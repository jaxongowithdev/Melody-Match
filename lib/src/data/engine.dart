import '../models/practice_models.dart';
import '../models/user_preferences.dart';
import 'library.dart';

class PracticeEngine {
  static PracticeSession pickWalk({
    required UserPreferences prefs,
    required List<PracticeLog> recent,
    DateTime? now,
  }) {
    final clock = now ?? DateTime.now();
    final hour = clock.hour;
    final used = recent.take(3).map((l) => l.sessionId).toSet();

    var pool = PracticeLibrary.sessions.where((s) {
      final fitsTime = s.minutes <= prefs.minutes;
      final fitsGrain = prefs.grain != 'smooth' || s.level != 'rough';
      return fitsTime && fitsGrain;
    }).toList();
    if (pool.isEmpty) pool = List.of(PracticeLibrary.sessions);

    pool.sort((a, b) =>
        _score(b, prefs, hour, used).compareTo(_score(a, prefs, hour, used)));
    return pool.first;
  }

  static int _score(
      PracticeSession s, UserPreferences prefs, int hour, Set<String> used) {
    var n = 0;
    if (s.aims.contains(prefs.aspect)) n += 5;
    if (s.level == prefs.grain) n += 3;
    if ((s.minutes - prefs.minutes).abs() <= 2) n += 2;
    if (hour < 11 && s.id.contains('morning')) n += 3;
    if (hour >= 20 && (s.kind == 'sleep' || s.aims.contains('sleep'))) n += 4;
    if (hour >= 11 && hour < 17 && s.kind == 'mobility') n += 3;
    if (prefs.aspect == 'sleep' && s.kind == 'sleep') n += 4;
    if (prefs.aspect == 'sit' && (s.kind == 'sit' || s.kind == 'breath')) {
      n += 3;
    }
    if (used.contains(s.id)) n -= 6;
    return n;
  }

  static String hourGreeting(DateTime now) {
    final h = now.hour;
    if (h < 11) return 'Good morning';
    if (h < 17) return 'A little reset';
    if (h < 21) return 'Ease into evening';
    return 'Good night';
  }

  static String lessonOfDay(DateTime now) {
    const lessons = [
      'Start at a point of contact. A foot on the floor is already something to notice.',
      'Try less movement, then pause. Notice whether less tells you more.',
      'Attention wanders. Returning to one sensation is the practice.',
      'Eight minutes can hold a complete lesson. Begin with the time you have.',
      'Notice the difference between describing a sensation and judging it.',
      'Let breathing be ordinary. There is no score for a larger breath.',
      'A field note can be one sentence: what was here, and what you noticed.',
    ];
    return lessons[now.day % lessons.length];
  }
}
