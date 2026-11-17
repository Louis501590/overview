import 'package:drift/drift.dart';

class UserProfiles extends Table {
  IntColumn get id => integer()(); // Singleton: immer 1
  TextColumn get birthDate => text()(); // YYYY-MM-DD
  TextColumn get sex => text()(); // 'male' | 'female'
  @override
  Set<Column> get primaryKey => {id};
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  @override
  Set<Column> get primaryKey => {key};
}

class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().unique()();
  TextColumn get name => text()();
  TextColumn get loadType => text()(); // 'external' | 'addedBodyweight'
}

class PlanDays extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get weekday => integer().unique()(); // 1 = Montag
  TextColumn get name => text()();
  BoolColumn get isRestDay => boolean()();
}

/// Plan-Slot = Übung an einem Tag. Hier hängt die Progression.
class PlanSlots extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get planDayId => integer().references(PlanDays, #id)();
  IntColumn get exerciseId => integer().references(Exercises, #id)();
  IntColumn get orderIdx => integer()();
  IntColumn get targetSets => integer()();
  IntColumn get repMin => integer()();
  IntColumn get repMax => integer()();
  IntColumn get rirMin => integer().nullable()();
  IntColumn get rirMax => integer().nullable()();
  IntColumn get progReps => integer()();
  IntColumn get progSets => integer()();
}

@TableIndex(name: 'idx_sessions_planned', columns: {#plannedDate})
class WorkoutSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get planDayId => integer().references(PlanDays, #id)();
  TextColumn get plannedDate => text().unique()(); // geplanter Tag
  TextColumn get performedDate => text().nullable()(); // tatsächlicher Tag
  TextColumn get status => text()(); // open | done | skipped
  TextColumn get note => text().nullable()();
}

@TableIndex(name: 'idx_se_exercise', columns: {#exerciseId})
class SessionExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(WorkoutSessions, #id)();
  IntColumn get slotId => integer().references(PlanSlots, #id)();
  IntColumn get exerciseId => integer().references(Exercises, #id)();
  RealColumn get topWeight => real()();
  RealColumn get e1rmBest => real()();
  RealColumn get volume => real()();
  TextColumn get progressionResult => text()(); // increase | hold | deload
  TextColumn get progressionMessage => text()();
}

@TableIndex(name: 'idx_sets_se', columns: {#sessionExerciseId})
class SetLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionExerciseId =>
      integer().references(SessionExercises, #id)();
  IntColumn get setNo => integer()();
  IntColumn get reps => integer()();
  RealColumn get weight => real()();
  IntColumn get rir => integer().nullable()();
}

class BodyWeightEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text().unique()(); // YYYY-MM-DD, ein Eintrag pro Tag
  RealColumn get weightKg => real()();
  IntColumn get measuredAtMs => integer()();
}
