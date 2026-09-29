import 'package:flutter/material.dart';
import '../data/library.dart';
import '../models/practice_models.dart';
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
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final muted = VisualTheme.mutedOf(context);
    final sessions = _filter == 'all'
        ? PracticeLibrary.sessions.where((s) => s.kind != 'sleep').toList()
        : PracticeLibrary.sessions.where((s) => s.kind == _filter).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      children: [
        Text('RANGE / THE FIELD GUIDE',
            style: VisualTheme.micro(10, color: VisualTheme.accentOf(context))),
        const SizedBox(height: 12),
        Text('Learn by noticing.',
            style: VisualTheme.display(36, color: VisualTheme.inkOf(context))),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final f in ['all', 'yoga', 'breath', 'sit', 'mobility'])
              SizedBox(
                width: 92,
                child: GestureDetector(
                  onTap: () => setState(() => _filter = f),
                  child: Container(
                    height: 36,
                    alignment: Alignment.center,
                    color: _filter == f
                        ? VisualTheme.accentOf(context)
                        : VisualTheme.bayOf(context),
                    child: Text(
                      f.toUpperCase(),
                      style: VisualTheme.micro(8,
                          color: _filter == f
                              ? Theme.of(context).colorScheme.onPrimary
                              : VisualTheme.inkOf(context)),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        ...sessions.map(
          (s) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: BayCard(
              session: s,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => SessionPlayerView(session: s))),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text('QUICK FIELD LESSONS',
            style: VisualTheme.micro(9, color: VisualTheme.accentOf(context))),
        const SizedBox(height: 8),
        Text(
            'Study a single skill: setup, breathing and a comfortable alternative.',
            style: VisualTheme.body(14, color: muted)),
        const SizedBox(height: 10),
        ...PracticeLibrary.poses.map((p) => _PoseRow(pose: p)),
      ],
    );
  }
}

class _PoseRow extends StatelessWidget {
  final PoseCard pose;
  const _PoseRow({required this.pose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        tileColor: VisualTheme.bayOf(context),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(2))),
        title: Text(pose.name,
            style: VisualTheme.heading(16, color: VisualTheme.inkOf(context))),
        subtitle: Text(pose.aka,
            style: VisualTheme.body(12, color: VisualTheme.mutedOf(context))),
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => PoseView(pose: pose))),
      ),
    );
  }
}
