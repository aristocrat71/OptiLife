import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/theme.dart';
import 'app_tutorial.dart';
import 'pop_tappable.dart';

/// Online how-to-use guide. TODO: point at the real manual page once the
/// marketing site is built — placeholder for now.
const kGuideUrl = 'https://google.com/hello';

/// Opens the guide in the external browser. Shows a snackbar if it can't.
Future<void> openGuide(BuildContext context) async {
  final messenger = ScaffoldMessenger.of(context);
  final ok = await launchUrl(Uri.parse(kGuideUrl),
      mode: LaunchMode.externalApplication);
  if (!ok) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text("Couldn't open the guide.")));
  }
}

/// First-launch prompt nudging the user to the visual guide. Pressing
/// "Cancel" follows up with a gentle "explore yourself" note.
Future<void> showWelcomeGuide(BuildContext context) async {
  final view = await _popDialog<bool>(
    context,
    icon: Icons.auto_stories_rounded,
    title: 'Welcome to OptiLife!',
    body: 'Human lifeform detected... Please go through '
        'the visual guide which will teach you how to operate the tools '
        'available in the system.',
    primaryLabel: 'Show tutorial',
    onPrimary: (ctx) => Navigator.of(ctx).pop(true),
    secondaryLabel: 'Cancel',
    onSecondary: (ctx) => Navigator.of(ctx).pop(false),
  );
  if (!context.mounted) return;
  if (view == true) {
    await showAppTutorial(context);
  } else if (view == false) {
    await _showExploreYourself(context);
  }
}

Future<void> _showExploreYourself(BuildContext context) => _popDialog<void>(
      context,
      icon: Icons.explore_rounded,
      title: 'Off you go!',
      body: 'Wanting to explore by yourself? Keep in mind the guide to use '
          'this app can be found in the settings. Enjoy!',
      primaryLabel: 'Cheers',
      onPrimary: (ctx) => Navigator.of(ctx).pop(),
    );

/// Shared POP-styled modal: icon + title + body, a primary pill and an
/// optional secondary pill.
Future<T?> _popDialog<T>(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String body,
  required String primaryLabel,
  required void Function(BuildContext ctx) onPrimary,
  String? secondaryLabel,
  void Function(BuildContext ctx)? onSecondary,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: secondaryLabel != null,
    barrierLabel: title,
    barrierColor: AppColors.ink.withValues(alpha: AppZ.scrim),
    transitionDuration: AppMotion.pop,
    pageBuilder: (ctx, _, _) => Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          decoration:
              popSurface(fill: AppColors.paper, radius: AppRadii.lg, stroke: 3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: AppColors.popPurple),
              const SizedBox(height: 12),
              Text(title,
                  textAlign: TextAlign.center,
                  style: AppType.display.copyWith(fontSize: 22)),
              const SizedBox(height: 8),
              Text(body,
                  textAlign: TextAlign.center,
                  style: AppType.body.copyWith(color: AppColors.textMuted)),
              const SizedBox(height: 20),
              Row(
                children: [
                  if (secondaryLabel != null) ...[
                    Expanded(
                      child: _pill(secondaryLabel, AppColors.haze, AppColors.ink,
                          () => onSecondary?.call(ctx),
                          filled: false),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: _pill(primaryLabel, AppColors.popPurple, Colors.white,
                        () => onPrimary(ctx)),
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
}

Widget _pill(String label, Color fill, Color fg, VoidCallback onTap,
        {bool filled = true}) =>
    PopTappable(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: popSurface(
            fill: fill, radius: AppRadii.pill, stroke: 2.5, shadow: filled),
        child: Text(label, style: AppType.label.copyWith(fontSize: 15, color: fg)),
      ),
    );
