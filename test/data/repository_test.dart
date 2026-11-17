import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:overview/data/db/database.dart';
import 'package:overview/data/repositories/app_repository.dart';
import 'package:overview/domain/models.dart';
import 'package:overview/domain/views.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  late AppRepository repo;
  late List<DayInfo> plan;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    repo = AppRepository(db);
    plan = await repo.loadPlan();
  });
  tearDown(() => db.close());

  DayInfo day(int weekday) => plan.firstWhere((d) => d.weekday == weekday);
  SetResult s(int reps, [double w = 20, int? rir]) =>
      SetResult(weight: w, reps: reps, rir: rir);

  test('Seed: 7 Tage, 4 Ruhetage, Slots laut Spezifikation', () {
    expect(plan.length, 7);
    expect(plan.where((d) => d.isRest).length, 3);
    expect(day(1).slots.map((e) => e.exerciseKey),
        ['back_squat', 'zercher_squat']);
    expect(day(2).slots.single.targetText, '3 Sätze · 3–5 Wdh. · 1–2 RIR');
    expect(day(4).slots.map((e) => e.exerciseKey),
        ['weighted_dip', 'weighted_pullup']);
    expect(day(7).slots.single.exerciseKey, 'weighted_pullup');
  });

  test('Dip Dienstag und Donnerstag sind getrennte Slots derselben Übung', () {
    final tueSlot = day(2).slots.single;
    final thuSlot = day(4).slots.first;
    expect(tueSlot.exerciseId, thuSlot.exerciseId);
    expect(tueSlot.slotId, isNot(thuSlot.slotId));
  });

  test('Speichern: e1RM, Volumen, Empfehlung "erhöhen"', () async {
    final planned = DateTime(2026, 11, 16); // Montag
    final res = await repo.saveSession(
      day: day(1),
      planned: planned,
      performed: planned,
      setsBySlot: {
        day(1).slots[0].slotId: [s(6, 100), s(6, 100)],
        day(1).slots[1].slotId: [s(6, 80), s(5, 80)],
      },
    );
    final squat = res[day(1).slots[0].slotId]!;
    expect(squat.action, ProgressionAction.increase);
    expect(squat.e1rm, closeTo(120, 0.01));
    expect(squat.volume, 1200);
    expect(res[day(1).slots[1].slotId]!.action, ProgressionAction.hold);
  });

  test('Verschieben: Di geplant, Mi durchgeführt -> Wochenstruktur bleibt', () async {
    final planned = DateTime(2026, 11, 17);
    final performed = DateTime(2026, 11, 18);
    await repo.saveSession(
      day: day(2),
      planned: planned,
      performed: performed,
      setsBySlot: {
        day(2).slots.single.slotId: [s(5, 50), s(5, 50), s(5, 50)]
      },
    );
    final sess = await repo.sessionForPlannedDate(planned);
    expect(sess!.status, SessionStatus.done);
    expect(sess.planned, planned);
    expect(sess.performed, performed);
    // Am Mittwoch erscheint die Einheit unter "heute durchgeführt".
    final today = await repo.watchSessionsPerformedOn(performed).first;
    expect(today.single.planned, planned);
  });

  test('Erneutes Speichern überschreibt statt zu duplizieren', () async {
    final planned = DateTime(2026, 11, 16);
    final slot = day(1).slots[0];
    for (final reps in [4, 6]) {
      await repo.saveSession(
        day: day(1),
        planned: planned,
        performed: planned,
        setsBySlot: {slot.slotId: [s(reps, 100), s(reps, 100)]},
      );
    }
    final sess = await repo.sessionForPlannedDate(planned);
    final results = await repo.resultsForSession(sess!.id);
    expect(results[slot.slotId]!.sets.map((e) => e.reps), [6, 6]);
    expect(await db.select(db.setLogs).get(), hasLength(2));
  });

  test('Sätze mit 0 Wdh. werden ignoriert', () async {
    final planned = DateTime(2026, 11, 16);
    final slot = day(1).slots[0];
    final res = await repo.saveSession(
      day: day(1),
      planned: planned,
      performed: planned,
      setsBySlot: {slot.slotId: [s(6, 100), s(0, 100)]},
    );
    expect(res[slot.slotId]!.sets, hasLength(1));
  });

  test('Letztes Ergebnis je Slot, Dip Di und Do unabhängig', () async {
    final tue = DateTime(2026, 11, 17);
    final thu = DateTime(2026, 11, 19);
    await repo.saveSession(
        day: day(2),
        planned: tue,
        performed: tue,
        setsBySlot: {
          day(2).slots.single.slotId: [s(5, 60), s(5, 60), s(5, 60)]
        });
    await repo.saveSession(
        day: day(4),
        planned: thu,
        performed: thu,
        setsBySlot: {
          day(4).slots[0].slotId: [s(10, 40), s(9, 40), s(8, 40)]
        });
    final lastTue = await repo.lastResultForSlot(day(2).slots.single.slotId);
    final lastThu = await repo.lastResultForSlot(day(4).slots[0].slotId);
    expect(lastTue!.topWeight, 60);
    expect(lastTue.action, ProgressionAction.increase);
    expect(lastThu!.topWeight, 40);
    expect(lastThu.action, ProgressionAction.hold);
  });

  test('Deload nach 3 gescheiterten Einheiten in Folge', () async {
    final slot = day(1).slots[0];
    ProgressionAction? last;
    for (var i = 0; i < 3; i++) {
      final d = DateTime(2026, 11, 2 + 7 * i);
      final res = await repo.saveSession(
          day: day(1),
          planned: d,
          performed: d,
          setsBySlot: {slot.slotId: [s(3, 100), s(3, 100)]});
      last = res[slot.slotId]!.action;
    }
    expect(last, ProgressionAction.deload);
  });

  test('Überspringen und Zurücksetzen', () async {
    final planned = DateTime(2026, 11, 17);
    await repo.markSkipped(day(2), planned);
    expect((await repo.sessionForPlannedDate(planned))!.status,
        SessionStatus.skipped);
    await repo.resetSession(planned);
    expect(await repo.sessionForPlannedDate(planned), isNull);
  });

  test('Gewicht: ein Eintrag pro Tag, überschreiben, löschen', () async {
    final d = DateTime(2026, 11, 17);
    await repo.saveWeight(d, 80.4);
    await repo.saveWeight(d, 80.1);
    expect((await repo.weightOn(d))!.weightKg, 80.1);
    expect(await db.select(db.bodyWeightEntries).get(), hasLength(1));
    await repo.deleteWeight(d);
    expect(await repo.weightOn(d), isNull);
  });

  test('Backup: Export -> Löschen -> Import stellt alles wieder her', () async {
    final planned = DateTime(2026, 11, 16);
    await repo.saveProfile(DateTime(1995, 5, 20), 'male');
    await repo.saveWeight(planned, 79.8);
    await repo.saveSession(
        day: day(1),
        planned: planned,
        performed: planned,
        setsBySlot: {day(1).slots[0].slotId: [s(6, 100), s(6, 100)]});
    final json = await repo.exportJson();

    // Neue, leere DB
    final db2 = AppDatabase(NativeDatabase.memory());
    final repo2 = AppRepository(db2);
    await repo2.importJson(json);
    expect((await repo2.weightOn(planned))!.weightKg, 79.8);
    final sess = await repo2.sessionForPlannedDate(planned);
    expect(sess!.status, SessionStatus.done);
    final res = await repo2.resultsForSession(sess.id);
    expect(res.values.single.e1rm, closeTo(120, 0.01));
    expect((await repo2.watchProfile().first)!.sex, 'male');
    await db2.close();
  });

  test('Import ungültiger Dateien ändert nichts', () async {
    await repo.saveWeight(DateTime(2026, 11, 17), 80);
    expect(() => repo.importJson('kein json'), throwsFormatException);
    expect(() => repo.importJson('{"format":"x"}'), throwsFormatException);
    expect(await db.select(db.bodyWeightEntries).get(), hasLength(1));
  });

  test('Dip-e1RM nutzt das Körpergewicht (50 kg x 3 bei 82,5 kg = 63,25)', () async {
    final tue = DateTime(2026, 11, 17);
    await repo.saveWeight(DateTime(2026, 11, 16), 82.5);
    final slot = day(2).slots.single;
    final res = await repo.saveSession(
        day: day(2),
        planned: tue,
        performed: tue,
        setsBySlot: {slot.slotId: [s(3, 50), s(3, 50), s(3, 50)]});
    expect(res[slot.slotId]!.e1rm, closeTo(63.25, 0.01));
    expect(res[slot.slotId]!.bodyweight, 82.5);
    final sess = await repo.sessionForPlannedDate(tue);
    final stored = await repo.resultsForSession(sess!.id);
    expect(stored[slot.slotId]!.bodyweight, 82.5);
  });

  test('Dip ohne Körpergewicht: Fallback auf Zusatzgewicht', () async {
    final tue = DateTime(2026, 11, 17);
    final slot = day(2).slots.single;
    final res = await repo.saveSession(
        day: day(2),
        planned: tue,
        performed: tue,
        setsBySlot: {slot.slotId: [s(3, 50)]});
    expect(res[slot.slotId]!.e1rm, closeTo(55, 0.01));
    expect(res[slot.slotId]!.bodyweight, isNull);
  });

  test('Körpergewicht: letzte Messung am oder vor dem Tag', () async {
    await repo.saveWeight(DateTime(2026, 11, 10), 80);
    await repo.saveWeight(DateTime(2026, 11, 14), 81);
    expect(await repo.bodyweightAtOrBefore(DateTime(2026, 11, 9)), isNull);
    expect(await repo.bodyweightAtOrBefore(DateTime(2026, 11, 12)), 80);
    expect(await repo.bodyweightAtOrBefore(DateTime(2026, 11, 20)), 81);
  });

  test('bestE1rmByExerciseSince: bester Wert je Übung im Zeitraum', () async {
    final slot = day(1).slots[0];
    for (final (d, w) in [(DateTime(2026, 9, 7), 120.0), (DateTime(2026, 11, 2), 100.0), (DateTime(2026, 11, 9), 105.0)]) {
      await repo.saveSession(
          day: day(1),
          planned: d,
          performed: d,
          setsBySlot: {slot.slotId: [s(5, w), s(5, w)]});
    }
    final since = await repo.bestE1rmByExerciseSince(DateTime(2026, 10, 1));
    expect(since['back_squat'], closeTo(105 * (1 + 5 / 30), 0.01)); // 120 kg liegt davor
    final all = await repo.bestE1rmByExerciseSince(DateTime(2026, 1, 1));
    expect(all['back_squat'], closeTo(140, 0.01));
    expect(since.containsKey('weighted_dip'), isFalse);
  });
}
