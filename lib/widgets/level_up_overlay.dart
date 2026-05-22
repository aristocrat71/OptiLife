import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/theme.dart';
import 'pop_tappable.dart';

/// Full-screen LEVEL UP celebration (`10-secondary-screens.md §9`). Shown when a
/// mark/log crosses a 50-LE boundary. A category-coloured confetti burst rains
/// over a hero card.
///
/// Tree **placement** lives on the Biome screen (still a stub), so for now the
/// pop is tap-to-dismiss; the pending tree stays queued in `app_state`.
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

/// Friendly tree label for the celebration copy. `normal` (habit-driven level-up
/// with no quests in window — Data Models §7.8) reads as a plain "new tree".
String _treeLabel(QuestCategory c) => switch (c) {
      QuestCategory.adventure => 'An Adventure tree',
      QuestCategory.fitness => 'A Fitness tree',
      QuestCategory.social => 'A Social tree',
      QuestCategory.creative => 'A Creative tree',
      QuestCategory.night => 'A Night tree',
      QuestCategory.normal => 'A new tree',
    };

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

  @override
  void dispose() {
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
            Text(
              '✦  LEVEL UP!  ✦',
              style: AppType.label.copyWith(
                fontSize: 16,
                color: AppColors.cream,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: AppRadii.r(AppRadii.md),
                border: Border.all(color: AppColors.ink, width: 2.5),
              ),
              child: Text('LV ${widget.level}', style: AppType.numXL),
            ),
            const SizedBox(height: 18),
            Text(
              '${_treeLabel(widget.category)} is ready 🌳',
              textAlign: TextAlign.center,
              style: AppType.bodyL.copyWith(color: AppColors.cream),
            ),
            const SizedBox(height: 6),
            Text(
              'Plant it in your biome',
              style: AppType.caption.copyWith(
                color: AppColors.cream.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: 18),
            // Placement isn't built yet, so this dismisses for now.
            PopTappable(
              onTap: () => Navigator.of(context).maybePop(),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
                decoration: popSurface(
                  fill: AppColors.cream,
                  radius: AppRadii.pill,
                  stroke: 2.5,
                  shadow: false,
                ),
                child: Text('Nice!', style: AppType.label.copyWith(fontSize: 15)),
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
