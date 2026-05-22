import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Spacing — 4-pt scale (`05-foundations-tokens.md §3`).
abstract final class AppSpace {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 18.0;
  static const xxl = 24.0;
  static const xxxl = 34.0;

  /// Standard left/right gutter on every screen.
  static const screenGutter = xl;

  // Layout constants.
  static const statusBar = 44.0;
  static const shellControl = 48.0; // LE ring & calendar diameter
  static const navCircle = 58.0;
  static const fab = 62.0;
  static const pageDotsInset = 18.0;
  static const minTapTarget = 48.0;
}

/// Corner radii (`§4`).
abstract final class AppRadii {
  static const sm = 12.0;
  static const md = 18.0;
  static const lg = 24.0;
  static const xl = 22.0; // sheets / journal paper
  static const pill = 999.0;

  static BorderRadius r(double v) => BorderRadius.circular(v);
}

/// Thin hard-offset "sticker" shadows (`§5`).
abstract final class AppShadows {
  static const _ink = AppColors.ink;

  static const card = <BoxShadow>[
    BoxShadow(color: _ink, offset: Offset(2, 2), blurRadius: 0),
  ];

  static const pressed = <BoxShadow>[
    BoxShadow(color: _ink, offset: Offset(1, 1), blurRadius: 0),
  ];

  static List<BoxShadow> get hero => [
        const BoxShadow(color: _ink, offset: Offset(3, 3), blurRadius: 0),
        BoxShadow(
            color: _ink.withValues(alpha: 0.16),
            offset: const Offset(0, 8),
            blurRadius: 24),
      ];
}

/// Motion tokens (`§6`). Pair durations with curves at the call site.
abstract final class AppMotion {
  static const press = Duration(milliseconds: 90);
  static const pop = Duration(milliseconds: 260);
  static const fill = Duration(milliseconds: 600);
  static const heartbeat = Duration(milliseconds: 800);
  static const ripple = Duration(milliseconds: 1600);
  static const shake = Duration(milliseconds: 320);
  static const travel = Duration(milliseconds: 1400);

  static const curvePop = Curves.easeOutBack;
  static const curveFill = Curves.easeOutCubic;
}

/// Layer/scrim constants (`§7`).
abstract final class AppZ {
  /// ink overlay alpha for sheets & the radial menu.
  static const scrim = 0.45;
}
