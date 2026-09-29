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
  String _filter = 'all', _query = '';
  bool _lessons = false;
  @override
  Widget build(BuildContext context) {
    final muted = VisualTheme.mutedOf(context),
        accent = VisualTheme.accentOf(context);
    final sessions = PracticeLibrary.sessions
        .where((s) =>
            (_filter == 'all' ? s.kind != 'sleep' : s.kind == _filter) &&
            '${s.title} ${s.subtitle}'
                .toLowerCase()
                .contains(_query.toLowerCase()))
        .toList();
    final lessons = PracticeLibrary.poses
        .where((p) =>
            '${p.name} ${p.aka}'.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    return ListView(padding: const EdgeInsets.all(22), children: [
      Text('RANGE / THE CONTENTS', style: VisualTheme.micro(10, color: accent)),
      const SizedBox(height: 12),
      Text('Choose a page\nto practice.',
          style: VisualTheme.display(36, color: VisualTheme.inkOf(context))),
      const SizedBox(height: 20),
      TextField(
          onChanged: (value) => setState(() => _query = value),
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Find a practice or lesson')),
      const SizedBox(height: 16),
      SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: false, label: Text('Practices')),
            ButtonSegment(value: true, label: Text('Short lessons')),
          ],
          selected: {
            _lessons
          },
          onSelectionChanged: (values) =>
              setState(() => _lessons = values.first)),
      const SizedBox(height: 16),
      if (!_lessons) ...[
        Wrap(spacing: 8, runSpacing: 4, children: [
          for (final f in ['all', 'yoga', 'breath', 'sit', 'mobility'])
            ChoiceChip(
                label: Text(f == 'all'
                    ? 'All'
                    : f == 'sit'
                        ? 'Attention'
                        : f[0].toUpperCase() + f.substring(1)),
                selected: _filter == f,
                onSelected: (_) => setState(() => _filter = f)),
        ]),
        const SizedBox(height: 16),
        Text('${sessions.length} PRACTICES',
            style: VisualTheme.micro(10, color: muted)),
        const SizedBox(height: 12),
        if (sessions.isEmpty)
          const Text(
              'No matching practices. Try a different word or category.'),
        for (final session in sessions)
          Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: BayCard(
                  session: session,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => SessionPlayerView(session: session))))),
      ] else ...[
        Text(
            'One skill at a time. Read the setup, breath cue and comfortable alternative.',
            style: VisualTheme.body(14, color: muted)),
        const SizedBox(height: 16),
        if (lessons.isEmpty)
          const Text('No matching lessons. Try a different word.'),
        for (final lesson in lessons)
          Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Material(
                  color: VisualTheme.bayOf(context),
                  borderRadius: BorderRadius.circular(8),
                  child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Icon(Icons.bookmark_outline, color: accent),
                      title: Text(lesson.name),
                      subtitle: Text(lesson.aka),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => PoseView(pose: lesson)))))),
      ],
    ]);
  }
}
