import 'package:flutter_test/flutter_test.dart';
import 'package:overview/domain/date_utils.dart';
import 'package:overview/domain/engines/schedule.dart';
import 'package:overview/domain/models.dart';

void main() {
  final tue = DateTime(2026, 11, 17);
  final wed = DateTime(2026, 11, 18);
  final mon = DateTime(2026, 11, 16);

  test('weekStart liefert Montag, auch für Sonntag', () {
    expect(weekStart(DateTime(2026, 11, 22)), mon); // Sonntag
    expect(weekStart(mon), mon);
    expect(weekStart(tue), mon);
  });

  test('Wochenwechsel über Monatsgrenze', () {
    expect(weekStart(DateTime(2026, 12, 2)), DateTime(2026, 11, 30));
  });

  test('dateKey/parseDateKey Roundtrip', () {
    expect(dateKey(DateTime(2026, 3, 5)), '2026-03-05');
    expect(parseDateKey('2026-03-05'), DateTime(2026, 3, 5));
  });

  test('daysBetween ist sommerzeitsicher', () {
    expect(daysBetween(DateTime(2026, 3, 28), DateTime(2026, 3, 30)), 2);
    expect(daysBetween(DateTime(2026, 10, 24), DateTime(2026, 10, 26)), 2);
  });

  group('timing', () {
    test('erledigt am geplanten Tag = planmäßig', () {
      expect(
          Schedule.timing(
              planned: tue,
              today: wed,
              status: SessionStatus.done,
              performed: tue),
          SessionTiming.onTime);
    });

    test('Beispiel aus der Spec: Di geplant, Mi gemacht = später', () {
      expect(
          Schedule.timing(
              planned: tue,
              today: wed,
              status: SessionStatus.done,
              performed: wed),
          SessionTiming.late);
    });

    test('Vorgezogen = früher', () {
      expect(
          Schedule.timing(
              planned: wed,
              today: wed,
              status: SessionStatus.done,
              performed: tue),
          SessionTiming.early);
    });

    test('Offen und Tag vorbei = overdue, sonst upcoming', () {
      expect(
          Schedule.timing(
              planned: tue, today: wed, status: SessionStatus.open),
          SessionTiming.overdue);
      expect(
          Schedule.timing(
              planned: wed, today: wed, status: SessionStatus.open),
          SessionTiming.upcoming);
    });

    test('Übersprungen', () {
      expect(
          Schedule.timing(
              planned: tue, today: wed, status: SessionStatus.skipped),
          SessionTiming.skipped);
    });
  });

  test('plannedDate: Donnerstag der Woche', () {
    expect(Schedule.plannedDate(mon, 4), DateTime(2026, 11, 19));
  });
}
