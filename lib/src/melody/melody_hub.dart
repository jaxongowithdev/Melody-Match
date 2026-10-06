part of '../../main.dart';

class MelodyHome extends StatefulWidget {
  const MelodyHome({super.key, this.progress});
  final MelodyProgress? progress;
  @override
  State<MelodyHome> createState() => _MelodyHomeState();
}

class _MelodyHomeState extends State<MelodyHome> {
  late final MelodyProgress progress;
  late final Future<void> _loading;
  int tab = 0;
  @override
  void initState() {
    super.initState();
    progress = widget.progress ?? MelodyProgress(store: LocalProgressStore());
    _loading = progress.loaded ? Future.value() : progress.load();
  }

  // The progress object remains alive while pending database writes finish.
  @override
  void dispose() {
    if (widget.progress == null) {
      _loading.then((_) => progress.flush()).then((_) => progress.dispose());
    }
    super.dispose();
  }

  Future<void> _play(int level, {PlayMode mode = PlayMode.journey}) async {
    await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) =>
            MelodyMatchScreen(progress: progress, level: level, mode: mode)));
    if (mounted) setState(() {});
  }

  void _openSettings() => Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => _SettingsScreen(progress: progress)));

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: progress,
        builder: (context, _) {
          if (!progress.loaded) {
            return Scaffold(
                body: Center(
                    child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: progress.error == null
                            ? const CircularProgressIndicator()
                            : Column(mainAxisSize: MainAxisSize.min, children: [
                                Text(progress.error!,
                                    textAlign: TextAlign.center),
                                const SizedBox(height: 16),
                                FilledButton(
                                    onPressed: progress.load,
                                    child: const Text('Retry'))
                              ]))));
          }
          return Scaffold(
            backgroundColor: const Color(0xff21123e),
            body: Stack(children: [
              const Positioned.fill(
                  child: CustomPaint(painter: _StagePainter())),
              SafeArea(
                  child: Center(
                      child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 760),
                          child: Column(children: [
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 12, 0),
                                child: Row(children: [
                                  const Expanded(
                                      child: Text('MELODY MATCH',
                                          style: TextStyle(
                                              color: _gold,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 18,
                                              letterSpacing: 1))),
                                  TextButton.icon(
                                      onPressed: () => setState(() => tab = 4),
                                      icon: const Text('🪙'),
                                      label: Text('${progress.coins}',
                                          style: const TextStyle(
                                              color: _cream,
                                              fontWeight: FontWeight.bold))),
                                  IconButton(
                                      tooltip: 'Settings',
                                      onPressed: _openSettings,
                                      icon: const Icon(Icons.settings_outlined,
                                          color: _cream)),
                                ])),
                            if (progress.error != null)
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: TextButton(
                                      onPressed: progress.retrySave,
                                      child: Text(progress.error!,
                                          style:
                                              const TextStyle(color: _gold)))),
                            Expanded(
                                child: SingleChildScrollView(
                                    key: ValueKey('tab-$tab'),
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 20, 20, 28),
                                    child: switch (tab) {
                                      1 => _journey(),
                                      2 => _collectionPage(),
                                      3 => _quests(),
                                      4 => _shop(),
                                      _ => _home(),
                                    })),
                          ])))),
            ]),
            bottomNavigationBar: NavigationBar(
              backgroundColor: const Color(0xff281737),
              indicatorColor: const Color(0xff654184),
              selectedIndex: tab,
              labelTextStyle: const WidgetStatePropertyAll(
                  TextStyle(fontSize: 10, color: _cream)),
              onDestinationSelected: (index) => setState(() => tab = index),
              destinations: const [
                NavigationDestination(
                    icon: Icon(Icons.home_rounded), label: 'Home'),
                NavigationDestination(
                    icon: Icon(Icons.route_rounded), label: 'Journey'),
                NavigationDestination(
                    icon: Icon(Icons.piano_rounded), label: 'Collection'),
                NavigationDestination(
                    icon: Icon(Icons.emoji_events_rounded), label: 'Quests'),
                NavigationDestination(
                    icon: Icon(Icons.storefront_rounded), label: 'Shop'),
              ],
            ),
          );
        },
      );

  Widget _home() =>
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Center(child: _GameLogo()),
        const SizedBox(height: 16),
        const Text('Your next standing ovation starts here.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xffd3bfdf), fontSize: 13)),
        const SizedBox(height: 26),
        _WoodPanel(
            child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _eyebrow('THE GRAND JOURNEY'),
                      const SizedBox(height: 12),
                      Text(MelodyProgress.venue(progress.unlocked),
                          style: _label(27)),
                      const SizedBox(height: 10),
                      Text(
                          'Level ${progress.unlocked} of 24  ·  ${progress.starCount} stars collected',
                          style: const TextStyle(color: _cream)),
                      const SizedBox(height: 20),
                      _action('PLAY LEVEL ${progress.unlocked}',
                          () => _play(progress.unlocked),
                          icon: Icons.play_arrow_rounded),
                    ]))),
        const SizedBox(height: 16),
        _featureCard(
            'TODAY’S SPOTLIGHT',
            'Daily encore',
            progress.dailyWins.contains(progress.today)
                ? 'Today’s reward collected. Play again for fun.'
                : 'One daily arrangement. A 150-coin first-win bonus.',
            Icons.wb_twilight_rounded,
            const Color(0xff764db1),
            () => Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => _DailyScreen(progress: progress)))),
        const SizedBox(height: 14),
        _featureCard(
            'TAKE YOUR TIME',
            'Free play',
            'No countdown. Just you and a little music.',
            Icons.spa_rounded,
            const Color(0xff246c79),
            () => _play(1, mode: PlayMode.practice)),
        const SizedBox(height: 26),
        _eyebrow('YOUR MUSICAL STORY'),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
              child: _stat('${progress.wins}', 'BOARDS WON',
                  Icons.emoji_events_outlined)),
          const SizedBox(width: 10),
          Expanded(
              child: _stat('${progress.totalPairs}', 'PAIRS FOUND',
                  Icons.music_note_rounded)),
          const SizedBox(width: 10),
          Expanded(
              child: _stat('${progress.collection.length}/8', 'INSTRUMENTS',
                  Icons.piano_rounded)),
        ]),
      ]);

  Widget _journey() =>
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _pageHeading('The grand journey',
            '24 performances. Three beautiful venues. One growing orchestra.'),
        for (var world = 0; world < 3; world++) ...[
          _WoodPanel(
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _eyebrow(
                            'ACT ${world + 1}  ·  ${world == 0 ? 'FIND YOUR RHYTHM' : world == 1 ? 'TAKE THE STAGE' : 'THE GRAND FINALE'}'),
                        const SizedBox(height: 7),
                        Text(MelodyProgress.worlds[world], style: _label(23)),
                        const SizedBox(height: 18),
                        GridView.count(
                            crossAxisCount: 4,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: .7,
                            children: [
                              for (var level = world * 8 + 1;
                                  level <= world * 8 + 8;
                                  level++)
                                _levelTile(level),
                            ]),
                      ]))),
          const SizedBox(height: 20),
        ],
      ]);

  Widget _levelTile(int level) {
    final locked = level > progress.unlocked;
    final stars = progress.stars['$level'] ?? 0;
    return Tooltip(
        message: locked
            ? 'Finish level ${level - 1} to unlock'
            : '${MelodyProgress.timeFor(level)} seconds · Best ${progress.best['$level'] ?? 0}',
        child: Material(
          color: locked
              ? const Color(0xff744a3b)
              : level == progress.unlocked
                  ? const Color(0xffe6b95e)
                  : const Color(0xffa0ce70),
          borderRadius: BorderRadius.circular(15),
          child: InkWell(
              onTap: locked ? null : () => _play(level),
              borderRadius: BorderRadius.circular(15),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (locked)
                      const Icon(Icons.lock_outline_rounded,
                          color: Color(0xffbb937b), size: 25)
                    else
                      Text('$level',
                          style: const TextStyle(
                              color: _ink,
                              fontSize: 25,
                              fontWeight: FontWeight.w900)),
                    const SizedBox(height: 5),
                    FittedBox(
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                                3,
                                (i) => Icon(Icons.star_rounded,
                                    size: 16,
                                    color: i < stars
                                        ? const Color(0xfffff4b8)
                                        : const Color(0xff895d3d))))),
                  ])),
        ));
  }

  Widget _collectionPage() =>
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _pageHeading('Meet your orchestra',
            'Match an instrument to discover it. Every pair adds to your collection.'),
        _surface(
            child: Row(children: [
          const Icon(Icons.auto_awesome, color: _gold, size: 34),
          const SizedBox(width: 16),
          Expanded(
              child: Text(
                  '${progress.collection.length} of 8 instruments discovered',
                  style: _label(18)))
        ])),
        const SizedBox(height: 18),
        LayoutBuilder(builder: (context, box) {
          final columns = box.maxWidth > 600 ? 4 : 2;
          final width = (box.maxWidth - 14 * (columns - 1)) / columns;
          return Wrap(spacing: 14, runSpacing: 14, children: [
            for (var i = 0; i < _instruments.length; i++)
              SizedBox(width: width, child: _instrumentCard(i)),
          ]);
        }),
      ]);

  Widget _instrumentCard(int index) {
    final item = _instruments[index];
    final count = progress.collection['$index'] ?? 0;
    return Material(
        color: const Color(0xff3a2450),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => _InstrumentScreen(index: index, count: count))),
            child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Opacity(
                          opacity: count > 0 ? 1 : .35,
                          child: Text(item.symbol,
                              style: const TextStyle(fontSize: 48))),
                      const SizedBox(height: 10),
                      Text(item.name, style: _label(16)),
                      const SizedBox(height: 5),
                      Text(
                          count > 0
                              ? '$count ${count == 1 ? 'pair' : 'pairs'} collected'
                              : 'Waiting to be discovered',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 11, color: Color(0xffc5addd))),
                    ]))));
  }

  Widget _quests() =>
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _pageHeading('A little more magic',
            'Play, collect and celebrate. Claim each milestone reward once.'),
        for (final mission in MelodyProgress.missions) ...[
          _surface(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(children: [
                  const Icon(Icons.workspace_premium_rounded,
                      color: _gold, size: 32),
                  const SizedBox(width: 12),
                  Expanded(child: Text(mission.$2, style: _label(20))),
                  Text('+${mission.$5} 🪙',
                      style: const TextStyle(
                          color: _gold, fontWeight: FontWeight.bold))
                ]),
                const SizedBox(height: 12),
                Text(mission.$3, style: const TextStyle(color: _cream)),
                const SizedBox(height: 14),
                ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                        value:
                            (progress.missionProgress(mission.$1) / mission.$4)
                                .clamp(0, 1),
                        minHeight: 7,
                        color: const Color(0xff71dedb),
                        backgroundColor: const Color(0xff20132d))),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(
                      child: Text(
                          '${progress.missionProgress(mission.$1).clamp(0, mission.$4)} / ${mission.$4}',
                          style: const TextStyle(color: Color(0xffc5addd)))),
                  TextButton(
                      onPressed: progress.claimed.contains(mission.$1) ||
                              progress.missionProgress(mission.$1) < mission.$4
                          ? null
                          : () {
                              progress.claim(mission.$1);
                            },
                      child: Text(progress.claimed.contains(mission.$1)
                          ? 'CLAIMED ✓'
                          : 'CLAIM REWARD'))
                ]),
              ])),
          const SizedBox(height: 14),
        ],
      ]);

  Widget _shop() =>
      Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _pageHeading('The backstage shop',
            'Spend the coins you earn while playing. No real-money purchases.'),
        _WoodPanel(
            child: Padding(
                padding: const EdgeInsets.all(22),
                child: Row(children: [
                  const Text('🪙', style: TextStyle(fontSize: 40)),
                  const SizedBox(width: 18),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        _eyebrow('YOUR COIN BALANCE'),
                        const SizedBox(height: 5),
                        Text('${progress.coins}', style: _label(32))
                      ]))
                ]))),
        const SizedBox(height: 20),
        for (final item in [
          (
            'hint',
            'A little inspiration',
            'Light up a matching pair.',
            Icons.lightbulb_rounded
          ),
          (
            'shuffle',
            'A fresh arrangement',
            'Rearrange every remaining tile.',
            Icons.shuffle_rounded
          ),
          (
            'freeze',
            'Hold that note',
            'Pause the countdown for 10 seconds.',
            Icons.ac_unit_rounded
          ),
          (
            'hammer',
            'Perfect harmony',
            'Collect a matching pair instantly.',
            Icons.handyman_rounded
          ),
        ]) ...[
          _surface(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                Row(children: [
                  Icon(item.$4, color: const Color(0xff80e8ec), size: 34),
                  const SizedBox(width: 14),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(item.$2, style: _label(18)),
                        const SizedBox(height: 4),
                        Text(item.$3,
                            style: const TextStyle(
                                color: Color(0xffc5addd), fontSize: 12))
                      ]))
                ]),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(
                      child: Text('Owned: ${progress.boosters[item.$1]}',
                          style: const TextStyle(color: _cream))),
                  FilledButton(
                      style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12)),
                      onPressed: progress.coins <
                              MelodyProgress.prices[item.$1]!
                          ? null
                          : () {
                              if (progress.buy(item.$1)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            '${item.$2} added to your boosters.'),
                                        duration: const Duration(seconds: 2)));
                              }
                            },
                      child: Text('BUY · ${MelodyProgress.prices[item.$1]} 🪙'))
                ]),
              ])),
          const SizedBox(height: 14),
        ],
      ]);
}

Widget _eyebrow(String text) => Text(text,
    style: const TextStyle(
        color: _gold,
        fontWeight: FontWeight.w800,
        fontSize: 10,
        letterSpacing: 1.5));
Widget _pageHeading(String title, String subtitle) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: _label(30)),
      const SizedBox(height: 10),
      Text(subtitle,
          style: const TextStyle(color: Color(0xffcfbcdd), height: 1.5))
    ]));
Widget _surface({required Widget child}) => Material(
      color: const Color(0xff382249),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xff674780))),
      child: Padding(padding: const EdgeInsets.all(18), child: child),
    );

Widget _action(String label, VoidCallback? action,
        {IconData icon = Icons.arrow_forward_rounded}) =>
    FilledButton.icon(
        style: FilledButton.styleFrom(
            backgroundColor: const Color(0xffb3dd65),
            foregroundColor: const Color(0xff293e19),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16)),
        onPressed: action,
        icon: Icon(icon),
        label: Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w900, letterSpacing: .5)));
Widget _stat(String value, String label, IconData icon) => Container(
    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 4),
    decoration: BoxDecoration(
        color: const Color(0xff382249),
        borderRadius: BorderRadius.circular(17)),
    child: Column(children: [
      Icon(icon, color: _gold),
      const SizedBox(height: 10),
      Text(value, style: _label(22)),
      const SizedBox(height: 6),
      FittedBox(
          child: Text(label,
              style: const TextStyle(
                  color: Color(0xffbda5d2), fontSize: 8, letterSpacing: .6)))
    ]));
Widget _featureCard(String eyebrow, String title, String subtitle,
        IconData icon, Color color, VoidCallback onTap) =>
    Material(
        color: color,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(22),
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(children: [
                  Icon(icon, color: _gold, size: 38),
                  const SizedBox(width: 17),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        _eyebrow(eyebrow),
                        const SizedBox(height: 8),
                        Text(title, style: _label(23)),
                        const SizedBox(height: 7),
                        Text(subtitle,
                            style: const TextStyle(
                                color: _cream, fontSize: 12, height: 1.4))
                      ])),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right_rounded, color: _cream)
                ]))));

class _DetailPage extends StatelessWidget {
  const _DetailPage({required this.title, required this.child});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: const Color(0xff21123e),
      appBar:
          AppBar(title: Text(title), backgroundColor: const Color(0xff281737)),
      body: Stack(children: [
        const Positioned.fill(child: CustomPaint(painter: _StagePainter())),
        SafeArea(
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child: ListView(
                        padding: const EdgeInsets.all(24), children: [child]))))
      ]));
}

class _DailyScreen extends StatelessWidget {
  const _DailyScreen({required this.progress});
  final MelodyProgress progress;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: progress,
      builder: (context, _) => _DetailPage(
          title: 'Daily encore',
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const SizedBox(height: 15),
            const Icon(Icons.wb_twilight_rounded, color: _gold, size: 100),
            const SizedBox(height: 26),
            _pageHeading('A new day. A new melody.',
                'An arrangement seeded from today’s date. Finish in 90 seconds to collect your daily reward.'),
            _surface(
                child: Column(children: [
              Text(progress.today, style: _label(24)),
              const SizedBox(height: 14),
              Text(
                  progress.dailyWins.contains(progress.today)
                      ? '✓ Reward collected today'
                      : 'First win today: +150 coins',
                  style: const TextStyle(color: _gold)),
              const SizedBox(height: 12),
              const Text('8 pairs · 90 seconds · One bonus per day',
                  textAlign: TextAlign.center, style: TextStyle(color: _cream))
            ])),
            const SizedBox(height: 24),
            _action(
                progress.dailyWins.contains(progress.today)
                    ? 'PLAY AGAIN'
                    : 'PLAY DAILY ENCORE',
                () => Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (_) => MelodyMatchScreen(
                        progress: progress, mode: PlayMode.daily)))),
          ])));
}

const _instrumentNotes = [
  (
    'STRINGS',
    'The violin',
    'Four strings and a bow give the violin its bright, singing voice. In an orchestra, violins often carry the melody.',
    'Look for the curved wooden body and the long bow.'
  ),
  (
    'WOODWINDS',
    'The flute',
    'A flute makes sound when air flows across its mouthpiece. Its clear, light tone can float above a whole orchestra.',
    'Find the long, slender tube with a line of keys.'
  ),
  (
    'BRASS',
    'The trumpet',
    'A player buzzes their lips into the mouthpiece to start the sound. Three valves help shape its bright, bold notes.',
    'Look for the flared bell and three valves.'
  ),
  (
    'KEYBOARDS',
    'The piano',
    'Pressing a piano key makes a small hammer strike a string. A piano can play a melody and its accompanying harmony together.',
    'Find the alternating black and white keys.'
  ),
  (
    'WOODWINDS',
    'The saxophone',
    'Although its body is brass, the saxophone belongs to the woodwind family. A vibrating reed creates its warm, expressive sound.',
    'Look for the curved neck and a bell pointing upward.'
  ),
  (
    'PERCUSSION',
    'The drum',
    'A drum makes sound when its stretched surface vibrates. It can keep a steady pulse or add an exciting rhythmic accent.',
    'Find the round drumhead and the crossed sticks.'
  ),
  (
    'STRINGS',
    'The guitar',
    'Guitar strings can be plucked or strummed. An electric guitar uses pickups to turn string vibrations into an electrical signal.',
    'Look for the long neck and solid, colorful body.'
  ),
  (
    'STRINGS',
    'The banjo',
    'The banjo has strings stretched over a round body with a thin head. That construction gives it a crisp, ringing sound.',
    'Look for a circular body and a long fretted neck.'
  ),
];

class _InstrumentScreen extends StatelessWidget {
  const _InstrumentScreen({required this.index, required this.count});
  final int index;
  final int count;
  @override
  Widget build(BuildContext context) {
    final item = _instruments[index];
    final note = _instrumentNotes[index];
    return _DetailPage(
        title: item.name,
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
              padding: const EdgeInsets.all(38),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: item.colors),
                  borderRadius: BorderRadius.circular(28)),
              child: Center(
                  child: Text(item.symbol,
                      style: const TextStyle(fontSize: 110)))),
          const SizedBox(height: 26),
          _eyebrow(note.$1),
          const SizedBox(height: 10),
          _pageHeading(note.$2, note.$3),
          _surface(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('SPOT IT ON THE BOARD', style: _label(13)),
                const SizedBox(height: 12),
                Text(note.$4,
                    style: const TextStyle(color: _cream, height: 1.5)),
                const SizedBox(height: 20),
                Text(
                    count == 0
                        ? 'Play a matching pair to discover this instrument.'
                        : 'Discovered · $count ${count == 1 ? 'pair' : 'pairs'} collected',
                    style: const TextStyle(color: _gold))
              ])),
        ]));
  }
}

class _SettingsScreen extends StatelessWidget {
  const _SettingsScreen({required this.progress});
  final MelodyProgress progress;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
      listenable: progress,
      builder: (context, _) => _DetailPage(
          title: 'Settings & your progress',
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            _pageHeading(
                'Make yourself at home', 'Your orchestra, at your own pace.'),
            _surface(
                child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Sound effects'),
                    subtitle:
                        const Text('System click feedback while matching'),
                    value: progress.sound,
                    onChanged: progress.toggleSound)),
            const SizedBox(height: 16),
            _surface(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('YOUR PERFORMANCE', style: _label(18)),
                  const SizedBox(height: 18),
                  Text(
                      '${progress.wins} boards completed\n${progress.totalPairs} pairs matched\n${progress.starCount} journey stars\n${progress.dailyWins.length} daily encores completed',
                      style: const TextStyle(color: _cream, height: 2))
                ])),
            const SizedBox(height: 16),
            _surface(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('HOW TO PLAY', style: _label(18)),
                  const SizedBox(height: 12),
                  const Text(
                      'Tap two identical instruments to collect a pair. Find all 8 pairs before time runs out.\n\nJourney stars: finish with 60+ seconds for 3 stars, 25+ seconds for 2, or finish for 1. Every pair earns 10 coins. The first clear of each journey level earns 100 bonus coins.\n\nUse Hint to reveal a pair, Shuffle to rearrange, Freeze to stop time for 10 seconds, or Auto match to collect a pair. Free play has no countdown and Freeze is disabled there.',
                      style: TextStyle(color: _cream, height: 1.6))
                ])),
            const SizedBox(height: 16),
            _surface(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('SAVED ON THIS DEVICE', style: _label(18)),
                  const SizedBox(height: 12),
                  const Text(
                      'Your levels, stars, collection, coins and settings are saved locally. No account, ads or real-money purchases. There is no cloud backup; uninstalling may erase your progress.',
                      style: TextStyle(color: _cream, height: 1.5)),
                  if (progress.error != null)
                    TextButton(
                        onPressed: progress.retrySave,
                        child: const Text('Retry saving'))
                ])),
            const SizedBox(height: 24),
            OutlinedButton.icon(
                onPressed: () async {
                  final reset = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                              title: const Text(
                                  'Reset all Melody Match progress?'),
                              content: const Text(
                                  'This removes your stars, collection, rewards and unlocked levels. Your wallet and boosters return to their starting amounts. This cannot be undone.'),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('CANCEL')),
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('RESET ALL'))
                              ]));
                  if (reset == true) await progress.reset();
                },
                icon: const Icon(Icons.restart_alt),
                label: const Text('Reset progress')),
            const SizedBox(height: 20),
            const Text('MELODY MATCH · 2.0.0\nA little rhythm. A little magic.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xffbda5d2), height: 1.8)),
          ])));
}
