import 'package:flutter_test/flutter_test.dart';
import 'package:overview/domain/engines/strength_score.dart';
import 'package:overview/domain/plan_seed.dart';

void main() {
  test('Perzentil trifft die Stützstellen (Mann, Back Squat)', () {
    double p(double r) =>
        StrengthScoreEngine.percentileForRatio(ExerciseKeys.backSquat, r);
    expect(p(0.75), closeTo(5, 1e-9));
    expect(p(1.25), closeTo(20, 1e-9));
    expect(p(1.75), closeTo(50, 1e-9));
    expect(p(2.30), closeTo(80, 1e-9));
    expect(p(2.80), closeTo(95, 1e-9));
  });

  test('Perzentil ist monoton und begrenzt (0..99)', () {
    var prev = -1.0;
    for (var r = 0.0; r <= 6; r += 0.05) {
      final v = StrengthScoreEngine.percentileForRatio(ExerciseKeys.weightedDip, r);
      expect(v, greaterThanOrEqualTo(prev));
      expect(v, inInclusiveRange(0, 99.0));
      prev = v;
    }
  });

  test('Dip: 0 kg Zusatz = 5 %, 0,6x KG = 50 %', () {
    expect(
        StrengthScoreEngine.percentileForRatio(ExerciseKeys.weightedDip, 0),
        0); // ratio 0 -> 0
    expect(
        StrengthScoreEngine.percentileForRatio(ExerciseKeys.weightedDip, 0.6),
        closeTo(50, 1e-9));
  });

  test('Altersfaktor: neutral 23–40, steigend darüber, Jüngere aufgewertet', () {
    expect(StrengthScoreEngine.ageFactor(30), 1.0);
    expect(StrengthScoreEngine.ageFactor(50), closeTo(1.105, 1e-9));
    expect(StrengthScoreEngine.ageFactor(18), closeTo(1.075, 1e-9));
    expect(StrengthScoreEngine.ageFactor(90), StrengthScoreEngine.ageFactor(80));
  });

  test('Frauen: gleiche Leistung ergibt höheres Perzentil', () {
    final m = StrengthScoreEngine.percentileForRatio(ExerciseKeys.backSquat, 1.2);
    final f = StrengthScoreEngine.percentileForRatio(ExerciseKeys.backSquat, 1.2,
        sex: 'female');
    expect(f, greaterThan(m));
  });

  test('compute: Mittel der Übungen, Alter hebt Score an', () {
    final data = {
      ExerciseKeys.backSquat: 140.0, // 1,75 x bei 80 kg -> 50
      ExerciseKeys.weightedDip: 48.0, // 0,6 x -> 50
    };
    final r30 = StrengthScoreEngine.compute(
        e1rmByKey: data, bodyweight: 80, age: 30, sex: 'male')!;
    expect(r30.score, closeTo(50, 1e-9));
    expect(r30.topPercent, 50);
    expect(r30.liftCount, 2);
    expect(r30.provisional, isTrue);

    final r50 = StrengthScoreEngine.compute(
        e1rmByKey: data, bodyweight: 80, age: 50, sex: 'male')!;
    expect(r50.score, greaterThan(r30.score));
  });

  test('compute: ohne Daten oder Körpergewicht = null', () {
    expect(
        StrengthScoreEngine.compute(
            e1rmByKey: {}, bodyweight: 80, age: 30, sex: 'male'),
        isNull);
    expect(
        StrengthScoreEngine.compute(
            e1rmByKey: {ExerciseKeys.backSquat: 100}, bodyweight: 0, age: 30, sex: 'male'),
        isNull);
  });

  test('Vier Übungen = nicht vorläufig', () {
    final r = StrengthScoreEngine.compute(e1rmByKey: {
      ExerciseKeys.backSquat: 120,
      ExerciseKeys.zercherSquat: 100,
      ExerciseKeys.weightedDip: 50,
      ExerciseKeys.weightedPullup: 40,
    }, bodyweight: 80, age: 28, sex: 'male')!;
    expect(r.provisional, isFalse);
  });
}
