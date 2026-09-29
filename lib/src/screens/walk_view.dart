import 'package:flutter/material.dart';
import '../data/engine.dart';
import '../data/library.dart';
import '../database/storage_manager.dart';
import '../models/practice_models.dart';
import '../utils/visual_theme.dart';
import '../widgets/stoa_chrome.dart';
import 'breath_view.dart';
import 'session_player_view.dart';

class WalkView extends StatefulWidget {
  const WalkView({super.key});
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
        accent = VisualTheme.accentOf(context),
        muted = VisualTheme.mutedOf(context);
    final pick = _pick;
    return ListView(
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 28),
        children: [
          Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  color: VisualTheme.fuchsia,
                  borderRadius: BorderRadius.circular(28)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.graphic_eq,
                          color: Colors.white, size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text('YOUR DAILY MIX',
                              style:
                                  VisualTheme.micro(11, color: Colors.white))),
                      const Icon(Icons.circle,
                          color: VisualTheme.apricot, size: 14),
                    ]),
                    const SizedBox(height: 22),
                    Text('Change the pace.\nKeep your centre.',
                        style: VisualTheme.display(33, color: Colors.white)),
                    const SizedBox(height: 14),
                    Text(PracticeEngine.lessonOfDay(DateTime.now()),
                        style: VisualTheme.body(14, color: Colors.white)),
                    const SizedBox(height: 22),
                    Wrap(spacing: 12, runSpacing: 8, children: [
                      _Metric(label: '$_streak practice days'),
                      _Metric(label: '$_week min this week'),
                    ]),
                  ])),
          const SizedBox(height: 26),
          Row(children: [
            Expanded(
                child: Text('Up next',
                    style: VisualTheme.heading(23, color: ink))),
            Text('WALK', style: VisualTheme.micro(10, color: muted)),
          ]),
          const SizedBox(height: 12),
          if (_error != null) ...[
            Text(_error!),
            TextButton(onPressed: _load, child: const Text('Try again'))
          ] else if (pick == null)
            const Center(child: CircularProgressIndicator())
          else ...[
            BayCard(session: pick, onTap: _start),
            const SizedBox(height: 12),
            FilledButton.icon(
                onPressed: _start,
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Walk this session')),
          ],
          const SizedBox(height: 28),
          Text('Breath studio', style: VisualTheme.heading(23, color: ink)),
          const SizedBox(height: 6),
          Text('Choose a rhythm. Follow the rising columns.',
              style: VisualTheme.body(14, color: muted)),
          const SizedBox(height: 12),
          Material(
              color: VisualTheme.bayOf(context),
              borderRadius: BorderRadius.circular(24),
              child: Column(children: [
                for (var i = 0; i < PracticeLibrary.patterns.length; i++) ...[
                  if (i > 0)
                    const Divider(height: 1, indent: 60, endIndent: 20),
                  ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 6),
                      leading: CircleAvatar(
                          backgroundColor: accent.withValues(alpha: .1),
                          foregroundColor: accent,
                          child: Text('0${i + 1}')),
                      title: Text(PracticeLibrary.patterns[i].name),
                      subtitle: Text(
                          '${PracticeLibrary.patterns[i].rounds} rounds · guided rhythm'),
                      trailing: Icon(Icons.play_circle_outline, color: accent),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => BreathView(
                              pattern: PracticeLibrary.patterns[i])))),
                ],
              ])),
          const SizedBox(height: 24),
          Row(children: [
            Icon(Icons.offline_bolt_outlined, size: 18, color: muted),
            const SizedBox(width: 8),
            Expanded(
                child: Text(
                    'Always available. Everything stays on this device.',
                    style: VisualTheme.body(12, color: muted))),
          ]),
        ]);
  }
}

class _Metric extends StatelessWidget {
  final String label;
  const _Metric({required this.label});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .15),
            borderRadius: BorderRadius.circular(20)),
        child: Text(label,
            style: const TextStyle(color: Colors.white, fontSize: 12)),
      );
}
