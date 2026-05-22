# OptiLife — IA, Navigation & State (POP)

**Audience:** Flutter engineers. Defines the route graph, the Riverpod state surface every screen reads, the global interaction locks, and the per-screen state matrix. Backed by Design Doc §5–6 and Data Models §4, §7.

---

## 1. Navigation model

### 1.1 Primary swipe (`PageView`)
Order **Biome ← Side Quest → Tasks → Journal**. Landing index = **Side Quest** (Design Doc §5.2).

```dart
final pageControllerProvider = Provider((_) => PageController(initialPage: 1));
enum AppPage { biome, sideQuest, tasks, journal } // index 0..3
```
- Horizontal swipe moves between adjacent pages. **Swipe does not change the date** (date is global, §2).
- `CentralNav` radial menu handles non-adjacent jumps + Settings/Analytics.

### 1.2 Vertical scroll = date change
- Up = previous day, down = next day. **Disabled on Biome** (date-agnostic).
- Journal uses `NestedScrollView`: inner = entry body, outer past-edge drag (~90px) = day change (Design Doc §8.4). Feedback is rubber-band + tug haptic only (no text ribbon).

### 1.3 Route graph
```
MaterialApp
└─ AppShell (Scaffold; hosts sticky shell + PageView)
   ├─ BiomePage      (also hosts placement-mode + reboot overlays)
   ├─ SideQuestPage
   ├─ TasksPage
   └─ JournalPage
Pushed routes / overlays:
   • RadialMenu            (Overlay, not a route)
   • SettingsPage          (push)
   │   └─ WorkshopPage     (push) → QuestEditorSheet / HabitEditorSheet
   • DatePickerSheet       (bottom sheet)
   • Task/Quest/Habit editor sheets (bottom sheets)
   • JournalFontSheet      (bottom sheet)
   • LevelUpOverlay / RebootOverlay (full-screen, route-blocking)
   • Analytics             (v1.x, stub)
```
The **sticky shell** (LE ring, central nav, calendar, date display, page-dots) lives in `AppShell` above the `PageView`, so it persists across pages, gestures, and dates (Design Doc §5.1). Sheets/overlays render above it.

---

## 2. Global state (Riverpod)

### 2.1 Selected date — the spine
```dart
/// Truncated to start-of-day. Single source of truth read by SQ, Tasks, Journal.
final selectedDateProvider = StateProvider<DateTime>((_) => DateUtils.dateOnly(DateTime.now()));

final isTodayProvider  = Provider((ref) => _isSameDay(ref.watch(selectedDateProvider), today));
final isPastProvider   = Provider((ref) => ref.watch(selectedDateProvider).isBefore(today));
final isFutureProvider = Provider((ref) => ref.watch(selectedDateProvider).isAfter(today));
```

### 2.2 App / gameplay state (from `app_state`, Data Models §4.1)
```dart
final appStateProvider = StreamProvider<AppState>(...); // Drift watch
// Derived (compute, never store):
int currentLevel(int le)        => (le ~/ 50) + 1;
int leIntoCurrentLevel(int le)  => le % 50;
int leUntilNextLevel(int le)    => 50 - (le % 50);
```
Surfaced: LE ring (`leIntoCurrentLevel/50`, level badge), Biome HUD (`WORLD = biomesCompleted+1`, tree count `/100`).

### 2.3 Settings (from `settings`, Data Models §4.2)
`liquidFillEnabled`, `journalFont`, `journalAlignment`, `questsPerDay`, `notificationsEnabled`. Read reactively; changing in Settings/Workshop updates immediately.

### 2.4 Per-screen data providers
- `dailyRollProvider(date)` → today's rolled quests + completion status (Data Models §8 join).
- `tasksProvider(date)`, `journalEntryProvider(date)`, `habitsProvider` (active) + `habitLogsProvider(date)`.
- `treesProvider` (current biome, ordered by `plantedAt`).

---

## 3. Global interaction locks

### 3.1 Placement-mode lock (HARD)
When `appState.pendingTreeCategory != null` the app is locked into Biome placement (Design Doc §6.7, Data Models §7.5):
- Force-navigate to Biome; **block** all other input — swipe, shell taps, radial menu, sheets, marking/logging.
- Only valid input: tap a valid biome cell to plant.
- Implement as a top-level `Consumer` in `AppShell`: if pending, wrap everything except the biome canvas in `IgnorePointer` + dim (`surfaceSunk` overlay), and disable `PageController`/`CalendarButton`.
- **Crash-safe**: state is persisted, so app boots straight into placement if pending on launch.

### 3.2 Read-only past dates (SOFT)
When `isPast`, disable all action verbs (mark/unmark, check, log, edit journal). Controls render in read-only style (`surfaceSunk`, `1.5px catNormal`, no shadow); tap → shake, no state change. Show `👀 Read-only · past day` ribbon. (Design Doc §6.2)

### 3.3 Future dates
- Tasks: **fully editable** (planning). `🗓 Planning ahead` ribbon.
- Side Quests / Journal / Habits: **disabled / empty** with friendly "comes around on the day" copy. (Design Doc §6.3)

---

## 4. Screen-state matrix

Legend: ✅ interactive · 👀 read-only · 🚫 empty/disabled · 🎉 celebratory.

| Screen | today | past | future | empty (today) | special |
|---|---|---|---|---|---|
| **Side Quest** | ✅ mark/unmark, reroll | 👀 outcomes only, no reroll; "no roll" if app unopened that day | 🚫 "quests roll on the day" | 🚫 no active pool → Workshop shortcut | 🎉 all-done banner; deal-in on fresh roll; reroll-disabled+tooltip |
| **Biome** | ✅ pan/zoom, photo | (date-agnostic — same always) | (same) | 🌱 "complete a quest to grow your first tree" | 🎉 placement-mode lock; level-down toast; reboot+travel |
| **Tasks** | ✅ CRUD | 👀 static checks, no FAB | ✅ **editable** (planning) | 🚫 "nothing on the list" + FAB | all-done → DONE group |
| **Journal+Habits** | ✅ log + write | 👀 static habit badges, read-only entry | 🚫 "opens on the day" | placeholder prompt; "add habits" if none | habit-driven level-up → placement |

### 4.1 Reroll eligibility (SQ) — disabled reasons (Design Doc §6.6, Data Models §7.7)
Show button always; disable + tooltip when:
1. already rerolled today (`lastRerollDate == today`),
2. any completion exists today,
3. `leIntoCurrentLevel < 10`,
4. hide entirely on past/future.

### 4.2 Loading / first launch
- **Cold start seeding** (Data Models §9): create `app_state`, `settings`, seed preset quests. Show a brief POP splash (logo + heartbeat) until the DB is ready; then land on Side Quest.
- **Per-provider loading**: skeleton shimmer in card shapes (`hazeDeep`), never a bare spinner. Empty vs loading must be distinguishable.
- **Lazy daily roll**: first SQ view after midnight generates the roll (Data Models §4.5); show deal-in animation, not a spinner.

---

## 5. Settings & Workshop IA (Design Doc §6.4)

```
SettingsPage
├─ Appearance: liquid-fill toggle, journal font, journal alignment
├─ Gameplay: quests-per-day stepper
├─ Notifications (v1.x; default off)
├─ Workshop ▸
│   ├─ Quests tab: list (preset toggles + user quests) → QuestEditorSheet (create/edit/delete user; toggle preset is_active)
│   └─ Habits tab: list → HabitEditorSheet (create/edit/delete; good/bad)
├─ Journal export (v1.x)
└─ About
```
- Quest category picker **excludes `normal`** (Data Models §5).
- Habits are daily-only — no recurrence field.
- Deletions: quests/habits **soft-delete** (`isActive=false`) to preserve history; tasks/journal hard-delete.

---

## 6. Routing of the celebratory flows
- **Level-up** (from quest mark or habit log crossing a 50-LE boundary): `LevelUpOverlay` (full-screen, blocks) → on dismiss, enter placement lock (§3.1) on Biome.
- **Level-down** (unmark/unlog crossing downward): no overlay; remove newest tree + `Toast` (Data Models §7.2/7.4).
- **Reboot** (100th tree): after placement, `RebootOverlay` prompt → confirm → transaction (Data Models §7.6) → dimensional-travel animation → empty world, `WORLD n+1`.
