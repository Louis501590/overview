import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/date_utils.dart';
import '../../domain/engines/analytics.dart';
import '../../domain/engines/e1rm.dart';
import '../../domain/engines/progression_engine.dart';
import '../../domain/models.dart';
import '../../domain/views.dart';
import '../db/database.dart';

class UserProfileData {
  const UserProfileData({required this.birthDate, required this.sex});
  final DateTime birthDate;
  final String sex;
}

class AppRepository {
  AppRepository(this.db);
  final AppDatabase db;

  static const _engine = ProgressionEngine();

  // ---------------------------------------------------------------- Profil

  Stream<UserProfileData?> watchProfile() =>
      db.select(db.userProfiles).watchSingleOrNull().map((r) => r == null
          ? null
          : UserProfileData(birthDate: parseDateKey(r.birthDate), sex: r.sex));

  Future<void> saveProfile(DateTime birthDate, String sex) =>
      db.into(db.userProfiles).insertOnConflictUpdate(
            UserProfilesCompanion.insert(
                id: const Value(1),
                birthDate: dateKey(birthDate),
                sex: sex),
          );

  // ------------------------------------------------------------- Einstellungen

  Future<String?> getSetting(String key) async {
    final row = await (db.select(db.appSettings)
          ..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> setSetting(String key, String value) =>
      db.into(db.appSettings).insertOnConflictUpdate(
          AppSettingsCompanion.insert(key: key, value: value));

  // ------------------------------------------------------------------ Plan

  /// Gesamter Wochenplan (Mo–So), sortiert nach Wochentag.
  Future<List<DayInfo>> loadPlan() async {
    final days = await (db.select(db.planDays)
          ..orderBy([(t) => OrderingTerm.asc(t.weekday)]))
        .get();
    final rows = await (db.select(db.planSlots).join([
      innerJoin(db.exercises,
          db.exercises.id.equalsExp(db.planSlots.exerciseId)),
    ])
          ..orderBy([OrderingTerm.asc(db.planSlots.orderIdx)]))
        .get();

    final byDay = <int, List<SlotInfo>>{};
    for (final r in rows) {
      final s = r.readTable(db.planSlots);
      final e = r.readTable(db.exercises);
      byDay.putIfAbsent(s.planDayId, () => []).add(SlotInfo(
            slotId: s.id,
            exerciseId: e.id,
            exerciseKey: e.key,
            exerciseName: e.name,
            loadType: LoadType.values.byName(e.loadType),
            targetSets: s.targetSets,
            repMin: s.repMin,
            repMax: s.repMax,
            rirMin: s.rirMin,
            rirMax: s.rirMax,
            progReps: s.progReps,
            progSets: s.progSets,
          ));
    }
    return [
      for (final d in days)
        DayInfo(
          id: d.id,
          weekday: d.weekday,
          name: d.name,
          isRest: d.isRestDay,
          slots: byDay[d.id] ?? const [],
        ),
    ];
  }

  // -------------------------------------------------------------- Sessions

  SessionInfo _toSession(WorkoutSession s) => SessionInfo(
        id: s.id,
        planDayId: s.planDayId,
        planned: parseDateKey(s.plannedDate),
        performed:
            s.performedDate == null ? null : parseDateKey(s.performedDate!),
        status: SessionStatus.values.byName(s.status),
        note: s.note,
      );

  /// Alle Einheiten, deren *geplanter* Tag in [from]..[to] liegt.
  Stream<List<SessionInfo>> watchSessionsPlannedBetween(
      DateTime from, DateTime to) {
    final q = db.select(db.workoutSessions)
      ..where((t) => t.plannedDate.isBetweenValues(dateKey(from), dateKey(to)));
    return q.watch().map((rows) => rows.map(_toSession).toList());
  }

  /// Einheiten, die an [day] tatsächlich durchgeführt wurden.
  Stream<List<SessionInfo>> watchSessionsPerformedOn(DateTime day) {
    final q = db.select(db.workoutSessions)
      ..where((t) =>
          t.performedDate.equals(dateKey(day)) & t.status.equals('done'));
    return q.watch().map((rows) => rows.map(_toSession).toList());
  }

  Future<SessionInfo?> sessionForPlannedDate(DateTime planned) async {
    final row = await (db.select(db.workoutSessions)
          ..where((t) => t.plannedDate.equals(dateKey(planned))))
        .getSingleOrNull();
    return row == null ? null : _toSession(row);
  }

  /// Gespeicherte Ergebnisse (je Slot) einer Einheit.
  Future<Map<int, SlotResult>> resultsForSession(int sessionId) async {
    final ses = await (db.select(db.sessionExercises)
          ..where((t) => t.sessionId.equals(sessionId)))
        .get();
    final out = <int, SlotResult>{};
    for (final se in ses) {
      out[se.slotId] = await _toResult(se);
    }
    return out;
  }

  Future<SlotResult> _toResult(SessionExercise se, {DateTime? date}) async {
    final sets = await (db.select(db.setLogs)
          ..where((t) => t.sessionExerciseId.equals(se.id))
          ..orderBy([(t) => OrderingTerm.asc(t.setNo)]))
        .get();
    return SlotResult(
      slotId: se.slotId,
      sets: [
        for (final s in sets)
          SetResult(weight: s.weight, reps: s.reps, rir: s.rir)
      ],
      action: ProgressionAction.values.byName(se.progressionResult),
      message: se.progressionMessage,
      e1rm: se.e1rmBest,
      volume: se.volume,
      topWeight: se.topWeight,
      bodyweight: se.bodyweightKg,
      date: date,
    );
  }

  /// Letzte erledigte Einheit dieses Slots (für Hinweise und Gewichts-Vorbelegung).
  Future<SlotResult?> lastResultForSlot(int slotId, {int? excludeSessionId}) async {
    final results = await _recentSlotRows(slotId, 1, excludeSessionId);
    if (results.isEmpty) return null;
    return _toResult(results.first.$1, date: results.first.$2);
  }

  Future<List<(SessionExercise, DateTime)>> _recentSlotRows(
      int slotId, int limit, int? excludeSessionId) async {
    final q = db.select(db.sessionExercises).join([
      innerJoin(db.workoutSessions,
          db.workoutSessions.id.equalsExp(db.sessionExercises.sessionId)),
    ])
      ..where(db.sessionExercises.slotId.equals(slotId) &
          db.workoutSessions.status.equals('done'))
      ..orderBy([
        OrderingTerm.desc(db.workoutSessions.performedDate),
        OrderingTerm.desc(db.workoutSessions.id),
      ])
      ..limit(limit + 1);
    final rows = await q.get();
    final out = <(SessionExercise, DateTime)>[];
    for (final r in rows) {
      final s = r.readTable(db.workoutSessions);
      if (s.id == excludeSessionId) continue;
      out.add((
        r.readTable(db.sessionExercises),
        parseDateKey(s.performedDate ?? s.plannedDate)
      ));
      if (out.length == limit) break;
    }
    return out;
  }

  /// Zahl direkt vorangehender gescheiterter Einheiten dieses Slots.
  Future<int> _failureStreak(SlotInfo slot, int? excludeSessionId) async {
    final rows = await _recentSlotRows(
        slot.slotId, _engine.deloadAfterFailures - 1, excludeSessionId);
    var streak = 0;
    for (final (se, _) in rows) {
      final r = await _toResult(se);
      if (ProgressionEngine.isFailure(slot.rule, r.sets)) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  /// Speichert eine Einheit (neu oder überschreibend) und berechnet für jeden
  /// Slot e1RM, Volumen und Progressions-Empfehlung.
  ///
  /// Sätze mit 0 Wiederholungen gelten als nicht erfasst und werden ignoriert.
  Future<Map<int, SlotResult>> saveSession({
    required DayInfo day,
    required DateTime planned,
    required DateTime performed,
    required Map<int, List<SetResult>> setsBySlot,
  }) async {
    // Streaks vorab außerhalb der Transaktion lesen.
    final existing = await sessionForPlannedDate(planned);
    final streaks = <int, int>{
      for (final slot in day.slots)
        slot.slotId: await _failureStreak(slot, existing?.id),
    };

    // Körpergewicht für Dip/Pullup: letzte Messung am oder vor dem Trainingstag.
    final bodyweight = await bodyweightAtOrBefore(performed);

    return db.transaction(() async {
      final sessionId = await _upsertSession(
        WorkoutSessionsCompanion.insert(
          planDayId: day.id,
          plannedDate: dateKey(planned),
          performedDate: Value(dateKey(performed)),
          status: SessionStatus.done.name,
        ),
      );
      await _deleteSessionExercises(sessionId);

      final results = <int, SlotResult>{};
      for (final slot in day.slots) {
        final sets = (setsBySlot[slot.slotId] ?? const <SetResult>[])
            .where((s) => s.reps > 0)
            .toList();
        if (sets.isEmpty) continue;

        final rec = _engine.evaluate(slot.rule, sets,
            previousFailureStreak: streaks[slot.slotId] ?? 0);
        final usesBw = slot.loadType == LoadType.addedBodyweight;
        final bw = usesBw ? bodyweight : null;
        final e1rm = E1rmCalculator.bestForLoad(sets, slot.loadType,
            bodyweight: bw);
        final volume = E1rmCalculator.volume(sets);
        final top = sets.map((s) => s.weight).reduce((a, b) => a > b ? a : b);

        final seId = await db.into(db.sessionExercises).insert(
              SessionExercisesCompanion.insert(
                sessionId: sessionId,
                slotId: slot.slotId,
                exerciseId: slot.exerciseId,
                topWeight: top,
                e1rmBest: e1rm,
                bodyweightKg: Value(bw),
                volume: volume,
                progressionResult: rec.action.name,
                progressionMessage: rec.message,
              ),
            );
        for (var i = 0; i < sets.length; i++) {
          await db.into(db.setLogs).insert(SetLogsCompanion.insert(
                sessionExerciseId: seId,
                setNo: i + 1,
                reps: sets[i].reps,
                weight: sets[i].weight,
                rir: Value(sets[i].rir),
              ));
        }
        results[slot.slotId] = SlotResult(
          slotId: slot.slotId,
          sets: sets,
          action: rec.action,
          message: rec.message,
          e1rm: e1rm,
          volume: volume,
          topWeight: top,
          bodyweight: bw,
        );
      }
      return results;
    });
  }

  Future<void> _deleteSessionExercises(int sessionId) async {
    final ses = await (db.select(db.sessionExercises)
          ..where((t) => t.sessionId.equals(sessionId)))
        .get();
    for (final se in ses) {
      await (db.delete(db.setLogs)
            ..where((t) => t.sessionExerciseId.equals(se.id)))
          .go();
    }
    await (db.delete(db.sessionExercises)
          ..where((t) => t.sessionId.equals(sessionId)))
        .go();
  }

  /// Markiert eine geplante Einheit als „nicht durchgeführt“.
  Future<void> markSkipped(DayInfo day, DateTime planned) async {
    await db.transaction(() async {
      final id = await _upsertSession(
        WorkoutSessionsCompanion.insert(
          planDayId: day.id,
          plannedDate: dateKey(planned),
          performedDate: const Value(null),
          status: SessionStatus.skipped.name,
        ),
      );
      await _deleteSessionExercises(id);
    });
  }

  /// Legt eine Einheit an oder aktualisiert sie (Schlüssel: geplanter Tag) und
  /// liefert die Zeilen-ID. `insertOnConflictUpdate` würde nur auf `id` prüfen.
  Future<int> _upsertSession(WorkoutSessionsCompanion row) async {
    await db.into(db.workoutSessions).insert(
          row,
          onConflict: DoUpdate((_) => row,
              target: [db.workoutSessions.plannedDate]),
        );
    return (await (db.select(db.workoutSessions)
              ..where((t) => t.plannedDate.equals(row.plannedDate.value)))
            .getSingle())
        .id;
  }

  /// Setzt eine Einheit zurück auf „offen“ (löscht die Erfassung).
  Future<void> resetSession(DateTime planned) async {
    final existing = await sessionForPlannedDate(planned);
    if (existing == null) return;
    await db.transaction(() async {
      await _deleteSessionExercises(existing.id);
      await (db.delete(db.workoutSessions)
            ..where((t) => t.id.equals(existing.id)))
          .go();
    });
  }

  // --------------------------------------------------------------- Gewicht

  /// Letzte Körpergewichtsmessung am oder vor [day] (sonst `null`).
  Future<double?> bodyweightAtOrBefore(DateTime day) async {
    final row = await (db.select(db.bodyWeightEntries)
          ..where((t) => t.date.isSmallerOrEqualValue(dateKey(day)))
          ..orderBy([(t) => OrderingTerm.desc(t.date)])
          ..limit(1))
        .getSingleOrNull();
    return row?.weightKg;
  }

  /// Alle erledigten Trainingstage einer Übung (aufsteigend). Aktualisiert sich
  /// automatisch, sobald Einheiten gespeichert oder geändert werden.
  Stream<List<ExercisePoint>> watchExercisePoints(String exerciseKey) {
    final q = db.select(db.sessionExercises).join([
      innerJoin(db.workoutSessions,
          db.workoutSessions.id.equalsExp(db.sessionExercises.sessionId)),
      innerJoin(db.exercises,
          db.exercises.id.equalsExp(db.sessionExercises.exerciseId)),
    ])
      ..where(db.exercises.key.equals(exerciseKey) &
          db.workoutSessions.status.equals('done'));
    return q.watch().map((rows) {
      final out = [
        for (final r in rows)
          ExercisePoint(
            date: parseDateKey(r.readTable(db.workoutSessions).performedDate ??
                r.readTable(db.workoutSessions).plannedDate),
            topWeight: r.readTable(db.sessionExercises).topWeight,
            e1rm: r.readTable(db.sessionExercises).e1rmBest,
            volume: r.readTable(db.sessionExercises).volume,
          )
      ]..sort((a, b) => a.date.compareTo(b.date));
      return out;
    });
  }

  /// Bester e1RM je Übung (Schlüssel = Exercise.key) seit [since],
  /// nur aus erledigten Einheiten.
  Future<Map<String, double>> bestE1rmByExerciseSince(DateTime since) async {
    final q = db.select(db.sessionExercises).join([
      innerJoin(db.workoutSessions,
          db.workoutSessions.id.equalsExp(db.sessionExercises.sessionId)),
      innerJoin(db.exercises,
          db.exercises.id.equalsExp(db.sessionExercises.exerciseId)),
    ])
      ..where(db.workoutSessions.status.equals('done') &
          db.workoutSessions.performedDate.isBiggerOrEqualValue(dateKey(since)));
    final out = <String, double>{};
    for (final r in await q.get()) {
      final key = r.readTable(db.exercises).key;
      final v = r.readTable(db.sessionExercises).e1rmBest;
      if (v > (out[key] ?? 0)) out[key] = v;
    }
    return out;
  }

  Stream<List<BodyWeightEntry>> watchWeights() => (db.select(db.bodyWeightEntries)
        ..orderBy([(t) => OrderingTerm.desc(t.date)]))
      .watch();

  Stream<BodyWeightEntry?> watchWeightOn(DateTime day) =>
      (db.select(db.bodyWeightEntries)..where((t) => t.date.equals(dateKey(day))))
          .watchSingleOrNull();

  Future<BodyWeightEntry?> weightOn(DateTime day) =>
      (db.select(db.bodyWeightEntries)..where((t) => t.date.equals(dateKey(day))))
          .getSingleOrNull();

  Future<void> saveWeight(DateTime day, double kg) {
    final row = BodyWeightEntriesCompanion.insert(
      date: dateKey(day),
      weightKg: kg,
      measuredAtMs: DateTime.now().millisecondsSinceEpoch,
    );
    return db.into(db.bodyWeightEntries).insert(row,
        onConflict:
            DoUpdate((_) => row, target: [db.bodyWeightEntries.date]));
  }

  Future<void> deleteWeight(DateTime day) => (db.delete(db.bodyWeightEntries)
        ..where((t) => t.date.equals(dateKey(day))))
      .go();

  // ---------------------------------------------------------------- Backup

  static const backupFormat = 'overview-backup';
  static const backupVersion = 1;

  Future<String> exportJson() async {
    final data = <String, dynamic>{
      'format': backupFormat,
      'version': backupVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'userProfiles': [for (final r in await db.select(db.userProfiles).get()) r.toJson()],
      'appSettings': [for (final r in await db.select(db.appSettings).get()) r.toJson()],
      'exercises': [for (final r in await db.select(db.exercises).get()) r.toJson()],
      'planDays': [for (final r in await db.select(db.planDays).get()) r.toJson()],
      'planSlots': [for (final r in await db.select(db.planSlots).get()) r.toJson()],
      'workoutSessions': [for (final r in await db.select(db.workoutSessions).get()) r.toJson()],
      'sessionExercises': [for (final r in await db.select(db.sessionExercises).get()) r.toJson()],
      'setLogs': [for (final r in await db.select(db.setLogs).get()) r.toJson()],
      'bodyWeightEntries': [for (final r in await db.select(db.bodyWeightEntries).get()) r.toJson()],
    };
    return const JsonEncoder.withIndent(' ').convert(data);
  }

  /// Ersetzt **alle** Daten durch den Inhalt der Sicherung.
  /// Wirft [FormatException] bei ungültigen Dateien (dann bleibt alles unverändert).
  Future<void> importJson(String json) async {
    final Map<String, dynamic> data;
    try {
      data = jsonDecode(json) as Map<String, dynamic>;
    } catch (_) {
      throw const FormatException('Keine gültige Sicherungsdatei.');
    }
    if (data['format'] != backupFormat) {
      throw const FormatException('Das ist keine Overview-Sicherung.');
    }
    if ((data['version'] as int? ?? 0) > backupVersion) {
      throw const FormatException(
          'Die Sicherung stammt von einer neueren App-Version.');
    }

    List<Map<String, dynamic>> list(String k) =>
        ((data[k] as List?) ?? const []).cast<Map<String, dynamic>>();

    // Zuerst alles parsen: schlägt das fehl, wird nichts gelöscht.
    final profiles = list('userProfiles').map(UserProfile.fromJson).toList();
    final settings = list('appSettings').map(AppSetting.fromJson).toList();
    final exs = list('exercises').map(Exercise.fromJson).toList();
    final days = list('planDays').map(PlanDay.fromJson).toList();
    final slots = list('planSlots').map(PlanSlot.fromJson).toList();
    final sessions = list('workoutSessions').map(WorkoutSession.fromJson).toList();
    final ses = list('sessionExercises').map(SessionExercise.fromJson).toList();
    final sets = list('setLogs').map(SetLog.fromJson).toList();
    final weights = list('bodyWeightEntries').map(BodyWeightEntry.fromJson).toList();

    await db.transaction(() async {
      await db.delete(db.setLogs).go();
      await db.delete(db.sessionExercises).go();
      await db.delete(db.workoutSessions).go();
      await db.delete(db.bodyWeightEntries).go();
      await db.delete(db.planSlots).go();
      await db.delete(db.planDays).go();
      await db.delete(db.exercises).go();
      await db.delete(db.userProfiles).go();
      await db.delete(db.appSettings).go();

      await db.batch((b) {
        b.insertAll(db.userProfiles, profiles);
        b.insertAll(db.appSettings, settings);
        b.insertAll(db.exercises, exs);
        b.insertAll(db.planDays, days);
        b.insertAll(db.planSlots, slots);
        b.insertAll(db.workoutSessions, sessions);
        b.insertAll(db.sessionExercises, ses);
        b.insertAll(db.setLogs, sets);
        b.insertAll(db.bodyWeightEntries, weights);
      });
    });
    // Falls die Sicherung ohne Plan kam, Plan neu anlegen.
    await db.seedPlan();
  }
}
