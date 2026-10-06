import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_screen/main.dart';
import 'package:user_screen/src/melody/progress.dart';

void main() {
  for (final size in [
    const Size(320, 568),
    const Size(844, 390),
    const Size(768, 1024)
  ]) {
    testWidgets('all hub destinations fit $size with large text',
        (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.3;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(UserScreen(progress: MelodyProgress()));
      await tester.pumpAndSettle();
      for (final name in ['Home', 'Journey', 'Collection', 'Quests', 'Shop']) {
        await tester.tap(find.text(name));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: name);
      }
      await tester.tap(find.byTooltip('Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Sound effects'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('game progress feeds collection, quests, store and locked map',
      (tester) async {
    final progress = MelodyProgress();
    await tester.pumpWidget(UserScreen(progress: progress));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Journey'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Finish level 1 to unlock'));
    await tester.pumpAndSettle();
    expect(find.byType(MelodyMatchScreen), findsNothing);
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('PLAY LEVEL 1'));
    await tester.pumpAndSettle();
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
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(progress.unlocked, 2);
    expect(progress.collection.length, 8);
    await tester.tap(find.byTooltip('Back to home'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Collection'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Violin'));
    await tester.pumpAndSettle();
    expect(find.text('Discovered · 1 pair collected'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Quests'));
    await tester.pumpAndSettle();
    final beforeClaim = progress.coins;
    await tester.tap(find.text('CLAIM REWARD').first);
    await tester.pumpAndSettle();
    expect(progress.coins, beforeClaim + 100);
    await tester.tap(find.text('Shop'));
    await tester.pumpAndSettle();
    final beforePurchase = progress.coins;
    await tester.tap(find.text('BUY · 75 🪙'));
    await tester.pumpAndSettle();
    expect(progress.coins, beforePurchase - 75);
    expect(progress.boosters['hint'], 6);
  });

  testWidgets('free play has no countdown and does not consume freeze',
      (tester) async {
    final progress = MelodyProgress();
    await tester.pumpWidget(MaterialApp(
        home: MelodyMatchScreen(progress: progress, mode: PlayMode.practice)));
    await tester.pump(const Duration(minutes: 5));
    expect(find.text('∞ FREE PLAY'), findsOneWidget);
    expect(find.text('TIME’S UP'), findsNothing);
    await tester.tap(find.byTooltip('Freeze'));
    await tester.pump();
    expect(progress.boosters['freeze'], 2);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('daily encore finishes with its bonus and returns to Home',
      (tester) async {
    final progress = MelodyProgress(now: () => DateTime(2026, 10, 6));
    await tester.pumpWidget(UserScreen(progress: progress));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Daily encore'));
    await tester.tap(find.text('Daily encore'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('PLAY DAILY ENCORE'));
    await tester.tap(find.text('PLAY DAILY ENCORE'));
    await tester.pumpAndSettle();
    expect(find.text('⏱ 1:30'), findsOneWidget);
    final pairs = <String, List<int>>{};
    for (var index = 0; index < 16; index++) {
      final symbol = tester
          .widget<Text>(find.descendant(
            of: find.byKey(ValueKey('tile-$index')),
            matching: find.byType(Text),
          ))
          .data!;
      (pairs[symbol] ??= []).add(index);
    }
    for (final pair in pairs.values) {
      for (final index in pair) {
        await tester.tap(find.byKey(ValueKey('tile-$index')));
      }
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(progress.dailyWins, contains('2026-10-06'));
    expect(progress.coins, 480);
    expect(progress.unlocked, 1);
    await tester.tap(find.text('BACK HOME').first);
    await tester.pumpAndSettle();
    expect(find.text('PLAY LEVEL 1'), findsOneWidget);
    expect(find.byType(MelodyMatchScreen), findsNothing);
  });
}
