import 'package:flutter/material.dart';
import '../data/engine.dart';
import '../data/library.dart';
import '../database/storage_manager.dart';
import '../models/practice_models.dart';
import '../utils/visual_theme.dart';
import 'breath_view.dart';
import 'session_player_view.dart';

class WalkView extends StatefulWidget {
  final VoidCallback? onRange, onTablet;
  const WalkView({super.key, this.onRange, this.onTablet});
  @override
  State<WalkView> createState() => _WalkViewState();
}

class _WalkViewState extends State<WalkView> {
  PracticeSession? _pick;
  int _week = 0, _streak = 0;
  String? _error;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final storage = StorageManager.instance;
      final prefs = await storage.getPreferences();
      final logs = await storage.recentLogs();
      final week = await storage.minutesThisWeek();
      final streak = await storage.streak();
      if (mounted) {
        setState(() {
          _pick = PracticeEngine.pickWalk(prefs: prefs, recent: logs);
          _week = week;
          _streak = streak;
          _error = null;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Could not open your local practice.');
      }
    }
  }

  Future<void> _start() async {
    if (_pick == null) return;
    await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => SessionPlayerView(session: _pick!)));
    if (mounted) _load();
  }

  @override
  Widget build(BuildContext context) {
    final ink = VisualTheme.inkOf(context),
        muted = VisualTheme.mutedOf(context);
    final pick = _pick;
    return ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
        children: [
          Text('Find your rhythm.', style: VisualTheme.display(32, color: ink)),
          const SizedBox(height: 6),
          Text('One practice. A breath. A moment to keep.',
              style: VisualTheme.body(14, color: muted)),
          const SizedBox(height: 20),
          Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  color: VisualTheme.fuchsia,
                  borderRadius: BorderRadius.circular(30)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.play_circle_outline,
                          color: VisualTheme.apricot),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text('YOUR WALK',
                              style:
                                  VisualTheme.micro(11, color: Colors.white))),
                      if (pick != null)
                        Text('${pick.minutes} MIN',
                            style: VisualTheme.micro(11, color: Colors.white)),
                    ]),
                    const SizedBox(height: 20),
                    if (_error != null) ...[
                      Text(_error!,
                          style: const TextStyle(color: Colors.white)),
                      TextButton(
                          onPressed: _load,
                          child: const Text('Try again',
                              style: TextStyle(color: Colors.white))),
                    ] else if (pick == null)
                      const CircularProgressIndicator(color: Colors.white)
                    else ...[
                      Text(pick.title,
                          style: VisualTheme.display(30, color: Colors.white)),
                      const SizedBox(height: 10),
                      Text(pick.subtitle,
                          style: VisualTheme.body(15, color: Colors.white)),
                      const SizedBox(height: 24),
                      SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                  backgroundColor: VisualTheme.apricot,
                                  foregroundColor: VisualTheme.ink),
                              onPressed: _start,
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Walk this session'))),
                    ],
                  ])),
          const SizedBox(height: 14),
          LayoutBuilder(builder: (context, constraints) {
            final tiles = [
              _QuickTile(
                  icon: Icons.equalizer,
                  title: 'Four columns',
                  detail: '4 phases · 4 rounds',
                  tint: VisualTheme.sky,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => BreathView(
                          pattern: PracticeLibrary.patterns.first)))),
              _QuickTile(
                  icon: Icons.add_comment_outlined,
                  title: 'Write in Tablet',
                  detail: 'Keep a private signal',
                  tint: VisualTheme.apricot,
                  onTap: widget.onTablet),
            ];
            if (constraints.maxWidth < 330 ||
                MediaQuery.textScalerOf(context).scale(1) > 1.2) {
              return Column(children: [
                for (final tile in tiles)
                  Padding(
                      padding: const EdgeInsets.only(bottom: 12), child: tile)
              ]);
            }
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: tiles[0]),
              const SizedBox(width: 12),
              Expanded(child: tiles[1]),
            ]);
          }),
          const SizedBox(height: 22),
          Text('Your local rhythm', style: VisualTheme.heading(19, color: ink)),
          const SizedBox(height: 12),
          Wrap(spacing: 12, runSpacing: 12, children: [
            _Metric(value: '$_streak', label: 'practice days'),
            _Metric(value: '$_week', label: 'minutes this week'),
          ]),
          const SizedBox(height: 22),
          Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: VisualTheme.bayOf(context),
                  borderRadius: BorderRadius.circular(24)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TODAY’S SIGNAL',
                        style: VisualTheme.micro(10,
                            color: VisualTheme.accentOf(context))),
                    const SizedBox(height: 8),
                    Text(PracticeEngine.lessonOfDay(DateTime.now()),
                        style: VisualTheme.body(15, color: ink)),
                  ])),
          const SizedBox(height: 18),
          ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: const Text('More breathing rhythms'),
              children: [
                for (final pattern in PracticeLibrary.patterns.skip(1))
                  ListTile(
                      title: Text(pattern.name),
                      subtitle: const Text('No breath holds'),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => BreathView(pattern: pattern)))),
              ]),
          if (widget.onRange != null)
            TextButton(
                onPressed: widget.onRange, child: const Text('Explore Range')),
          const SizedBox(height: 12),
          Text('Private journal — fully offline. No account. No cloud.',
              style: VisualTheme.body(12, color: muted)),
        ]);
  }
}

class _QuickTile extends StatelessWidget {
  final IconData icon;
  final String title, detail;
  final Color tint;
  final VoidCallback? onTap;
  const _QuickTile(
      {required this.icon,
      required this.title,
      required this.detail,
      required this.tint,
      this.onTap});
  @override
  Widget build(BuildContext context) => Material(
      color: tint,
      borderRadius: BorderRadius.circular(26),
      child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: onTap,
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, color: VisualTheme.ink, size: 28),
                    const SizedBox(height: 20),
                    Text(title,
                        style: VisualTheme.heading(18,
                            color: VisualTheme.ink, w: FontWeight.w700)),
                    const SizedBox(height: 5),
                    Text(detail,
                        style: VisualTheme.body(12, color: VisualTheme.ink)),
                  ]))));
}

class _Metric extends StatelessWidget {
  final String value, label;
  const _Metric({required this.value, required this.label});
  @override
  Widget build(BuildContext context) =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        Text(value,
            style:
                VisualTheme.display(30, color: VisualTheme.accentOf(context))),
        const SizedBox(width: 8),
        Text(label,
            style: VisualTheme.body(12, color: VisualTheme.mutedOf(context))),
      ]);
}
