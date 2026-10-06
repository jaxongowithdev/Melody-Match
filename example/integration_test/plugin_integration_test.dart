import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:user_screen/user_screen.dart';
import 'package:user_screen/src/melody/progress.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Melody Match native navigation, purchase and SQLite restore', (
    tester,
  ) async {
    final store = LocalProgressStore(
      filename: 'melody_match_integration_test.db',
    );
    final progress = MelodyProgress(store: store);
    await progress.load();
    await progress.reset();
    await tester.pumpWidget(UserScreen(progress: progress));
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
      [12, 15],
    ]) {
      for (final index in pair) {
        await tester.tap(find.byKey(ValueKey('tile-$index')));
      }
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('BRAVO!'), findsOneWidget);
    expect(progress.unlocked, 2);
    await tester.tap(find.byTooltip('Back to home'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Quests'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('CLAIM REWARD').first);
    await tester.pumpAndSettle();
    expect(progress.claimed, contains('first'));
    await tester.tap(find.text('Shop'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('BUY · 75 🪙'));
    await tester.pumpAndSettle();
    expect(progress.boosters['hint'], 6);
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(progress.sound, isFalse);
    await progress.flush();
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    final restored = MelodyProgress(
      store: LocalProgressStore(filename: 'melody_match_integration_test.db'),
    );
    await restored.load();
    expect(restored.error, isNull);
    expect(restored.unlocked, 2);
    expect(restored.collection.length, 8);
    expect(restored.coins, progress.coins);
    expect(restored.sound, isFalse);
    expect(restored.claimed, contains('first'));
    await tester.pumpWidget(UserScreen(progress: restored));
    await tester.pumpAndSettle();
    expect(find.text('PLAY LEVEL 2'), findsOneWidget);
    await tester.tap(find.text('Collection'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Violin'));
    await tester.pumpAndSettle();
    expect(find.text('Discovered · 1 pair collected'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
  });
}
