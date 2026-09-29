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
  final _controller = TextEditingController();
  List<JournalEntry> _rows = [];
  int _prompt = 0;
  String _mood = 'grounded';
  bool _saving = false;
  String? _error;
  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _controller.dispose();
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

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (_saving || text.isEmpty) return;
    setState(() => _saving = true);
    try {
      await StorageManager.instance.insertJournal(JournalEntry(
          mood: _mood,
          prompt: PracticeLibrary.prompts[_prompt],
          body: text,
          createdAt: DateTime.now().toIso8601String()));
      if (!mounted) return;
      _controller.clear();
      FocusScope.of(context).unfocus();
      await _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Note saved on this device.')));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Could not save. Your draft is still here.')));
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
    return ListView(padding: const EdgeInsets.all(24), children: [
      Text('TABLET / PRIVATE FIELD NOTES',
          style: VisualTheme.micro(10, color: accent)),
      const SizedBox(height: 12),
      Text('Keep what\nyou noticed.',
          style: VisualTheme.display(38, color: ink)),
      const SizedBox(height: 12),
      Text('Private journal — fully offline. No account. No cloud.',
          style: VisualTheme.body(14, color: muted)),
      const SizedBox(height: 24),
      Text(PracticeLibrary.prompts[_prompt],
          style: VisualTheme.heading(17, color: ink)),
      Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
              onPressed: _saving
                  ? null
                  : () => setState(() =>
                      _prompt = (_prompt + 1) % PracticeLibrary.prompts.length),
              child: const Text('Another prompt'))),
      Wrap(spacing: 8, runSpacing: 6, children: [
        for (final mood in PracticeLibrary.moods)
          ChoiceChip(
              label: Text(mood),
              selected: _mood == mood,
              onSelected: _saving ? null : (_) => setState(() => _mood = mood))
      ]),
      const SizedBox(height: 16),
      TextField(
          controller: _controller,
          enabled: !_saving,
          minLines: 4,
          maxLines: 8,
          decoration: const InputDecoration(
              labelText: 'Your observation',
              hintText: 'A sensation, a sound, a small discovery…')),
      const SizedBox(height: 12),
      ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (context, value, _) => FilledButton.icon(
              onPressed: _saving || value.text.trim().isEmpty ? null : _save,
              icon: const Icon(Icons.bookmark_add_outlined),
              label: Text(_saving ? 'Saving…' : 'Save note'))),
      const SizedBox(height: 30),
      const Divider(),
      Text('COLLECTED OBSERVATIONS / ${_rows.length}',
          style: VisualTheme.micro(10, color: accent)),
      const SizedBox(height: 12),
      if (_error != null) ...[
        Text(_error!),
        TextButton(onPressed: _load, child: const Text('Try again'))
      ],
      if (_rows.isEmpty && _error == null)
        Text(
            'Your first observation belongs here. A single sentence is enough.',
            style: VisualTheme.body(14, color: muted)),
      for (final row in _rows)
        Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
                color: VisualTheme.bayOf(context),
                border: Border(left: BorderSide(color: accent, width: 2))),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${row.createdAt.split('T').first} / ${row.mood}',
                  style: VisualTheme.micro(10, color: muted)),
              const SizedBox(height: 10),
              Text(row.body, style: VisualTheme.body(16, color: ink)),
            ])),
    ]);
  }
}
