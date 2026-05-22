import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../data/game_repository.dart';
import '../state/app_providers.dart';
import '../theme/theme.dart';
import '../widgets/day_pager.dart';
import '../widgets/journal_style_sheet.dart';
import '../widgets/level_up_overlay.dart';
import '../widgets/pop_tappable.dart';
import '../widgets/shell_controls.dart';
import '../widgets/warp_button.dart';
import 'workshop_page.dart';

/// Journal + Habits (`04-journal-habits.md`). One combined screen: habit logging
/// (+2⚡ each) lives **above** the day's journal entry. Today is editable; past
/// is read-only; future is a friendly empty state.
///
/// Scroll model mirrors the Side Quests screen: the journal body is its own
/// inner scrollable (so long entries scroll in place), and a vertical drag
/// **outside** it changes the day via [DayPager].
class JournalPage extends ConsumerWidget {
  const JournalPage({super.key});

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  static const _days = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(selectedDateProvider);
    final isPast = ref.watch(isPastProvider);
    final isFuture = ref.watch(isFutureProvider);

    return DayPager(
      padding: const EdgeInsets.fromLTRB(
          AppSpace.screenGutter, 128, AppSpace.screenGutter, 24),
      children: [
        DateDisplay(date: date),
        const SizedBox(height: 16),
        if (isFuture)
          Expanded(child: _futureEmpty(ref))
        else ...[
          _HabitsStrip(readOnly: isPast),
          const SizedBox(height: 18),
          _journalHeader(context, date),
          const SizedBox(height: 10),
          Expanded(child: _JournalSection(date: date, readOnly: isPast)),
        ],
      ],
    );
  }

  Widget _journalHeader(BuildContext context, DateTime date) {
    final label =
        '${_days[date.weekday - 1]} ${date.day} ${_months[date.month - 1]}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('JOURNAL',
                      style: AppType.label
                          .copyWith(fontSize: 14, color: AppColors.popTeal)),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text('· $label',
                        overflow: TextOverflow.ellipsis,
                        style: AppType.label.copyWith(
                            fontSize: 14, color: AppColors.textMuted)),
                  ),
                ],
              ),
            ],
          ),
        ),
        PopTappable(
          onTap: () => showJournalStyleSheet(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: popSurface(
                fill: AppColors.haze,
                radius: AppRadii.pill,
                stroke: 2,
                shadow: false),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.edit_rounded, size: 14, color: AppColors.ink),
                const SizedBox(width: 6),
                Text('Font', style: AppType.label.copyWith(fontSize: 13)),
                const Icon(Icons.arrow_drop_down_rounded,
                    size: 18, color: AppColors.ink),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _futureEmpty(WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🌅', style: TextStyle(fontSize: 52)),
          const SizedBox(height: 14),
          Text('Habits & journal\nopen up on the day.',
              textAlign: TextAlign.center,
              style: AppType.display
                  .copyWith(fontSize: 22, color: AppColors.textMuted)),
          const SizedBox(height: 6),
          Text('See you then!',
              style: AppType.body.copyWith(color: AppColors.textMuted)),
          const SizedBox(height: 22),
          WarpButton(
            onTap: () => ref.read(selectedDateProvider.notifier).state =
                dateOnly(DateTime.now()),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────── Habits strip ───────────────────────────

class _HabitsStrip extends ConsumerWidget {
  const _HabitsStrip({required this.readOnly});
  final bool readOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(activeHabitsProvider).asData?.value ?? const [];
    final logs =
        ref.watch(habitLogsForSelectedDateProvider).asData?.value ?? const [];
    final loggedLe = logs.fold<int>(0, (s, l) => s + l.leAwarded);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(readOnly ? "THAT DAY'S HABITS" : "TODAY'S HABITS",
                style: AppType.label
                    .copyWith(fontSize: 13, color: AppColors.textMuted)),
            if (loggedLe > 0)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('+$loggedLe',
                      style: AppType.label
                          .copyWith(fontSize: 14, color: AppColors.popTeal)),
                  const Icon(Icons.bolt, size: 15, color: AppColors.energy),
                  const SizedBox(width: 2),
                  Text('logged',
                      style: AppType.caption
                          .copyWith(color: AppColors.textMuted)),
                ],
              ),
          ],
        ),
        const SizedBox(height: 10),
        if (habits.isEmpty)
          _noHabitsPrompt(context)
        else
          SizedBox(
            height: 124,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 2),
              itemCount: habits.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final h = habits[i];
                HabitLog? log;
                for (final l in logs) {
                  if (l.habitId == h.id) {
                    log = l;
                    break;
                  }
                }
                return _HabitChip(habit: h, log: log, readOnly: readOnly);
              },
            ),
          ),
      ],
    );
  }

  Widget _noHabitsPrompt(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: popSurface(
          fill: AppColors.surfaceSunk,
          radius: AppRadii.md,
          stroke: 2,
          shadow: false),
      child: Row(
        children: [
          Expanded(
            child: Text('No habits yet — add some in the Workshop.',
                style: AppType.body.copyWith(color: AppColors.textMuted)),
          ),
          const SizedBox(width: 10),
          PopTappable(
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const WorkshopPage())),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: popSurface(
                  fill: AppColors.popPurple, radius: AppRadii.pill, stroke: 2),
              child: Text('Workshop',
                  style:
                      AppType.label.copyWith(fontSize: 13, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class _HabitChip extends ConsumerWidget {
  const _HabitChip({required this.habit, required this.log, required this.readOnly});
  final Habit habit;
  final HabitLog? log;
  final bool readOnly;

  bool get _logged => log != null;
  bool get _isGood => habit.type == HabitType.good;

  Future<void> _toggle(BuildContext context, WidgetRef ref) async {
    final outcome = await ref.read(gameRepositoryProvider).toggleHabit(habit.id);
    if (outcome == ActionOutcome.leveledUpAwaitingPlacement && context.mounted) {
      final app = await ref.read(databaseProvider).watchAppState().first;
      if (!context.mounted) return;
      await showLevelUp(
        context,
        level: currentLevel(app.lifetimeLe),
        category: app.pendingTreeCategory ?? QuestCategory.normal,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typeColor = _isGood ? AppColors.positive : AppColors.negative;
    final actionLabel = _isGood ? 'DONE' : 'AVOIDED';
    final actionIcon = _isGood ? Icons.check_rounded : Icons.shield_rounded;

    final chip = Container(
      width: 132,
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 12),
      decoration: popSurface(
        fill: readOnly ? AppColors.surfaceSunk : AppColors.paper,
        radius: AppRadii.md,
        stroke: readOnly ? 1.5 : 2,
        shadow: !readOnly,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: typeColor,
                  borderRadius: AppRadii.r(AppRadii.pill),
                ),
                child: Text(_isGood ? 'good' : 'bad',
                    style: AppType.caption
                        .copyWith(color: Colors.white, fontSize: 10)),
              ),
              const Spacer(),
              if (_logged)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('+2',
                        style: AppType.label.copyWith(
                            fontSize: 11, color: AppColors.popTeal)),
                    const Icon(Icons.bolt, size: 12, color: AppColors.energy),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            habit.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppType.body
                .copyWith(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          _actionPill(actionLabel, actionIcon),
        ],
      ),
    );

    if (readOnly) return chip;
    return PopTappable(onTap: () => _toggle(context, ref), child: chip);
  }

  Widget _actionPill(String label, IconData icon) {
    return AnimatedContainer(
      duration: AppMotion.pop,
      curve: AppMotion.curvePop,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 7),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _logged ? AppColors.positive : Colors.transparent,
        borderRadius: AppRadii.r(AppRadii.sm),
        border: Border.all(
          color: _logged ? AppColors.positive : AppColors.ink,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_logged) ...[
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 4),
          ],
          Text(label,
              style: AppType.label.copyWith(
                  fontSize: 12,
                  color: _logged ? Colors.white : AppColors.ink)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────── Journal body ───────────────────────────

class _JournalSection extends ConsumerWidget {
  const _JournalSection({required this.date, required this.readOnly});
  final DateTime date;
  final bool readOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalAsync = ref.watch(journalForSelectedDateProvider);
    final settings = ref.watch(settingsProvider).asData?.value;
    final font = settings?.journalFont ?? JournalFont.handwriting;
    final align = settings?.journalAlignment ?? JournalAlignment.left;
    final textAlign = align == JournalAlignment.left
        ? TextAlign.left
        : TextAlign.right;

    return journalAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, _) => Text('$e', style: AppType.body),
      data: (entry) {
        final body = entry?.body ?? '';
        final paper = Container(
          decoration: popSurface(
            fill: readOnly ? AppColors.surfaceSunk : AppColors.cream,
            radius: AppRadii.xl,
            stroke: readOnly ? 1.5 : 2.5,
            shadow: !readOnly,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              const Positioned.fill(
                child: IgnorePointer(child: CustomPaint(painter: _RuledPaper())),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: readOnly
                    ? _readOnlyBody(body, font, textAlign)
                    : _JournalEditor(
                        key: ValueKey(date),
                        initialBody: body,
                        font: font,
                        textAlign: textAlign,
                        onChanged: (text) => ref
                            .read(databaseProvider)
                            .upsertJournal(date, text),
                      ),
              ),
            ],
          ),
        );
        return paper;
      },
    );
  }

  Widget _readOnlyBody(String body, JournalFont font, TextAlign align) {
    if (body.trim().isEmpty) {
      return Center(
        child: Text('Nothing was written this day.',
            style: AppType.body.copyWith(color: AppColors.textMuted)),
      );
    }
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Text(body, textAlign: align, style: AppType.journal(font)),
    );
  }
}

/// Free-form entry editor. Owns its controller for the life of one day (the
/// parent re-keys it by date), autosaving on a short debounce — no save button,
/// the row is upserted on `date` (Data Models §4.9).
class _JournalEditor extends StatefulWidget {
  const _JournalEditor({
    super.key,
    required this.initialBody,
    required this.font,
    required this.textAlign,
    required this.onChanged,
  });
  final String initialBody;
  final JournalFont font;
  final TextAlign textAlign;
  final ValueChanged<String> onChanged;

  @override
  State<_JournalEditor> createState() => _JournalEditorState();
}

class _JournalEditorState extends State<_JournalEditor> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialBody);
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      widget.onChanged(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onChanged,
      maxLines: null,
      expands: true,
      textAlign: widget.textAlign,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      cursorColor: AppColors.popPurple,
      style: AppType.journal(widget.font),
      decoration: InputDecoration(
        isCollapsed: true,
        border: InputBorder.none,
        hintText: 'What happened today?',
        hintStyle: AppType.journal(widget.font)
            .copyWith(color: AppColors.textMuted),
      ),
    );
  }
}

/// Very low-contrast ruled lines so the entry reads as a page (Design §4).
class _RuledPaper extends CustomPainter {
  const _RuledPaper();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.popPurple.withValues(alpha: 0.06)
      ..strokeWidth = 1;
    const gap = 34.0;
    for (double y = gap + 14; y < size.height; y += gap) {
      canvas.drawLine(Offset(14, y), Offset(size.width - 14, y), paint);
    }
  }

  @override
  bool shouldRepaint(_RuledPaper old) => false;
}
