import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:overview/data/db/database.dart';
import 'package:overview/data/repositories/app_repository.dart';

/// Bildet das **Schema 1** (V1, vor der Spalte `bodyweight_kg`) nach und legt
/// Beispieldaten an. So wird geprüft, dass bestehende Geräte beim App-Update
/// ihre Daten behalten und nicht an „no such column“ scheitern.
void _createSchemaV1(dynamic raw, {bool withBodyweightColumn = false}) {
  raw.execute('''
    CREATE TABLE exercises (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      "key" TEXT NOT NULL UNIQUE, name TEXT NOT NULL, load_type TEXT NOT NULL)''');
  raw.execute('''
    CREATE TABLE workout_sessions (
      id INTEGER PRIMARY KEY AUTOINCREMENT, plan_day_id INTEGER NOT NULL,
      planned_date TEXT NOT NULL UNIQUE, performed_date TEXT,
      status TEXT NOT NULL, note TEXT)''');
  raw.execute('''
    CREATE TABLE session_exercises (
      id INTEGER PRIMARY KEY AUTOINCREMENT, session_id INTEGER NOT NULL,
      slot_id INTEGER NOT NULL, exercise_id INTEGER NOT NULL,
      top_weight REAL NOT NULL, e1rm_best REAL NOT NULL, volume REAL NOT NULL,
      ${withBodyweightColumn ? 'bodyweight_kg REAL NULL,' : ''}
      progression_result TEXT NOT NULL, progression_message TEXT NOT NULL)''');
  raw.execute(
      "INSERT INTO exercises VALUES (1,'weighted_dip','Weighted Dip','addedBodyweight')");
  raw.execute(
      "INSERT INTO workout_sessions VALUES (1,2,'2026-11-17','2026-11-17','done',NULL)");
  raw.execute(
      'INSERT INTO session_exercises (id, session_id, slot_id, exercise_id, '
      'top_weight, e1rm_best, volume, progression_result, progression_message) '
      "VALUES (1,1,1,1,50.0,58.3,750.0,'hold','alt')");
  raw.execute('PRAGMA user_version = 1');
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  test('Update von Schema 1 auf 2: Spalte wird ergänzt, Daten bleiben', () async {
    final db = AppDatabase(NativeDatabase.memory(setup: _createSchemaV1));
    final repo = AppRepository(db);

    // Die Abfragen der neuen App funktionieren auf der alten Datenbank.
    final points = await repo.watchExercisePoints('weighted_dip').first;
    expect(points, hasLength(1));
    expect(points.single.e1rm, 58.3);
    expect(points.single.topWeight, 50);

    final best = await repo.bestE1rmByExerciseSince(DateTime(2026, 1, 1));
    expect(best['weighted_dip'], 58.3);

    final cols = await db
        .customSelect("PRAGMA table_info('session_exercises')")
        .get();
    expect(cols.map((r) => r.read<String>('name')), contains('bodyweight_kg'));

    // Alte Zeilen haben kein Körpergewicht (null).
    final se = await db.select(db.sessionExercises).getSingle();
    expect(se.bodyweightKg, isNull);
    await db.close();
  });

  test('Zwischenstand: Version 1 mit bereits vorhandener Spalte (kein Absturz)',
      () async {
    final db = AppDatabase(NativeDatabase.memory(
        setup: (raw) => _createSchemaV1(raw, withBodyweightColumn: true)));
    final repo = AppRepository(db);
    final points = await repo.watchExercisePoints('weighted_dip').first;
    expect(points.single.e1rm, 58.3);
    final cols = await db
        .customSelect("PRAGMA table_info('session_exercises')")
        .get();
    expect(
        cols.where((r) => r.read<String>('name') == 'bodyweight_kg'), hasLength(1));
    await db.close();
  });

  test('Neue Datenbank startet direkt mit Schema 2', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final cols = await db
        .customSelect("PRAGMA table_info('session_exercises')")
        .get();
    expect(cols.map((r) => r.read<String>('name')), contains('bodyweight_kg'));
    expect(db.schemaVersion, 2);
    await db.close();
  });
}
