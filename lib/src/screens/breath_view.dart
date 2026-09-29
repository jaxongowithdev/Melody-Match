import 'dart:async';

import 'package:flutter/material.dart';
import '../models/practice_models.dart';
import '../utils/visual_theme.dart';
import '../widgets/stoa_chrome.dart';

class BreathView extends StatefulWidget {
  final BreathPattern pattern;
  const BreathView({super.key, required this.pattern});

  @override
  State<BreathView> createState() => _BreathViewState();
}

class _BreathViewState extends State<BreathView> {
  int _phase = 0;
  int _round = 1;
  int _left = 0;
  bool _running = false;
  bool _done = false;
  Timer? _timer;

  BreathPattern get _p => widget.pattern;
  BreathPhase get _current => _p.phases[_phase];

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
    if (_left <= 1) {
      if (_phase >= _p.phases.length - 1) {
        if (_round >= _p.rounds) {
          _timer?.cancel();
          setState(() {
            _running = false;
            _done = true;
            _left = 0;
          });
          return;
        }
        setState(() {
          _round += 1;
          _phase = 0;
          _left = _p.phases[0].seconds;
        });
        return;
      }
      setState(() {
        _phase += 1;
        _left = _p.phases[_phase].seconds;
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

  double get _t {
    final progress = 1 - (_left / _current.seconds);
    return switch (_current.label) {
      'Inhale' => progress,
      'Pause full' => 1,
      'Exhale' => 1 - progress,
      _ => 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    final ink = VisualTheme.inkOf(context);
    final muted = VisualTheme.mutedOf(context);
    return Scaffold(
      appBar: AppBar(title: Text(_p.name)),
      body: SafeArea(
          child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
        children: [
          Text('BREATH STUDIO',
              style:
                  VisualTheme.micro(10, color: VisualTheme.accentOf(context))),
          const SizedBox(height: 16),
          Text(_p.teaching, style: VisualTheme.body(15, color: muted)),
          const SizedBox(height: 30),
          Text(_done ? 'The columns rest.' : _current.label.toUpperCase(),
              textAlign: TextAlign.center,
              style:
                  VisualTheme.micro(14, color: VisualTheme.accentOf(context))),
          const SizedBox(height: 20),
          Center(
              child: ColumnWalk(
                  t: _done ? 0 : _t, color: VisualTheme.accentOf(context))),
          const Divider(),
          const SizedBox(height: 12),
          Text(_done ? 'Done' : '$_left',
              textAlign: TextAlign.center,
              style: VisualTheme.display(54, color: ink)),
          Text('Round $_round / ${_p.rounds}',
              textAlign: TextAlign.center,
              style: VisualTheme.body(14, color: muted)),
          const SizedBox(height: 24),
          FilledButton(
              onPressed: _done ? () => Navigator.of(context).pop() : _toggle,
              child: Text(_done
                  ? 'Back to Walk'
                  : _running
                      ? 'Pause breathing'
                      : 'Start breathing')),
        ],
      )),
    );
  }
}
