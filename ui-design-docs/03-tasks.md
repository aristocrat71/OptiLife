# Tasks Screen — UI Design (POP Theme)

**Foundation:** see `00-design-system.md`.
**Backed by:** Design Doc §3.1, §4.4, §6.1/6.2/6.3 · Data Models §4.8, §7 (no LE flow — tasks are inert)

> Plain life-admin. **No LE, no biome impact** (Design Doc §4.4). The calm utility corner of the app — still POP, but quieter: fewer bursts, no confetti. Reached by swiping right from Side Quests (`SQ → Tasks`), or the **Task** radial petal.

---

## 1. Purpose & Behaviors

- Show tasks scoped to the **currently-selected date** (`tasks.dueDate`, Data Models §4.8).
- Create / edit / complete / delete tasks.
- Completing a task sets `completedAt`; it awards **0 LE** — the meter does not react.
- Date rules differ from every other screen: **future dates are fully editable** (forward planning is the whole point — Design Doc §6.3). Past dates remain read-only.

---

## 2. Layout — Today / editable day

```
┌──────────────────────────────────────────────────────────┐
│ ╭ ⚡▓▓▓░░ Lv4 ╮       ( ♥ )           ╭ 📅 ╮               │  ← shell
│                    · Today ·                               │
│                                                            │
│   TASKS                                    1 of 4 done     │
│   ─────                                                    │
│                                                            │
│   ╭──────────────────────────────────────────────╮       │
│   │ ▢  Buy groceries                               │       │
│   ╰──────────────────────────────────────────────╯       │
│   ╭──────────────────────────────────────────────╮       │
│   │ ▢  Call the dentist                            │       │
│   │     reschedule cleaning                        │       │  ← optional
│   ╰──────────────────────────────────────────────╯       │     description
│   ╭──────────────────────────────────────────────╮       │
│   │ ▢  Pay electricity bill                        │       │
│   ╰──────────────────────────────────────────────╯       │
│                                                            │
│   ✓ DONE (1)                                               │
│   ╭──────────────────────────────────────────────╮       │
│   │ ☑  Water the plants                  (struck)  │       │
│   ╰──────────────────────────────────────────────╯       │
│                                                            │
│                                              ╭─────╮       │
│                                              │  ＋ │       │  ← FAB
│                                              ╰─────╯       │
│            ◗ ─ ─ ● ─        ← page dots (Tasks active)      │
└──────────────────────────────────────────────────────────┘
```

---

## 3. Task Row

Deliberately calmer than a quest card — these are utility, not reward.

| Element | Spec |
|---|---|
| Surface | `--paper`, `--r-md`, `--stroke` (thinner feel via tighter padding), `3px 3px 0` shadow |
| **Checkbox** | Chunky rounded square, `--ink` outline. Checked = `--pop-purple` fill (NOT teal/`--positive` — reserve teal for LE-earning completions so tasks read as "no reward") with a bouncy check draw-on |
| Title | Body 600, ink. Optional description line below, muted |
| Completed look | Checkbox filled, title gets a strike-through, row fades to ~70% and moves into a **"✓ DONE (n)"** collapsed group below the active list |
| Row tap | Opens edit sheet; checkbox tap toggles complete (separate hit zones) |
| Swipe-left | Reveals a `🗑 Delete` action in `--negative` (hard-delete — no downstream refs, Data Models §4.8) |

**No LE chip, no confetti.** Completing gives only a quiet check animation + a soft tick — explicitly signaling "this doesn't feed the meter."

---

## 4. Add / Edit Task (bottom sheet)

FAB `＋` (bottom-right, `--pop-pink`) → bottom sheet:

```
        ╭──────────────────────────────────╮
        │  ━━━                              │
        │  NEW TASK                          │
        │  ╭──────────────────────────────╮ │
        │  │ Title…                        │ │
        │  ╰──────────────────────────────╯ │
        │  ╭──────────────────────────────╮ │
        │  │ Notes (optional)…             │ │
        │  ╰──────────────────────────────╯ │
        │  Due:  ╭ 📅 Today ▾ ╮               │
        │                                    │
        │            ╭──────────────────╮    │
        │            │   ADD TASK ＋     │    │
        │            ╰──────────────────╯    │
        ╰──────────────────────────────────╯
```

- **Due date** defaults to the currently-selected date but is freely changeable (incl. future) — this is the one place future planning is encouraged.
- Editing an existing task reuses the sheet, header `EDIT TASK`, with a `Delete` text-button.
- Validation: title required (1–300 chars, Data Models §4.8); inline shake if empty.

---

## 5. Date-dependent states

### Today (default)
Full CRUD, as above.

### Future date (Design Doc §6.3 — **editable!**)
- Identical full CRUD. A small `🗓 Planning ahead` ribbon under the date display reassures the user this is intentional.
- This is the deliberate exception to the "future = empty" rule that SQ/Journal follow.

### Past date (read-only — Design Doc §6.2)
- Rows flatten to `--surface-sunk`, 1.5px slate outline, no shadow.
- Checkboxes become static state indicators (`☑` done / `▢` not done) — non-interactive.
- FAB hidden; swipe-delete disabled. "👀 Read-only · past day" ribbon shown.

---

## 6. Empty states

| Case | Treatment |
|---|---|
| No tasks for the day (editable date) | Friendly empty illustration + "Nothing on the list — enjoy it, or tap ＋ to add something." FAB stays prominent |
| No tasks for a past date | Quiet: "No tasks logged this day." (no FAB) |
| All tasks done | Active list empty; "✓ DONE (n)" group holds them; small "All clear ✨" line (no confetti — keep it calm) |

---

## 7. Header & counter

- Title `TASKS`, display face, underline accent in `--pop-purple`.
- Top-right `X of N done` counter with a thin segmented bar (mirrors SQ for consistency, but in purple not yellow — no energy semantics).

---

## 8. Motion summary

- Add: row drops in `easeOutBack`.
- Complete: bouncy check draw-on + row fades & slides into DONE group.
- Delete: swipe reveal → row collapses height to 0.
- Sheet: rises with `6px 6px 0` hero shadow.
- **No** LE chips, **no** confetti, **no** meter reaction anywhere on this screen — by design.
```
