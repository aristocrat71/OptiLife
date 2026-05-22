# Journal + Habits (JH) Screen — UI Design (POP Theme)

**Foundation:** see `00-design-system.md`.
**Backed by:** Design Doc §4.1/§4.4, §5.3, §6.2/6.3, §6.5, §7, §8.4, §10 (open Q) · Data Models §4.6/4.7/4.9, §7.3/7.4

> One combined screen. **Habit logging lives *inside* the journal entry experience** — there is no separate habits screen (Design Doc §5.3, §10). Reached by swiping right from Tasks (`Tasks → Journal`) or the **HJ** radial petal. One journal entry per day (`journal_entries.date` UNIQUE).

This is the trickiest screen: it earns LE (habits drip +2), it owns the custom-typography signature, and it has the vertical-scroll-vs-day-change conflict (Design Doc §8.4).

---

## 1. Purpose & Behaviors

- **Habits strip:** log today's active habits (good = done, bad = avoided). Each successful log = **+2 LE** with full meter/level/tree consequences (Data Models §7.3/7.4). Bad-habit *slip* = `done`, **0 LE**.
- **Journal body:** one free-form entry per day, with user-chosen font (`handwriting`/`formal`) & alignment (`left`/`right`) from `settings` (Design Doc §7, Data Models §4.9).
- **Date-aware:** today editable; past read-only; future empty.
- **Scroll model:** inner scroll = journal body; outer past-edge drag = day change (`NestedScrollView`, ~80–100px threshold — Design Doc §8.4).

---

## 2. Layout — Today

```
┌──────────────────────────────────────────────────────────┐
│   ( ⚡4 )           ( ♥ )              ( 📅 )               │  ← shell (circular)
│                    · Today ·                               │
│   TODAY'S HABITS                              +6⚡ logged   │
│   ╭────────────╮ ╭────────────╮ ╭────────────╮            │
│   │ 💧 Water    │ │ 🚭 No soda │ │ 📵 No phone │   …       │  ← habit chips
│   │  good       │ │  bad       │ │  bad        │            │     (horizontal
│   │ ╭────────╮  │ │ ╭────────╮ │ │ ╭────────╮  │            │     scroll)
│   │ │  DONE  │  │ │ │AVOIDED │ │ │ │AVOIDED │  │            │  each = ONE
│   │ ╰────────╯  │ │ ╰────────╯ │ │ ╰── outline╯  │          │  binary toggle
│   ╰────────────╯ ╰────────────╯ ╰────────────╯            │
│                                                            │
│   JOURNAL · Thursday 22 May                  ✎ font ▾      │
│   ╭──────────────────────────────────────────────╮       │
│   │                                                │       │
│   │  Today I finally went for that swim and it     │       │  ← inner
│   │  felt incredible. The water was freezing but   │       │     scroll,
│   │  I stayed in for twenty whole minutes...       │       │     user font
│   │                                                │       │     + alignment
│   │  ▌                                             │       │
│   │                                                │       │
│   ╰──────────────────────────────────────────────╯       │
│            ◗ ─ ─ ─ ●        ← page dots (Journal active)    │
└──────────────────────────────────────────────────────────┘
```

---

## 3. Habits Strip (top region)

A horizontally scrolling row of **habit chips** for all `is_active` habits (Data Models §4.6, query §8). Sits above the journal so logging feels like "checking in" before you write.

### Habit chip
| Element | Spec |
|---|---|
| Surface | `--paper`, `--r-md`, `--stroke`, `3px 3px 0` shadow, ~120px wide |
| Type badge | Small pill: **good** in `--pop-teal`, **bad** in `--pop-coral` |
| Title | Body 600 + emoji glyph |
| **Action** (good habit) | Single binary toggle `DONE`. Unlogged = outline; logged = `--positive` fill + check, `+2⚡` flies to meter |
| **Action** (bad habit) | Single binary toggle `AVOIDED`. Unlogged = outline; logged = `--positive` fill + shield, `+2⚡` flies to meter |
| Logged look | Filled, tiny ⚡+2 badge in corner |

> **One toggle per habit — no tri-state.** Good habits toggle *Done*, bad habits toggle *Avoided*. The only states are **logged** (the positive action, +2⚡) and **not logged** (neutral, 0). There is no separate "slip" action — a bad habit you didn't avoid is just left untoggled.

### Logging mechanics (Data Models §7.3/7.4)
- Tap to log → insert `habit_log` (`status` = `done` for good / `avoided` for bad, `leAwarded` = 2). Tap again to **unlog** → delete row, reverse LE.
- `+2` chip flies to the LE meter on log; `−2` on unlog.
- One log per `(habit, date)` — the chip *is* the toggle.
- A habit log can trigger **level-up** (Design Doc §6.5) → same LEVEL UP pop → Biome **placement mode** (Normal tree if no quests in window — Data Models §7.8). Whole screen locks during placement.
- Strip header right-side mini-stat: `+N⚡ logged` today (sum of LE from habit logs).

### No active habits
- Strip collapses to a slim prompt: "No habits yet — add some in Settings → Workshop." with a shortcut chip. Journal still fully usable.

---

## 4. Journal Body (main region)

- One entry per day; autosaves to `journal_entries.body` (debounced) — no explicit save button (the entry row is upserted; `date` is UNIQUE).
- **Typography honors `settings`** (Design Doc §7):
  - Font: `handwriting` (Caveat, larger, warmer) or `formal` (Lora).
  - Alignment: `left` or `right`.
- Inline **`✎ font ▾`** control top-right of the journal header = quick access to the same font/alignment toggles (writes through to `settings`, so it's global — a small note clarifies "applies to all entries").
- Section header shows the full date (`Thursday 22 May`) so the entry feels diary-like.
- Placeholder when empty: faded prompt in the chosen font — "What happened today?".
- Paper texture: very subtle dot-grid or ruled lines behind the text (POP-flavored, low contrast) to read as a page.

---

## 5. The Scroll Conflict (Design Doc §8.4)

Two scroll intents share this screen; resolved with `NestedScrollView`:

| Gesture | Result |
|---|---|
| Scroll **within** the journal body | Scrolls the entry text (inner scrollable) |
| Drag **past the top edge** ~80–100px | **Day change → previous day** (outer scrollable) |
| Drag **past the bottom edge** ~80–100px | **Day change → next day** |

- **No textual hint ribbons** ("pull for yesterday/tomorrow" labels are intentionally omitted). The only feedback is a **rubber-band stretch** of the content + a little tug haptic at the trigger point — the motion itself is the affordance.
- Threshold value to be tuned on a real device (Design Doc §8.4, Open Questions); start at ~90px past-edge.
- Day change animates the whole screen content with a vertical page-turn-ish slide so the direction is legible.

---

## 6. Date-dependent states

### Today (default)
Full logging + writing, as above.

### Past date — read-only (Design Doc §6.2)
- Habit chips show that day's logged outcomes as **static badges** (`✓ done` / `🛡 avoided` / `slip`), non-interactive, flattened to `--surface-sunk`.
- Journal body is **read-only** — text shown in the chosen font, no caret, no edits.
- "👀 Read-only · past day" ribbon. Day-change scroll still works (you can browse history).

### Future date (Design Doc §6.3 — empty)
- Habits can't be logged in advance, journal can't be written ahead → unified empty state:
```
            ╭───────────────────────╮
            │        🌅 ✨           │
            │  Habits & journal      │
            │  open up on the day.   │
            │  See you then!         │
            ╰───────────────────────╯
```
- Day-change scroll still works to navigate back.

---

## 7. Empty / first-time states

| Case | Treatment |
|---|---|
| Today, blank entry, habits unlogged | Habit chips await taps; journal shows faded "What happened today?" prompt |
| No active habits | Strip → "Add habits in the Workshop" prompt; journal unaffected |
| Past day with no entry & no logs | "Nothing was logged this day." quiet state |

---

## 8. Motion summary

| Moment | Motion |
|---|---|
| Log good habit (DONE) | Chip fills `--positive`, check draws on, `+2⚡` flies to meter |
| Log bad habit (AVOIDED) | Chip fills `--positive`, shield draws on, `+2⚡` flies up |
| Unlog | Reverse fill, `−2⚡` to meter |
| Habit-driven level-up | LEVEL UP pop → Biome placement (Normal tree if no quests) |
| Near scroll threshold | Rubber-band stretch + tug haptic (no text ribbon) |
| Day change | Vertical slide of content; new day's habits + entry land |
| Typing | Autosave (silent, debounced); tiny "saved ✓" flicker occasionally |
```
