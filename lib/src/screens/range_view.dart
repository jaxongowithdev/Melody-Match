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
        ink = VisualTheme.inkOf(context);
    final sessions = PracticeLibrary.sessions
        .where((s) =>
            (_filter == 'all' ? s.kind != 'sleep' : s.kind == _filter) &&
            '${s.title} ${s.subtitle}'
                .toLowerCase()
                .contains(_query.toLowerCase()))
        .toList();
    final lessons = PracticeLibrary.poses
        .where((p) => '${p.name} ${p.aka} ${p.setup}'
            .toLowerCase()
            .contains(_query.toLowerCase()))
        .toList();
    return ListView(padding: const EdgeInsets.all(20), children: [
      Text('Explore your range.', style: VisualTheme.display(32, color: ink)),
      const SizedBox(height: 8),
      Text('Choose a complete practice or learn one small skill.',
          style: VisualTheme.body(14, color: muted)),
      const SizedBox(height: 20),
      TextField(
          onChanged: (v) => setState(() => _query = v),
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search the collection')),
      const SizedBox(height: 14),
      SegmentedButton<bool>(segments: const [
        ButtonSegment(
            value: false,
            label: Text('Practices'),
            icon: Icon(Icons.play_circle_outline)),
        ButtonSegment(
            value: true,
            label: Text('Short lessons'),
            icon: Icon(Icons.school_outlined)),
      ], selected: {
        _lessons
      }, onSelectionChanged: (s) => setState(() => _lessons = s.first)),
      const SizedBox(height: 16),
      if (!_lessons) ...[
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              for (final f in ['all', 'yoga', 'breath', 'sit', 'mobility'])
                Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                        label: Text(f == 'all'
                            ? 'All'
                            : f == 'sit'
                                ? 'Attention'
                                : f[0].toUpperCase() + f.substring(1)),
                        selected: _filter == f,
                        onSelected: (_) => setState(() => _filter = f))),
            ])),
        const SizedBox(height: 18),
        Text('${sessions.length} PRACTICES',
            style: VisualTheme.micro(10, color: muted)),
        const SizedBox(height: 12),
        if (sessions.isEmpty)
          const Text(
              'No matching practices. Try a different word or category.'),
        LayoutBuilder(builder: (context, constraints) {
          final columns = constraints.maxWidth >= 560 ? 2 : 1;
          final width = (constraints.maxWidth - (columns - 1) * 14) / columns;
          return Wrap(spacing: 14, runSpacing: 14, children: [
            for (final session in sessions)
              SizedBox(
                  width: width,
                  child: BayCard(
                      session: session,
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) =>
                              SessionPlayerView(session: session))))),
          ]);
        }),
      ] else ...[
        Text('Read the setup. Try the cue. Keep the comfortable alternative.',
            style: VisualTheme.body(14, color: muted)),
        const SizedBox(height: 16),
        if (lessons.isEmpty)
          const Text('No matching lessons. Try a different word.'),
        for (var i = 0; i < lessons.length; i++)
          Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Material(
                  color: VisualTheme.bayOf(context),
                  borderRadius: BorderRadius.circular(24),
                  child: ListTile(
                      contentPadding: const EdgeInsets.all(18),
                      leading: CircleAvatar(
                          backgroundColor: VisualTheme.sky,
                          foregroundColor: VisualTheme.ink,
                          child: Text('${i + 1}')),
                      title: Text(lessons[i].name),
                      subtitle: Text(lessons[i].aka),
                      trailing: const Icon(Icons.north_east),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => PoseView(pose: lessons[i])))))),
      ],
    ]);
  }
}
