import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart'; // StateProvider (Riverpod 3)

import '../data/database.dart';
import '../state/app_providers.dart';
import '../theme/theme.dart';
import '../widgets/shell_controls.dart';

/// Analytics (`07-ia-navigation-state.md` — the "Stats" petal). Read-only
/// lifetime + windowed insights, computed client-side from the watched history
/// tables. Charts are hand-painted to match the POP aesthetic (no chart dep).
///
/// Three blocks (per agreed scope): headline cards, trends (LE/day, activity
/// heatmap, completion rate), and breakdowns (category donut, good vs bad).
enum AnalyticsWindow {
  week('7d', 7),
  month('30d', 30),
  all('All', -1);

  const AnalyticsWindow(this.label, this.days);
  final String label;
  final int days; // -1 = since account creation
}

final analyticsWindowProvider =
    StateProvider<AnalyticsWindow>((ref) => AnalyticsWindow.month);

Color _catColor(QuestCategory c) => switch (c) {
      QuestCategory.adventure => AppColors.catAdventure,
      QuestCategory.fitness => AppColors.catFitness,
      QuestCategory.social => AppColors.catSocial,
      QuestCategory.creative => AppColors.catCreative,
      QuestCategory.night => AppColors.catNight,
      QuestCategory.normal => AppColors.catNormal,
    };

String _cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final window = ref.watch(analyticsWindowProvider);
    final app = ref.watch(appStateProvider).asData?.value;
    final trees = ref.watch(treesProvider).asData?.value;
    final completions = ref.watch(allQuestCompletionsProvider).asData?.value;
    final habitLogs = ref.watch(allHabitLogsProvider).asData?.value;
    final rolls = ref.watch(allRollsProvider).asData?.value;

    final ready = app != null &&
        trees != null &&
        completions != null &&
        habitLogs != null &&
        rolls != null;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpace.screenGutter, 8, AppSpace.screenGutter, 0),
              child: Row(
                children: [
                  BackCoin(onTap: () => Navigator.of(context).pop()),
                  Expanded(
                    child: Center(
                      child: Text('Analytics', style: AppType.display),
                    ),
                  ),
                  const SizedBox(width: AppSpace.shellControl),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _WindowToggle(
              selected: window,
              onSelect: (w) =>
                  ref.read(analyticsWindowProvider.notifier).state = w,
            ),
            const SizedBox(height: 6),
            Expanded(
              child: !ready
                  ? const Center(child: CircularProgressIndicator())
                  : _Body(
                      stats: _Stats.compute(
                        window: window,
                        now: DateTime.now(),
                        createdAt: app.createdAt,
                        lifetimeLe: app.lifetimeLe,
                        biomesCompleted: app.biomesCompleted,
                        treesNow: trees.length,
                        completions: completions,
                        habitLogs: habitLogs,
                        rolls: rolls,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────────────── stats model ──────────────────────────────

class _Bar {
  const _Bar(this.quest, this.habit);
  final double quest;
  final double habit;
  double get total => quest + habit;
}

class _Stats {
  _Stats({
    required this.level,
    required this.lifetimeLe,
    required this.dayStreak,
    required this.treesNow,
    required this.biomesCompleted,
    required this.bars,
    required this.heatStart,
    required this.heatLastDay,
    required this.leByDay,
    required this.maxDayLe,
    required this.completed,
    required this.rolled,
    required this.byCategory,
    required this.good,
    required this.bad,
  });

  final int level;
  final int lifetimeLe;
  final int dayStreak;
  final int treesNow;
  final int biomesCompleted;

  final List<_Bar> bars; // LE per bucket (day or week)
  final DateTime heatStart; // grid origin (a Monday)
  final DateTime heatLastDay;
  final Map<DateTime, int> leByDay;
  final int maxDayLe;

  final int completed;
  final int rolled;
  final Map<QuestCategory, int> byCategory;
  final int good; // habit logs: done
  final int bad; // habit logs: avoided

  static _Stats compute({
    required AnalyticsWindow window,
    required DateTime now,
    required DateTime createdAt,
    required int lifetimeLe,
    required int biomesCompleted,
    required int treesNow,
    required List<QuestCompletion> completions,
    required List<HabitLog> habitLogs,
    required List<DailyQuestRoll> rolls,
  }) {
    final today = dateOnly(now);
    final start = window.days == -1
        ? dateOnly(createdAt)
        : today.subtract(Duration(days: window.days - 1));

    bool inRange(DateTime d) {
      final day = dateOnly(d);
      return !day.isBefore(start) && !day.isAfter(today);
    }

    // LE per day, split quests vs habits.
    final questLeByDay = <DateTime, int>{};
    final habitLeByDay = <DateTime, int>{};
    for (final c in completions) {
      if (inRange(c.date)) {
        questLeByDay[dateOnly(c.date)] =
            (questLeByDay[dateOnly(c.date)] ?? 0) + c.leAwarded;
      }
    }
    for (final l in habitLogs) {
      if (inRange(l.date)) {
        habitLeByDay[dateOnly(l.date)] =
            (habitLeByDay[dateOnly(l.date)] ?? 0) + l.leAwarded;
      }
    }
    final leByDay = <DateTime, int>{};
    for (final d in {...questLeByDay.keys, ...habitLeByDay.keys}) {
      leByDay[d] = (questLeByDay[d] ?? 0) + (habitLeByDay[d] ?? 0);
    }
    final maxDayLe =
        leByDay.values.fold<int>(0, (m, v) => v > m ? v : m);

    // Bars: daily for <=31 days, else weekly buckets so the chart stays legible.
    final totalDays = today.difference(start).inDays + 1;
    final bars = <_Bar>[];
    if (totalDays <= 31) {
      for (var i = 0; i < totalDays; i++) {
        final d = start.add(Duration(days: i));
        bars.add(_Bar((questLeByDay[d] ?? 0).toDouble(),
            (habitLeByDay[d] ?? 0).toDouble()));
      }
    } else {
      // align buckets to weeks starting at `start`
      for (var w = 0; w * 7 < totalDays; w++) {
        var q = 0, h = 0;
        for (var i = 0; i < 7; i++) {
          final d = start.add(Duration(days: w * 7 + i));
          if (d.isAfter(today)) break;
          q += questLeByDay[d] ?? 0;
          h += habitLeByDay[d] ?? 0;
        }
        bars.add(_Bar(q.toDouble(), h.toDouble()));
      }
    }

    // Day streak (lifetime, not windowed): consecutive active days ending today
    // (or yesterday, so a not-yet-active today doesn't read as a broken streak).
    final active = <DateTime>{
      for (final c in completions) dateOnly(c.date),
      for (final l in habitLogs) dateOnly(l.date),
    };
    var streak = 0;
    var cursor = active.contains(today)
        ? today
        : today.subtract(const Duration(days: 1));
    while (active.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    // Completion rate (window).
    final completed = completions.where((c) => inRange(c.date)).length;
    final rolled = rolls.where((r) => inRange(r.date)).length;

    // Category breakdown (window).
    final byCategory = <QuestCategory, int>{};
    for (final c in completions) {
      if (inRange(c.date)) {
        byCategory[c.categoryAtCompletion] =
            (byCategory[c.categoryAtCompletion] ?? 0) + 1;
      }
    }

    // Good vs bad habit logs (window).
    var good = 0, bad = 0;
    for (final l in habitLogs) {
      if (!inRange(l.date)) continue;
      if (l.status == HabitLogStatus.done) {
        good++;
      } else {
        bad++;
      }
    }

    // Heatmap grid origin: back up to the Monday of `start`'s week.
    final heatStart = start.subtract(Duration(days: (start.weekday - 1)));

    return _Stats(
      level: currentLevel(lifetimeLe),
      lifetimeLe: lifetimeLe,
      dayStreak: streak,
      treesNow: treesNow,
      biomesCompleted: biomesCompleted,
      bars: bars,
      heatStart: heatStart,
      heatLastDay: today,
      leByDay: leByDay,
      maxDayLe: maxDayLe,
      completed: completed,
      rolled: rolled,
      byCategory: byCategory,
      good: good,
      bad: bad,
    );
  }
}

// ─────────────────────────────────── body ───────────────────────────────────

class _Body extends StatelessWidget {
  const _Body({required this.stats});
  final _Stats stats;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
          AppSpace.screenGutter, 6, AppSpace.screenGutter, 36),
      children: [
        // 1) Headline cards
        Row(
          children: [
            Expanded(
              child: _StatCard(
                value: 'Lv ${stats.level}',
                sub: '${stats.lifetimeLe} lifetime',
                subIcon: Icons.bolt,
                accent: AppColors.popPurple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                value: '${stats.dayStreak}',
                valueIcon: Icons.local_fire_department_rounded,
                sub: stats.dayStreak == 1 ? 'day streak' : 'days streak',
                accent: AppColors.popCoral,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                value: '${stats.treesNow}',
                valueIcon: Icons.park_rounded,
                sub: '${stats.biomesCompleted} Biome'
                    '${stats.biomesCompleted == 1 ? '' : 's'} Completed',
                accent: AppColors.biomeGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // 2) Trends
        _ChartCard(
          title: 'LIFE ENERGY EARNED',
          trailing: _LegendDots(),
          child: stats.bars.every((b) => b.total == 0)
              ? const _EmptyNote('No energy earned in this window yet.')
              : SizedBox(
                  height: 132,
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: _BarChartPainter(stats.bars),
                  ),
                ),
        ),
        const SizedBox(height: 14),

        _ChartCard(
          title: 'ACTIVITY',
          child: _Heatmap(stats: stats),
        ),
        const SizedBox(height: 14),

        _ChartCard(
          title: 'QUEST COMPLETION',
          child: _CompletionRate(
              completed: stats.completed, rolled: stats.rolled),
        ),
        const SizedBox(height: 14),

        // 3) Breakdowns
        _ChartCard(
          title: 'QUESTS BY CATEGORY',
          child: _CategoryDonut(byCategory: stats.byCategory),
        ),
        const SizedBox(height: 14),

        _ChartCard(
          title: 'HABITS',
          child: _GoodVsBad(good: stats.good, bad: stats.bad),
        ),
      ],
    );
  }
}

// ─────────────────────────────── small widgets ──────────────────────────────

class _WindowToggle extends StatelessWidget {
  const _WindowToggle({required this.selected, required this.onSelect});
  final AnalyticsWindow selected;
  final ValueChanged<AnalyticsWindow> onSelect;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: popSurface(
            fill: AppColors.haze, radius: AppRadii.pill, stroke: 2, shadow: false),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final w in AnalyticsWindow.values)
              GestureDetector(
                onTap: () => onSelect(w),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: AppMotion.press,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  decoration: BoxDecoration(
                    color: w == selected
                        ? AppColors.popPurple
                        : Colors.transparent,
                    borderRadius: AppRadii.r(AppRadii.pill),
                  ),
                  child: Text(w.label,
                      style: AppType.label.copyWith(
                        fontSize: 14,
                        color: w == selected ? Colors.white : AppColors.ink,
                      )),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.sub,
    required this.accent,
    this.valueIcon,
    this.subIcon,
  });
  final String value;
  final String sub;
  final Color accent;
  final IconData? valueIcon; // shown beside the big value
  final IconData? subIcon; // shown before the sub line

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: popSurface(fill: AppColors.paper, radius: AppRadii.md),
      child: Column(
        children: [
          Container(
            width: 26,
            height: 4,
            decoration: BoxDecoration(
                color: accent, borderRadius: AppRadii.r(AppRadii.pill)),
          ),
          const SizedBox(height: 10),
          FittedBox(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(value, style: AppType.display.copyWith(fontSize: 22)),
                if (valueIcon != null) ...[
                  const SizedBox(width: 4),
                  Icon(valueIcon, size: 20, color: accent),
                ],
              ],
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (subIcon != null) ...[
                Icon(subIcon, size: 13, color: AppColors.energy),
                const SizedBox(width: 3),
              ],
              Flexible(
                child: Text(sub,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        AppType.caption.copyWith(color: AppColors.textMuted)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard(
      {required this.title, required this.child, this.trailing});
  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: popSurface(fill: AppColors.paper, radius: AppRadii.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                    style: AppType.label
                        .copyWith(fontSize: 13, color: AppColors.textMuted)),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _LegendDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget dot(Color c, String label) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 9,
                height: 9,
                decoration:
                    BoxDecoration(color: c, shape: BoxShape.circle)),
            const SizedBox(width: 4),
            Text(label,
                style: AppType.caption.copyWith(color: AppColors.textMuted)),
          ],
        );
    return Row(mainAxisSize: MainAxisSize.min, children: [
      dot(AppColors.energy, 'Quests'),
      const SizedBox(width: 10),
      dot(AppColors.popTeal, 'Habits'),
    ]);
  }
}

class _EmptyNote extends StatelessWidget {
  const _EmptyNote(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Center(
          child: Text(text,
              textAlign: TextAlign.center,
              style: AppType.body.copyWith(color: AppColors.textMuted)),
        ),
      );
}

class _CompletionRate extends StatelessWidget {
  const _CompletionRate({required this.completed, required this.rolled});
  final int completed;
  final int rolled;

  @override
  Widget build(BuildContext context) {
    final pct = rolled == 0 ? 0.0 : completed / rolled;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('${(pct * 100).round()}%',
                style: AppType.display.copyWith(fontSize: 30)),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('$completed of $rolled rolled quests',
                  style:
                      AppType.caption.copyWith(color: AppColors.textMuted)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: AppRadii.r(AppRadii.pill),
          child: Stack(
            children: [
              Container(height: 12, color: AppColors.haze),
              FractionallySizedBox(
                widthFactor: pct.clamp(0.0, 1.0),
                child: Container(height: 12, color: AppColors.popTeal),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GoodVsBad extends StatelessWidget {
  const _GoodVsBad({required this.good, required this.bad});
  final int good;
  final int bad;

  @override
  Widget build(BuildContext context) {
    final total = good + bad;
    if (total == 0) {
      return const _EmptyNote('No habits logged in this window yet.');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: AppRadii.r(AppRadii.pill),
          child: Row(
            children: [
              Expanded(
                flex: math.max(good, good == 0 ? 0 : 1),
                child: Container(height: 16, color: AppColors.positive),
              ),
              Expanded(
                flex: math.max(bad, bad == 0 ? 0 : 1),
                child: Container(height: 16, color: AppColors.negative),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _tag(AppColors.positive, 'Good done', good),
            const Spacer(),
            _tag(AppColors.negative, 'Bad avoided', bad),
          ],
        ),
      ],
    );
  }

  Widget _tag(Color c, String label, int n) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text('$label  ',
              style: AppType.body.copyWith(fontSize: 13)),
          Text('$n',
              style: AppType.label.copyWith(fontSize: 14, color: c)),
        ],
      );
}

class _CategoryDonut extends StatelessWidget {
  const _CategoryDonut({required this.byCategory});
  final Map<QuestCategory, int> byCategory;

  @override
  Widget build(BuildContext context) {
    final total = byCategory.values.fold<int>(0, (a, b) => a + b);
    if (total == 0) {
      return const _EmptyNote('No quests completed in this window yet.');
    }
    final entries = QuestCategory.values
        .where((c) => (byCategory[c] ?? 0) > 0)
        .toList();
    return Row(
      children: [
        SizedBox(
          width: 116,
          height: 116,
          child: CustomPaint(
            painter: _DonutPainter(byCategory, total),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$total',
                      style: AppType.display.copyWith(fontSize: 24)),
                  Text('done',
                      style: AppType.caption
                          .copyWith(color: AppColors.textMuted)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final c in entries)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Container(
                          width: 11,
                          height: 11,
                          decoration: BoxDecoration(
                              color: _catColor(c),
                              borderRadius: AppRadii.r(3))),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(_cap(c.name),
                            style: AppType.body.copyWith(fontSize: 13)),
                      ),
                      Text('${byCategory[c]}',
                          style: AppType.label.copyWith(fontSize: 13)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Heatmap extends StatelessWidget {
  const _Heatmap({required this.stats});
  final _Stats stats;

  static const _cell = 15.0;
  static const _gap = 3.0;

  @override
  Widget build(BuildContext context) {
    final cols =
        (stats.heatLastDay.difference(stats.heatStart).inDays ~/ 7) + 1;
    final w = cols * (_cell + _gap) - _gap;
    final h = 7 * (_cell + _gap) - _gap;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true, // keep the most recent weeks in view
          physics: const BouncingScrollPhysics(),
          child: CustomPaint(
            size: Size(w, h),
            painter: _HeatmapPainter(
              start: stats.heatStart,
              lastDay: stats.heatLastDay,
              leByDay: stats.leByDay,
              maxLe: stats.maxDayLe,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('less ',
                style: AppType.caption.copyWith(color: AppColors.textMuted)),
            for (final t in [0.0, 0.33, 0.66, 1.0])
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.5),
                child: Container(
                  width: 11,
                  height: 11,
                  decoration: BoxDecoration(
                    color: Color.lerp(
                        AppColors.hazeDeep, AppColors.popPurple, t),
                    borderRadius: AppRadii.r(3),
                  ),
                ),
              ),
            Text(' more',
                style: AppType.caption.copyWith(color: AppColors.textMuted)),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────── painters ───────────────────────────────

class _BarChartPainter extends CustomPainter {
  _BarChartPainter(this.bars);
  final List<_Bar> bars;

  @override
  void paint(Canvas canvas, Size size) {
    if (bars.isEmpty) return;
    final maxTotal =
        bars.fold<double>(1, (m, b) => b.total > m ? b.total : m);
    final n = bars.length;
    final gap = n > 20 ? 2.0 : 4.0;
    final barW = (size.width - gap * (n - 1)) / n;
    final baseline = size.height;

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = AppColors.ink.withValues(alpha: 0.55);

    for (var i = 0; i < n; i++) {
      final b = bars[i];
      if (b.total <= 0) continue;
      final x = i * (barW + gap);
      final qH = (b.quest / maxTotal) * (size.height - 4);
      final hH = (b.habit / maxTotal) * (size.height - 4);

      // quest segment (bottom)
      if (qH > 0) {
        final r = Rect.fromLTWH(x, baseline - qH, barW, qH);
        canvas.drawRRect(_top(r, barW / 3, hH <= 0),
            Paint()..color = AppColors.energy);
      }
      // habit segment (stacked on top)
      if (hH > 0) {
        final r = Rect.fromLTWH(x, baseline - qH - hH, barW, hH);
        canvas.drawRRect(_top(r, barW / 3, true),
            Paint()..color = AppColors.popTeal);
      }
      // outline the whole stacked bar
      final full = Rect.fromLTWH(x, baseline - qH - hH, barW, qH + hH);
      canvas.drawRRect(_top(full, barW / 3, true), stroke);
    }
  }

  // Rounded only on top corners when [roundTop]; flat bottom so segments seam.
  RRect _top(Rect r, double radius, bool roundTop) {
    final rad = Radius.circular(math.min(radius, 6));
    return RRect.fromRectAndCorners(
      r,
      topLeft: roundTop ? rad : Radius.zero,
      topRight: roundTop ? rad : Radius.zero,
    );
  }

  @override
  bool shouldRepaint(_BarChartPainter old) => old.bars != bars;
}

class _HeatmapPainter extends CustomPainter {
  _HeatmapPainter({
    required this.start,
    required this.lastDay,
    required this.leByDay,
    required this.maxLe,
  });
  final DateTime start; // a Monday
  final DateTime lastDay;
  final Map<DateTime, int> leByDay;
  final int maxLe;

  static const _cell = _Heatmap._cell;
  static const _gap = _Heatmap._gap;

  @override
  void paint(Canvas canvas, Size size) {
    final totalDays = lastDay.difference(start).inDays;
    for (var i = 0; i <= totalDays; i++) {
      final day = start.add(Duration(days: i));
      final col = i ~/ 7;
      final row = i % 7; // 0 = Monday (start is a Monday)
      final le = leByDay[day] ?? 0;
      final t = maxLe == 0 ? 0.0 : (le / maxLe);
      final color = le == 0
          ? AppColors.haze
          : Color.lerp(AppColors.hazeDeep, AppColors.popPurple,
              0.25 + 0.75 * t)!;
      final x = col * (_cell + _gap);
      final y = row * (_cell + _gap);
      final rrect = RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, _cell, _cell), const Radius.circular(3));
      canvas.drawRRect(rrect, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(_HeatmapPainter old) =>
      old.leByDay != leByDay ||
      old.start != start ||
      old.lastDay != lastDay ||
      old.maxLe != maxLe;
}

class _DonutPainter extends CustomPainter {
  _DonutPainter(this.byCategory, this.total);
  final Map<QuestCategory, int> byCategory;
  final int total;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    const thickness = 18.0;
    final rect = Rect.fromCircle(
        center: center, radius: radius - thickness / 2);

    var startAngle = -math.pi / 2;
    const gap = 0.04; // small ink-like gap between slices
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.butt;

    for (final c in QuestCategory.values) {
      final count = byCategory[c] ?? 0;
      if (count == 0) continue;
      final sweep = (count / total) * (2 * math.pi);
      paint.color = _catColor(c);
      final adj = sweep > gap ? sweep - gap : sweep;
      canvas.drawArc(rect, startAngle + gap / 2, adj, false, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.byCategory != byCategory || old.total != total;
}
