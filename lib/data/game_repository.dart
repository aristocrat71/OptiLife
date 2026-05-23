import 'dart:math';

import 'package:drift/drift.dart';

import '../core/date_utils.dart';
import '../core/enums.dart';
import '../core/le_math.dart';
import '../core/limits.dart';
import 'database.dart';

/// Result of a mark/log mutation.
enum ActionOutcome {
  /// Change applied; no level boundary crossed.
  applied,

  /// Crossed a level boundary upward. `pendingTreeCategory` is now set —
  /// the UI must enter tree-placement mode (Design Doc §6.7).
  leveledUpAwaitingPlacement,

  /// Crossed a level boundary downward; the newest tree was removed.
  leveledDown,

  /// Placement lock is active — nothing happened (Data Models §7.1 step 1).
  blocked,

  /// Tried to uncheck while LE is already 0 (e.g. after a reboot, where the
  /// completion/log row survives but LE was reset). Nothing happened.
  blockedNoEnergy,
}

enum PlaceOutcome { placed, placedBiomeFull, noPending }

enum RerollOutcome {
  success,
  alreadyUsedToday,
  completionExists,
  notEnoughLe,
  blocked,
}

/// All gameplay writes that must uphold the core invariants
/// (Data Models §7). Every level-affecting op runs in a transaction and keeps
/// `trees.count == currentLevel - 1` outside placement mode.
class GameRepository {
  GameRepository(this._db);
  final AppDatabase _db;

  // ── §7.1 mark a side quest complete ──
  Future<ActionOutcome> markQuestComplete(String questId) {
    return _db.transaction(() async {
      final app = await _appState();
      if (app.pendingTreeCategory != null) return ActionOutcome.blocked;
      // Full biome must be rebooted before more LE can be earned (§4.3).
      if (await _treeCount() >= kBiomeCapacity) return ActionOutcome.blocked;

      final quest = await (_db.select(_db.quests)
            ..where((t) => t.id.equals(questId)))
          .getSingle();
      final today = dateOnly(DateTime.now());

      await _db.into(_db.questCompletions).insert(QuestCompletionsCompanion.insert(
            questId: questId,
            completedAt: DateTime.now(),
            date: today,
            categoryAtCompletion: quest.category,
          ));
      return _applyLeDelta(app.lifetimeLe, 10);
    });
  }

  // ── §7.2 unmark a side quest (today only) ──
  Future<ActionOutcome> unmarkQuest(String questId) {
    return _db.transaction(() async {
      final app = await _appState();
      if (app.pendingTreeCategory != null) return ActionOutcome.blocked;

      final today = dateOnly(DateTime.now());
      // A quest is rolled once/day, so there is normally ≤1 completion; if
      // several exist, drop the most recent one.
      final completion = await (_db.select(_db.questCompletions)
            ..where((t) => t.questId.equals(questId) & t.date.equals(today))
            ..orderBy([(t) => OrderingTerm.desc(t.completedAt)])
            ..limit(1))
          .getSingleOrNull();
      if (completion == null) return ActionOutcome.applied;
      // LE can't go below 0, so unchecking with none banked is a no-op — block
      // it and tell the user (Data Models §7.6: reboot keeps the row, zeroes LE).
      if (app.lifetimeLe == 0) return ActionOutcome.blockedNoEnergy;

      await (_db.delete(_db.questCompletions)
            ..where((t) => t.id.equals(completion.id)))
          .go();
      return _applyLeDelta(app.lifetimeLe, -completion.leAwarded);
    });
  }

  // ── §7.3 / §7.4 toggle a habit (single binary toggle — no slip) ──
  Future<ActionOutcome> toggleHabit(String habitId) {
    return _db.transaction(() async {
      final app = await _appState();
      if (app.pendingTreeCategory != null) return ActionOutcome.blocked;

      final today = dateOnly(DateTime.now());
      final existing = await (_db.select(_db.habitLogs)
            ..where((t) => t.habitId.equals(habitId) & t.date.equals(today)))
          .getSingleOrNull();

      // Block logging (LE gain) on a full biome, but allow un-logging so the
      // user can still undo. Only the gain path can push past the cap.
      if (existing == null && await _treeCount() >= kBiomeCapacity) {
        return ActionOutcome.blocked;
      }

      if (existing != null) {
        // unlog — but not below 0 LE (see unmarkQuest note).
        if (app.lifetimeLe == 0) return ActionOutcome.blockedNoEnergy;
        await (_db.delete(_db.habitLogs)..where((t) => t.id.equals(existing.id)))
            .go();
        return _applyLeDelta(app.lifetimeLe, -existing.leAwarded);
      }

      final habit = await (_db.select(_db.habits)
            ..where((t) => t.id.equals(habitId)))
          .getSingle();
      final status = habit.type == HabitType.good
          ? HabitLogStatus.done
          : HabitLogStatus.avoided;
      await _db.into(_db.habitLogs).insert(HabitLogsCompanion.insert(
            habitId: habitId,
            date: today,
            status: status,
            loggedAt: DateTime.now(),
          )); // leAwarded defaults to 2
      return _applyLeDelta(app.lifetimeLe, 2);
    });
  }

  // ── §7.1.d / §7.5 place the pending tree ──
  Future<PlaceOutcome> placeTree(double x, double y) {
    return _db.transaction(() async {
      final app = await _appState();
      final cat = app.pendingTreeCategory;
      if (cat == null) return PlaceOutcome.noPending;

      await _db.into(_db.trees).insert(TreesCompanion.insert(
            category: cat,
            plantedAt: DateTime.now(),
            levelAtPlanting: currentLevel(app.lifetimeLe),
            positionX: x,
            positionY: y,
          ));
      await _patchApp(const AppStateCompanion(
          pendingTreeCategory: Value(null)));

      final count = await _treeCount();
      return count >= kBiomeCapacity
          ? PlaceOutcome.placedBiomeFull
          : PlaceOutcome.placed;
    });
  }

  // ── §7.6 biome reboot (full reset; history preserved) ──
  Future<void> rebootBiome() {
    return _db.transaction(() async {
      final app = await _appState();
      await _db.delete(_db.trees).go();
      await _patchApp(AppStateCompanion(
        lifetimeLe: const Value(0),
        biomesCompleted: Value(app.biomesCompleted + 1),
        currentBiomeStartedAt: Value(DateTime.now()),
        pendingTreeCategory: const Value(null),
      ));
    });
  }

  // ── §7.7 daily reroll ──
  Future<RerollOutcome> reroll() {
    return _db.transaction(() async {
      final app = await _appState();
      if (app.pendingTreeCategory != null) return RerollOutcome.blocked;

      final today = dateOnly(DateTime.now());
      if (app.lastRerollDate != null && sameDay(app.lastRerollDate!, today)) {
        return RerollOutcome.alreadyUsedToday;
      }
      final completionsToday = await (_db.select(_db.questCompletions)
            ..where((t) => t.date.equals(today)))
          .get();
      if (completionsToday.isNotEmpty) return RerollOutcome.completionExists;
      if (leIntoLevel(app.lifetimeLe) < 10) return RerollOutcome.notEnoughLe;

      await _patchApp(AppStateCompanion(
        lifetimeLe: Value(app.lifetimeLe - 10),
        lastRerollDate: Value(today),
      ));
      await (_db.delete(_db.dailyQuestRolls)..where((t) => t.date.equals(today)))
          .go();
      await _generateRoll(today);
      return RerollOutcome.success;
    });
  }

  // ── §4.5 lazy daily roll (call on SQ view / app open) ──
  Future<void> ensureRollForToday() async {
    final today = dateOnly(DateTime.now());
    final existing = await (_db.select(_db.dailyQuestRolls)
          ..where((t) => t.date.equals(today)))
        .get();
    if (existing.isEmpty) await _generateRoll(today);
  }

  // ── helpers ──

  Future<AppStateRow> _appState() =>
      (_db.select(_db.appState)..where((t) => t.id.equals(1))).getSingle();

  Future<void> _patchApp(AppStateCompanion patch) =>
      (_db.update(_db.appState)..where((t) => t.id.equals(1)))
          .write(patch.copyWith(lastModified: Value(DateTime.now())));

  Future<int> _treeCount() async =>
      (await _db.select(_db.trees).get()).length;

  /// Applies an LE delta, updates the level, and plants/removes a tree on a
  /// crossed boundary. Must run inside a transaction. `oldLe` is the value
  /// read at the start of the same transaction.
  Future<ActionOutcome> _applyLeDelta(int oldLe, int delta) async {
    final oldLevel = currentLevel(oldLe);
    final newLe = max(0, oldLe + delta);
    final newLevel = currentLevel(newLe);

    if (newLevel > oldLevel) {
      final cat = await _determineTreeCategory();
      await _patchApp(AppStateCompanion(
        lifetimeLe: Value(newLe),
        pendingTreeCategory: Value(cat),
      ));
      return ActionOutcome.leveledUpAwaitingPlacement;
    }

    if (newLevel < oldLevel) {
      await _patchApp(AppStateCompanion(lifetimeLe: Value(newLe)));
      await _removeNewestTree();
      return ActionOutcome.leveledDown;
    }

    await _patchApp(AppStateCompanion(lifetimeLe: Value(newLe)));
    return ActionOutcome.applied;
  }

  Future<void> _removeNewestTree() async {
    final newest = await (_db.select(_db.trees)
          ..orderBy([(t) => OrderingTerm.desc(t.plantedAt)])
          ..limit(1))
        .getSingleOrNull();
    if (newest != null) {
      await (_db.delete(_db.trees)..where((t) => t.id.equals(newest.id))).go();
    }
  }

  /// §7.8 — tally completions since the last tree was planted; empty window
  /// (habit-driven level-up) → Normal tree.
  Future<QuestCategory> _determineTreeCategory() async {
    final latest = await (_db.select(_db.trees)
          ..orderBy([(t) => OrderingTerm.desc(t.plantedAt)])
          ..limit(1))
        .getSingleOrNull();
    final since =
        latest?.plantedAt ?? DateTime.fromMillisecondsSinceEpoch(0);

    final comps = await (_db.select(_db.questCompletions)
          ..where((t) => t.completedAt.isBiggerThanValue(since))
          ..orderBy([(t) => OrderingTerm.asc(t.completedAt)]))
        .get();
    if (comps.isEmpty) return QuestCategory.normal;

    final counts = <QuestCategory, int>{};
    for (final c in comps) {
      counts.update(c.categoryAtCompletion, (v) => v + 1, ifAbsent: () => 1);
    }
    final maxCount = counts.values.reduce(max);
    final winners = counts.entries
        .where((e) => e.value == maxCount)
        .map((e) => e.key)
        .toSet();
    if (winners.length == 1) return winners.first;

    // tiebreak: most recent completion among the tied categories
    for (final c in comps.reversed) {
      if (winners.contains(c.categoryAtCompletion)) {
        return c.categoryAtCompletion;
      }
    }
    return QuestCategory.normal; // unreachable
  }

  Future<void> _generateRoll(DateTime day) async {
    final settings = await (_db.select(_db.settings)
          ..where((t) => t.id.equals(1)))
        .getSingle();
    final pool =
        await (_db.select(_db.quests)..where((t) => t.isActive.equals(true)))
            .get();
    pool.shuffle();
    final n = min(settings.questsPerDay, pool.length);
    final picks = pool.take(n);
    await _db.batch((b) {
      b.insertAll(
        _db.dailyQuestRolls,
        picks.map((q) => DailyQuestRollsCompanion.insert(
              questId: q.id,
              date: day,
              rolledAt: DateTime.now(),
            )),
      );
    });
  }
}
