/// Day-truncation helpers. The whole app keys day-scoped data off the
/// start-of-day instant (Data Models §2.5).
DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

bool sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
