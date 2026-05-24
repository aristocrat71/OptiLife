import '../core/enums.dart';

/// The curated preset-quest pool, seeded on first launch (Data Models §4.3/§9).
/// Plain records so this file stays free of generated Drift types — the
/// database maps them to `QuestsCompanion` rows (all `source = preset`).
///
/// 80 quests across the 5 quest categories (16 each). `normal` is intentionally
/// absent — it's the tree-only fallback for habit-driven level-ups (§7.8).
/// See `design-docs/quest_pool.md` for the reviewed source list.
typedef PresetQuest = ({String title, String? description, QuestCategory category});

const List<PresetQuest> presetQuests = [
  // ── adventure ──
  (title: 'Explore a street you\'ve never walked down', description: null, category: QuestCategory.adventure),
  (title: 'Take a different route to a familiar place', description: null, category: QuestCategory.adventure),
  (title: 'Visit a spot in your town you\'ve never been', description: null, category: QuestCategory.adventure),
  (title: 'Watch the sunrise from somewhere new', description: null, category: QuestCategory.adventure),
  (title: 'Try a food you\'ve never eaten before', description: null, category: QuestCategory.adventure),
  (title: 'Visit a park or green space you don\'t usually go to', description: null, category: QuestCategory.adventure),
  (title: 'Take a photo of something interesting on your commute', description: null, category: QuestCategory.adventure),
  (title: 'Wander with no destination for 20 minutes', description: null, category: QuestCategory.adventure),
  (title: 'Visit a museum, gallery, or local exhibit', description: null, category: QuestCategory.adventure),
  (title: 'Find a nearby viewpoint and go see it', description: null, category: QuestCategory.adventure),
  (title: 'Take public transport somewhere new', description: null, category: QuestCategory.adventure),
  (title: 'Sit somewhere unfamiliar and just observe for 10 minutes', description: null, category: QuestCategory.adventure),
  (title: 'Step into a local shop or market you\'ve never entered', description: null, category: QuestCategory.adventure),
  (title: 'Plan a small day trip for this week', description: null, category: QuestCategory.adventure),
  (title: 'Learn one fact about a landmark near you, then go visit it', description: null, category: QuestCategory.adventure),
  (title: 'Say yes to something outside your routine today', description: null, category: QuestCategory.adventure),

  // ── fitness ──
  (title: 'Do 50 pushups', description: 'Spread them through the day if you need to.', category: QuestCategory.fitness),
  (title: 'Go for a 20-minute walk', description: null, category: QuestCategory.fitness),
  (title: 'Stretch for 10 minutes', description: null, category: QuestCategory.fitness),
  (title: 'Go swimming', description: null, category: QuestCategory.fitness),
  (title: 'Do a 15-minute home workout', description: null, category: QuestCategory.fitness),
  (title: 'Take the stairs every time today', description: null, category: QuestCategory.fitness),
  (title: 'Do 3 sets of squats', description: null, category: QuestCategory.fitness),
  (title: 'Go for a run', description: null, category: QuestCategory.fitness),
  (title: 'Hold a plank as long as you can, twice', description: null, category: QuestCategory.fitness),
  (title: 'Do 10 minutes of yoga', description: null, category: QuestCategory.fitness),
  (title: 'Hit 8,000 steps today', description: null, category: QuestCategory.fitness),
  (title: 'Cycle somewhere instead of driving', description: null, category: QuestCategory.fitness),
  (title: 'Do a quick mobility routine for your back and hips', description: null, category: QuestCategory.fitness),
  (title: 'Dance to 3 full songs', description: null, category: QuestCategory.fitness),
  (title: 'Do 100 jumping jacks across the day', description: null, category: QuestCategory.fitness),
  (title: 'Spend 15 minutes on a sport you enjoy', description: null, category: QuestCategory.fitness),

  // ── social ──
  (title: 'Call a friend you haven\'t spoken to in a while', description: null, category: QuestCategory.social),
  (title: 'Give someone a genuine compliment', description: null, category: QuestCategory.social),
  (title: 'Cook a meal with or for someone', description: null, category: QuestCategory.social),
  (title: 'Send a thank-you to someone who helped you', description: null, category: QuestCategory.social),
  (title: 'Check in on a family member', description: null, category: QuestCategory.social),
  (title: 'Have a real conversation with an acquaintance', description: null, category: QuestCategory.social),
  (title: 'Invite someone to do something this week', description: null, category: QuestCategory.social),
  (title: 'Write a kind note and leave it for someone to find', description: null, category: QuestCategory.social),
  (title: 'Reconnect with an old friend', description: null, category: QuestCategory.social),
  (title: 'Ask someone about their day, and really listen', description: null, category: QuestCategory.social),
  (title: 'Share something you made or learned with a friend', description: null, category: QuestCategory.social),
  (title: 'Help someone without being asked', description: null, category: QuestCategory.social),
  (title: 'Eat a meal with someone, phones away', description: null, category: QuestCategory.social),
  (title: 'Reply to that message you\'ve been putting off', description: null, category: QuestCategory.social),
  (title: 'Introduce two people who\'d get along', description: null, category: QuestCategory.social),
  (title: 'Tell someone you appreciate them', description: null, category: QuestCategory.social),

  // ── creative ──
  (title: 'Draw something for 10 minutes', description: null, category: QuestCategory.creative),
  (title: 'Write a page of anything', description: null, category: QuestCategory.creative),
  (title: 'Learn 3 chords or a short tune', description: null, category: QuestCategory.creative),
  (title: 'Take 5 interesting photos', description: null, category: QuestCategory.creative),
  (title: 'Write a short poem or haiku', description: null, category: QuestCategory.creative),
  (title: 'Doodle in the margins for 5 minutes', description: null, category: QuestCategory.creative),
  (title: 'Try a new recipe from scratch', description: null, category: QuestCategory.creative),
  (title: 'Make a playlist around a mood or theme', description: null, category: QuestCategory.creative),
  (title: 'Jot down 10 ideas about anything', description: null, category: QuestCategory.creative),
  (title: 'Sketch an object in front of you', description: null, category: QuestCategory.creative),
  (title: 'Learn the opening of a song on an instrument', description: null, category: QuestCategory.creative),
  (title: 'Free-write for 10 minutes without stopping', description: null, category: QuestCategory.creative),
  (title: 'Make something with your hands', description: 'Fold, build, or craft — anything goes.', category: QuestCategory.creative),
  (title: 'Refresh or redecorate a small corner of a room', description: null, category: QuestCategory.creative),
  (title: 'Start a tiny creative project and do step one', description: null, category: QuestCategory.creative),
  (title: 'Capture a short video of something beautiful', description: null, category: QuestCategory.creative),

  // ── night ──
  (title: 'Stargaze for 5 minutes', description: null, category: QuestCategory.night),
  (title: 'Take a slow walk after dark', description: null, category: QuestCategory.night),
  (title: 'Write down 3 things that went well today', description: null, category: QuestCategory.night),
  (title: 'Read a few pages before bed instead of your phone', description: null, category: QuestCategory.night),
  (title: 'Do a 5-minute wind-down breathing exercise', description: null, category: QuestCategory.night),
  (title: 'Put your phone away an hour before sleep', description: null, category: QuestCategory.night),
  (title: 'Make a calming tea and drink it slowly', description: null, category: QuestCategory.night),
  (title: 'Watch the moon for a few minutes', description: null, category: QuestCategory.night),
  (title: 'Tidy one small space before bed', description: null, category: QuestCategory.night),
  (title: 'Reflect on your day in your journal', description: null, category: QuestCategory.night),
  (title: 'Plan tomorrow\'s top three things', description: null, category: QuestCategory.night),
  (title: 'Dim the lights and listen to calm music', description: null, category: QuestCategory.night),
  (title: 'Do a gentle stretch before bed', description: null, category: QuestCategory.night),
  (title: 'Step outside and feel the night air for a moment', description: null, category: QuestCategory.night),
  (title: 'Write a worry down and set it aside for tomorrow', description: null, category: QuestCategory.night),
  (title: 'Take a warm shower and let the day go', description: null, category: QuestCategory.night),
];
