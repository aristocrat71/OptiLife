import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:optilife/core/enums.dart';
import 'package:optilife/data/database.dart';

void main() {
  test('first-launch migration seeds singletons + preset quests', () async {
    final db = AppDatabase(NativeDatabase.memory());

    final app = await db.watchAppState().first;
    expect(app.id, 1);
    expect(app.lifetimeLe, 0);
    expect(app.biomesCompleted, 0);
    expect(app.pendingTreeCategory, isNull);

    final settings = await db.watchSettings().first;
    expect(settings.questsPerDay, 3);
    expect(settings.liquidFillEnabled, isTrue);
    expect(settings.journalFont, JournalFont.handwriting);

    final quests = await db.select(db.quests).get();
    expect(quests.length, greaterThan(10));
    expect(quests.every((q) => q.source == QuestSource.preset), isTrue);
    expect(quests.every((q) => q.category != QuestCategory.normal), isTrue,
        reason: 'normal is tree-only, never a quest category');

    await db.close();
  });
}
