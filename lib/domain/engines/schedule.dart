import '../date_utils.dart';
import '../models.dart';

/// Reine Terminlogik: Zeit-Status einer Einheit relativ zum Plan.
///
/// Der Plan selbst ändert sich nie. Gespeichert wird nur, *wann* eine geplante
/// Einheit tatsächlich durchgeführt wurde.
class Schedule {
  const Schedule._();

  /// [planned] = geplanter Tag, [performed] = tatsächlicher Tag (falls erledigt).
  static SessionTiming timing({
    required DateTime planned,
    required DateTime today,
    required SessionStatus status,
    DateTime? performed,
  }) {
    switch (status) {
      case SessionStatus.skipped:
        return SessionTiming.skipped;
      case SessionStatus.done:
        final p = performed ?? planned;
        final diff = daysBetween(planned, p);
        if (diff == 0) return SessionTiming.onTime;
        return diff < 0 ? SessionTiming.early : SessionTiming.late;
      case SessionStatus.open:
        return daysBetween(planned, today) > 0
            ? SessionTiming.overdue
            : SessionTiming.upcoming;
    }
  }

  /// Geplanter Tag der Woche [weekMonday] für Plan-Wochentag [weekday] (1 = Mo).
  static DateTime plannedDate(DateTime weekMonday, int weekday) =>
      addDays(weekMonday, weekday - 1);
}
