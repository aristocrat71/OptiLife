import 'package:flutter/material.dart';

import '../core/enums.dart';

/// POP colour palette. Authoritative source: `ui-design-docs/05-foundations-tokens.md §1`.
/// Never hard-code a hex in a widget — reference these tokens.
abstract final class AppColors {
  // ── core ──
  static const ink = Color(0xFF1A1626);
  static const cream = Color(0xFFFFF7EC);
  static const paper = Color(0xFFFFFFFF);
  static const haze = Color(0xFFF0E9FF);
  static const hazeDeep = Color(0xFFE7DEF5);
  static const popPurple = Color(0xFF7C4DFF);
  static const popPink = Color(0xFFFF4D9D);
  static const popYellow = Color(0xFFFFD23F);
  static const popTeal = Color(0xFF1EC7C0);
  static const popCoral = Color(0xFFFF6B5E);
  static const mutedInk = Color(0xFF9B8FB0);

  /// Biome's leafy light green (the Bio nav/petal colour).
  static const biomeGreen = Color(0xFF7AC974);

  // ── semantic ──
  static const background = cream;
  static const surface = paper;
  static const surfaceSunk = haze;
  static const positive = popTeal;
  static const negative = popCoral;
  static const energy = popYellow;
  static const brand = popPurple;
  static const outline = ink;

  // ── category ──
  static const catAdventure = Color(0xFFFF8A3D);
  static const catFitness = Color(0xFFFF4D6D);
  static const catSocial = Color(0xFFFFC24B);
  static const catCreative = Color(0xFF9B5DE5);
  static const catNight = Color(0xFF4361EE);
  static const catNormal = Color(0xFF8D99AE);

  /// Category → colour. `normal` included (used for the fallback tree).
  static Color category(QuestCategory c) => switch (c) {
        QuestCategory.adventure => catAdventure,
        QuestCategory.fitness => catFitness,
        QuestCategory.social => catSocial,
        QuestCategory.creative => catCreative,
        QuestCategory.night => catNight,
        QuestCategory.normal => catNormal,
      };

  /// Soft "done" wash for a card (category colour @ ~12%).
  static Color categoryWash(QuestCategory c) =>
      category(c).withValues(alpha: 0.12);

  // ── text on light ──
  static Color get textMuted => ink.withValues(alpha: 0.55);
  static const textCaption = mutedInk;
}
