import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/database.dart';
import '../state/app_providers.dart';
import '../theme/theme.dart';
import '../widgets/pop_tappable.dart';
import '../widgets/shell_controls.dart';

/// Workshop (`10-secondary-screens.md §4`). Tabbed: Quests / Habits. This pass
/// builds the **Habits** tab (every habit is user-created, so every row is
/// editable + soft-deletable); the Quests tab is stubbed pending its build.
class WorkshopPage extends StatefulWidget {
  const WorkshopPage({super.key, this.initialTab = 1});
  final int initialTab; // 0 = Quests, 1 = Habits

  @override
  State<WorkshopPage> createState() => _WorkshopPageState();
}

class _WorkshopPageState extends State<WorkshopPage> {
  late int _tab = widget.initialTab;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpace.screenGutter, 8,
              AppSpace.screenGutter, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  BackCoin(onTap: () => Navigator.of(context).pop()),
                  const SizedBox(width: 14),
                  Text('Workshop', style: AppType.display),
                ],
              ),
              const SizedBox(height: 18),
              _tabBar(),
              const SizedBox(height: 16),
              Expanded(
                child: _tab == 1 ? const _HabitsTab() : const _QuestsTabStub(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _tab == 1
          ? _Fab(onTap: () => openHabitSheet(context, null))
          : null,
    );
  }

  Widget _tabBar() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: popSurface(
          fill: AppColors.surfaceSunk,
          radius: AppRadii.pill,
          stroke: 2,
          shadow: false),
      child: Row(
        children: [
          _tabButton('Quests', 0),
          _tabButton('Habits', 1),
        ],
      ),
    );
  }

  Widget _tabButton(String label, int i) {
    final active = _tab == i;
    return Expanded(
      child: PopTappable(
        onTap: () => setState(() => _tab = i),
        child: AnimatedContainer(
          duration: AppMotion.pop,
          curve: AppMotion.curvePop,
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? AppColors.popPurple : Colors.transparent,
            borderRadius: AppRadii.r(AppRadii.pill),
          ),
          child: Text(label,
              style: AppType.label.copyWith(
                  fontSize: 15,
                  color: active ? Colors.white : AppColors.textMuted)),
        ),
      ),
    );
  }
}

class _QuestsTabStub extends StatelessWidget {
  const _QuestsTabStub();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🛠️', style: TextStyle(fontSize: 44)),
          const SizedBox(height: 12),
          Text('Quest editing is coming soon.',
              textAlign: TextAlign.center,
              style: AppType.body.copyWith(color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

class _HabitsTab extends ConsumerWidget {
  const _HabitsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(activeHabitsProvider);
    return habits.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('$e', style: AppType.body),
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🌿', style: TextStyle(fontSize: 44)),
                const SizedBox(height: 12),
                Text('No habits yet.\nTap ＋ to add your first.',
                    textAlign: TextAlign.center,
                    style: AppType.body.copyWith(color: AppColors.textMuted)),
              ],
            ),
          );
        }
        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 2, bottom: 96),
          itemCount: list.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (_, i) => _HabitRow(habit: list[i]),
        );
      },
    );
  }
}

class _HabitRow extends ConsumerWidget {
  const _HabitRow({required this.habit});
  final Habit habit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGood = habit.type == HabitType.good;
    final tagColor = isGood ? AppColors.positive : AppColors.negative;

    return Dismissible(
      key: ValueKey(habit.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 22),
        decoration: BoxDecoration(
          color: AppColors.negative,
          borderRadius: AppRadii.r(AppRadii.md),
        ),
        child: const Icon(Icons.delete_outline_rounded,
            color: Colors.white, size: 26),
      ),
      onDismissed: (_) =>
          ref.read(databaseProvider).softDeleteHabit(habit.id),
      child: PopTappable(
        onTap: () => openHabitSheet(context, habit),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration:
              popSurface(fill: AppColors.paper, radius: AppRadii.md, stroke: 2),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: tagColor.withValues(alpha: 0.16),
                  borderRadius: AppRadii.r(AppRadii.sm),
                  border: Border.all(color: tagColor, width: 2),
                ),
                child: Icon(
                    isGood
                        ? Icons.check_rounded
                        : Icons.shield_outlined,
                    size: 20,
                    color: tagColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(habit.title,
                        style: AppType.body.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(isGood ? 'GOOD' : 'BAD',
                        style: AppType.caption.copyWith(color: tagColor)),
                  ],
                ),
              ),
              const Icon(Icons.edit_outlined, size: 21, color: AppColors.ink),
            ],
          ),
        ),
      ),
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
          color: AppColors.popPurple,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.ink, width: 3),
          boxShadow: AppShadows.card,
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
      ),
    );
  }
}

// ─────────────────────────────────── Habit editor ───────────────────────────

/// Add/edit habit sheet (`10-secondary-screens.md §6`).
Future<void> openHabitSheet(BuildContext context, Habit? existing) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Habit',
    barrierColor: AppColors.ink.withValues(alpha: AppZ.scrim),
    transitionDuration: AppMotion.pop,
    pageBuilder: (_, _, _) => _HabitSheet(existing: existing),
    transitionBuilder: (_, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: AppMotion.curvePop);
      return FadeTransition(
        opacity: anim,
        child: ScaleTransition(
          scale: Tween(begin: 0.7, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class _HabitSheet extends ConsumerStatefulWidget {
  const _HabitSheet({required this.existing});
  final Habit? existing;

  @override
  ConsumerState<_HabitSheet> createState() => _HabitSheetState();
}

class _HabitSheetState extends ConsumerState<_HabitSheet> {
  late final _title =
      TextEditingController(text: widget.existing?.title ?? '');
  late final _desc =
      TextEditingController(text: widget.existing?.description ?? '');
  late HabitType _type = widget.existing?.type ?? HabitType.good;
  bool _titleError = false;

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _title.text.trim();
    if (title.isEmpty) {
      setState(() => _titleError = true);
      return;
    }
    final desc = _desc.text.trim().isEmpty ? null : _desc.text.trim();
    final db = ref.read(databaseProvider);
    if (widget.existing == null) {
      await db.addHabit(title, desc, _type);
    } else {
      await db.updateHabit(widget.existing!.id, title, desc, _type);
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    await ref.read(databaseProvider).softDeleteHabit(widget.existing!.id);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.existing != null;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Center(
        child: SingleChildScrollView(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
              decoration: popSurface(
                  fill: AppColors.paper, radius: AppRadii.lg, stroke: 3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(editing ? 'EDIT HABIT' : 'NEW HABIT',
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
                  _field(_desc, 'Description (optional)…', maxLines: 2),
                  const SizedBox(height: 16),
                  Text('Type',
                      style: AppType.caption
                          .copyWith(color: AppColors.textMuted)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _typeChip(
                          selected: _type == HabitType.good,
                          color: AppColors.positive,
                          icon: Icons.check_rounded,
                          label: 'Good',
                          sub: 'log when done',
                          onTap: () => setState(() => _type = HabitType.good),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _typeChip(
                          selected: _type == HabitType.bad,
                          color: AppColors.negative,
                          icon: Icons.shield_outlined,
                          label: 'Bad',
                          sub: 'log when avoided',
                          onTap: () => setState(() => _type = HabitType.bad),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          size: 15, color: AppColors.mutedInk),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text('Habits are daily. Logged = +2⚡.',
                            style: AppType.caption
                                .copyWith(color: AppColors.textMuted)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  PopTappable(
                    onTap: _submit,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      alignment: Alignment.center,
                      decoration: popSurface(
                          fill: AppColors.popPurple,
                          radius: AppRadii.md,
                          stroke: 2.5),
                      child: Text(editing ? 'SAVE' : 'ADD HABIT  ＋',
                          style: AppType.label.copyWith(
                              fontSize: 16, color: AppColors.cream)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _typeChip({
    required bool selected,
    required Color color,
    required IconData icon,
    required String label,
    required String sub,
    required VoidCallback onTap,
  }) {
    return PopTappable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
        decoration: popSurface(
          fill: selected ? color.withValues(alpha: 0.16) : AppColors.paper,
          radius: AppRadii.md,
          stroke: selected ? 2.5 : 2,
          shadow: false,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 17, color: color),
                const SizedBox(width: 6),
                Text(label, style: AppType.label.copyWith(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 3),
            Text(sub,
                style: AppType.caption.copyWith(color: AppColors.textMuted)),
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
        textCapitalization: TextCapitalization.sentences,
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

