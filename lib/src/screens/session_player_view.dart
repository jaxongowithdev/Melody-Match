import 'dart:async';

import 'package:flutter/material.dart';
import '../database/storage_manager.dart';
import '../data/library.dart';
import '../models/practice_models.dart';
import '../utils/visual_theme.dart';

class SessionPlayerView extends StatefulWidget {
  final PracticeSession session;
  final bool dim;
  const SessionPlayerView({super.key, required this.session, this.dim = false});

  @override
  State<SessionPlayerView> createState() => _SessionPlayerViewState();
}

class _SessionPlayerViewState extends State<SessionPlayerView> {
  int _step = 0;
  int _left = 0;
  bool _running = false;
  bool _done = false;
  Timer? _timer;
  bool _saving = false;
  int _elapsed = 0;

  PracticeSession get _session => widget.session;
  PracticeStep get _current => _session.steps[_step];

  @override
  void initState() {
    super.initState();
    _left = _current.seconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _tick() {
    _elapsed++;
    if (_left <= 1) {
      if (_step >= _session.steps.length - 1) {
        _timer?.cancel();
        setState(() {
          _running = false;
          _done = true;
          _left = 0;
        });
        return;
      }
      setState(() {
        _step += 1;
        _left = _session.steps[_step].seconds;
      });
      return;
    }
    setState(() => _left -= 1);
  }

  void _toggle() {
    if (_done) return;
    if (_running) {
      _timer?.cancel();
      setState(() => _running = false);
      return;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    setState(() => _running = true);
  }

  Future<void> _log(String mood) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await StorageManager.instance.insertLog(
        PracticeLog(
          sessionId: _session.id,
          title: '${_session.title} · $mood',
          minutes: _elapsed ~/ 60,
          completedAt: DateTime.now().toIso8601String(),
        ),
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Could not save this practice. Please try again.')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _clock(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.dim ? VisualTheme.night : VisualTheme.mistOf(context);
    final ink = widget.dim ? VisualTheme.nightInk : VisualTheme.inkOf(context);
    final muted =
        widget.dim ? VisualTheme.nightMuted : VisualTheme.mutedOf(context);
    final accent =
        widget.dim ? VisualTheme.apricot : VisualTheme.accentOf(context);
    return Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
            backgroundColor: bg,
            foregroundColor: ink,
            title: Text(_session.title)),
        body: SafeArea(
            child: _done
                ? ListView(padding: const EdgeInsets.all(24), children: [
                    Icon(Icons.flag_outlined, size: 56, color: accent),
                    const SizedBox(height: 24),
                    Text('Walk complete.',
                        style: VisualTheme.display(36, color: ink)),
                    const SizedBox(height: 16),
                    Text(
                        'The route ends here. Choose a feeling to keep a local record of your practice.',
                        style: VisualTheme.body(16, color: muted)),
                    const SizedBox(height: 24),
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      for (final mood in PracticeLibrary.moods)
                        FilledButton(
                            onPressed: _saving ? null : () => _log(mood),
                            child: Text(mood)),
                    ]),
                  ])
                : Column(children: [
                    Expanded(
                        child: ListView(
                            padding: const EdgeInsets.all(24),
                            children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('0${_step + 1}',
                                    style:
                                        VisualTheme.display(72, color: accent)),
                                const SizedBox(width: 16),
                                Expanded(
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Text('OF FOUR\nGUIDED STOPS',
                                            style: VisualTheme.micro(10,
                                                color: muted)))),
                              ]),
                          const Divider(height: 30),
                          Text(_current.title,
                              style: VisualTheme.display(32, color: ink)),
                          const SizedBox(height: 20),
                          Text(_current.cue,
                              style: VisualTheme.body(18, color: ink)),
                          const SizedBox(height: 28),
                          Text('YOUR ROUTE',
                              style: VisualTheme.micro(10, color: muted)),
                          const SizedBox(height: 10),
                          for (var i = 0; i < _session.steps.length; i++)
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 7),
                                child: Row(children: [
                                  Icon(
                                      i < _step
                                          ? Icons.check_circle_outline
                                          : i == _step
                                              ? Icons.radio_button_checked
                                              : Icons.radio_button_unchecked,
                                      size: 18,
                                      color: i == _step ? accent : muted),
                                  const SizedBox(width: 12),
                                  Expanded(
                                      child: Text(_session.steps[i].title,
                                          style: VisualTheme.body(13,
                                              color:
                                                  i == _step ? ink : muted))),
                                ])),
                        ])),
                    Container(
                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: muted.withValues(alpha: .2)))),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(children: [
                                Text(_clock(_left),
                                    style: VisualTheme.display(30, color: ink)),
                                const SizedBox(width: 16),
                                Expanded(
                                    child: LinearProgressIndicator(
                                        value: 1 - _left / _current.seconds,
                                        color: accent,
                                        backgroundColor:
                                            accent.withValues(alpha: .12))),
                              ]),
                              const SizedBox(height: 12),
                              FilledButton.icon(
                                  onPressed: _toggle,
                                  icon: Icon(_running
                                      ? Icons.pause
                                      : Icons.play_arrow),
                                  label: Text(_running
                                      ? 'Pause session'
                                      : 'Start session')),
                              TextButton(
                                  onPressed: () {
                                    setState(() => _left = 1);
                                    _tick();
                                    _elapsed--;
                                  },
                                  child: Text(_step == _session.steps.length - 1
                                      ? 'Finish practice'
                                      : 'Next step')),
                            ])),
                  ])));
  }
}
