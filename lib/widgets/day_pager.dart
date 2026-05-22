import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/app_providers.dart';
import '../theme/theme.dart';

/// Vertical drag = day change (Design Doc §5.4). Dragging **down** goes to the
/// **previous** day; dragging **up** goes to the **next** day.
///
/// Content is laid out **statically** (no internal scrolling) so the vertical
/// swipe is never eaten by a scroll view — every drag past [_threshold] logical
/// pixels flips the day. The gesture area fills the page, so a swipe anywhere
/// (including empty space) counts; taps on buttons still pass through.
///
/// Going before the first day (the app's creation date) is blocked.
class DayPager extends ConsumerStatefulWidget {
  const DayPager({super.key, required this.children, this.padding = EdgeInsets.zero});

  final List<Widget> children;
  final EdgeInsets padding;

  @override
  ConsumerState<DayPager> createState() => _DayPagerState();
}

class _DayPagerState extends ConsumerState<DayPager> {
  static const _threshold = 90.0;
  double _accum = 0;
  bool _fired = false;

  void _changeDay(int deltaDays) {
    final current = ref.read(selectedDateProvider);
    final next = dateOnly(current.add(Duration(days: deltaDays)));

    if (deltaDays < 0) {
      final created = ref.read(appStateProvider).asData?.value.createdAt;
      final firstDay = created != null ? dateOnly(created) : current;
      if (next.isBefore(firstDay)) return; // no day before the first — block
    }
    HapticFeedback.selectionClick();
    ref.read(selectedDateProvider.notifier).state = next;
  }

  @override
  Widget build(BuildContext context) {
    final date = ref.watch(selectedDateProvider);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragStart: (_) {
        _accum = 0;
        _fired = false;
      },
      onVerticalDragUpdate: (d) {
        if (_fired) return;
        _accum += d.delta.dy; // +dy = dragging down, -dy = dragging up
        if (_accum >= _threshold) {
          _fired = true;
          _changeDay(-1); // drag down → previous day
        } else if (_accum <= -_threshold) {
          _fired = true;
          _changeDay(1); // drag up → next day
        }
      },
      child: SizedBox.expand(
        // Keyed by the date so each day transitions in with a soft fade+settle.
        // Same-date rebuilds (e.g. marking a quest) keep the key, so they don't
        // animate — only an actual day change does.
        child: AnimatedSwitcher(
          duration: AppMotion.pop,
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(
                      begin: const Offset(0, 0.03), end: Offset.zero)
                  .animate(anim),
              child: child,
            ),
          ),
          child: Padding(
            key: ValueKey(date),
            padding: widget.padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widget.children,
            ),
          ),
        ),
      ),
    );
  }
}
