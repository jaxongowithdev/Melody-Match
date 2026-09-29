import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_screen/src/data/library.dart';
import 'package:user_screen/src/utils/visual_theme.dart';
import 'package:user_screen/src/widgets/stoa_chrome.dart';

void main() {
  testWidgets('bottom navigation opens all four destinations', (tester) async {
    var selected = -1;
    await tester.pumpWidget(
      MaterialApp(
        theme: VisualTheme.darkTheme,
        home: Scaffold(
          bottomNavigationBar: StoaColon(
            index: 0,
            onSelect: (i) => selected = i,
          ),
        ),
      ),
    );
    for (final name in ['Walk', 'Range', 'Rest', 'Tablet']) {
      expect(find.text(name), findsOneWidget);
    }
    await tester.tap(find.text('Tablet'));
    expect(selected, 3);
    expect(tester.takeException(), isNull);
  });
  testWidgets('field lesson card exposes its session and opens on tap', (
    tester,
  ) async {
    var opened = false;
    final session = PracticeLibrary.sessions.first;
    await tester.pumpWidget(
      MaterialApp(
        theme: VisualTheme.darkTheme,
        home: Scaffold(
          body: BayCard(session: session, onTap: () => opened = true),
        ),
      ),
    );
    await tester.tap(find.text(session.title));
    expect(opened, isTrue);
    expect(tester.takeException(), isNull);
  });
}
