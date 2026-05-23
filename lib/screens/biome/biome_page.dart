import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/limits.dart';
import '../../state/app_providers.dart';
import '../../theme/theme.dart';
import '../../widgets/pop_tappable.dart';
import 'biome_game.dart';
import 'reboot_overlay.dart';

/// The Biome screen (`02-biome.md`): a Flame isometric world hosted at PageView
/// index 0. Date-agnostic — no `DayPager`. Renders the world + current trees,
/// with the World HUD, photo stub, and empty-state prompt as Flutter chrome on
/// top. Placement / reboot land in later phases.
class BiomePage extends ConsumerStatefulWidget {
  const BiomePage({super.key});

  @override
  ConsumerState<BiomePage> createState() => _BiomePageState();
}

class _BiomePageState extends ConsumerState<BiomePage> {
  final BiomeGame _game = BiomeGame();

  // Guards the reboot prompt so a full world asks once per visit, not per build.
  bool _rebootPrompted = false;
  bool _rebooting = false;

  @override
  void initState() {
    super.initState();
    _game.onCellTapped = _onCellTapped;
    // Seed the world once the first frame has the provider resolved.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(treesProvider).whenData(_game.syncTrees);
    });
  }

  /// User tapped a valid empty cell during placement → plant the pending tree.
  /// The 100th-tree reboot prompt is driven from [build] off the tree count.
  Future<void> _onCellTapped(int col, int row) =>
      ref.read(gameRepositoryProvider).placeTree(col.toDouble(), row.toDouble());

  /// World is full (100 trees): offer the reboot once per visit (`§6`).
  Future<void> _maybePromptReboot() async {
    if (_rebootPrompted || _rebooting) return;
    _rebootPrompted = true;
    final confirmed = await showRebootSheet(context);
    if (confirmed && mounted) await _runReboot();
  }

  /// The HUD's Reboot button (shown on a full world): re-open the prompt.
  Future<void> _rebootButtonPressed() async {
    if (_rebooting) return;
    final confirmed = await showRebootSheet(context);
    if (confirmed && mounted) await _runReboot();
  }

  /// Confirmed reboot: warp the screen while the world is wiped behind it
  /// (motion §2.7). The DB reset clears trees + resets LE → level 1.
  Future<void> _runReboot() async {
    _rebooting = true;
    final travel = showDimensionalTravel(context);
    // Let the swirl cover the screen before the world empties underneath.
    await Future.delayed(const Duration(milliseconds: 500));
    await ref.read(gameRepositoryProvider).rebootBiome();
    await travel;
    _rebooting = false;
  }

  @override
  Widget build(BuildContext context) {
    // Keep the rendered world reconciled with the DB.
    ref.listen(treesProvider, (_, next) => next.whenData(_game.syncTrees));

    final app = ref.watch(appStateProvider).asData?.value;
    final trees = ref.watch(treesProvider).asData?.value ?? const [];
    final treeCount = trees.length;
    final level = currentLevel(app?.lifetimeLe ?? 0);
    final worldsCompleted = app?.biomesCompleted ?? 0;
    final placingCategory = app?.pendingTreeCategory;
    final placing = placingCategory != null;
    final isEmpty = level == 1 && treeCount == 0 && !placing;

    // At Level 1 there's nothing to plant — hide the grid, show just the prompt.
    _game.setGridVisible(!isEmpty);
    _game.setPlacement(placingCategory);

    // Full world → surface the reboot prompt (once). Reset the guard when the
    // count drops (after reboot / level-down) so it can re-arm next time.
    if (treeCount >= kBiomeCapacity && !placing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _maybePromptReboot();
      });
    } else if (treeCount < kBiomeCapacity) {
      _rebootPrompted = false;
    }

    final topInset = MediaQuery.of(context).padding.top;
    // Sit just below the shell's LE ring / calendar row (ring is 48 tall,
    // starting 6px into the safe area — see app_shell).
    final chromeTop = topInset + AppSpace.shellControl + 18;
    // The banner spans the width, so it must clear the taller central nav
    // button (navCircle + ripple, starting 6px into the safe area).
    final bannerTop = topInset + AppSpace.navCircle + 34;

    return Stack(
      children: [
        // A vertical-only drag pans the biome; horizontal drags fall through to
        // the PageView so swiping still changes screens.
        Positioned.fill(
          child: GestureDetector(
            onVerticalDragUpdate: (d) => _game.panVertical(d.delta.dy),
            child: GameWidget(game: _game),
          ),
        ),
        if (isEmpty)
          const Positioned.fill(child: IgnorePointer(child: _EmptyBiome())),
        // Placement mode swaps the HUD for a locked instruction banner.
        if (placing)
          Positioned(
            top: bannerTop,
            left: AppSpace.screenGutter,
            right: AppSpace.screenGutter,
            child: _PlacementBanner(category: placingCategory),
          )
        else ...[
          Positioned(
            top: chromeTop,
            left: AppSpace.screenGutter,
            child: _WorldHud(world: worldsCompleted + 1, treeCount: treeCount),
          ),
          Positioned(
            top: chromeTop,
            right: AppSpace.screenGutter,
            child: const _PhotoStubButton(),
          ),
          // Full world → the reboot lives at the bottom, the only way forward.
          if (treeCount >= kBiomeCapacity)
            Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).padding.bottom + 28,
              child: Center(child: _RebootButton(onTap: _rebootButtonPressed)),
            ),
        ],
      ],
    );
  }
}

/// Locked instruction banner shown over the canvas during placement
/// (`02-biome.md §5.2`). Named + coloured to the pending tree's category.
class _PlacementBanner extends StatelessWidget {
  const _PlacementBanner({required this.category});
  final QuestCategory category;

  static String _label(QuestCategory c) => switch (c) {
        QuestCategory.adventure => 'PLACE YOUR ADVENTURE TREE',
        QuestCategory.fitness => 'PLACE YOUR FITNESS TREE',
        QuestCategory.social => 'PLACE YOUR SPECIAL TREE',
        QuestCategory.creative => 'PLACE YOUR CREATIVE TREE',
        QuestCategory.night => 'PLACE YOUR NIGHT TREE',
        QuestCategory.normal => 'PLACE YOUR TREE',
      };

  @override
  Widget build(BuildContext context) {
    final color = AppColors.category(category);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('🌳 ${_label(category)}',
            style: AppType.label.copyWith(fontSize: 14, color: color)),
        const SizedBox(height: 3),
        Text('Tap a spot in your biome',
            style: AppType.caption.copyWith(color: AppColors.ink)),
      ],
    );
  }
}

/// Top-left progression cluster (`02-biome.md §3`): the long-term WORLD trophy,
/// the n/100 capacity ring, and a worlds-completed subline.
class _WorldHud extends StatelessWidget {
  const _WorldHud({required this.world, required this.treeCount});
  final int world;
  final int treeCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // WORLD N — the world ticker. Flat (non-interactive, so no sticker pop).
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: popSurface(
              fill: AppColors.popPurple, radius: AppRadii.pill, shadow: false),
          child: Text(
            'WORLD $world',
            style: AppType.label
                .copyWith(fontSize: 13, color: Colors.white, letterSpacing: 1),
          ),
        ),
        const SizedBox(height: 8),
        // Capacity ring + count — also flat.
        Container(
          padding: const EdgeInsets.fromLTRB(6, 5, 12, 5),
          decoration: popSurface(
              fill: AppColors.paper, radius: AppRadii.pill, shadow: false),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: CustomPaint(
                    painter: _CapacityRingPainter(treeCount / kBiomeCapacity)),
              ),
              const SizedBox(width: 7),
              Text('🌳 $treeCount/$kBiomeCapacity',
                  style: AppType.label.copyWith(fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }
}

/// Prominent bottom-of-screen reboot CTA, shown on a full (locked) world.
class _RebootButton extends StatelessWidget {
  const _RebootButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PopTappable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
        decoration: popSurface(
            fill: AppColors.popCoral, radius: AppRadii.pill, stroke: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.restart_alt_rounded, size: 20, color: Colors.white),
            const SizedBox(width: 8),
            Text('Reboot Biome',
                style: AppType.label.copyWith(fontSize: 16, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class _CapacityRingPainter extends CustomPainter {
  _CapacityRingPainter(this.fraction);
  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2 - 3;
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = AppColors.haze;
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..color = AppColors.biomeGreen;
    canvas.drawCircle(c, r, track);
    canvas.drawArc(Rect.fromCircle(center: c, radius: r), -math.pi / 2,
        2 * math.pi * fraction.clamp(0, 1), false, arc);
  }

  @override
  bool shouldRepaint(_CapacityRingPainter old) => old.fraction != fraction;
}

/// Photo mode (Tier 1) is deferred to a follow-up — this is the parked button
/// (`02-biome.md §4`). Tapping it explains that for now.
class _PhotoStubButton extends StatelessWidget {
  const _PhotoStubButton();

  @override
  Widget build(BuildContext context) {
    return PopTappable(
      onTap: () => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('📸 Photo mode coming soon'))),
      child: Container(
        width: AppSpace.shellControl,
        height: AppSpace.shellControl,
        alignment: Alignment.center,
        decoration: popSurface(fill: AppColors.paper, radius: AppRadii.pill),
        child: const Icon(Icons.photo_camera_outlined,
            size: 22, color: AppColors.ink),
      ),
    );
  }
}

/// Fresh-world prompt (`02-biome.md §7`): Level 1, no trees yet.
class _EmptyBiome extends StatelessWidget {
  const _EmptyBiome();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🌱', style: TextStyle(fontSize: 52)),
            const SizedBox(height: 14),
            Text(
              'Earn a level and plant your first tree!',
              textAlign: TextAlign.center,
              style: AppType.bodyL.copyWith(color: AppColors.ink),
            ),
            const SizedBox(height: 18),
            const _BeckonChevron(),
          ],
        ),
      ),
    );
  }
}

/// A lone ">" that rhythmically nudges right + fades, beckoning a swipe toward
/// Side Quests (mirrors the shell's edge-peek motion).
class _BeckonChevron extends StatefulWidget {
  const _BeckonChevron();

  @override
  State<_BeckonChevron> createState() => _BeckonChevronState();
}

class _BeckonChevronState extends State<_BeckonChevron>
    with SingleTickerProviderStateMixin {
  late final AnimationController _beckon = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);
  late final Animation<double> _t =
      CurvedAnimation(parent: _beckon, curve: Curves.easeInOut);

  @override
  void dispose() {
    _beckon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _t,
      builder: (_, _) => Transform.translate(
        offset: Offset(8 * _t.value, 0),
        child: Opacity(
          opacity: 0.35 + 0.55 * _t.value,
          child: Icon(Icons.chevron_right_rounded,
              size: 30, color: AppColors.popPurple),
        ),
      ),
    );
  }
}
