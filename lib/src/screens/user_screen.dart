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
        title: 'Tideframe',
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
                  Text(_error ?? 'Setting your rhythm…',
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
        muted = VisualTheme.mutedOf(context);
    final titles = [
      'Make time for\nyour own rhythm.',
      'Choose a direction.',
      'Set your window.',
      'Find your pace.'
    ];
    final subtitles = [
      'Learn, breathe and reflect — entirely on your device.',
      'Your choice shapes the recommended Walk.',
      'Each lesson includes four guided steps.',
      'Comfort matters more than intensity.'
    ];
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
          child: Row(children: [
            const Icon(Icons.waves, color: VisualTheme.fuchsia),
            const SizedBox(width: 10),
            Expanded(
                child: Text('TIDEFRAME',
                    style: VisualTheme.micro(12,
                        color: VisualTheme.accentOf(context)))),
            Text('${_page + 1} of 4',
                style: VisualTheme.body(13, color: muted)),
          ])),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: LinearProgressIndicator(
              value: (_page + 1) / 4,
              minHeight: 5,
              borderRadius: BorderRadius.circular(4))),
      Expanded(
          child: ListView(padding: const EdgeInsets.all(24), children: [
        Text(titles[_page], style: VisualTheme.display(34, color: ink)),
        const SizedBox(height: 12),
        Text(subtitles[_page], style: VisualTheme.body(16, color: muted)),
        const SizedBox(height: 24),
        if (_page == 0) ...[
          Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  color: VisualTheme.fuchsia,
                  borderRadius: BorderRadius.circular(30)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                        child: Icon(Icons.waves,
                            size: 64, color: VisualTheme.apricot)),
                    const SizedBox(height: 20),
                    Text('A teacher.\nNot another feed.',
                        style: VisualTheme.display(27, color: Colors.white)),
                    const SizedBox(height: 12),
                    Text(
                        'Walk through a lesson. Follow Four columns. Explore Range. Keep a note in Tablet.',
                        style: VisualTheme.body(15, color: Colors.white)),
                  ])),
          const SizedBox(height: 18),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.lock_outline, color: VisualTheme.accentOf(context)),
            const SizedBox(width: 10),
            Expanded(
                child: Text(
                    'Private journal — fully offline.\nNo account. No cloud. No remote AI.',
                    style: VisualTheme.body(14, color: muted))),
          ]),
        ],
        if (_page == 1)
          for (final c in [
            ('ease', 'Reset', 'Switch from doing to sensing.'),
            ('stretch', 'Mobilize', 'Explore small, supported movements.'),
            ('sit', 'Focus', 'Learn to return to one ordinary detail.'),
            ('sleep', 'Unwind', 'Put down the task of finishing everything.'),
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
                    ? 'A compact reset.'
                    : m == 12
                        ? 'A steady practice window.'
                        : 'Room for a longer attention lesson.',
                selected: _minutes == m,
                onTap: () => setState(() => _minutes = m)),
        if (_page == 3) ...[
          for (final c in [
            ('smooth', 'Low tide', 'Simple cues and plenty of support.'),
            ('even', 'Mid tide', 'A balanced lesson at an easy pace.'),
            (
              'rough',
              'Wide tide',
              'A longer space for noticing and returning.'
            ),
          ])
            _Choice(
                label: c.$2,
                detail: c.$3,
                selected: _grain == c.$1,
                onTap: () => setState(() => _grain = c.$1)),
          Text(
              'No targets to chase. Keep movements and breathing comfortable. Pause or stop whenever you need.',
              style: VisualTheme.body(14, color: muted)),
        ],
      ])),
      Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Row(children: [
            if (_page > 0) ...[
              IconButton(
                  tooltip: 'Previous step',
                  onPressed: _saving ? null : () => setState(() => _page--),
                  icon: const Icon(Icons.arrow_back)),
              const SizedBox(width: 8),
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
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
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
