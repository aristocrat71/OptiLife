import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Temporary stub so the PageView/navigation works while the real Biome screen
/// is built. Replace per `02-biome.md`.
class _Stub extends StatelessWidget {
  const _Stub({required this.title, required this.bg, required this.emoji});
  final String title;
  final Color bg;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: bg,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(title, style: AppType.display),
            const SizedBox(height: 4),
            Text('Coming soon', style: AppType.caption),
          ],
        ),
      ),
    );
  }
}

class BiomePage extends StatelessWidget {
  const BiomePage({super.key});
  @override
  Widget build(BuildContext context) =>
      const _Stub(title: 'Biome', bg: Color(0xFFEAF6FF), emoji: '🌳');
}
