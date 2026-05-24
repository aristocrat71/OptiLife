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
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(done ? Icons.check_rounded : Icons.remove_rounded,
              size: 14, color: AppColors.textMuted),
          const SizedBox(width: 4),
          Text(done ? 'done' : 'not done',
              style: AppType.caption.copyWith(color: AppColors.textMuted)),
        ],
      );
    }
    if (done) {
      // "Completed" label + a small "Not done?" undo button beside it.
      return Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.check_circle_rounded,
            size: 18, color: AppColors.positive),
        const SizedBox(width: 6),
        Text('Completed',
            style: AppType.label
                .copyWith(fontSize: 15, color: AppColors.positive)),
        const SizedBox(width: 12),
        PopTappable(
          onTap: onUndo,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: popSurface(
                fill: AppColors.haze, radius: AppRadii.pill, stroke: 2),
            child: Text('Not done?',
                style: AppType.label
                    .copyWith(fontSize: 13, color: AppColors.ink)),
          ),
        ),
      ]);
    }
    return PopTappable(
      onTap: onMark,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 9),
        decoration: popSurface(fill: color, radius: AppRadii.md, stroke: 2.5),
        child: Text('Done', style: AppType.label.copyWith(fontSize: 15)),
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
