import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/app_providers.dart'; // re-exports dateOnly + le_math helpers
import '../theme/theme.dart';
import '../widgets/pop_tappable.dart';
import '../widgets/radial_menu.dart';
import '../widgets/shell_controls.dart';
import 'placeholder_pages.dart';
import 'side_quest_page.dart';

/// Hosts the always-on sticky shell over a horizontally-swiped PageView
/// (Biome ← SQ → Tasks → Journal). Landing page = Side Quest (index 1).
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});
  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  final _controller = PageController(initialPage: 1);
  int _index = 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openNav() async {
    final i = await showRadialMenu(context);
    if (i != null && mounted) {
      _controller.animateToPage(i,
          duration: AppMotion.pop, curve: AppMotion.curvePop);
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    // Calendar grid that commits the moment a day is tapped — no OK/Cancel.
    final picked = await showDialog<DateTime>(
      context: context,
      builder: (ctx) => Dialog(
        child: SizedBox(
          width: 340,
          height: 380,
          child: CalendarDatePicker(
            initialDate: ref.read(selectedDateProvider),
            firstDate: DateTime(now.year - 1),
            lastDate: DateTime(now.year + 1),
            onDateChanged: (d) => Navigator.of(ctx).pop(d),
          ),
        ),
      ),
    );
    if (picked != null) {
      ref.read(selectedDateProvider.notifier).state = dateOnly(picked);
    }
  }

  void _goToToday() =>
      ref.read(selectedDateProvider.notifier).state = dateOnly(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appStateProvider);
    final le = app.asData?.value.lifetimeLe ?? 0;
    final isToday = ref.watch(isTodayProvider);

    return Scaffold(
      body: Stack(
        children: [
          if (_index != 0)
            Positioned.fill(
              child: IgnorePointer(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(end: leIntoLevel(le) / 50),
                  duration: AppMotion.fill,
                  curve: AppMotion.curveFill,
                  builder: (_, v, _) =>
                      CustomPaint(painter: _LiquidPainter(v)),
                ),
              ),
            ),
          // Reserve the bottom band so page content never sits under the dots.
          Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 40),
            child: PageView(
              controller: _controller,
              onPageChanged: (i) => setState(() => _index = i),
              children: const [
                BiomePage(),
                SideQuestPage(),
                TasksPage(),
                JournalPage(),
              ],
            ),
          ),
          // sticky shell
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpace.screenGutter, 6,
                    AppSpace.screenGutter, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LeRingGauge(
                      level: currentLevel(le),
                      fraction: leIntoLevel(le) / 50,
                      into: leIntoLevel(le),
                      goal: 50,
                    ),
                    CentralNav(onTap: _openNav),
                    CalendarButton(
                      isToday: isToday,
                      // §5.3: off-today tap springs back to today; long-press
                      // (or tap while already on today) opens the picker.
                      onTap: isToday ? _pickDate : _goToToday,
                      onLongPress: _pickDate,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // "Go to Present" — only when viewing another day. Floats above the
          // page dots so it never collides with the date display / header.
          if (!isToday)
            Positioned(
              bottom: AppSpace.pageDotsInset + 30,
              left: 0,
              right: 0,
              child: SafeArea(
                top: false,
                child: Center(child: _GoToPresentPill(onTap: _goToToday)),
              ),
            ),
          Positioned(
            bottom: AppSpace.pageDotsInset,
            left: 0,
            right: 0,
            child: SafeArea(
                top: false,
                child: PageDots(count: 4, activeIndex: _index)),
          ),
        ],
      ),
    );
  }
}

/// Floating pill that returns the global date to today. Shown only off-today.
class _GoToPresentPill extends StatelessWidget {
  const _GoToPresentPill({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PopTappable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: popSurface(
            fill: AppColors.popPink, radius: AppRadii.pill, stroke: 2.5),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.today_rounded, size: 16, color: AppColors.cream),
          const SizedBox(width: 7),
          Text('GO TO PRESENT',
              style: AppType.label
                  .copyWith(fontSize: 13, color: AppColors.cream)),
        ]),
      ),
    );
  }
}

/// Lightweight static liquid-fill background (two phase-shifted sine waves).
/// Height ∝ LE within the current level. Animation comes later (`08-motion.md`).
class _LiquidPainter extends CustomPainter {
  _LiquidPainter(this.fraction);
  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {
    final fillTop = size.height * (1 - (0.12 + 0.33 * fraction.clamp(0, 1)));
    final paint = Paint()
      ..color = AppColors.popPurple.withValues(alpha: 0.16);
    for (final cfg in [(amp: 10.0, phase: 0.0), (amp: 7.0, phase: math.pi)]) {
      final path = Path()..moveTo(0, fillTop);
      for (double x = 0; x <= size.width; x += 8) {
        path.lineTo(
            x, fillTop + math.sin(x / size.width * 2 * math.pi + cfg.phase) * cfg.amp);
      }
      path
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_LiquidPainter old) => old.fraction != fraction;
}
