import 'package:flutter/material.dart';
import '../data/library.dart';
import '../utils/visual_theme.dart';
import '../widgets/stoa_chrome.dart';
import 'session_player_view.dart';

class ShadeView extends StatelessWidget {
  const ShadeView({super.key});

  @override
  Widget build(BuildContext context) {
    final muted = VisualTheme.mutedOf(context);
    final rest = PracticeLibrary.sessions
        .where((s) => s.kind == 'sleep' || s.aims.contains('sleep'))
        .toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      children: [
        Text(
          'REST / Switch to a slower track. Two guided practices for ending the workday and settling into an unhurried evening.',
          style: VisualTheme.body(16, color: muted),
        ),
        const SizedBox(height: 14),
        ...rest.map(
          (s) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: BayCard(
              session: s,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => SessionPlayerView(session: s, dim: true)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
