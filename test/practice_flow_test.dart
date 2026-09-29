import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_screen/src/data/library.dart';
import 'package:user_screen/src/screens/breath_view.dart';
import 'package:user_screen/src/screens/session_player_view.dart';
import 'package:user_screen/src/utils/visual_theme.dart';

void main() {
  testWidgets('Four columns pauses, resumes and completes all four rounds',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        theme: VisualTheme.darkTheme,
        home: BreathView(pattern: PracticeLibrary.patterns.first)));
    await tester.ensureVisible(find.text('Start breathing'));
    await tester.tap(find.text('Start breathing'));
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('2'), findsOneWidget);
    await tester.tap(find.text('Pause breathing'));
    await tester.pump(const Duration(seconds: 8));
    expect(find.text('2'), findsOneWidget);
    await tester.ensureVisible(find.text('Start breathing'));
    await tester.tap(find.text('Start breathing'));
    await tester.pump(const Duration(seconds: 62));
    await tester.pumpAndSettle();
    expect(find.text('Done'), findsOneWidget);
    expect(find.text('Round 4 / 4'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Walk timer advances steps, pauses and reaches completion',
      (tester) async {
    final session = PracticeLibrary.sessions.first;
    await tester.pumpWidget(MaterialApp(
        theme: VisualTheme.darkTheme,
        home: SessionPlayerView(session: session)));
    await tester.tap(find.text('Start session'));
    await tester.pump(const Duration(seconds: 30));
    expect(find.text('01:30'), findsOneWidget);
    await tester.tap(find.text('Pause session'));
    await tester.pump(const Duration(seconds: 10));
    expect(find.text('01:30'), findsOneWidget);
    await tester.tap(find.text('Start session'));
    await tester.pump(Duration(seconds: session.totalSeconds - 30));
    await tester.pumpAndSettle();
    expect(find.text('Walk complete.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
