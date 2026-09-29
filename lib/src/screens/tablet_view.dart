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
  final _search = TextEditingController();
  List<JournalEntry> _rows = [];
  String? _error;
  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
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
    final saved = await Navigator.of(context)
        .push<bool>(MaterialPageRoute(builder: (_) => const NoteComposer()));
    if (!mounted || saved != true) return;
    _search.clear();
    await _load();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note saved on this device.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ink = VisualTheme.inkOf(context),
        muted = VisualTheme.mutedOf(context),
        accent = VisualTheme.accentOf(context);
    final query = _search.text.trim().toLowerCase();
    final rows = _rows
        .where((r) =>
            '${r.body} ${r.prompt} ${r.mood}'.toLowerCase().contains(query))
        .toList();
    return ListView(padding: const EdgeInsets.all(24), children: [
      Text('Traces of practice.', style: VisualTheme.display(36, color: ink)),
      const SizedBox(height: 10),
      Text('Private journal — fully offline. No account. No cloud.',
          style: VisualTheme.body(14, color: muted)),
      const SizedBox(height: 20),
      FilledButton.icon(
          onPressed: _compose,
          icon: const Icon(Icons.edit_outlined),
          label: const Text('New note')),
      const SizedBox(height: 22),
      TextField(
          controller: _search,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search), hintText: 'Search your notes')),
      const SizedBox(height: 20),
      Text('${rows.length} NOTES ON THIS DEVICE',
          style: VisualTheme.micro(10, color: muted)),
      const Divider(height: 28),
      if (_error != null) ...[
        Text(_error!),
        TextButton(onPressed: _load, child: const Text('Try again'))
      ],
      if (rows.isEmpty && _error == null)
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
                _rows.isEmpty
                    ? 'Leave your first trace. One sentence is enough.'
                    : 'No notes match this search.',
                style: VisualTheme.body(16, color: muted))),
      for (final row in rows)
        Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: const EdgeInsets.only(top: 5, right: 16),
                  child: Icon(Icons.diamond_outlined, size: 18, color: accent)),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('${row.createdAt.split('T').first}  /  ${row.mood}',
                        style: VisualTheme.micro(10, color: accent)),
                    const SizedBox(height: 10),
                    Text(row.body, style: VisualTheme.body(17, color: ink)),
                    const SizedBox(height: 8),
                    ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        title: Text('Reflection prompt',
                            style: VisualTheme.body(12, color: muted)),
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Text(row.prompt,
                                      style:
                                          VisualTheme.body(13, color: muted))))
                        ]),
                    const Divider(),
                  ])),
            ])),
    ]);
  }
}

class NoteComposer extends StatefulWidget {
  const NoteComposer({super.key});
  @override
  State<NoteComposer> createState() => _NoteComposerState();
}

class _NoteComposerState extends State<NoteComposer> {
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
    final ink = VisualTheme.inkOf(context),
        muted = VisualTheme.mutedOf(context);
    return Scaffold(
        appBar: AppBar(title: const Text('A new trace')),
        body: SafeArea(
            child: Column(children: [
          Expanded(
              child: ListView(padding: const EdgeInsets.all(24), children: [
            Text('A MOMENT TO REMEMBER',
                style: VisualTheme.micro(10,
                    color: VisualTheme.accentOf(context))),
            const SizedBox(height: 18),
            Text(PracticeLibrary.prompts[_prompt],
                style: VisualTheme.display(28, color: ink)),
            Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                    onPressed: _saving
                        ? null
                        : () => setState(() => _prompt =
                            (_prompt + 1) % PracticeLibrary.prompts.length),
                    child: const Text('Another prompt'))),
            const Divider(height: 28),
            TextField(
                controller: _controller,
                enabled: !_saving,
                minLines: 6,
                maxLines: 12,
                decoration: const InputDecoration(
                    labelText: 'Your note',
                    hintText: 'Begin with one honest detail.')),
            const SizedBox(height: 22),
            Text('HOW DOES THIS MOMENT FEEL?',
                style: VisualTheme.micro(10, color: muted)),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final mood in PracticeLibrary.moods)
                ChoiceChip(
                    label: Text(mood),
                    selected: _mood == mood,
                    onSelected:
                        _saving ? null : (_) => setState(() => _mood = mood)),
            ]),
            if (_error != null)
              Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(_error!)),
          ])),
          Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: SizedBox(
                  width: double.infinity,
                  child: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _controller,
                      builder: (context, value, _) => FilledButton(
                          onPressed: _saving || value.text.trim().isEmpty
                              ? null
                              : _save,
                          child: Text(_saving ? 'Saving…' : 'Save note'))))),
        ])));
  }
}
