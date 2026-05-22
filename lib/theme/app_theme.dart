import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';
import 'tokens.dart';

/// The standard outlined + thin-shadowed POP surface used by cards, buttons,
/// chips and shell controls. See `06-components.md §12`.
BoxDecoration popSurface({
  Color fill = AppColors.paper,
  double radius = AppRadii.lg,
  double stroke = 2.5,
  bool shadow = true,
}) =>
    BoxDecoration(
      color: fill,
      borderRadius: AppRadii.r(radius),
      border: Border.all(color: AppColors.ink, width: stroke),
      boxShadow: shadow ? AppShadows.card : null,
    );

/// App-wide theme. POP uses the press "squish" for feedback, so the Material
/// ink splash is disabled globally (`05-foundations-tokens.md §8`).
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
    splashFactory: NoSplash.splashFactory,
  );
}
