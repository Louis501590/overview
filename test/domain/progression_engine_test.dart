import 'package:flutter_test/flutter_test.dart';
import 'package:overview/domain/engines/progression_engine.dart';
import 'package:overview/domain/models.dart';

SetResult s(int reps, {double w = 20, int? rir}) =>
    SetResult(weight: w, reps: reps, rir: rir);

void main() {
  const engine = ProgressionEngine();

  // Back Squat: 2 Sätze, 4–6, erhöhen bei beiden Sätzen 6.
  const squat = ProgressionRule(
      targetSets: 2, repMin: 4, repMax: 6, requiredReps: 6, requiredSets: 2);
  // Dip Max: 3 Sätze, 3–5, RIR 1–2, erhöhen bei allen 3 Sätzen 5.
  const dipMax = ProgressionRule(
      targetSets: 3,
      repMin: 3,
      repMax: 5,
      requiredReps: 5,
      requiredSets: 3,
      rirMin: 1,
      rirMax: 2);

  test('Squat: beide Sätze 6 -> erhöhen', () {
    final r = engine.evaluate(squat, [s(6), s(6)]);
    expect(r.action, ProgressionAction.increase);
  });

  test('Squat: 6 und 5 -> halten, nennt Satz 2', () {
    final r = engine.evaluate(squat, [s(6), s(5)]);
    expect(r.action, ProgressionAction.hold);
    expect(r.message, contains('Satz 2: 5'));
  });

  test('Dip Max: 5/5/5 mit RIR 1-2 -> erhöhen', () {
    final r = engine.evaluate(
        dipMax, [s(5, rir: 2), s(5, rir: 1), s(5, rir: 1)]);
    expect(r.action, ProgressionAction.increase);
  });

  test('Dip Max: 5/5/4 -> halten', () {
    final r = engine.evaluate(dipMax, [s(5), s(5), s(4)]);
    expect(r.action, ProgressionAction.hold);
  });

  test('Dip Max: 5/5/5 aber RIR 0 -> halten', () {
    final r = engine.evaluate(dipMax, [s(5, rir: 1), s(5, rir: 1), s(5, rir: 0)]);
    expect(r.action, ProgressionAction.hold);
    expect(r.message, contains('0 RIR'));
  });

  test('Zu wenige Sätze erfasst -> nicht erhöhen', () {
    final r = engine.evaluate(dipMax, [s(5), s(5)]);
    expect(r.action, ProgressionAction.hold);
  });

  test('Keine Sätze -> halten', () {
    expect(engine.evaluate(squat, []).action, ProgressionAction.hold);
  });

  test('Deload nach 3 gescheiterten Einheiten in Folge', () {
    final r = engine.evaluate(squat, [s(3), s(3)], previousFailureStreak: 2);
    expect(r.action, ProgressionAction.deload);
  });

  test('Nur 2. Fehlschlag -> noch halten', () {
    final r = engine.evaluate(squat, [s(3), s(4)], previousFailureStreak: 1);
    expect(r.action, ProgressionAction.hold);
  });

  test('isFailure: unter Minimum', () {
    expect(ProgressionEngine.isFailure(squat, [s(6), s(3)]), isTrue);
    expect(ProgressionEngine.isFailure(squat, [s(4), s(5)]), isFalse);
  });

  test('deloadWeight rundet auf 0,25 kg', () {
    expect(ProgressionEngine.deloadWeight(100), 90);
    expect(ProgressionEngine.deloadWeight(37.5), 33.75);
  });
}
