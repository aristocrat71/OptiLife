import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:optilife/widgets/shell_controls.dart';

/// Pure-widget render tests. The full app isn't pumped here because the nav's
/// heartbeat/ripple use AnimationController.repeat(), which makes a full-app
/// widget test hang — app boot is verified by running the app.
void main() {
  testWidgets('DateDisplay shows day number, month, and weekday', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: DateDisplay(date: DateTime(2026, 5, 22)))),
    );
    expect(find.text('22'), findsOneWidget);
    expect(find.text('MAY'), findsOneWidget);
    expect(find.text('FRI'), findsOneWidget); // 22 May 2026 is a Friday
  });

  testWidgets('PageDots renders one dot per page', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: PageDots(count: 4, activeIndex: 1))),
    );
    expect(find.byType(AnimatedContainer), findsNWidgets(4));
  });
}
