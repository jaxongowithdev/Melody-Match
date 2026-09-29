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
        muted = VisualTheme.mutedOf(context),
        accent = VisualTheme.accentOf(context);
    final pick = _pick;
    return ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          Text('EMBER ATLAS / TODAY’S ROUTE',
              style: VisualTheme.micro(10, color: accent)),
          const SizedBox(height: 16),
          Text('A small path\nback to yourself.',
              style: VisualTheme.display(38, color: ink)),
          const SizedBox(height: 14),
          Text(PracticeEngine.lessonOfDay(DateTime.now()),
              style: VisualTheme.body(15, color: muted)),
          const SizedBox(height: 28),
          _Station(
              number: '01',
              label: 'ARRIVE & PRACTICE',
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_error != null) ...[
                      Text(_error!),
                      TextButton(
                          onPressed: _load, child: const Text('Try again'))
                    ] else if (pick == null)
                      const CircularProgressIndicator()
                    else ...[
                      Text(pick.title,
                          style: VisualTheme.heading(23,
                              color: ink, w: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text(pick.subtitle,
                          style: VisualTheme.body(14, color: muted)),
                      const SizedBox(height: 12),
                      Text('${pick.minutes} MINUTES · FOUR GUIDED STOPS',
                          style: VisualTheme.micro(9, color: accent)),
                      const SizedBox(height: 18),
                      FilledButton.icon(
                          onPressed: _start,
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Walk this session')),
                    ],
                  ])),
          _Station(
              number: '02',
              label: 'FOLLOW THE BREATH',
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Give the moment a rhythm.',
                        style: VisualTheme.heading(20, color: ink)),
                    const SizedBox(height: 10),
                    for (final pattern in PracticeLibrary.patterns)
                      ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(pattern.name),
                          subtitle: Text('${pattern.rounds} rounds'),
                          trailing: Icon(Icons.bar_chart, color: accent),
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) =>
                                      BreathView(pattern: pattern)))),
                  ])),
          _Station(
              number: '03',
              label: 'LEAVE A TRACE',
              last: true,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('What is worth remembering?',
                        style: VisualTheme.heading(20, color: ink)),
                    const SizedBox(height: 8),
                    Text('Keep a few words in your private Tablet.',
                        style: VisualTheme.body(14, color: muted)),
                    if (widget.onTablet != null)
                      TextButton.icon(
                          onPressed: widget.onTablet,
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Write in Tablet')),
                  ])),
          const Divider(height: 36),
          Wrap(spacing: 20, runSpacing: 8, children: [
            Text('$_streak practice days',
                style: VisualTheme.body(13, color: muted)),
            Text('$_week min this week',
                style: VisualTheme.body(13, color: muted)),
          ]),
          if (widget.onRange != null)
            Padding(
                padding: const EdgeInsets.only(top: 16),
                child: OutlinedButton.icon(
                    onPressed: widget.onRange,
                    icon: const Icon(Icons.map_outlined),
                    label: const Text('Choose another route in Range'))),
          const SizedBox(height: 20),
          Text('Private journal — fully offline. No account. No cloud.',
              style: VisualTheme.body(12, color: muted)),
        ]);
  }
}

class _Station extends StatelessWidget {
  final String number, label;
  final Widget child;
  final bool last;
  const _Station(
      {required this.number,
      required this.label,
      required this.child,
      this.last = false});
  @override
  Widget build(BuildContext context) => IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        SizedBox(
            width: 32,
            child: Column(children: [
              Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: VisualTheme.accentOf(context))),
                  child: Text(number,
                      style: VisualTheme.micro(10,
                          color: VisualTheme.accentOf(context)))),
              if (!last)
                Expanded(
                    child: VerticalDivider(
                        width: 1,
                        color: VisualTheme.accentOf(context)
                            .withValues(alpha: .3))),
            ])),
        const SizedBox(width: 16),
        Expanded(
            child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: Text(label,
                              style: VisualTheme.micro(10,
                                  color: VisualTheme.accentOf(context)))),
                      const SizedBox(height: 12),
                      child,
                    ]))),
      ]));
}
