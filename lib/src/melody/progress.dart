import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

abstract class ProgressStore {
  Future<Map<String, dynamic>?> read();
  Future<void> write(Map<String, dynamic> data);
}

class MemoryProgressStore implements ProgressStore {
  Map<String, dynamic>? data;
  @override
  Future<Map<String, dynamic>?> read() async => data;
  @override
  Future<void> write(Map<String, dynamic> value) async {
    data = jsonDecode(jsonEncode(value)) as Map<String, dynamic>;
  }
}

class LocalProgressStore implements ProgressStore {
  LocalProgressStore({this.filename = 'melody_match_v1.db'});
  final String filename;
  Database? _db;
  Future<Database> get database async => _db ??= await openDatabase(
        p.join(await getDatabasesPath(), filename),
        version: 1,
        onCreate: (db, _) => db.execute(
            'CREATE TABLE progress (id INTEGER PRIMARY KEY, value TEXT NOT NULL)'),
      );
  @override
  Future<Map<String, dynamic>?> read() async {
    final rows = await (await database).query('progress', where: 'id = 1');
    return rows.isEmpty
        ? null
        : jsonDecode(rows.first['value'] as String) as Map<String, dynamic>;
  }

  @override
  Future<void> write(Map<String, dynamic> data) async {
    await (await database).insert(
        'progress', {'id': 1, 'value': jsonEncode(data)},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}

enum PlayMode { journey, daily, practice }

class MelodyProgress extends ChangeNotifier {
  MelodyProgress({ProgressStore? store, DateTime Function()? now})
      : _store = store ?? MemoryProgressStore(),
        _now = now ?? DateTime.now;
  final ProgressStore _store;
  final DateTime Function() _now;
  bool loaded = false;
  String? error;
  int coins = 250;
  int unlocked = 1;
  int totalPairs = 0;
  int wins = 0;
  bool sound = true;
  Map<String, int> boosters = {
    'hint': 5,
    'shuffle': 3,
    'freeze': 2,
    'hammer': 1
  };
  Map<String, int> stars = {};
  Map<String, int> best = {};
  Map<String, int> collection = {};
  Set<String> claimed = {};
  Set<String> dailyWins = {};
  Future<void> _pending = Future.value();
  String get today {
    final date = _now();
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  int get starCount => stars.values.fold(0, (a, b) => a + b);
  static const levelCount = 24;
  static const worlds = [
    'The Practice Room',
    'Moonlight Theater',
    'Orchestra Hall'
  ];
  static String venue(int level) => worlds[((level - 1) ~/ 8).clamp(0, 2)];
  static int timeFor(int level) => 125 - level * 2;

  Future<void> load() async {
    try {
      final data = await _store.read();
      if (data != null) {
        coins = data['coins'] as int? ?? 250;
        unlocked = (data['unlocked'] as int? ?? 1).clamp(1, levelCount);
        totalPairs = data['totalPairs'] as int? ?? 0;
        wins = data['wins'] as int? ?? 0;
        sound = data['sound'] as bool? ?? true;
        boosters = {...boosters, ..._ints(data['boosters'])};
        stars = _ints(data['stars']);
        best = _ints(data['best']);
        collection = _ints(data['collection']);
        claimed = Set<String>.from(data['claimed'] as List? ?? []);
        dailyWins = Set<String>.from(data['dailyWins'] as List? ?? []);
      }
      loaded = true;
      error = null;
    } catch (_) {
      error = 'Your saved progress could not be opened. Please try again.';
    }
    notifyListeners();
  }

  Map<String, int> _ints(dynamic value) => value is Map
      ? value.map((key, value) => MapEntry(key.toString(), value as int))
      : {};
  Map<String, dynamic> toJson() => {
        'coins': coins,
        'unlocked': unlocked,
        'totalPairs': totalPairs,
        'wins': wins,
        'sound': sound,
        'boosters': boosters,
        'stars': stars,
        'best': best,
        'collection': collection,
        'claimed': claimed.toList(),
        'dailyWins': dailyWins.toList(),
      };
  void _changed() {
    notifyListeners();
    final snapshot = jsonDecode(jsonEncode(toJson())) as Map<String, dynamic>;
    _pending = _pending.then((_) async {
      try {
        await _store.write(snapshot);
        if (error != null) {
          error = null;
          notifyListeners();
        }
      } catch (_) {
        error = 'Progress is in memory. Saving failed; tap Retry in Settings.';
        notifyListeners();
      }
    });
  }

  Future<void> flush() => _pending;
  void retrySave() => _changed();
  void toggleSound(bool value) {
    sound = value;
    _changed();
  }

  bool useBooster(String type) {
    if ((boosters[type] ?? 0) <= 0) return false;
    boosters[type] = boosters[type]! - 1;
    _changed();
    return true;
  }

  static const prices = {
    'hint': 75,
    'shuffle': 60,
    'freeze': 80,
    'hammer': 120
  };
  bool buy(String type) {
    final price = prices[type];
    if (price == null || coins < price) return false;
    coins -= price;
    boosters[type] = (boosters[type] ?? 0) + 1;
    _changed();
    return true;
  }

  void collectPair(int instrument) {
    totalPairs++;
    collection['$instrument'] = (collection['$instrument'] ?? 0) + 1;
    coins += 10;
    _changed();
  }

  int complete(
      {required int level,
      required int score,
      required int seconds,
      required PlayMode mode,
      String? dailyDate}) {
    wins++;
    var reward = 0;
    if (mode == PlayMode.journey) {
      final earned = seconds >= 60
          ? 3
          : seconds >= 25
              ? 2
              : 1;
      if ((stars['$level'] ?? 0) == 0) reward = 100;
      if (earned > (stars['$level'] ?? 0)) stars['$level'] = earned;
      if (score > (best['$level'] ?? 0)) best['$level'] = score;
      if (level >= unlocked && level < levelCount) unlocked = level + 1;
    } else if (mode == PlayMode.daily && dailyWins.add(dailyDate ?? today)) {
      reward = 150;
    }
    coins += reward;
    _changed();
    return reward;
  }

  static const missions = [
    ('first', 'First applause', 'Finish your first board', 1, 100),
    ('pairs', 'Finding harmony', 'Collect 40 instrument pairs', 40, 150),
    ('collector', 'Full ensemble', 'Discover all 8 instruments', 8, 200),
    ('stars', 'Rising star', 'Earn 12 journey stars', 12, 250),
    ('daily', 'A daily rhythm', 'Complete 3 daily challenges', 3, 300),
  ];
  int missionProgress(String id) => switch (id) {
        'first' => wins,
        'pairs' => totalPairs,
        'collector' => collection.length,
        'stars' => starCount,
        'daily' => dailyWins.length,
        _ => 0,
      };
  bool claim(String id) {
    final matches = missions.where((m) => m.$1 == id);
    if (matches.isEmpty) return false;
    final mission = matches.first;
    if (claimed.contains(id) || missionProgress(id) < mission.$4) return false;
    claimed.add(id);
    coins += mission.$5;
    _changed();
    return true;
  }

  Future<void> reset() async {
    coins = 250;
    unlocked = 1;
    totalPairs = 0;
    wins = 0;
    sound = true;
    boosters = {'hint': 5, 'shuffle': 3, 'freeze': 2, 'hammer': 1};
    stars.clear();
    best.clear();
    collection.clear();
    claimed.clear();
    dailyWins.clear();
    _changed();
    await flush();
  }
}
