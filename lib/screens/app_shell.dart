import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/app_providers.dart'; // re-exports dateOnly + le_math helpers
import '../theme/theme.dart';
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

  void _jump(int i) {
    _controller.animateToPage(i,
        duration: AppMotion.pop, curve: AppMotion.curvePop);
    Navigator.of(context).maybePop();
  }

  void _openNav() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _NavSheet(onPick: _jump),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: ref.read(selectedDateProvider),
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      ref.read(selectedDateProvider.notifier).state = dateOnly(picked);
    }
  }

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
                child: CustomPaint(
                    painter: _LiquidPainter(leIntoLevel(le) / 50)),
              ),
            ),
          PageView(
            controller: _controller,
            onPageChanged: (i) => setState(() => _index = i),
            children: const [
              BiomePage(),
              SideQuestPage(),
              TasksPage(),
              JournalPage(),
            ],
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
                        level: currentLevel(le), fraction: leIntoLevel(le) / 50),
                    CentralNav(onTap: _openNav),
                    CalendarButton(
                      isToday: isToday,
                      onTap: isToday
                          ? null
                          : () => ref
                              .read(selectedDateProvider.notifier)
                              .state = dateOnly(DateTime.now()),
                      onLongPress: _pickDate,
                    ),
                  ],
                ),
              ),
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

class _NavSheet extends StatelessWidget {
  const _NavSheet({required this.onPick});
  final void Function(int) onPick;

  @override
  Widget build(BuildContext context) {
    Widget item(IconData icon, String label, int index, Color c) => ListTile(
          leading: CircleAvatar(backgroundColor: c, child: Icon(icon, color: Colors.white)),
          title: Text(label, style: AppType.bodyL),
          onTap: () => onPick(index),
        );
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
        border: Border(top: BorderSide(color: AppColors.ink, width: 3)),
      ),
      child: SafeArea(
        top: false,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 12),
          Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                  color: AppColors.hazeDeep,
                  borderRadius: BorderRadius.circular(AppRadii.pill))),
          item(Icons.park_rounded, 'Biome', 0, const Color(0xFF7AC974)),
          item(Icons.flag_rounded, 'Side Quests', 1, AppColors.popPurple),
          item(Icons.check_box_rounded, 'Tasks', 2, AppColors.popPink),
          item(Icons.menu_book_rounded, 'Journal + Habits', 3, AppColors.popTeal),
          const SizedBox(height: 12),
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
