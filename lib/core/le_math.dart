/// Level math derived from lifetime LE (Data Models §4.1). Never stored —
/// computed on read so values can't go stale.
int currentLevel(int lifetimeLe) => (lifetimeLe ~/ 50) + 1;
int leIntoLevel(int lifetimeLe) => lifetimeLe % 50;
int leUntilNext(int lifetimeLe) => 50 - (lifetimeLe % 50);
