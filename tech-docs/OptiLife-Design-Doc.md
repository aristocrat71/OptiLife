# OptiLife — Design Document

**Status:** v0.3 (locked decisions, pre-implementation)
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

- **Trigger:** Every level-up plants exactly one tree in the biome.
- **Tree type:** Determined by the **category of the majority of quests completed since the last level-up**.
- **Tiebreaker:** Most recent quest's category wins.
- **Categories → tree types:**

| Category | Tree / Plant Type |
|---|---|
| Adventure | Wild, untamed tree |
| Fitness | Strong oak |
| Social | Flowering tree |
| Creative | Rare glowing plant |
| Night | Moonlit plant |

(Exact visual assets TBD during art pass.)

The biome is **cumulative and date-agnostic** — it represents the current state of the user's "world" and does not retroactively change when the user views past dates.

**Biome capacity & reboot:** Each biome holds **100 trees** total. On planting the 100th tree, the user is prompted to **Reboot Biome** — confirming triggers a "dimensional travel" animation and starts a fresh, empty grid. Previous biomes are **replaced, not archived** — the old trees are gone and a new world begins.

### 4.4 Entity Definitions

- **Side Quest** — Special, often one-off, category-tagged. Sources: curated preset DB + user-created via Workshop. Full LE reward.
- **Habit** — Recurring (daily/weekly), user-defined. Small LE drip. Can be good (log when done) or bad (log when avoided).
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
- **Habits** — create, edit, delete; mark as good/bad; set recurrence.

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

## 9. Data Model (Outline — Full Schema TBD)

High-level entities to be detailed in the data model document:

- **User** (single row — preferences, settings, current LE total)
- **Quest** (id, title, description, category, source: preset/user, is_active)
- **QuestCompletion** (id, quest_id, completed_at)
- **Habit** (id, title, type: good/bad, recurrence)
- **HabitLog** (id, habit_id, logged_at, status)
- **Task** (id, title, due_date, completed_at)
- **JournalEntry** (id, date, body, font_preference, alignment)
- **Tree** (id, type, planted_at, position_in_biome)

Every entity will carry `uuid`, `created_at`, `last_modified`.

---

## 10. Open Questions / To Review

- **Journal screen design** — habit logging is integrated *into* the journal entry experience, not a separate screen. Exact UX needs design work: where habit checkboxes live relative to the entry text, how they behave on past/future dates, visual hierarchy.
- **Tree visual assets** — need to settle on art style and produce the 5 tree types.
- **Preset quest list** — need to write the curated quest pool (target: ~50–100 quests across the 5 categories).
- **Vertical scroll threshold tuning** — pick exact px value once tested on device (target ~80–100px past-edge drag).
- **Top controls visual layout** — finalize sizing, spacing, and styling of the three floating sticky buttons during UI build.

---

## 11. Changelog

- **v0.3 (21 May 2026)** — Biome reboot replaces old world entirely (no archive). Photo mode locked at Tier 1 (screenshot-only) and added to MVP. Section 5.1 rewritten: "top bar" reframed as three independent floating sticky buttons, with detailed layout deferred to UI build.
- **v0.2 (21 May 2026)** — Confirmed horizontal swipe order. Clarified HJ as combined Habits+Journal screen (habit logging lives inside journal entry UI). Biome capacity capped at 100 trees with reboot-and-dimensional-travel mechanic. Photo mode noted as deferred pending decision; render-layer separation flagged for MVP.
- **v0.1 (21 May 2026)** — Initial design doc. All decisions from planning discussion captured.
