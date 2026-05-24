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
              const Icon(Icons.public_rounded, size: 44, color: AppColors.popTeal),
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

  // The streak field is generated once (stable seed) so the same stars stream
  // outward every frame instead of flickering to new random ones.
  late final List<_Streak> _streaks = _buildStreaks();

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
      builder: (_, _) => CustomPaint(
        size: Size.infinite,
        painter: _HyperdrivePainter(_c.value, _streaks),
      ),
    );
  }
}

/// One light streak: a fixed bearing from centre, its own speed + phase so the
/// field doesn't pulse in lockstep, plus a colour and base thickness.
class _Streak {
  const _Streak(this.angle, this.offset, this.speed, this.color, this.width);
  final double angle; // radians, fixed bearing from centre
  final double offset; // 0..1 phase so streaks stagger
  final double speed; // per-streak rate multiplier
  final Color color;
  final double width;
}

/// Hyperdrive palette — mostly cool star-light (white / cyan / blue / teal)
/// with a few warm + green accents thrown in, weighted by repetition.
const _streakPalette = <Color>[
  Color(0xFFFFFFFF), Color(0xFFFFFFFF), Color(0xFFFFFFFF), // white star-light
  Color(0xFF7DF9FF), Color(0xFF7DF9FF), Color(0xFF7DF9FF), // electric cyan
  Color(0xFF3A86FF), Color(0xFF3A86FF), Color(0xFF3A86FF), // hyperblue
  Color(0xFF2EE6A8), Color(0xFF2EE6A8), // teal-green
  Color(0xFF6C5CE7), // indigo
  Color(0xFF6EF26E), // lime accent
  Color(0xFFFF5A5F), // coral-red accent
  Color(0xFFFF4D9D), // pink accent
];

List<_Streak> _buildStreaks() {
  final rnd = math.Random(7);
  return List.generate(180, (_) {
    final angle = rnd.nextDouble() * 2 * math.pi;
    final offset = rnd.nextDouble();
    final speed = 0.7 + rnd.nextDouble() * 0.9;
    final color = _streakPalette[rnd.nextInt(_streakPalette.length)];
    final width = 1.2 + rnd.nextDouble() * 2.6;
    return _Streak(angle, offset, speed, color, width);
  });
}

/// Light streaks rushing out from a white-hot centre — a starfield punched into
/// hyperspace. Streaks accelerate, lengthen and brighten as they fly to the
/// edge. A sine envelope fades the whole field in, holds, then out, so the
/// (now empty) world is revealed underneath at the end.
class _HyperdrivePainter extends CustomPainter {
  _HyperdrivePainter(this.t, this.streaks);
  final double t; // 0..1 linear drive.
  final List<_Streak> streaks;

  static const _space = Color(0xFF05071A);

  @override
  void paint(Canvas canvas, Size size) {
    // Acceleration: slow at first, rushing by the end.
    final motion = Curves.easeInCubic.transform(t);
    final envelope = math.sin(t * math.pi).clamp(0.0, 1.0);
    if (envelope <= 0) return;

    // Deep-space backdrop drops in, hiding the world swap behind the warp.
    canvas.drawRect(Offset.zero & size,
        Paint()..color = _space.withValues(alpha: envelope));

    final center = Offset(size.width / 2, size.height / 2);
    final maxR = size.longestSide * 0.72;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(motion * 0.5); // a gentle swirl, not a full spin
    // Additive blending so overlapping streaks glow and pile into white light
    // at the core — the luminous hyperspace look.
    final paint = Paint()
      ..blendMode = BlendMode.plus
      ..strokeCap = StrokeCap.round;

    for (final s in streaks) {
      // Looping phase: each streak repeatedly flies out from the centre.
      final p = (motion * 2.3 * s.speed + s.offset) % 1.0;
      final lead = maxR * math.pow(p, 1.7).toDouble();
      if (lead <= 1) continue;
      // Streaks are short near the centre, long (motion-blurred) near the edge.
      final len = maxR * (0.03 + 0.30 * p);
      final trail = (lead - len).clamp(0.0, lead);
      final dir = Offset(math.cos(s.angle), math.sin(s.angle));

      // Dim at the centre, bright toward the edge; soft fade-in/out at the ends.
      var a = envelope * (0.35 + 0.65 * p);
      if (p < 0.05) a *= p / 0.05;
      if (p > 0.9) a *= (1 - p) / 0.1;

      paint
        ..color = s.color.withValues(alpha: a.clamp(0.0, 1.0))
        ..strokeWidth = s.width * (0.6 + 1.4 * p);
      canvas.drawLine(dir * trail, dir * lead, paint);
    }
    canvas.restore();

    // White-hot core: a bright radial bloom at light-speed centre.
    final bloomR = maxR * (0.10 + 0.05 * motion) * envelope;
    if (bloomR > 0) {
      final bloom = Paint()
        ..blendMode = BlendMode.plus
        ..shader = RadialGradient(
          colors: [
            Colors.white.withValues(alpha: envelope),
            Colors.white.withValues(alpha: envelope * 0.4),
            Colors.white.withValues(alpha: 0),
          ],
          stops: const [0.0, 0.35, 1.0],
        ).createShader(
            Rect.fromCircle(center: center, radius: bloomR * 2.4));
      canvas.drawCircle(center, bloomR * 2.4, bloom);
      canvas.drawCircle(center, bloomR * 0.5,
          Paint()..color = Colors.white.withValues(alpha: envelope));
    }
  }

  @override
  bool shouldRepaint(_HyperdrivePainter old) => old.t != t;
}
