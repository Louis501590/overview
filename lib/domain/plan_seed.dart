import 'models.dart';

/// Stabile Schlüssel der vier Übungen.
class ExerciseKeys {
  const ExerciseKeys._();
  static const weightedDip = 'weighted_dip';
  static const weightedPullup = 'weighted_pullup';
  static const backSquat = 'back_squat';
  static const zercherSquat = 'zercher_squat';
}

class ExerciseSeed {
  const ExerciseSeed(this.key, this.name, this.loadType);
  final String key;
  final String name;
  final LoadType loadType;
}

class SlotSeed {
  const SlotSeed({
    required this.exerciseKey,
    required this.sets,
    required this.repMin,
    required this.repMax,
    required this.progReps,
    this.rirMin,
    this.rirMax,
  });
  final String exerciseKey;
  final int sets;
  final int repMin;
  final int repMax;

  /// Wiederholungen, die in *allen* Sätzen erreicht werden müssen.
  final int progReps;
  final int? rirMin;
  final int? rirMax;
}

class DaySeed {
  const DaySeed(this.weekday, this.name, [this.slots = const []]);
  final int weekday; // 1 = Montag … 7 = Sonntag
  final String name;
  final List<SlotSeed> slots;
  bool get isRest => slots.isEmpty;
}

/// Trainingsplan laut Spezifikation (Version 1).
class PlanSeed {
  const PlanSeed._();

  static const exercises = [
    ExerciseSeed(ExerciseKeys.weightedDip, 'Weighted Dip',
        LoadType.addedBodyweight),
    ExerciseSeed(ExerciseKeys.weightedPullup, 'Weighted Pullup',
        LoadType.addedBodyweight),
    ExerciseSeed(ExerciseKeys.backSquat, 'Back Squat', LoadType.external),
    ExerciseSeed(ExerciseKeys.zercherSquat, 'Zercher Squat', LoadType.external),
  ];

  static const days = [
    DaySeed(1, 'Legs', [
      SlotSeed(
          exerciseKey: ExerciseKeys.backSquat,
          sets: 2,
          repMin: 4,
          repMax: 6,
          progReps: 6),
      SlotSeed(
          exerciseKey: ExerciseKeys.zercherSquat,
          sets: 2,
          repMin: 4,
          repMax: 6,
          progReps: 6),
    ]),
    DaySeed(2, 'Push Max Strength', [
      SlotSeed(
          exerciseKey: ExerciseKeys.weightedDip,
          sets: 3,
          repMin: 3,
          repMax: 5,
          progReps: 5,
          rirMin: 1,
          rirMax: 2),
    ]),
    DaySeed(3, 'Rest Day'),
    DaySeed(4, 'Upper Hypertrophy', [
      SlotSeed(
          exerciseKey: ExerciseKeys.weightedDip,
          sets: 3,
          repMin: 8,
          repMax: 10,
          progReps: 10),
      SlotSeed(
          exerciseKey: ExerciseKeys.weightedPullup,
          sets: 3,
          repMin: 8,
          repMax: 10,
          progReps: 10),
    ]),
    DaySeed(5, 'Rest Day'),
    DaySeed(6, 'Rest Day'),
    DaySeed(7, 'Pull Max Strength', [
      SlotSeed(
          exerciseKey: ExerciseKeys.weightedPullup,
          sets: 3,
          repMin: 3,
          repMax: 5,
          progReps: 5,
          rirMin: 1,
          rirMax: 2),
    ]),
  ];
}
