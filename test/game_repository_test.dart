import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:optilife/core/enums.dart';
import 'package:optilife/data/database.dart';
import 'package:optilife/data/game_repository.dart';

void main() {
  late AppDatabase db;
  late GameRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = GameRepository(db);
  });

  tearDown(() => db.close());

  Future<String> addQuest(QuestCategory cat) async {
    final row = await db.into(db.quests).insertReturning(QuestsCompanion.insert(
        title: 'q-${cat.name}-${DateTime.now().microsecondsSinceEpoch}',
        category: cat,
        source: QuestSource.user));
    return row.id;
  }

  Future<String> addHabit(HabitType type) async {
    final row = await db.into(db.habits).insertReturning(HabitsCompanion.insert(
        title: 'h-${DateTime.now().microsecondsSinceEpoch}', type: type));
    return row.id;
  }

  Future<int> le() async => (await db.watchAppState().first).lifetimeLe;
  Future<int> treeCount() async => (await db.select(db.trees).get()).length;

  test('5 quest marks cross to level 2, await placement, plant a fitness tree',
      () async {
    // 5 distinct fitness quests (the daily roll gates one completion each).
    final quests = [for (var i = 0; i < 5; i++) await addQuest(QuestCategory.fitness)];

    for (var i = 0; i < 4; i++) {
      expect(await repo.markQuestComplete(quests[i]), ActionOutcome.applied);
    }
    expect(await le(), 40);

    expect(await repo.markQuestComplete(quests[4]),
        ActionOutcome.leveledUpAwaitingPlacement);
    final app = await db.watchAppState().first;
    expect(app.lifetimeLe, 50);
    expect(app.pendingTreeCategory, QuestCategory.fitness);

    // Hard lock: further actions blocked until placement.
    expect(await repo.markQuestComplete(quests[0]), ActionOutcome.blocked);

    expect(await repo.placeTree(10, 20), PlaceOutcome.placed);
    expect(await treeCount(), 1); // invariant: trees == level - 1
    final tree = (await db.select(db.trees).get()).single;
    expect(tree.category, QuestCategory.fitness);
    expect(tree.levelAtPlanting, 2);
    expect((await db.watchAppState().first).pendingTreeCategory, isNull);
  });

  test('unmark crossing the boundary downward removes the newest tree',
      () async {
    final quests = [for (var i = 0; i < 5; i++) await addQuest(QuestCategory.creative)];
    for (final q in quests) {
      await repo.markQuestComplete(q);
    }
    await repo.placeTree(0, 0);
    expect(await treeCount(), 1);

    expect(await repo.unmarkQuest(quests[0]), ActionOutcome.leveledDown);
    expect(await le(), 40);
    expect(await treeCount(), 0);
  });

  test('habit-only level-up (no quests in window) plants a Normal tree',
      () async {
    // 25 good-habit logs × 2 = 50 LE, with zero quest completions.
    final habits = [for (var i = 0; i < 25; i++) await addHabit(HabitType.good)];
    ActionOutcome? last;
    for (final h in habits) {
      last = await repo.toggleHabit(h);
    }
    expect(await le(), 50);
    expect(last, ActionOutcome.leveledUpAwaitingPlacement);
    expect((await db.watchAppState().first).pendingTreeCategory,
        QuestCategory.normal);
  });

  test('toggle habit is symmetric (log +2, unlog -2)', () async {
    final h = await addHabit(HabitType.bad);
    expect(await repo.toggleHabit(h), ActionOutcome.applied);
    expect(await le(), 2);
    final log = (await db.select(db.habitLogs).get()).single;
    expect(log.status, HabitLogStatus.avoided); // bad habit → avoided
    expect(await repo.toggleHabit(h), ActionOutcome.applied);
    expect(await le(), 0);
    expect((await db.select(db.habitLogs).get()).isEmpty, isTrue);
  });

  test('reroll: notEnoughLe → success → alreadyUsedToday', () async {
    await repo.ensureRollForToday();
    expect((await db.select(db.dailyQuestRolls).get()).length, 3);

    expect(await repo.reroll(), RerollOutcome.notEnoughLe);

    for (var i = 0; i < 5; i++) {
      await repo.toggleHabit(await addHabit(HabitType.good)); // +10 LE, no completion
    }
    expect(await le(), 10);
    expect(await repo.reroll(), RerollOutcome.success);
    expect(await le(), 0); // 10 LE cost deducted
    expect((await db.select(db.dailyQuestRolls).get()).length, 3); // fresh roll

    expect(await repo.reroll(), RerollOutcome.alreadyUsedToday); // 1/day
  });

  test('reroll blocked when a completion exists today', () async {
    for (var i = 0; i < 5; i++) {
      await repo.toggleHabit(await addHabit(HabitType.good)); // 10 LE
    }
    await repo.markQuestComplete(await addQuest(QuestCategory.social));
    expect(await repo.reroll(), RerollOutcome.completionExists);
  });

  test('biome reboot resets LE & trees, bumps world, keeps history', () async {
    final quests = [for (var i = 0; i < 5; i++) await addQuest(QuestCategory.night)];
    for (final q in quests) {
      await repo.markQuestComplete(q);
    }
    await repo.placeTree(1, 1);
    expect(await treeCount(), 1);

    await repo.rebootBiome();
    final app = await db.watchAppState().first;
    expect(app.lifetimeLe, 0);
    expect(app.biomesCompleted, 1);
    expect(await treeCount(), 0);
    // History preserved.
    expect((await db.select(db.questCompletions).get()).length, 5);
  });
}
