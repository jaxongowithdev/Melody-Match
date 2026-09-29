import 'package:flutter/material.dart';
import '../data/library.dart';
import '../utils/visual_theme.dart';
import '../widgets/stoa_chrome.dart';
import 'session_player_view.dart';

class ShadeView extends StatelessWidget {
  const ShadeView({super.key});
  @override
  Widget build(BuildContext context) {
    final rest =
        PracticeLibrary.sessions.where((s) => s.kind == 'sleep').toList();
    return ListView(padding: const EdgeInsets.all(20), children: [
      Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
              color: VisualTheme.night,
              borderRadius: BorderRadius.circular(30)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.nights_stay_outlined,
                size: 38, color: VisualTheme.apricot),
            const SizedBox(height: 24),
            Text('Let the day\nrecede.',
                style: VisualTheme.display(32, color: Colors.white)),
            const SizedBox(height: 12),
            Text(
                'No finish line. No need to fall asleep. Find support and leave the next task for later.',
                style: VisualTheme.body(15, color: VisualTheme.nightMuted)),
          ])),
      const SizedBox(height: 20),
      for (final session in rest)
        Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: BayCard(
                session: session,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) =>
                        SessionPlayerView(session: session, dim: true))))),
    ]);
  }
}
