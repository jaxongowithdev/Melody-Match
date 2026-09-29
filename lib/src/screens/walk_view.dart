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
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
        children: [
          Text('YOUR DAILY FIELDWORK',
              style: VisualTheme.micro(10, color: accent)),
          const SizedBox(height: 10),
          Text('A small practice.\nA steadier day.',
              style: VisualTheme.display(38, color: ink)),
          const SizedBox(height: 18),
          Row(children: [
            const FieldMark(size: 82),
            const SizedBox(width: 18),
            Expanded(
                child: Text(PracticeEngine.lessonOfDay(DateTime.now()),
                    style: VisualTheme.body(14, color: muted))),
          ]),
          const SizedBox(height: 16),
          const Divider(),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text('$_streak practice days  /  $_week min this week',
                  style: VisualTheme.micro(10, color: muted))),
          if (_error != null) ...[
            Text(_error!),
            TextButton(onPressed: _load, child: const Text('Try again'))
          ] else if (pick == null)
            const Center(child: CircularProgressIndicator())
          else ...[
            Text('01 / WALK', style: VisualTheme.micro(11, color: accent)),
            const SizedBox(height: 10),
            BayCard(session: pick, onTap: _start),
            const SizedBox(height: 12),
            SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                    onPressed: _start,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Walk this session'))),
          ],
          const SizedBox(height: 28),
          Text('02 / BREATHE', style: VisualTheme.micro(11, color: accent)),
          const SizedBox(height: 8),
          Text('Let a rhythm lead.',
              style: VisualTheme.display(27, color: ink)),
          const SizedBox(height: 12),
          for (final p in PracticeLibrary.patterns)
            Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                    color: VisualTheme.bayOf(context),
                    borderRadius: BorderRadius.circular(12),
                    child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        leading: Icon(Icons.air, color: accent),
                        title: Text(p.name),
                        subtitle: Text('${p.rounds} rounds · guided breath'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => BreathView(pattern: p)))))),
          const SizedBox(height: 16),
          Text('All lessons are on your device. No signal needed.',
              style: VisualTheme.body(12, color: muted)),
        ]);
  }
}
