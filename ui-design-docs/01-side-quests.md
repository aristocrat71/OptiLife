# Side Quests Screen — UI Design (POP Theme)

**Foundation:** see `00-design-system.md` for tokens, the always-on shell, and shared components.
**Backed by:** Design Doc §3.1, §4.1, §6.2/6.3, §6.6 · Data Models §4.3–4.5, §7.1/7.2/7.7

> **Landing screen** of the app (Design Doc §5.2). This is where the core loop starts: roll → do it offline → mark → ⚡ LE → level → tree.

---

## 1. Purpose & Behaviors

- Show **today's rolled quests** (`daily_quest_rolls` joined with `quest_completions` for done-state).
- Mark / unmark today's quests → ±10 LE, immediate meter response (Data Models §7.1/7.2).
- **Random roller** & **Reroll** (1/day, costs 10 LE, gated — Design Doc §6.6).
- Respect global date: past = read-only, future = empty (quests are in-the-moment).

---

## 2. Layout — Today (the happy path)

```
┌──────────────────────────────────────────────────────────┐
│ ╭ ⚡▓▓▓░░ Lv4 ╮       ( ♥ )           ╭ 📅 ╮               │  ← shell
│                    · Today ·                               │
│                                                            │
│   SIDE QUESTS                              🎲 quests       │
│   ──────────                               2 of 3 done     │
│                                                            │
│   ╭──────────────────────────────────────────────╮       │
│   │ 🧭 ADVENTURE                            +10 ⚡ │       │
│   │ Go explore a street you've never walked        │       │
│   │                                      ╭───────╮ │       │
│   │                                      │ MARK  │ │       │
│   │                                      ╰───────╯ │       │
│   ╰──────────────────────────────────────────────╯       │
│                                                            │
│   ╭──────────────────────────────────────────────╮       │
│   │ 💪 FITNESS                          ✓ DONE     │       │
│   │ Do 50 pushups                                  │       │
│   │  ▓▓▓▓▓▓▓▓▓▓ (filled / teal wash)      undo ↺   │       │
│   ╰──────────────────────────────────────────────╯       │
│                                                            │
│   ╭──────────────────────────────────────────────╮       │
│   │ 🎨 CREATIVE                         ✓ DONE     │       │
│   │ Draw something for 10 minutes          undo ↺  │       │
│   ╰──────────────────────────────────────────────╯       │
│                                                            │
│   ╭────────────────────────────────────────╮             │
│   │  🎲  REROLL TODAY'S QUESTS   · 1 left · -10⚡│        │
│   ╰────────────────────────────────────────╯             │
│                                                            │
│            ●  ◗ ─ ─ ─        ← page dots (SQ active)        │
└──────────────────────────────────────────────────────────┘
```

---

## 3. Quest Card

Each card = one rolled quest. The card is **category-colored** — that's the whole personality.

| Element | Spec |
|---|---|
| Surface | `--paper`, `--r-lg`, `--stroke`, `4px 4px 0` pop shadow |
| **Category band** | Left edge 8px stripe in the category color + glyph + ALL-CAPS category label chip top-left |
| Title | Fredoka 600, 18px, ink. Description line below in body font, muted ink |
| **Reward chip** | `+10 ⚡` pill in `--energy`, top-right (pending state) |
| Action | **MARK** primary button (category-tinted fill) bottom-right |

### States
- **Pending:** full color, shadow raised, MARK button active.
- **Pressing MARK:** card squishes; a **category-colored confetti burst** fires; the done-wash sweeps across; LE chip `+10` flies up to the meter (top-left); meter fill animates.
- **Done:** card gets a teal/category translucent wash + `✓ DONE` badge; MARK becomes a small **undo ↺**; corner gets a little folded "sticker" dog-ear.
- **Unmark (undo):** reverse animation, `−10` chip flies to meter in `--negative`; card returns to pending.

### Level-up from a mark
If the mark crosses a level boundary (Data Models §7.1 step 8): instead of returning control, the app fires a **LEVEL UP!** full-screen pop and transitions into Biome **placement mode** (see `02-biome.md`). The SQ screen is then locked until the tree is placed.

---

## 4. Header & Roll Counter

- Screen title `SIDE QUESTS` in display face, with a thick underline accent in `--pop-purple`.
- Top-right mini-stat: 🎲 + `X of N done` progress, where N = `settings.questsPerDay` (default 3). A tiny segmented progress bar under it (one segment per quest, fills as done).

---

## 5. Reroll Control

A wide pill button pinned below the list (Design Doc §6.6, Data Models §7.7). **Always visible**, disabled with a reason when blocked.

| Condition | Button state | Copy / tooltip |
|---|---|---|
| Eligible | Active, `--pop-yellow` fill, dice icon | `🎲 REROLL · 1 left · −10⚡` |
| Already rerolled today | Disabled, `--surface-sunk` | "Come back tomorrow — 1 reroll a day 🎲" |
| A quest already completed today | Disabled | "Unmark all of today's quests to reroll" |
| LE in current level < 10 | Disabled | "Need 10⚡ in this level to reroll" |
| Past / future date | Hidden | — |

- On disabled tap: button shakes, an info tooltip-toast pops with the contextual reason.
- On successful reroll: cards **shuffle out** (cards fly off with a spin) and the fresh roll **deals in** like cards from a deck, `easeOutBack`, staggered. `−10` chip flies to the meter.

---

## 6. Date-dependent states

### Past date (read-only — Design Doc §6.2)
- Shows that day's roll + completion outcome, all flattened to `--surface-sunk`, 1.5px slate outline, no shadows.
- MARK/undo replaced by static read-only badges (`✓ done` / `— not done`).
- Reroll hidden. "👀 Read-only · past day" ribbon shown (from shell).
- Days the user never opened the app have **no roll** → show a gentle empty state: "No quests were rolled this day."

### Future date (Design Doc §6.3)
- Quests are in-the-moment → **empty state**:

```
            ╭───────────────────────╮
            │        🎲 ✨           │
            │  Quests roll fresh     │
            │  on the day itself.    │
            │  Come back then!       │
            ╰───────────────────────╯
```

### Pool fallback (Data Models §4.5)
- If `questsPerDay` > active pool size, fewer cards appear — no error. The roll counter just reads the smaller N (e.g. `1 of 2 done`).

---

## 7. Empty / edge states

| Case | Treatment |
|---|---|
| No active quests at all in pool | Empty state: chunky illustration + "Your quest pool is empty — add some in the Workshop (Settings → Workshop)." with a shortcut button |
| All today's quests done | Celebratory banner at top: "All quests cleared! 🎉" + soft confetti; cards stay in done state |
| Fresh new day, just rolled | Cards "deal in" staggered on first view (lazy roll happened — Data Models §4.5) |

---

## 8. Motion summary

- Card deal-in / shuffle: staggered `easeOutBack`.
- Mark: squish + category confetti + LE chip flight + meter fill.
- Reroll: deck shuffle out / deal in.
- Disabled control: horizontal shake (×2, 6px).
- Level-up: handoff to full-screen LEVEL UP pop → Biome placement.
```
