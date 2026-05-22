import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
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
