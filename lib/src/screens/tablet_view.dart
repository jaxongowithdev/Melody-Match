import 'package:flutter/material.dart';
import '../data/library.dart';
import '../database/storage_manager.dart';
import '../models/practice_models.dart';
import '../utils/visual_theme.dart';

class TabletView extends StatefulWidget {
  const TabletView({super.key});
  @override
  State<TabletView> createState() => _TabletViewState();
}

class _TabletViewState extends State<TabletView> {
  List<JournalEntry> _rows = [];
  String? _error;
  String _filter = 'all';
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final rows = await StorageManager.instance.allJournal();
      if (mounted) {
        setState(() {
          _rows = rows;
          _error = null;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Could not read your notes. Try again.');
      }
    }
  }

  Future<void> _compose() async {
    final saved = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: VisualTheme.mistOf(context),
        builder: (_) => const _NoteComposer());
    if (!mounted || saved != true) return;
    setState(() => _filter = 'all');
    await _load();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note saved on this device.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ink = VisualTheme.inkOf(context),
        muted = VisualTheme.mutedOf(context);
    final rows =
        _rows.where((r) => _filter == 'all' || r.mood == _filter).toList();
    return ListView(padding: const EdgeInsets.all(20), children: [
      Text('Keep a signal.', style: VisualTheme.display(32, color: ink)),
      const SizedBox(height: 8),
      Text('Private journal — fully offline. No account. No cloud.',
          style: VisualTheme.body(14, color: muted)),
      const SizedBox(height: 22),
      Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
              color: VisualTheme.sky, borderRadius: BorderRadius.circular(28)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${_rows.length} saved moments',
                style: VisualTheme.heading(23,
                    color: VisualTheme.ink, w: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('A detail is enough. No perfect entry required.',
                style: VisualTheme.body(14, color: VisualTheme.ink)),
            const SizedBox(height: 18),
            FilledButton.icon(
                onPressed: _compose,
                icon: const Icon(Icons.add),
                label: const Text('New note')),
          ])),
      const SizedBox(height: 22),
      SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            for (final mood in ['all', ...PracticeLibrary.moods])
              Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                      label: Text(mood == 'all' ? 'All moments' : mood),
                      selected: _filter == mood,
                      onSelected: (_) => setState(() => _filter = mood))),
          ])),
      const SizedBox(height: 18),
      if (_error != null) ...[
        Text(_error!),
        TextButton(onPressed: _load, child: const Text('Try again')),
      ],
      if (rows.isEmpty && _error == null)
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(children: [
              Icon(Icons.bubble_chart_outlined,
                  size: 48, color: VisualTheme.accentOf(context)),
              const SizedBox(height: 12),
              Text(
                  _rows.isEmpty
                      ? 'Your first signal starts here.'
                      : 'No moments with this feeling yet.',
                  style: VisualTheme.body(15, color: muted)),
            ])),
      for (final row in rows)
        Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
                color: VisualTheme.bayOf(context),
                borderRadius: BorderRadius.circular(26)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(Icons.circle,
                    size: 9, color: VisualTheme.accentOf(context)),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(row.mood,
                        style: VisualTheme.heading(13,
                            color: VisualTheme.accentOf(context)))),
                Text(row.createdAt.split('T').first,
                    style: VisualTheme.body(11, color: muted)),
              ]),
              const SizedBox(height: 14),
              Text(row.body, style: VisualTheme.body(16, color: ink)),
              const Divider(height: 30),
              Text(row.prompt, style: VisualTheme.body(12, color: muted)),
            ])),
    ]);
  }
}

class _NoteComposer extends StatefulWidget {
  const _NoteComposer();
  @override
  State<_NoteComposer> createState() => _NoteComposerState();
}

class _NoteComposerState extends State<_NoteComposer> {
  final _controller = TextEditingController();
  int _prompt = 0;
  String _mood = PracticeLibrary.moods.first;
  bool _saving = false;
  String? _error;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (_saving || text.isEmpty) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await StorageManager.instance.insertJournal(JournalEntry(
          mood: _mood,
          prompt: PracticeLibrary.prompts[_prompt],
          body: text,
          createdAt: DateTime.now().toIso8601String()));
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = 'Could not save. Your draft is still here.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context), ink = VisualTheme.inkOf(context);
    return Padding(
        padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
        child: SizedBox(
            height: (media.size.height -
                    media.padding.top -
                    media.viewInsets.bottom) *
                .9,
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 12, 0),
                  child: Row(children: [
                    Expanded(
                        child: Text('Capture a moment',
                            style: VisualTheme.heading(23,
                                color: ink, w: FontWeight.w700))),
                    IconButton(
                        tooltip: 'Close note',
                        onPressed:
                            _saving ? null : () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close)),
                  ])),
              Expanded(
                  child: ListView(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
                      children: [
                    Text(PracticeLibrary.prompts[_prompt],
                        style: VisualTheme.heading(18, color: ink)),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                            onPressed: _saving
                                ? null
                                : () => setState(() => _prompt = (_prompt + 1) %
                                    PracticeLibrary.prompts.length),
                            child: const Text('Another prompt'))),
                    Wrap(spacing: 8, runSpacing: 6, children: [
                      for (final mood in PracticeLibrary.moods)
                        ChoiceChip(
                            label: Text(mood),
                            selected: _mood == mood,
                            onSelected: _saving
                                ? null
                                : (_) => setState(() => _mood = mood)),
                    ]),
                    const SizedBox(height: 18),
                    TextField(
                        controller: _controller,
                        enabled: !_saving,
                        minLines: 4,
                        maxLines: 8,
                        decoration: const InputDecoration(
                            labelText: 'Your note',
                            hintText: 'One thing you noticed…')),
                    if (_error != null)
                      Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(_error!)),
                  ])),
              SafeArea(
                  top: false,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                      child: SizedBox(
                          width: double.infinity,
                          child: ValueListenableBuilder<TextEditingValue>(
                              valueListenable: _controller,
                              builder: (context, value, _) => FilledButton(
                                  onPressed:
                                      _saving || value.text.trim().isEmpty
                                          ? null
                                          : _save,
                                  child: Text(
                                      _saving ? 'Saving…' : 'Save note')))))),
            ])));
  }
}
