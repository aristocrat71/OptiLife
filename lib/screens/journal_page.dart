import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart'; // StateProvider (Riverpod 3)

import '../core/limits.dart';
import '../data/database.dart';
import '../data/game_repository.dart';
import '../state/app_providers.dart';
import '../theme/theme.dart';
import '../widgets/char_counter.dart';
import '../widgets/day_pager.dart';
import '../widgets/journal_style_sheet.dart';
import '../widgets/level_up_overlay.dart';
import '../widgets/pop_tappable.dart';
import '../widgets/warp_button.dart';
import 'workshop_page.dart';

/// Whether the habits strip is collapsed (hidden behind its title arrow).
/// Lives outside the widgets so the journal editor can pop it back open when
/// the entry is focused.
final habitsCollapsedProvider = StateProvider<bool>((ref) => false);

/// Journal + Habits (`04-journal-habits.md`). One combined screen: habit logging
/// (+2⚡ each) lives **above** the day's journal entry. Today is editable; past
/// is read-only; future is a friendly empty state.
///
/// Scroll model mirrors the Side Quests screen: the journal body is its own
/// inner scrollable (so long entries scroll in place), and a vertical drag
/// **outside** it changes the day via [DayPager].
class JournalPage extends ConsumerWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(selectedDateProvider);
    final isPast = ref.watch(isPastProvider);
    final isFuture = ref.watch(isFutureProvider);

    return DayPager(
      // Reserve the keyboard's height at the bottom so the editable region ends
      // at the keyboard's upper edge (the shell keeps resizeToAvoidBottomInset
      // off, so we account for the inset here). Flutter then auto-scrolls the
      // entry to keep the caret above the keyboard.
      padding: EdgeInsets.fromLTRB(AppSpace.screenGutter, 184,
          AppSpace.screenGutter, 24 + MediaQuery.of(context).viewInsets.bottom),
      children: [
        if (isFuture)
          Expanded(child: _futureEmpty(ref))
        else ...[
          _HabitsStrip(readOnly: isPast),
          const SizedBox(height: 18),
          _journalHeader(context),
          const SizedBox(height: 10),
          Expanded(child: _JournalSection(date: date, readOnly: isPast)),
        ],
      ],
    );
  }

  Widget _journalHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('JOURNAL',
            style: AppType.label.copyWith(fontSize: 16, color: AppColors.popTeal)),
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
    // Top-aligned at the same height as the Side Quests future doodle: that
    // screen reserves header (~38) + 16 + a 48px lead-in before its animation;
    // this branch has no header, so we pad the equivalent space.
    return Padding(
      padding: const EdgeInsets.only(top: 102),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _TimeWarpClock(),
          const SizedBox(height: 12),
          Text('No time travel available to\njournal your future self…',
              textAlign: TextAlign.center,
              style: AppType.display
                  .copyWith(fontSize: 21, color: AppColors.textMuted)),
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

/// A clock nucleus with electrons orbiting it like an atom — a little
/// "time machine" doodle for the future-date journal state. The hands turn
/// gently; the electrons trace tilted elliptical orbits around the face.
class _TimeWarpClock extends StatefulWidget {
  const _TimeWarpClock();
  @override
  State<_TimeWarpClock> createState() => _TimeWarpClockState();
}

class _TimeWarpClockState extends State<_TimeWarpClock>
    with SingleTickerProviderStateMixin {
  // Slower loop than before so the hands drift rather than race.
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 4200))
        ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 118,
      height: 118,
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, _) => CustomPaint(painter: _TimeWarpPainter(_c.value)),
      ),
    );
  }
}

class _TimeWarpPainter extends CustomPainter {
  _TimeWarpPainter(this.t);
  final double t; // 0..1 loop

  // Electron orbits: (tilt, integer speed for a seamless loop, colour, phase).
  static const _orbits = [
    (tilt: 0.0, speed: 2, color: AppColors.popPink, phase: 0.0),
    (tilt: 1.0472, speed: -2, color: AppColors.popTeal, phase: 0.33), // 60°
    (tilt: 2.0944, speed: 3, color: AppColors.popPurple, phase: 0.66), // 120°
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    const r = 30.0; // nucleus radius
    const tau = 2 * math.pi;
    const a = 52.0, b = 18.0; // orbit semi-axes

    // 1) Orbit paths (behind the nucleus).
    final orbitPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = AppColors.ink.withValues(alpha: 0.22);
    for (final o in _orbits) {
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.rotate(o.tilt);
      canvas.drawOval(
          Rect.fromCenter(center: Offset.zero, width: a * 2, height: b * 2),
          orbitPaint);
      canvas.restore();
    }

    // 2) Nucleus = the clock face.
    canvas.drawCircle(c, r, Paint()..color = AppColors.paper);
    canvas.drawCircle(
        c,
        r,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = AppColors.ink);
    final tick = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = AppColors.ink.withValues(alpha: 0.4);
    for (var i = 0; i < 12; i++) {
      final ang = i / 12 * tau;
      final dir = Offset(math.sin(ang), -math.cos(ang));
      canvas.drawLine(c + dir * (r - 5), c + dir * (r - 2), tick);
    }
    // Gentle hands (minute slow, hour slower).
    _hand(canvas, c, t * tau * 2, r * 0.76, 3, AppColors.popPurple);
    _hand(canvas, c, t * tau * 1, r * 0.48, 4, AppColors.ink);
    canvas.drawCircle(c, 3.5, Paint()..color = AppColors.ink);

    // 3) Electrons orbit on top.
    for (final o in _orbits) {
      final theta = (t * o.speed + o.phase) * tau;
      final local = Offset(a * math.cos(theta), b * math.sin(theta));
      final pos = c + _rot(local, o.tilt);
      canvas.drawCircle(pos, 4.5, Paint()..color = o.color);
      canvas.drawCircle(
          pos,
          4.5,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5
            ..color = AppColors.ink);
    }
  }

  Offset _rot(Offset p, double a) => Offset(
        p.dx * math.cos(a) - p.dy * math.sin(a),
        p.dx * math.sin(a) + p.dy * math.cos(a),
      );

  void _hand(Canvas canvas, Offset c, double ang, double len, double w, Color col) {
    final end = c + Offset(math.sin(ang), -math.cos(ang)) * len;
    canvas.drawLine(
        c,
        end,
        Paint()
          ..strokeWidth = w
          ..strokeCap = StrokeCap.round
          ..color = col);
  }

  @override
  bool shouldRepaint(_TimeWarpPainter old) => old.t != t;
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
    final collapsed = ref.watch(habitsCollapsedProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Title + the collapse/expand arrow.
            PopTappable(
              onTap: () => ref.read(habitsCollapsedProvider.notifier).state =
                  !collapsed,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('HABITS',
                      style: AppType.label
                          .copyWith(fontSize: 13, color: AppColors.textMuted)),
                  const SizedBox(width: 3),
                  AnimatedRotation(
                    // Points up when open, down when collapsed.
                    turns: collapsed ? 0 : 0.5,
                    duration: AppMotion.pop,
                    curve: Curves.easeInOut,
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        size: 20, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
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
        // The list drops down / folds up under the title.
        AnimatedSize(
          duration: AppMotion.pop,
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: collapsed
              ? const SizedBox(width: double.infinity)
              : Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: habits.isEmpty
                      ? _noHabitsPrompt(context)
                      : SizedBox(
                          height: 96,
                          child: _fadeEdgesH(
                            ListView.separated(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              // Inset so the first/last chips clear the edge
                              // fades at rest.
                              padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                              itemCount: habits.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (_, i) {
                                final h = habits[i];
                                HabitLog? log;
                                for (final l in logs) {
                                  if (l.habitId == h.id) {
                                    log = l;
                                    break;
                                  }
                                }
                                return _HabitChip(
                                    habit: h, log: log, readOnly: readOnly);
                              },
                            ),
                          ),
                        ),
                ),
        ),
      ],
    );
  }

  /// Softly fades the left & right edges of the habits row to transparent so
  /// chips melt into the background instead of being hard-clipped — mirrors the
  /// vertical fade on the Side Quests box, but horizontal.
  Widget _fadeEdgesH(Widget child) => ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback: (rect) => const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.transparent,
            Colors.white,
            Colors.white,
            Colors.transparent,
          ],
          stops: [0.0, 0.04, 0.96, 1.0],
        ).createShader(rect),
        child: child,
      );

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
            child: Text('No habits? Want to build some?',
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
    if (!context.mounted) return;
    if (outcome == ActionOutcome.leveledUpAwaitingPlacement) {
      final app = await ref.read(databaseProvider).watchAppState().first;
      if (!context.mounted) return;
      await showLevelUp(
        context,
        level: currentLevel(app.lifetimeLe),
        category: app.pendingTreeCategory ?? QuestCategory.normal,
      );
    } else if (outcome == ActionOutcome.leveledDown) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
            const SnackBar(content: Text('🍂 Level down — newest tree removed.')));
    } else if (outcome == ActionOutcome.blockedNoEnergy) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
            const SnackBar(content: Text('Life energy already at 0.')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typeColor = _isGood ? AppColors.positive : AppColors.negative;
    final actionIcon = _isGood ? Icons.check_rounded : Icons.shield_rounded;

    final chip = Container(
      width: 122,
      padding: const EdgeInsets.fromLTRB(12, 10, 10, 11),
      decoration: popSurface(
        fill: readOnly ? AppColors.surfaceSunk : AppColors.paper,
        radius: AppRadii.md,
        stroke: readOnly ? 1.5 : 2,
        shadow: !readOnly,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tag + the toggle check/shield sit on one line, so the chip can
          // stay short — the dot beside the tag *is* the log control.
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
              _toggleDot(actionIcon),
            ],
          ),
          const SizedBox(height: 4),
          Flexible(
            child: Text(
              habit.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppType.body
                  .copyWith(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    if (readOnly) return chip;
    return PopTappable(onTap: () => _toggle(context, ref), child: chip);
  }

  /// The check (good) / shield (bad) dot — outline when unlogged, filled
  /// `positive` when logged.
  Widget _toggleDot(IconData icon) {
    return AnimatedContainer(
      duration: AppMotion.pop,
      curve: AppMotion.curvePop,
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _logged ? AppColors.positive : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: _logged
              ? AppColors.positive
              : (readOnly ? AppColors.catNormal : AppColors.ink),
          width: 2,
        ),
      ),
      child: Icon(icon,
          size: 15,
          color: _logged ? Colors.white : AppColors.mutedInk),
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
                        // Focusing the entry folds the habits strip away to
                        // make room for typing.
                        onFocus: () => ref
                            .read(habitsCollapsedProvider.notifier)
                            .state = true,
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
    required this.onFocus,
  });
  final String initialBody;
  final JournalFont font;
  final TextAlign textAlign;
  final ValueChanged<String> onChanged;
  final VoidCallback onFocus;

  @override
  State<_JournalEditor> createState() => _JournalEditorState();
}

class _JournalEditorState extends State<_JournalEditor> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialBody);
  late final FocusNode _focusNode = FocusNode()..addListener(_onFocusChange);
  Timer? _debounce;

  void _onFocusChange() {
    if (_focusNode.hasFocus) widget.onFocus();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.dispose();
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
    return Stack(
      children: [
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: _onChanged,
          maxLines: null,
          expands: true,
          inputFormatters: [
            LengthLimitingTextInputFormatter(TextLimits.journalBody),
          ],
          textAlign: widget.textAlign,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          cursorColor: AppColors.popPurple,
          style: AppType.journal(widget.font),
          decoration: InputDecoration(
            // Leave room so the last line never hides under the counter.
            contentPadding: const EdgeInsets.only(bottom: 22),
            isCollapsed: true,
            border: InputBorder.none,
            hintText: 'What happened today?',
            hintStyle: AppType.journal(widget.font)
                .copyWith(color: AppColors.textMuted),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: AppRadii.r(AppRadii.pill),
            ),
            child:
                CharCounter(controller: _controller, max: TextLimits.journalBody),
          ),
        ),
      ],
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
