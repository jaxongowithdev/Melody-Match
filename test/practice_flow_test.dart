import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_screen/src/data/library.dart';
import 'package:user_screen/src/screens/breath_view.dart';
import 'package:user_screen/src/screens/session_player_view.dart';
import 'package:user_screen/src/screens/range_view.dart';
import 'package:user_screen/src/screens/pose_view.dart';
import 'package:user_screen/src/utils/visual_theme.dart';

void main() {
  testWidgets('Range searches practices and opens a filtered short lesson',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        theme: VisualTheme.lightTheme,
        home: const Scaffold(body: RangeView())));
    await tester.enterText(find.byType(TextField), 'chair hinge');
    await tester.pumpAndSettle();
    expect(find.text('The chair hinge'), findsOneWidget);
    expect(find.text('1 PRACTICES'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'no-such-lesson');
    await tester.pumpAndSettle();
    expect(
        find.text('No matching practices. Try a different word or category.'),
        findsOneWidget);
    await tester.tap(find.text('Short lessons'));
    await tester.enterText(find.byType(TextField), 'palm');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Resting palm'));
    await tester.tap(find.text('Resting palm'));
    await tester.pumpAndSettle();
    expect(find.byType(PoseView), findsOneWidget);
    expect(find.text('SETUP'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Four columns pauses, resumes and completes all four rounds',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        theme: VisualTheme.darkTheme,
        home: BreathView(pattern: PracticeLibrary.patterns.first)));
    await tester.ensureVisible(find.text('Start breathing'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start breathing'));
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('2'), findsOneWidget);
    await tester.tap(find.text('Pause breathing'));
    await tester.pump(const Duration(seconds: 8));
    expect(find.text('2'), findsOneWidget);
    await tester.ensureVisible(find.text('Start breathing'));
    await tester.pumpAndSettle();
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
