import '../../core/format.dart';
import '../date_utils.dart';
import 'analytics.dart';
import 'goal_engine.dart';

/// Erzeugt deutsche Fazit-Texte ohne externen Dienst (regelbasiert).
class InsightService {
  const InsightService._();

  static String _signed(double v, {int d = 1}) =>
      '${v >= 0 ? '+' : '−'}${fmtKg(v.abs(), maxDecimals: d)}';

  static String _trendWord(double pct) {
    if (pct >= 2) return 'gestiegen';
    if (pct <= -2) return 'gesunken';
    return 'ungefähr gleich geblieben';
  }

  /// Fazit zur Kraftentwicklung einer Übung im gewählten Zeitraum.
  static String strength({
    required String exerciseName,
    required List<ExercisePoint> points, // bereits auf den Zeitraum gefiltert
    required AnalysisRange range,
  }) {
    final period = switch (range) {
      AnalysisRange.month => 'in den letzten 30 Tagen',
      AnalysisRange.threeMonths => 'in den letzten 3 Monaten',
      AnalysisRange.sixMonths => 'in den letzten 6 Monaten',
      AnalysisRange.twelveMonths => 'in den letzten 12 Monaten',
      AnalysisRange.all => 'insgesamt',
    };
    if (points.isEmpty) {
      return 'Im gewählten Zeitraum gibt es noch keine Einheiten für '
          '$exerciseName.';
    }
    if (points.length < 2) {
      return 'Für $exerciseName liegt erst eine Einheit vor. Ab zwei '
          'Einheiten zeige ich hier eine Entwicklung.';
    }
    // Wochenbestwerte vergleichen (schwere und leichte Tage gleichen sich aus).
    final weeks = weeklyStats(points);
    if (weeks.length < 2) {
      return 'Für $exerciseName liegen erst Daten aus einer Trainingswoche '
          'vor. Ab zwei Wochen zeige ich hier eine Entwicklung.';
    }
    final first = weeks.first, last = weeks.last;
    final b = StringBuffer();

    // e1RM nur aus Wochen mit verwertbarem Wert (Sätze mit höchstens 6 Wdh.).
    final eWeeks = weeks.where((w) => w.e1rm > 0).toList();
    var ePct = 0.0;
    if (eWeeks.length >= 2) {
      final e0 = eWeeks.first.e1rm, e1 = eWeeks.last.e1rm;
      ePct = e0 <= 0 ? 0.0 : (e1 - e0) / e0 * 100;
      b.write('Dein e1RM bei $exerciseName ist $period ${_trendWord(ePct)}: '
          'von ${fmtKg(e0, maxDecimals: 1)} auf ${fmtKg(e1, maxDecimals: 1)} kg '
          '(${_signed(e1 - e0)} kg, ${_signed(ePct, d: 0)} %). ');
    } else {
      b.write('Für den e1RM brauche ich Sätze mit höchstens 6 Wiederholungen '
          'aus mindestens zwei Trainingswochen. ');
    }

    final w0 = first.weight, w1 = last.weight;
    if (w1 > w0) {
      b.write('Das höchste Trainingsgewicht stieg von ${fmtKg(w0)} auf '
          '${fmtKg(w1)} kg. ');
    } else if (w1 < w0) {
      b.write('Das höchste Trainingsgewicht sank von ${fmtKg(w0)} auf '
          '${fmtKg(w1)} kg. ');
    } else {
      b.write('Das höchste Trainingsgewicht blieb bei ${fmtKg(w1)} kg. ');
    }

    final half = weeks.length ~/ 2;
    double avg(List<WeekStat> l) =>
        l.fold(0.0, (s, p) => s + p.volume) / l.length;
    if (half >= 1) {
      final v0 = avg(weeks.sublist(0, half)), v1 = avg(weeks.sublist(half));
      if (v0 > 0) {
        final vPct = (v1 - v0) / v0 * 100;
        b.write('Das Wochenvolumen ist in der zweiten Hälfte des '
            'Zeitraums ${_trendWord(vPct)} '
            '(Ø ${fmtKg(v0, maxDecimals: 0)} → ${fmtKg(v1, maxDecimals: 0)} kg). ');
      }
    }

    if (eWeeks.length < 2) {
      b.write('Trage weiter regelmäßig ein.');
    } else if (ePct <= -2) {
      b.write('Prüfe Erholung, Schlaf und ob ein Deload sinnvoll ist.');
    } else if (ePct < 2) {
      b.write('Ein Plateau ist normal – bleibe bei der Progression und '
          'wiederhole das Gewicht sauber.');
    } else {
      b.write('Weiter so.');
    }
    return b.toString().trim();
  }

  /// Text zum Erreichungsdatum eines Ziels.
  static String eta(GoalStatus s) {
    switch (s.state) {
      case EtaState.reached:
        return 'Ziel erreicht! 🎉';
      case EtaState.noData:
        return 'Noch keine Trainingsdaten der letzten 90 Tage.';
      case EtaState.notEnoughData:
        return 'Für eine Prognose brauche ich mindestens 4 Trainingswochen '
            'mit Daten.';
      case EtaState.noProgress:
        return 'Aktuell kein Aufwärtstrend – keine Prognose möglich.';
      case EtaState.tooFar:
        return 'Beim aktuellen Tempo nicht absehbar (mehr als 5 Jahre).';
      case EtaState.estimated:
        final d = s.eta!;
        return 'Voraussichtlich erreicht: ${monthNamesDe[d.month - 1]} ${d.year} '
            '(Schätzung)';
    }
  }

  /// Wochentext für Ziele: kurze Einordnung.
  static String shortDate(DateTime d) => formatDateDe(d);
}
