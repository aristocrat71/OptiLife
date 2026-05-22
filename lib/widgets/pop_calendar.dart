import 'package:flutter/material.dart';

import '../core/date_utils.dart';
import '../theme/theme.dart';
import 'pop_tappable.dart';

/// Self-contained POP calendar. Lays out as a `Column` sized to its content
/// (only the weeks the month actually needs), so it can never clip the last
/// week the way Material's `CalendarDatePicker` does. Commits via [onSelect]
/// the moment an in-range day is tapped.
class PopCalendar extends StatefulWidget {
  const PopCalendar({
    super.key,
    required this.selectedDate,
    required this.firstDate,
    required this.lastDate,
    required this.onSelect,
  });

  final DateTime selectedDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onSelect;

  @override
  State<PopCalendar> createState() => _PopCalendarState();
}

class _PopCalendarState extends State<PopCalendar>
    with SingleTickerProviderStateMixin {
  late DateTime _month = DateTime(
    widget.selectedDate.year,
    widget.selectedDate.month,
  );

  // Drives the staggered "deal-in" of day cells; replays on month change.
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 650),
  )..forward();

  static const _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  static const _weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  // Sortable month index so range checks are a single comparison.
  int _idx(DateTime d) => d.year * 12 + d.month;

  void _shiftMonth(int delta) => setState(() {
    _month = DateTime(_month.year, _month.month + delta);
    _intro.forward(from: 0); // re-cascade the new month
  });

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final leading = DateTime(_month.year, _month.month, 1).weekday % 7; // Sun=0

    // Lay days into a flat list with leading/trailing blanks, then chunk by 7.
    final cells = <Widget>[
      for (var i = 0; i < leading; i++) const _Blank(),
      for (var d = 1; d <= daysInMonth; d++) _dayCell(d),
    ];
    while (cells.length % 7 != 0) {
      cells.add(const _Blank());
    }
    final weeks = [
      for (var i = 0; i < cells.length; i += 7)
        Row(
          children: [for (var j = 0; j < 7; j++) Expanded(child: cells[i + j])],
        ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _header(),
        const SizedBox(height: 10),
        Row(
          children: [
            for (final w in _weekdays)
              Expanded(
                child: Center(
                  child: Text(
                    w,
                    style: AppType.label.copyWith(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        ...weeks,
      ],
    );
  }

  Widget _header() {
    final canPrev = _idx(_month) > _idx(widget.firstDate);
    final canNext = _idx(_month) < _idx(widget.lastDate);
    return Row(
      children: [
        Text(
          '${_monthNames[_month.month - 1]} ${_month.year}',
          style: AppType.label.copyWith(fontSize: 17),
        ),
        const Spacer(),
        _navBtn(
          Icons.chevron_left_rounded,
          canPrev ? () => _shiftMonth(-1) : null,
        ),
        const SizedBox(width: 8),
        _navBtn(
          Icons.chevron_right_rounded,
          canNext ? () => _shiftMonth(1) : null,
        ),
      ],
    );
  }

  Widget _navBtn(IconData icon, VoidCallback? onTap) {
    return Opacity(
      opacity: onTap == null ? 0.3 : 1,
      child: PopTappable(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.haze,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.ink, width: 2),
          ),
          child: Icon(icon, size: 22, color: AppColors.ink),
        ),
      ),
    );
  }

  /// Staggered scale+fade pop, ordered by day number so the month deals in
  /// top-left → bottom-right.
  Widget _staggered(int order, int count, Widget child) {
    final start = (order / count) * 0.55;
    final anim = CurvedAnimation(
      parent: _intro,
      curve: Interval(
        start,
        (start + 0.45).clamp(0.0, 1.0),
        curve: Curves.easeOutBack,
      ),
    );
    return AnimatedBuilder(
      animation: anim,
      child: child,
      builder: (_, child) => Opacity(
        opacity: anim.value.clamp(0.0, 1.0),
        child: Transform.scale(scale: 0.3 + 0.7 * anim.value, child: child),
      ),
    );
  }

  Widget _dayCell(int day) {
    final date = DateTime(_month.year, _month.month, day);
    final enabled =
        !date.isBefore(dateOnly(widget.firstDate)) &&
        !date.isAfter(dateOnly(widget.lastDate));
    final selected = sameDay(date, widget.selectedDate);
    final isToday = sameDay(date, DateTime.now());
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;

    return _staggered(
      day - 1,
      daysInMonth,
      Padding(
        padding: const EdgeInsets.all(3),
        child: PopTappable(
          onTap: enabled ? () => widget.onSelect(date) : null,
          child: Container(
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.popPurple : Colors.transparent,
              shape: BoxShape.circle,
              border: isToday && !selected
                  ? Border.all(color: AppColors.popPurple, width: 2)
                  : null,
            ),
            child: Text(
              '$day',
              style: AppType.body.copyWith(
                fontSize: 15,
                fontWeight: selected || isToday
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: !enabled
                    ? AppColors.textMuted.withValues(alpha: 0.4)
                    : selected
                    ? Colors.white
                    : AppColors.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// An empty day slot (leading/trailing padding cells), sized like a day cell.
class _Blank extends StatelessWidget {
  const _Blank();
  @override
  Widget build(BuildContext context) => const SizedBox(height: 44);
}
