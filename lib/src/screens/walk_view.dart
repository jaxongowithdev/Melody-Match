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
        accent = VisualTheme.accentOf(context),
        muted = VisualTheme.mutedOf(context);
    final pick = _pick;
    return ListView(
        padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
        children: [
          Row(children: [
            Expanded(
                child: Text('A PAGE FOR TODAY',
                    style: VisualTheme.micro(10, color: accent))),
            Text(
                '${DateTime.now().day.toString().padLeft(2, '0')} / ${DateTime.now().month.toString().padLeft(2, '0')}',
                style: VisualTheme.micro(10, color: muted)),
          ]),
          const SizedBox(height: 14),
          Text('Leave a little\nspace for yourself.',
              style: VisualTheme.display(36, color: ink)),
          const SizedBox(height: 16),
          Text(PracticeEngine.lessonOfDay(DateTime.now()),
              style: VisualTheme.body(15, color: muted)),
          const SizedBox(height: 18),
          const Divider(),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Wrap(spacing: 20, runSpacing: 6, children: [
                Text('$_streak DAYS OF PRACTICE',
                    style: VisualTheme.micro(10, color: muted)),
                Text('$_week MIN THIS WEEK',
                    style: VisualTheme.micro(10, color: muted)),
              ])),
          const SizedBox(height: 14),
          _Chapter(
              number: '01', title: 'Make space', detail: 'Your guided Walk'),
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
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Walk this session')),
          ],
          const SizedBox(height: 28),
          _Chapter(
              number: '02',
              title: 'Find an easy breath',
              detail: 'Four columns and two gentler rhythms'),
          const SizedBox(height: 12),
          for (final pattern in PracticeLibrary.patterns)
            Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                    color: VisualTheme.bayOf(context),
                    borderRadius: BorderRadius.circular(8),
                    child: ListTile(
                        leading: Icon(Icons.view_week_outlined, color: accent),
                        title: Text(pattern.name),
                        subtitle: Text('${pattern.rounds} rounds · guided'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) =>
                                    BreathView(pattern: pattern)))))),
          const SizedBox(height: 20),
          _Chapter(
              number: '03',
              title: 'Leave a small note',
              detail: 'One sentence is a complete reflection'),
          const SizedBox(height: 12),
          if (widget.onTablet != null)
            OutlinedButton.icon(
                onPressed: widget.onTablet,
                icon: const Icon(Icons.edit_note),
                label: const Text('Write in Tablet')),
          if (widget.onRange != null)
            TextButton(
                onPressed: widget.onRange,
                child: const Text('Browse all lessons in Range')),
          const SizedBox(height: 12),
          Text('Private journal — fully offline. No account. No cloud.',
              textAlign: TextAlign.center,
              style: VisualTheme.body(12, color: muted)),
        ]);
  }
}

class _Chapter extends StatelessWidget {
  final String number, title, detail;
  const _Chapter(
      {required this.number, required this.title, required this.detail});
  @override
  Widget build(BuildContext context) =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: VisualTheme.accentOf(context).withValues(alpha: .1),
                borderRadius: BorderRadius.circular(4)),
            child: Text(number,
                style: VisualTheme.micro(12,
                    color: VisualTheme.accentOf(context)))),
        const SizedBox(width: 12),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style:
                  VisualTheme.heading(18, color: VisualTheme.inkOf(context))),
          const SizedBox(height: 3),
          Text(detail,
              style: VisualTheme.body(12, color: VisualTheme.mutedOf(context))),
        ])),
      ]);
}
