import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/theme.dart';
import '../../widgets/pop_tappable.dart';

/// REBOOT? hero sheet shown after the 100th tree is planted (`02-biome.md §6`).
/// Returns `true` if the user confirms the (destructive) reset.
Future<bool> showRebootSheet(BuildContext context) async {
  HapticFeedback.mediumImpact();
  final result = await showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Reboot biome',
    barrierColor: AppColors.ink.withValues(alpha: AppZ.scrim),
    transitionDuration: AppMotion.pop,
    pageBuilder: (ctx, _, _) => Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 36),
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
          decoration:
              popSurface(fill: AppColors.paper, radius: AppRadii.lg, stroke: 3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🌍', style: TextStyle(fontSize: 44)),
              const SizedBox(height: 12),
              Text('YOUR BIOME IS COMPLETE',
                  style: AppType.label.copyWith(fontSize: 16, letterSpacing: 1)),
              const SizedBox(height: 6),
              Text('100 trees planted!',
                  style: AppType.bodyL.copyWith(color: AppColors.popPurple)),
              const SizedBox(height: 14),
              Text(
                'Reboot starts a fresh, empty world. Your Life Energy and Levels will be reset.'
                'Teaching you the Art of letting go',
                textAlign: TextAlign.center,
                style: AppType.body.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: PopTappable(
                      onTap: () => Navigator.of(ctx).pop(false),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: popSurface(
                            fill: AppColors.haze,
                            radius: AppRadii.pill,
                            stroke: 2.5,
                            shadow: false),
                        child: Text('View',
                            style: AppType.label.copyWith(fontSize: 15)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PopTappable(
                      onTap: () => Navigator.of(ctx).pop(true),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: popSurface(
                            fill: AppColors.popCoral,
                            radius: AppRadii.pill,
                            stroke: 2.5),
                        child: Text('REBOOT',
                            style: AppType.label
                                .copyWith(fontSize: 15, color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    transitionBuilder: (_, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: AppMotion.curvePop);
      return FadeTransition(
        opacity: anim,
        child: ScaleTransition(
            scale: Tween(begin: 0.6, end: 1.0).animate(curved), child: child),
      );
    },
  );
  return result ?? false;
}

/// The "dimensional travel" warp (`02-biome.md §6.4`, motion §2.7): the world
/// zooms into a swirling purple→pink→teal tunnel, then settles. Full-screen,
/// non-dismissible; auto-pops after [AppMotion.travel]. Pops itself, so the
/// returned future completes when the warp is done.
Future<void> showDimensionalTravel(BuildContext context) {
  HapticFeedback.heavyImpact();
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'Reboot travel',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (_, _, _) => const _DimensionalTravel(),
    transitionBuilder: (_, anim, _, child) =>
        FadeTransition(opacity: anim, child: child),
  );
}

class _DimensionalTravel extends StatefulWidget {
  const _DimensionalTravel();

  @override
  State<_DimensionalTravel> createState() => _DimensionalTravelState();
}

class _DimensionalTravelState extends State<_DimensionalTravel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: AppMotion.travel,
  )..forward();

  @override
  void initState() {
    super.initState();
    _c.addStatusListener((s) {
      if (s == AnimationStatus.completed && mounted) {
        Navigator.of(context).maybePop();
      }
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, _) =>
          CustomPaint(size: Size.infinite, painter: _TunnelPainter(_c.value)),
    );
  }
}

/// Concentric gradient rings rushing out from centre with a swirl rotation —
/// reads as zooming through a tunnel. Envelope fades in, peaks, fades out so
/// the (now empty) world is revealed underneath at the end.
class _TunnelPainter extends CustomPainter {
  _TunnelPainter(this.t);
  final double t; // 0..1 linear drive.

  // Hyperdrive palette: white star-light → electric cyan → hyperblue → indigo.
  static const _space = Color(0xFF05071A);
  static const _colors = [
    Color(0xFFFFFFFF),
    Color(0xFF7DF9FF),
    Color(0xFF3A86FF),
    Color(0xFF6C5CE7),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    // The swirl/zoom accelerates — slow at first, rushing by the end.
    final motion = Curves.easeInCubic.transform(t);
    // Cover-then-reveal is timed on the linear drive so it stays opaque while
    // the world is wiped behind it (mid-animation), regardless of the easing.
    final envelope = math.sin(t * math.pi).clamp(0.0, 1.0);
    if (envelope <= 0) return;

    // Deep-space backdrop drops in, hiding the world swap behind the warp.
    canvas.drawRect(Offset.zero & size,
        Paint()..color = _space.withValues(alpha: envelope));

    final center = Offset(size.width / 2, size.height / 2);
    final maxR = size.longestSide * 0.75;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(motion * math.pi * 1.5); // swirl
    canvas.translate(-center.dx, -center.dy);

    const rings = 14;
    for (var i = 0; i < rings; i++) {
      // Each ring rushes outward; staggered so they form a moving tunnel.
      final phase = (motion * 2 + i / rings) % 1.0;
      final radius = maxR * phase;
      if (radius <= 0) continue;
      final color = _colors[i % _colors.length];
      final alpha = envelope * (1 - phase) * 0.9;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 26 * (1 - phase) + 6
        ..color = color.withValues(alpha: alpha.clamp(0.0, 1.0));
      canvas.drawCircle(center, radius, paint);
    }
    canvas.restore();

    // A bright white-hot core blooming at light-speed centre.
    final core = Paint()
      ..color = const Color(0xFFFFFFFF).withValues(alpha: envelope * 0.9);
    canvas.drawCircle(center, maxR * 0.16 * envelope, core);
  }

  @override
  bool shouldRepaint(_TunnelPainter old) => old.t != t;
}
