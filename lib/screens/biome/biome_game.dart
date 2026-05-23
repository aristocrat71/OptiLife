import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flutter/animation.dart';

import '../../core/enums.dart';
import '../../data/database.dart';
import '../../theme/app_assets.dart';
import '../../theme/app_colors.dart';

/// The Flame layer for the Biome screen (`02-biome.md`). A 10×10 isometric
/// tile grid — 100 cells, 1:1 with the 100-tree biome cap. Trees are
/// foot-anchored SVG sprites placed on cell centres, depth-sorted so nearer
/// trees overlap farther ones. The Flutter chrome (HUD, banners, overlays)
/// lives in `biome_page.dart`; this class only owns the world.
class BiomeGame extends FlameGame {
  BiomeGame();

  // ── grid geometry ──
  static const int cols = 10;
  static const int rows = 10;
  static const double tileW = 72; // full diamond width
  static const double tileH = 36; // full diamond height (2:1 iso)

  final Map<QuestCategory, Svg> _sprites = {};
  final Map<String, TreeComponent> _trees = {};
  late final _GroundComponent _ground;
  late final _PlacementLayer _placement;

  bool _ready = false;
  bool _showGrid = true;
  bool _seeded = false;
  QuestCategory? _placingCategory;
  List<TreeRow> _desired = const [];

  /// Invoked when the user taps a valid empty cell during placement mode.
  void Function(int col, int row)? onCellTapped;

  /// World-space centre of cell (col, row). Columns fan to the right, rows to
  /// the left; depth increases with (col + row).
  static Vector2 cellCentre(int col, int row) =>
      Vector2((col - row) * tileW / 2, (col + row) * tileH / 2);

  /// Centroid of the whole diamond (camera looks here at rest).
  static Vector2 get _gridCentre =>
      Vector2(0, (cols + rows - 2) / 2 * tileH / 2);

  /// Nearest grid cell to a world-space point (may be out of range — caller
  /// range-checks). Inverse of [cellCentre].
  static (int col, int row) cellAt(Vector2 world) {
    final fcol = world.x / tileW + world.y / tileH;
    final frow = world.y / tileH - world.x / tileW;
    return (fcol.round(), frow.round());
  }

  static bool inRange(int col, int row) =>
      col >= 0 && col < cols && row >= 0 && row < rows;

  static int cellKey(int col, int row) => col * rows + row;

  /// Cells currently holding a tree (encoded via [cellKey]).
  Set<int> occupiedKeys() =>
      {for (final t in _trees.values) cellKey(t.col, t.row)};

  // A pale backdrop so only the diamond grid reads green (a saturated
  // full-screen green felt too heavy).
  @override
  Color backgroundColor() => const Color(0xFFE3F1D6);

  @override
  Future<void> onLoad() async {
    for (final cat in QuestCategory.values) {
      final path = AppAssets.treeSprite(cat.name).replaceFirst('assets/', '');
      _sprites[cat] = await Svg.load(path, cache: assets);
    }

    _ground = _GroundComponent()
      ..priority = -1 << 20
      ..visible = _showGrid;
    world.add(_ground);

    _placement = _PlacementLayer(this)..priority = 1 << 20;
    world.add(_placement);

    // Frame the whole diamond with a little breathing room, then centre on it.
    final worldW = (cols + rows) * tileW / 2;
    camera.viewfinder
      ..position = _gridCentre
      ..zoom = (size.x / (worldW + tileW)).clamp(0.45, 1.3);

    _ready = true;
    _applyTrees(_desired);
  }

  /// Hide the tile grid at Level 1 (nothing to plant yet) — the world is just
  /// the soft backdrop until the first tree is earned.
  void setGridVisible(bool visible) {
    _showGrid = visible;
    if (_ready) _ground.visible = visible;
  }

  /// Enter (non-null category) or leave (null) tree-placement mode. While
  /// placing, empty cells shimmer and a tap on one fires [onCellTapped].
  void setPlacement(QuestCategory? category) => _placingCategory = category;

  QuestCategory? get placingCategory => _placingCategory;

  /// Reconcile the rendered trees with the latest DB rows (diff by id).
  void syncTrees(List<TreeRow> trees) {
    _desired = trees;
    if (_ready) _applyTrees(trees);
  }

  void _applyTrees(List<TreeRow> trees) {
    final wanted = {for (final t in trees) t.id: t};

    // Remove trees that no longer exist (level-down, reboot).
    for (final id in _trees.keys.toList()) {
      if (!wanted.containsKey(id)) {
        _trees.remove(id)?.removeFromParent();
      }
    }

    // Add trees that appeared. Trees from the very first sync (initial load /
    // crash-safe resume) pop in silently; later additions are freshly planted,
    // so they get the bouncy squash-settle.
    for (final row in trees) {
      if (_trees.containsKey(row.id)) continue;
      final col = row.positionX.round().clamp(0, cols - 1);
      final r = row.positionY.round().clamp(0, rows - 1);
      final svg = _sprites[row.category] ?? _sprites[QuestCategory.normal]!;
      final comp = TreeComponent(
        svg: svg,
        col: col,
        row: r,
        position: cellCentre(col, r),
        animateIn: _seeded,
      );
      _trees[row.id] = comp;
      world.add(comp);
    }
    _seeded = true;
  }

  /// Vertical drag → pan the camera within bounds (horizontal swipes are left
  /// to the PageView). `dy` is the screen-space drag delta.
  void panVertical(double dy) {
    final vf = camera.viewfinder;
    final worldDy = dy / vf.zoom;
    final centreY = _gridCentre.y;
    final span = (cols + rows) * tileH / 4 + 80;
    final nextY = (vf.position.y - worldDy).clamp(centreY - span, centreY + span);
    vf.position = Vector2(vf.position.x, nextY);
  }
}

/// A single foot-anchored tree sprite on a grid cell. Depth-sorted by
/// (col + row) and gently back-scaled so the world reads as 2.5D. Holds a
/// shared [Svg] (never disposes it — the game owns sprite lifetimes).
class TreeComponent extends PositionComponent {
  TreeComponent({
    required this.svg,
    required this.col,
    required this.row,
    required Vector2 position,
    this.animateIn = false,
  }) : super(
          position: position,
          anchor: Anchor.bottomCenter,
          // Higher (col+row) = nearer the viewer = drawn on top. The +col
          // term breaks ties along a diagonal deterministically.
          priority: (col + row) * 16 + col,
        ) {
    // Native sprite is 62×84; keep that aspect, scale to the tile footprint,
    // and shrink toward the back for depth.
    const baseW = BiomeGame.tileW * 0.95;
    final depth = (col + row) / (BiomeGame.cols + BiomeGame.rows - 2);
    final s = lerpDouble(0.82, 1.06, depth)!;
    size = Vector2(baseW, baseW * 84 / 62) * s;
  }

  final Svg svg;
  final int col;
  final int row;
  final bool animateIn;

  @override
  Future<void> onLoad() async {
    if (animateIn) {
      // Squash on contact, then elastic-settle upward from the foot anchor.
      scale = Vector2(1.3, 0.3);
      add(ScaleEffect.to(
        Vector2.all(1),
        EffectController(duration: 0.55, curve: Curves.elasticOut),
      ));
    }
  }

  @override
  void render(Canvas canvas) => svg.render(canvas, size);
}

/// Top-of-world layer active only during placement mode: shimmers the empty
/// cells, marks occupied ones with a soft ✕, and captures the placing tap.
class _PlacementLayer extends PositionComponent with TapCallbacks {
  _PlacementLayer(this.game);
  final BiomeGame game;
  double _phase = 0;

  bool get _active => game._placingCategory != null;

  // Capture every tap while placing (and none otherwise), regardless of size.
  @override
  bool containsLocalPoint(Vector2 point) => _active;

  @override
  void update(double dt) => _phase = (_phase + dt) % 1.0;

  @override
  void onTapDown(TapDownEvent event) {
    if (!_active) return;
    final (col, row) = BiomeGame.cellAt(event.localPosition);
    if (!BiomeGame.inRange(col, row)) return;
    if (game.occupiedKeys().contains(BiomeGame.cellKey(col, row))) return;
    game.onCellTapped?.call(col, row);
  }

  @override
  void render(Canvas canvas) {
    if (!_active) return;
    final occupied = game.occupiedKeys();
    final tint = AppColors.category(game._placingCategory!);
    // Pulse 0..1..0 over the loop for a gentle shimmer.
    final pulse = (math.sin(_phase * 2 * math.pi) + 1) / 2;
    const hw = BiomeGame.tileW / 2;
    const hh = BiomeGame.tileH / 2;

    final fill = Paint()..color = tint.withValues(alpha: 0.12 + 0.20 * pulse);
    final edge = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = tint.withValues(alpha: 0.45 + 0.35 * pulse);
    final cross = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..color = AppColors.ink.withValues(alpha: 0.18);

    for (var col = 0; col < BiomeGame.cols; col++) {
      for (var row = 0; row < BiomeGame.rows; row++) {
        final c = BiomeGame.cellCentre(col, row);
        if (occupied.contains(BiomeGame.cellKey(col, row))) {
          const m = 6.0;
          canvas
            ..drawLine(Offset(c.x - m, c.y - m / 2), Offset(c.x + m, c.y + m / 2), cross)
            ..drawLine(Offset(c.x + m, c.y - m / 2), Offset(c.x - m, c.y + m / 2), cross);
          continue;
        }
        final path = Path()
          ..moveTo(c.x, c.y - hh)
          ..lineTo(c.x + hw, c.y)
          ..lineTo(c.x, c.y + hh)
          ..lineTo(c.x - hw, c.y)
          ..close();
        canvas
          ..drawPath(path, fill)
          ..drawPath(path, edge);
      }
    }
  }
}

/// Draws the isometric ground: 100 soft diamond tiles in a checkerboard of two
/// greens with a hairline outline. Lives behind every tree.
class _GroundComponent extends PositionComponent {
  static final _light = Paint()..color = const Color(0xFF8BD37F);
  static final _dark = Paint()..color = const Color(0xFF7AC974);
  static final _stroke = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = AppColors.ink.withValues(alpha: 0.06);

  /// Hidden at Level 1 (see [BiomeGame.setGridVisible]).
  bool visible = true;

  @override
  void render(Canvas canvas) {
    if (!visible) return;
    const hw = BiomeGame.tileW / 2;
    const hh = BiomeGame.tileH / 2;
    for (var col = 0; col < BiomeGame.cols; col++) {
      for (var row = 0; row < BiomeGame.rows; row++) {
        final c = BiomeGame.cellCentre(col, row);
        final path = Path()
          ..moveTo(c.x, c.y - hh)
          ..lineTo(c.x + hw, c.y)
          ..lineTo(c.x, c.y + hh)
          ..lineTo(c.x - hw, c.y)
          ..close();
        canvas.drawPath(path, (col + row).isEven ? _light : _dark);
        canvas.drawPath(path, _stroke);
      }
    }
  }
}
