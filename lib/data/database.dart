import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../core/date_utils.dart';
import '../core/enums.dart'; // enum types referenced by the generated part
import 'seed_quests.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  AppState,
  Settings,
  Quests,
  QuestCompletions,
  DailyQuestRolls,
  Habits,
  HabitLogs,
  Tasks,
  JournalEntries,
  Trees,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _open());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seed();
        },
        onUpgrade: (m, from, to) async {
          if (from < 3) {
            // Reset quests/day to the default 3 and clear today's cached roll
            // so it re-rolls with the right count. (Bridges the temporary
            // 6-quest experiment; safe to squash before release.)
            await (update(settings)..where((t) => t.id.equals(1)))
                .write(const SettingsCompanion(questsPerDay: Value(3)));
            final today = dateOnly(DateTime.now());
            await (delete(dailyQuestRolls)..where((t) => t.date.equals(today)))
                .go();
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// First-launch seeding (Data Models §9): singleton rows + preset quests.
  Future<void> _seed() async {
    await into(appState).insert(const AppStateCompanion(id: Value(1)));
    await into(settings).insert(const SettingsCompanion(id: Value(1)));
    await batch((b) {
      b.insertAll(
        quests,
        presetQuests.map((q) => QuestsCompanion.insert(
              title: q.title,
              description: Value(q.description),
              category: q.category,
              source: QuestSource.preset,
            )),
      );
    });
  }

  // ── reactive reads (used by Riverpod providers) ──
  Stream<AppStateRow> watchAppState() =>
      (select(appState)..where((t) => t.id.equals(1))).watchSingle();

  Stream<SettingsRow> watchSettings() =>
      (select(settings)..where((t) => t.id.equals(1))).watchSingle();

  Stream<List<Habit>> watchActiveHabits() =>
      (select(habits)..where((t) => t.isActive.equals(true))).watch();

  Stream<List<TaskRow>> watchTasksForDate(DateTime day) => (select(tasks)
        ..where((t) => t.dueDate.equals(day))
        ..orderBy([(t) => OrderingTerm(expression: t.completedAt)]))
      .watch();

  Stream<JournalEntry?> watchJournalForDate(DateTime day) =>
      (select(journalEntries)..where((t) => t.date.equals(day)))
          .watchSingleOrNull();

  Stream<List<HabitLog>> watchHabitLogsForDate(DateTime day) =>
      (select(habitLogs)..where((t) => t.date.equals(day))).watch();

  Stream<List<DailyQuestRoll>> watchRollForDate(DateTime day) =>
      (select(dailyQuestRolls)..where((t) => t.date.equals(day))).watch();

  /// Today's rolled quests joined with their completion status (Data Models §8).
  Stream<List<RolledQuest>> watchRolledQuests(DateTime day) {
    final query = select(dailyQuestRolls).join([
      innerJoin(quests, quests.id.equalsExp(dailyQuestRolls.questId)),
      leftOuterJoin(
        questCompletions,
        questCompletions.questId.equalsExp(dailyQuestRolls.questId) &
            questCompletions.date.equals(day),
      ),
    ])
      ..where(dailyQuestRolls.date.equals(day));
    return query.watch().map((rows) => rows
        .map((r) => RolledQuest(
              quest: r.readTable(quests),
              done: r.readTableOrNull(questCompletions) != null,
            ))
        .toList());
  }

  Stream<List<TreeRow>> watchTrees() => (select(trees)
        ..orderBy([(t) => OrderingTerm(expression: t.plantedAt)]))
      .watch();

  /// Workshop quest list, **filtered in SQL** (not client-side): optional title/
  /// description search + optional category. Shows all presets (active or not,
  /// so they can be toggled back on) plus active user quests; deleted user
  /// quests (`isActive=false`) drop out. Active rows sort first, then by title.
  Stream<List<Quest>> watchWorkshopQuests({
    String search = '',
    QuestCategory? category,
    QuestSource? source,
  }) {
    final query = select(quests)
      ..where((t) =>
          t.source.equalsValue(QuestSource.preset) | t.isActive.equals(true));
    if (category != null) {
      query.where((t) => t.category.equalsValue(category));
    }
    if (source != null) {
      query.where((t) => t.source.equalsValue(source));
    }
    final term = search.trim();
    if (term.isNotEmpty) {
      final like = '%$term%';
      query.where((t) => t.title.like(like) | t.description.like(like));
    }
    query.orderBy([
      (t) => OrderingTerm(expression: t.isActive, mode: OrderingMode.desc),
      (t) => OrderingTerm(expression: t.title),
    ]);
    return query.watch();
  }

  // ── task writes (no LE — Data Models §4.8) ──
  Future<void> addTask(String title, String? description, DateTime dueDate) =>
      into(tasks).insert(TasksCompanion.insert(
        title: title,
        description: Value(description),
        dueDate: dateOnly(dueDate),
      ));

  Future<void> updateTask(
          String id, String title, String? description, DateTime dueDate) =>
      (update(tasks)..where((t) => t.id.equals(id))).write(TasksCompanion(
        title: Value(title),
        description: Value(description),
        dueDate: Value(dateOnly(dueDate)),
        lastModified: Value(DateTime.now()),
      ));

  Future<void> setTaskComplete(String id, bool done) =>
      (update(tasks)..where((t) => t.id.equals(id))).write(TasksCompanion(
        completedAt: Value(done ? DateTime.now() : null),
        lastModified: Value(DateTime.now()),
      ));

  Future<void> deleteTask(String id) =>
      (delete(tasks)..where((t) => t.id.equals(id))).go();

  // ── journal writes (one entry per day; `date` is UNIQUE — Data Models §4.9) ──
  /// Upserts the entry for [day]. Called debounced from the journal editor.
  Future<void> upsertJournal(DateTime day, String body) async {
    final date = dateOnly(day);
    await into(journalEntries).insert(
      JournalEntriesCompanion.insert(
        date: date,
        body: Value(body),
      ),
      onConflict: DoUpdate(
        (_) => JournalEntriesCompanion(
          body: Value(body),
          lastModified: Value(DateTime.now()),
        ),
        target: [journalEntries.date],
      ),
    );
  }

  // ── habit writes (CRUD for the Workshop; logging lives in GameRepository) ──
  Future<void> addHabit(String title, String? description, HabitType type) =>
      into(habits).insert(HabitsCompanion.insert(
        title: title,
        description: Value(description),
        type: type,
      ));

  Future<void> updateHabit(
          String id, String title, String? description, HabitType type) =>
      (update(habits)..where((t) => t.id.equals(id))).write(HabitsCompanion(
        title: Value(title),
        description: Value(description),
        type: Value(type),
        lastModified: Value(DateTime.now()),
      ));

  /// Soft-delete (Data Models §6): keep history (logs/trees), just deactivate.
  Future<void> softDeleteHabit(String id) =>
      (update(habits)..where((t) => t.id.equals(id))).write(HabitsCompanion(
        isActive: const Value(false),
        lastModified: Value(DateTime.now()),
      ));

  // ── settings writes (write-through, immediate — Data Models §4.2) ──
  Future<void> setLiquidFillEnabled(bool v) => _patchSettings(
      SettingsCompanion(liquidFillEnabled: Value(v)));

  Future<void> setJournalFont(JournalFont f) =>
      _patchSettings(SettingsCompanion(journalFont: Value(f)));

  Future<void> setJournalAlignment(JournalAlignment a) =>
      _patchSettings(SettingsCompanion(journalAlignment: Value(a)));

  Future<void> setQuestsPerDay(int n) => _patchSettings(
      SettingsCompanion(questsPerDay: Value(n.clamp(1, 9))));

  Future<void> setNotificationsEnabled(bool v) => _patchSettings(
      SettingsCompanion(notificationsEnabled: Value(v)));

  Future<void> _patchSettings(SettingsCompanion patch) =>
      (update(settings)..where((t) => t.id.equals(1)))
          .write(patch.copyWith(lastModified: Value(DateTime.now())));

  // ── quest writes (Workshop CRUD; presets toggle, user quests full CRUD) ──
  Future<void> addQuest(
          String title, String? description, QuestCategory category) =>
      into(quests).insert(QuestsCompanion.insert(
        title: title,
        description: Value(description),
        category: category,
        source: QuestSource.user,
      ));

  Future<void> updateQuest(
          String id, String title, String? description, QuestCategory category) =>
      (update(quests)..where((t) => t.id.equals(id))).write(QuestsCompanion(
        title: Value(title),
        description: Value(description),
        category: Value(category),
        lastModified: Value(DateTime.now()),
      ));

  /// Toggle a quest in/out of the daily roll pool (presets) — Data Models §4.3.
  Future<void> setQuestActive(String id, bool active) =>
      (update(quests)..where((t) => t.id.equals(id))).write(QuestsCompanion(
        isActive: Value(active),
        lastModified: Value(DateTime.now()),
      ));

  /// Soft-delete a user quest (Data Models §6): keep completion history.
  Future<void> softDeleteQuest(String id) => setQuestActive(id, false);

  /// Copies the previous calendar day's tasks onto [targetDate] (fresh, not
  /// completed). Returns how many were copied.
  Future<int> copyTasksFromPreviousDay(DateTime targetDate) async {
    final to = dateOnly(targetDate);
    final from = dateOnly(to.subtract(const Duration(days: 1)));
    final prev =
        await (select(tasks)..where((t) => t.dueDate.equals(from))).get();
    if (prev.isEmpty) return 0;
    await batch((b) {
      b.insertAll(
        tasks,
        prev.map((t) => TasksCompanion.insert(
              title: t.title,
              description: Value(t.description),
              dueDate: to,
            )),
      );
    });
    return prev.length;
  }
}

/// A rolled quest plus whether it's been completed on the viewed day.
class RolledQuest {
  const RolledQuest({required this.quest, required this.done});
  final Quest quest;
  final bool done;
}

LazyDatabase _open() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'optilife.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
