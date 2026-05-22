import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/app_providers.dart';

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
        child: Padding(
          padding: widget.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widget.children,
          ),
        ),
      ),
    );
  }
}
