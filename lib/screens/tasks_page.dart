import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../state/app_providers.dart';
import '../theme/theme.dart';
import '../widgets/day_pager.dart';
import '../widgets/pop_calendar.dart';
import '../widgets/pop_tappable.dart';
import '../widgets/shell_controls.dart';
import '../widgets/warp_button.dart';

/// Calm life-admin (`03-tasks.md`): tasks scoped to the selected date, **no LE,
/// no confetti**. Future dates are fully editable (the planning exception);
/// past dates are read-only.
class TasksPage extends ConsumerWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPast = ref.watch(isPastProvider);
    final date = ref.watch(selectedDateProvider);
    final tasksAsync = ref.watch(tasksForSelectedDateProvider);

    return Stack(
      children: [
        DayPager(
          padding: const EdgeInsets.fromLTRB(
              AppSpace.screenGutter, 128, AppSpace.screenGutter, 24),
          children: [
            DateDisplay(date: date),
            const SizedBox(height: 16),
            _header(tasksAsync.asData?.value),
            const SizedBox(height: 16),
            Expanded(
              child: tasksAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('$e', style: AppType.body),
                data: (list) => _TaskList(list: list, readOnly: isPast),
              ),
            ),
          ],
        ),
        if (!isPast)
          Positioned(
            right: AppSpace.screenGutter,
            bottom: AppSpace.pageDotsInset + 60, // sit above the edge peeks
            child: _Fab(onTap: () => openTaskSheet(context, ref, null)),
          ),
      ],
    );
  }

  Widget _header(List<TaskRow>? list) {
    final total = list?.length ?? 0;
    final done = list?.where((t) => t.completedAt != null).length ?? 0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Tasks', style: AppType.display),
          const SizedBox(height: 3),
          Container(
              width: 90,
              height: 5,
              decoration: BoxDecoration(
                  color: AppColors.popPurple,
                  borderRadius: AppRadii.r(AppRadii.pill))),
        ]),
        if (total > 0)
          Text('$done of $total done',
              style: AppType.label.copyWith(fontSize: 14)),
      ],
    );
  }
}

class _TaskList extends ConsumerWidget {
  const _TaskList({required this.list, required this.readOnly});
  final List<TaskRow> list;
  final bool readOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isToday = ref.watch(isTodayProvider);
    if (list.isEmpty) {
      return _DesertEmpty(
        offToday: !isToday,
        onWarp: () => ref.read(selectedDateProvider.notifier).state =
            dateOnly(DateTime.now()),
        onRepeat: readOnly
            ? null
            : () async {
                final n = await ref
                    .read(databaseProvider)
                    .copyTasksFromPreviousDay(ref.read(selectedDateProvider));
                if (n == 0 && context.mounted) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(const SnackBar(
                        content: Text('No tasks yesterday to repeat.')));
                }
              },
      );
    }
    final active = list.where((t) => t.completedAt == null).toList();
    final done = list.where((t) => t.completedAt != null).toList();
    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(top: 2, bottom: 24),
      children: [
        if (active.isEmpty && done.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(children: [
              Text('The coast is clear',
                  style: AppType.body.copyWith(color: AppColors.textMuted)),
              const SizedBox(height: 2),
              Text('[Immediately gets crushed by an asteroid]',
                  textAlign: TextAlign.center,
                  style: AppType.caption.copyWith(
                      color: AppColors.textMuted,
                      fontStyle: FontStyle.italic)),
            ]),
          ),
        for (final t in active) _TaskRow(task: t, readOnly: readOnly),
        if (done.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 8, 0, 10),
            child: Text('✓ DONE (${done.length})',
                style: AppType.label
                    .copyWith(fontSize: 13, color: AppColors.textMuted)),
          ),
          for (final t in done) _TaskRow(task: t, readOnly: readOnly),
        ],
      ],
    );
  }
}

class _TaskRow extends ConsumerWidget {
  const _TaskRow({required this.task, required this.readOnly});
  final TaskRow task;
  final bool readOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final done = task.completedAt != null;
    final hasDesc =
        task.description != null && task.description!.trim().isNotEmpty;

    final content = Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: popSurface(
        fill: readOnly ? AppColors.surfaceSunk : AppColors.paper,
        radius: AppRadii.md,
        stroke: readOnly ? 1.5 : 2,
        shadow: !readOnly,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Checkbox(
            done: done,
            readOnly: readOnly,
            onTap: () =>
                ref.read(databaseProvider).setTaskComplete(task.id, !done),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: AppType.body.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: done ? AppColors.textMuted : AppColors.ink,
                    decoration: done ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (hasDesc) ...[
                  const SizedBox(height: 2),
                  Text(task.description!,
                      style: AppType.caption
                          .copyWith(color: AppColors.textMuted)),
                ],
              ],
            ),
          ),
          // Bin at the right end deletes the task (separate hit zone).
          if (!readOnly) ...[
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () => ref.read(databaseProvider).deleteTask(task.id),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(Icons.delete_outline_rounded,
                    size: 22, color: AppColors.negative),
              ),
            ),
          ],
        ],
      ),
    );

    if (readOnly) return content;

    return PopTappable(
      onTap: () => openTaskSheet(context, ref, task),
      child: content,
    );
  }
}

/// Chunky rounded checkbox. Checked = `popPurple` (NOT teal — tasks earn no LE).
class _Checkbox extends StatelessWidget {
  const _Checkbox(
      {required this.done, required this.readOnly, required this.onTap});
  final bool done;
  final bool readOnly;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final box = AnimatedContainer(
      duration: AppMotion.pop,
      curve: AppMotion.curvePop,
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: done ? AppColors.popPurple : Colors.transparent,
        borderRadius: AppRadii.r(AppRadii.sm),
        border: Border.all(
            color: readOnly ? AppColors.catNormal : AppColors.ink, width: 2.5),
      ),
      child: done
          ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
          : null,
    );
    if (readOnly) return box;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: box,
    );
  }
}

class _Fab extends StatelessWidget {
  const _Fab({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PopTappable(
      onTap: onTap,
      child: Container(
        width: AppSpace.fab,
        height: AppSpace.fab,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.popPink,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.ink, width: 3),
          boxShadow: AppShadows.card,
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
      ),
    );
  }
}

/// Opens the add/edit task bottom sheet.
Future<void> openTaskSheet(
    BuildContext context, WidgetRef ref, TaskRow? existing) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _TaskSheet(
      db: ref.read(databaseProvider),
      existing: existing,
      initialDate: existing?.dueDate ?? ref.read(selectedDateProvider),
    ),
  );
}

class _TaskSheet extends StatefulWidget {
  const _TaskSheet(
      {required this.db, required this.existing, required this.initialDate});
  final AppDatabase db;
  final TaskRow? existing;
  final DateTime initialDate;

  @override
  State<_TaskSheet> createState() => _TaskSheetState();
}

class _TaskSheetState extends State<_TaskSheet> {
  late final _title =
      TextEditingController(text: widget.existing?.title ?? '');
  late final _notes =
      TextEditingController(text: widget.existing?.description ?? '');
  late DateTime _due = widget.initialDate;
  bool _titleError = false;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  String get _dueLabel =>
      sameDay(_due, DateTime.now()) ? 'Today' : '${_due.day} ${_months[_due.month - 1]}';

  Future<void> _pickDue() async {
    final now = DateTime.now();
    final picked = await showGeneralDialog<DateTime>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Due date',
      barrierColor: AppColors.ink.withValues(alpha: AppZ.scrim),
      transitionDuration: AppMotion.pop,
      pageBuilder: (ctx, _, _) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: (MediaQuery.of(ctx).size.width - 80).clamp(280.0, 360.0),
            padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
            decoration: popSurface(
                fill: AppColors.paper, radius: AppRadii.lg, stroke: 3),
            child: PopCalendar(
              selectedDate: _due,
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
              scale: Tween(begin: 0.7, end: 1.0).animate(curved), child: child),
        );
      },
    );
    if (picked != null) setState(() => _due = picked);
  }

  Future<void> _submit() async {
    final title = _title.text.trim();
    if (title.isEmpty) {
      setState(() => _titleError = true);
      return;
    }
    final notes = _notes.text.trim().isEmpty ? null : _notes.text.trim();
    if (widget.existing == null) {
      await widget.db.addTask(title, notes, _due);
    } else {
      await widget.db.updateTask(widget.existing!.id, title, notes, _due);
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    await widget.db.deleteTask(widget.existing!.id);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.existing != null;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.fromLTRB(
            20, 12, 20, 24 + MediaQuery.of(context).padding.bottom),
        decoration: const BoxDecoration(
          color: AppColors.paper,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(
            top: BorderSide(color: AppColors.ink, width: 2.5),
            left: BorderSide(color: AppColors.ink, width: 2.5),
            right: BorderSide(color: AppColors.ink, width: 2.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                    color: AppColors.haze,
                    borderRadius: AppRadii.r(AppRadii.pill)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(editing ? 'EDIT TASK' : 'NEW TASK',
                    style: AppType.label.copyWith(fontSize: 16)),
                if (editing)
                  PopTappable(
                    onTap: _delete,
                    child: const Icon(Icons.delete_outline_rounded,
                        size: 24, color: AppColors.negative),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            _field(_title, 'Title…', error: _titleError),
            const SizedBox(height: 10),
            _field(_notes, 'Notes (optional)…', maxLines: 2),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('For the day',
                    style: AppType.label
                        .copyWith(fontSize: 14, color: AppColors.textMuted)),
                const SizedBox(width: 12),
                PopTappable(
                  onTap: _pickDue,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: popSurface(
                        fill: AppColors.haze,
                        radius: AppRadii.pill,
                        stroke: 2,
                        shadow: false),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.calendar_today_rounded,
                          size: 15, color: AppColors.ink),
                      const SizedBox(width: 7),
                      Text(_dueLabel,
                          style: AppType.label.copyWith(fontSize: 14)),
                      const Icon(Icons.arrow_drop_down_rounded,
                          size: 20, color: AppColors.ink),
                    ]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            PopTappable(
              onTap: _submit,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                alignment: Alignment.center,
                decoration: popSurface(
                    fill: AppColors.popPink, radius: AppRadii.md, stroke: 2.5),
                child: Text(editing ? 'SAVE' : 'ADD TASK  ＋',
                    style: AppType.label
                        .copyWith(fontSize: 16, color: AppColors.cream)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController controller, String hint,
      {bool error = false, int maxLines = 1}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: AppRadii.r(AppRadii.md),
        border: Border.all(
            color: error ? AppColors.negative : AppColors.ink, width: 2),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: AppType.body,
        cursorColor: AppColors.popPurple,
        onChanged: error ? (_) => setState(() => _titleError = false) : null,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: AppType.body.copyWith(color: AppColors.textMuted),
        ),
      ),
    );
  }
}

/// Empty-list scene: a tumbleweed rolling through wind, "It's highhhh
/// noooonnn", and (off-today) a Warp to Present button.
class _DesertEmpty extends StatelessWidget {
  const _DesertEmpty(
      {required this.offToday, required this.onWarp, this.onRepeat});
  final bool offToday;
  final VoidCallback onWarp;
  final VoidCallback? onRepeat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          const _FloatingLeaf(),
          const SizedBox(height: 10),
          Text("It's a bit too quiet out here...",
              textAlign: TextAlign.center,
              style: AppType.display
                  .copyWith(fontSize: 22, color: AppColors.textMuted)),
          if (onRepeat != null) ...[
            const SizedBox(height: 18),
            PopTappable(
              onTap: onRepeat,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                decoration: popSurface(
                    fill: AppColors.paper, radius: AppRadii.pill, stroke: 2.5),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.replay_rounded,
                      size: 17, color: AppColors.ink),
                  const SizedBox(width: 8),
                  Text('Repeat yesterday',
                      style: AppType.label.copyWith(fontSize: 14)),
                ]),
              ),
            ),
          ],
          if (offToday) ...[
            const SizedBox(height: 12),
            WarpButton(onTap: onWarp),
          ],
        ],
      ),
    );
  }
}

/// A lone leaf that drifts left→right while gently bobbing and tilting, like
/// it's caught on the breeze. Off-screen at t=0/t=1 and the bob/tilt are whole
/// sine cycles, so the loop is seamless.
class _FloatingLeaf extends StatefulWidget {
  const _FloatingLeaf();
  @override
  State<_FloatingLeaf> createState() => _FloatingLeafState();
}

class _FloatingLeafState extends State<_FloatingLeaf>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 5))
        ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (_, c) => AnimatedBuilder(
          animation: _c,
          builder: (_, _) {
            final t = _c.value;
            final tx = t * (c.maxWidth + 90) - 45; // off-screen at both ends
            final wobble = math.sin(t * 2 * math.pi * 2);
            return Stack(
              children: [
                Positioned(
                  left: tx,
                  top: 18 - wobble * 8, // gentle bob
                  child: Transform.rotate(
                    angle: wobble * 0.35, // tilt — a leaf turns more in the wind
                    child: Icon(Icons.eco,
                        size: 42, color: AppColors.ink.withValues(alpha: 0.35)),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
