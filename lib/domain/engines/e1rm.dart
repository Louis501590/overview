import '../models.dart';

/// Geschätztes 1-Rep-Max nach Epley: `w · (1 + reps / 30)`.
///
/// Bei Dip/Pullup wird das **Zusatzgewicht** gerechnet (so sind auch die Ziele
/// definiert). Für den Strength Score wird später separat Körpergewicht addiert.
class E1rmCalculator {
  const E1rmCalculator._();

  /// Maximal gewertete Wiederholungen; darüber ist Epley zu ungenau.
  static const maxReliableReps = 12;

  static double epley(double weight, int reps) {
    if (reps <= 0 || weight <= 0) return 0;
    if (reps == 1) return weight;
    return weight * (1 + reps / 30);
  }

  /// Bester e1RM über alle Sätze (Sätze > [maxReliableReps] werden ignoriert).
  static double best(Iterable<SetResult> sets) {
    var best = 0.0;
    for (final s in sets) {
      if (s.reps > maxReliableReps) continue;
      final v = epley(s.weight, s.reps);
      if (v > best) best = v;
    }
    return best;
  }

  /// e1RM abhängig von der Lastart.
  ///
  /// * `external` (Langhantel): Epley auf das Hantelgewicht.
  /// * `addedBodyweight` (Dip/Pullup) mit bekanntem Körpergewicht: Epley auf das
  ///   **Gesamtgewicht** (Körpergewicht + Zusatz), danach wird das Körpergewicht
  ///   wieder abgezogen. Das Ergebnis ist das geschätzte *Zusatzgewicht* für 1 Wdh.
  ///   Ohne Körpergewicht wird nur das Zusatzgewicht gerechnet (unterschätzt).
  static double bestForLoad(
    Iterable<SetResult> sets,
    LoadType loadType, {
    double? bodyweight,
  }) {
    if (loadType == LoadType.external || bodyweight == null || bodyweight <= 0) {
      return best(sets);
    }
    var best_ = 0.0;
    for (final s in sets) {
      if (s.reps <= 0 || s.reps > maxReliableReps) continue;
      final v = s.reps == 1
          ? s.weight
          : epley(bodyweight + s.weight, s.reps) - bodyweight;
      if (v > best_) best_ = v;
    }
    return best_;
  }

  /// Umkehrung: Gewicht, das für [reps] Wiederholungen entspricht.
  static double weightForReps(double e1rm, int reps) =>
      reps <= 1 ? e1rm : e1rm / (1 + reps / 30);

  /// Trainingsvolumen: Σ Gewicht · Wiederholungen.
  static double volume(Iterable<SetResult> sets) =>
      sets.fold(0.0, (sum, s) => sum + s.weight * s.reps);
}
