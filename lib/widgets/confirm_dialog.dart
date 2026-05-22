import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'pop_tappable.dart';

/// Shared confirm-delete modal (POP entrance). Returns true if the user
/// confirms. Used by the Tasks and Habits delete actions.
Future<bool> showConfirmDelete(
  BuildContext context, {
  required String message,
}) async {
  final ok = await showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Confirm delete',
    barrierColor: AppColors.ink.withValues(alpha: AppZ.scrim),
    transitionDuration: AppMotion.pop,
    pageBuilder: (ctx, _, _) => Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 44),
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          decoration:
              popSurface(fill: AppColors.paper, radius: AppRadii.lg, stroke: 3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Delete?',
                  textAlign: TextAlign.center,
                  style: AppType.display.copyWith(fontSize: 21)),
              const SizedBox(height: 8),
              Text(message,
                  textAlign: TextAlign.center,
                  style: AppType.body.copyWith(color: AppColors.textMuted)),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: _btn('Cancel', AppColors.haze, AppColors.ink,
                        () => Navigator.of(ctx).pop(false)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _btn('Delete', AppColors.negative, AppColors.cream,
                        () => Navigator.of(ctx).pop(true)),
                  ),
                ],
              ),
            ],
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
  return ok ?? false;
}

Widget _btn(String label, Color fill, Color fg, VoidCallback onTap) {
  return PopTappable(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      alignment: Alignment.center,
      decoration: popSurface(fill: fill, radius: AppRadii.md, stroke: 2.5),
      child: Text(label, style: AppType.label.copyWith(fontSize: 16, color: fg)),
    ),
  );
}
