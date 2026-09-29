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
        setState(() => _error =
            'Your local practice space could not open. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Ember Atlas',
        debugShowCheckedModeBanner: false,
        theme: VisualTheme.lightTheme,
        darkTheme: VisualTheme.darkTheme,
        themeMode: switch (_prefs?.theme ?? 'dark') {
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
                  Text(_error ?? 'Opening your atlas…',
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
      'A practice you\ncan carry within.',
      'Where will\nyou begin?',
      'Make room\nfor a route.',
      'Travel at\nyour own pace.'
    ];
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
          child: Row(children: [
            Expanded(
                child: Text('EMBER ATLAS',
                    style: VisualTheme.micro(12, color: accent))),
            Text('WELCOME / ${_page + 1}',
                style: VisualTheme.micro(10, color: muted)),
          ])),
      Expanded(
          child: ListView(padding: const EdgeInsets.all(24), children: [
        if (_page == 0) ...[
          const Center(child: FieldMark(size: 125)),
          const SizedBox(height: 24),
        ],
        Text(titles[_page], style: VisualTheme.display(38, color: ink)),
        const SizedBox(height: 20),
        if (_page == 0) ...[
          Text(
              'An offline teacher for small movements, steady attention and unhurried rest.',
              style: VisualTheme.body(17, color: muted)),
          const SizedBox(height: 24),
          for (final line in [
            ('01', 'Walk', 'Follow a four-step lesson at your own pace.'),
            ('02', 'Four columns', 'Watch the breath rise, pause and fall.'),
            ('03', 'Tablet', 'Leave a private trace of what you noticed.'),
          ])
            Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(line.$1,
                          style: VisualTheme.micro(12, color: accent)),
                      const SizedBox(width: 18),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(line.$2,
                                style: VisualTheme.heading(17, color: ink)),
                            Text(line.$3,
                                style: VisualTheme.body(14, color: muted)),
                          ])),
                    ])),
          Text(
              'No account. No cloud. No remote AI.\nAll teaching and journal entries stay on your device.',
              style: VisualTheme.body(13, color: muted)),
        ],
        if (_page == 1)
          for (final c in [
            ('ease', 'Arrive', 'Make contact with this moment.'),
            ('stretch', 'Move', 'Try a comfortable supported motion.'),
            ('sit', 'Attend', 'Learn to notice and return.'),
            ('sleep', 'Release', 'Leave the day with less to carry.')
          ])
            _Choice(
                label: c.$2,
                detail: c.$3,
                selected: _aspect == c.$1,
                onTap: () => setState(() => _aspect = c.$1)),
        if (_page == 2)
          for (final m in VisualTheme.minuteChoices)
            _Choice(
                label: '$m minutes',
                detail: m == 8
                    ? 'A short route with a clear beginning.'
                    : m == 12
                        ? 'Four stops with time to explore.'
                        : 'A spacious attention or rest practice.',
                selected: _minutes == m,
                onTap: () => setState(() => _minutes = m)),
        if (_page == 3) ...[
          for (final c in [
            ('smooth', 'Gentle', 'Simple cues with plenty of support.'),
            ('even', 'Measured', 'An easy balance of movement and attention.'),
            ('rough', 'Unhurried', 'Longer pauses for exploration.')
          ])
            _Choice(
                label: c.$2,
                detail: c.$3,
                selected: _grain == c.$1,
                onTap: () => setState(() => _grain = c.$1)),
          Text(
              'Keep movement and breath comfortable. Every route allows you to pause, change position or stop.',
              style: VisualTheme.body(14, color: muted)),
        ],
      ])),
      Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
          child: Row(children: [
            if (_page > 0)
              IconButton(
                  tooltip: 'Previous step',
                  onPressed: _saving ? null : () => setState(() => _page--),
                  icon: const Icon(Icons.arrow_back)),
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
      Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (var i = 0; i < 4; i++)
              Container(
                  width: 32,
                  height: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  color: i <= _page ? accent : accent.withValues(alpha: .2)),
          ])),
    ])));
  }
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
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
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
