import 'package:flutter/material.dart';

import '../data/database.dart';
import '../theme/theme.dart';
import 'pop_tappable.dart';

/// A single rolled side quest. [done] swaps MARK → undo + a done wash.
/// [readOnly] (past dates) replaces actions with a static status.
class QuestCard extends StatelessWidget {
  const QuestCard({
    super.key,
    required this.rolled,
    this.onMark,
    this.onUndo,
    this.readOnly = false,
  });

  final RolledQuest rolled;
  final VoidCallback? onMark;
  final VoidCallback? onUndo;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final cat = rolled.quest.category;
    final color = AppColors.category(cat);
    final done = rolled.done;

    return Container(
      decoration: popSurface(
        fill: AppColors.paper,
        shadow: !readOnly,
      ).copyWith(
        border: Border.all(
            color: readOnly ? AppColors.catNormal : AppColors.ink,
            width: readOnly ? 1.5 : 2.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 9, color: color),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 14, 15, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _Chip(label: cat.name.toUpperCase(), fill: color),
                        const _Chip(
                            label: '+10', fill: AppColors.energy, icon: Icons.bolt),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(rolled.quest.title, style: AppType.bodyL),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: _action(color, done),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _action(Color color, bool done) {
    if (readOnly) {
      return Text(done ? '✓ done' : '— not done',
          style: AppType.caption.copyWith(color: AppColors.textMuted));
    }
    if (done) {
      // Only the toggler changes — same shape/position as MARK, now a teal
      // DONE state that toggles back off on tap. The card itself is unchanged.
      return PopTappable(
        onTap: onUndo,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 9),
          decoration:
              popSurface(fill: AppColors.positive, radius: AppRadii.md, stroke: 2.5),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.check_rounded, size: 16, color: AppColors.ink),
            const SizedBox(width: 6),
            Text('DONE', style: AppType.label.copyWith(fontSize: 15)),
          ]),
        ),
      );
    }
    return PopTappable(
      onTap: onMark,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 9),
        decoration: popSurface(fill: color, radius: AppRadii.md, stroke: 2.5),
        child: Text('MARK', style: AppType.label.copyWith(fontSize: 15)),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.fill, this.icon});
  final String label;
  final Color fill;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: AppRadii.r(AppRadii.pill),
        border: Border.all(color: AppColors.ink, width: 2),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[
          Icon(icon, size: 13, color: AppColors.ink),
          const SizedBox(width: 4),
        ],
        Text(label, style: AppType.label.copyWith(fontSize: 11)),
      ]),
    );
  }
}
