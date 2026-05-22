import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'pop_tappable.dart';

/// "Warp to Present" — a space-themed button: a deep-space gradient pill with a
/// twinkling starfield drifting through it and a gently pulsing purple glow.
/// Used wherever an off-today screen wants to jump back to today.
class WarpButton extends StatefulWidget {
  const WarpButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  State<WarpButton> createState() => _WarpButtonState();
}

class _WarpButtonState extends State<WarpButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 4))
        ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopTappable(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, _) {
          final pulse = 0.5 + 0.5 * math.sin(_c.value * 2 * math.pi);
          return Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2A2350), Color(0xFF5B45C9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppRadii.r(AppRadii.pill),
              border: Border.all(color: AppColors.ink, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color:
                      AppColors.popPurple.withValues(alpha: 0.25 + 0.3 * pulse),
                  blurRadius: 10 + 10 * pulse,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(painter: _StarfieldPainter(_c.value)),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
                  child: Text('WARP TO PRESENT',
                      style: AppType.label.copyWith(
                          fontSize: 15,
                          color: AppColors.cream,
                          letterSpacing: 0.8)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Slowly drifting, twinkling stars painted inside the warp button.
class _StarfieldPainter extends CustomPainter {
  _StarfieldPainter(this.t);
  final double t;

  static final List<(double, double, double, double)> _stars = () {
    final r = math.Random(42);
    return [
      for (var i = 0; i < 16; i++)
        (r.nextDouble(), r.nextDouble(), r.nextDouble(),
            0.7 + r.nextDouble() * 1.8),
    ];
  }();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final (x, y, phase, radius) in _stars) {
      final nx = (x + t) % 1.0;
      final twinkle = 0.5 + 0.5 * math.sin((t + phase) * 2 * math.pi);
      final edge = math.sin(nx * math.pi);
      paint.color =
          Colors.white.withValues(alpha: (0.3 + 0.7 * twinkle) * edge * 0.85);
      canvas.drawCircle(
          Offset(nx * size.width, y * size.height), radius, paint);
    }
  }

  @override
  bool shouldRepaint(_StarfieldPainter old) => old.t != t;
}
