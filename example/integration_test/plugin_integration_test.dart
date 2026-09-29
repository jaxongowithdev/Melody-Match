import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:user_screen/user_screen.dart';
import 'package:user_screen/src/database/storage_manager.dart';
import 'package:user_screen/src/models/user_preferences.dart';
import 'package:user_screen/src/screens/session_player_view.dart';
import 'package:user_screen/src/screens/breath_view.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets(
    'Mosslight offline onboarding, Walk, breathing, Range and persistent Tablet',
    (tester) async {
      final storage = StorageManager.instance;
      await storage.savePreferences(UserPreferences());
      Future<void> waitFor(Finder finder) async {
        for (var i = 0; i < 100 && finder.evaluate().isEmpty; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }
        expect(finder, findsWidgets);
        await tester.pumpAndSettle();
      }

      await tester.pumpWidget(const UserScreen());
      await waitFor(find.text('Continue'));
      for (var i = 0; i < 3; i++) {
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text('Start my Walk'));
      await waitFor(find.text('Walk this session'));
      await tester.tap(find.text('Walk this session'));
      await tester.pumpAndSettle();
      expect(find.byType(SessionPlayerView), findsOneWidget);
      await tester.tap(find.text('Start session'));
      await tester.pump(const Duration(seconds: 2));
      await tester.tap(find.text('Pause session'));
      await tester.pumpAndSettle();
      for (var i = 0; i < 3; i++) {
        await tester.ensureVisible(find.text('Next step'));
        await tester.tap(find.text('Next step'));
        await tester.pumpAndSettle();
      }
      await tester.ensureVisible(find.text('Finish practice'));
      await tester.tap(find.text('Finish practice'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('grounded'));
      await waitFor(find.text('Walk this session'));
      expect((await storage.recentLogs()).isNotEmpty, isTrue);
      await tester.scrollUntilVisible(
        find.text('Four columns'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Four columns'));
      await tester.pumpAndSettle();
      expect(find.byType(BreathView), findsOneWidget);
      await tester.tap(find.text('Start breathing'));
      await tester.pump(const Duration(seconds: 2));
      await tester.tap(find.text('Pause breathing'));
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Range'));
      await tester.pumpAndSettle();
      expect(find.text('Learn by noticing.'), findsOneWidget);
      await tester.tap(find.text('Tablet'));
      await tester.pumpAndSettle();
      final note =
          'Mosslight offline observation ${DateTime.now().millisecondsSinceEpoch}';
      await tester.enterText(find.byType(TextField), note);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Save note'));
      await tester.tap(find.text('Save note'));
      await waitFor(find.text('Note saved on this device.'));
      expect((await storage.allJournal()).any((e) => e.body == note), isTrue);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      await tester.pumpWidget(const UserScreen());
      await waitFor(find.text('Walk this session'));
      await tester.tap(find.text('Tablet'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text(note),
        200,
        scrollable: find.byType(Scrollable).last,
      );
      expect(find.text(note), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
