/// Reine Domain-Modelle (keine Flutter-/DB-Abhängigkeit).
library;

enum LoadType {
  /// Freie Last (Langhantel): Gewicht = Hantelgewicht.
  external,

  /// Zusatzgewicht am Körpergewicht (Dip/Pullup): Gewicht = Zusatzlast.
  addedBodyweight,
}

enum SessionStatus { open, done, skipped }

/// Zeitlicher Status einer Einheit relativ zum Plan.
enum SessionTiming {
  /// Noch nichts erfasst und noch nicht überfällig.
  upcoming,

  /// Geplant, noch nicht erledigt, Tag liegt in der Vergangenheit.
  overdue,
  onTime,
  early,
  late,
  skipped;

  String get labelDe => switch (this) {
        SessionTiming.upcoming => 'Geplant',
        SessionTiming.overdue => 'Offen',
        SessionTiming.onTime => 'Planmäßig',
        SessionTiming.early => 'Früher',
        SessionTiming.late => 'Später',
        SessionTiming.skipped => 'Nicht durchgeführt',
      };
}

enum ProgressionAction { increase, hold, deload }

class SetResult {
  const SetResult({required this.weight, required this.reps, this.rir});
  final double weight;
  final int reps;

  /// Reps in Reserve (optional erfasst).
  final int? rir;
}

/// Progressionsregel eines Plan-Slots (Übung an einem Tag).
class ProgressionRule {
  const ProgressionRule({
    required this.targetSets,
    required this.repMin,
    required this.repMax,
    required this.requiredReps,
    required this.requiredSets,
    this.rirMin,
    this.rirMax,
  });

  final int targetSets;
  final int repMin;
  final int repMax;

  /// Wiederholungen, die pro Satz erreicht werden müssen.
  final int requiredReps;

  /// Anzahl Sätze, die [requiredReps] erreichen müssen.
  final int requiredSets;
  final int? rirMin;
  final int? rirMax;
}

class ProgressionRecommendation {
  const ProgressionRecommendation(this.action, this.message);
  final ProgressionAction action;
  final String message;

  String get titleDe => switch (action) {
        ProgressionAction.increase => 'Gewicht erhöhen',
        ProgressionAction.hold => 'Gewicht halten',
        ProgressionAction.deload => 'Deload empfohlen',
      };
}
