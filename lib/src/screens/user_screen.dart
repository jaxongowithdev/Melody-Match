import 'package:flutter/material.dart';
import '../database/storage_manager.dart';
import '../models/user_preferences.dart';
import '../utils/visual_theme.dart';
import '../widgets/stoa_chrome.dart';
import 'dashboard_view.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  UserPreferences? _prefs;
  String? _error;
  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    try {
      final prefs = await StorageManager.instance.getPreferences();
      if (mounted) {
        setState(() {
          _prefs = prefs;
          _error = null;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() =>
            _error = 'Your local notebook could not open. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Soft Margin',
        debugShowCheckedModeBanner: false,
        theme: VisualTheme.lightTheme,
        darkTheme: VisualTheme.darkTheme,
        themeMode: switch (_prefs?.theme) {
          'dark' => ThemeMode.dark,
          'system' => ThemeMode.system,
          _ => ThemeMode.light
        },
        home: _prefs == null
            ? Scaffold(
                body: SafeArea(
                    child: Center(
                        child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const FieldMark(),
                  const SizedBox(height: 24),
                  Text(_error ?? 'Opening a fresh page…',
                      textAlign: TextAlign.center),
                  if (_error != null)
                    TextButton(
                        onPressed: _boot, child: const Text('Try again')),
                ]),
              ))))
            : _prefs!.showOnboarding
                ? WelcomeView(onFinished: _boot)
                : DashboardView(onPrefsChanged: _boot),
      );
}

class WelcomeView extends StatefulWidget {
  final VoidCallback onFinished;
  const WelcomeView({super.key, required this.onFinished});
  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  int _page = 0;
  String _aspect = 'ease', _grain = 'even';
  int _minutes = 12;
  bool _saving = false;
  Future<void> _finish() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final storage = StorageManager.instance;
      final current = await storage.getPreferences();
      await storage.savePreferences(current.copyWith(
          aspect: _aspect,
          minutes: _minutes,
          grain: _grain,
          showOnboarding: false));
      if (mounted) widget.onFinished();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Could not save your choices. Please try again.')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ink = VisualTheme.inkOf(context),
        muted = VisualTheme.mutedOf(context),
        accent = VisualTheme.accentOf(context);
    final titles = [
      'A little space.\nJust for you.',
      'What belongs\non today’s page?',
      'How much time\ncan you keep?',
      'Choose a\ncomfortable pace.'
    ];
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
          child: Row(children: [
            Expanded(
                child: Text('SOFT MARGIN',
                    style: VisualTheme.micro(11, color: accent))),
            Text('0${_page + 1} / 04',
                style: VisualTheme.micro(11, color: muted)),
          ])),
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (var i = 0; i < 4; i++)
              AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _page ? 32 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                      color:
                          i == _page ? accent : accent.withValues(alpha: .18),
                      borderRadius: BorderRadius.circular(8)))
          ])),
      Expanded(
          child: ListView(padding: const EdgeInsets.all(24), children: [
        if (_page == 0)
          Center(
              child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                      color: VisualTheme.bayOf(context),
                      borderRadius: BorderRadius.circular(8)),
                  child: const FieldMark(size: 100))),
        const SizedBox(height: 16),
        Text(titles[_page],
            textAlign: TextAlign.left,
            style: VisualTheme.display(40, color: ink)),
        const SizedBox(height: 20),
        if (_page == 0) ...[
          Text(
              'An offline teacher for movement, attention and rest. Follow a lesson, find an easy breath, and keep a private note.',
              style: VisualTheme.body(17, color: muted)),
          const SizedBox(height: 24),
          const _IntroLine(
              icon: Icons.explore_outlined,
              title: 'Walk',
              detail: 'A guided lesson in four clear steps.'),
          const _IntroLine(
              icon: Icons.air,
              title: 'Four columns',
              detail: 'Follow the rise, the pause and the release.'),
          const _IntroLine(
              icon: Icons.lock_outline,
              title: 'Private by design',
              detail: 'No account. No cloud. No remote AI.'),
        ],
        if (_page == 1) ...[
          Text('Your choice helps select a practice. Change it any time.',
              style: VisualTheme.body(15, color: muted)),
          const SizedBox(height: 20),
          for (final choice in [
            ('ease', 'Settle', 'Begin with support and simple sensations.'),
            (
              'stretch',
              'Open',
              'Make a little room with easy, supported movement.'
            ),
            ('sit', 'Notice', 'Explore what is here without trying to fix it.'),
            ('sleep', 'Rest', 'Leave some of the day unfinished and rest.')
          ])
            _Choice(
                label: choice.$2,
                detail: choice.$3,
                selected: _aspect == choice.$1,
                onTap: () => setState(() => _aspect = choice.$1)),
        ],
        if (_page == 2)
          for (final m in VisualTheme.minuteChoices)
            _Choice(
                label: '$m minutes',
                detail: m == 8
                    ? 'A short page of practice.'
                    : m == 12
                        ? 'Space to learn and settle.'
                        : 'A longer lesson without hurry.',
                selected: _minutes == m,
                onTap: () => setState(() => _minutes = m)),
        if (_page == 3) ...[
          for (final choice in [
            ('smooth', 'Soft', 'Simple, supported lessons.'),
            (
              'even',
              'Steady',
              'A comfortable balance of movement and attention.'
            ),
            ('rough', 'Spacious', 'More time to explore an attention lesson.')
          ])
            _Choice(
                label: choice.$2,
                detail: choice.$3,
                selected: _grain == choice.$1,
                onTap: () => setState(() => _grain = choice.$1)),
          const SizedBox(height: 16),
          Text(
              'Keep movements comfortable. Pause or return to ordinary breathing whenever you need.',
              style: VisualTheme.body(14, color: muted)),
        ],
      ])),
      Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
          child: Row(children: [
            if (_page > 0) ...[
              IconButton(
                  tooltip: 'Previous step',
                  onPressed: _saving ? null : () => setState(() => _page--),
                  icon: const Icon(Icons.arrow_back)),
              const SizedBox(width: 12)
            ],
            Expanded(
                child: FilledButton(
                    onPressed: _saving
                        ? null
                        : () {
                            if (_page < 3) {
                              setState(() => _page++);
                            } else {
                              _finish();
                            }
                          },
                    child: Text(_saving
                        ? 'Saving…'
                        : _page < 3
                            ? 'Continue'
                            : 'Start my Walk'))),
          ])),
    ])));
  }
}

class _IntroLine extends StatelessWidget {
  final IconData icon;
  final String title, detail;
  const _IntroLine(
      {required this.icon, required this.title, required this.detail});
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 21, color: VisualTheme.accentOf(context)),
        const SizedBox(width: 14),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style:
                  VisualTheme.heading(15, color: VisualTheme.inkOf(context))),
          Text(detail,
              style: VisualTheme.body(14, color: VisualTheme.mutedOf(context))),
        ])),
      ]));
}

class _Choice extends StatelessWidget {
  final String label, detail;
  final bool selected;
  final VoidCallback onTap;
  const _Choice(
      {required this.label,
      required this.detail,
      required this.selected,
      required this.onTap});
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
          color: selected
              ? VisualTheme.accentOf(context).withValues(alpha: .12)
              : VisualTheme.bayOf(context),
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: selected
                            ? VisualTheme.accentOf(context)
                            : Colors.transparent)),
                child: Row(children: [
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(label,
                            style: VisualTheme.heading(18,
                                color: VisualTheme.inkOf(context))),
                        const SizedBox(height: 4),
                        Text(detail,
                            style: VisualTheme.body(14,
                                color: VisualTheme.mutedOf(context))),
                      ])),
                  const SizedBox(width: 12),
                  Icon(selected ? Icons.check_circle : Icons.circle_outlined,
                      color: VisualTheme.accentOf(context)),
                ])),
          )));
}
