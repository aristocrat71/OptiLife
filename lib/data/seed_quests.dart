import '../core/enums.dart';

/// A starter preset-quest pool, seeded on first launch (Data Models §4.3/§9).
/// Plain records so this file stays free of generated Drift types — the
/// database maps them to `QuestsCompanion` rows (all `source = preset`).
///
/// TODO: expand toward the ~50–100 curated pool (Design Doc §10). `normal`
/// is intentionally absent (tree-only category).
typedef PresetQuest = ({String title, String? description, QuestCategory category});

const List<PresetQuest> presetQuests = [
  // adventure
  (title: 'Explore a street you\'ve never walked down', description: null, category: QuestCategory.adventure),
  (title: 'Take a different route home', description: null, category: QuestCategory.adventure),
  (title: 'Visit a place in your town you\'ve never been', description: null, category: QuestCategory.adventure),
  // fitness
  (title: 'Do 50 pushups', description: null, category: QuestCategory.fitness),
  (title: 'Go for a 20-minute walk', description: null, category: QuestCategory.fitness),
  (title: 'Stretch for 10 minutes', description: null, category: QuestCategory.fitness),
  (title: 'Go swimming', description: null, category: QuestCategory.fitness),
  // social
  (title: 'Call a friend you haven\'t spoken to in a while', description: null, category: QuestCategory.social),
  (title: 'Give someone a genuine compliment', description: null, category: QuestCategory.social),
  (title: 'Cook a meal with or for someone', description: null, category: QuestCategory.social),
  // creative
  (title: 'Draw something for 10 minutes', description: null, category: QuestCategory.creative),
  (title: 'Write a page of anything', description: null, category: QuestCategory.creative),
  (title: 'Learn 3 chords or a short tune', description: null, category: QuestCategory.creative),
  // night
  (title: 'Stargaze for 5 minutes', description: null, category: QuestCategory.night),
  (title: 'Take a slow walk after dark', description: null, category: QuestCategory.night),
];
