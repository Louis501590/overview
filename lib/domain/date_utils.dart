/// Kalendertage werden app-weit als lokaler String `YYYY-MM-DD` gespeichert
/// (kein UTC, keine Zeitzonen-/Sommerzeitprobleme). Wochen laufen Mo–So.
library;

const weekdayNamesDe = [
  'Montag',
  'Dienstag',
  'Mittwoch',
  'Donnerstag',
  'Freitag',
  'Samstag',
  'Sonntag',
];

const weekdayShortDe = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];

/// Schneidet die Uhrzeit ab (lokales Datum).
DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

String dateKey(DateTime d) {
  final y = d.year.toString().padLeft(4, '0');
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '$y-$m-$day';
}

DateTime parseDateKey(String s) {
  final p = s.split('-');
  return DateTime(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
}

/// Addiert Kalendertage (sommerzeitsicher, da über den Konstruktor normalisiert).
DateTime addDays(DateTime d, int days) =>
    DateTime(d.year, d.month, d.day + days);

/// Montag der Woche, in der [d] liegt.
DateTime weekStart(DateTime d) => addDays(dateOnly(d), -(d.weekday - 1));

/// Anzahl Kalendertage von [a] bis [b] (b - a), sommerzeitsicher.
int daysBetween(DateTime a, DateTime b) {
  final ua = DateTime.utc(a.year, a.month, a.day);
  final ub = DateTime.utc(b.year, b.month, b.day);
  return ub.difference(ua).inDays;
}

String formatDateDe(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
