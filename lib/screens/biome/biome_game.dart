import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
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
  double _baseZoom = 1; // the fit-to-screen zoom set on load
  Vector2? _pinchAnchor; // world point held under the moving pinch midpoint
  double _pinchZoom0 = 1; // camera zoom when the pinch began
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

  /// Foot-anchored sprite size for a cell: native 62×84 aspect, scaled to the
  /// tile footprint and shrunk toward the back for depth. Shared by the planted
  /// tree and the placement ghost.
  static Vector2 treeSize(int col, int row) {
    const baseW = tileW * 0.95;
    final depth = (col + row) / (cols + rows - 2);
    final s = lerpDouble(0.82, 1.06, depth)!;
    return Vector2(baseW, baseW * 84 / 62) * s;
  }

  /// Cells currently holding a tree (encoded via [cellKey]).
  Set<int> occupiedKeys() =>
      {for (final t in _trees.values) cellKey(t.col, t.row)};

  // A pale backdrop so only the diamond grid reads green (a saturated
  // full-screen green felt too heavy).
  @override
  Color backgroundColor() => AppColors.biomeSky;

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
    _baseZoom = (size.x / (worldW + tileW)).clamp(0.45, 1.3);
    camera.viewfinder
      ..position = _gridCentre
      ..zoom = _baseZoom;

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

    // Remove trees that no longer exist. A level-down uproots the newest tree
    // with a reverse-pop; a reboot wipes everything, so skip the per-tree
    // animation there (the dimensional-travel warp covers it).
    final removed = _trees.keys.where((id) => !wanted.containsKey(id)).toList();
    final wipe = wanted.isEmpty && removed.length > 1;
    for (final id in removed) {
      final comp = _trees.remove(id);
      if (wipe) {
        comp?.removeFromParent();
      } else {
        comp?.uproot();
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
      // Freshly planted (not initial seed) → kick a little dust at the foot.
      if (_seeded) _plantDust(col, r);
    }
    _seeded = true;
  }

  /// A small brown dust puff bursting outward along the ground when a tree
  /// drops in (`02-biome.md §5.2`, motion §2.5).
  void _plantDust(int col, int row) {
    final rnd = math.Random();
    world.add(ParticleSystemComponent(
      position: cellCentre(col, row),
      priority: (col + row) * 16 + col + 1,
      particle: Particle.generate(
        count: 12,
        generator: (i) {
          final angle = rnd.nextDouble() * 2 * math.pi;
          final speed = 16 + rnd.nextDouble() * 26;
          return AcceleratedParticle(
            // Longer-lived + gentler gravity so the puff is actually visible.
            lifespan: 0.9 + rnd.nextDouble() * 0.5,
            acceleration: Vector2(0, 55),
            speed: Vector2(math.cos(angle) * speed, math.sin(angle) * speed * 0.4 - 14),
            child: ComputedParticle(
              renderer: (canvas, particle) {
                // Hold opacity, then ease out over the back half of the life.
                final fade = (1 - particle.progress * particle.progress)
                    .clamp(0.0, 1.0);
                final paint = Paint()
                  ..color = const Color(0xFFB89B72).withValues(alpha: fade * 0.75);
                canvas.drawCircle(Offset.zero, 7 * (1 - particle.progress) + 2, paint);
              },
            ),
          );
        },
      ),
    ));
  }

  /// Begin a pinch: remember the camera zoom and the world point under the
  /// pinch midpoint [focal] (game-widget coordinates).
  void pinchBegin(Offset focal) {
    if (!_ready) return;
    _pinchZoom0 = camera.viewfinder.zoom;
    _pinchAnchor = camera.globalToLocal(Vector2(focal.dx, focal.dy));
  }

  /// Update a pinch (`02-biome.md §2`): [scale] is the finger-distance ratio
  /// since [pinchBegin]; [focal] is the current midpoint. Zoom is clamped, then
  /// the camera is shifted so the anchored world point sits back under the
  /// midpoint — giving simultaneous pan + zoom toward the fingers.
  void pinchUpdate(double scale, Offset focal) {
    final anchor = _pinchAnchor;
    if (!_ready || anchor == null) return;
    camera.viewfinder.zoom =
        (_pinchZoom0 * scale).clamp(_baseZoom * 0.75, _baseZoom * 3.0);
    final now = camera.globalToLocal(Vector2(focal.dx, focal.dy));
    final p = camera.viewfinder.position;
    camera.viewfinder.position =
        Vector2(p.x + anchor.x - now.x, p.y + anchor.y - now.y);
    _clampCamera();
  }

  void pinchEnd() => _pinchAnchor = null;

  /// Reset the camera to the fit-to-screen zoom, centred on the grid.
  void resetView() {
    if (!_ready) return;
    _pinchAnchor = null;
    camera.viewfinder
      ..zoom = _baseZoom
      ..position = _gridCentre;
  }

  /// Vertical drag → pan the camera within bounds (horizontal swipes are left
  /// to the PageView). `dy` is the screen-space drag delta.
  void panVertical(double dy) {
    if (!_ready) return;
    final vf = camera.viewfinder;
    vf.position = Vector2(vf.position.x, vf.position.y - dy / vf.zoom);
    _clampCamera();
  }

  /// Keep the camera within a generous box around the grid so it can't drift
  /// off into empty space (used by pan + zoom).
  void _clampCamera() {
    final vf = camera.viewfinder;
    final c = _gridCentre;
    final spanX = (cols + rows) * tileW / 4 + 80;
    final spanY = (cols + rows) * tileH / 4 + 80;
    vf.position = Vector2(
      vf.position.x.clamp(c.x - spanX, c.x + spanX),
      vf.position.y.clamp(c.y - spanY, c.y + spanY),
    );
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
    size = BiomeGame.treeSize(col, row);
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

  /// Level-down: squash the tree back into the ground, then remove it
  /// (`02-biome.md §5.4`).
  void uproot() {
    add(ScaleEffect.to(
      Vector2(1.2, 0),
      EffectController(duration: 0.28, curve: Curves.easeInBack),
      onComplete: removeFromParent,
    ));
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

  // The cell currently under the finger (shows a ghost tree until release).
  int? _ghostCol;
  int? _ghostRow;

  bool get _active => game._placingCategory != null;

  // Capture every tap while placing (and none otherwise), regardless of size.
  @override
  bool containsLocalPoint(Vector2 point) => _active;

  @override
  void update(double dt) => _phase = (_phase + dt) % 1.0;

  /// Resolve a tap point to a plantable cell, or null if out of range/occupied.
  (int, int)? _cellFor(Vector2 point) {
    final (col, row) = BiomeGame.cellAt(point);
    if (!BiomeGame.inRange(col, row)) return null;
    if (game.occupiedKeys().contains(BiomeGame.cellKey(col, row))) return null;
    return (col, row);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!_active) return;
    final cell = _cellFor(event.localPosition);
    if (cell == null) return;
    _ghostCol = cell.$1;
    _ghostRow = cell.$2;
  }

  @override
  void onTapUp(TapUpEvent event) {
    final col = _ghostCol, row = _ghostRow;
    _ghostCol = _ghostRow = null;
    if (_active && col != null && row != null) {
      game.onCellTapped?.call(col, row);
    }
  }

  @override
  void onTapCancel(TapCancelEvent event) => _ghostCol = _ghostRow = null;

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

    // Ghost tree on the cell under the finger (foot-anchored, translucent).
    final gc = _ghostCol, gr = _ghostRow;
    if (gc != null && gr != null) {
      final svg = game._sprites[game._placingCategory!];
      if (svg != null) {
        final size = BiomeGame.treeSize(gc, gr);
        final c = BiomeGame.cellCentre(gc, gr);
        canvas.saveLayer(null, Paint()..color = const Color(0x80000000));
        canvas.translate(c.x - size.x / 2, c.y - size.y);
        svg.render(canvas, size);
        canvas.restore();
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
