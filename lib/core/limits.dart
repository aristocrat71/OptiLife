/// Input character caps for the CRUD editors + journal. Titles are also bounded
/// by the Drift `withLength` constraints in `data/tables.dart` (200/200/300), so
/// these tighter UI caps stay safely under the DB limits; descriptions/notes and
/// the journal body have no DB limit, so these are purely UI guards.
abstract final class TextLimits {
  static const taskTitle = 100;
  static const taskNotes = 200;
  static const habitTitle = 20;
  static const habitDescription = 100;
  static const questTitle = 80;
  static const questDescription = 200;
  static const journalBody = 1000;
}

/// Trees a single biome holds before the reboot prompt fires (Data Models §7.6,
/// `02-biome.md §6`).
///
/// TEMP (testing only): set low so the reboot can be exercised without 100
/// trees. 10 leaves room to test placement (ghost/dust) before the world fills.
/// **Bump back to 100 before release.**
const int kBiomeCapacity = 10;
