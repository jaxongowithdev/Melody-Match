import 'package:flutter/material.dart';
import '../data/library.dart';
import '../utils/visual_theme.dart';
import '../widgets/stoa_chrome.dart';
import 'pose_view.dart';
import 'session_player_view.dart';

class RangeView extends StatefulWidget {
  const RangeView({super.key});
  @override
  State<RangeView> createState() => _RangeViewState();
}

class _RangeViewState extends State<RangeView> {
  String _query = '';
  bool _lessons = false;
  @override
  Widget build(BuildContext context) {
    final ink = VisualTheme.inkOf(context),
        muted = VisualTheme.mutedOf(context);
    final sessions = PracticeLibrary.sessions
        .where((s) => '${s.title} ${s.subtitle}'
            .toLowerCase()
            .contains(_query.toLowerCase()))
        .toList();
    final lessons = PracticeLibrary.poses
        .where((s) => '${s.name} ${s.aka} ${s.setup}'
            .toLowerCase()
            .contains(_query.toLowerCase()))
        .toList();
    return ListView(padding: const EdgeInsets.all(24), children: [
      Text('The route index.', style: VisualTheme.display(36, color: ink)),
      const SizedBox(height: 10),
      Text('Open a collection. Find your own starting point.',
          style: VisualTheme.body(15, color: muted)),
      const SizedBox(height: 24),
      TextField(
          onChanged: (v) => setState(() => _query = v),
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Find a route or skill')),
      const SizedBox(height: 16),
      Wrap(spacing: 8, children: [
        ChoiceChip(
            label: const Text('Practices'),
            selected: !_lessons,
            onSelected: (_) => setState(() => _lessons = false)),
        ChoiceChip(
            label: const Text('Short lessons'),
            selected: _lessons,
            onSelected: (_) => setState(() => _lessons = true)),
      ]),
      const SizedBox(height: 20),
      if (!_lessons) ...[
        Text('${sessions.length} PRACTICES',
            style: VisualTheme.micro(10, color: muted)),
        const SizedBox(height: 12),
        if (sessions.isEmpty)
          const Text('No matching practices. Try a different word.'),
        for (final group in [
          ('sit', 'Attention'),
          ('mobility', 'Everyday movement'),
          ('yoga', 'Supported shapes'),
          ('breath', 'Breath awareness'),
          ('sleep', 'Evening routes')
        ])
          if (sessions.any((s) => s.kind == group.$1))
            Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                    key: ValueKey('${group.$1}/$_query'),
                    initiallyExpanded: _query.isNotEmpty,
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                    backgroundColor: VisualTheme.bayOf(context),
                    collapsedBackgroundColor: VisualTheme.bayOf(context),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    leading: Icon(Icons.folder_open,
                        color: VisualTheme.accentOf(context)),
                    title: Text(group.$2),
                    subtitle: Text(
                        '${sessions.where((s) => s.kind == group.$1).length} routes'),
                    children: [
                      for (final session
                          in sessions.where((s) => s.kind == group.$1))
                        BayCard(
                            session: session,
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => SessionPlayerView(
                                        session: session,
                                        dim: session.kind == 'sleep')))),
                    ])),
      ] else ...[
        Text('FIELD SKILLS / ${lessons.length}',
            style: VisualTheme.micro(10, color: muted)),
        const SizedBox(height: 12),
        if (lessons.isEmpty)
          const Text('No matching lessons. Try a different word.'),
        for (final lesson in lessons)
          Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ExpansionTile(
                  key: ValueKey('skill/${lesson.id}/$_query'),
                  tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                  title: Text(lesson.name),
                  subtitle: Text(lesson.aka),
                  childrenPadding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lesson.setup, style: VisualTheme.body(15, color: ink)),
                    const SizedBox(height: 12),
                    Text(lesson.breath,
                        style: VisualTheme.body(14, color: muted)),
                    TextButton(
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => PoseView(pose: lesson))),
                        child: const Text('Open lesson')),
                  ])),
      ],
    ]);
  }
}
