import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/limits.dart';
import '../data/database.dart';
import '../widgets/char_counter.dart';
import '../state/app_providers.dart';
import '../theme/theme.dart';
import '../widgets/confirm_dialog.dart';
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
                  Expanded(
                    child: Center(
                      child: Text('Workshop', style: AppType.display),
                    ),
                  ),
                  // Jump straight back to the live app (skips Settings).
                  _CoinButton(
                    icon: Icons.home_rounded,
                    onTap: () => Navigator.of(context)
                        .popUntil((route) => route.isFirst),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _tabBar(),
              const SizedBox(height: 16),
              Expanded(
                child: _tab == 1 ? const _HabitsTab() : const _QuestsTab(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _Fab(
        onTap: () => _tab == 1
            ? openHabitSheet(context, null)
            : openQuestSheet(context, null),
      ),
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

/// Categories offered in the picker/filter. `normal` is tree-only (Data Models
/// §5) and never shown.
const _questCats = [
  QuestCategory.adventure,
  QuestCategory.fitness,
  QuestCategory.social,
  QuestCategory.creative,
  QuestCategory.night,
];

String _catLabel(QuestCategory c) => switch (c) {
      QuestCategory.adventure => 'Adventure',
      QuestCategory.fitness => 'Fitness',
      QuestCategory.social => 'Social',
      QuestCategory.creative => 'Creative',
      QuestCategory.night => 'Night',
      QuestCategory.normal => 'Normal',
    };

class _QuestsTab extends ConsumerWidget {
  const _QuestsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quests = ref.watch(workshopQuestsProvider);
    final categories = ref.watch(questCategoryFilterProvider);
    final sources = ref.watch(questSourceFilterProvider);
    final searching = ref.watch(questSearchProvider).trim().isNotEmpty;
    final filtersActive = categories.isNotEmpty || sources.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: _QuestSearchField()),
            const SizedBox(width: 10),
            _FilterButton(
              active: filtersActive,
              onTap: () => showQuestFilters(context),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Expanded(
          child: quests.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('$e', style: AppType.body),
            data: (list) {
              if (list.isEmpty) {
                return Center(
                  child: Text(
                    searching || filtersActive
                        ? 'No quests match.'
                        : 'No quests yet.\nTap ＋ to add your own.',
                    textAlign: TextAlign.center,
                    style: AppType.body.copyWith(color: AppColors.textMuted),
                  ),
                );
              }
              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 2, bottom: 96),
                itemCount: list.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (_, i) => _QuestRow(quest: list[i]),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Square filter button beside the search bar; shows a dot when any filter is
/// active. Opens the filters modal.
class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.active, required this.onTap});
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PopTappable(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: popSurface(
                fill: active ? AppColors.popPurple : AppColors.paper,
                radius: AppRadii.md,
                stroke: 2,
                shadow: false),
            child: Icon(Icons.tune_rounded,
                size: 21, color: active ? Colors.white : AppColors.ink),
          ),
          if (active)
            Positioned(
              right: -3,
              top: -3,
              child: Container(
                width: 13,
                height: 13,
                decoration: BoxDecoration(
                  color: AppColors.popPink,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.ink, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Filters modal: category (colour-coded) + source (Preset / Custom). Writes
/// straight through to the filter providers; the SQL query re-runs live.
Future<void> showQuestFilters(BuildContext context) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Filters',
    barrierColor: AppColors.ink.withValues(alpha: AppZ.scrim),
    transitionDuration: AppMotion.pop,
    pageBuilder: (_, _, _) => const _QuestFiltersSheet(),
    transitionBuilder: (_, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: AppMotion.curvePop);
      return FadeTransition(
        opacity: anim,
        child: ScaleTransition(
            scale: Tween(begin: 0.7, end: 1.0).animate(curved), child: child),
      );
    },
  );
}

class _QuestFiltersSheet extends ConsumerWidget {
  const _QuestFiltersSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(questCategoryFilterProvider);
    final sources = ref.watch(questSourceFilterProvider);
    final catNotifier = ref.read(questCategoryFilterProvider.notifier);
    final srcNotifier = ref.read(questSourceFilterProvider.notifier);

    void toggleCat(QuestCategory c) {
      final next = {...categories};
      next.contains(c) ? next.remove(c) : next.add(c);
      catNotifier.state = next;
    }

    void toggleSrc(QuestSource s) {
      final next = {...sources};
      next.contains(s) ? next.remove(s) : next.add(s);
      srcNotifier.state = next;
    }

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
          decoration:
              popSurface(fill: AppColors.paper, radius: AppRadii.lg, stroke: 3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('FILTERS', style: AppType.label.copyWith(fontSize: 16)),
                  if (categories.isNotEmpty || sources.isNotEmpty)
                    PopTappable(
                      onTap: () {
                        catNotifier.state = const {};
                        srcNotifier.state = const {};
                      },
                      child: Text('Clear',
                          style: AppType.label.copyWith(
                              fontSize: 13, color: AppColors.popCoral)),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Category',
                  style: AppType.caption.copyWith(color: AppColors.textMuted)),
              const SizedBox(height: 8),
              // Multi-select: empty set = all. "All" clears the set.
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _FilterChip(
                    label: 'All',
                    color: AppColors.popPurple,
                    selected: categories.isEmpty,
                    onTap: () => catNotifier.state = const {},
                  ),
                  for (final c in _questCats)
                    _FilterChip(
                      label: _catLabel(c),
                      color: AppColors.category(c),
                      selected: categories.contains(c),
                      onTap: () => toggleCat(c),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Source',
                  style: AppType.caption.copyWith(color: AppColors.textMuted)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _FilterChip(
                    label: 'All',
                    color: AppColors.popPurple,
                    selected: sources.isEmpty,
                    onTap: () => srcNotifier.state = const {},
                  ),
                  _FilterChip(
                    label: 'Preset',
                    color: AppColors.popPurple,
                    selected: sources.contains(QuestSource.preset),
                    onTap: () => toggleSrc(QuestSource.preset),
                  ),
                  _FilterChip(
                    label: 'Custom',
                    color: AppColors.popPurple,
                    selected: sources.contains(QuestSource.user),
                    onTap: () => toggleSrc(QuestSource.user),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              PopTappable(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  alignment: Alignment.center,
                  // Biome green so the confirm action reads distinctly from
                  // the purple filter chips.
                  decoration: popSurface(
                      fill: AppColors.biomeGreen,
                      radius: AppRadii.md,
                      stroke: 2.5),
                  child: Text('DONE',
                      style: AppType.label
                          .copyWith(fontSize: 15, color: AppColors.cream)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Debounced search box — pushes the term to [questSearchProvider], which the
/// DB query reads (the filtering is done in SQL, not here).
class _QuestSearchField extends ConsumerStatefulWidget {
  const _QuestSearchField();
  @override
  ConsumerState<_QuestSearchField> createState() => _QuestSearchFieldState();
}

class _QuestSearchFieldState extends ConsumerState<_QuestSearchField> {
  late final TextEditingController _ctrl =
      TextEditingController(text: ref.read(questSearchProvider));
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  void _onChanged(String v) {
    setState(() {}); // refresh the clear button
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250),
        () => ref.read(questSearchProvider.notifier).state = v);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: popSurface(
          fill: AppColors.cream, radius: AppRadii.pill, stroke: 2, shadow: false),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, size: 19, color: AppColors.mutedInk),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _ctrl,
              onChanged: _onChanged,
              style: AppType.body,
              cursorColor: AppColors.popPurple,
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: 'Search quests…',
                hintStyle: AppType.body.copyWith(color: AppColors.textMuted),
              ),
            ),
          ),
          if (_ctrl.text.isNotEmpty)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _ctrl.clear();
                _onChanged('');
              },
              child: const Icon(Icons.close_rounded,
                  size: 18, color: AppColors.mutedInk),
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: PopTappable(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppMotion.pop,
          curve: AppMotion.curvePop,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          alignment: Alignment.center,
          decoration: popSurface(
            fill: selected ? color : AppColors.paper,
            radius: AppRadii.pill,
            stroke: 2,
            shadow: false,
          ),
          child: Text(label,
              style: AppType.label.copyWith(
                  fontSize: 13,
                  color: selected ? Colors.white : AppColors.textMuted)),
        ),
      ),
    );
  }
}

class _QuestRow extends ConsumerWidget {
  const _QuestRow({required this.quest});
  final Quest quest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.read(databaseProvider);
    final isPreset = quest.source == QuestSource.preset;
    final c = AppColors.category(quest.category);
    final hiddenPreset = isPreset && !quest.isActive;
    final meta = isPreset
        ? (quest.isActive ? 'PRESET · ${_catLabel(quest.category)}' : 'PRESET · hidden')
        : 'YOURS · ${_catLabel(quest.category)}';

    final row = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration:
          popSurface(fill: AppColors.paper, radius: AppRadii.md, stroke: 2),
      child: Row(
        children: [
          // Category is signified by colour alone — solid swatch, no glyph.
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: c,
              borderRadius: AppRadii.r(AppRadii.sm),
              border: Border.all(color: AppColors.ink, width: 2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(quest.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppType.body
                        .copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(meta,
                    style: AppType.caption.copyWith(
                        color: hiddenPreset ? AppColors.mutedInk : c)),
              ],
            ),
          ),
          if (isPreset)
            _MiniSwitch(
              value: quest.isActive,
              onChanged: (v) => db.setQuestActive(quest.id, v),
            )
          else ...[
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => openQuestSheet(context, quest),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child:
                    Icon(Icons.edit_outlined, size: 21, color: AppColors.ink),
              ),
            ),
            const SizedBox(width: 2),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                final ok = await showConfirmDelete(context,
                    message: 'Remove “${quest.title}”? Your completion\nhistory is kept.');
                if (ok) db.softDeleteQuest(quest.id);
              },
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.delete_outline_rounded,
                    size: 21, color: AppColors.negative),
              ),
            ),
          ],
        ],
      ),
    );

    return Opacity(opacity: hiddenPreset ? 0.6 : 1, child: row);
  }
}

/// Compact POP toggle for preset rows.
class _MiniSwitch extends StatelessWidget {
  const _MiniSwitch({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopTappable(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: AppMotion.pop,
        curve: AppMotion.curvePop,
        width: 46,
        height: 27,
        padding: const EdgeInsets.all(3),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        decoration: BoxDecoration(
          color: value ? AppColors.positive : AppColors.surfaceSunk,
          borderRadius: AppRadii.r(AppRadii.pill),
          border: Border.all(color: AppColors.ink, width: 2),
        ),
        child: Container(
          width: 19,
          height: 19,
          decoration: BoxDecoration(
            color: AppColors.paper,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.ink, width: 2),
          ),
        ),
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
            child: Text('No habits yet.\nTap ＋ to add your first.',
                textAlign: TextAlign.center,
                style: AppType.body.copyWith(color: AppColors.textMuted)),
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
            child: Icon(isGood ? Icons.check_rounded : Icons.shield_outlined,
                size: 20, color: tagColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(habit.title,
                    style: AppType.body
                        .copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(isGood ? 'GOOD' : 'BAD',
                    style: AppType.caption.copyWith(color: tagColor)),
              ],
            ),
          ),
          // Edit (pencil) + delete (bin) — same styling as the task rows.
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => openHabitSheet(context, habit),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.edit_outlined, size: 21, color: AppColors.ink),
            ),
          ),
          const SizedBox(width: 2),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              final ok = await showConfirmDelete(context,
                  message: 'Remove “${habit.title}”? Your logged\nhistory is kept.');
              if (ok) ref.read(databaseProvider).softDeleteHabit(habit.id);
            },
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.delete_outline_rounded,
                  size: 21, color: AppColors.negative),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────── Quest editor ───────────────────────────

/// Add/edit quest sheet (`10-secondary-screens.md §5`). User quests only —
/// presets are managed via the row toggle.
Future<void> openQuestSheet(BuildContext context, Quest? existing) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Quest',
    barrierColor: AppColors.ink.withValues(alpha: AppZ.scrim),
    transitionDuration: AppMotion.pop,
    pageBuilder: (_, _, _) => _QuestSheet(existing: existing),
    transitionBuilder: (_, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: AppMotion.curvePop);
      return FadeTransition(
        opacity: anim,
        child: ScaleTransition(
            scale: Tween(begin: 0.7, end: 1.0).animate(curved), child: child),
      );
    },
  );
}

class _QuestSheet extends ConsumerStatefulWidget {
  const _QuestSheet({required this.existing});
  final Quest? existing;

  @override
  ConsumerState<_QuestSheet> createState() => _QuestSheetState();
}

class _QuestSheetState extends ConsumerState<_QuestSheet> {
  late final _title = TextEditingController(text: widget.existing?.title ?? '');
  late final _desc =
      TextEditingController(text: widget.existing?.description ?? '');
  late QuestCategory _category =
      widget.existing?.category ?? QuestCategory.adventure;
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
    if (title.characters.length > TextLimits.questTitle) {
      setState(() => _titleError = true);
      _tooLong('Title', TextLimits.questTitle);
      return;
    }
    final desc = _desc.text.trim().isEmpty ? null : _desc.text.trim();
    if (desc != null && desc.characters.length > TextLimits.questDescription) {
      _tooLong('Description', TextLimits.questDescription);
      return;
    }
    final db = ref.read(databaseProvider);
    if (widget.existing == null) {
      await db.addQuest(title, desc, _category);
    } else {
      await db.updateQuest(widget.existing!.id, title, desc, _category);
    }
    if (mounted) Navigator.of(context).pop();
  }

  void _tooLong(String field, int max) =>
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
            content: Text('$field must be $max characters or fewer.')));

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
                  Text(editing ? 'EDIT QUEST' : 'NEW QUEST',
                      style: AppType.label.copyWith(fontSize: 16)),
                  const SizedBox(height: 14),
                  _field(_title, 'Title…',
                      error: _titleError, maxLength: TextLimits.questTitle),
                  const SizedBox(height: 10),
                  _field(_desc, 'Description (optional)…',
                      maxLines: 2, maxLength: TextLimits.questDescription),
                  const SizedBox(height: 16),
                  Text('Category',
                      style: AppType.caption
                          .copyWith(color: AppColors.textMuted)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final c in _questCats)
                        _catChip(c, selected: _category == c),
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
                          fill: AppColors.popPurple,
                          radius: AppRadii.md,
                          stroke: 2.5),
                      child: Text(editing ? 'SAVE' : 'ADD QUEST  ＋',
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

  Widget _catChip(QuestCategory c, {required bool selected}) {
    final color = AppColors.category(c);
    return PopTappable(
      onTap: () => setState(() => _category = c),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: popSurface(
          fill: selected ? color : AppColors.paper,
          radius: AppRadii.pill,
          stroke: selected ? 2.5 : 2,
          shadow: false,
        ),
        child: Text(_catLabel(c),
            style: AppType.label.copyWith(
                fontSize: 13, color: selected ? Colors.white : AppColors.ink)),
      ),
    );
  }

  Widget _field(TextEditingController controller, String hint,
      {bool error = false, int maxLines = 1, int? maxLength}) {
    final box = Container(
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
        inputFormatters: maxLength == null
            ? null
            : [LengthLimitingTextInputFormatter(maxLength)],
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
    if (maxLength == null) return box;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        box,
        Padding(
          padding: const EdgeInsets.only(top: 3, right: 4),
          child: Align(
            alignment: Alignment.centerRight,
            child: CharCounter(controller: controller, max: maxLength),
          ),
        ),
      ],
    );
  }
}

/// Small circular coin button (e.g. Home) matching the shell control size.
class _CoinButton extends StatelessWidget {
  const _CoinButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PopTappable(
      onTap: onTap,
      child: Container(
        width: AppSpace.shellControl,
        height: AppSpace.shellControl,
        alignment: Alignment.center,
        decoration: popSurface(fill: AppColors.paper, radius: AppRadii.pill),
        child: Icon(icon, size: 22, color: AppColors.ink),
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
    if (title.characters.length > TextLimits.habitTitle) {
      setState(() => _titleError = true);
      _tooLong('Title', TextLimits.habitTitle);
      return;
    }
    final desc = _desc.text.trim().isEmpty ? null : _desc.text.trim();
    if (desc != null && desc.characters.length > TextLimits.habitDescription) {
      _tooLong('Description', TextLimits.habitDescription);
      return;
    }
    final db = ref.read(databaseProvider);
    if (widget.existing == null) {
      await db.addHabit(title, desc, _type);
    } else {
      await db.updateHabit(widget.existing!.id, title, desc, _type);
    }
    if (mounted) Navigator.of(context).pop();
  }

  void _tooLong(String field, int max) =>
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
            content: Text('$field must be $max characters or fewer.')));

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
                  Text(editing ? 'EDIT HABIT' : 'NEW HABIT',
                      style: AppType.label.copyWith(fontSize: 16)),
                  const SizedBox(height: 14),
                  _field(_title, 'Title…',
                      error: _titleError, maxLength: TextLimits.habitTitle),
                  const SizedBox(height: 10),
                  _field(_desc, 'Description (optional)…',
                      maxLines: 2, maxLength: TextLimits.habitDescription),
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
      {bool error = false, int maxLines = 1, int? maxLength}) {
    final box = Container(
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
        inputFormatters: maxLength == null
            ? null
            : [LengthLimitingTextInputFormatter(maxLength)],
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
    if (maxLength == null) return box;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        box,
        Padding(
          padding: const EdgeInsets.only(top: 3, right: 4),
          child: Align(
            alignment: Alignment.centerRight,
            child: CharCounter(controller: controller, max: maxLength),
          ),
        ),
      ],
    );
  }
}

