import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Live `current/max` character counter that tracks a [TextEditingController].
/// Counts by grapheme clusters to match [LengthLimitingTextInputFormatter], and
/// turns coral once the cap is reached.
class CharCounter extends StatelessWidget {
  const CharCounter({super.key, required this.controller, required this.max});

  final TextEditingController controller;
  final int max;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (_, value, _) {
        final n = value.text.characters.length;
        return Text(
          '$n/$max',
          style: AppType.caption.copyWith(
            color: n >= max ? AppColors.negative : AppColors.textMuted,
          ),
        );
      },
    );
  }
}
