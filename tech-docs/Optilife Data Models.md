# OptiLife — Data Model

**Status:** v0.5
**Companion to:** `OptiLife-Design-Doc.md`
**Last updated:** 21 May 2026

---

## 1. Overview

This document defines the complete on-device data schema for OptiLife, implemented with **Drift** over SQLite. It is the single source of truth for table structure, column semantics, indexes, and the relationships between entities. Every UI feature, animation, and gameplay mechanic in the design doc ultimately reads from or writes to one of the tables defined here.

The schema is designed to be:
- **Local-first** — no server dependency.
- **Sync-portable** — every table maps cleanly to Supabase Postgres if sync is ever bolted on, with no schema rewrite.
- **Migration-friendly** — Drift's migration system handles version bumps; the schema is structured to make future additions painless.

---

## 2. Design Principles

These rules apply uniformly across all tables. They are non-negotiable for v1.0 — bend them later only with deliberate reason.

**1. UUIDs as primary keys (not auto-increment integers).**
Every row's PK is a `TEXT` UUIDv4 generated in Dart (via the `uuid` package). Auto-increment integers don't survive sync: two devices would generate colliding IDs. UUIDs are unique by birth, so a future sync layer just merges rows.

**2. Every row carries `created_at` and `last_modified`.**
`created_at` is set on insert and never changes. `last_modified` is set on insert and updated on every change. This pair is sufficient for last-write-wins sync resolution later. Both are stored as `DateTime` (Drift's `dateTime()` column, which maps to ISO8601 strings in SQLite).

**3. Enums are stored as `TEXT`, not `INTEGER`.**
Drift's `textEnum<E>()` serializes Dart enums to their name. This costs ~10 bytes per row but is readable in raw SQL queries, survives reordering of enum cases in Dart code, and ports cleanly to Postgres' native enum type.

**4. Single-row tables for global state.**
`app_state` and `settings` are single-row tables. Enforced by application code (we only ever insert one row, then update it). Drift doesn't enforce single-row constraints at the schema level, so the data access layer must.

**5. Date vs. DateTime — both are first-class.**
For things tied to a specific day (journal entries, habit logs, the date filter), we store both a `date` column (truncated to the day) and a `completed_at` / `logged_at` `DateTime` for exact time. Denormalization is intentional — querying by day is the most common operation and indexed dates are far faster than computing `DATE(timestamp)` on the fly.

**6. Soft-delete via `is_active` where deletion would lose history.**
Quests and habits use `is_active = false` rather than physical deletion, because their completion/log rows reference them and we want history to survive. Tasks and journal entries can be hard-deleted (no downstream references).

**7. No cascade deletes.**
Drift supports SQLite foreign keys but cascades are off by default. The application layer handles cleanup explicitly — clearer, easier to test, avoids surprise data loss.

---

## 3. Schema at a Glance

```
┌──────────────┐      ┌──────────────┐
│  app_state   │      │   settings   │       (single-row each)
└──────────────┘      └──────────────┘

┌──────────────┐                ┌────────────────────┐
│              │ ──────────────<│ quest_completions  │
│    quests    │                └────────────────────┘
│              │                ┌────────────────────┐
│              │ ──────────────<│ daily_quest_rolls  │
└──────────────┘                └────────────────────┘

┌──────────────┐                ┌────────────────────┐
│    habits    │ ──────────────<│    habit_logs      │
└──────────────┘                └────────────────────┘

┌──────────────┐    ┌──────────────────┐    ┌──────────────┐
│    tasks     │    │ journal_entries  │    │    trees     │
└──────────────┘    └──────────────────┘    └──────────────┘
   (independent)       (1 per date)            (current biome)
```

Ten tables. Three relations: `quests` → `quest_completions`, `quests` → `daily_quest_rolls`, and `habits` → `habit_logs`. Everything else is flat.

---

## 4. Tables

### 4.1 `app_state` (single row)

Holds gameplay-state values that change during normal use. Separated from `settings` because this data is sacred — accidentally resetting it would wipe progression.

```dart
class AppState extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  // Always 1. Enforced by app layer.

  IntColumn get lifetimeLe => integer().withDefault(const Constant(0))();
  // Total LE earned in the *current biome*. Resets to 0 on biome reboot.
  // Drives level computation.

  DateTimeColumn get currentBiomeStartedAt => dateTime()();
  // Set on first launch, reset on biome reboot.

  IntColumn get biomesCompleted => integer().withDefault(const Constant(0))();
  // Increments by 1 each reboot. Surfaced on the Biome screen as
  // "X worlds completed".

  TextColumn get pendingTreeCategory =>
      textEnum<QuestCategory>().nullable()();
  // Set when a level-up triggers tree planting. While non-null, the app
  // is in "tree placement mode" — the user must tap a spot in the biome
  // to plant the tree before the LE meter / further completions resume
  // normal flow. Cleared on successful placement.
  // Persisted (rather than held in memory) so a crash mid-placement
  // doesn't lose the pending tree.

  DateTimeColumn get lastRerollDate => dateTime().nullable()();
  // Date (truncated to day) of the most recent quest reroll. If equal
  // to today, the user has already used their daily reroll and cannot
  // reroll again until tomorrow. Null until first reroll ever.

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

**Derived values (not stored):**
- `currentLevel = (lifetimeLe ~/ 50) + 1`
- `leIntoCurrentLevel = lifetimeLe % 50`
- `leUntilNextLevel = 50 - leIntoCurrentLevel`

**Invariant:** Outside of placement mode (when `pendingTreeCategory` is null), `trees.count() == currentLevel - 1`. Every level-up plants a tree; every level-down removes one. The tree count and the level are locked together.

**Why derive instead of store?** Stored derived values get stale. The math is trivial — computing on read costs nothing and removes a class of bugs.

---

### 4.2 `settings` (single row)

User-controllable preferences. Safe to reset to defaults if the user ever wants a clean slate.

```dart
class Settings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();

  BoolColumn get liquidFillEnabled =>
      boolean().withDefault(const Constant(true))();
  // Toggle for the animated liquid-fill background.

  TextColumn get journalFont =>
      textEnum<JournalFont>()
          .withDefault(Constant(JournalFont.handwriting.name))();

  TextColumn get journalAlignment =>
      textEnum<JournalAlignment>()
          .withDefault(Constant(JournalAlignment.left.name))();

  IntColumn get questsPerDay => integer().withDefault(const Constant(3))();
  // How many side quests the roller assigns per day.
  // From the Excalidraw "X side quests per day (can be set in settings)".

  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(false))();
  // Wired up in final stage; default off until then.

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

---

### 4.3 `quests`

Master list of all side quests, both preset (shipped with the app) and user-created (added via Workshop).

```dart
class Quests extends Table {
  TextColumn get id => text()();
  // UUIDv4.

  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();

  TextColumn get category => textEnum<QuestCategory>()();
  // adventure | fitness | social | creative | night

  TextColumn get source => textEnum<QuestSource>()();
  // preset | user

  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();
  // Soft-delete. Inactive quests are hidden from the roller and lists,
  // but their completion history survives.

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

**Indexes:**
- `(category, is_active)` — the roller filters by both.
- `(source)` — used when Workshop lists user-created vs preset.

**Notes:**
- Preset quests are seeded on first launch from a bundled JSON. Their UUIDs are stable across installs (hardcoded in the seed file), so they map consistently.
- A user can deactivate a preset quest (don't show it again) — flip `isActive`, don't delete the row.

---

### 4.4 `quest_completions`

One row per completed side quest. Append-only — completing a quest never updates a row, only inserts.

```dart
class QuestCompletions extends Table {
  TextColumn get id => text()();
  TextColumn get questId =>
      text().references(Quests, #id)();

  DateTimeColumn get completedAt => dateTime()();
  // Exact wall-clock time of completion.

  DateTimeColumn get date => dateTime()();
  // Truncated to start-of-day. Used for fast day-filter queries.

  IntColumn get leAwarded => integer().withDefault(const Constant(10))();
  // Stored explicitly so future LE rule changes don't retroactively
  // alter historical totals.

  TextColumn get categoryAtCompletion =>
      textEnum<QuestCategory>()();
  // Denormalized snapshot of the quest's category at completion time.
  // If the user later edits the quest's category, history stays truthful.

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

**Indexes:**
- `(date)` — "show today's completions" is the hottest query.
- `(quest_id)` — Workshop shows completion count per quest.
- `(completed_at)` — used when computing which quest completions fall between two level-ups, for tree-type calculation.

**Why denormalize `leAwarded` and `categoryAtCompletion`?**
LE rules might change someday (you might bump quest reward to 15). Tree-planting math needs to know what was true at the time, not what's true now. Snapshotting these two columns at insertion is the cheap, robust answer.

---

### 4.5 `daily_quest_rolls`

The set of side quests assigned for a given day. Generated lazily on the first app open / SQ-screen view of each day. Quests outside this set cannot be completed that day — the roller is the gate.

```dart
class DailyQuestRolls extends Table {
  TextColumn get id => text()();
  TextColumn get questId =>
      text().references(Quests, #id)();

  DateTimeColumn get date => dateTime()();
  // The day this quest is assigned to (date-truncated).

  DateTimeColumn get rolledAt => dateTime()();
  // Wall-clock time of the roll. Useful for debugging /
  // "when did midnight roll happen".

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

**Indexes:**
- `(date)` — primary scoping query: "what was rolled for date X?".
- `(quest_id, date)` UNIQUE — a given quest can only be rolled once per day.

**Generation logic (lazy, on first read after midnight):**

```
1. On SQ screen load (or app open if SQ is landing screen):
2. todayDate = startOfDay(now).
3. existingRolls = SELECT * FROM daily_quest_rolls WHERE date = todayDate.
4. If existingRolls is empty:
     a. activePool = SELECT * FROM quests WHERE is_active = true.
     b. n = settings.questsPerDay (default 3).
     c. Randomly pick min(n, activePool.length) quests without replacement.
     d. Insert one daily_quest_rolls row per pick.
5. Return existingRolls (or the freshly created ones).
```

**Why lazy generation rather than a scheduled midnight job?**
Background work on Android/iOS is unreliable, energy-restricted, and varies wildly by device. A lazy check on app open is dead simple, always consistent, and doesn't require any platform-specific scheduling. The only downside: if the user doesn't open the app on a given day, no roll exists for that day — which is fine, because there were no completions either, so no history is lost.

**Relationship to `quest_completions`:** to determine completion status, join on `quest_id` and `date`. A roll without a matching completion = pending; with a completion = done.

---

### 4.6 `habits`

Master list of habits. Same soft-delete philosophy as quests.

```dart
class Habits extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();

  TextColumn get type => textEnum<HabitType>()();
  // good | bad

  // Habits are always daily — no recurrence column needed.

  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

**Indexes:**
- `(is_active)` — Journal screen queries active habits for daily logging.

---

### 4.7 `habit_logs`

One row per habit-log event per day. Logging a habit creates a row; "unlogging" deletes it.

```dart
class HabitLogs extends Table {
  TextColumn get id => text()();
  TextColumn get habitId =>
      text().references(Habits, #id)();

  DateTimeColumn get date => dateTime()();
  // The day this log applies to (date-truncated).

  TextColumn get status => textEnum<HabitLogStatus>()();
  // done       — good habit performed, OR bad habit slipped
  // avoided    — bad habit successfully avoided

  IntColumn get leAwarded => integer().withDefault(const Constant(0))();
  // +2 for good=done or bad=avoided; 0 for bad=done (a slip earns nothing).

  DateTimeColumn get loggedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

**Uniqueness:** Only one log per `(habit_id, date)` combination — enforced at the app layer (toggle behavior on the journal screen), not the schema.

**Indexes:**
- `(date)` — Journal screen pulls habit logs for the day.
- `(habit_id, date)` — checking whether a habit was already logged today.

---

### 4.8 `tasks`

Plain to-dos. No LE, no biome impact. Free-form due dates including future.

```dart
class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 300)();
  TextColumn get description => text().nullable()();

  DateTimeColumn get dueDate => dateTime()();
  // Required. The Tasks screen always shows tasks scoped to the
  // currently-selected date.

  DateTimeColumn get completedAt => dateTime().nullable()();
  // Null while pending; set when checked off.

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

**Indexes:**
- `(due_date)` — primary scoping query.
- `(completed_at)` — useful for "show me what I finished this week" later.

**Notes:**
- `is_completed` is just `completedAt != null` — no separate column.
- Tasks for past dates are immutable per the design doc rules; enforcement is in the UI/repository layer.

---

### 4.9 `journal_entries`

One row per day. Unique constraint on `date`.

```dart
class JournalEntries extends Table {
  TextColumn get id => text()();

  DateTimeColumn get date => dateTime().unique()();
  // Exactly one entry per date.

  TextColumn get body => text().withDefault(const Constant(''))();
  // The free-form entry text.

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

**Indexes:**
- The `unique()` on `date` creates an implicit unique index — that's the only one needed.

**Notes:**
- Font and alignment live in `settings` (global preference), not per-entry. Reverting that decision later means a schema migration.
- Journal entries can be hard-deleted. They have no downstream references.

---

### 4.10 `trees`

Trees in the **current** biome. On biome reboot, all rows are deleted (no archive per design doc).

```dart
class Trees extends Table {
  TextColumn get id => text()();

  TextColumn get category => textEnum<QuestCategory>()();
  // Same enum as quests — adventure tree, fitness tree, etc.

  DateTimeColumn get plantedAt => dateTime()();

  IntColumn get levelAtPlanting => integer()();
  // The level the user reached when this tree was planted.
  // Tree N corresponds to level (N+1).

  RealColumn get positionX => real()();
  RealColumn get positionY => real()();
  // Coordinates in the Flame biome canvas, picked by the user at
  // planting time. On level-up the app enters "placement mode" (see
  // app_state.pendingTreeCategory) — the user taps a spot in the
  // biome and these coords are recorded at that tap.

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastModified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

**Indexes:**
- `(planted_at)` — for ordered rendering ("oldest trees in the back" or similar).
- `(category)` — for any category-based visual grouping or stats.

**Reboot operation:** `DELETE FROM trees;` then update `app_state` to set `lifetimeLe = 0`, `biomes_completed += 1`, `current_biome_started_at = now`, and clear `pendingTreeCategory` if set. Level resets to 1.

---

## 5. Enums

All enums are Dart `enum` types serialized to their `name` string via `textEnum<E>()`.

```dart
enum QuestCategory { adventure, fitness, social, creative, night, normal }
enum QuestSource { preset, user }
enum HabitType { good, bad }
enum HabitLogStatus { done, avoided }
enum JournalFont { handwriting, formal }
enum JournalAlignment { left, right }
```

**Note on `normal`:** This is a tree-only category, used as a neutral fallback when a level-up has no clear dominant category (see § 7.8). Side quests should **never** be tagged with `normal` — Workshop UI must exclude it from the quest category picker. The enum lives in `QuestCategory` (rather than a separate `TreeCategory`) so that `quest_completions.categoryAtCompletion` and `trees.category` share the same type and tree-determination logic can compare apples to apples.

**Rule:** Never reorder enum cases. Never rename a case once shipped. Add new cases at the end. Renames require a migration that rewrites stored strings.

---

## 6. Indexes Summary

Drift indexes are declared in the database class via `customStatement` in migrations, or with the `@TableIndex` annotation on the table. Below is the complete list:

| Table | Index | Purpose |
|---|---|---|
| `quests` | `(category, is_active)` | Roller filter |
| `quests` | `(source)` | Workshop tabs (preset vs user) |
| `quest_completions` | `(date)` | Today's completions, day filter |
| `quest_completions` | `(quest_id)` | Per-quest stats |
| `quest_completions` | `(completed_at)` | Tree-type windowing |
| `daily_quest_rolls` | `(date)` | "What's rolled for today?" |
| `daily_quest_rolls` | `(quest_id, date)` UNIQUE | One roll per quest per day |
| `habits` | `(is_active)` | Daily habit list on journal |
| `habit_logs` | `(date)` | Today's logs |
| `habit_logs` | `(habit_id, date)` | "Already logged today?" check |
| `tasks` | `(due_date)` | Day-scoped task list |
| `tasks` | `(completed_at)` | Completed-this-week stats (later) |
| `journal_entries` | `(date)` UNIQUE | One per day, fast lookup |
| `trees` | `(planted_at)` | Ordered rendering |
| `trees` | `(category)` | Category-based stats |

---

## 7. Key Operations (Code Flow)

Reference for the most common write paths. These define the *invariants* the app layer must uphold.

### 7.1 Marking a Side Quest Complete

```
1. Verify not in placement mode (app_state.pendingTreeCategory is null).
   If in placement mode, block the action — placement must complete first.
2. Insert quest_completion (questId, completedAt = now, date = today,
   leAwarded = 10, categoryAtCompletion = quest.category).
3. Read app_state.lifetimeLe.
4. oldLevel = (lifetimeLe / 50) + 1
5. newLifetimeLe = lifetimeLe + 10
6. newLevel = (newLifetimeLe / 50) + 1
7. Update app_state.lifetimeLe = newLifetimeLe.
8. If newLevel > oldLevel:
     a. Determine tree category (see § 7.8).
     b. Set app_state.pendingTreeCategory = winning category.
     c. UI transitions to tree placement mode. User taps a spot
        on the biome canvas.
     d. On tap: insert tree row with (positionX, positionY, category =
        pendingTreeCategory, levelAtPlanting = newLevel).
        Clear app_state.pendingTreeCategory.
     e. If tree count after insert == 100, surface the reboot prompt.
```

### 7.2 Unmarking a Side Quest

Only valid for today's completions (past is read-only). Symmetric inverse of § 7.1.

```
1. Verify not in placement mode. If in placement mode, block.
2. Delete the quest_completion row for (quest_id, today).
3. Read app_state.lifetimeLe.
4. oldLevel = (lifetimeLe / 50) + 1
5. newLifetimeLe = lifetimeLe - 10
6. newLevel = (newLifetimeLe / 50) + 1
7. Update app_state.lifetimeLe = newLifetimeLe.
8. If newLevel < oldLevel:
     a. DELETE the most recently planted tree:
        DELETE FROM trees WHERE id = (
          SELECT id FROM trees ORDER BY planted_at DESC LIMIT 1
        );
     b. No placement mode triggered — tree is just gone.
```

### 7.3 Logging a Habit

```
1. Verify not in placement mode. If in placement mode, block.
2. Check if habit_logs already has a row for (habitId, today).
   - If yes: this is a toggle-off (handled in § 7.4).
   - If no: insert with status = done or avoided.
3. Compute leAwarded:
   - good habit + done → +2
   - bad habit + avoided → +2
   - bad habit + done (a slip) → 0
4. If leAwarded > 0:
     a. Update the log row's leAwarded.
     b. oldLevel = (lifetimeLe / 50) + 1
     c. newLifetimeLe = lifetimeLe + leAwarded
     d. newLevel = (newLifetimeLe / 50) + 1
     e. Update app_state.lifetimeLe.
     f. If newLevel > oldLevel: trigger tree planting flow
        (see § 7.1 step 8 — same as quest completion).
```

### 7.4 Unlogging a Habit

```
1. Verify not in placement mode. If in placement mode, block.
2. Find the habit_log for (habitId, today).
3. Read its leAwarded value.
4. Delete the row.
5. If leAwarded > 0:
     a. oldLevel = (lifetimeLe / 50) + 1
     b. newLifetimeLe = lifetimeLe - leAwarded
     c. newLevel = (newLifetimeLe / 50) + 1
     d. Update app_state.lifetimeLe.
     e. If newLevel < oldLevel: DELETE the most recently planted tree
        (same as § 7.2 step 8).
```

### 7.5 Tree Placement (resumed after app restart)

```
1. On app open / Biome screen mount:
2. If app_state.pendingTreeCategory is not null:
     a. Force the Biome screen to placement mode.
     b. Block navigation away (or warn) until placement is complete.
     c. On user tap: insert tree, clear pendingTreeCategory.
```

This means a crash or force-close during placement is fully recoverable — the app reopens directly into placement mode.

### 7.6 Biome Reboot

```
1. Triggered when tree count reaches 100. User confirms the prompt.
2. Start a transaction.
3. DELETE FROM trees.
4. UPDATE app_state SET
     lifetime_le = 0,
     biomes_completed = biomes_completed + 1,
     current_biome_started_at = now,
     pending_tree_category = NULL.
5. Commit.
6. Trigger the dimensional-travel animation.

After reboot: lifetimeLE is 0, level is 1, biome is empty.
biomesCompleted increments and is surfaced on the Biome screen
("X worlds completed").

Notes:
- quest_completions, habit_logs, journal_entries, and tasks are
  PRESERVED across reboot. Only LE and trees reset. History stays
  intact for future analytics.
- pendingTreeCategory is cleared defensively in case the user reboots
  mid-placement (edge case, but cheap to handle).
- lastRerollDate is NOT reset — reroll is a "once per real-world day"
  budget that doesn't care about biome boundaries.
```

### 7.7 Daily Quest Reroll

```
1. User taps "Reroll" on the SQ screen.
2. Eligibility checks (in order — first failure blocks):
     a. app_state.lastRerollDate != today.            (used-today check)
     b. No quest_completions exist for date = today.  (completion check)
     c. (lifetimeLe % 50) >= 10.                       (LE check)
   If any fails, surface a contextual error message and stop.
3. Start a transaction.
4. UPDATE app_state SET
     lifetime_le = lifetime_le - 10,
     last_reroll_date = today.
5. DELETE FROM daily_quest_rolls WHERE date = today.
   (Safe — no completions exist by check 2b.)
6. Generate a fresh roll using the same logic as § 4.5
   (pick min(questsPerDay, activePool.length) from active quests).
7. INSERT the new daily_quest_rolls rows.
8. Commit.

NOTE: The LE deduction of 10 is designed so it never triggers a
level-down — the LE check in step 2c guarantees the user has at
least 10 LE of current-level progress before deducting. As a result,
no tree removal logic is needed here.
```

### 7.8 Determining Tree Category (on level-up)

When a level-up triggers tree planting, the category is determined as follows:

```
1. Find quest_completions where completed_at > (
     latest tree's planted_at, or epoch if no trees exist
   ).
   (i.e., quests completed since the most recently planted tree.)

2. If this window contains quest_completions:
     a. Tally categories using categoryAtCompletion (the snapshot).
     b. Winner = category with highest count.
     c. Tiebreaker = category of the most recently completed quest
        in the window.

3. If the window is EMPTY (e.g., level-up triggered purely by habit LE):
     → Category is QuestCategory.normal.
        Plant a Normal tree.
```

The result is then set as `app_state.pendingTreeCategory`, which the placement-mode UI reads to know which tree sprite to render.

**Why a dedicated Normal tree instead of falling back to historical quests?** A Normal tree is an honest visual representation of "this level-up came from habit grind, not a specific quest theme." It also gives the user a meaningful aesthetic choice — a biome with several Normal trees mixed in tells a different story than a Fitness-dominated forest.

---

## 8. Convenience Queries

A reference list of common queries the app/repository layer will use. None require schema changes; all are answerable with the existing tables and indexes.

```sql
-- Most recently planted tree
SELECT * FROM trees
ORDER BY planted_at DESC
LIMIT 1;

-- Today's rolled quests, with completion status
SELECT r.quest_id, q.title, q.category, c.completed_at IS NOT NULL AS done
FROM daily_quest_rolls r
JOIN quests q ON q.id = r.quest_id
LEFT JOIN quest_completions c
  ON c.quest_id = r.quest_id AND c.date = r.date
WHERE r.date = :today;

-- Is the user eligible to reroll right now?
-- (Combined in code, but the three checks are:)
SELECT last_reroll_date != :today AS used_today_ok,
       (lifetime_le % 50) >= 10  AS le_ok,
       NOT EXISTS (
         SELECT 1 FROM quest_completions WHERE date = :today
       )                         AS no_completion_ok
FROM app_state WHERE id = 1;

-- Quest completions since the last tree was planted
-- (used for tree-category determination on level-up)
SELECT * FROM quest_completions
WHERE completed_at > (
  SELECT COALESCE(MAX(planted_at), '1970-01-01') FROM trees
)
ORDER BY completed_at ASC;

-- Active habit list for today's journal
SELECT * FROM habits WHERE is_active = 1;

-- Tree count in current biome (= currentLevel - 1, by invariant)
SELECT COUNT(*) FROM trees;

-- Remove the most recently planted tree (on level-down)
DELETE FROM trees WHERE id = (
  SELECT id FROM trees ORDER BY planted_at DESC LIMIT 1
);

-- Have I used my reroll today?
SELECT last_reroll_date = :today AS reroll_used FROM app_state WHERE id = 1;
```

---

## 9. Migration Considerations

Drift handles migrations via `MigrationStrategy` in the database class. Pattern:

```dart
@override
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (m) async {
    await m.createAll();
    await _seedPresetQuests();
    await _seedSingletonRows();
  },
  onUpgrade: (m, from, to) async {
    if (from < 2) {
      // future migration logic
    }
  },
);
```

**Seeding on first launch:**
- One row in `app_state` (id=1, lifetimeLe=0, currentBiomeStartedAt=now).
- One row in `settings` (id=1, all defaults).
- Preset quests from bundled JSON.

**Safe schema changes (no migration logic needed):**
- Adding new nullable columns.
- Adding new tables.
- Adding indexes.

**Schema changes requiring migration logic:**
- Renaming columns or tables.
- Changing column types.
- Renaming enum cases (must rewrite stored strings).
- Adding NOT NULL columns without defaults.

---

## 10. Sync Portability Notes

If/when Supabase sync is added:

- **Table names map 1:1** — Postgres allows the same names.
- **Column types map cleanly:**
  - SQLite `TEXT` → Postgres `TEXT`
  - SQLite `INTEGER` → Postgres `INTEGER` or `BIGINT`
  - SQLite `REAL` → Postgres `DOUBLE PRECISION`
  - SQLite `DateTime` (ISO8601 strings) → Postgres `TIMESTAMPTZ` (with a conversion step).
  - Drift `BOOLEAN` (stored as 0/1) → Postgres `BOOLEAN` (with conversion).
- **Enums:** stored as `TEXT` in SQLite; in Postgres, either keep as `TEXT` (with a CHECK constraint) or migrate to native `ENUM` types.
- **Conflict resolution:** UUIDs ensure no PK collisions. `last_modified` enables last-write-wins. No conflict-prone constraints (no globally unique strings beyond UUIDs, no auto-increment sequences).

The schema in this doc is deliberately written to be a near-direct Postgres `CREATE TABLE` translation. No SQLite-specific quirks are relied on.

---

## 11. Open Questions

All previously-flagged questions are now resolved:

- ~~Tree-permanence rule~~ → resolved v0.4: fully symmetric (mark plants, unmark removes latest).
- ~~Reroll "completion check"~~ → resolved v0.3 as lenient. Confirmed v0.4.
- ~~Quest pool minimum~~ → resolved v0.3 as soft fallback. Confirmed v0.4.
- ~~Habit-triggered level-up category fallback~~ → resolved v0.5: plant a Normal tree when the since-last-tree window is empty.

Remaining items for future consideration (not blocking implementation):

- **Tree-replant exploit consideration.** With symmetric trees, the user can mark→unmark→mark a quest to re-pick the tree's position (and potentially its category, if other completions changed in between). This is intentional for personal use but worth noting.

---

## 12. Changelog

- **v0.5 (21 May 2026)** — Added `normal` to `QuestCategory` enum as a tree-only neutral fallback. § 7.8 simplified: when the since-last-tree window is empty (habit-driven level-up), plant a Normal tree directly rather than chaining through historical quest categories. Workshop UI must exclude `normal` from the quest category picker.
- **v0.4 (21 May 2026)** — Switched to fully symmetric tree mechanics: marking plants a tree on level-up, unmarking removes the most recently planted tree on level-down (§ 7.2, § 7.4). The `maxLevelReached` derivation is dropped — replaced by the cleaner invariant `trees.count() == currentLevel - 1`. Added explicit placement-mode guard to all completion/log operations (§ 7.1–7.4): all other actions are blocked while `pendingTreeCategory` is set. Tree category determination extracted into a dedicated § 7.8 with explicit fallback chain for habit-triggered level-ups (window → most recent quest in biome → Adventure default).
- **v0.3 (21 May 2026)** — Added daily quest reroll mechanic (§ 7.7): 1 per day, costs 10 LE from current-level progress, blocked if any completion exists or if LE check fails. Added `lastRerollDate` column to `app_state` for "once per day" enforcement. New § 8 "Convenience Queries" with reference SQL for the most common app reads (latest tree, today's roll status, reroll eligibility, etc.). Subsequent sections renumbered.
- **v0.2 (21 May 2026)** — Added `daily_quest_rolls` table with lazy generation logic. Removed `recurrence` column from habits and `HabitRecurrence` enum (habits are always daily). Added `pendingTreeCategory` to `app_state` for crash-safe tree placement. Tree positions are now user-picked at placement time. Biome reboot now resets `lifetimeLe` to 0 (full restart, Level 1). Defined symmetric mark/unmark semantics (LE up on mark, LE down on unmark) and confirmed tree-permanence rule (trees plant only when reaching a new max level in the current biome). Restructured § 7 into separate ops for mark, unmark, log, unlog, placement, and reboot.
- **v0.1 (21 May 2026)** — Initial data model. Nine tables, full Drift definitions, indexes, key operation flows, sync portability notes.
