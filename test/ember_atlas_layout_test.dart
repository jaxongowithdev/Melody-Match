import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_screen/src/data/library.dart';
import 'package:user_screen/src/screens/range_view.dart';
import 'package:user_screen/src/screens/breath_view.dart';
import 'package:user_screen/src/screens/session_player_view.dart';
import 'package:user_screen/src/screens/tablet_view.dart';
import 'package:user_screen/src/utils/visual_theme.dart';
import 'package:user_screen/src/widgets/stoa_chrome.dart';

void main() {
  for (final size in [const Size(320, 568), const Size(844, 390)]) {
    for (final dark in [false, true]) {
      for (final screen in [
        'Range',
        'Breath',
        'Session',
        'Navigation',
        'Editor'
      ]) {
        testWidgets('$screen at $size, dark=$dark, enlarged text',
            (tester) async {
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          final home = switch (screen) {
            'Range' => const Scaffold(body: RangeView()),
            'Breath' => BreathView(pattern: PracticeLibrary.patterns.first),
            'Session' =>
              SessionPlayerView(session: PracticeLibrary.sessions.first),
            'Editor' => const NoteComposer(),
            _ => Scaffold(body: StoaColon(index: 0, onSelect: (_) {})),
          };
          await tester.pumpWidget(MaterialApp(
            theme: dark ? VisualTheme.darkTheme : VisualTheme.lightTheme,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.3)),
              child: child!,
            ),
            home: home,
          ));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        });
      }
    }
  }
}
