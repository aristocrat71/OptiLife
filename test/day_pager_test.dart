import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:optilife/data/database.dart';
import 'package:optilife/state/app_providers.dart';
import 'package:optilife/widgets/day_pager.dart';

Widget _host(ProviderContainer c) => UncontrolledProviderScope(
      container: c,
      child: const MaterialApp(
        home: Scaffold(
          body: DayPager(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(height: 120, child: Center(child: Text('content'))),
            ],
          ),
        ),
      ),
    );

void main() {
  testWidgets('bottom overscroll advances to the next day', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final c = ProviderContainer(
        overrides: [databaseProvider.overrideWithValue(db)]);
    addTearDown(c.dispose);
    final start = c.read(selectedDateProvider);

    await tester.pumpWidget(_host(c));
    await tester.pump();

    // Finger drags up → overscroll past the bottom edge → next day.
    await tester.drag(find.text('content'), const Offset(0, -300));
    await tester.pump();

    expect(c.read(selectedDateProvider), start.add(const Duration(days: 1)));
  });

  testWidgets('top overscroll on the first day is blocked', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final c = ProviderContainer(
        overrides: [databaseProvider.overrideWithValue(db)]);
    addTearDown(c.dispose);
    // Ensure app_state (createdAt = today) has loaded so the floor is today.
    // Drift's stream resolves on the real event loop, so load it via runAsync —
    // awaiting it inside testWidgets' fake-async clock would deadlock.
    await tester.runAsync(() => c.read(appStateProvider.future));
    final start = c.read(selectedDateProvider);

    await tester.pumpWidget(_host(c));
    await tester.pump();

    // Finger drags down → overscroll past the top edge → previous day, but
    // today is the first day, so it must be blocked.
    await tester.drag(find.text('content'), const Offset(0, 300));
    await tester.pump();

    expect(c.read(selectedDateProvider), start);
  });
}
