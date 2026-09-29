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
    if (hour < 11 && (s.kind == 'sit' || s.kind == 'breath')) n += 3;
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
      'Try listening to one sound before reaching for the next task.',
      'A smaller movement still gives you something to notice.',
      'Let the count support your breathing, never force it.',
      'You can change position before discomfort becomes a distraction.',
      'An ordinary detail is enough to bring attention back.',
      'A completed practice can feel quiet, lively or unchanged.',
      'Leave one finished thing finished. You do not need to improve it tonight.',
    ];
    return lessons[now.day % lessons.length];
  }
}
