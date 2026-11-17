import 'models.dart';

/// Plan-Slot (Übung an einem Tag) inkl. Übungsdaten.
class SlotInfo {
  const SlotInfo({
    required this.slotId,
    required this.exerciseId,
    required this.exerciseKey,
    required this.exerciseName,
    required this.loadType,
    required this.targetSets,
    required this.repMin,
    required this.repMax,
    required this.progReps,
    required this.progSets,
    this.rirMin,
    this.rirMax,
  });

  final int slotId;
  final int exerciseId;
  final String exerciseKey;
  final String exerciseName;
  final LoadType loadType;
  final int targetSets;
  final int repMin;
  final int repMax;
  final int progReps;
  final int progSets;
  final int? rirMin;
  final int? rirMax;

  ProgressionRule get rule => ProgressionRule(
        targetSets: targetSets,
        repMin: repMin,
        repMax: repMax,
        requiredReps: progReps,
        requiredSets: progSets,
        rirMin: rirMin,
        rirMax: rirMax,
      );

  String get repsText => repMin == repMax ? '$repMin' : '$repMin–$repMax';

  /// z. B. „3 Sätze · 3–5 Wdh. · 1–2 RIR“.
  String get targetText {
    final parts = ['$targetSets Sätze', '$repsText Wdh.'];
    if (rirMin != null) {
      parts.add(rirMin == rirMax ? '$rirMin RIR' : '$rirMin–$rirMax RIR');
    }
    return parts.join(' · ');
  }

  String get progressionText => progSets == targetSets
      ? 'Erhöhen, wenn alle $progSets Sätze $progReps Wdh. erreichen.'
      : 'Erhöhen, wenn $progSets Sätze $progReps Wdh. erreichen.';

  String get weightLabel =>
      loadType == LoadType.addedBodyweight ? 'Zusatzgewicht (kg)' : 'Gewicht (kg)';
}

class DayInfo {
  const DayInfo({
    required this.id,
    required this.weekday,
    required this.name,
    required this.isRest,
    required this.slots,
  });
  final int id;
  final int weekday;
  final String name;
  final bool isRest;
  final List<SlotInfo> slots;
}

class SessionInfo {
  const SessionInfo({
    required this.id,
    required this.planDayId,
    required this.planned,
    required this.status,
    this.performed,
    this.note,
  });
  final int id;
  final int planDayId;
  final DateTime planned;
  final DateTime? performed;
  final SessionStatus status;
  final String? note;
}

/// Ergebnis einer Übung einer gespeicherten Einheit.
class SlotResult {
  const SlotResult({
    required this.slotId,
    required this.sets,
    required this.action,
    required this.message,
    required this.e1rm,
    required this.volume,
    required this.topWeight,
    this.bodyweight,
    this.date,
  });
  final int slotId;
  final List<SetResult> sets;
  final ProgressionAction action;
  final String message;
  final double e1rm;
  final double volume;
  final double topWeight;

  /// Körpergewicht, das in den e1RM eingeflossen ist (Dip/Pullup), sonst null.
  final double? bodyweight;

  /// Tatsächliches Trainingsdatum (nur bei geladenen Historien-Ergebnissen).
  final DateTime? date;

  String get titleDe => ProgressionRecommendation(action, message).titleDe;
}
