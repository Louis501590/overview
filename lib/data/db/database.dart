import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../domain/plan_seed.dart';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  UserProfiles,
  AppSettings,
  Exercises,
  PlanDays,
  PlanSlots,
  WorkoutSessions,
  SessionExercises,
  SetLogs,
  BodyWeightEntries,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ??
            driftDatabase(
              name: 'overview',
              web: DriftWebOptions(
                sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                driftWorker: Uri.parse('drift_worker.js'),
              ),
            ));

  /// Schema-Historie:
  /// * 1: Ersteinführung (V1)
  /// * 2: `session_exercises.bodyweight_kg` (e1RM mit Körpergewicht)
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await seedPlan();
        },
        onUpgrade: (m, from, to) async {
          // Jeder Schritt läuft einzeln, damit auch Sprünge (1 → 3 …) klappen.
          if (from < 2) {
            // Zwischenstände der App haben die Spalte teils schon unter
            // Version 1 angelegt (ohne Versionssprung). Daher erst prüfen.
            final cols = await customSelect("PRAGMA table_info('session_exercises')").get();
            final exists = cols.any((r) => r.read<String>('name') == 'bodyweight_kg');
            if (!exists) {
              await m.addColumn(sessionExercises, sessionExercises.bodyweightKg);
            }
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// Legt Übungen und den Trainingsplan an (nur wenn noch nicht vorhanden).
  Future<void> seedPlan() async {
    final existing = await select(exercises).get();
    if (existing.isNotEmpty) return;
    await transaction(() async {
      final idByKey = <String, int>{};
      for (final e in PlanSeed.exercises) {
        idByKey[e.key] = await into(exercises).insert(ExercisesCompanion.insert(
          key: e.key,
          name: e.name,
          loadType: e.loadType.name,
        ));
      }
      for (final d in PlanSeed.days) {
        final dayId = await into(planDays).insert(PlanDaysCompanion.insert(
          weekday: d.weekday,
          name: d.name,
          isRestDay: d.isRest,
        ));
        var idx = 0;
        for (final s in d.slots) {
          await into(planSlots).insert(PlanSlotsCompanion.insert(
            planDayId: dayId,
            exerciseId: idByKey[s.exerciseKey]!,
            orderIdx: idx++,
            targetSets: s.sets,
            repMin: s.repMin,
            repMax: s.repMax,
            rirMin: Value(s.rirMin),
            rirMax: Value(s.rirMax),
            progReps: s.progReps,
            progSets: s.sets,
          ));
        }
      }
    });
  }
}
