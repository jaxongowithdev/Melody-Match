import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_screen/main.dart';
import 'package:user_screen/src/melody/progress.dart';

Future<void> openGame(WidgetTester tester,
    [Size size = const Size(414, 896)]) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
      MaterialApp(home: MelodyMatchScreen(progress: MelodyProgress())));
}

void main() {
  for (final size in [
    const Size(320, 568),
    const Size(414, 896),
    const Size(844, 390)
  ]) {
    testWidgets('game fits $size without overflow', (tester) async {
      await openGame(tester, size);
      expect(find.byKey(const ValueKey('tile-15')), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('matching instruments earns points and collects a pair',
      (tester) async {
    await openGame(tester);
    await tester.tap(find.byKey(const ValueKey('tile-0')));
    await tester.tap(find.byKey(const ValueKey('tile-2')));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('200'), findsOneWidget);
    expect(find.text('1/8 pairs'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('tile-0')));
    await tester.pump();
    expect(find.text('200'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('mismatched tiles do not score and selection recovers',
      (tester) async {
    await openGame(tester);
    await tester.tap(find.byKey(const ValueKey('tile-0')));
    await tester.tap(find.byKey(const ValueKey('tile-1')));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('0/8 pairs'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('tile-0')));
    await tester.tap(find.byKey(const ValueKey('tile-2')));
    await tester.pump();
    expect(find.text('1/8 pairs'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('hint consumes a booster and pause stops the clock',
      (tester) async {
    await openGame(tester);
    await tester.tap(find.text('HINT').last);
    await tester.pump();
    expect(find.text('4'), findsOneWidget);
    expect(find.text('Follow the glow to find your harmony.'), findsOneWidget);
    await tester.tap(find.byTooltip('Pause'));
    await tester.pump(const Duration(seconds: 5));
    expect(find.text('INTERMISSION'), findsOneWidget);
    expect(find.text('⏱ 2:03'), findsOneWidget);
    await tester.tap(find.text('CONTINUE'));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('⏱ 2:02'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('completing the board unlocks the next level', (tester) async {
    await openGame(tester);
    for (final pair in [
      [0, 2],
      [1, 6],
      [3, 4],
      [5, 9],
      [7, 10],
      [8, 14],
      [11, 13],
      [12, 15]
    ]) {
      for (final index in pair) {
        await tester.tap(find.byKey(ValueKey('tile-$index')));
      }
      await tester.pump(const Duration(milliseconds: 250));
    }
    expect(find.text('BRAVO!'), findsOneWidget);
    expect(find.text('8/8 pairs'), findsOneWidget);
    await tester.tap(find.text('NEXT LEVEL').first);
    await tester.pump();
    expect(find.text('LEVEL 2: THE PRACTICE ROOM'), findsOneWidget);
    expect(find.text('0/8 pairs'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
