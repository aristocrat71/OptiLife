import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/game_repository.dart';
import '../state/app_providers.dart';
import '../theme/theme.dart';
import '../widgets/day_pager.dart';
import '../widgets/level_up_overlay.dart';
import '../widgets/pop_tappable.dart';
import '../widgets/quest_card.dart';
import '../widgets/warp_button.dart';

/// Landing screen: today's rolled quests + reroll. Wired to
/// [rolledQuestsForSelectedDateProvider] and [GameRepository].
class SideQuestPage extends ConsumerStatefulWidget {
  const SideQuestPage({super.key});
  @override
  ConsumerState<SideQuestPage> createState() => _SideQuestPageState();
}

class _SideQuestPageState extends ConsumerState<SideQuestPage> {
  @override
  void initState() {
    super.initState();
    // Lazy daily roll on first view (Data Models §4.5).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(isTodayProvider)) {
        ref.read(gameRepositoryProvider).ensureRollForToday();
      }
    });
  }

  void _snack(String msg) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg), duration: AppMotion.fill * 3));

  Future<void> _onMark(String questId) async {
    final outcome =
        await ref.read(gameRepositoryProvider).markQuestComplete(questId);
    if (outcome == ActionOutcome.leveledUpAwaitingPlacement && mounted) {
      final app = await ref.read(databaseProvider).watchAppState().first;
      if (!mounted) return;
      await showLevelUp(
        context,
        level: currentLevel(app.lifetimeLe),
        category: app.pendingTreeCategory ?? QuestCategory.normal,
      );
    }
  }

  Future<void> _onUndo(String questId) async {
    final outcome = await ref.read(gameRepositoryProvider).unmarkQuest(questId);
    if (outcome == ActionOutcome.leveledDown) {
      _snack('🍂 Level down — newest tree removed.');
    } else if (outcome == ActionOutcome.blockedNoEnergy) {
      _snack('Life energy already at 0.');
    }
  }

  Future<void> _onReroll() async {
    final r = await ref.read(gameRepositoryProvider).reroll();
    _snack(switch (r) {
      RerollOutcome.success => '🎲 Rerolled!',
      RerollOutcome.alreadyUsedToday => 'Come back tomorrow — 1 reroll a day.',
      RerollOutcome.completionExists => 'Unmark today\'s quests to reroll.',
      RerollOutcome.notEnoughLe => 'Need 10⚡ in this level to reroll.',
      RerollOutcome.blocked => 'Place your tree first.',
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPast = ref.watch(isPastProvider);
    final isFuture = ref.watch(isFutureProvider);
    final quests = ref.watch(rolledQuestsForSelectedDateProvider);

    return DayPager(
      padding: const EdgeInsets.fromLTRB(
          AppSpace.screenGutter, 184, AppSpace.screenGutter, 24),
      children: [
        _header(quests.asData?.value),
        const SizedBox(height: 16),
        // The quest cards live in their own scrollable box (so a long list
        // scrolls internally). Dragging inside it scrolls; dragging anywhere
        // outside it (date, header, reroll, margins) changes the day.
        if (isFuture)
          Expanded(
            child: _empty(
              const _RollingDice(),
              'Side Quests not determined.\nThey roll on the day itself.',
              action: WarpButton(onTap: _goToToday),
            ),
          )
        else
          Expanded(
            child: quests.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('$e', style: AppType.body),
              data: (list) => list.isEmpty
                  ? _empty(
                      const Text('🌱', style: TextStyle(fontSize: 44)),
                      isPast
                          ? 'No quests were rolled this day.'
                          : 'No active quests — add some in the Workshop.',
                      action: isPast ? WarpButton(onTap: _goToToday) : null,
                    )
                  : _fadeEdges(
                      // No stretch/bounce overscroll on the quest box.
                      ScrollConfiguration(
                        behavior: const _NoStretchScroll(),
                        child: ListView(
                          physics: const _GentleBouncePhysics(),
                          // Top padding keeps the first card clear of the (now
                          // tight) top fade at rest; bottom room lets the last
                          // card scroll up clear of the bottom fade.
                          padding: const EdgeInsets.only(top: 10, bottom: 36),
                          children: [
                            for (final rq in list) ...[
                              QuestCard(
                                rolled: rq,
                                readOnly: isPast,
                                onMark: () => _onMark(rq.quest.id),
                                onUndo: () => _onUndo(rq.quest.id),
                              ),
                              const SizedBox(height: 14),
                            ],
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        // Reroll sits below the box — part of the day-change (outside) zone.
        if (!isPast && !isFuture) ...[
          const SizedBox(height: 16),
          _rerollButton(),
          const SizedBox(height: 30), // lift it up off the bottom a bit
        ],
      ],
    );
  }

  Widget _header(List<dynamic>? list) {
    final total = list?.length ?? 0;
    final done = list?.where((e) => e.done == true).length ?? 0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Side Quests', style: AppType.display),
          const SizedBox(height: 3),
          Container(
              width: 120,
              height: 5,
              decoration: BoxDecoration(
                  color: AppColors.popPurple,
                  borderRadius: AppRadii.r(AppRadii.pill))),
        ]),
        // No count when nothing rolled (future / empty pool).
        if (total > 0)
          Text('$done of $total done',
              style: AppType.label.copyWith(fontSize: 14)),
      ],
    );
  }

  Widget _rerollButton() {
    return Center(
      child: PopTappable(
        onTap: _confirmReroll,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const _RerollDie(),
            const SizedBox(width: 9),
            Text('REROLL',
                style: AppType.label
                    .copyWith(fontSize: 19, color: AppColors.popCoral)),
          ]),
        ),
      ),
    );
  }

  /// Confirmation modal — this is where the reroll cost is shown.
  Future<void> _confirmReroll() async {
    final ok = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Reroll',
      barrierColor: AppColors.ink.withValues(alpha: AppZ.scrim),
      transitionDuration: AppMotion.pop,
      pageBuilder: (ctx, _, _) => _RerollConfirm(
        onConfirm: () => Navigator.of(ctx).pop(true),
        onCancel: () => Navigator.of(ctx).pop(false),
      ),
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
    if (ok == true) await _onReroll();
  }

  /// Softly fades the top & bottom edges of the scroll box to transparent so
  /// cards melt into the background instead of being hard-clipped — and it
  /// hints there's more to scroll. Bottom fade is stronger than the top.
  Widget _fadeEdges(Widget child) => ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback: (rect) => const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.white,
            Colors.white,
            Colors.transparent,
          ],
          stops: [0.0, 0.015, 0.85, 1.0],
        ).createShader(rect),
        child: child,
      );

  Widget _empty(Widget icon, String msg, {Widget? action}) => Padding(
        padding: const EdgeInsets.only(top: 48),
        child: Column(children: [
          icon,
          const SizedBox(height: 12),
          Text(msg,
              textAlign: TextAlign.center,
              style: AppType.body.copyWith(color: AppColors.textMuted)),
          if (action != null) ...[
            const SizedBox(height: 22),
            action,
          ],
        ]),
      );

  void _goToToday() => ref.read(selectedDateProvider.notifier).state =
      dateOnly(DateTime.now());
}

/// Scroll behavior with no overscroll glow/stretch — the bounce comes from
/// [_GentleBouncePhysics] alone, so we don't want a stretch layered on top.
class _NoStretchScroll extends ScrollBehavior {
  const _NoStretchScroll();
  @override
  Widget buildOverscrollIndicator(
          BuildContext context, Widget child, ScrollableDetails details) =>
      child;
}

/// A subtle iOS-style bounce: same spring as [BouncingScrollPhysics] but with
/// extra friction (0.18 vs 0.52) so the overscroll travel is small and gentle.
class _GentleBouncePhysics extends BouncingScrollPhysics {
  const _GentleBouncePhysics({super.parent});

  @override
  _GentleBouncePhysics applyTo(ScrollPhysics? ancestor) =>
      _GentleBouncePhysics(parent: buildParent(ancestor));

  @override
  double frictionFactor(double overscrollFraction) =>
      0.18 * math.pow(1 - overscrollFraction, 2);
}

/// The reroll button's die — spins round and round, cycling its pip face as it
/// turns, so it reads as a die mid-roll.
class _RerollDie extends StatefulWidget {
  const _RerollDie();
  @override
  State<_RerollDie> createState() => _RerollDieState();
}

class _RerollDieState extends State<_RerollDie>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 3600))
        ..repeat();

  // Pip positions on a 3×3 grid (indices 0–8) per face value.
  static const _faces = {
    1: {4},
    2: {0, 8},
    3: {0, 4, 8},
    4: {0, 2, 6, 8},
    5: {0, 2, 4, 6, 8},
    6: {0, 2, 3, 5, 6, 8},
  };

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, _) {
        final t = _c.value; // 0..1
        final rot = t * 2 * math.pi; // one full turn per loop — seamless, slower
        final face = 1 + (t * 6).floor() % 6; // 6 faces over the loop (~0.6s each)
        return Transform.rotate(
          angle: rot,
          child: Container(
            width: 46,
            height: 46,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.paper,
              borderRadius: AppRadii.r(AppRadii.sm),
              border: Border.all(color: AppColors.ink, width: 2.5),
              boxShadow: AppShadows.card,
            ),
            child: _pips(face),
          ),
        );
      },
    );
  }

  Widget _pips(int face) {
    final on = _faces[face]!;
    return Column(
      children: [
        for (var r = 0; r < 3; r++)
          Expanded(
            child: Row(
              children: [
                for (var c = 0; c < 3; c++)
                  Expanded(
                    child: Center(
                      child: on.contains(r * 3 + c)
                          ? Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                  color: AppColors.popCoral,
                                  shape: BoxShape.circle),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Reroll confirmation modal — shows the LE cost and confirms the action.
class _RerollConfirm extends StatelessWidget {
  const _RerollConfirm({required this.onConfirm, required this.onCancel});
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Center(
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
              Text('Reroll today’s quests?',
                  textAlign: TextAlign.center,
                  style: AppType.display.copyWith(fontSize: 21)),
              const SizedBox(height: 8),
              Text('You’ll get a fresh set of quests for today.',
                  textAlign: TextAlign.center,
                  style: AppType.body.copyWith(color: AppColors.textMuted)),
              const SizedBox(height: 18),
              // The cost lives here now, not on the button.
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Cost',
                      style: AppType.label
                          .copyWith(fontSize: 16, color: AppColors.textMuted)),
                  const SizedBox(width: 10),
                  Text('10', style: AppType.label.copyWith(fontSize: 26)),
                  const Icon(Icons.bolt, size: 26, color: AppColors.energy),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: _modalButton('Cancel', AppColors.haze, onCancel),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _modalButton('Reroll', AppColors.energy, onConfirm),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _modalButton(String label, Color fill, VoidCallback onTap) {
    return PopTappable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: popSurface(fill: fill, radius: AppRadii.md, stroke: 2.5),
        child: Text(label, style: AppType.label.copyWith(fontSize: 16)),
      ),
    );
  }
}

/// Two POP dice that tumble, bounce and cycle their pip faces in a loop —
/// the "quests roll on the day" idea, animated.
class _RollingDice extends StatefulWidget {
  const _RollingDice();
  @override
  State<_RollingDice> createState() => _RollingDiceState();
}

class _RollingDiceState extends State<_RollingDice>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))
        ..repeat();

  // Pip positions in a 3×3 grid (indices 0–8) for each face value.
  static const _faces = {
    1: {4},
    2: {0, 8},
    3: {0, 4, 8},
    4: {0, 2, 6, 8},
    5: {0, 2, 4, 6, 8},
    6: {0, 2, 3, 5, 6, 8},
  };

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, _) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _die(phase: _c.value, faceSpeed: 4, dir: 1),
          const SizedBox(width: 14),
          _die(phase: (_c.value + 0.37) % 1.0, faceSpeed: 5, dir: -1),
        ],
      ),
    );
  }

  Widget _die({required double phase, required int faceSpeed, required int dir}) {
    final face = 1 + (phase * faceSpeed).floor() % 6;
    final rot = dir * phase * 2 * math.pi; // one tumble per loop
    final bob = -12 * math.sin(phase * 2 * math.pi * 2).abs(); // two bounces
    return Transform.translate(
      offset: Offset(0, bob),
      child: Transform.rotate(
        angle: rot,
        child: Container(
          width: 46,
          height: 46,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: AppColors.paper,
            borderRadius: AppRadii.r(AppRadii.md),
            border: Border.all(color: AppColors.ink, width: 2.5),
            boxShadow: AppShadows.card,
          ),
          child: _pips(face),
        ),
      ),
    );
  }

  Widget _pips(int face) {
    final on = _faces[face]!;
    return Column(
      children: [
        for (var r = 0; r < 3; r++)
          Expanded(
            child: Row(
              children: [
                for (var c = 0; c < 3; c++)
                  Expanded(
                    child: Center(
                      child: on.contains(r * 3 + c)
                          ? Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                  color: AppColors.ink, shape: BoxShape.circle),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
