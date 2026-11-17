import '../date_utils.dart';
import '../plan_seed.dart';
import 'analytics.dart';
import 'e1rm.dart';

/// Ein Ziel: Zusatzgewicht für eine Anzahl Wiederholungen.
class GoalDef {
  const GoalDef({
    required this.exerciseKey,
    required this.title,
    required this.targetKg,
    required this.reps,
  });
  final String exerciseKey;
  final String title;
  final double targetKg;
  final int reps;
}

/// Deine Ziele (Zusatzgewicht für 3 Wiederholungen).
class Goals {
  const Goals._();
  static const all = [
    GoalDef(
        exerciseKey: ExerciseKeys.weightedDip,
        title: 'Weighted Dip',
        targetKg: 100,
        reps: 3),
    GoalDef(
        exerciseKey: ExerciseKeys.weightedPullup,
        title: 'Weighted Pullup',
        targetKg: 70,
        reps: 3),
  ];
}

enum EtaState {
  reached,
  estimated,
  noData,
  notEnoughData,
  noProgress,
  tooFar,
}

class GoalStatus {
  const GoalStatus({
    required this.state,
    this.currentKg,
    this.progress = 0,
    this.eta,
  });
  final EtaState state;

  /// Aktueller Stand als Zusatzgewicht für [GoalDef.reps] Wiederholungen.
  final double? currentKg;

  /// 0..1
  final double progress;
  final DateTime? eta;
}

/// Berechnet Fortschritt und Erreichungsdatum.
///
/// * Stand = bester e1RM der letzten [windowDays] Tage, umgerechnet auf das
///   Zusatzgewicht für die Ziel-Wiederholungen (mit Körpergewicht, falls bekannt).
/// * Fortschritt = Stand ÷ Zielgewicht (0 kg Zusatz = 0 %).
/// * Prognose: robuste Trendgerade (Theil-Sen) über die wöchentlichen
///   e1RM-Bestwerte der letzten 12 Wochen. Zu wenige Daten, kein Aufwärtstrend
///   oder ein Ziel jenseits von 5 Jahren ergeben **keine** Jahreszahl.
class GoalEngine {
  const GoalEngine._();

  static const windowDays = 90;
  static const trendWeeks = 12;
  static const minTrendWeeks = 4;
  static const maxWeeksAhead = 260;
  static const minSlopePerWeek = 0.05; // kg e1RM pro Woche

  /// e1RM (Zusatzgewicht für 1 Wdh.) aus Zusatzgewicht × Wiederholungen.
  static double e1rmFor(double addedKg, int reps, double? bodyweight) {
    if (reps <= 1) return addedKg;
    return bodyweight == null || bodyweight <= 0
        ? E1rmCalculator.epley(addedKg, reps)
        : E1rmCalculator.epley(bodyweight + addedKg, reps) - bodyweight;
  }

  /// Umkehrung: Zusatzgewicht für [reps] Wiederholungen aus einem e1RM.
  static double addedFor(double e1rm, int reps, double? bodyweight) {
    if (reps <= 1) return e1rm;
    final hasBw = bodyweight != null && bodyweight > 0;
    final total = (hasBw ? e1rm + bodyweight : e1rm) / (1 + reps / 30);
    return hasBw ? total - bodyweight : total;
  }

  static GoalStatus evaluate({
    required GoalDef goal,
    required List<ExercisePoint> points,
    required DateTime today,
    double? bodyweight,
  }) {
    final recent = points
        .where((p) =>
            !p.date.isAfter(today) &&
            !p.date.isBefore(addDays(today, -windowDays)) &&
            p.e1rm > 0)
        .toList();
    if (recent.isEmpty) return const GoalStatus(state: EtaState.noData);

    final bestE1rm = recent.map((p) => p.e1rm).reduce((a, b) => a > b ? a : b);
    final currentKg = addedFor(bestE1rm, goal.reps, bodyweight);
    final progress = (currentKg / goal.targetKg).clamp(0.0, 1.0);

    if (currentKg >= goal.targetKg) {
      return GoalStatus(
          state: EtaState.reached, currentKg: currentKg, progress: 1);
    }

    final targetE1rm = e1rmFor(goal.targetKg, goal.reps, bodyweight);
    final trend = _trend(points, today);
    if (trend == null) {
      return GoalStatus(
          state: EtaState.notEnoughData,
          currentKg: currentKg,
          progress: progress);
    }
    if (trend.slope < minSlopePerWeek) {
      return GoalStatus(
          state: EtaState.noProgress, currentKg: currentKg, progress: progress);
    }
    final weeks = (targetE1rm - trend.valueNow) / trend.slope;
    if (weeks > maxWeeksAhead) {
      return GoalStatus(
          state: EtaState.tooFar, currentKg: currentKg, progress: progress);
    }
    final eta = addDays(today, (weeks <= 0 ? 0 : weeks * 7).round());
    return GoalStatus(
        state: EtaState.estimated,
        currentKg: currentKg,
        progress: progress,
        eta: eta);
  }

  static ({double slope, double valueNow})? _trend(
      List<ExercisePoint> points, DateTime today) {
    final from = addDays(weekStart(today), -7 * (trendWeeks - 1));
    final weekly = <DateTime, double>{};
    for (final p in points) {
      if (p.e1rm <= 0 || p.date.isAfter(today) || p.date.isBefore(from)) continue;
      final k = weekStart(p.date);
      if (p.e1rm > (weekly[k] ?? 0)) weekly[k] = p.e1rm;
    }
    if (weekly.length < minTrendWeeks) return null;
    final keys = weekly.keys.toList()..sort();
    if (daysBetween(keys.first, keys.last) < 21) return null;

    final xs = [for (final k in keys) daysBetween(keys.first, k) / 7.0];
    final ys = [for (final k in keys) weekly[k]!];

    final slopes = <double>[];
    for (var i = 0; i < xs.length; i++) {
      for (var j = i + 1; j < xs.length; j++) {
        if (xs[j] != xs[i]) slopes.add((ys[j] - ys[i]) / (xs[j] - xs[i]));
      }
    }
    final slope = _median(slopes);
    final intercept =
        _median([for (var i = 0; i < xs.length; i++) ys[i] - slope * xs[i]]);
    final xNow = daysBetween(keys.first, today) / 7.0;
    return (slope: slope, valueNow: intercept + slope * xNow);
  }

  static double _median(List<double> v) {
    final s = [...v]..sort();
    final n = s.length;
    return n.isOdd ? s[n ~/ 2] : (s[n ~/ 2 - 1] + s[n ~/ 2]) / 2;
  }
}
