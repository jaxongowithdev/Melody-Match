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
    final ink = VisualTheme.inkOf(context),
        muted = VisualTheme.mutedOf(context),
        accent = VisualTheme.accentOf(context);
    return Scaffold(
      appBar: AppBar(title: Text(_p.name)),
      body: SafeArea(
          child: Column(children: [
        Expanded(
            child: ListView(padding: const EdgeInsets.all(24), children: [
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (var i = 0; i < _p.phases.length; i++)
              Chip(
                  backgroundColor: i == _phase && !_done
                      ? accent
                      : VisualTheme.bayOf(context),
                  label: Text(_p.phases[i].label,
                      style: TextStyle(
                          color: i == _phase && !_done
                              ? Theme.of(context).colorScheme.onPrimary
                              : ink))),
          ]),
          const SizedBox(height: 24),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              decoration: BoxDecoration(
                  color: VisualTheme.bayOf(context),
                  borderRadius: BorderRadius.circular(30)),
              child: Column(children: [
                Text(_done ? 'The tide is quiet.' : _current.label,
                    style: VisualTheme.heading(23, color: ink)),
                const SizedBox(height: 24),
                ColumnWalk(t: _done ? 0 : _t, color: accent),
                const SizedBox(height: 22),
                Text(_done ? 'Done' : '$_left',
                    style: VisualTheme.display(48, color: ink)),
                Text('Round $_round / ${_p.rounds}',
                    style: VisualTheme.body(13, color: muted)),
              ])),
          const SizedBox(height: 20),
          Text(_p.teaching, style: VisualTheme.body(14, color: muted)),
        ])),
        Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                    onPressed:
                        _done ? () => Navigator.of(context).pop() : _toggle,
                    icon: Icon(_done
                        ? Icons.check
                        : _running
                            ? Icons.pause
                            : Icons.play_arrow),
                    label: Text(_done
                        ? 'Back to Walk'
                        : _running
                            ? 'Pause breathing'
                            : 'Start breathing')))),
      ])),
    );
  }
}
