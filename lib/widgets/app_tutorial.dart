import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'pop_tappable.dart';
import 'shell_controls.dart';

/// First-launch in-app tutorial: a blurred overlay over the shell. Two steps —
/// (1) the swipe gestures (animated arrows), (2) the central-nav button with a
/// label. Shown over [AppShell] so it reads as part of the app.
Future<void> showAppTutorial(BuildContext context) => showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Tutorial',
      barrierColor: Colors.transparent,
      transitionDuration: AppMotion.pop,
      pageBuilder: (_, _, _) => const _Tutorial(),
      transitionBuilder: (_, anim, _, child) =>
          FadeTransition(opacity: anim, child: child),
    );

class _Tutorial extends StatefulWidget {
  const _Tutorial();
  @override
  State<_Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<_Tutorial>
    with SingleTickerProviderStateMixin {
  int _step = 0;

  // Drives the swipe-arrow oscillation on step 1.
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Material kills the "no Material ancestor" yellow underlines + supplies a
    // default text style for the overlay.
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
              child: Container(color: AppColors.ink.withValues(alpha: 0.62)),
            ),
          ),
          if (_step == 0) _swipeStep() else _controlsStep(),
        ],
      ),
    );
  }

  // ── step 1: swipe gestures (animated) ──
  Widget _swipeStep() => SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Horizontal swipe: arrows slide out and back.
                AnimatedBuilder(
                  animation: _c,
                  builder: (_, _) {
                    final d = (_c.value - 0.5) * 2 * 12; // -12 → 12
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.translate(
                            offset: Offset(-d.abs(), 0),
                            child: _arrow(Icons.arrow_back_rounded)),
                        const SizedBox(width: 18),
                        _hint('Swipe to browse sections'),
                        const SizedBox(width: 18),
                        Transform.translate(
                            offset: Offset(d.abs(), 0),
                            child: _arrow(Icons.arrow_forward_rounded)),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 46),
                // Vertical swipe: arrows slide up/down and back.
                AnimatedBuilder(
                  animation: _c,
                  builder: (_, _) {
                    final d = (_c.value - 0.5) * 2 * 12;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.translate(
                            offset: Offset(0, -d.abs()),
                            child: _arrow(Icons.arrow_upward_rounded)),
                        const SizedBox(height: 10),
                        _hint('Swipe to change date'),
                        const SizedBox(height: 10),
                        Transform.translate(
                            offset: Offset(0, d.abs()),
                            child: _arrow(Icons.arrow_downward_rounded)),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 48),
                _button('Next', () => setState(() => _step = 1)),
              ],
            ),
          ),
        ),
      );

  // ── step 2: the central nav button, labelled ──
  Widget _controlsStep() => SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CentralNav(),
              const SizedBox(height: 16),
              Text('Central navigation button',
                  style: AppType.label.copyWith(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 6),
              Text('Jump between sections, settings & more',
                  textAlign: TextAlign.center,
                  style: AppType.body
                      .copyWith(color: Colors.white.withValues(alpha: 0.8))),
              const SizedBox(height: 40),
              _button('Got it', () => Navigator.of(context).pop()),
            ],
          ),
        ),
      );

  // ── bits ──
  Widget _arrow(IconData icon) => Icon(icon, color: Colors.white, size: 34);

  Widget _hint(String text) => Flexible(
        child: Text(text,
            textAlign: TextAlign.center,
            style: AppType.label.copyWith(color: Colors.white, fontSize: 16)),
      );

  Widget _button(String label, VoidCallback onTap) => PopTappable(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 13),
          decoration: popSurface(
              fill: AppColors.popPurple, radius: AppRadii.pill, stroke: 2.5),
          child: Text(label,
              style: AppType.label.copyWith(fontSize: 16, color: Colors.white)),
        ),
      );
}
