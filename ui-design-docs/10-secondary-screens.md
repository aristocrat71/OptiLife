# OptiLife — Secondary Screens & Overlays (POP)

**Audience:** Flutter engineers. Layout specs for every screen beyond the four core "today" pages. Some of these also exist as Paper mockups (noted ✅ Paper); the rest are spec-only here (the Paper build was paused at the weekly tool limit — visuals to follow). Builds on `05`–`09`.

> Status legend: ✅ Paper = pixel mockup exists on the Paper canvas · ✎ spec-only = build from this spec; mockup pending.

---

## 1. Radial Menu — overlay ✅ Paper
- Trigger: tap `CentralNav`. Scrim `ink @ 45%`; tap-outside closes.
- 6 petals fan **downward** from the heart in an arc (button is top-centre): **Bio · SQ · Task · HJ · Set · Analytics**.
- Petal = 62px circle (`2.5px ink`, `card` shadow) + icon + label below. Colours: Bio green `#7AC974`, SQ `popPurple`, Task `popPink`, HJ `popTeal`, Set deep-ink `#3A3450`, Analytics `hazeDeep` **dimmed @40% ("soon")**.
- Heart re-shown bright with a soft glow ring. Petals spring in staggered (`pop`).
- Action: tap → PageView jump (Bio/SQ/Task/HJ) or push (Set); menu collapses.

## 2. Date Picker — bottom sheet ✅ Paper
- Long-press `CalendarButton`. `PopBottomSheet`, scrim `ink @ 45%`.
- Header `Jump to a day` + month nav (`‹ May 2026 ›`, circular chevrons). Weekday row (`mutedInk`). 6×7 grid, cells 38px.
- **Today/selected** = `popPurple` filled circle, white numeral, `2px ink`. Other days plain. Any day selectable (browsing past is allowed; editing past is not — §read-only).
- Footer: legend dot + `Go to Today` (`energy` button).
- On day tap → set `selectedDateProvider`, close.

## 3. Settings — pushed screen ✅ Paper
- Back coin + `Settings` title. Grouped cards (`paper`, `2.5px ink`, `card` shadow), section labels in `mutedInk` caps.
- **Appearance**: Liquid-fill toggle (teal ON), Journal font (`Handwriting ›` shown in Caveat), Journal alignment (Left/Right segmented).
- **Gameplay**: Side quests per day stepper (`− 3 +`; clamp ≥1).
- **Workshop** prominent `popPurple` card → pushes Workshop.
- **More**: Notifications (toggle, "soon"), Export journal ("soon" ›), About ›.
- Toggles/segmented/stepper per `06-components.md`. Changes write to `settings` immediately (Data Models §4.2).

## 4. Workshop — pushed screen, tabbed ✅ Paper (Quests tab)
- Back coin + `Workshop`. Segmented tab bar **Quests / Habits** (`popPurple` active fill).
- **Quests tab** row: category swatch icon (rounded square, category colour) + title + meta line (`PRESET · Fitness` / `YOURS · Adventure`). Trailing: **presets → on/off toggle** (`isActive`); **user quests → edit pencil**. Deactivated preset row dims @70% with `· hidden` meta.
- **Habits tab** (✎ spec-only): same row pattern; meta `GOOD`/`BAD` (teal/coral tag); user habits editable, trailing edit pencil. (Habits are all user-created — no presets — so every row is editable.)
- FAB `+` (bottom-right) → opens the matching editor sheet for the active tab.
- Swipe-left on a **user** row → Delete (soft-delete: `isActive=false`, Data Models §6; history preserved). Presets can't be deleted, only toggled off.

---

## 5. Quest Editor — bottom sheet ✎ spec-only
`PopBottomSheet`, header `New quest` / `Edit quest`.
```
 ━━━
 New quest                        [Delete]   (edit mode only, user quests)
 ┌────────────────────────────┐
 │ Title…                       │  PopTextField (1–200 chars, required)
 └────────────────────────────┘
 ┌────────────────────────────┐
 │ Description (optional)…       │
 └────────────────────────────┘
 Category
 ( 🧭 Adv ) ( 💪 Fit ) ( 🫂 Soc ) ( 🎨 Cre ) ( 🌙 Night )   ← chips, single-select
 [           SAVE QUEST  ＋            ]
```
- Category chips = `CategoryChip` set, single-select, selected = filled + `2.5px ink`, others outline. **`normal` is NOT shown** (tree-only, Data Models §5).
- Validation: title required → inline shake on empty.
- Save → insert/update `quests` (`source=user`). Editing a preset only allows toggling `isActive` (no field edits) — open as a read-only sheet with just the toggle.

## 6. Habit Editor — bottom sheet ✎ spec-only
Header `New habit` / `Edit habit`.
```
 ━━━
 New habit                         [Delete]
 ┌────────────────────────────┐
 │ Title…                       │
 └────────────────────────────┘
 ┌────────────────────────────┐
 │ Description (optional)…       │
 └────────────────────────────┘
 Type
 ( ✓ Good — log when done )   ( 🛡 Bad — log when avoided )   ← single-select, 2 chips
 ⓘ Habits are daily. Logged = +2⚡.
 [           SAVE HABIT  ＋            ]
```
- Type: two chips, Good (`positive`) / Bad (`coral`), single-select. No recurrence field (always daily, Data Models §4.6).
- Save → insert/update `habits`. Single binary toggle at log time (no slip; §6.5).

## 7. Add/Edit Task — bottom sheet ✎ spec-only (mock pattern in `03-tasks.md §4`)
Header `New task` / `Edit task`.
```
 ━━━
 New task                          [Delete]
 ┌────────────────────────────┐  Title… (1–300, required)
 ┌────────────────────────────┐  Notes (optional)…
 Due:  ╭ 📅 Today ▾ ╮             ← defaults to selectedDate; freely changeable incl. future
 [           ADD TASK  ＋             ]
```
- Due date picker reuses the Date Picker sheet (or a compact inline). **Future allowed** (planning is the point, §6.3).
- Hard-delete (no downstream refs, Data Models §4.8).

## 8. Journal Font/Alignment — bottom sheet ✎ spec-only
Triggered by `✎ font ▾` on the Journal header (also mirrored in Settings).
```
 ━━━
 Journal style
 Font
 ( Handwriting — Caveat )   ( Formal — Lora )     ← preview text in each chip's own font
 Alignment
 ( Left )  ( Right )
 ⓘ Applies to all entries.
```
- Writes `settings.journalFont` / `journalAlignment` (global, not per-entry — Data Models §4.9). Live-preview the journal body behind the sheet.

---

## 9. Level-Up — full-screen celebration ✎ spec-only
Blocks input; appears when a mark/log crosses a 50-LE boundary (Data Models §7.1 step 8 / §7.3).
```
        ✦   LEVEL UP!   ✦
            ╭───────╮
            │  LV 5 │        ← numXL on popPurple hero gradient (rare gradient)
            ╰───────╯
   A {Adventure} tree is ready 🌳
   ( category-colour confetti burst )
        tap to place it
```
- Hero card `AppShadows.hero`, category-colour `ConfettiBurst`.
- Auto-advance ~1.4s or tap → transitions into **Tree Placement** (§10).
- Normal-tree case (habit level-up, no quests in window): copy "A new tree is ready 🌳", neutral `catNormal` styling (Data Models §7.8).

## 10. Tree Placement mode — Biome locked ✎ spec-only (lives on Biome)
- `appState.pendingTreeCategory != null` → hard lock (§07 §3.1). Crash-safe resume.
```
 ┌──────────────────────────────────────────────┐
 │  🌳 PLACE YOUR ADVENTURE TREE                  │  ← banner (category-tinted)
 │  Tap a spot in your biome                      │
 └──────────────────────────────────────────────┘
   ( grid cells shimmer; ghost tree follows finger;
     occupied/invalid cells show soft ✕ )
   everything else (shell, swipe, menu) DIMMED & inert
```
- Plant = bouncy squash-settle + dust puff + category burst; inserts `trees` row (`positionX/Y`, `category`, `levelAtPlanting`); clears `pendingTreeCategory`; lock releases.
- If this is the 100th tree → chain into Reboot prompt (§11).

## 11. Biome Reboot — prompt + dimensional travel ✎ spec-only
```
        ╭──────────────────────────────╮
        │   🌍 YOUR WORLD IS FULL       │
        │   100 trees planted!          │
        │   Reboot starts a fresh world.│
        │   LE & trees reset; history   │
        │   is kept.                    │
        │  ╭ Not yet ╮   ╭ REBOOT 🚀 ╮  │
        ╰──────────────────────────────╯
```
- `REBOOT` is destructive (`coral` confirm, explicit tap) → transaction (Data Models §7.6): `lifetimeLe→0`, level→1, trees deleted, `biomesCompleted += 1`.
- **Dimensional-travel** animation (`travel` 1400ms): warp/zoom into a purple→pink→teal swirl tunnel → fresh empty grid; liquid drains; `WORLD n+1` HUD ticks up.
- `Not yet` dismisses; prompt re-surfaces on next Biome visit while full.

---

## 12. State variants ✎ spec-only (rules in `07 §3–4`; per-screen in `01`–`04`)
For each, the same screen with global modifiers applied:
| Variant | Key visual deltas |
|---|---|
| **Past (read-only)** | controls → `surfaceSunk`, `1.5px catNormal`, no shadow; actions inert (tap = shake); `👀 Read-only · past day` ribbon; SQ shows outcomes only, no reroll; Tasks no FAB; Journal static badges + read-only body |
| **Future** | Tasks fully editable + `🗓 Planning ahead`; SQ/Journal/Habits → friendly empty "opens on the day" |
| **Empty (today)** | SQ: no active pool → Workshop shortcut; Tasks: "nothing on the list" + FAB; Journal: faded prompt / "add habits"; Biome: first-sprout prompt |
| **Reroll disabled** | button `surfaceSunk`; tap → shake + tooltip with the blocking reason (already used / completion exists / <10⚡) |
| **Loading / first launch** | POP splash (logo + heartbeat) during seed; per-provider skeleton shimmer in card shapes (`hazeDeep`), never a bare spinner |

---

## 13. Build status (Paper canvas)
✅ Mocked: Side Quests, Biome, Tasks, Journal+Habits, Radial Menu, Date Picker, Settings, Workshop (Quests tab).
✎ Pending mockup (spec complete above): Workshop Habits tab, Quest/Habit/Task editors, Journal font sheet, Level-Up, Tree Placement, Reboot, state variants. These will be added to the canvas when the Paper tool budget resets — none block development, as each is fully specced here + in `06`/`07`/`08`.
