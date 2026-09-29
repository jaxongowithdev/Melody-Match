import 'package:flutter/material.dart';
import '../data/library.dart';
import '../utils/visual_theme.dart';
import '../widgets/stoa_chrome.dart';
import 'session_player_view.dart';

class ShadeView extends StatelessWidget {
  const ShadeView({super.key});
  @override
  Widget build(BuildContext context) =>
      ListView(padding: const EdgeInsets.all(24), children: [
        Icon(Icons.nightlight_outlined,
            size: 42, color: VisualTheme.accentOf(context)),
        const SizedBox(height: 24),
        Text('The last landmark\nis rest.',
            style: VisualTheme.display(36, color: VisualTheme.inkOf(context))),
        const SizedBox(height: 16),
        Text(
            'No need to resolve the day. These routes offer a comfortable ending, whether you feel sleepy or simply ready to stop.',
            style: VisualTheme.body(16, color: VisualTheme.mutedOf(context))),
        const Divider(height: 40),
        for (final s
            in PracticeLibrary.sessions.where((s) => s.kind == 'sleep'))
          Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: BayCard(
                  session: s,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>
                          SessionPlayerView(session: s, dim: true))))),
        const SizedBox(height: 16),
        Text('Rest is an invitation, not a result to produce.',
            style: VisualTheme.body(14, color: VisualTheme.mutedOf(context))),
      ]);
}
