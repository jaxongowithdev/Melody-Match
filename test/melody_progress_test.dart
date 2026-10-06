import 'package:flutter_test/flutter_test.dart';
import 'package:user_screen/src/melody/progress.dart';

class FailingStore extends MemoryProgressStore {
  bool fail = true;
  @override
  Future<void> write(Map<String, dynamic> value) async {
    if (fail) throw StateError('Disk unavailable');
    await super.write(value);
  }
}

void main() {
  test('wallet, collection, unlocks and settings survive reloading', () async {
    final store = MemoryProgressStore();
    final progress = MelodyProgress(store: store);
    await progress.load();
    progress.collectPair(0);
    expect(progress.buy('hint'), isTrue);
    progress.useBooster('hint');
    progress.toggleSound(false);
    progress.complete(
        level: 1, score: 2400, seconds: 80, mode: PlayMode.journey);
    await progress.flush();
    final restored = MelodyProgress(store: store);
    await restored.load();
    expect(restored.coins, 285);
    expect(restored.boosters['hint'], 5);
    expect(restored.collection['0'], 1);
    expect(restored.stars['1'], 3);
    expect(restored.best['1'], 2400);
    expect(restored.unlocked, 2);
    expect(restored.sound, isFalse);
  });

  test(
      'journey replay improves stars but does not duplicate first-clear reward',
      () {
    final p = MelodyProgress();
    expect(
        p.complete(level: 1, score: 1700, seconds: 10, mode: PlayMode.journey),
        100);
    expect(
        p.complete(level: 1, score: 2400, seconds: 80, mode: PlayMode.journey),
        0);
    expect(p.stars['1'], 3);
    expect(p.best['1'], 2400);
    p.complete(level: 1, score: 1900, seconds: 30, mode: PlayMode.journey);
    expect(p.stars['1'], 3);
    expect(p.best['1'], 2400);
    expect(p.coins, 350);
  });

  test(
      'daily bonus is once per captured play date and practice does not unlock',
      () {
    var now = DateTime(2026, 10, 6);
    final p = MelodyProgress(now: () => now);
    final started = p.today;
    now = DateTime(2026, 10, 7);
    expect(
        p.complete(
            level: 1,
            score: 1800,
            seconds: 20,
            mode: PlayMode.daily,
            dailyDate: started),
        150);
    expect(
        p.complete(
            level: 1,
            score: 1800,
            seconds: 20,
            mode: PlayMode.daily,
            dailyDate: started),
        0);
    expect(p.complete(level: 1, score: 1800, seconds: 20, mode: PlayMode.daily),
        150);
    p.complete(level: 1, score: 1600, seconds: 100, mode: PlayMode.practice);
    expect(p.unlocked, 1);
    expect(p.stars, isEmpty);
  });

  test('purchases cannot overdraw and milestone rewards cannot repeat', () {
    final p = MelodyProgress();
    expect(p.claim('first'), isFalse);
    expect(p.buy('hammer'), isTrue);
    expect(p.buy('hammer'), isTrue);
    expect(p.buy('hammer'), isFalse);
    expect(p.coins, 10);
    p.complete(level: 1, score: 1600, seconds: 10, mode: PlayMode.practice);
    expect(p.claim('first'), isTrue);
    expect(p.claim('first'), isFalse);
    expect(p.coins, 110);
    for (var i = 0; i < 5; i++) {
      expect(p.useBooster('hint'), isTrue);
    }
    expect(p.useBooster('hint'), isFalse);
  });

  test('save failure is surfaced and retry preserves progress', () async {
    final store = FailingStore();
    final p = MelodyProgress(store: store);
    await p.load();
    p.collectPair(3);
    await p.flush();
    expect(p.error, isNotNull);
    store.fail = false;
    p.retrySave();
    await p.flush();
    expect(p.error, isNull);
    final restored = MelodyProgress(store: store);
    await restored.load();
    expect(restored.collection['3'], 1);
  });

  test('reset is persisted with starting balance', () async {
    final store = MemoryProgressStore();
    final p = MelodyProgress(store: store);
    p.collectPair(1);
    p.complete(level: 24, score: 1800, seconds: 20, mode: PlayMode.journey);
    expect(p.unlocked, 1); // Last level cannot create a level 25.
    await p.reset();
    final restored = MelodyProgress(store: store);
    await restored.load();
    expect(restored.coins, 250);
    expect(restored.collection, isEmpty);
    expect(restored.unlocked, 1);
  });
}
