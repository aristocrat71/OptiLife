import 'package:flutter/material.dart';

import '../core/enums.dart';
import 'app_colors.dart';

/// Type scale (`ui-design-docs/05-foundations-tokens.md §2`).
/// Fonts are **bundled locally** (declared in pubspec) and referenced by
/// family name — not via the google_fonts runtime fetch (offline-first).
abstract final class AppType {
  static const _fredoka = 'Fredoka';
  static const _nunito = 'Nunito';
  static const _caveat = 'Caveat';
  static const _lora = 'Lora';

  // letterSpacing is in logical px (≈ em × fontSize).
  static const display = TextStyle(
      fontFamily: _fredoka,
      fontSize: 30,
      fontWeight: FontWeight.w700,
      height: 1.0,
      letterSpacing: 0.3,
      color: AppColors.ink);

  static const h2 = TextStyle(
      fontFamily: _fredoka,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.15,
      color: AppColors.ink);

  static const numXL = TextStyle(
      fontFamily: _fredoka,
      fontSize: 38,
      fontWeight: FontWeight.w700,
      height: 0.9,
      color: AppColors.ink);

  static const numL = TextStyle(
      fontFamily: _fredoka,
      fontSize: 17,
      fontWeight: FontWeight.w700,
      height: 1.1,
      color: AppColors.ink);

  static const label = TextStyle(
      fontFamily: _fredoka,
      fontSize: 14,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.4,
      color: AppColors.ink);

  static const bodyL = TextStyle(
      fontFamily: _nunito,
      fontSize: 16,
      fontWeight: FontWeight.w700,
      height: 1.3,
      color: AppColors.ink);

  static const body = TextStyle(
      fontFamily: _nunito,
      fontSize: 15,
      fontWeight: FontWeight.w600,
      height: 1.45,
      color: AppColors.ink);

  static const caption = TextStyle(
      fontFamily: _nunito,
      fontSize: 12,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
      color: AppColors.mutedInk);

  /// Journal body — family chosen by the user setting (Data Models §4.2/§4.9).
  static TextStyle journal(JournalFont f) => f == JournalFont.handwriting
      ? const TextStyle(
          fontFamily: _caveat,
          fontSize: 23,
          fontWeight: FontWeight.w600,
          height: 1.45,
          color: AppColors.ink)
      : const TextStyle(
          fontFamily: _lora,
          fontSize: 17,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: AppColors.ink);
}
