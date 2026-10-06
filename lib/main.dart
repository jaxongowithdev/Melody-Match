import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'src/melody/progress.dart';

part 'src/melody/melody_hub.dart';

void main() => runApp(const UserScreen());

/// App entry point. UserScreen stays in main.dart; feature screens share its theme.
class UserScreen extends StatelessWidget {
  const UserScreen({super.key, this.progress});
  final MelodyProgress? progress;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Melody Match',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Arial',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xff7549bd),
            brightness: Brightness.dark,
          ),
        ),
        home: MelodyHome(progress: progress),
      );
}

class _Instrument {
  const _Instrument(this.name, this.symbol, this.colors);
  final String name;
  final String symbol;
  final List<Color> colors;
}

const _instruments = [
  _Instrument('Violin', '🎻', [Color(0xffff9e87), Color(0xffe65070)]),
  _Instrument('Flute', '🪈', [Color(0xffdc9bfb), Color(0xff9955d4)]),
  _Instrument('Trumpet', '🎺', [Color(0xffffebad), Color(0xffeebc64)]),
  _Instrument('Piano', '🎹', [Color(0xff9bd9f8), Color(0xff5e97dc)]),
  _Instrument('Saxophone', '🎷', [Color(0xffffe5a3), Color(0xffe4a558)]),
  _Instrument('Drum', '🥁', [Color(0xffff9c95), Color(0xffe85c77)]),
  _Instrument('Guitar', '🎸', [Color(0xffade6d7), Color(0xff55bca9)]),
  _Instrument('Banjo', '🪕', [Color(0xffd6a2f7), Color(0xffa466db)]),
];

const _cream = Color(0xffffedc1);
const _gold = Color(0xffffd56b);
const _ink = Color(0xff54271d);

class MelodyMatchScreen extends StatefulWidget {
  const MelodyMatchScreen(
      {super.key,
      required this.progress,
      this.level = 1,
      this.mode = PlayMode.journey});
  final MelodyProgress progress;
  final int level;
  final PlayMode mode;

  @override
  State<MelodyMatchScreen> createState() => _MelodyMatchScreenState();
}

class _MelodyMatchScreenState extends State<MelodyMatchScreen>
    with WidgetsBindingObserver {
  final _random = math.Random();
  List<int> _tiles = [0, 1, 0, 3, 3, 2, 1, 4, 5, 2, 4, 7, 6, 7, 5, 6];
  final Set<int> _matched = {};
  final Set<int> _hinted = {};
  Timer? _timer;
  Timer? _selectionTimer;
  int? _selected;
  late int _seconds;
  int _score = 0;
  MelodyProgress get _progress => widget.progress;
  int get _coins => _progress.coins;
  int get _hints => _progress.boosters['hint']!;
  int get _shuffles => _progress.boosters['shuffle']!;
  int get _freezes =>
      widget.mode == PlayMode.practice ? 0 : _progress.boosters['freeze']!;
  int get _hammers => _progress.boosters['hammer']!;
  int _frozenSeconds = 0;
  late int _level;
  late final String _dailyDate;
  int _reward = 0;
  int _lastInstrument = 0;
  bool get _sound => _progress.sound;
  bool _paused = false;
  bool _background = false;
  bool _mismatch = false;
  String _message = 'Find a pair. Make a little music.';

  bool get _finished => _matched.length == 16;
  bool get _canPlay => !_paused && !_finished && _seconds > 0;
  int get _duration =>
      widget.mode == PlayMode.daily ? 90 : MelodyProgress.timeFor(_level);
  int get _earnedStars => widget.mode != PlayMode.journey
      ? 0
      : _seconds >= 60
          ? 3
          : _seconds >= 25
              ? 2
              : 1;
  String get _nextLabel =>
      widget.mode == PlayMode.journey && _level < MelodyProgress.levelCount
          ? 'NEXT LEVEL'
          : 'BACK HOME';
  void _goHome() => Navigator.of(context).popUntil((route) => route.isFirst);

  void _advance() {
    if (widget.mode == PlayMode.journey && _level < MelodyProgress.levelCount) {
      _restart(nextLevel: true);
    } else {
      _goHome();
    }
  }

  void _arrange() {
    if (widget.mode == PlayMode.daily) {
      final seed = int.parse(_dailyDate.replaceAll('-', ''));
      _tiles = [
        for (var i = 0; i < 8; i++) ...[i, i]
      ]..shuffle(math.Random(seed));
    } else if (_level > 1 || widget.mode == PlayMode.practice) {
      _tiles = [
        for (var i = 0; i < 8; i++) ...[i, i]
      ]..shuffle(_random);
    }
  }

  @override
  void initState() {
    super.initState();
    _level = widget.level.clamp(1, MelodyProgress.levelCount);
    _dailyDate = _progress.today;
    _seconds = _duration;
    _arrange();
    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_canPlay || _background || widget.mode == PlayMode.practice) return;
      setState(() {
        if (_frozenSeconds > 0) {
          _frozenSeconds--;
        } else {
          _seconds--;
          if (_seconds == 0) _message = 'The curtain falls. Try an encore!';
        }
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _background = state != AppLifecycleState.resumed;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _selectionTimer?.cancel();
    super.dispose();
  }

  void _playNote() {
    if (_sound) SystemSound.play(SystemSoundType.click);
  }

  void _select(int index) {
    if (!_canPlay || _matched.contains(index) || _mismatch) return;
    _playNote();
    setState(() {
      _hinted.clear();
      if (_selected == index) {
        _selected = null;
      } else if (_selected == null) {
        _selected = index;
      } else if (_tiles[_selected!] == _tiles[index]) {
        _match(_selected!, index);
      } else {
        _mismatch = true;
        _message = 'Listen closely… choose two of the same.';
        _selectionTimer = Timer(const Duration(milliseconds: 550), () {
          if (!mounted) return;
          setState(() {
            _selected = null;
            _mismatch = false;
          });
        });
      }
    });
  }

  void _match(int first, int second) {
    _lastInstrument = _tiles[first];
    _matched.addAll([first, second]);
    _selected = null;
    _hinted.clear();
    _score += 200;
    _progress.collectPair(_lastInstrument);
    if (_finished) {
      // Time contributes to a personal best; booster use remains a valid win.
      if (widget.mode != PlayMode.practice) _score += _seconds * 10;
      _reward = _progress.complete(
          level: _level,
          score: _score,
          seconds: _seconds,
          mode: widget.mode,
          dailyDate: _dailyDate);
    }
    _message = _finished
        ? 'Bravo! A pitch-perfect performance.'
        : '+200 · A perfect harmony!';
  }

  List<int> _findPair() {
    for (var i = 0; i < _tiles.length; i++) {
      if (_matched.contains(i)) continue;
      for (var j = i + 1; j < _tiles.length; j++) {
        if (!_matched.contains(j) && _tiles[i] == _tiles[j]) return [i, j];
      }
    }
    return [];
  }

  void _hint() {
    if (!_canPlay || _hints == 0 || _mismatch) return;
    setState(() {
      _progress.useBooster('hint');
      _selected = null;
      _hinted.addAll(_findPair());
      _message = 'Follow the glow to find your harmony.';
    });
  }

  void _shuffle() {
    if (!_canPlay || _shuffles == 0 || _mismatch) return;
    setState(() {
      _progress.useBooster('shuffle');
      final remaining = [
        for (var i = 0; i < 16; i++)
          if (!_matched.contains(i)) _tiles[i]
      ]..shuffle(_random);
      var next = 0;
      for (var i = 0; i < 16; i++) {
        if (!_matched.contains(i)) _tiles[i] = remaining[next++];
      }
      _selected = null;
      _hinted.clear();
      _message = 'A fresh arrangement. Let’s play!';
    });
  }

  void _freeze() {
    if (!_canPlay || _freezes == 0) return;
    setState(() {
      _progress.useBooster('freeze');
      _frozenSeconds += 10;
      _message = 'Time is frozen for 10 seconds.';
    });
  }

  void _hammer() {
    if (!_canPlay || _hammers == 0 || _mismatch) return;
    final pair = _findPair();
    if (pair.isEmpty) return;
    setState(() {
      _progress.useBooster('hammer');
      _match(pair[0], pair[1]);
    });
    _playNote();
  }

  void _restart({bool nextLevel = false}) {
    _selectionTimer?.cancel();
    setState(() {
      if (nextLevel) _level++;
      _tiles = [0, 1, 0, 3, 3, 2, 1, 4, 5, 2, 4, 7, 6, 7, 5, 6];
      _arrange();
      _matched.clear();
      _hinted.clear();
      _selected = null;
      _seconds = _duration;
      _score = 0;
      _reward = 0;
      _frozenSeconds = 0;
      _paused = false;
      _mismatch = false;
      _message = 'Find a pair. Make a little music.';
    });
  }

  String _number(int value) => value.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},');

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xff21123e),
        body: Stack(
          children: [
            const Positioned.fill(child: CustomPaint(painter: _StagePainter())),
            SafeArea(
              child: LayoutBuilder(builder: (context, constraints) {
                return Center(
                  child: SizedBox(
                    width: math.min(constraints.maxWidth, 480),
                    height: constraints.maxHeight,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaler: TextScaler.noScaling),
                        child: SizedBox(width: 414, child: _game()),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      );

  Widget _game() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _smallButton(Icons.arrow_back_rounded, 'Back to home', _goHome),
                const Text('✦  THE MUSIC ROOM  ✦',
                    style: TextStyle(
                        color: Color(0xffc5addd),
                        fontSize: 10,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w800)),
                _smallButton(
                    _paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                    _paused ? 'Resume' : 'Pause', () {
                  if (_finished || _seconds == 0) return;
                  setState(() => _paused = !_paused);
                }),
              ],
            ),
            const SizedBox(height: 4),
            const _GameLogo(),
            const SizedBox(height: 14),
            _WoodPanel(
              radius: 19,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(children: [
                  _currency('🪙', _number(_coins)),
                  const Spacer(),
                  _currency('⭐', '${_progress.starCount}'),
                  const Spacer(),
                  _smallButton(
                      Icons.help_outline_rounded, 'How to play', _showHelp),
                ]),
              ),
            ),
            const SizedBox(height: 12),
            _WoodPanel(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(13, 14, 13, 13),
                child: Column(children: [
                  Text(
                      widget.mode == PlayMode.daily
                          ? 'DAILY ENCORE'
                          : widget.mode == PlayMode.practice
                              ? 'FREE PLAY · YOUR OWN TEMPO'
                              : 'LEVEL $_level: ${MelodyProgress.venue(_level).toUpperCase()}',
                      style: _label(14)),
                  const SizedBox(height: 3),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          3,
                          (i) =>
                              Icon(Icons.star_rounded,
                                  size: 31,
                                  color: i <
                                          (_finished
                                              ? _earnedStars
                                              : (_progress.stars['$_level'] ??
                                                  0))
                                      ? _gold
                                      : const Color(0xff81422e),
                                  shadows: const [
                                    Shadow(
                                        color: Color(0xff66301e),
                                        offset: Offset(0, 2),
                                        blurRadius: 2)
                                  ]))),
                  const SizedBox(height: 7),
                  Row(children: [
                    _statusPill(
                        widget.mode == PlayMode.practice
                            ? '∞ FREE PLAY'
                            : '${_frozenSeconds > 0 ? '❄' : '⏱'} ${_seconds ~/ 60}:${(_seconds % 60).toString().padLeft(2, '0')}',
                        width: 92),
                    const SizedBox(width: 8),
                    Expanded(child: _statusPill(_number(_score), big: true)),
                    const SizedBox(width: 8),
                    _statusPill(
                        widget.mode == PlayMode.journey
                            ? 'BEST ${_number(_progress.best['$_level'] ?? 0)}'
                            : '8 PAIRS',
                        width: 103),
                  ]),
                  const SizedBox(height: 12),
                  _board(),
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.music_note_rounded,
                        color: _gold, size: 16),
                    const SizedBox(width: 5),
                    Text('MATCH THE MUSICAL PAIRS',
                        style: _label(11, spacing: 1.3)),
                  ]),
                  const SizedBox(height: 6),
                  Text(_message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: _cream,
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                ]),
              ),
            ),
            const SizedBox(height: 12),
            _collection(),
            const SizedBox(height: 12),
            _WoodPanel(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 12, 15, 12),
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _booster(Icons.shuffle_rounded, 'Shuffle', _shuffles,
                            _shuffle),
                        _booster(
                            Icons.ac_unit_rounded, 'Freeze', _freezes, _freeze),
                        _booster(Icons.lightbulb_rounded, 'Hint', _hints, _hint,
                            yellow: true),
                        _booster(Icons.handyman_rounded, 'Auto match', _hammers,
                            _hammer),
                      ]),
                  const SizedBox(height: 12),
                  Container(height: 1, color: const Color(0xff7e3e29)),
                  const SizedBox(height: 10),
                  Row(children: [
                    _smallButton(
                        _sound
                            ? Icons.volume_up_rounded
                            : Icons.volume_off_rounded,
                        _sound ? 'Mute sound' : 'Enable sound',
                        () => setState(() => _progress.toggleSound(!_sound))),
                    const SizedBox(width: 13),
                    Expanded(
                        child: _greenButton(
                            _finished
                                ? _nextLabel
                                : _seconds == 0
                                    ? 'TRY AGAIN'
                                    : 'HINT',
                            _finished
                                ? _advance
                                : _seconds == 0
                                    ? _restart
                                    : _canPlay && _hints > 0
                                        ? _hint
                                        : null)),
                    const SizedBox(width: 13),
                    _smallButton(
                        Icons.replay_rounded, 'Restart level', _confirmRestart),
                  ]),
                ]),
              ),
            ),
            const SizedBox(height: 10),
            const Text('A LITTLE RHYTHM. A LITTLE MAGIC.',
                style: TextStyle(
                    color: Color(0xffbaa1d0),
                    fontSize: 9,
                    letterSpacing: 2.3,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      );

  Widget _board() => Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xff582b23),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xffe6a362), width: 2),
          boxShadow: const [
            BoxShadow(color: Color(0xff713b26), offset: Offset(0, 3))
          ],
        ),
        child: Stack(children: [
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, mainAxisSpacing: 6, crossAxisSpacing: 6),
            itemCount: 16,
            itemBuilder: (context, index) {
              final instrument = _instruments[_tiles[index]];
              final matched = _matched.contains(index);
              final highlighted = _selected == index || _hinted.contains(index);
              return Semantics(
                button: true,
                label:
                    '${instrument.name} tile ${index + 1}${matched ? ', matched' : ''}',
                selected: highlighted,
                child: Tooltip(
                  message: instrument.name,
                  child: GestureDetector(
                    key: ValueKey('tile-$index'),
                    onTap: () => _select(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: matched
                                ? const [Color(0xff73422e), Color(0xff613422)]
                                : highlighted
                                    ? const [
                                        Color(0xffffef9a),
                                        Color(0xffffc833)
                                      ]
                                    : instrument.colors),
                        border: Border.all(
                            color: highlighted
                                ? const Color(0xfffff5be)
                                : matched
                                    ? const Color(0xff996040)
                                    : const Color(0xffffe1b6),
                            width: highlighted ? 3 : 1.8),
                        boxShadow: highlighted
                            ? const [
                                BoxShadow(
                                    color: Color(0xffffd64b),
                                    blurRadius: 13,
                                    spreadRadius: 2)
                              ]
                            : const [
                                BoxShadow(
                                    color: Color(0xff361c1d),
                                    offset: Offset(0, 3),
                                    blurRadius: 1)
                              ],
                      ),
                      child: Stack(children: [
                        if (!matched)
                          Positioned(
                              left: 5,
                              right: 5,
                              top: 3,
                              child: Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.white.withValues(alpha: .25),
                                            Colors.white.withValues(alpha: 0)
                                          ])))),
                        Center(
                            child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity: matched ? .25 : 1,
                                child: Text(instrument.symbol,
                                    style: const TextStyle(
                                        fontSize: 43, height: 1.1)))),
                        if (matched)
                          const Center(
                              child: Icon(Icons.check_rounded,
                                  color: _gold, size: 31)),
                      ]),
                    ),
                  ),
                ),
              );
            },
          ),
          if (_paused || _finished || _seconds == 0)
            Positioned.fill(
                child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xff241332).withValues(alpha: .91),
                  borderRadius: BorderRadius.circular(9)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                        _finished
                            ? Icons.emoji_events_rounded
                            : _paused
                                ? Icons.pause_circle_outline_rounded
                                : Icons.hourglass_bottom_rounded,
                        color: _gold,
                        size: 58),
                    const SizedBox(height: 14),
                    Text(
                        _finished
                            ? 'BRAVO!'
                            : _paused
                                ? 'INTERMISSION'
                                : 'TIME’S UP',
                        style: _label(23, spacing: 2)),
                    const SizedBox(height: 10),
                    Text(
                        _finished
                            ? '${_number(_score)} points · +$_reward bonus coins'
                            : _paused
                                ? 'Your orchestra is waiting for you.'
                                : 'Every great musician practices.',
                        style: const TextStyle(color: _cream, fontSize: 12)),
                    const SizedBox(height: 20),
                    SizedBox(
                        width: 190,
                        child: _greenButton(
                            _finished
                                ? _nextLabel
                                : _paused
                                    ? 'CONTINUE'
                                    : 'ENCORE', () {
                          if (_paused) {
                            setState(() => _paused = false);
                          } else if (_finished) {
                            _advance();
                          } else {
                            _restart();
                          }
                        })),
                  ]),
            )),
        ]),
      );

  Widget _collection() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
            color: const Color(0xff29193d).withValues(alpha: .9),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: const Color(0xff8762a2), width: 1.3)),
        child: Row(children: [
          Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                  color: const Color(0xff4b2e60),
                  borderRadius: BorderRadius.circular(11)),
              child: Center(
                  child: Text(
                      _matched.isEmpty
                          ? '🎼'
                          : _instruments[_lastInstrument].symbol,
                      style: const TextStyle(fontSize: 28)))),
          const SizedBox(width: 13),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('YOUR ORCHESTRA', style: _label(11, spacing: 1)),
                      Text('${_matched.length ~/ 2}/8 pairs',
                          style: const TextStyle(
                              color: _gold,
                              fontSize: 11,
                              fontWeight: FontWeight.w700)),
                    ]),
                const SizedBox(height: 9),
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                        value: _matched.length / 16,
                        minHeight: 9,
                        color: const Color(0xff64dded),
                        backgroundColor: const Color(0xff140f27))),
              ])),
        ]),
      );

  Widget _currency(String symbol, String value) => Row(children: [
        Text(symbol, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 5),
        Text(value, style: _label(16)),
      ]);

  Widget _statusPill(String text, {double? width, bool big = false}) =>
      Container(
        width: width,
        height: 29,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: const Color(0xff79412d),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xffd3945d))),
        child: Text(text, style: _label(big ? 20 : 12)),
      );

  Widget _booster(IconData icon, String label, int count, VoidCallback onTap,
          {bool yellow = false}) =>
      Tooltip(
        message: label,
        child: Semantics(
          label: '$label, $count remaining',
          button: true,
          child: GestureDetector(
            onTap: _canPlay && count > 0 ? onTap : null,
            child: Opacity(
              opacity: _canPlay && count > 0 ? 1 : .45,
              child: Column(children: [
                SizedBox(
                    width: 59,
                    height: 57,
                    child: Stack(children: [
                      Container(
                          width: 53,
                          height: 53,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xff86eff4),
                                    Color(0xff2595c8),
                                    Color(0xff18639f)
                                  ]),
                              border: Border.all(
                                  color: const Color(0xffe6f8e2), width: 2),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color(0xff62371f),
                                    offset: Offset(0, 3),
                                    blurRadius: 2)
                              ]),
                          child: Icon(icon,
                              color: yellow ? _gold : const Color(0xffe1f9ff),
                              size: 31,
                              shadows: const [
                                Shadow(
                                    color: Color(0xff285777),
                                    offset: Offset(0, 2),
                                    blurRadius: 2)
                              ])),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                              width: 23,
                              height: 23,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xffd54e68),
                                  border: Border.all(
                                      color: const Color(0xffffada9),
                                      width: 1.5)),
                              child: Text('$count', style: _label(12)))),
                    ])),
                const SizedBox(height: 4),
                Text(label.toUpperCase(), style: _label(8, spacing: .6)),
              ]),
            ),
          ),
        ),
      );

  Widget _smallButton(IconData icon, String label, VoidCallback onTap) =>
      IconButton(
        tooltip: label,
        onPressed: onTap,
        icon: Icon(icon, size: 24, color: _cream),
        style: IconButton.styleFrom(
            minimumSize: const Size(36, 36), padding: const EdgeInsets.all(5)),
      );

  Widget _greenButton(String title, VoidCallback? onTap) => Semantics(
        button: true,
        child: Container(
          height: 45,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: const Color(0xff643325), width: 3),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: onTap == null
                      ? const [Color(0xff889776), Color(0xff536546)]
                      : const [
                          Color(0xffccf35a),
                          Color(0xff79c92d),
                          Color(0xff409b23)
                        ]),
              boxShadow: const [
                BoxShadow(color: Color(0xffe9af6d), spreadRadius: 1),
                BoxShadow(
                    color: Color(0xff6b3928),
                    offset: Offset(0, 3),
                    blurRadius: 2)
              ]),
          child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(25),
              child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(25),
                  child: Center(
                      child: Text(title, style: _label(21, spacing: 1))))),
        ),
      );

  Future<void> _showHelp() async {
    final wasPaused = _paused;
    setState(() => _paused = true);
    await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: const Color(0xff382149),
              title: const Text('Welcome to the orchestra!'),
              content: const Text(
                  'Tap two matching instruments to collect a pair and earn 200 points. Find all 8 pairs before the time runs out.\n\n💡 Hint lights up a matching pair.\n❄ Freeze stops the clock for 10 seconds.\n🔀 Shuffle rearranges the remaining tiles.\n🔨 Auto match collects a pair for you.'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('LET’S PLAY',
                        style: TextStyle(color: _gold)))
              ],
            ));
    if (mounted) setState(() => _paused = wasPaused);
  }

  Future<void> _confirmRestart() async {
    final wasPaused = _paused;
    setState(() => _paused = true);
    final restart = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: const Color(0xff382149),
              title: const Text('Start a new arrangement?'),
              content: const Text(
                  'The board and timer will reset. Your earned coins and remaining boosters will be kept. The board score starts over.'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('KEEP PLAYING')),
                TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child:
                        const Text('RESTART', style: TextStyle(color: _gold)))
              ],
            ));
    if (!mounted) return;
    if (restart == true) {
      _restart();
    } else {
      setState(() => _paused = wasPaused);
    }
  }
}

TextStyle _label(double size, {double spacing = 0}) => TextStyle(
      color: _cream,
      fontSize: size,
      fontWeight: FontWeight.w900,
      letterSpacing: spacing,
      shadows: const [
        Shadow(color: _ink, offset: Offset(0, 1.5), blurRadius: 1)
      ],
    );

class _GameLogo extends StatelessWidget {
  const _GameLogo();

  Widget _word(String text, double size, List<Color> colors) => Stack(
        alignment: Alignment.center,
        children: [
          Text(text,
              style: TextStyle(
                  fontSize: size,
                  height: .94,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 10
                    ..color = const Color(0xff53283e),
                  shadows: const [
                    Shadow(
                        color: Color(0xff120f28),
                        offset: Offset(0, 6),
                        blurRadius: 5)
                  ])),
          Text(text,
              style: TextStyle(
                  fontSize: size,
                  height: .94,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 5
                    ..color = const Color(0xffba713c))),
          ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: colors)
                  .createShader(bounds),
              child: Text(text,
                  style: TextStyle(
                      fontSize: size,
                      height: .94,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                      color: Colors.white))),
        ],
      );

  @override
  Widget build(BuildContext context) => Semantics(
        label: 'Melody Match',
        child: ExcludeSemantics(
            child: Column(children: [
          _word('MELODY', 46,
              const [Color(0xfffff5ab), Color(0xffffc64b), Color(0xfff09034)]),
          const SizedBox(height: 5),
          _word('MATCH', 42,
              const [Color(0xffc3ffff), Color(0xff59d8fb), Color(0xff3295e0)]),
        ])),
      );
}

class _WoodPanel extends StatelessWidget {
  const _WoodPanel({required this.child, this.radius = 24});
  final Widget child;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: const Color(0xffe5a65e), width: 2),
          gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xffc5844b),
                Color(0xffa66037),
                Color(0xffb77745),
                Color(0xff934c2f)
              ]),
          boxShadow: const [
            BoxShadow(color: Color(0xff4d2634), offset: Offset(0, 5)),
            BoxShadow(
                color: Color(0x660c071c), offset: Offset(0, 8), blurRadius: 13)
          ],
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(radius - 2),
            child: CustomPaint(painter: _WoodGrainPainter(), child: child)),
      );
}

class _WoodGrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xff652f25).withValues(alpha: .09)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (double y = 8; y < size.height; y += 11) {
      canvas.drawPath(
          Path()
            ..moveTo(0, y)
            ..cubicTo(size.width * .3, y - 5, size.width * .6, y + 7,
                size.width, y - 1),
          paint);
    }
    canvas.drawLine(
        const Offset(12, 3),
        Offset(size.width - 12, 3),
        Paint()
          ..color = const Color(0xffffd292).withValues(alpha: .35)
          ..strokeWidth = 2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StagePainter extends CustomPainter {
  const _StagePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
        rect,
        Paint()
          ..shader = const RadialGradient(
              center: Alignment(0, -.25),
              radius: .9,
              colors: [
                Color(0xff675397),
                Color(0xff382654),
                Color(0xff170e2c)
              ]).createShader(rect));
    final beam = Paint()
      ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xffa0e7ee).withValues(alpha: .18),
            const Color(0xffa0e7ee).withValues(alpha: 0)
          ]).createShader(rect);
    for (final x in [.08, .92]) {
      canvas.drawPath(
          Path()
            ..moveTo(size.width * x, 0)
            ..lineTo(size.width * (x < .5 ? .7 : .3), size.height * .8)
            ..lineTo(size.width * (x < .5 ? .18 : .82), size.height * .8)
            ..close(),
          beam);
    }
    final balcony = Paint()
      ..color = const Color(0xff9666a8).withValues(alpha: .14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13;
    for (final y in [.2, .4, .85]) {
      canvas.drawPath(
          Path()
            ..moveTo(0, size.height * y)
            ..quadraticBezierTo(size.width / 2, size.height * (y + .2),
                size.width, size.height * y),
          balcony);
    }
    final rng = math.Random(12);
    for (var i = 0; i < 48; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      canvas.drawCircle(
          Offset(x, y),
          rng.nextDouble() * 2 + .6,
          Paint()
            ..color = const Color(0xffffdc91)
                .withValues(alpha: rng.nextDouble() * .45 + .1));
    }
    for (var i = 0; i < 12; i++) {
      final text = TextPainter(
          text: TextSpan(
              text: i.isEven ? '♪' : '♫',
              style: TextStyle(
                  fontSize: 23 + (i % 3) * 9,
                  color: [
                    const Color(0xfff4cc72),
                    const Color(0xffa5e7e7),
                    const Color(0xffde97d8)
                  ][i % 3]
                      .withValues(alpha: .4))),
          textDirection: TextDirection.ltr)
        ..layout();
      final x = i.isEven
          ? size.width * .06 + (i % 3) * 12
          : size.width * .86 - (i % 3) * 12;
      text.paint(canvas, Offset(x, size.height * (.1 + i * .074)));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
