import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// POP press feedback: scale to 0.96 with the shadow collapsing — the "squish".
/// Used instead of Material ink (splash disabled in [appTheme]).
class PopTappable extends StatefulWidget {
  const PopTappable({
    super.key,
    required this.child,
    this.onTap,
    this.enabled = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  State<PopTappable> createState() => _PopTappableState();
}

class _PopTappableState extends State<PopTappable> {
  bool _down = false;

  void _set(bool v) {
    if (widget.enabled && widget.onTap != null) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.enabled && widget.onTap != null;
    return GestureDetector(
      onTapDown: (_) => _set(true),
      onTapUp: (_) => _set(false),
      onTapCancel: () => _set(false),
      onTap: active ? widget.onTap : null,
      child: AnimatedScale(
        scale: _down ? 0.96 : 1.0,
        duration: AppMotion.press,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
