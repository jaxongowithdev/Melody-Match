import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_screen/src/screens/user_screen.dart';
import 'package:user_screen/src/utils/visual_theme.dart';

void main() {
  for (final size in [
    const Size(390, 844),
    const Size(320, 568),
    const Size(844, 390)
  ]) {
    for (final dark in [false, true]) {
      testWidgets('onboarding at $size, dark=$dark, enlarged text',
          (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(MaterialApp(
          theme: dark ? VisualTheme.darkTheme : VisualTheme.lightTheme,
          builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.3)),
              child: child!),
          home: WelcomeView(onFinished: () {}),
        ));
        expect(tester.takeException(), isNull);
        for (var page = 0; page < 3; page++) {
          await tester.tap(find.text('Continue'));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
        expect(find.text('Start my Walk'), findsOneWidget);
      });
    }
  }
}
