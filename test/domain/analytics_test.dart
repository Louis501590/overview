import 'package:flutter_test/flutter_test.dart';
import 'package:overview/domain/date_utils.dart';
import 'package:overview/domain/engines/analytics.dart';
import 'package:overview/domain/engines/goal_engine.dart';
import 'package:overview/domain/engines/insights.dart';

ExercisePoint pt(DateTime d, double w, double e, [double v = 100]) =>
    ExercisePoint(date: d, topWeight: w, e1rm: e, volume: v);

void main() {
  final today = DateTime(2026, 11, 17);

  group('Zeitreihen', () {
    final points = [
      pt(DateTime(2025, 1, 6), 40, 50),
      pt(DateTime(2026, 8, 3), 45, 55),
      pt(DateTime(2026, 10, 20), 50, 60, 300),
      pt(DateTime(2026, 11, 3), 52.5, 62, 400),
      pt(DateTime(2026, 11, 10), 55, 64, 500),
    ];

    test('Zeitraum filtert korrekt (Monat = 30 Tage)', () {
      final s = StrengthAnalytics.inRange(points, AnalysisRange.month, today);
      // 20.10. (28 Tage zurück), 3.11. und 10.11.; 3.8. liegt außerhalb.
      expect(s.length, 3);
      expect(StrengthAnalytics.inRange(points, AnalysisRange.all, today).length, 5);
    });

    test('Monat: je Einheit, 3 Monate: wochenweise', () {
      final m = StrengthAnalytics.series(
          points, AnalysisRange.month, AnalysisMetric.e1rm, today);
      expect(m.bucket, Bucket.day);
      expect(m.points.map((p) => p.value), [60, 62, 64]);
      final q = StrengthAnalytics.series(
          points, AnalysisRange.threeMonths, AnalysisMetric.e1rm, today);
      expect(q.bucket, Bucket.week);
      expect(q.points.map((p) => p.value), [60, 62, 64]);
    });

    test('Schwerer und leichter Tag einer Woche: Wochenbestwert, kein Zacken', () {
      final p = [
        pt(DateTime(2026, 11, 3), 50, 70), // Di schwer
        pt(DateTime(2026, 11, 5), 35, 55), // Do leicht
        pt(DateTime(2026, 11, 10), 52, 73),
        pt(DateTime(2026, 11, 12), 36, 56),
      ];
      final s = StrengthAnalytics.series(
          p, AnalysisRange.threeMonths, AnalysisMetric.e1rm, today);
      expect(s.points.map((e) => e.value), [70, 73]);
    });

    test('12 Monate: wochenweise, Gesamt über 400 Tage: monatsweise', () {
      expect(
          StrengthAnalytics.series(points, AnalysisRange.twelveMonths,
                  AnalysisMetric.e1rm, today)
              .bucket,
          Bucket.week);
      expect(
          StrengthAnalytics.series(
                  points, AnalysisRange.all, AnalysisMetric.e1rm, today)
              .bucket,
          Bucket.month);
    });

    test('e1RM-Reihe lässt Einheiten ohne e1RM (0) aus, Gewicht und Volumen nicht', () {
      final p = [
        pt(DateTime(2026, 11, 3), 50, 70, 500), // Di Maximalkraft
        pt(DateTime(2026, 11, 5), 35, 0, 900), // Do Hypertrophie, kein e1RM
        pt(DateTime(2026, 11, 10), 52, 73, 520),
      ];
      final e = StrengthAnalytics.series(
          p, AnalysisRange.month, AnalysisMetric.e1rm, today);
      expect(e.points.map((x) => x.value), [70, 73]);
      final v = StrengthAnalytics.series(
          p, AnalysisRange.month, AnalysisMetric.volume, today);
      expect(v.points.map((x) => x.value), [500, 900, 520]);
    });

    test('Volumen wird je Bucket summiert, Gewicht = Maximum', () {
      final p = [
        pt(DateTime(2026, 11, 2), 50, 60, 100), // Mo
        pt(DateTime(2026, 11, 5), 55, 62, 200), // Do, gleiche Woche
      ];
      final vol = StrengthAnalytics.series(
          p, AnalysisRange.sixMonths, AnalysisMetric.volume, today);
      expect(vol.bucket, Bucket.week);
      expect(vol.points.single.value, 300);
      final w = StrengthAnalytics.series(
          p, AnalysisRange.sixMonths, AnalysisMetric.weight, today);
      expect(w.points.single.value, 55);
    });

    test('Leere Daten und Zukunft werden ignoriert', () {
      expect(StrengthAnalytics.series([], AnalysisRange.all, AnalysisMetric.e1rm, today).points,
          isEmpty);
      final future = [pt(DateTime(2026, 12, 1), 60, 70)];
      expect(StrengthAnalytics.inRange(future, AnalysisRange.all, today), isEmpty);
    });
  });

  group('Rekorde', () {
    test('Höchstes Gewicht und höchster e1RM mit erstem Datum', () {
      final r = RecordsEngine.compute([
        pt(DateTime(2026, 11, 10), 55, 64),
        pt(DateTime(2026, 11, 3), 52.5, 62),
        pt(DateTime(2026, 11, 17), 55, 63), // gleiches Gewicht später
      ]);
      expect(r.maxWeight!.value, 55);
      expect(r.maxWeight!.date, DateTime(2026, 11, 10));
      expect(r.maxE1rm!.value, 64);
      expect(r.maxE1rm!.date, DateTime(2026, 11, 10));
    });

    test('Ohne Daten: keine Rekorde', () {
      final r = RecordsEngine.compute([]);
      expect(r.maxWeight, isNull);
      expect(r.maxE1rm, isNull);
    });
  });

  group('Ziele', () {
    const dipGoal = GoalDef(
        exerciseKey: 'weighted_dip', title: 'Weighted Dip', targetKg: 100, reps: 3);

    List<ExercisePoint> weekly(int weeks, double start, double perWeek) => [
          for (var i = 0; i < weeks; i++)
            pt(addDays(weekStart(today), -7 * (weeks - 1 - i)), 50,
                start + perWeek * i)
        ];

    test('Umrechnung hin und zurück ist konsistent (mit Körpergewicht)', () {
      final e = GoalEngine.e1rmFor(100, 3, 80);
      expect(e, closeTo(118, 1e-9)); // (80+100)*1.1 - 80
      expect(GoalEngine.addedFor(GoalEngine.e1rmFor(100, 3, 80), 3, 80), closeTo(100, 1e-9));
      expect(GoalEngine.addedFor(GoalEngine.e1rmFor(70, 3, null), 3, null), closeTo(70, 1e-9));
    });

    test('Keine Daten', () {
      final s = GoalEngine.evaluate(goal: dipGoal, points: [], today: today);
      expect(s.state, EtaState.noData);
    });

    test('Stand und Fortschritt: 63,25 kg e1RM bei 82,5 kg KG', () {
      final s = GoalEngine.evaluate(
          goal: dipGoal,
          points: [pt(addDays(today, -3), 50, 63.25)],
          today: today,
          bodyweight: 82.5);
      // Umrechnung auf 3 Wdh.: (63.25+82.5)/1.1 - 82.5 = 50
      expect(s.currentKg, closeTo(50, 0.01));
      expect(s.progress, closeTo(0.5, 0.001));
      expect(s.state, EtaState.notEnoughData); // nur ein Datenpunkt
    });

    test('Ziel erreicht', () {
      final s = GoalEngine.evaluate(
          goal: dipGoal,
          points: [pt(addDays(today, -1), 100, 140)],
          today: today);
      expect(s.state, EtaState.reached);
      expect(s.progress, 1);
    });

    test('Prognose bei gleichmäßigem Anstieg (+1 kg e1RM/Woche)', () {
      // Start 80, +1/Woche über 8 Wochen -> aktuell 87. Ziel-e1RM (ohne KG)
      // = 100*1.1 = 110 -> ca. 23 Wochen.
      final pts = weekly(8, 80, 1);
      final s = GoalEngine.evaluate(goal: dipGoal, points: pts, today: today);
      expect(s.state, EtaState.estimated);
      final weeks = daysBetween(today, s.eta!) / 7;
      expect(weeks, closeTo(23, 2));
    });

    test('Kein Aufwärtstrend / zu weit weg', () {
      final flat = GoalEngine.evaluate(
          goal: dipGoal, points: weekly(8, 90, 0), today: today);
      expect(flat.state, EtaState.noProgress);
      final slow = GoalEngine.evaluate(
          goal: dipGoal, points: weekly(8, 60, 0.1), today: today);
      expect(slow.state, EtaState.tooFar);
    });

    test('Zu wenige Wochen = keine Prognose', () {
      final s = GoalEngine.evaluate(
          goal: dipGoal, points: weekly(3, 80, 1), today: today);
      expect(s.state, EtaState.notEnoughData);
    });

    test('Ausreißer verfälscht die Prognose kaum (Theil-Sen)', () {
      final pts = weekly(8, 80, 1);
      final withOutlier = [
        ...pts.sublist(0, 4),
        pt(pts[4].date, 50, 100), // Ausreißer nach oben (unter dem Ziel von 110)
        ...pts.sublist(5),
      ];
      final s = GoalEngine.evaluate(goal: dipGoal, points: withOutlier, today: today);
      expect(s.state, EtaState.estimated);
    });
  });

  group('Fazit-Texte', () {
    test('Wenig Daten', () {
      expect(
          InsightService.strength(
              exerciseName: 'Weighted Dip', points: [], range: AnalysisRange.month),
          contains('noch keine Einheiten'));
      expect(
          InsightService.strength(
              exerciseName: 'Weighted Dip',
              points: [pt(today, 50, 60)],
              range: AnalysisRange.month),
          contains('erst eine Einheit'));
    });

    test('Fazit vergleicht Wochenbestwerte, nicht die letzte leichte Einheit', () {
      final t = InsightService.strength(
        exerciseName: 'Weighted Dip',
        points: [
          pt(DateTime(2026, 9, 1), 30, 50),  // Di schwer
          pt(DateTime(2026, 9, 3), 20, 40),  // Do leicht
          pt(DateTime(2026, 11, 3), 50, 70), // Di schwer
          pt(DateTime(2026, 11, 5), 35, 55), // Do leicht (letzte Einheit)
        ],
        range: AnalysisRange.threeMonths,
      );
      expect(t, contains('von 30 auf 50 kg')); // Gewicht: Wochenbestwerte
      expect(t, contains('von 50 auf 70 kg')); // e1RM
      expect(t, contains('in den letzten 3 Monaten gestiegen'));
    });

    test('Fazit ignoriert Wochen ohne e1RM', () {
      final t = InsightService.strength(
        exerciseName: 'Weighted Dip',
        points: [
          pt(DateTime(2026, 10, 6), 40, 60),
          pt(DateTime(2026, 10, 8), 30, 0), // Hypertrophie
          pt(DateTime(2026, 10, 13), 30, 0), // nur Hypertrophie in der Woche
          pt(DateTime(2026, 11, 3), 50, 75),
        ],
        range: AnalysisRange.threeMonths,
      );
      expect(t, contains('von 60 auf 75 kg'));
    });

    test('Ohne e1RM-Daten: Hinweis auf 6-Wdh.-Regel', () {
      final t = InsightService.strength(
        exerciseName: 'Weighted Dip',
        points: [pt(DateTime(2026, 10, 6), 30, 0), pt(DateTime(2026, 11, 3), 35, 0)],
        range: AnalysisRange.threeMonths,
      );
      expect(t, contains('höchstens 6 Wiederholungen'));
    });

    test('Nur eine Trainingswoche', () {
      final t = InsightService.strength(
        exerciseName: 'Weighted Dip',
        points: [pt(DateTime(2026, 11, 3), 50, 70), pt(DateTime(2026, 11, 5), 35, 55)],
        range: AnalysisRange.month,
      );
      expect(t, contains('einer Trainingswoche'));
    });

    test('Anstieg wird benannt', () {
      final t = InsightService.strength(
        exerciseName: 'Weighted Dip',
        points: [
          pt(DateTime(2026, 9, 1), 40, 50, 400),
          pt(DateTime(2026, 11, 1), 50, 60, 450),
        ],
        range: AnalysisRange.threeMonths,
      );
      expect(t, contains('gestiegen'));
      expect(t, contains('+10'));
      expect(t, contains('+20 %'));
      expect(t, contains('Weiter so'));
    });

    test('Rückgang empfiehlt Prüfung der Erholung', () {
      final t = InsightService.strength(
        exerciseName: 'Back Squat',
        points: [
          pt(DateTime(2026, 9, 1), 100, 120),
          pt(DateTime(2026, 11, 1), 90, 105),
        ],
        range: AnalysisRange.all,
      );
      expect(t, contains('gesunken'));
      expect(t, contains('Erholung'));
    });

    test('Plateau', () {
      final t = InsightService.strength(
        exerciseName: 'Back Squat',
        points: [
          pt(DateTime(2026, 9, 1), 100, 120),
          pt(DateTime(2026, 11, 1), 100, 120.5),
        ],
        range: AnalysisRange.all,
      );
      expect(t, contains('Plateau'));
    });

    test('ETA-Texte', () {
      expect(
          InsightService.eta(GoalStatus(
              state: EtaState.estimated, eta: DateTime(2028, 3, 10))),
          'Voraussichtlich erreicht: März 2028 (Schätzung)');
      expect(InsightService.eta(const GoalStatus(state: EtaState.reached)),
          contains('erreicht'));
    });
  });
}
