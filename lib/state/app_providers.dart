import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart'; // StateProvider (Riverpod 3)

import '../core/date_utils.dart';
import '../core/enums.dart';
import '../data/database.dart';
import '../data/game_repository.dart';

export '../core/date_utils.dart' show dateOnly, sameDay;
export '../core/le_math.dart' show currentLevel, leIntoLevel, leUntilNext;

/// Riverpod state surface (`ui-design-docs/07-ia-navigation-state.md §2`).
/// The selected date is the spine; app_state & settings stream from Drift;
/// per-screen data providers are date-scoped off `selectedDateProvider`.

// ── database ──
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

// ── date spine ── (helpers in core/date_utils.dart)
/// Single source of truth for the active day. Horizontal swipes never change
/// it; vertical scroll / the date picker do.
final selectedDateProvider =
    StateProvider<DateTime>((ref) => dateOnly(DateTime.now()));

final isTodayProvider = Provider<bool>(
    (ref) => sameDay(ref.watch(selectedDateProvider), DateTime.now()));
final isPastProvider = Provider<bool>(
    (ref) => ref.watch(selectedDateProvider).isBefore(dateOnly(DateTime.now())));
final isFutureProvider = Provider<bool>(
    (ref) => ref.watch(selectedDateProvider).isAfter(dateOnly(DateTime.now())));

// ── app state ── (derived level math in core/le_math.dart, re-exported above)
final appStateProvider = StreamProvider<AppStateRow>(
    (ref) => ref.watch(databaseProvider).watchAppState());

/// True while a level-up is awaiting tree placement — the global hard lock
/// (Design Doc §6.7). UI must block everything except the biome canvas.
final isPlacingTreeProvider = Provider<bool>((ref) =>
    ref.watch(appStateProvider).asData?.value.pendingTreeCategory != null);

// ── settings ──
final settingsProvider = StreamProvider<SettingsRow>(
    (ref) => ref.watch(databaseProvider).watchSettings());

// ── per-screen data (date-scoped) ──
final activeHabitsProvider = StreamProvider<List<Habit>>(
    (ref) => ref.watch(databaseProvider).watchActiveHabits());

final tasksForSelectedDateProvider = StreamProvider<List<TaskRow>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchTasksForDate(ref.watch(selectedDateProvider));
});

final journalForSelectedDateProvider = StreamProvider<JournalEntry?>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchJournalForDate(ref.watch(selectedDateProvider));
});

final habitLogsForSelectedDateProvider = StreamProvider<List<HabitLog>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchHabitLogsForDate(ref.watch(selectedDateProvider));
});

final rollForSelectedDateProvider = StreamProvider<List<DailyQuestRoll>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchRollForDate(ref.watch(selectedDateProvider));
});

/// Today's rolled quests with completion status — what the SQ screen renders.
final rolledQuestsForSelectedDateProvider =
    StreamProvider<List<RolledQuest>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchRolledQuests(ref.watch(selectedDateProvider));
});

/// The current biome's trees (date-agnostic).
final treesProvider = StreamProvider<List<TreeRow>>(
    (ref) => ref.watch(databaseProvider).watchTrees());

// ── Workshop quest browsing (filtering happens in SQL — see
//    AppDatabase.watchWorkshopQuests) ──
/// Live search term for the Workshop Quests tab.
final questSearchProvider = StateProvider<String>((ref) => '');

/// Active category filter (null = all categories).
final questCategoryFilterProvider =
    StateProvider<QuestCategory?>((ref) => null);

/// Active source filter — preset / user (null = both).
final questSourceFilterProvider = StateProvider<QuestSource?>((ref) => null);

/// The Workshop quest list, re-queried whenever the search or filters change.
final workshopQuestsProvider = StreamProvider<List<Quest>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchWorkshopQuests(
    search: ref.watch(questSearchProvider),
    category: ref.watch(questCategoryFilterProvider),
    source: ref.watch(questSourceFilterProvider),
  );
});

// ── gameplay write layer (Data Models §7) ──
final gameRepositoryProvider = Provider<GameRepository>(
    (ref) => GameRepository(ref.watch(databaseProvider)));
