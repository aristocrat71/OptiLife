# OptiLife — UI Design System (POP Theme)

**Status:** v1.0 (UI foundations)
**Companion to:** `tech-docs/OptiLife-Design-Doc.md`, `tech-docs/Optilife Data Models.md`
**Theme:** POP — bold, candy-bright, high-contrast, chunky rounded shapes, thick outlines, playful drop shadows. Think pop-art meets cozy game UI.

> This file is the shared foundation. Each screen file (`01`–`04`) builds on the tokens, components, and the always-on shell defined here. Read this first.

---

## 1. POP Theme — Mood & Principles

The whole app should feel like a **bright, friendly arcade you actually want to open when nothing needs doing** (Design Doc §2). The POP language delivers that with:

1. **Loud, saturated color** used confidently — flat color blocks, not subtle gradients (gradients reserved for hero moments: liquid fill, level-up, reboot).
2. **Chunky geometry** — large corner radii (16–28px), generous padding, big tap targets (min 48×48).
3. **Thick ink outlines** — every primary surface and button gets a 2.5–3px near-black outline (`--ink`), pop-art style. This is the signature.
4. **Hard offset shadows** — solid color shadows offset down-right (no blur, or minimal blur), giving a sticker / cut-out feel.
5. **Bouncy motion** — spring/overshoot curves everywhere (`easeOutBack`), nothing eases linearly. Buttons squish on press.
6. **Category color = identity** — the 5 quest categories each own a color; that color tints quests, completion bursts, trees, and the liquid fill.

**Restraint rules (so it doesn't get exhausting):**
- One hero color per screen region; neutrals carry the rest.
- Outlines and shadows are consistent, never random.
- Text is always high-contrast on its background (ink on light, cream on dark).

---

## 2. Color Tokens

### Core palette
| Token | Hex | Use |
|---|---|---|
| `--ink` | `#1A1626` | Outlines, primary text, shadows (the "black") |
| `--cream` | `#FFF7EC` | App background base, text on dark |
| `--paper` | `#FFFFFF` | Card / sheet surfaces |
| `--haze` | `#F0E9FF` | Recessed / disabled surfaces |
| `--pop-purple` | `#7C4DFF` | Primary brand / central nav / level-up |
| `--pop-pink` | `#FF4D9D` | Accent, hearts, highlights |
| `--pop-yellow` | `#FFD23F` | LE / energy, rewards, the "spark" |
| `--pop-teal` | `#1EC7C0` | Success, "done", checkmarks |
| `--pop-coral` | `#FF6B5E` | Destructive, warnings, "bad habit slip" |

### Category colors (drive quests → bursts → trees → liquid tint)
| Category | Token | Hex | Tree |
|---|---|---|---|
| Adventure | `--cat-adventure` | `#FF8A3D` (sunset orange) | Wild, untamed tree |
| Fitness | `--cat-fitness` | `#FF4D6D` (power red) | Strong oak |
| Social | `--cat-social` | `#FFC24B` (warm gold) | Flowering tree |
| Creative | `--cat-creative` | `#9B5DE5` (electric violet) | Rare glowing plant |
| Night | `--cat-night` | `#4361EE` (deep indigo) | Moonlit plant |
| Normal | `--cat-normal` | `#8D99AE` (slate) | Neutral plain tree (tree-only) |

> `normal` never appears in any quest picker — it is a tree-only fallback (Data Models §5, §7.8). It exists in this table only for tree rendering.

### Semantic
| Token | Maps to | Use |
|---|---|---|
| `--surface` | `--paper` | Default card |
| `--surface-sunk` | `--haze` | Disabled / past-date / empty |
| `--positive` | `--pop-teal` | Mark complete, LE gain |
| `--negative` | `--pop-coral` | Unmark, LE loss, delete |
| `--energy` | `--pop-yellow` | LE meter, sparks |

---

## 3. Typography

POP wants a **rounded, friendly display face** for headers and a clean readable face for body. The journal is the one place the user overrides this (Design Doc §7).

| Role | Font | Size / Weight | Notes |
|---|---|---|---|
| Display / screen title | Fredoka / Baloo 2 (rounded, heavy) | 28–34px / 700 | All-caps optional for short labels |
| Section header | Fredoka | 20px / 600 | |
| Body | Nunito / Inter | 15–16px / 400–600 | |
| Numeric (LE, levels, counts) | Fredoka tabular | varies / 700 | Big and proud |
| Journal body | **User choice:** `handwriting` (Caveat) or `formal` (Lora) | 17px | Alignment left/right per `settings` |

Letter-spacing on display: `0.01em`. Line-height body: `1.45`.

---

## 4. Shape, Elevation & Motion

**Radii:** `--r-sm 12px` · `--r-md 18px` · `--r-lg 24px` · `--r-pill 999px`.

**Outline:** `--stroke 2.5px solid --ink` on all primary surfaces & buttons. Secondary chips: `2px`.

**Pop shadow (signature):** hard offset, no/low blur. Kept **thin** so it reads as a crisp sticker edge, not a heavy drop.
- Resting card: `2px 2px 0 --ink`
- Raised button / shell control: `2px 2px 0 --ink`
- Pressed: shadow collapses to `1px 1px 0 --ink` and element translates `(1px,1px)` → the "squish".
- Hero (level-up card, sheets): `3px 3px 0 --ink` + soft ambient `0 8px 24px rgba(26,22,38,.16)`.

**Motion curves:**
- Press: scale `0.96`, 90ms.
- Appear / land: `easeOutBack` (overshoot), 260ms.
- LE fill change: `easeOutCubic`, 600ms.
- Heartbeat: button scale `1.0 → 1.08 → 1.0`, ~0.8s, `repeat(reverse)` **plus ripple waves** — 2–3 concentric rings behind the button that scale outward and fade to 0 on the same cycle, like a heartbeat/sonar ping (Design Doc §7). Rings are non-interactive (taps pass through to the button).

---

## 5. The Always-On Shell

Present on **every** screen, every date, every gesture (Design Doc §5.1). Three independent floating sticky buttons — **not** a bar. They float over content as cut-out stickers.

```
┌──────────────────────────────────────────────────────────┐
│    ╭───╮              ◌◌◌                ╭───╮              │  ← all three
│   ╭ ⚡4 ╮            ( ♥ pulse )          │ 📅 │             │    float, with
│    ╰───╯              ◌◌◌                ╰───╯              │    thin pop shadow
│  LE ring             central nav        calendar           │
│  (top-left)          (top-middle)       (top-right)        │
│                                                            │
│   three equal circular coins — LE ring & calendar same     │
│   diameter; nav circle slightly larger (primary action)    │
│                   ( screen content )                       │
```

### 5.1 LE Meter (top-left) — circular ring gauge
- **Circular**, `--paper` disc, `--stroke`, thin pop shadow. **Same diameter as the calendar button** (48px) so the two flanking coins match.
- A **circular progress ring** fills clockwise to show **progress within the current level only** (0 → 50, resets on level-up — Design Doc §4.2). Track in `--haze`, progress arc in `--energy`, both inside the `--ink` outline. Lifetime LE is NOT shown here (that's Analytics).
- Centre: ⚡ glyph. A small **level badge** (e.g. `4`) sits in a `--pop-purple` mini-disc on the bottom-right of the ring.
- Ring animates `easeOutCubic` on change; on **gain** a tiny `+10` / `+2` chip pops beside it in `--positive`/`--energy`; on **loss** a `−10`/`−2` chip in `--negative`.
- Tappable later → Analytics (v1.x); inert tap gives a playful wiggle for now.

### 5.2 Central Nav Circle (top-middle)
- Circular `--pop-purple` button, `--stroke`, white heart glyph, **heartbeat animation** always running — the button gently swells while **ripple waves** (concentric `--pop-purple` rings) pulse outward from behind it and fade as they expand. No shadow on this button (the ripple is its signature, not a drop shadow).
- Tap → **radial menu** (custom overlay, Design Doc §8.4) — petals spring out `easeOutBack`:

```
              ╭─────╮
              │ Set │
        ╭─────╮     ╭─────╮
        │ Bio │     │ SQ  │
        ╭─────╮  ♥  ╭─────╮
        │ Task│     │ HJ  │
        ╰─────╯     ╰─────╯
        ( Analytics petal added in v1.x, dimmed for now )
```
  - 6 petals: **Bio · SQ · Task · HJ · Set · Analytics(v1.x, disabled)**.
  - Each petal is a colored chip with icon + short label; tap navigates, menu collapses with a pop.
  - Backdrop dims to `rgba(26,22,38,.45)`; tap-outside closes.
  - HJ petal note: opens the same Journal screen reached by swipe (habit logging lives inside it — Design Doc §5.3).

### 5.3 Calendar Button (top-right)
**Circular** button (`--paper` disc, `--stroke`, thin pop shadow, same 48px diameter as the LE ring). Three states (Design Doc §5.5):
| State | Visual |
|---|---|
| Viewing **today** | Plain 📅 calendar icon, `--paper` |
| Viewing **other date** | 📅 with small `←` overlay badge in `--pop-pink`; disc tinted `--haze` |
| **Tap** (when off-today) | Springs back to today |
| **Long-press** (any time) | Opens full date picker sheet |

**Active-date display (no pill).** The selected date is shown as a typographic **big-number** treatment — a large day numeral, a colored vertical tick, then the month + weekday abbreviation stacked beside it (e.g. `22 | MAY / THU`). It is *not* boxed in a pill. It sits left-aligned above the screen title on **Side Quests** and **Tasks**. On **Journal** it's omitted (the date already sits beside the "Journal" header). Date is global state shared by SQ/Tasks/Journal. Off-today is signalled by the calendar button state (§5.3) and the read-only treatment (§7.2); the numeral simply reflects whatever day is selected.

---

## 6. Navigation Model

- **Horizontal swipe** (`PageView`): `Biome ← Side Quest → Tasks → Journal`. Landing = **Side Quest** (Design Doc §5.2).
- **Vertical scroll** = date change: up = previous day, down = next day. **Disabled on Biome** (date-agnostic). Journal uses a `NestedScrollView` past-edge threshold (Design Doc §5.4, §8.4).
- **Central nav** handles non-adjacent jumps + Settings/Analytics.

**Page indicator:** 4 chunky dots at the very bottom center, the active one stretched to a pill in `--pop-purple`. Biome dot carries a 🌳 glyph.

---

## 7. Global State Visuals

### 7.1 Liquid-fill background (Design Doc §7, §8.4)
- Animated wave rising from the screen bottom, height ∝ LE within current level.
- Shown on **every screen except Biome** — Side Quests, Tasks, and Journal+Habits all share it. Biome has its own isometric world backdrop instead.
- Two phase-shifted sine waves for natural wobble.
- **Tint = most-recent quest category color** at low opacity (~16%) over `--cream`.
- Toggle in Settings; when off, background is flat `--cream` with a subtle dot-grid.

### 7.2 Past-date (read-only) treatment
When viewing any date before today (Design Doc §6.2): action verbs disabled app-wide.
- All interactive controls shift to `--surface-sunk`, outline drops to 1.5px `--cat-normal`, shadows removed (flat).
- A floating **"👀 Read-only · past day"** ribbon appears under the date display.
- Cursor/feedback on tap: gentle shake, no state change.

### 7.3 Future-date treatment (Design Doc §6.3)
- **Tasks:** fully editable (planning is the point).
- **Side Quests / Journal / Habits:** disabled / empty state with a friendly "comes around on the day" message.

### 7.4 Tree-placement lock (Design Doc §6.7, Data Models §7.5)
When `app_state.pendingTreeCategory` is non-null, the app is **hard-locked** into Biome placement mode. **Every** other control across every screen is non-interactive (dimmed, shadows flat). Covered fully in `02-biome.md`.

---

## 8. Shared Components

| Component | POP spec |
|---|---|
| **Primary button** | Filled hero color, `--stroke`, `3px 3px 0` shadow, squish on press, label in Fredoka 600 |
| **Chip / tag** | Pill, 2px outline, category-colored fill at 100% with ink text, small |
| **Card** | `--paper`, `--r-lg`, `--stroke`, thin `2px 2px 0` shadow |
| **Toggle / checkbox** | Chunky rounded square, `--ink` outline; checked = `--positive` fill with a bouncy check draw-on |
| **FAB (＋)** | Circular `--pop-pink`, `--stroke`, big `+`, bottom-right, casts pop shadow; squish + rotate on press |
| **Bottom sheet** | `--paper`, top corners `--r-lg`, grabber handle, `6px 6px 0` hero shadow |
| **Empty state** | Centered chunky illustration + 1 line of warm copy + (optional) action button |
| **Toast / LE chip** | Small pill that pops up, `easeOutBack`, auto-dismiss 1.2s |
| **Confetti / burst** | Category-colored particle burst on quest completion & level-up |

---

## 9. Iconography & Illustration

- Icon style: rounded-stroke, 2px, filled accents — match the chunky outline language.
- Each category gets a signature glyph: Adventure 🧭, Fitness 💪, Social 🫂, Creative 🎨, Night 🌙.
- Trees rendered by the Flame engine in cartoon 2.5D isometric (Design Doc §7) — these specs cover the Flutter UI chrome around the canvas, not the sprite art (TBD art pass).

---

## 10. Accessibility & Density

- Min tap target 48×48; FAB and nav circle 60×60.
- Contrast: ink-on-cream and cream-on-purple both clear AA.
- The high-saturation palette gets a **"Calm POP"** Settings toggle later (desaturate ~20%, keep outlines) for sensory comfort — flagged, not in MVP.
- Outlines double as a contrast aid (shapes remain legible even if color is hard to distinguish).
```
