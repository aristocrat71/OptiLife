# OptiLife — Foundations & Design Tokens (POP)

**Audience:** Flutter engineers. **Status:** v1.0 dev-ready.
**Companion to:** `00-design-system.md` (conceptual overview). This file is the **authoritative, code-ready token source** — if `00` and `05` ever disagree, `05` wins for implementation values.

> Stack reminder (Design Doc §8.1): Flutter · Riverpod · Drift · Flame · native `AnimationController` + `CustomPainter`. Tokens below are given as plain Dart so they can drop into `lib/theme/` with no dependencies.

---

## 0. How to use this file

1. Create `lib/theme/` and paste the four token classes (`AppColors`, `AppType`, `AppSpace`, `AppRadii`, `AppShadows`, `AppMotion`, `AppZ`).
2. Build a single `AppTheme` (ThemeData) from them (snippet at the end).
3. **Never hard-code a hex, radius, duration, or pixel gap in a widget.** Reference the token. Reviews should reject raw literals.
4. Mobile-only for v1 (portrait). No responsive breakpoints; design canvas is **390×844** logical px.

---

## 1. Color

### 1.1 Core palette
| Token | Hex | Role |
|---|---|---|
| `ink` | `#1A1626` | Outlines, primary text, the "black" in shadows |
| `cream` | `#FFF7EC` | App background base; text on dark surfaces |
| `paper` | `#FFFFFF` | Card / sheet surfaces |
| `haze` | `#F0E9FF` | Recessed tracks, disabled fills |
| `hazeDeep` | `#E7DEF5` | Empty/placeholder segments |
| `popPurple` | `#7C4DFF` | Brand, central nav, level-up, primary accents |
| `popPink` | `#FF4D9D` | FAB, highlights, off-today marker |
| `popYellow` | `#FFD23F` | LE / energy, rewards |
| `popTeal` | `#1EC7C0` | Success, "done", positive logs |
| `popCoral` | `#FF6B5E` | Destructive, warnings, "bad habit" tag |
| `mutedInk` | `#9B8FB0` | Caption / tertiary text |

### 1.2 Category colors (drive quests → bursts → trees → liquid tint)
| Category | Token | Hex |
|---|---|---|
| adventure | `catAdventure` | `#FF8A3D` |
| fitness | `catFitness` | `#FF4D6D` |
| social | `catSocial` | `#FFC24B` |
| creative | `catCreative` | `#9B5DE5` |
| night | `catNight` | `#4361EE` |
| normal *(tree-only)* | `catNormal` | `#8D99AE` |

> `normal` is **never** offered in a quest category picker (Data Models §5). It exists only for the fallback tree. Keep it out of any `QuestCategory` UI list; include it only in tree-rendering maps.

### 1.3 Semantic aliases
| Semantic | → token |
|---|---|
| `surface` | `paper` |
| `surfaceSunk` | `haze` (disabled / past / empty) |
| `background` | `cream` |
| `positive` | `popTeal` |
| `negative` | `popCoral` |
| `energy` | `popYellow` |
| `brand` | `popPurple` |
| `textPrimary` | `ink` |
| `textMuted` | `ink` @ 55% |
| `textCaption` | `mutedInk` |
| `outline` | `ink` |

### 1.4 Dart
```dart
import 'package:flutter/material.dart';

abstract final class AppColors {
  // core
  static const ink       = Color(0xFF1A1626);
  static const cream     = Color(0xFFFFF7EC);
  static const paper     = Color(0xFFFFFFFF);
  static const haze      = Color(0xFFF0E9FF);
  static const hazeDeep  = Color(0xFFE7DEF5);
  static const popPurple = Color(0xFF7C4DFF);
  static const popPink   = Color(0xFFFF4D9D);
  static const popYellow = Color(0xFFFFD23F);
  static const popTeal   = Color(0xFF1EC7C0);
  static const popCoral  = Color(0xFFFF6B5E);
  static const mutedInk  = Color(0xFF9B8FB0);

  // semantic
  static const background   = cream;
  static const surface      = paper;
  static const surfaceSunk  = haze;
  static const positive     = popTeal;
  static const negative     = popCoral;
  static const energy       = popYellow;
  static const brand        = popPurple;
  static const outline      = ink;

  // category
  static const catAdventure = Color(0xFFFF8A3D);
  static const catFitness   = Color(0xFFFF4D6D);
  static const catSocial    = Color(0xFFFFC24B);
  static const catCreative  = Color(0xFF9B5DE5);
  static const catNight     = Color(0xFF4361EE);
  static const catNormal    = Color(0xFF8D99AE);

  /// Maps a QuestCategory enum to its colour. `normal` included for trees.
  static Color category(QuestCategory c) => switch (c) {
    QuestCategory.adventure => catAdventure,
    QuestCategory.fitness   => catFitness,
    QuestCategory.social    => catSocial,
    QuestCategory.creative  => catCreative,
    QuestCategory.night     => catNight,
    QuestCategory.normal    => catNormal,
  };

  /// Soft fill for a "done" card wash (category colour @ ~12%).
  static Color categoryWash(QuestCategory c) => category(c).withValues(alpha: 0.12);
}
```

> Use `withValues(alpha:)` (Flutter 3.27+) rather than the deprecated `withOpacity`.

### 1.5 Opacity ladder (use these, don't invent)
`0.05` hairline · `0.12` wash · `0.16` liquid tint · `0.28` grid lines · `0.55` muted text · `0.75` de-emphasised row.

---

## 2. Typography

Two display/body families + two journal-only families (user-switchable).

| Role | Family | Size | Weight | Height | Tracking |
|---|---|---|---|---|---|
| `display` (screen title) | Fredoka | 30 | 700 | 1.0 | 0.01em |
| `h2` (section header) | Fredoka | 20 | 600 | 1.15 | 0 |
| `numXL` (big date / level-up) | Fredoka | 38 | 700 | 0.9 | 0 |
| `numL` (counts) | Fredoka | 16–18 | 700 | 1.1 | 0.10em (labels) |
| `bodyL` | Nunito | 16 | 700 | 1.3 | 0 |
| `body` | Nunito | 15 | 600 | 1.45 | 0 |
| `label` (buttons/chips) | Fredoka | 13–15 | 700 | 1.0 | 0.03em |
| `caption` | Nunito | 12 | 700 | 1.2 | 0.04em |
| `journalHand` | Caveat | 23 | 600 | 1.45 | 0 |
| `journalFormal` | Lora | 17 | 500 | 1.5 | 0 |

- Fonts via `google_fonts` package (Fredoka, Nunito, Caveat, Lora). For offline-first (Design Doc §2), **bundle the font files** in `assets/fonts/` and declare in `pubspec.yaml` rather than fetching at runtime.
- Journal family/alignment come from `settings.journalFont` / `settings.journalAlignment` (Data Models §4.2) — resolve at render time.

```dart
abstract final class AppType {
  static TextStyle get display => GoogleFonts.fredoka(
        fontSize: 30, fontWeight: FontWeight.w700, height: 1.0,
        letterSpacing: 0.3, color: AppColors.ink);
  static TextStyle get h2 => GoogleFonts.fredoka(
        fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.ink);
  static TextStyle get numXL => GoogleFonts.fredoka(
        fontSize: 38, fontWeight: FontWeight.w700, height: 0.9, color: AppColors.ink);
  static TextStyle get label => GoogleFonts.fredoka(
        fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.4, color: AppColors.ink);
  static TextStyle get bodyL => GoogleFonts.nunito(
        fontSize: 16, fontWeight: FontWeight.w700, height: 1.3, color: AppColors.ink);
  static TextStyle get body => GoogleFonts.nunito(
        fontSize: 15, fontWeight: FontWeight.w600, height: 1.45, color: AppColors.ink);
  static TextStyle get caption => GoogleFonts.nunito(
        fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5,
        color: AppColors.mutedInk);

  static TextStyle journal(JournalFont f) => f == JournalFont.handwriting
      ? GoogleFonts.caveat(fontSize: 23, fontWeight: FontWeight.w600, height: 1.45, color: AppColors.ink)
      : GoogleFonts.lora(fontSize: 17, fontWeight: FontWeight.w500, height: 1.5, color: AppColors.ink);
}
```

---

## 3. Spacing (4-pt scale)

| Token | px | Typical use |
|---|---|---|
| `xs` | 4 | icon-text gap, tight chips |
| `sm` | 8 | chip padding, small gaps |
| `md` | 12 | inner card padding |
| `lg` | 16 | screen gutter, list gap |
| `xl` | 18 | screen horizontal padding (standard gutter) |
| `xxl` | 24 | section spacing |
| `xxxl` | 34 | hero / sheet padding |

```dart
abstract final class AppSpace {
  static const xs = 4.0, sm = 8.0, md = 12.0, lg = 16.0,
               xl = 18.0, xxl = 24.0, xxxl = 34.0;
  static const screenGutter = xl; // 18 — left/right on every screen
}
```

**Layout constants:** screen H-gutter `18`; status bar `44`; shell control diameter `48` (LE ring & calendar), nav circle `58`; FAB `62`; page-dots bottom inset `18`; min tap target `48`.

---

## 4. Radii

| Token | px | Use |
|---|---|---|
| `sm` | 12 | small chips, inputs |
| `md` | 18 | rows, secondary buttons, habit chips |
| `lg` | 24 | cards |
| `xl` | 22 | sheets / journal paper (top corners) |
| `pill` | 999 | pills, ring, calendar circle, toggles |

```dart
abstract final class AppRadii {
  static const sm = 12.0, md = 18.0, lg = 24.0, xl = 22.0, pill = 999.0;
  static BorderRadius r(double v) => BorderRadius.circular(v);
}
```

---

## 5. Outline & Shadow (the POP signature)

- **Outline:** `2.5px solid ink` on primary surfaces & buttons; `2px` on chips; `1.5px` on disabled/past surfaces (colour shifts to `catNormal`).
- **Shadow:** thin hard offset, no blur — a crisp sticker edge. (Tuned down from the original heavy values per design review.)

| Token | Offset/blur | Use |
|---|---|---|
| `card` | `2,2` / 0 | resting card / button / shell control |
| `pressed` | `1,1` / 0 | pressed (element also translates `+1,+1`) |
| `hero` | `3,3` / 0 + ambient `0,8 / 24 @16%` | sheets, level-up card |
| `none` | — | central nav (ripple is its signature, no shadow) |

```dart
abstract final class AppShadows {
  static const _ink = AppColors.ink;
  static List<BoxShadow> get card => const [
        BoxShadow(color: _ink, offset: Offset(2, 2), blurRadius: 0)];
  static List<BoxShadow> get pressed => const [
        BoxShadow(color: _ink, offset: Offset(1, 1), blurRadius: 0)];
  static List<BoxShadow> get hero => [
        const BoxShadow(color: _ink, offset: Offset(3, 3), blurRadius: 0),
        BoxShadow(color: _ink.withValues(alpha: 0.16), offset: const Offset(0, 8), blurRadius: 24)];
}

/// Standard outlined+shadowed surface used everywhere.
BoxDecoration popSurface({
  Color fill = AppColors.paper,
  double radius = AppRadii.lg,
  double stroke = 2.5,
  bool shadow = true,
}) => BoxDecoration(
      color: fill,
      borderRadius: AppRadii.r(radius),
      border: Border.all(color: AppColors.ink, width: stroke),
      boxShadow: shadow ? AppShadows.card : null,
    );
```

---

## 6. Motion tokens

| Token | Duration | Curve | Use |
|---|---|---|---|
| `press` | 90ms | `easeOut` | button squish (scale 0.96) |
| `pop` | 260ms | `easeOutBack` | element land / deal-in / sheet open |
| `fill` | 600ms | `easeOutCubic` | LE ring & liquid level change |
| `heartbeat` | 800ms | `easeInOut`, `repeat(reverse)` | nav swell 1.0→1.08 |
| `ripple` | 1600ms | `easeOut`, `repeat` | nav rings expand+fade (staggered) |
| `shake` | 320ms | custom | disabled-tap / invalid (±6px ×2) |
| `travel` | 1400ms | `easeInOutCubic` | reboot dimensional warp |

```dart
abstract final class AppMotion {
  static const press     = Duration(milliseconds: 90);
  static const pop       = Duration(milliseconds: 260);
  static const fill      = Duration(milliseconds: 600);
  static const heartbeat = Duration(milliseconds: 800);
  static const ripple    = Duration(milliseconds: 1600);
  static const shake     = Duration(milliseconds: 320);
  static const travel    = Duration(milliseconds: 1400);

  static const curvePop  = Curves.easeOutBack;
  static const curveFill = Curves.easeOutCubic;
}
```

Full per-animation detail lives in `08-motion.md`.

---

## 7. Z-index / layer order

Per screen, back → front:
1. **Liquid-fill background** (all screens except Biome) / Biome world
2. Screen content (scrollable)
3. Nav ripple (behind the shell, above content top region)
4. **Sticky shell** (LE ring, central nav, calendar) + date display
5. Page-dots
6. FAB (Tasks)
7. **Bottom sheets / dialogs** (with scrim `ink @ 45%`)
8. **Radial menu overlay** (scrim + petals)
9. **Tree-placement lock layer** (dims everything; only biome canvas interactive)
10. **Level-up / reboot full-screen celebration**
11. Toasts / LE-fly chips (always topmost, non-blocking)

```dart
abstract final class AppZ {
  static const scrim = 0.45; // ink overlay alpha for sheets & radial menu
}
```

> Layers 7–10 are **modal**; the placement lock (9) is special — see `07-ia-navigation-state.md` §placement-lock.

---

## 8. Assembling the theme

```dart
ThemeData appTheme() {
  final base = ThemeData(useMaterial3: true, brightness: Brightness.light);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.popPurple,
      secondary: AppColors.popPink,
      surface: AppColors.paper,
      error: AppColors.popCoral,
      outline: AppColors.ink,
    ),
    textTheme: base.textTheme.copyWith(
      displayLarge: AppType.display,
      titleLarge: AppType.h2,
      bodyMedium: AppType.body,
      labelLarge: AppType.label,
    ),
    splashFactory: NoSplash.splashFactory, // POP uses squish, not ripple ink
  );
}
```

> **No Material ink ripples** on POP buttons — the press feedback is the squish (`AppMotion.press`). Disable splash globally and animate scale in the button widget (see `06-components.md`).
