# Biome Screen — UI Design (POP Theme)

**Foundation:** see `00-design-system.md`.
**Backed by:** Design Doc §3.1, §4.3, §6.7, §7 · Data Models §4.1, §4.10, §7.5/7.6/7.8

> The reward screen. A cartoon **2.5D isometric** world (Flame engine) where every level-up plants a tree. **Date-agnostic** — vertical date scroll is disabled here (Design Doc §5.4). Reached by swiping left from Side Quests, or via the **Bio** radial petal.

---

## 1. Purpose & Behaviors

- Render the current biome: all `trees` rows as isometric sprites at their user-picked `(x, y)`.
- Show progression context: current world number (`biomesCompleted`), tree count / capacity (… / 100).
- Host **tree placement mode** (the only interactive game state here).
- Host **Photo mode (Tier 1)** — screenshot-only (Design Doc §3.1).
- Host the **Reboot Biome** flow at 100 trees (Design Doc §4.3, Data Models §7.6).

The Flutter chrome (overlays, buttons, banners) is what this doc specifies; the sprite/terrain art is the Flame layer (TBD art pass).

---

## 2. Layout — Normal browsing

```
┌──────────────────────────────────────────────────────────┐
│ ╭ ⚡▓▓▓░░ Lv4 ╮       ( ♥ )           ╭ 📅 ╮               │  ← shell
│                                                            │
│   ╭─ WORLD 3 ─╮                          ╭────────╮        │
│   │ 🌳 23/100 │                          │  📷    │        │  ← photo btn
│   ╰───────────╯                          ╰────────╯        │
│                                                            │
│         (isometric biome canvas — Flame)                   │
│              🌳     🌲                                      │
│           🌳    🌸      🌳                                  │
│         ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲  ground tiles                    │
│              🌙        🪵                                   │
│           🌳     🌲                                         │
│                                                            │
│                                                            │
│                                                            │
│         ◗ ─ ●(🌳) ─ ─        ← page dots (Biome active)     │
└──────────────────────────────────────────────────────────┘
```

- Date ribbon under the calendar is **hidden / greyed** here (biome ignores date). The calendar button itself still works (jump to today / picker) since it's part of the global shell.
- Vertical date-scroll gesture is disabled; vertical drag instead **pans** the biome canvas (within bounds). Pinch to zoom (gentle clamp).

---

## 3. World HUD (top-left, under LE meter)

A small stacked POP card cluster:
- **`WORLD N`** chip — `N = biomesCompleted + 1` — in `--pop-purple`, the long-term trophy (Design Doc §4.3).
- **`🌳 23/100`** capacity chip — tree count vs the 100-tree cap, with a thin ring/progress that fills as the world fills.
- Optional sub-line: `2 worlds completed` once `biomesCompleted ≥ 1`.

---

## 4. Photo Mode — Tier 1 (top-right)

Screenshot-only (Design Doc §3.1, §3.2 defers pan/zoom/filters).

Flow:
1. Tap 📷 → all floating shell controls (LE meter, nav circle, calendar, HUD, page dots) **fade out** with a quick pop.
2. A clean capture of the current biome view is taken and saved to the device gallery.
3. A toast pops: "Saved to gallery 📸"; controls fade back in.

No crop/pan/filter UI in Tier 1 — keep it one tap.

---

## 5. Tree Placement Mode (the hero interaction)

Triggered by **any** level-up (quest mark or habit log crossing a boundary — Design Doc §6.5, §6.7; Data Models §7.1 step 8, §7.5). Driven by `app_state.pendingTreeCategory`.

### 5.1 Entry
- Full-screen **LEVEL UP!** pop card first: big `LV 5` numeral, `--pop-purple` hero gradient (one of the rare gradient moments), burst confetti in the pending category's color, copy: "A {Adventure} tree is ready to plant 🌳".
- Card dismisses (tap / auto after ~1.4s) into placement mode on the biome canvas.

### 5.2 Placement UI
```
┌──────────────────────────────────────────────────────────┐
│   ╭──────────────────────────────────────────────╮       │
│   │  🌳 PLACE YOUR ADVENTURE TREE                  │       │  ← banner
│   │  Tap a spot in your biome                      │       │     (locked)
│   ╰──────────────────────────────────────────────╯       │
│                                                            │
│      (biome canvas — valid tiles gently highlighted)       │
│           ✦ ✦ ✦                                            │
│        ✦  [ghost 🌳 follows finger ]  ✦                    │
│           ✦ ✦ ✦                                            │
│                                                            │
│   the rest of the shell is DIMMED & non-interactive        │
└──────────────────────────────────────────────────────────┘
```

- **Hard lock** (Design Doc §6.7, §7.4): the only valid input is a tap on a valid biome tile. LE meter, nav circle, calendar, swipe, settings — all dimmed (`--surface-sunk`, flat) and inert. Backdrop outside the canvas dims slightly.
- A persistent banner at top names the tree category (colored to match) and instructs "Tap a spot in your biome".
- A **ghost tree sprite** in the pending category follows the finger / hover; valid tiles shimmer; invalid/occupied tiles show a soft ✕.
- On tap: tree **drops in with a bouncy squash-and-settle** + a small dust puff + category burst; row inserted (`positionX/Y`, `category`, `levelAtPlanting`); `pendingTreeCategory` cleared; lock releases; shell controls pop back in.

### 5.3 Crash-safe resume (Data Models §7.5)
- If the app reopens with `pendingTreeCategory` non-null, it boots **straight into** placement mode on the Biome screen — same banner, same lock. No data lost.

### 5.4 Level-down (no placement)
- Unmarking / unlogging that crosses a boundary downward (Data Models §7.2/7.4): the **most recently planted tree** simply uproots with a quick reverse-pop and vanishes. No placement step. Brief toast: "Level down — newest tree removed."

### 5.5 Normal-tree case
- Habit-driven level-up with no quests in the window plants a **Normal** tree (`--cat-normal`, plain) — banner reads "Place your tree 🌳" with neutral styling (Data Models §7.8). Honest visual record of habit grind.

---

## 6. Reboot Biome (100th tree)

On planting the **100th** tree (Design Doc §4.3, Data Models §7.6):

1. Placement completes as normal, then a **REBOOT?** hero sheet rises:
```
        ╭──────────────────────────────────╮
        │   🌍 YOUR WORLD IS FULL            │
        │   100 trees planted!               │
        │                                    │
        │   Reboot starts a fresh, empty     │
        │   world. Your LE & trees reset,    │
        │   but your history is kept.        │
        │                                    │
        │   ╭────────────╮  ╭────────────╮  │
        │   │  Not yet   │  │  REBOOT 🚀 │  │
        │   ╰────────────╯  ╰────────────╯  │
        ╰──────────────────────────────────╯
```
2. **Not yet:** dismiss; user keeps browsing the full world (can reboot later — prompt re-surfaces on next visit).
3. **REBOOT 🚀** (destructive, `--pop-coral` confirm, requires the explicit tap): runs the transaction (`lifetimeLe→0`, `level→1`, all trees deleted, `biomesCompleted += 1`).
4. **Dimensional-travel animation** — the signature moment: the world warps/zooms into a swirl (purple→pink→teal gradient tunnel), then settles on a fresh empty grid. `WORLD N` HUD ticks up. Liquid fill drains to empty.

> Reboot is a full reset of LE/trees only — quests, habits, journal, tasks, and `lastRerollDate` are preserved (Data Models §7.6).

---

## 7. Empty biome state

- Fresh world (Level 1, 0 trees): empty isometric ground with a soft prompt: "Complete a side quest to grow your first tree 🌱" + a subtle arrow hint toward the SQ screen (swipe right).

---

## 8. Motion summary

| Moment | Motion |
|---|---|
| Enter screen | Canvas eases in, trees gently re-settle |
| Level-up | Full-screen LEVEL UP pop → placement |
| Ghost tree | Follows finger, valid tiles shimmer |
| Plant | Bouncy squash-settle + dust + category burst |
| Level-down | Reverse-pop uproot + toast |
| Photo | Controls fade out → capture → fade in + toast |
| Reboot | Dimensional-travel warp tunnel → empty grid |
```
