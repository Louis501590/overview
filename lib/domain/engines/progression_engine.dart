import '../models.dart';

String _kg(double v) =>
    (v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toString())
        .replaceAll('.', ',');

/// Bewertet eine Einheit eines Plan-Slots nach den Progressionsregeln.
///
/// * **Erhöhen**: mindestens `requiredSets` Sätze erreichen `requiredReps`
///   (die Spezifikation fordert „alle Sätze“).
/// * **Halten**: sonst.
/// * **Deload**: der aktuelle und die [deloadAfterFailures] − 1 vorherigen
///   Einheiten blieben mit einem Satz unter dem Wiederholungsminimum.
/// * Optional: Wurden Wiederholungen erreicht, aber RIR 0 gemeldet (Muskelversagen
///   bei Zielbereich 1–2 RIR), wird aus „Erhöhen“ ein „Halten“.
///
/// Die konkrete Erhöhung (Kilogramm) wählt der Nutzer selbst.
class ProgressionEngine {
  const ProgressionEngine({this.deloadAfterFailures = 3});

  final int deloadAfterFailures;

  /// [previousFailureStreak] = Anzahl direkt vorangehender gescheiterter
  /// Einheiten desselben Slots (siehe [isFailure]).
  ProgressionRecommendation evaluate(
    ProgressionRule rule,
    List<SetResult> sets, {
    int previousFailureStreak = 0,
  }) {
    if (sets.isEmpty) {
      return const ProgressionRecommendation(
          ProgressionAction.hold, 'Keine Sätze erfasst.');
    }

    final reached = sets.where((s) => s.reps >= rule.requiredReps).length;
    final needed = rule.requiredSets;
    final allReached = sets.length >= needed && reached >= needed;

    if (isFailure(rule, sets) &&
        previousFailureStreak + 1 >= deloadAfterFailures) {
      return ProgressionRecommendation(
        ProgressionAction.deload,
        'Zum ${previousFailureStreak + 1}. Mal in Folge unter ${rule.repMin} '
        'Wdh. – Gewicht um ca. 10 % reduzieren und neu aufbauen.',
      );
    }

    if (allReached) {
      final hitFailure = rule.rirMin != null && sets.any((s) => s.rir == 0);
      if (hitFailure) {
        return ProgressionRecommendation(
          ProgressionAction.hold,
          'Wiederholungsziel erreicht, aber mit 0 RIR (Zielbereich '
          '${rule.rirMin}–${rule.rirMax} RIR). Gewicht halten und sauberer '
          'wiederholen.',
        );
      }
      return ProgressionRecommendation(
        ProgressionAction.increase,
        needed == rule.targetSets
            ? 'Alle $needed Sätze haben ${rule.requiredReps} Wdh. erreicht.'
            : '$needed Sätze haben ${rule.requiredReps} Wdh. erreicht.',
      );
    }

    final misses = <String>[];
    for (var i = 0; i < sets.length; i++) {
      if (sets[i].reps < rule.requiredReps) {
        misses.add('Satz ${i + 1}: ${sets[i].reps}');
      }
    }
    final extra = sets.length < needed
        ? ' (nur ${sets.length} von ${rule.targetSets} Sätzen erfasst)'
        : '';
    return ProgressionRecommendation(
      ProgressionAction.hold,
      'Ziel ${rule.requiredReps} Wdh. in $needed '
      '${needed == 1 ? 'Satz' : 'Sätzen'} noch nicht erreicht '
      '(${misses.join(', ')})$extra.',
    );
  }

  /// Gescheitert = mindestens ein Satz unter dem Wiederholungsminimum.
  static bool isFailure(ProgressionRule rule, List<SetResult> sets) =>
      sets.isNotEmpty && sets.any((s) => s.reps < rule.repMin);

  /// Gewicht für den Hinweistext, falls ein Deload empfohlen wird.
  static double deloadWeight(double current) =>
      (current * 0.9 / 0.25).round() * 0.25;

  static String formatKg(double v) => _kg(v);
}
