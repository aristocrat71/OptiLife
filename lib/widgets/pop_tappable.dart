import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/theme.dart';

/// POP press feedback: scale to 0.96 with the shadow collapsing — the "squish".
/// Used instead of Material ink (splash disabled in [appTheme]).
class PopTappable extends StatefulWidget {
  const PopTappable({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enabled;

  @override
  State<PopTappable> createState() => _PopTappableState();
}

class _PopTappableState extends State<PopTappable> {
  bool _down = false;

  void _set(bool v) {
    if (widget.enabled && (widget.onTap != null || widget.onLongPress != null)) {
      setState(() => _down = v);
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.enabled && widget.onTap != null;
    final canLongPress = widget.enabled && widget.onLongPress != null;
    return GestureDetector(
      onTapDown: (_) => _set(true),
      onTapUp: (_) => _set(false),
      onTapCancel: () => _set(false),
      onTap: active ? widget.onTap : null,
      onLongPress: canLongPress
          ? () {
              _set(false);
              HapticFeedback.selectionClick();
              widget.onLongPress!();
            }
          : null,
      child: AnimatedScale(
        scale: _down ? 0.96 : 1.0,
        duration: AppMotion.press,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
