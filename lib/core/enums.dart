/// Shared domain enums (Data Models §5). Stored by Drift via `textEnum<E>()`
/// later — define them once here so theme + data layers share one source.
///
/// RULES: never reorder cases, never rename a shipped case, add new cases at
/// the end (renames require a stored-string migration).
library;

/// `normal` is **tree-only** — the neutral fallback for habit-driven level-ups
/// (Data Models §7.8). Never offer it in a quest category picker.
enum QuestCategory { adventure, fitness, social, creative, night, normal }

enum QuestSource { preset, user }

enum HabitType { good, bad }

/// `done` = good habit performed. `avoided` = bad habit successfully avoided.
/// A log row exists only for the positive action (no "slip"; Design Doc §6.5).
enum HabitLogStatus { done, avoided }

enum JournalFont { handwriting, formal }

enum JournalAlignment { left, right }
