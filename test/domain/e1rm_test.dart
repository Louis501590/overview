import 'package:flutter_test/flutter_test.dart';
import 'package:overview/domain/engines/e1rm.dart';
import 'package:overview/domain/models.dart';

void main() {
  test('Epley: 100 kg x 5 = 116,7', () {
    expect(E1rmCalculator.epley(100, 5), closeTo(116.67, 0.01));
  });

  test('Epley: 1 Wdh. = Gewicht, 0 Wdh./0 kg = 0', () {
    expect(E1rmCalculator.epley(140, 1), 140);
    expect(E1rmCalculator.epley(100, 0), 0);
    expect(E1rmCalculator.epley(0, 5), 0);
  });

  test('best nimmt besten Satz und ignoriert > 12 Wdh.', () {
    final sets = [
      const SetResult(weight: 100, reps: 5), // 116,67
      const SetResult(weight: 110, reps: 3), // 121
      const SetResult(weight: 50, reps: 30), // ignoriert
    ];
    expect(E1rmCalculator.best(sets), closeTo(121, 0.01));
  });

  test('weightForReps ist Umkehrung von Epley', () {
    final e = E1rmCalculator.epley(100, 3);
    expect(E1rmCalculator.weightForReps(e, 3), closeTo(100, 1e-9));
    expect(E1rmCalculator.weightForReps(150, 1), 150);
  });

  test('Volumen = Summe Gewicht x Wdh.', () {
    final v = E1rmCalculator.volume(const [
      SetResult(weight: 20, reps: 5),
      SetResult(weight: 20, reps: 4),
    ]);
    expect(v, 180);
  });
}
