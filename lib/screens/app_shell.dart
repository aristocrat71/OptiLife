import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/app_providers.dart'; // re-exports dateOnly + le_math helpers
import '../theme/theme.dart';
import '../widgets/pop_calendar.dart';
import '../widgets/radial_menu.dart';
import '../widgets/shell_controls.dart';
import 'journal_page.dart';
import 'placeholder_pages.dart';
import 'settings_page.dart';
import 'side_quest_page.dart';
import 'tasks_page.dart';

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
    if (i == null || !mounted) return;
    if (i == kRadialSettings) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const SettingsPage()));
    } else {
      _goToPage(i);
    }
  }

  void _goToPage(int i) => _controller.animateToPage(i,
      duration: AppMotion.pop, curve: AppMotion.curvePop);

  Future<void> _pickDate() async {
    final now = DateTime.now();
    // Standard Material calendar (it sizes itself, so no clipping), committing
    // the moment a day is tapped — no OK/Cancel. Kept the pop entrance.
    final picked = await showGeneralDialog<DateTime>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Pick a date',
      barrierColor: AppColors.ink.withValues(alpha: AppZ.scrim),
      transitionDuration: AppMotion.pop,
      pageBuilder: (ctx, _, _) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: math.min(
                MediaQuery.of(ctx).size.width - 2 * AppSpace.screenGutter, 360),
            padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
            decoration: popSurface(
                fill: AppColors.paper, radius: AppRadii.lg, stroke: 3),
            child: PopCalendar(
              selectedDate: ref.read(selectedDateProvider),
              firstDate: DateTime(now.year - 1),
              lastDate: DateTime(now.year + 1),
              onSelect: (d) => Navigator.of(ctx).pop(d),
            ),
          ),
        ),
      ),
      transitionBuilder: (_, anim, _, child) {
        final curved = CurvedAnimation(parent: anim, curve: AppMotion.curvePop);
        return FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            scale: Tween(begin: 0.5, end: 1.0).animate(curved),
            child: RotationTransition(
              turns: Tween(begin: -0.05, end: 0.0).animate(curved),
              child: child,
            ),
          ),
        );
      },
    );
    if (picked != null) {
      ref.read(selectedDateProvider.notifier).state = dateOnly(picked);
    }
  }

  void _goToToday() =>
      ref.read(selectedDateProvider.notifier).state = dateOnly(DateTime.now());

  /// Wraps a page so it tilts back in 3D, shrinks and fades as it slides away
  /// from center — the deck flips like cards on a turntable while swiping.
  Widget _depthPage(int index, Widget child) {
    return AnimatedBuilder(
      animation: _controller,
      child: child,
      builder: (context, child) {
        var page = _index.toDouble();
        if (_controller.hasClients && _controller.position.haveDimensions) {
          page = _controller.page ?? page;
        }
        final t = (page - index).clamp(-1.0, 1.0);
        final a = t.abs();
        return Opacity(
          opacity: (1 - 0.55 * a).clamp(0.0, 1.0),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0015) // perspective
              ..rotateY(-0.55 * t) // tilt toward the incoming page
              ..scaleByDouble(1 - 0.22 * a, 1 - 0.22 * a, 1, 1),
            child: child,
          ),
        );
      },
    );
  }

  /// The sticky date display, positioned where each page used to render it
  /// (absolute top, tuned to clear the shell controls). Opacity tracks the
  /// horizontal swipe so it dissolves on the way into Biome and is solid
  /// elsewhere; a date change cross-fades the new day in.
  Widget _stickyDate(DateTime date) {
    return Positioned(
      top: 128,
      left: AppSpace.screenGutter,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            var page = _index.toDouble();
            if (_controller.hasClients && _controller.position.haveDimensions) {
              page = _controller.page ?? page;
            }
            return Opacity(opacity: page.clamp(0.0, 1.0), child: child);
          },
          child: AnimatedSwitcher(
            duration: AppMotion.pop,
            switchInCurve: AppMotion.curvePop,
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween(begin: const Offset(0, 0.22), end: Offset.zero)
                    .animate(anim),
                child: child,
              ),
            ),
            child: DateDisplay(key: ValueKey(date), date: date),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appStateProvider);
    final le = app.asData?.value.lifetimeLe ?? 0;
    final isToday = ref.watch(isTodayProvider);
    final date = ref.watch(selectedDateProvider);
    // Honour the Appearance setting — when off, drop the backdrop entirely.
    final liquidOn =
        ref.watch(settingsProvider).asData?.value.liquidFillEnabled ?? true;

    return Scaffold(
      body: Stack(
        children: [
          // Persistent, independent backdrop: always the bottom layer, never
          // inside the PageView, so horizontal swipes never move it. Sections
          // with their own opaque world (Biome) simply paint over it.
          if (liquidOn)
            Positioned.fill(
              child: _LiquidBackground(fraction: leIntoLevel(le) / 50),
            ),
          // Reserve the bottom band so page content never sits under the dots.
          Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 40),
            child: PageView(
              controller: _controller,
              onPageChanged: (i) => setState(() => _index = i),
              children: [
                _depthPage(0, const BiomePage()),
                _depthPage(1, const SideQuestPage()),
                _depthPage(2, const TasksPage()),
                _depthPage(3, const JournalPage()),
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
                    CentralNav(
                        onTap: _openNav, color: _navTargets[_index].color),
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
          // Sticky date: lives in the shell (not the PageView), so it stays put
          // during horizontal swipes instead of tilting with the page deck. It
          // fades out as you swipe toward Biome (index 0), which has no date.
          _stickyDate(date),
          // Directional edge peeks replace the page dots: the adjacent pages'
          // icons hug the bottom corners (tap to glide there).
          if (_index > 0)
            Positioned(
              bottom: AppSpace.pageDotsInset,
              left: AppSpace.screenGutter,
              child: SafeArea(
                top: false,
                child: _EdgePeek(
                  target: _navTargets[_index - 1],
                  pointLeft: true,
                ),
              ),
            ),
          if (_index < _navTargets.length - 1)
            Positioned(
              bottom: AppSpace.pageDotsInset,
              right: AppSpace.screenGutter,
              child: SafeArea(
                top: false,
                child: _EdgePeek(
                  target: _navTargets[_index + 1],
                  pointLeft: false,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Icon + color for each PageView destination (Biome · SQ · Tasks · Journal).
class _NavTarget {
  const _NavTarget(this.icon, this.color);
  final IconData icon;
  final Color color;
}

const _navTargets = [
  _NavTarget(Icons.park_outlined, AppColors.biomeGreen),
  _NavTarget(Icons.flag_outlined, AppColors.popPurple),
  _NavTarget(Icons.check_box_outlined, AppColors.popPink),
  _NavTarget(Icons.menu_book_outlined, AppColors.popTeal),
];

/// A minimalist bottom-corner peek at the adjacent page: a clean outline icon
/// in the page's color, with a chevron that rhythmically nudges outward to
/// beckon a swipe. Non-interactive — swiping is the only way to navigate.
class _EdgePeek extends StatefulWidget {
  const _EdgePeek({required this.target, required this.pointLeft});
  final _NavTarget target;
  final bool pointLeft;

  @override
  State<_EdgePeek> createState() => _EdgePeekState();
}

class _EdgePeekState extends State<_EdgePeek>
    with SingleTickerProviderStateMixin {
  late final AnimationController _beckon = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);
  late final Animation<double> _t =
      CurvedAnimation(parent: _beckon, curve: Curves.easeInOut);

  @override
  void dispose() {
    _beckon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dir = widget.pointLeft ? -1.0 : 1.0;
    final icon = Icon(widget.target.icon, color: widget.target.color, size: 26);
    final chevron = AnimatedBuilder(
      animation: _t,
      builder: (_, _) => Transform.translate(
        offset: Offset(dir * 6 * _t.value, 0),
        child: Opacity(
          opacity: 0.3 + 0.5 * _t.value,
          child: Icon(
            widget.pointLeft
                ? Icons.chevron_left_rounded
                : Icons.chevron_right_rounded,
            size: 22,
            color: AppColors.ink,
          ),
        ),
      ),
    );
    return IgnorePointer(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: widget.pointLeft ? [chevron, icon] : [icon, chevron],
      ),
    );
  }
}

/// Liquid-fill background: two phase-shifted sine waves that drift slowly so
/// the surface reads as gently moving fluid. Height ∝ LE within the current
/// level (`08-motion.md`). Cheap — one full-screen `CustomPaint` drawing two
/// ~50-segment paths per frame, isolated behind a `RepaintBoundary`.
class _LiquidBackground extends StatefulWidget {
  const _LiquidBackground({required this.fraction});
  final double fraction;

  @override
  State<_LiquidBackground> createState() => _LiquidBackgroundState();
}

class _LiquidBackgroundState extends State<_LiquidBackground>
    with SingleTickerProviderStateMixin {
  // One slow loop = one full horizontal drift of the waves.
  late final AnimationController _phase =
      AnimationController(vsync: this, duration: const Duration(seconds: 7))
        ..repeat();

  @override
  void dispose() {
    _phase.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        // Fill height eases smoothly toward the target LE fraction.
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: widget.fraction),
          duration: AppMotion.fill,
          curve: AppMotion.curveFill,
          builder: (_, frac, _) => AnimatedBuilder(
            animation: _phase,
            builder: (_, _) => CustomPaint(
              size: Size.infinite,
              painter: _LiquidPainter(fraction: frac, t: _phase.value),
            ),
          ),
        ),
      ),
    );
  }
}

class _LiquidPainter extends CustomPainter {
  _LiquidPainter({required this.fraction, required this.t});
  final double fraction;
  final double t; // 0..1 loop phase

  @override
  void paint(Canvas canvas, Size size) {
    final tau = 2 * math.pi;
    // A slow vertical bob on top of the LE-driven fill height.
    final bob = math.sin(t * tau) * 4;
    final fillTop = size.height * (1 - (0.12 + 0.33 * fraction.clamp(0, 1))) + bob;
    final paint = Paint()
      ..color = AppColors.popPurple.withValues(alpha: 0.10);
    // Two waves drifting at different speeds/directions for an organic surface.
    // Speeds are whole numbers of cycles per loop so the waveform at t=1 is
    // identical to t=0 — the repeat is seamless (no visible reset).
    for (final cfg in const [
      (amp: 10.0, phase: 0.0, speed: 1.0),
      (amp: 7.0, phase: math.pi, speed: -2.0),
    ]) {
      final path = Path()..moveTo(0, fillTop);
      for (double x = 0; x <= size.width; x += 8) {
        final y = fillTop +
            math.sin(x / size.width * tau + cfg.phase + t * tau * cfg.speed) *
                cfg.amp;
        path.lineTo(x, y);
      }
      path
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_LiquidPainter old) =>
      old.fraction != fraction || old.t != t;
}
