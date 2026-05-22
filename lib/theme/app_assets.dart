/// Central registry of bundled asset paths.
///
/// Rule: widgets reference these constants — never raw asset-path strings.
/// See `ui-design-docs/09-assets-iconography.md` for the full manifest and
/// the tree-sprite contract (foot-anchored, base = bottom-centre).
///
/// `treeSprite` is keyed by category *name* (e.g. `QuestCategory.adventure.name`)
/// so this file stays decoupled from the Drift enum until that layer exists.
abstract final class AppAssets {
  // ── directories ──
  static const _icons = 'assets/icons';
  static const _illus = 'assets/illustrations';
  static const _trees = 'assets/trees';
  static const _icon = 'assets/icon';

  // ── app icon / splash masters ──
  static const appIconMaster = '$_icon/app_icon.svg';

  // ── tree sprites (placeholder SVGs; swap for real sprites in art pass) ──
  static const treeAdventure = '$_trees/tree_adventure.svg';
  static const treeFitness = '$_trees/tree_fitness.svg';
  static const treeSocial = '$_trees/tree_social.svg';
  static const treeCreative = '$_trees/tree_creative.svg';
  static const treeNight = '$_trees/tree_night.svg';
  static const treeNormal = '$_trees/tree_normal.svg';

  /// Resolve a tree sprite from a category name. Unknown → normal (the
  /// neutral fallback, per Data Models §7.8).
  static String treeSprite(String categoryName) => switch (categoryName) {
        'adventure' => treeAdventure,
        'fitness' => treeFitness,
        'social' => treeSocial,
        'creative' => treeCreative,
        'night' => treeNight,
        _ => treeNormal,
      };

  // ── category glyphs (add SVGs to assets/icons/, names per manifest) ──
  static const icCatAdventure = '$_icons/ic_cat_adventure.svg';
  static const icCatFitness = '$_icons/ic_cat_fitness.svg';
  static const icCatSocial = '$_icons/ic_cat_social.svg';
  static const icCatCreative = '$_icons/ic_cat_creative.svg';
  static const icCatNight = '$_icons/ic_cat_night.svg';

  /// Category glyph by name. `normal` has no quest glyph (tree-only).
  static String categoryIcon(String categoryName) => switch (categoryName) {
        'adventure' => icCatAdventure,
        'fitness' => icCatFitness,
        'social' => icCatSocial,
        'creative' => icCatCreative,
        'night' => icCatNight,
        _ => icCatAdventure,
      };

  // ── illustrations (empty / celebration slots) ──
  static const emptyQuests = '$_illus/empty_quests.svg';
  static const emptyTasks = '$_illus/empty_tasks.svg';
  static const emptyJournal = '$_illus/empty_journal.svg';
  static const emptyBiome = '$_illus/empty_biome.svg';
  static const futureLocked = '$_illus/future_locked.svg';
  static const levelupHero = '$_illus/levelup_hero.svg';
  static const rebootWorld = '$_illus/reboot_world.svg';
}
