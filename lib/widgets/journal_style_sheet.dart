import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/app_providers.dart';
import '../theme/theme.dart';
import 'pop_tappable.dart';

/// Journal font + alignment picker (`10-secondary-screens.md §8`). Writes
/// through to `settings` immediately — the choice is **global**, not per-entry
/// (Data Models §4.9). Mirrored in Settings → Appearance.
Future<void> showJournalStyleSheet(BuildContext context) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Journal style',
    barrierColor: AppColors.ink.withValues(alpha: AppZ.scrim),
    transitionDuration: AppMotion.pop,
    pageBuilder: (_, _, _) => const _JournalStyleSheet(),
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

class _JournalStyleSheet extends ConsumerWidget {
  const _JournalStyleSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).asData?.value;
    final db = ref.read(databaseProvider);
    final font = settings?.journalFont ?? JournalFont.handwriting;
    final align = settings?.journalAlignment ?? JournalAlignment.left;

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
              Text('JOURNAL STYLE', style: AppType.label.copyWith(fontSize: 16)),
              const SizedBox(height: 16),
              Text('Font',
                  style: AppType.caption.copyWith(color: AppColors.textMuted)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _fontChip(
                      selected: font == JournalFont.handwriting,
                      label: 'Handwriting',
                      preview: 'Today I…',
                      previewStyle: AppType.journal(JournalFont.handwriting)
                          .copyWith(fontSize: 20),
                      onTap: () => db.setJournalFont(JournalFont.handwriting),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _fontChip(
                      selected: font == JournalFont.formal,
                      label: 'Formal',
                      preview: 'Today I…',
                      previewStyle: AppType.journal(JournalFont.formal)
                          .copyWith(fontSize: 16),
                      onTap: () => db.setJournalFont(JournalFont.formal),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Alignment',
                  style: AppType.caption.copyWith(color: AppColors.textMuted)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _segChip(
                      selected: align == JournalAlignment.left,
                      icon: Icons.format_align_left_rounded,
                      label: 'Left',
                      onTap: () => db.setJournalAlignment(JournalAlignment.left),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _segChip(
                      selected: align == JournalAlignment.right,
                      icon: Icons.format_align_right_rounded,
                      label: 'Right',
                      onTap: () =>
                          db.setJournalAlignment(JournalAlignment.right),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      size: 15, color: AppColors.mutedInk),
                  const SizedBox(width: 6),
                  Text('Applies to all entries.',
                      style:
                          AppType.caption.copyWith(color: AppColors.textMuted)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fontChip({
    required bool selected,
    required String label,
    required String preview,
    required TextStyle previewStyle,
    required VoidCallback onTap,
  }) {
    return PopTappable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: popSurface(
          fill: selected ? AppColors.haze : AppColors.paper,
          radius: AppRadii.md,
          stroke: selected ? 2.5 : 2,
          shadow: false,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (selected)
                  const Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Icon(Icons.check_circle_rounded,
                        size: 16, color: AppColors.popPurple),
                  ),
                Text(label, style: AppType.label.copyWith(fontSize: 13)),
              ],
            ),
            const SizedBox(height: 6),
            Text(preview, style: previewStyle, maxLines: 1),
          ],
        ),
      ),
    );
  }

  Widget _segChip({
    required bool selected,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return PopTappable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        alignment: Alignment.center,
        decoration: popSurface(
          fill: selected ? AppColors.popPurple : AppColors.paper,
          radius: AppRadii.md,
          stroke: selected ? 2.5 : 2,
          shadow: false,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 17,
                color: selected ? Colors.white : AppColors.ink),
            const SizedBox(width: 6),
            Text(label,
                style: AppType.label.copyWith(
                    fontSize: 14,
                    color: selected ? Colors.white : AppColors.ink)),
          ],
        ),
      ),
    );
  }
}
