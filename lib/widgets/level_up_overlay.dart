import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/theme.dart';
import 'pop_tappable.dart';

/// Full-screen LEVEL UP celebration (`10-secondary-screens.md §9`, motion §2.5).
/// Shown when a mark/log crosses a 50-LE boundary. A category-coloured confetti
/// burst rains over a hero card.
///
/// On dismiss (tap or ~1.4s auto-advance), the pending tree set on `app_state`
/// drives the shell into Biome placement mode (the hard lock in `app_shell`).
Future<void> showLevelUp(
  BuildContext context, {
  required int level,
  required QuestCategory category,
}) {
  HapticFeedback.heavyImpact();
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'Level up',
    barrierColor: AppColors.ink.withValues(alpha: 0.6),
    transitionDuration: AppMotion.pop,
    pageBuilder: (_, _, _) =>
        _LevelUpOverlay(level: level, category: category),
    transitionBuilder: (_, anim, _, child) =>
        FadeTransition(opacity: anim, child: child),
  );
}

class _LevelUpOverlay extends StatefulWidget {
  const _LevelUpOverlay({required this.level, required this.category});
  final int level;
  final QuestCategory category;

  @override
  State<_LevelUpOverlay> createState() => _LevelUpOverlayState();
}

class _LevelUpOverlayState extends State<_LevelUpOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _burst = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..forward();
  late final AnimationController _pop = AnimationController(
    vsync: this,
    duration: AppMotion.pop,
  )..forward();

  // Auto-advance into placement after the celebration beat (motion §2.5).
  Timer? _auto;

  void _dismiss() {
    if (mounted) Navigator.of(context).maybePop();
  }

  @override
  void initState() {
    super.initState();
    _auto = Timer(const Duration(milliseconds: 4000), _dismiss);
  }

  @override
  void dispose() {
    _auto?.cancel();
    _burst.dispose();
    _pop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = AppColors.category(widget.category);
    return GestureDetector(
      onTap: () => Navigator.of(context).maybePop(),
      behavior: HitTestBehavior.opaque,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Confetti rains over the whole screen.
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _burst,
                builder: (_, _) => CustomPaint(
                  painter: _ConfettiPainter(_burst.value, color),
                ),
              ),
            ),
          ),
          ScaleTransition(
            scale: Tween(begin: 0.7, end: 1.0).animate(
              CurvedAnimation(parent: _pop, curve: AppMotion.curvePop),
            ),
            child: _heroCard(color),
          ),
        ],
      ),
    );
  }

  Widget _heroCard(Color color) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 44),
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 26),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.popPurple, AppColors.popPink],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: AppRadii.r(AppRadii.lg),
          border: Border.all(color: AppColors.ink, width: 3),
          boxShadow: AppShadows.hero,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_awesome_rounded,
                    size: 16, color: AppColors.cream),
                const SizedBox(width: 8),
                Text(
                  'LEVEL UP!',
                  style: AppType.label.copyWith(
                    fontSize: 16,
                    color: AppColors.cream,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.auto_awesome_rounded,
                    size: 16, color: AppColors.cream),
              ],
            ),
            const SizedBox(height: 12),
            Text('LVL ${widget.level}',
                style: AppType.numXL.copyWith(color: AppColors.cream)),
            const SizedBox(height: 16),
            Text(
              'Your tree is ready to be planted!',
              textAlign: TextAlign.center,
              style: AppType.bodyL.copyWith(color: AppColors.cream),
            ),
            const SizedBox(height: 18),
            // Dismiss → the shell drops into Biome placement mode.
            PopTappable(
              onTap: _dismiss,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
                decoration: popSurface(
                  fill: AppColors.cream,
                  radius: AppRadii.pill,
                  stroke: 2.5,
                  shadow: false,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Plant it',
                        style: AppType.label.copyWith(fontSize: 15)),
                    const SizedBox(width: 6),
                    const Icon(Icons.park_rounded,
                        size: 16, color: AppColors.ink),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A one-shot confetti burst: ribbons fly outward from centre, tumble, and fall
/// under gravity while fading at the end. Category colour + POP accents.
class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.t, this.color);
  final double t; // 0..1
  final Color color;

  static final _pieces = () {
    final r = math.Random(7);
    return [
      for (var i = 0; i < 70; i++)
        (
          angle: r.nextDouble() * 2 * math.pi,
          speed: 0.5 + r.nextDouble(),
          spin: (r.nextDouble() - 0.5) * 14,
          size: 5.0 + r.nextDouble() * 7,
          tint: r.nextInt(4),
          phase: r.nextDouble(),
        ),
    ];
  }();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.42);
    final palette = [
      color,
      AppColors.popYellow,
      AppColors.popTeal,
      AppColors.cream,
    ];
    final paint = Paint();
    for (final p in _pieces) {
      final reach = size.height * 0.6 * p.speed;
      final dx = math.cos(p.angle) * reach * t;
      // outward + gravity pulling down as it travels
      final dy = math.sin(p.angle) * reach * t + 0.5 * 900 * t * t * p.speed;
      final pos = center + Offset(dx, dy);
      final fade = (1 - (t - 0.7) / 0.3).clamp(0.0, 1.0);
      paint.color = palette[p.tint].withValues(alpha: fade);
      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(p.spin * t + p.phase * 6.28);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset.zero, width: p.size, height: p.size * 0.6),
          const Radius.circular(1.5),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) =>
      old.t != t || old.color != color;
}
