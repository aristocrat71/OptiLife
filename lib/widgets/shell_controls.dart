import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'pop_tappable.dart';

/// Top-left circular LE ring gauge (48×48). [fraction] is 0..1 progress within
/// the current level; [level] shows in the corner badge.
class LeRingGauge extends StatelessWidget {
  const LeRingGauge({super.key, required this.level, required this.fraction, this.onTap});
  final int level;
  final double fraction;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PopTappable(
      onTap: onTap,
      child: SizedBox(
        width: AppSpace.shellControl,
        height: AppSpace.shellControl,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            DecoratedBox(
              decoration: popSurface(radius: AppRadii.pill),
              child: const SizedBox.expand(),
            ),
            Positioned.fill(
              child: CustomPaint(painter: _RingPainter(fraction.clamp(0, 1))),
            ),
            const Center(child: Icon(Icons.bolt, size: 18, color: AppColors.energy)),
            Positioned(
              right: -3,
              bottom: -3,
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.popPurple,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.ink, width: 2),
                ),
                child: Text('$level',
                    style: AppType.label.copyWith(fontSize: 11, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.fraction);
  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2 - 8;
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..color = AppColors.haze;
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..color = AppColors.energy;
    canvas.drawCircle(c, r, track);
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), -math.pi / 2,
        2 * math.pi * fraction, false, arc);
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.fraction != fraction;
}

/// Top-middle heartbeat-pulsing nav circle with outward ripple waves.
class CentralNav extends StatefulWidget {
  const CentralNav({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  State<CentralNav> createState() => _CentralNavState();
}

class _CentralNavState extends State<CentralNav> with TickerProviderStateMixin {
  late final AnimationController _beat = AnimationController(
      vsync: this, duration: AppMotion.heartbeat)
    ..repeat(reverse: true);
  late final AnimationController _ripple =
      AnimationController(vsync: this, duration: AppMotion.ripple)..repeat();

  @override
  void dispose() {
    _beat.dispose();
    _ripple.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const d = AppSpace.navCircle;
    return SizedBox(
      width: d + 24,
      height: d + 24,
      child: Stack(
        alignment: Alignment.center,
        children: [
          IgnorePointer(
            child: AnimatedBuilder(
              animation: _ripple,
              builder: (_, _) =>
                  CustomPaint(size: const Size(d + 24, d + 24), painter: _RipplePainter(_ripple.value)),
            ),
          ),
          ScaleTransition(
            scale: Tween(begin: 1.0, end: 1.08).animate(
                CurvedAnimation(parent: _beat, curve: Curves.easeInOut)),
            child: PopTappable(
              onTap: widget.onTap,
              child: Container(
                width: d,
                height: d,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.popPurple,
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(
                      BorderSide(color: AppColors.ink, width: 3)),
                ),
                child: const Icon(Icons.favorite, color: Colors.white, size: 26),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  _RipplePainter(this.t);
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    const base = 35.0, spread = 24.0;
    for (var i = 0; i < 3; i++) {
      final phase = (t + i / 3) % 1.0;
      final radius = base + spread * phase;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = AppColors.popPurple.withValues(alpha: 0.42 * (1 - phase));
      canvas.drawCircle(c, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_RipplePainter old) => old.t != t;
}

/// Top-right circular calendar button. [isToday] toggles the off-today badge.
class CalendarButton extends StatelessWidget {
  const CalendarButton(
      {super.key, required this.isToday, this.onTap, this.onLongPress});
  final bool isToday;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: PopTappable(
        onTap: onTap,
        child: SizedBox(
          width: AppSpace.shellControl,
          height: AppSpace.shellControl,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                alignment: Alignment.center,
                decoration: popSurface(
                    radius: AppRadii.pill,
                    fill: isToday ? AppColors.paper : AppColors.haze),
                child: const Icon(Icons.calendar_today_rounded,
                    size: 20, color: AppColors.ink),
              ),
              if (!isToday)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 18,
                    height: 18,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.popPink,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.ink, width: 2),
                    ),
                    child: const Icon(Icons.arrow_back,
                        size: 10, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Big-number, container-less date display (SQ & Tasks). E.g. `22 | MAY / THU`.
class DateDisplay extends StatelessWidget {
  const DateDisplay({super.key, required this.date});
  final DateTime date;

  static const _months = [
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
  ];
  static const _days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('${date.day}', style: AppType.numXL),
        const SizedBox(width: 11),
        Container(
            width: 4,
            height: 36,
            decoration: BoxDecoration(
                color: AppColors.popPink,
                borderRadius: AppRadii.r(AppRadii.pill))),
        const SizedBox(width: 11),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_months[date.month - 1],
                style: AppType.label.copyWith(fontSize: 16, letterSpacing: 1.6)),
            Text(_days[date.weekday - 1],
                style: AppType.label.copyWith(
                    fontSize: 13,
                    letterSpacing: 1.3,
                    color: AppColors.textMuted)),
          ],
        ),
      ],
    );
  }
}

/// Bottom page indicator; active dot stretches to a pill (with a tree on Biome).
class PageDots extends StatelessWidget {
  const PageDots({super.key, required this.count, required this.activeIndex});
  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: AppMotion.pop,
            curve: AppMotion.curvePop,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: i == activeIndex ? 30 : 9,
            height: i == activeIndex ? 11 : 9,
            decoration: BoxDecoration(
              color: i == activeIndex
                  ? AppColors.popPurple
                  : AppColors.ink.withValues(alpha: 0.25),
              borderRadius: AppRadii.r(AppRadii.pill),
              border: i == activeIndex
                  ? Border.all(color: AppColors.ink, width: 2)
                  : null,
            ),
          ),
      ],
    );
  }
}
