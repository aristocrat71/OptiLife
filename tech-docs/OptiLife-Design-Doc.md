# OptiLife — Design Document

**Status:** v0.7 (locked decisions, pre-implementation)
**Owner:** Personal project (single developer)
**Last updated:** 21 May 2026

---

## 1. Overview

OptiLife is a personal life-gamification app built in Flutter. Completing real-world **side quests** (small, intentional offline tasks like "do 50 pushups", "draw something", "go swimming") charges a **Life Energy (LE)** meter. Accumulating LE levels you up, and each level-up plants a tree in your personal **biome** — the tree type is determined by which category of quests you've been completing most. Habits provide a small LE drip, tasks are plain utility (no LE), and a daily journal sits alongside.

It is intentionally a single-user, local-first, no-account-needed app for personal use. Not intended for distribution.

---

## 2. Goals & Non-Goals

**Goals**
- A daily-driver app that makes "doing intentional offline things" feel rewarding via a tight loop: quest → LE → level → tree → visible biome growth.
- Simple, linear progression with no difficulty weights, no streak loss-aversion, no anti-cheat overhead.
- Offline-capable, fast, private (no required network calls).
- A pleasant, distinctive UI worth opening even when nothing needs doing.

**Non-Goals**
- Multi-user / social features.
- App store distribution.
- Productivity-tracker positioning (no "10x your output" framing — this is for *life*, not work).
- Complex economy, marketplaces, or quest verification.

---

## 3. Scope

### 3.1 In MVP (v1.0)
- Side Quest screen with both preset DB and user-created quests.
- Random quest roller (rolls from the combined pool).
- LE meter (top bar, always visible).
- Biome screen (2.5D isometric, trees grown via level-up).
- Habits (CRUD via Workshop in Settings).
- Tasks (no LE impact).
- Journal (one entry per day, includes habit logging).
- Date navigation: global date state, vertical scroll for day change.
- Workshop section in Settings: CRUD for quests and habits.
- **Photo mode (Tier 1):** screenshot-only — hides floating top controls, captures current biome view, saves to device gallery. No pan/zoom/filters yet.

### 3.2 Deferred to Final Stages (v1.x)
- **Analytics** — accessed via the central nav circle.
- **Journal export** — lives in Settings.
- **Notifications** — lives in Settings.

These are explicitly *not* part of the early build. They get added once the core loop is solid and tuned.

### 3.3 Dropped (will not build)
- Side-quest verification (photo proof, location ping, etc.).
- LE loss / decay / penalty for missed quests.
- Side-quest marketplace.
- XP-style weighted rewards or difficulty multipliers.

---

## 4. Core Mechanics

### 4.1 Life Energy (LE)

LE is the single progression currency. No XP, no coins, no secondary scores.

| Action | LE Awarded |
|---|---|
| Complete a side quest | +10 |
| Log a good habit for the day | +2 |
| Avoid a bad habit for the day | +2 |
| Complete a task | 0 |

### 4.2 Levels

- **Formula:** `LE_required(level N) = 50 × (N − 1)`
- Level 2 unlocks at 50 LE, Level 3 at 100 LE, Level 4 at 150 LE.
- **No upper threshold** — levels keep going forever.
- Each level requires the same flat 50 LE worth of progress.

The top-bar LE meter shows progress *within the current level* (0 → 50 → reset on level-up). Total lifetime LE is surfaced later in the Analytics screen.

### 4.3 Biome & Trees

- **Trigger:** Every level-up plants exactly one tree. Every level-down (caused by unmarking a quest or unlogging a habit) removes the most recently planted tree. Trees and levels are locked in sync: `tree count == current level − 1`.
- **Tree type:** Determined by the **category of the majority of quests completed since the last tree was planted** (see fallback chain below for habit-only level-ups).
- **Tiebreaker:** Most recent quest's category wins.
- **Tree position: user-decided.** On level-up the app enters "placement mode" — the user taps a spot in the biome canvas to plant the tree. **All other interactions are blocked during placement** (the only valid action is placing the tree). State is persisted, so a crash mid-placement resumes cleanly on next launch.
- **Category fallback for habit-triggered level-ups:** If a habit log triggers the level-up and no quest has been completed since the last tree was planted, a **Normal tree** is planted. Normal is a dedicated tree type used as a neutral fallback — an honest visual record that the level-up came from habit grind rather than a thematic quest streak.
- **Categories → tree types:**

| Category | Tree / Plant Type |
|---|---|
| Adventure | Wild, untamed tree |
| Fitness | Strong oak |
| Social | Flowering tree |
| Creative | Rare glowing plant |
| Night | Moonlit plant |
| Normal | Neutral, plain tree (tree-only — never assignable to a quest) |

(Exact visual assets TBD during art pass.)

The biome is **cumulative and date-agnostic** — it represents the current state of the user's "world" and does not retroactively change when the user views past dates.

**Biome capacity & reboot:** Each biome holds **100 trees** total. On planting the 100th tree, the user is prompted to **Reboot Biome** — confirming triggers a "dimensional travel" animation and starts a fresh, empty grid. Reboot is a **full reset**: `lifetimeLe → 0`, level → 1, all trees deleted. Quest/habit/journal/task history is preserved (it stays useful for analytics).

**Biomes completed counter:** A `biomesCompleted` counter increments by 1 on each reboot and is surfaced on the Biome screen (e.g. "World 3" or "2 worlds completed"), giving long-term users a visible trophy for prior cycles.

### 4.4 Entity Definitions

- **Side Quest** — Special, often one-off, category-tagged. Sources: curated preset DB + user-created via Workshop. Full LE reward.
- **Habit** — Recurring **daily**, user-defined. Small LE drip. Can be good (log when done) or bad (log when avoided).
- **Task** — Plain to-do. No LE, no biome impact. Pure life admin.
- **Journal Entry** — One per day. No LE. Text content + formatting preferences.

---

## 5. Information Architecture

### 5.1 Sticky Top Controls (always visible on every screen)

The top of every screen has **three independent floating sticky buttons** — *not* a solid bar. Each floats over the underlying content as its own element. Exact positioning, sizing, spacing, and visual treatment will be finalized when building the UI screens.

| Position | Element | Behavior |
|---|---|---|
| Top-left | LE meter | Visual gauge showing progress within current level. Tappable later for analytics. |
| Top-middle | Central nav circle | Heartbeat pulse animation. Tap opens radial menu. |
| Top-right | Calendar button | See § 5.5 for behavior. |

All three persist across every screen, every gesture, and every date — they never slide away or hide.

### 5.2 Primary Navigation (Horizontal Swipe)

Left-to-right order:

**Biome ← Side Quest → Tasks → Journal**

- Landing screen on app open: **Side Quest**.
- Implemented as `PageView` with `PageController`.
- Swipe gestures move between adjacent screens; the central nav handles non-adjacent jumps.

### 5.3 Central Nav Circle (Radial Menu)

Tapping the heartbeat-pulsing circle opens a radial menu with destinations:

- **Bio** (Biome)
- **SQ** (Side Quest)
- **Task**
- **HJ** (Habits + Journal) — opens the Journal screen, which is the combined habits + journal experience. Habit logging for the day lives *inside* the journal entry UI (not as a separate screen). This is the same destination as the Journal screen reached via horizontal swipe; the label "HJ" exists as a reminder that habit logging happens there.
- **Set** (Settings — Workshop, export, notifs, theme toggles)
- **Analytics** (added in v1.x)

### 5.4 Date Navigation (Vertical Scroll)

- **Scroll up** = previous day.
- **Scroll down** = next day.
- **Disabled on Biome screen** — biome is date-agnostic.
- **Journal screen needs special handling** — see § 8.4.

### 5.5 Calendar Button Behavior

A single button on the top-right with three states/interactions:

1. **When viewing today:** Standard calendar icon.
2. **When viewing any other date:** Icon visually changes (e.g., calendar + small `←` overlay) to signal you're not on today.
3. **Tap (when off-today):** Jump back to today.
4. **Long-press (any time):** Open full date picker.

---

## 6. UX Behavior Rules

### 6.1 Date as Global App State

- The currently-selected date is a single piece of global state (Riverpod provider), read by every screen.
- Horizontal swipes between Biome / SQ / Tasks / Journal **do not change the date**. Browsing "yesterday" on Tasks then swiping to Journal shows *yesterday's* journal.
- Biome screen ignores the date entirely.

### 6.2 Past Dates — Read-Only

When viewing any date earlier than today, all action verbs are disabled:
- Cannot mark quests complete.
- Cannot check off tasks.
- Cannot edit journal entries.
- Cannot log habits.

Past data is **viewable** but **immutable**. This prevents backfilling and keeps progression honest.

### 6.3 Future Dates

- **Tasks:** Can be created and edited (forward planning is the point).
- **Side Quests:** Disabled / empty (quests are daily / in-the-moment).
- **Journal:** Disabled / empty.
- **Habits:** Cannot be logged in advance.

### 6.4 Workshop (Settings → Workshop)

A dedicated CRUD area inside Settings for managing:
- **Side Quests** — create, edit, delete user quests; toggle preset quests on/off.
- **Habits** — create, edit, delete; mark as good/bad. (Recurrence is always daily.)

### 6.5 Mark / Unmark Semantics (Today Only)

Marking and unmarking on the **current day** is fully symmetric:

| Action | LE delta |
|---|---|
| Mark quest complete | +10 |
| Unmark quest | −10 |
| Log good habit (done) | +2 |
| Unlog good habit | −2 |
| Log bad habit (avoided) | +2 |
| Unlog bad habit (avoided) | −2 |
| Log bad habit (slip) | 0 |

The LE meter responds immediately to either direction. Note this only applies to today — past dates are read-only (see § 6.2).

**Trees are symmetric too:** Crossing a level boundary upward plants a tree (entering placement mode). Crossing a level boundary downward removes the most recently planted tree, with no placement step needed. The invariant `tree count == current level − 1` holds at all times outside of placement mode.

This means re-marking after an unmark plants a *fresh* tree — potentially in a new position the user picks, and potentially of a different category if other completions changed in the meantime. This isn't a bug; it's a natural consequence of the symmetric model and gives a graceful "I want to try again" affordance.

### 6.6 Daily Quest Roll

- A fresh set of side quests is rolled at the start of each day.
- **Mechanism:** lazy generation — the first time the app is opened (or the SQ screen is viewed) on a new day, the roller picks `settings.questsPerDay` quests at random from the active quest pool and assigns them as today's quests.
- Quests outside today's roll **cannot** be completed that day — the roll is the gate.
- The roll for a given day is persistent: closing the app and reopening it later the same day shows the same quests, in the same state.
- Days the user doesn't open the app simply have no roll (no completions either — nothing is lost).
- **Pool fallback:** If `questsPerDay` exceeds the active quest pool size, the roller picks `min(questsPerDay, poolSize)` and proceeds. No error, no warning — the user just gets fewer quests that day.

**Reroll:** The user can replace today's roll with a fresh one, subject to these rules:

| Rule | Detail |
|---|---|
| Frequency | 1 reroll per day, max. |
| Cost | 10 LE, deducted from current-level progress. |
| Blocked if any quest is already completed today | Including quests that were marked then unmarked? No — the check is "any current `quest_completion` for today exists". If the user unmarks, reroll re-enables. |
| Blocked if LE in current level < 10 | Prevents reroll from triggering a level-down. |
| Blocked if reroll already used today | Tracked via `app_state.lastRerollDate`. Resets at midnight. |

The reroll button is visible on the SQ screen always but disabled (with a contextual tooltip explaining *why*) when any rule blocks it.

### 6.7 Tree Placement Flow

- On level-up (every level-up — see § 6.5), the app enters **tree placement mode**.
- The user is presented with the biome canvas and taps a spot to plant the tree.
- The pending tree's category is computed at level-up time and persisted, so a crash or force-close during placement is fully recoverable — the app reopens in placement mode.
- **All other interactions are blocked during placement.** Marking quests, unmarking, logging habits, swiping between screens, opening Settings — none of it works until placement completes. The only valid input is a tap on the biome canvas to place the tree.

---

## 7. UI Signature Elements

- **Heartbeat pulse** on the central nav circle — subtle scale animation (~0.8s cycle, scale 1.0 → 1.08 → 1.0).
- **Liquid-fill background** — animated wave rising from the bottom of the screen, height proportional to LE within current level. Toggle on/off in Settings.
- **Customizable journal typography** — font choice (handwriting vs. formal) and right-align toggle.
- **Cartoonish 2.5D isometric biome** — rendered with the Flame engine.

---

## 8. Technical Architecture

### 8.1 Stack

| Layer | Choice |
|---|---|
| Framework | Flutter |
| State management | Riverpod |
| Local database | Drift (SQLite ORM, typed queries) |
| Biome rendering | Flame engine (2.5D isometric sprites) |
| Animations | Native Flutter `AnimationController` + `CustomPainter` for liquid fill |

### 8.2 Local-First Philosophy

- All data lives in an on-device SQLite database via Drift.
- No required network calls. App is fully functional offline.
- Every record has a stable UUID and `last_modified` timestamp from day one (so sync can bolt on later without a migration).

### 8.3 Sync (Future, Optional)

If sync is ever added, the target is **Supabase free tier** (Postgres). Drift's SQLite schema is designed to be portable to Postgres — same column types, same relationships. Sync would be a periodic JSON snapshot push, nothing more elaborate.

### 8.4 Implementation Notes (Captured from Discussion)

- **Journal vertical scroll conflict:** Use Flutter's `NestedScrollView`. The journal entry body lives inside the inner scrollable; day-change is triggered by the outer scrollable. Day-change should fire only after **~80–100px of past-the-edge drag** on the outer scroll, not on every small overscroll. Threshold to be tuned on a real device.
- **Heartbeat animation:** `AnimationController` with `repeat(reverse: true)`, wrapped in `ScaleTransition`.
- **Liquid fill:** Custom `CustomPainter` with two phase-shifted sine waves for natural wobble; color tint can shift based on most-recent quest category.
- **Radial nav menu:** Custom `Overlay` with animated `Positioned` children. Worth writing custom for visual identity (not using `flutter_speed_dial`).

---

## 9. Data Model (Outline — Full Schema in `Optilife Data Models.md`)

Ten tables, captured in the companion data model document. High-level summary:

- **app_state** (single row — biome-scoped `lifetimeLe`, `biomesCompleted`, `pendingTreeCategory` for crash-safe placement, `lastRerollDate` for daily reroll enforcement)
- **settings** (single row — preferences: font, alignment, liquid-fill toggle, quests-per-day, notifications)
- **quests** (id, title, description, category, source: preset/user, is_active)
- **quest_completions** (id, quest_id, date, completed_at, leAwarded snapshot, category snapshot)
- **daily_quest_rolls** (id, quest_id, date — the day's assigned quests)
- **habits** (id, title, type: good/bad, is_active)
- **habit_logs** (id, habit_id, date, status: done/avoided, leAwarded)
- **tasks** (id, title, due_date, completed_at)
- **journal_entries** (id, date UNIQUE, body)
- **trees** (id, category, planted_at, levelAtPlanting, position_x, position_y)

Every entity carries `uuid`, `created_at`, `last_modified` for sync portability.

---

## 10. Open Questions / To Review

- **Journal screen design** — habit logging is integrated *into* the journal entry experience, not a separate screen. Exact UX needs design work: where habit checkboxes live relative to the entry text, how they behave on past/future dates, visual hierarchy.
- **Tree visual assets** — need to settle on art style and produce the 5 tree types.
- **Preset quest list** — need to write the curated quest pool (target: ~50–100 quests across the 5 categories).
- **Vertical scroll threshold tuning** — pick exact px value once tested on device (target ~80–100px past-edge drag).
- **Top controls visual layout** — finalize sizing, spacing, and styling of the three floating sticky buttons during UI build.

---

## 11. Changelog

- **v0.7 (21 May 2026)** — Added Normal as a sixth tree type. Plants automatically when a habit-driven level-up has no quests in the since-last-tree window. Normal is tree-only — never selectable as a quest category. Replaces the earlier "look back further → Adventure default" fallback chain, which was awkward (claimed a category that wasn't really represented).
- **v0.6 (21 May 2026)** — Trees made fully symmetric: level-up plants, level-down removes the most recently planted tree. Locked-in invariant: `tree count == current level − 1` (outside placement mode). Placement-mode interaction lock locked in as "all other actions blocked". § 4.3 and § 6.5 rewritten accordingly. Category fallback chain documented for habit-triggered level-ups.
- **v0.5 (21 May 2026)** — Daily quest reroll mechanic locked in (§ 6.6): 1 per day, costs 10 LE from current-level progress, blocked if any completion exists, if LE check fails, or if already used today. Pool-fallback rule clarified (soft `min(N, poolSize)`). `lastRerollDate` field noted on app_state in § 9.
- **v0.4 (21 May 2026)** — Habits locked as daily-only (no weekly recurrence). Tree positioning is user-decided (placement mode on level-up, crash-safe). Biome reboot is now a full reset of `lifetimeLe` to 0 (Level 1). Biomes-completed counter added to Biome screen UI. Daily quest roll happens lazily on first open after midnight. Mark/unmark semantics formalized as symmetric LE delta (§ 6.5). Tree-permanence rule documented (trees only plant on a new max-level-reached). New sections: § 6.5 mark/unmark, § 6.6 daily roll, § 6.7 placement flow.
- **v0.3 (21 May 2026)** — Biome reboot replaces old world entirely (no archive). Photo mode locked at Tier 1 (screenshot-only) and added to MVP. Section 5.1 rewritten: "top bar" reframed as three independent floating sticky buttons, with detailed layout deferred to UI build.
- **v0.2 (21 May 2026)** — Confirmed horizontal swipe order. Clarified HJ as combined Habits+Journal screen (habit logging lives inside journal entry UI). Biome capacity capped at 100 trees with reboot-and-dimensional-travel mechanic. Photo mode noted as deferred pending decision; render-layer separation flagged for MVP.
- **v0.1 (21 May 2026)** — Initial design doc. All decisions from planning discussion captured.
