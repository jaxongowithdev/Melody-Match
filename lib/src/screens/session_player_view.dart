import 'dart:async';

import 'package:flutter/material.dart';
import '../database/storage_manager.dart';
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
    final bg = widget.dim ? VisualTheme.ink : VisualTheme.mistOf(context);
    final ink = widget.dim ? VisualTheme.mist : VisualTheme.inkOf(context);
    final muted =
        widget.dim ? const Color(0xFFB4B9BE) : VisualTheme.mutedOf(context);
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: ink,
        title: Text(_session.title.toUpperCase(),
            style: VisualTheme.micro(10, color: VisualTheme.accentOf(context))),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
        child: _done
            ? ListView(
                children: [
                  Text('Walk complete.',
                      style: VisualTheme.display(32, color: ink)),
                  const SizedBox(height: 10),
                  Text('Choose how you feel to save this practice.',
                      style: VisualTheme.body(16, color: muted)),
                  const SizedBox(height: 32),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final m in [
                        'grounded',
                        'clear',
                        'tired',
                        'unchanged'
                      ])
                        FilledButton(
                            onPressed: _saving ? null : () => _log(m),
                            child: Text(m)),
                    ],
                  ),
                ],
              )
            : ListView(
                children: [
                  LinearProgressIndicator(
                    value: (_step + 1) / _session.steps.length,
                    minHeight: 4,
                    backgroundColor: VisualTheme.pewter.withValues(alpha: 0.25),
                    color: VisualTheme.accentOf(context),
                  ),
                  const SizedBox(height: 18),
                  Text('STEP ${_step + 1}  /  ${_session.steps.length}',
                      style: VisualTheme.micro(9,
                          color: VisualTheme.accentOf(context))),
                  const SizedBox(height: 10),
                  Text(_current.title,
                      style: VisualTheme.display(28, color: ink)),
                  const SizedBox(height: 12),
                  Text(_current.cue, style: VisualTheme.body(16, color: muted)),
                  const SizedBox(height: 32),
                  Text(_clock(_left),
                      style: VisualTheme.display(48, color: ink)),
                  const SizedBox(height: 18),
                  FilledButton(
                    onPressed: _toggle,
                    child: Text(_running ? 'Pause session' : 'Start session'),
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() => _left = 1);
                        _tick();
                        _elapsed--;
                      },
                      child: Text(_step == _session.steps.length - 1
                          ? 'Finish practice'
                          : 'Next step')),
                ],
              ),
      ),
    );
  }
}
