import '../plan_seed.dart';

/// Ergebnis des Strength Scores.
class StrengthScoreResult {
  const StrengthScoreResult({
    required this.score,
    required this.liftPercentiles,
    required this.age,
  });

  /// 0–100. Entspricht dem geschätzten Anteil der Trainierenden deiner
  /// Altersgruppe, die du übertriffst.
  final double score;

  /// Perzentil je Übung (Schlüssel aus [ExerciseKeys]).
  final Map<String, double> liftPercentiles;
  final int age;

  /// „Top X %“ (mindestens 1).
  int get topPercent => (100 - score).round().clamp(1, 100);
  int get liftCount => liftPercentiles.length;
  bool get provisional => liftCount < 4;
}

/// Schätzmodell für den Strength Score (0–100) – **keine** exakte Statistik.
///
/// Idee: Pro Übung wird die relative Stärke (e1RM ÷ Körpergewicht) mit
/// Referenzwerten trainierender Personen verglichen und in ein Perzentil
/// übersetzt (5 = Anfänger, 20 = Novice, 50 = Intermediate, 80 = Advanced,
/// 95 = Elite). Ein Altersfaktor gleicht Jüngere und Ältere aus. Der Score ist
/// der Mittelwert der Perzentile aller Übungen mit Daten.
///
/// Die Referenzwerte sind grobe, an gängigen Strength-Standards orientierte
/// Näherungen und lassen sich hier zentral anpassen.
class StrengthScoreEngine {
  const StrengthScoreEngine._();

  /// Perzentil-Stützstellen.
  static const _percentiles = [5.0, 20.0, 50.0, 80.0, 95.0];

  /// Referenz-Verhältnisse (e1RM ÷ Körpergewicht) für Männer.
  /// Dip/Pullup: **Zusatzgewicht** ÷ Körpergewicht.
  static const Map<String, List<double>> _maleRatios = {
    ExerciseKeys.backSquat: [0.75, 1.25, 1.75, 2.30, 2.80],
    ExerciseKeys.zercherSquat: [0.60, 1.00, 1.40, 1.85, 2.25],
    ExerciseKeys.weightedDip: [0.00, 0.25, 0.60, 1.00, 1.50],
    ExerciseKeys.weightedPullup: [0.00, 0.20, 0.50, 0.85, 1.25],
  };

  /// Frauen erreichen im Schnitt geringere relative Kraft (Oberkörper stärker
  /// betroffen als Unterkörper).
  static double _sexFactor(String key, String sex) {
    if (sex != 'female') return 1.0;
    return (key == ExerciseKeys.backSquat || key == ExerciseKeys.zercherSquat)
        ? 0.70
        : 0.55;
  }

  /// Faktor, mit dem die gemessene Kraft verrechnet wird, um sie mit dem
  /// Referenzfeld (Trainierende ca. 23–40 Jahre) zu vergleichen.
  /// Jüngere: leicht aufgewertet, ab 40: ca. 1 % pro Jahr.
  static double ageFactor(int age) {
    if (age < 23) return 1 + 0.015 * (23 - age.clamp(14, 23));
    if (age <= 40) return 1.0;
    return 1 + 0.0105 * (age.clamp(40, 80) - 40);
  }

  /// Perzentil (0–99) für ein Verhältnis; linear zwischen den Stützstellen.
  static double percentileForRatio(String key, double ratio, {String sex = 'male'}) {
    final refs = _maleRatios[key];
    if (refs == null || ratio.isNaN) return 0;
    final scaled = refs.map((r) => r * _sexFactor(key, sex)).toList();
    if (ratio <= 0) return 0;
    // Unterhalb der ersten Stützstelle: 0 → 5 %.
    if (ratio < scaled.first) {
      return scaled.first <= 0 ? 5 : 5 * ratio / scaled.first;
    }
    for (var i = 0; i < scaled.length - 1; i++) {
      if (ratio <= scaled[i + 1]) {
        final span = scaled[i + 1] - scaled[i];
        final t = span <= 0 ? 1.0 : (ratio - scaled[i]) / span;
        return _percentiles[i] + t * (_percentiles[i + 1] - _percentiles[i]);
      }
    }
    // Oberhalb von „Elite“: 95 → 99 asymptotisch.
    final over = (ratio - scaled.last) / scaled.last;
    return 95 + 4 * (1 - 1 / (1 + 2 * over));
  }

  /// [e1rmByKey]: bester e1RM je Übung (Dip/Pullup als Zusatzgewicht).
  /// `null`, wenn keine verwertbaren Daten vorliegen.
  static StrengthScoreResult? compute({
    required Map<String, double> e1rmByKey,
    required double bodyweight,
    required int age,
    required String sex,
  }) {
    if (bodyweight <= 0) return null;
    final factor = ageFactor(age);
    final per = <String, double>{};
    for (final e in e1rmByKey.entries) {
      if (e.value <= 0 || !_maleRatios.containsKey(e.key)) continue;
      per[e.key] = percentileForRatio(e.key, e.value * factor / bodyweight, sex: sex);
    }
    if (per.isEmpty) return null;
    final score = per.values.reduce((a, b) => a + b) / per.length;
    return StrengthScoreResult(score: score, liftPercentiles: per, age: age);
  }
}
