# OptiLife — Component Library (POP)

**Audience:** Flutter engineers. Build these as reusable widgets in `lib/widgets/`. Every component references tokens from `05-foundations-tokens.md` — no raw literals.

**State vocabulary** (applies to all interactive components):
`default` · `pressed` (squish) · `disabled` (sunk) · `selected/active` · `loading` (where relevant). Past-date read-only is a global modifier (see `07`).

**Press behaviour (global):** all tappable POP elements scale to `0.96` over `AppMotion.press`, shadow collapses `card → pressed`, element translates `+1,+1`. Implement once as a `PopTappable` wrapper; do **not** use Material InkWell ink (splash disabled in theme).

```dart
class PopTappable extends StatefulWidget {
  final Widget child; final VoidCallback? onTap; final bool enabled;
  // on tap-down: AnimatedScale 0.96 + swap shadow; on tap-up: restore + onTap()
}
```

---

## 1. Shell controls (always-on, every screen)

### 1.1 `LeRingGauge` (top-left, 48×48)
- Circular `paper` disc, `2.5px ink` outline, `AppShadows.card`.
- **Progress ring**: track `haze` (5px), arc `energy` (5px, round cap), fills clockwise from top. `value = leIntoCurrentLevel / 50` (Data Models §4.1 derived).
- Centre: ⚡ glyph. **Level badge**: 20px `popPurple` disc, `2px ink`, bottom-right `(-3,-3)`, white level numeral.
- Animate arc on change with `AppMotion.fill`. On LE delta, spawn an LE-fly chip (§9) `+10/+2` (positive) or `−10/−2` (negative).
- States: `default`; `pressed`→playful wiggle only (tap is inert until Analytics v1.x).
- Build: `CustomPaint` for the ring; `Stack` for glyph + badge.

### 1.2 `CentralNav` (top-middle, 58×58)
- `popPurple` circle, `2.5px ink`, white heart, **no shadow**.
- **Heartbeat**: scale `1.0→1.08` (`AppMotion.heartbeat`, repeat-reverse).
- **Ripple**: 3 concentric `popPurple` rings behind the button, scale outward + fade to 0 (`AppMotion.ripple`, staggered ~530ms). Compact — start ~70px, grow ~+30px each. `IgnorePointer` so taps hit the button.
- Tap → `RadialMenu` overlay (§10).

### 1.3 `CalendarButton` (top-right, 48×48 circle)
- `paper` circle, `2.5px ink`, `AppShadows.card`, calendar glyph.
- States:
  - **today**: plain glyph, `paper` fill.
  - **offToday**: `haze` fill + small `popPink` `←` badge top-right; tap → jump to today (`selectedDate = today`).
  - **long-press** (any): open `DatePickerSheet` (§8 + screen file).

### 1.4 `DateDisplay` (big-number, no container) — SQ & Tasks only
- Row: `numXL` day number · `popPink` 4px vertical tick · column(`MAY` `label`-spaced, `THU` muted). Left-aligned above the title.
- Reflects `selectedDate`. Past/future just change the numerals; today-ness is signalled by `CalendarButton` + read-only ribbon. Omitted on Journal (date sits beside the "Journal" header).

---

## 2. `AppButton`
Variants: `primary` (hero-colour fill), `secondary` (paper + outline), `destructive` (`popCoral` fill).
- Anatomy: optional leading icon + `label` text. Padding `12×24` (primary), `10×20` (secondary).
- Surface: `popSurface(fill: variantColor, radius: AppRadii.md)`. Label `ink` (always — even on coloured fills, per POP high-contrast rule).
- States: default / pressed (squish) / **disabled** (`surfaceSunk` fill, `1.5px catNormal` outline, no shadow, label @45%).
- Category-tinted variant: `AppButton.category(QuestCategory)` → fill `AppColors.category(c)` (used by quest MARK).

---

## 3. `QuestCard`
Anatomy: left **category band** (9px stripe) · body{ category chip + reward chip / status badge · title (+desc) · action }.
| State | Visual |
|---|---|
| `pending` | full colour, `card` shadow, reward chip `+10⚡`, MARK button (category-tinted) |
| `pressing` | squish + category confetti burst + done-wash sweep + LE-fly `+10` |
| `done` | `categoryWash(c)` fill, `✓ DONE` teal badge, MARK→`undo ↺` small button |
| `readOnly` (past) | flattened to `surfaceSunk`, `1.5px catNormal`, no shadow; action replaced by static `✓ done`/`— not done` |

Build: `Row`(band, `Expanded` body). Confetti via overlay particle widget (§ motion).

---

## 4. `TaskRow`
Calmer than QuestCard — **no LE chrome, no confetti** (signals "no reward").
- Anatomy: `Checkbox` (purple, see §6) + title (+optional desc). `AppRadii.md`, `AppShadows.card`.
- States: `pending`; `done`→checkbox filled `popPurple`, title strike-through, row @75%, moves into a `DONE (n)` collapsed group; `readOnly`→static check indicator, no interaction.
- Swipe-left → `Delete` (`negative`) — hard delete (Data Models §4.8). Disabled on past dates.
- Row tap → edit sheet; checkbox tap toggles complete (separate hit zones).

---

## 5. `HabitChip` (Journal screen, horizontal strip)
- ~120px wide. Anatomy: type badge (`GOOD`=teal / `BAD`=coral) + title + **single binary toggle**.
- Good habit → `DONE` toggle; bad habit → `AVOIDED` toggle. **No tri-state, no "slip"** (Design Doc §6.5).
| State | Visual |
|---|---|
| `unlogged` | toggle outline (`paper` + `2px ink`) |
| `logged` | toggle fill `positive` + check (DONE) / shield (AVOIDED), tiny `⚡+2` corner badge, LE-fly `+2` |
| `readOnly` | static badge (`✓ done` / `🛡 avoided`), sunk |
- Toggle = insert/delete `habit_log` (`leAwarded=2`), reverse on un-log (`−2`). May trigger level-up → placement.

---

## 6. Inputs & toggles
### `PopCheckbox`
- 26×26 rounded square, `2.5px ink`. Unchecked `cream`. Checked → fill (`popPurple` for tasks, `positive` for habits/quests) + bouncy check draw-on (`AppMotion.pop`).
### `PopToggleButton`
- The DONE/AVOIDED pill in HabitChip; outline ↔ filled.
### `PopTextField`
- `paper`, `2px ink`, `AppRadii.sm`, `body` text, `mutedInk` placeholder. Focus → outline `popPurple`. Error → outline `popCoral` + shake. Used in sheets.

---

## 7. Chips & badges
- `CategoryChip`: pill, `2px ink`, fill `AppColors.category(c)`, `ink` label + glyph (ALL-CAPS `label`).
- `RewardChip`: `energy` pill, `+10⚡`.
- `StatusBadge`: `DONE` (teal+check), `AVOIDED` (teal+shield), `— not done` (sunk).
- `CountBadge`: small `hazeDeep` pill w/ `popPurple` numeral (e.g. DONE count).
- `Ribbon`: floating contextual strip — `👀 Read-only · past day`, `🗓 Planning ahead`. `ink` or tinted, small.

---

## 8. `PopBottomSheet`
- `paper`, top corners `AppRadii.xl`, grab handle (`hazeDeep` 36×4 pill), `AppShadows.hero`, scrim `ink @ AppZ.scrim`.
- Opens with `AppMotion.pop` (slide-up + slight overshoot). Used by: add/edit Task/Quest/Habit, journal font picker, date picker, reboot prompt.
- Header: `h2` title + optional `Delete` text-button (edit mode). Footer: primary action `AppButton`.

---

## 9. Feedback
### `Fab` (Tasks)
- 62×62 `popPink` circle, `2.5px ink`, `AppShadows.card`, white `+`. Press → squish + slight rotate. Bottom-right, `xl` inset.
### `Toast`
- Small pill, pops with `AppMotion.pop`, auto-dismiss 1.2s. Non-blocking, topmost. e.g. "Saved to gallery 📸", "Level down — newest tree removed".
### `LeFlyChip`
- Tiny chip (`+10`/`+2` `positive`/`energy`; `−10`/`−2` `negative`) that spawns at the action and **flies to the LE ring**, then the ring animates. Drives the core feedback loop. Implement as an `OverlayEntry` with a `Tween` along a curve to the ring's global position.
### `ConfettiBurst`
- Category-coloured particle burst on quest-complete & level-up. Short (~700ms), additive, non-blocking.

---

## 10. `RadialMenu` (overlay)
- Triggered by `CentralNav`. Scrim `ink @ 45%`, tap-outside closes.
- 6 petals spring out (`AppMotion.pop`, staggered): **Bio · SQ · Task · HJ · Set · Analytics**. Analytics dimmed/disabled (v1.x).
- Each petal: coloured chip, icon + short label; tap → navigate (PageView jump or push Settings), menu collapses with a pop.
- Build: custom `Overlay` + animated `Positioned` children (Design Doc §8.4 — not `flutter_speed_dial`).

---

## 11. Misc
- `PageDots`: 4 dots; active = stretched `popPurple` pill (`2px ink`). Biome dot carries a tiny 🌳. Bottom-centre, `18` inset.
- `SegmentedProgress`: one segment per item (quest/task), fills as done. `positive` (SQ) / `popPurple` (Tasks — no energy semantics).
- `EmptyState`: centred chunky illustration + one warm line + optional `AppButton`.
- `LiquidFillBackground`: `CustomPainter`, two phase-shifted sine waves, height ∝ LE-in-level, tint = recent category @16%. All screens except Biome; toggle via `settings.liquidFillEnabled` (fallback: flat `cream` + dot-grid).

---

## 12. Component → token quick map
| Component | Fill | Outline | Shadow | Radius |
|---|---|---|---|---|
| Card / QuestCard | `paper` | 2.5 `ink` | `card` | `lg` |
| TaskRow / HabitChip | `paper` | 2.5 `ink` | `card` | `md` |
| Primary button | hero | 2.5 `ink` | `card` | `md` |
| Chip | category | 2 `ink` | — | `pill` |
| Shell control | `paper`/`popPurple` | 2.5 `ink` | `card` / none(nav) | `pill` |
| Sheet | `paper` | — | `hero` | `xl` (top) |
| Disabled (any) | `surfaceSunk` | 1.5 `catNormal` | none | inherit |
