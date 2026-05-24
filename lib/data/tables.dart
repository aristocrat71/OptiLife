import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../core/enums.dart';

/// Drift table definitions — 1:1 with `tech-docs/Optilife Data Models.md §4`.
/// Conventions (§2): UUID text PKs, every row carries createdAt/lastModified,
/// enums stored as TEXT, single-row tables for global state.

const _uuid = Uuid();
String newId() => _uuid.v4();

// ── 4.1 app_state (single row) ──
@DataClassName('AppStateRow')
class AppState extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  IntColumn get lifetimeLe => integer().withDefault(const Constant(0))();
  DateTimeColumn get currentBiomeStartedAt =>
      dateTime().clientDefault(DateTime.now)();
  IntColumn get biomesCompleted => integer().withDefault(const Constant(0))();
  TextColumn get pendingTreeCategory =>
      textEnum<QuestCategory>().nullable()();
  DateTimeColumn get lastRerollDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get lastModified => dateTime().clientDefault(DateTime.now)();

  @override
  Set<Column> get primaryKey => {id};
}

// ── 4.2 settings (single row) ──
@DataClassName('SettingsRow')
class Settings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  BoolColumn get liquidFillEnabled =>
      boolean().withDefault(const Constant(true))();
  TextColumn get journalFont => textEnum<JournalFont>()
      .withDefault(Constant(JournalFont.handwriting.name))();
  TextColumn get journalAlignment => textEnum<JournalAlignment>()
      .withDefault(Constant(JournalAlignment.left.name))();
  IntColumn get questsPerDay => integer().withDefault(const Constant(3))();
  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(false))();
  // Reminder times as minutes-since-midnight. Morning = quests nudge (09:00),
  // evening = journal nudge (20:00).
  IntColumn get morningReminderMin =>
      integer().withDefault(const Constant(9 * 60))();
  IntColumn get eveningReminderMin =>
      integer().withDefault(const Constant(20 * 60))();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get lastModified => dateTime().clientDefault(DateTime.now)();

  @override
  Set<Column> get primaryKey => {id};
}

// ── 4.3 quests ──
@DataClassName('Quest')
@TableIndex(name: 'idx_quests_category_active', columns: {#category, #isActive})
@TableIndex(name: 'idx_quests_source', columns: {#source})
class Quests extends Table {
  TextColumn get id => text().clientDefault(newId)();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  TextColumn get category => textEnum<QuestCategory>()();
  TextColumn get source => textEnum<QuestSource>()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get lastModified => dateTime().clientDefault(DateTime.now)();

  @override
  Set<Column> get primaryKey => {id};
}

// ── 4.4 quest_completions (append-only) ──
@DataClassName('QuestCompletion')
@TableIndex(name: 'idx_completions_date', columns: {#date})
@TableIndex(name: 'idx_completions_quest', columns: {#questId})
@TableIndex(name: 'idx_completions_completed_at', columns: {#completedAt})
class QuestCompletions extends Table {
  TextColumn get id => text().clientDefault(newId)();
  TextColumn get questId => text().references(Quests, #id)();
  DateTimeColumn get completedAt => dateTime()();
  DateTimeColumn get date => dateTime()();
  IntColumn get leAwarded => integer().withDefault(const Constant(10))();
  TextColumn get categoryAtCompletion => textEnum<QuestCategory>()();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get lastModified => dateTime().clientDefault(DateTime.now)();

  @override
  Set<Column> get primaryKey => {id};
}

// ── 4.5 daily_quest_rolls ──
@DataClassName('DailyQuestRoll')
@TableIndex(name: 'idx_rolls_date', columns: {#date})
@TableIndex(name: 'idx_rolls_quest_date', columns: {#questId, #date}, unique: true)
class DailyQuestRolls extends Table {
  TextColumn get id => text().clientDefault(newId)();
  TextColumn get questId => text().references(Quests, #id)();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get rolledAt => dateTime()();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get lastModified => dateTime().clientDefault(DateTime.now)();

  @override
  Set<Column> get primaryKey => {id};
}

// ── 4.6 habits ──
@DataClassName('Habit')
@TableIndex(name: 'idx_habits_active', columns: {#isActive})
class Habits extends Table {
  TextColumn get id => text().clientDefault(newId)();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  TextColumn get type => textEnum<HabitType>()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get lastModified => dateTime().clientDefault(DateTime.now)();

  @override
  Set<Column> get primaryKey => {id};
}

// ── 4.7 habit_logs ──
@DataClassName('HabitLog')
@TableIndex(name: 'idx_habit_logs_date', columns: {#date})
@TableIndex(name: 'idx_habit_logs_habit_date', columns: {#habitId, #date})
class HabitLogs extends Table {
  TextColumn get id => text().clientDefault(newId)();
  TextColumn get habitId => text().references(Habits, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get status => textEnum<HabitLogStatus>()();
  IntColumn get leAwarded => integer().withDefault(const Constant(2))();
  DateTimeColumn get loggedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get lastModified => dateTime().clientDefault(DateTime.now)();

  @override
  Set<Column> get primaryKey => {id};
}

// ── 4.8 tasks ──
@DataClassName('TaskRow')
@TableIndex(name: 'idx_tasks_due_date', columns: {#dueDate})
@TableIndex(name: 'idx_tasks_completed_at', columns: {#completedAt})
class Tasks extends Table {
  TextColumn get id => text().clientDefault(newId)();
  TextColumn get title => text().withLength(min: 1, max: 300)();
  TextColumn get description => text().nullable()();
  DateTimeColumn get dueDate => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get lastModified => dateTime().clientDefault(DateTime.now)();

  @override
  Set<Column> get primaryKey => {id};
}

// ── 4.9 journal_entries (one per day) ──
@DataClassName('JournalEntry')
class JournalEntries extends Table {
  TextColumn get id => text().clientDefault(newId)();
  DateTimeColumn get date => dateTime().unique()();
  TextColumn get body => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get lastModified => dateTime().clientDefault(DateTime.now)();

  @override
  Set<Column> get primaryKey => {id};
}

// ── 4.10 trees (current biome) ──
@DataClassName('TreeRow')
@TableIndex(name: 'idx_trees_planted_at', columns: {#plantedAt})
@TableIndex(name: 'idx_trees_category', columns: {#category})
class Trees extends Table {
  TextColumn get id => text().clientDefault(newId)();
  TextColumn get category => textEnum<QuestCategory>()();
  DateTimeColumn get plantedAt => dateTime()();
  IntColumn get levelAtPlanting => integer()();
  RealColumn get positionX => real()();
  RealColumn get positionY => real()();
  DateTimeColumn get createdAt => dateTime().clientDefault(DateTime.now)();
  DateTimeColumn get lastModified => dateTime().clientDefault(DateTime.now)();

  @override
  Set<Column> get primaryKey => {id};
}
