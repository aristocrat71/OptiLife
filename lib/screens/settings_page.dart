import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../state/app_providers.dart';
import '../theme/theme.dart';
import '../widgets/journal_export.dart';
import '../widgets/journal_style_sheet.dart';
import '../widgets/pop_tappable.dart';
import '../widgets/shell_controls.dart';
import 'workshop_page.dart';

/// Settings (`10-secondary-screens.md §3`). Grouped cards; every change writes
/// through to `settings` immediately (Data Models §4.2). Hosts the Workshop
/// entry point.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).asData?.value;
    final app = ref.watch(appStateProvider).asData?.value;
    final db = ref.read(databaseProvider);

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
                      child: Text('Settings', style: AppType.display),
                    ),
                  ),
                  // Balances the back coin so the title sits truly centered.
                  const SizedBox(width: AppSpace.shellControl),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: settings == null
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(AppSpace.screenGutter,
                          0, AppSpace.screenGutter, 32),
                      children: [
                        _sectionLabel('APPEARANCE'),
                        _card([
                          _ToggleRow(
                            label: 'Liquid fill',
                            value: settings.liquidFillEnabled,
                            onChanged: db.setLiquidFillEnabled,
                          ),
                          const _Divider(),
                          _NavRow(
                            label: 'Journal font',
                            trailing: Text(
                              settings.journalFont == JournalFont.handwriting
                                  ? 'Handwriting'
                                  : 'Formal',
                              style: AppType.journal(settings.journalFont)
                                  .copyWith(fontSize: 18),
                            ),
                            onTap: () => showJournalStyleSheet(context),
                          ),
                          const _Divider(),
                          _SegmentedRow(
                            label: 'Journal alignment',
                            options: const ['Left', 'Right'],
                            selectedIndex:
                                settings.journalAlignment == JournalAlignment.left
                                    ? 0
                                    : 1,
                            onSelect: (i) => db.setJournalAlignment(i == 0
                                ? JournalAlignment.left
                                : JournalAlignment.right),
                          ),
                        ]),
                        _sectionLabel('GAMEPLAY'),
                        _card([
                          _StepperRow(
                            label: 'Side quests per day',
                            value: settings.questsPerDay,
                            min: 1,
                            max: 9,
                            onChanged: db.setQuestsPerDay,
                          ),
                        ]),
                        _sectionLabel('WORKSHOP'),
                        _WorkshopCard(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const WorkshopPage()),
                          ),
                        ),
                        _sectionLabel('MORE'),
                        _card([
                          _ToggleRow(
                            label: 'Notifications',
                            soon: true,
                            value: settings.notificationsEnabled,
                            onChanged: null,
                          ),
                          const _Divider(),
                          _NavRow(
                            label: 'Export journal',
                            trailing: const Icon(Icons.chevron_right_rounded,
                                color: AppColors.mutedInk),
                            onTap: () => showJournalExportDialog(
                              context,
                              db: db,
                              font: settings.journalFont,
                              alignment: settings.journalAlignment,
                              accountCreated:
                                  app?.createdAt ?? DateTime.now(),
                            ),
                          ),
                          const _Divider(),
                          _NavRow(
                            label: 'About',
                            trailing: const Icon(Icons.chevron_right_rounded,
                                color: AppColors.mutedInk),
                            onTap: () => _showAbout(context),
                          ),
                        ]),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 18, 0, 8),
        child: Text(text,
            style: AppType.caption.copyWith(color: AppColors.mutedInk)),
      );

  static Widget _card(List<Widget> children) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration:
            popSurface(fill: AppColors.paper, radius: AppRadii.lg, stroke: 2.5),
        child: Column(children: children),
      );

  static Widget _soonChip() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.surfaceSunk,
          borderRadius: AppRadii.r(AppRadii.pill),
        ),
        child: Text('soon',
            style: AppType.caption.copyWith(color: AppColors.mutedInk)),
      );

  static void _showAbout(BuildContext context) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'About',
      barrierColor: AppColors.ink.withValues(alpha: AppZ.scrim),
      transitionDuration: AppMotion.pop,
      pageBuilder: (ctx, _, _) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 44),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
            decoration: popSurface(
                fill: AppColors.paper, radius: AppRadii.lg, stroke: 3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(AppAssets.appIconMaster,
                    width: 56, height: 56),
                const SizedBox(height: 10),
                Text('OptiLife', style: AppType.display.copyWith(fontSize: 26)),
                const SizedBox(height: 4),
                Text('Version 1.0.0',
                    style:
                        AppType.caption.copyWith(color: AppColors.textMuted)),
                const SizedBox(height: 12),
                Text('Level up your life, one quest at a time.',
                    textAlign: TextAlign.center,
                    style: AppType.body.copyWith(color: AppColors.textMuted)),
                const SizedBox(height: 14),
                Text('Dreamy · Projekt Dreamscape',
                    textAlign: TextAlign.center,
                    style: AppType.caption.copyWith(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w600)),
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
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) => Container(
      height: 1.5, color: AppColors.surfaceSunk);
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
    this.soon = false,
  });
  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool soon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Text(label, style: AppType.body.copyWith(fontSize: 16)),
          if (soon) ...[
            const SizedBox(width: 8),
            SettingsPage._soonChip(),
          ],
          const Spacer(),
          _PopSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

/// Chunky POP toggle: teal track + ink-outlined knob when ON.
class _PopSwitch extends StatelessWidget {
  const _PopSwitch({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: PopTappable(
        onTap: enabled ? () => onChanged!(!value) : null,
        child: AnimatedContainer(
          duration: AppMotion.pop,
          curve: AppMotion.curvePop,
          width: 52,
          height: 30,
          padding: const EdgeInsets.all(3),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          decoration: BoxDecoration(
            color: value ? AppColors.positive : AppColors.surfaceSunk,
            borderRadius: AppRadii.r(AppRadii.pill),
            border: Border.all(color: AppColors.ink, width: 2),
          ),
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: AppColors.paper,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.ink, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({required this.label, required this.trailing, this.onTap});
  final String label;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PopTappable(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Text(label, style: AppType.body.copyWith(fontSize: 16)),
            const Spacer(),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _SegmentedRow extends StatelessWidget {
  const _SegmentedRow({
    required this.label,
    required this.options,
    required this.selectedIndex,
    required this.onSelect,
  });
  final String label;
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppType.body.copyWith(fontSize: 16))),
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: AppColors.surfaceSunk,
              borderRadius: AppRadii.r(AppRadii.pill),
            ),
            child: Row(
              children: [
                for (var i = 0; i < options.length; i++)
                  PopTappable(
                    onTap: () => onSelect(i),
                    child: AnimatedContainer(
                      duration: AppMotion.pop,
                      curve: AppMotion.curvePop,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 7),
                      decoration: BoxDecoration(
                        color: i == selectedIndex
                            ? AppColors.popPurple
                            : Colors.transparent,
                        borderRadius: AppRadii.r(AppRadii.pill),
                      ),
                      child: Text(options[i],
                          style: AppType.label.copyWith(
                              fontSize: 13,
                              color: i == selectedIndex
                                  ? Colors.white
                                  : AppColors.textMuted)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepperRow extends StatelessWidget {
  const _StepperRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });
  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppType.body.copyWith(fontSize: 16))),
          _stepBtn(Icons.remove_rounded,
              enabled: value > min, onTap: () => onChanged(value - 1)),
          SizedBox(
            width: 34,
            child: Text('$value',
                textAlign: TextAlign.center,
                style: AppType.numL.copyWith(fontSize: 19)),
          ),
          _stepBtn(Icons.add_rounded,
              enabled: value < max, onTap: () => onChanged(value + 1)),
        ],
      ),
    );
  }

  Widget _stepBtn(IconData icon,
      {required bool enabled, required VoidCallback onTap}) {
    return Opacity(
      opacity: enabled ? 1 : 0.35,
      child: PopTappable(
        onTap: enabled ? onTap : null,
        child: Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: popSurface(
              fill: AppColors.surfaceSunk,
              radius: AppRadii.pill,
              stroke: 2,
              shadow: false),
          child: Icon(icon, size: 20, color: AppColors.ink),
        ),
      ),
    );
  }
}

class _WorkshopCard extends StatelessWidget {
  const _WorkshopCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PopTappable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: popSurface(
            fill: AppColors.popPurple, radius: AppRadii.lg, stroke: 2.5),
        child: Row(
          children: [
            const Icon(Icons.build_rounded, color: Colors.white, size: 24),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Workshop',
                      style: AppType.h2.copyWith(color: Colors.white)),
                  const SizedBox(height: 2),
                  Text('Manage your quests & habits',
                      style: AppType.caption.copyWith(
                          color: Colors.white.withValues(alpha: 0.85))),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
