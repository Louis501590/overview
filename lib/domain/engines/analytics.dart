import '../date_utils.dart';

/// Ein Trainingstag einer Übung (Werte aus den gespeicherten Einheiten).
class ExercisePoint {
  const ExercisePoint({
    required this.date,
    required this.topWeight,
    required this.e1rm,
    required this.volume,
  });
  final DateTime date;

  /// Höchstes Satzgewicht (bei Dip/Pullup: Zusatzgewicht).
  final double topWeight;
  final double e1rm;
  final double volume;
}

enum AnalysisRange {
  month(30, 'Monat'),
  threeMonths(90, '3 Monate'),
  sixMonths(182, '6 Monate'),
  twelveMonths(365, '12 Monate'),
  all(null, 'Gesamt');

  const AnalysisRange(this.days, this.label);
  final int? days;
  final String label;
}

enum AnalysisMetric {
  weight('Trainingsgewicht'),
  e1rm('e1RM'),
  volume('Volumen');

  const AnalysisMetric(this.label);
  final String label;
}

enum Bucket { day, week, month }

class SeriesPoint {
  const SeriesPoint(this.date, this.value);
  final DateTime date;
  final double value;
}

class Series {
  const Series(this.points, this.bucket);
  final List<SeriesPoint> points;
  final Bucket bucket;
}

class StrengthAnalytics {
  const StrengthAnalytics._();

  /// Punkte im Zeitraum (inklusive Heute), aufsteigend nach Datum.
  static List<ExercisePoint> inRange(
      List<ExercisePoint> points, AnalysisRange range, DateTime today) {
    final from = range.days == null ? null : addDays(today, -range.days!);
    final out = points
        .where((p) =>
            !p.date.isAfter(today) && (from == null || !p.date.isBefore(from)))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return out;
  }

  /// Zeitreihe für eine Kennzahl. Bis ca. 45 Tage je Einheit, bis ca. 400 Tage
  /// je Woche, darüber je Monat. Gewicht und e1RM: Maximum, Volumen: Summe.
  ///
  /// Wochenwerte glätten das Muster aus schweren und leichten Tagen (z. B. Dip
  /// Dienstag/Donnerstag), sodass der langfristige Trend sichtbar wird.
  static Series series(List<ExercisePoint> points, AnalysisRange range,
      AnalysisMetric metric, DateTime today) {
    final pts = inRange(points, range, today);
    if (pts.isEmpty) return const Series([], Bucket.day);

    final span = range.days ?? daysBetween(pts.first.date, pts.last.date);
    final bucket = span <= 45
        ? Bucket.day
        : (span <= 400 ? Bucket.week : Bucket.month);

    DateTime keyOf(DateTime d) => switch (bucket) {
          Bucket.day => d,
          Bucket.week => weekStart(d),
          Bucket.month => DateTime(d.year, d.month),
        };

    double valueOf(ExercisePoint p) => switch (metric) {
          AnalysisMetric.weight => p.topWeight,
          AnalysisMetric.e1rm => p.e1rm,
          AnalysisMetric.volume => p.volume,
        };

    final map = <DateTime, double>{};
    for (final p in pts) {
      final k = keyOf(p.date);
      final v = valueOf(p);
      // Einheiten ohne verwertbaren e1RM (z. B. Hypertrophie) auslassen.
      if (metric == AnalysisMetric.e1rm && v <= 0) continue;
      map[k] = metric == AnalysisMetric.volume
          ? (map[k] ?? 0) + v
          : (v > (map[k] ?? 0) ? v : (map[k] ?? 0));
    }
    if (map.isEmpty) return Series(const [], bucket);
    final keys = map.keys.toList()..sort();
    return Series([for (final k in keys) SeriesPoint(k, map[k]!)], bucket);
  }
}

/// Wochenwerte: Gewicht/e1RM = Bestwert der Woche, Volumen = Summe der Woche.
class WeekStat {
  const WeekStat(this.weekStart, this.weight, this.e1rm, this.volume);
  final DateTime weekStart;
  final double weight;
  final double e1rm;
  final double volume;
}

List<WeekStat> weeklyStats(List<ExercisePoint> points) {
  final w = <DateTime, List<double>>{};
  for (final p in points) {
    final k = weekStart(p.date);
    final a = w.putIfAbsent(k, () => [0, 0, 0]);
    if (p.topWeight > a[0]) a[0] = p.topWeight;
    if (p.e1rm > a[1]) a[1] = p.e1rm;
    a[2] += p.volume;
  }
  final keys = w.keys.toList()..sort();
  return [for (final k in keys) WeekStat(k, w[k]![0], w[k]![1], w[k]![2])];
}

class RecordInfo {
  const RecordInfo(this.value, this.date);
  final double value;
  final DateTime date;
}

class ExerciseRecords {
  const ExerciseRecords({this.maxWeight, this.maxE1rm});
  final RecordInfo? maxWeight;
  final RecordInfo? maxE1rm;
}

class RecordsEngine {
  const RecordsEngine._();

  /// Bestleistungen. Bei Gleichstand zählt der **erste** Tag, an dem der Wert
  /// erreicht wurde.
  static ExerciseRecords compute(List<ExercisePoint> points) {
    final sorted = [...points]..sort((a, b) => a.date.compareTo(b.date));
    RecordInfo? w, e;
    for (final p in sorted) {
      if (p.topWeight > 0 && (w == null || p.topWeight > w.value)) {
        w = RecordInfo(p.topWeight, p.date);
      }
      if (p.e1rm > 0 && (e == null || p.e1rm > e.value)) {
        e = RecordInfo(p.e1rm, p.date);
      }
    }
    return ExerciseRecords(maxWeight: w, maxE1rm: e);
  }
}
