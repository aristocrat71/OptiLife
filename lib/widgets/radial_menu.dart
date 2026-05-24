import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'pop_tappable.dart';

/// Sentinel result for the Settings petal — a *pushed* route, not a PageView
/// page. [AppShell] pushes Settings when [showRadialMenu] returns this.
const kRadialSettings = -2;

/// Sentinel result for the Analytics ("Stats") petal — also a pushed route.
const kRadialAnalytics = -3;

/// Opens the circular radial menu from the central nav. Returns the chosen
/// PageView index (0=Biome, 1=SQ, 2=Tasks, 3=Journal), [kRadialSettings] for
/// Settings, or null if dismissed.
Future<int?> showRadialMenu(BuildContext context) {
  return showGeneralDialog<int>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close menu',
    barrierColor: AppColors.ink.withValues(alpha: AppZ.scrim),
    transitionDuration: AppMotion.pop,
    pageBuilder: (_, _, _) => const _RadialMenu(),
    transitionBuilder: (_, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: AppMotion.curvePop);
      return FadeTransition(
        opacity: anim,
        child: ScaleTransition(
            scale: Tween(begin: 0.6, end: 1.0).animate(curved),
            alignment: Alignment.topCenter,
            child: child),
      );
    },
  );
}

class _Petal {
  const _Petal(this.label, this.icon, this.color, this.index, this.angle);
  final String label;
  final IconData icon;
  final Color color;
  final int index; // PageView index, or a kRadial* sentinel for pushed routes
  final double angle; // degrees, y-down
}

class _RadialMenu extends StatelessWidget {
  const _RadialMenu();

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final cx = media.size.width / 2;
    final cy = media.padding.top + 95;
    const r = 165.0; // larger radius → more breathing room between petals
    const petalSize = 56.0;

    const petals = [
      _Petal('Bio', Icons.park_rounded, AppColors.biomeGreen, 0, 150),
      _Petal('SQ', Icons.flag_rounded, AppColors.popPurple, 1, 126),
      _Petal('Task', Icons.check_box_rounded, AppColors.popPink, 2, 102),
      _Petal('HJ', Icons.menu_book_rounded, AppColors.popTeal, 3, 78),
      _Petal('Set', Icons.settings_rounded, Color(0xFF3A3450),
          kRadialSettings, 54),
      _Petal('Stats', Icons.bar_chart_rounded, AppColors.catNight,
          kRadialAnalytics, 30),
    ];

    return Stack(
      children: [
        for (final p in petals)
          Positioned(
            left: cx + r * math.cos(p.angle * math.pi / 180) - petalSize / 2,
            top: cy + r * math.sin(p.angle * math.pi / 180) - petalSize / 2,
            child: _PetalButton(petal: p, size: petalSize),
          ),
      ],
    );
  }
}

class _PetalButton extends StatelessWidget {
  const _PetalButton({required this.petal, required this.size});
  final _Petal petal;
  final double size;

  @override
  Widget build(BuildContext context) {
    return PopTappable(
      onTap: () => Navigator.of(context).pop(petal.index),
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: petal.color,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.ink, width: 2.5),
          boxShadow: AppShadows.card,
        ),
        child: Icon(petal.icon, color: Colors.white, size: 26),
      ),
    );
  }
}
