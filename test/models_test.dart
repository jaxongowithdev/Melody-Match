import 'package:flutter_test/flutter_test.dart';
import 'package:user_screen/src/data/engine.dart';
import 'package:user_screen/src/data/library.dart';
import 'package:user_screen/src/models/practice_models.dart';
import 'package:user_screen/src/models/user_preferences.dart';

void main() {
  test('every session id is unique and steps add up', () {
    final ids = PracticeLibrary.sessions.map((s) => s.id).toSet();
    expect(ids.length, PracticeLibrary.sessions.length);
    for (final session in PracticeLibrary.sessions) {
      expect(session.steps, isNotEmpty);
      expect(session.totalSeconds, session.minutes * 60);
    }
  });

  test('journal survives a map round trip', () {
    const entry = JournalEntry(
      id: 2,
      mood: 'fuchsia',
      prompt: 'Where did the breath catch between the columns?',
      body: 'The right hip after the walk.',
      createdAt: '2026-09-24T10:00:00.000',
    );
    final back = JournalEntry.fromMap(entry.toMap());
    expect(back.mood, 'fuchsia');
    expect(back.body, entry.body);
  });

  test('preferences default to a light twelve-minute ease walk', () {
    final prefs = UserPreferences();
    expect(prefs.aspect, 'ease');
    expect(prefs.minutes, 12);
    expect(prefs.theme, 'light');
    expect(prefs.showOnboarding, isTrue);
    expect(UserPreferences.fromMap(prefs.toMap()).grain, 'even');
  });

  test('engine avoids its last recommendation when alternatives exist', () {
    final prefs = UserPreferences(aspect: 'ease', minutes: 8, grain: 'smooth');
    final now = DateTime(2026, 9, 29, 8);
    final first = PracticeEngine.pickWalk(prefs: prefs, recent: [], now: now);
    final second = PracticeEngine.pickWalk(prefs: prefs, now: now, recent: [
      PracticeLog(
          sessionId: first.id,
          title: first.title,
          minutes: first.minutes,
          completedAt: now.toIso8601String()),
    ]);
    expect(second.id, isNot(first.id));
    expect(second.minutes, lessThanOrEqualTo(prefs.minutes));
  });

  test('night hour leans toward rest', () {
    final pick = PracticeEngine.pickWalk(
      prefs: UserPreferences(aspect: 'sleep', minutes: 19, grain: 'smooth'),
      recent: const [],
      now: DateTime(2026, 9, 24, 22, 10),
    );
    expect(pick.kind == 'sleep' || pick.aims.contains('sleep'), isTrue);
  });

  test('hour greeting changes across the day', () {
    expect(
        PracticeEngine.hourGreeting(DateTime(2026, 1, 1, 8)), 'Good morning');
    expect(PracticeEngine.hourGreeting(DateTime(2026, 1, 1, 14)),
        'A little reset');
    expect(PracticeEngine.hourGreeting(DateTime(2026, 1, 1, 19)),
        'Ease into evening');
    expect(PracticeEngine.hourGreeting(DateTime(2026, 1, 1, 23)), 'Good night');
  });
}
