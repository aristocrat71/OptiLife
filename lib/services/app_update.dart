import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/theme.dart';
import '../widgets/pop_tappable.dart';

/// Where "Update" sends the user — the web landing page hosts the latest APK.
const kUpdateDownloadUrl = 'https://optilife-web.netlify.app/';

/// Latest published (non-draft, non-prerelease) GitHub release. The version is
/// read from the release *title* (its `name`), falling back to the tag.
const _releasesApiUrl =
    'https://api.github.com/repos/aristocrat71/OptiLife/releases/latest';

/// Checks GitHub for a newer release than the installed build and, if found,
/// shows the update prompt. Network/parse failures are swallowed — the app is
/// offline-first, so a failed check must never block startup. Mobile-only:
/// the "download a new build" model doesn't apply on web/desktop.
Future<void> maybePromptForUpdate(BuildContext context) async {
  if (kIsWeb ||
      (defaultTargetPlatform != TargetPlatform.android &&
          defaultTargetPlatform != TargetPlatform.iOS)) {
    return;
  }

  final latest = _parseVersion(await _fetchLatestReleaseTitle());
  if (latest == null) return;

  final info = await PackageInfo.fromPlatform();
  final current = _parseVersion(info.version);
  if (current == null) return;

  if (_compare(latest, current) <= 0) return; // already up to date
  if (!context.mounted) return;

  await _showUpdateDialog(context, _formatVersion(latest));
}

/// Fetches the latest release and returns its title (or tag) string, or null
/// on any failure (no releases yet, offline, rate-limited, bad payload…).
Future<String?> _fetchLatestReleaseTitle() async {
  try {
    final res = await http.get(
      Uri.parse(_releasesApiUrl),
      headers: const {
        'Accept': 'application/vnd.github+json',
        'User-Agent': 'OptiLife-App',
      },
    ).timeout(const Duration(seconds: 8));
    if (res.statusCode != 200) return null;

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final name = (json['name'] as String?)?.trim();
    final tag = (json['tag_name'] as String?)?.trim();
    return (name != null && name.isNotEmpty) ? name : tag;
  } catch (_) {
    return null;
  }
}

/// Pulls the first `x[.y[.z]]` it can find out of an arbitrary string (e.g.
/// "v1.2.0 — Biome update" → [1, 2, 0]). Missing parts default to 0.
List<int>? _parseVersion(String? raw) {
  if (raw == null) return null;
  final m = RegExp(r'(\d+)(?:\.(\d+))?(?:\.(\d+))?').firstMatch(raw);
  if (m == null) return null;
  return [
    int.parse(m.group(1)!),
    int.parse(m.group(2) ?? '0'),
    int.parse(m.group(3) ?? '0'),
  ];
}

/// Returns >0 if [a] is newer than [b], <0 if older, 0 if equal.
int _compare(List<int> a, List<int> b) {
  for (var i = 0; i < 3; i++) {
    final c = a[i].compareTo(b[i]);
    if (c != 0) return c;
  }
  return 0;
}

String _formatVersion(List<int> v) => 'v${v[0]}.${v[1]}.${v[2]}';

/// POP-styled "update available" modal: Later dismisses, Update opens the
/// download page in the browser.
Future<void> _showUpdateDialog(BuildContext context, String version) {
  final messenger = ScaffoldMessenger.of(context);
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Update available',
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
              const Icon(Icons.rocket_launch_rounded,
                  size: 40, color: AppColors.popPurple),
              const SizedBox(height: 12),
              Text('Update available',
                  textAlign: TextAlign.center,
                  style: AppType.display.copyWith(fontSize: 22)),
              const SizedBox(height: 8),
              Text(
                  'OptiLife $version is ready. Update now to get the latest '
                  'quests, fixes and biome magic.',
                  textAlign: TextAlign.center,
                  style: AppType.body.copyWith(color: AppColors.textMuted)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _pill('Later', AppColors.haze, AppColors.ink,
                        () => Navigator.of(ctx).pop(),
                        filled: false),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _pill('Update', AppColors.popPurple, Colors.white,
                        () async {
                      Navigator.of(ctx).pop();
                      final ok = await launchUrl(
                          Uri.parse(kUpdateDownloadUrl),
                          mode: LaunchMode.externalApplication);
                      if (!ok) {
                        messenger
                          ..hideCurrentSnackBar()
                          ..showSnackBar(const SnackBar(
                              content:
                                  Text("Couldn't open the download page.")));
                      }
                    }),
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
        child:
            Text(label, style: AppType.label.copyWith(fontSize: 15, color: fg)),
      ),
    );
