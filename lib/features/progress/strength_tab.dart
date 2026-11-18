import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/format.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/glass.dart';
import '../../domain/date_utils.dart';
import '../../domain/engines/analytics.dart';
import '../../domain/engines/insights.dart';
import '../../domain/models.dart';
import '../../domain/plan_seed.dart';

/// Kraft: Oben eine Übersicht der vier Übungen, darunter die Detailansicht der
/// gewählten Übung (Diagramm, Kennzahlen, Fazit).
class StrengthTab extends ConsumerStatefulWidget {
  const StrengthTab({super.key});

  @override
  ConsumerState<StrengthTab> createState() => _StrengthTabState();
}

class _StrengthTabState extends ConsumerState<StrengthTab> {
  String _key = ExerciseKeys.weightedDip;
  AnalysisRange _range = AnalysisRange.threeMonths;
  AnalysisMetric _metric = AnalysisMetric.e1rm;

  @override
  Widget build(BuildContext context) {
    final ex = PlanSeed.exercises;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Heading(
          'Deine Kraft',
          'Geschätztes Maximum für 1 Wiederholung (e1RM) – Veränderung in den '
              'letzten 3 Monaten.',
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < ex.length; i += 2) ...[
          Row(children: [
            for (var j = i; j < i + 2; j++) ...[
              Expanded(
                child: _LiftCard(
                  exercise: ex[j],
                  selected: ex[j].key == _key,
                  onTap: () => setState(() => _key = ex[j].key),
                ),
              ),
              if (j == i) const SizedBox(width: 12),
            ],
          ]),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 4),
        _Detail(
          exercise: ex.firstWhere((e) => e.key == _key),
          range: _range,
          metric: _metric,
          onRange: (r) => setState(() => _range = r),
          onMetric: (m) => setState(() => _metric = m),
        ),
      ],
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.title, this.subtitle);
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(subtitle,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13, height: 1.3)),
        ],
      );
}

// ---------------------------------------------------------------- Übersicht

class _LiftCard extends ConsumerWidget {
  const _LiftCard(
      {required this.exercise, required this.selected, required this.onTap});
  final ExerciseSeed exercise;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todayProvider);
    final points = ref.watch(exercisePointsProvider(exercise.key)).value ?? const [];
    final s = StrengthAnalytics.series(
        points, AnalysisRange.threeMonths, AnalysisMetric.e1rm, today);
    final vals = s.points;
    final current = vals.isEmpty ? null : vals.last.value;
    final delta = vals.length < 2 ? null : vals.last.value - vals.first.value;

    return GlassCard(
      glow: selected,
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: SizedBox(
        height: 132,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(exercise.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: selected ? AppColors.neon : AppColors.textSecondary)),
            const SizedBox(height: 6),
            Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
              Text(current == null ? '–' : fmtKg(current, maxDecimals: 1),
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w800, height: 1)),
              if (current != null)
                const Text(' kg',
                    style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
            ]),
            const SizedBox(height: 6),
            _DeltaPill(delta: delta, hasData: current != null),
            const Spacer(),
            SizedBox(height: 34, child: _Sparkline(values: [for (final p in vals) p.value])),
          ],
        ),
      ),
    );
  }
}

class _DeltaPill extends StatelessWidget {
  const _DeltaPill({required this.delta, required this.hasData});
  final double? delta;
  final bool hasData;

  @override
  Widget build(BuildContext context) {
    if (!hasData) {
      return const Text('Noch keine Daten',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12));
    }
    if (delta == null) {
      return const Text('Erst 1 Woche',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12));
    }
    final up = delta! > 0.05, down = delta! < -0.05;
    final color =
        up ? AppColors.success : (down ? AppColors.danger : AppColors.textSecondary);
    final text = up
        ? '▲ +${fmtKg(delta!, maxDecimals: 1)} kg'
        : (down ? '▼ −${fmtKg(delta!.abs(), maxDecimals: 1)} kg' : '● unverändert');
    return Text(text,
        style:
            TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700));
  }
}

class _Sparkline extends StatelessWidget {
  const _Sparkline({required this.values});
  final List<double> values;

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) {
      return Align(
        alignment: Alignment.bottomLeft,
        child: Container(
            height: 2, width: 40, color: Colors.white.withValues(alpha: 0.1)),
      );
    }
    final spots = [
      for (var i = 0; i < values.length; i++) FlSpot(i.toDouble(), values[i])
    ];
    final minY = values.reduce((a, b) => a < b ? a : b);
    final maxY = values.reduce((a, b) => a > b ? a : b);
    final pad = (maxY - minY) == 0 ? 1.0 : (maxY - minY) * 0.1;
    return IgnorePointer(
      child: LineChart(LineChartData(
        minY: minY - pad,
        maxY: maxY + pad,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: spots.length > 2,
            preventCurveOverShooting: true,
            color: AppColors.neon,
            barWidth: 2.5,
            dotData: FlDotData(
              show: true,
              checkToShowDot: (s, _) => s == spots.last,
              getDotPainter: (a, b, c, d) => FlDotCirclePainter(
                  radius: 3.5,
                  color: AppColors.neon,
                  strokeWidth: 2,
                  strokeColor: AppColors.navy),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.neon.withValues(alpha: 0.25),
                  AppColors.neon.withValues(alpha: 0)
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}

// ------------------------------------------------------------------- Detail

String _metricName(AnalysisMetric m) => switch (m) {
      AnalysisMetric.e1rm => 'e1RM',
      AnalysisMetric.weight => 'Gewicht',
      AnalysisMetric.volume => 'Volumen',
    };

String _explain(AnalysisMetric m, ExerciseSeed e) {
  final bw = e.loadType == LoadType.addedBodyweight;
  return switch (m) {
    AnalysisMetric.e1rm =>
      'Geschätztes Gewicht für 1 Wiederholung – das beste Maß für deine Kraft. '
          'Berechnet aus Sätzen mit höchstens 6 Wiederholungen'
          '${bw ? ' (als Zusatzgewicht)' : ''}.',
    AnalysisMetric.weight =>
      'Das höchste ${bw ? 'Zusatzgewicht' : 'Gewicht'}, das du trainiert hast.',
    AnalysisMetric.volume =>
      'Gewicht × Wiederholungen aller Sätze zusammen – wie viel du insgesamt '
          'bewegt hast.',
  };
}

String _rangeName(AnalysisRange r) => switch (r) {
      AnalysisRange.month => '1 Mon.',
      AnalysisRange.threeMonths => '3 Mon.',
      AnalysisRange.sixMonths => '6 Mon.',
      AnalysisRange.twelveMonths => '12 Mon.',
      AnalysisRange.all => 'Gesamt',
    };

class _Detail extends ConsumerWidget {
  const _Detail({
    required this.exercise,
    required this.range,
    required this.metric,
    required this.onRange,
    required this.onMetric,
  });
  final ExerciseSeed exercise;
  final AnalysisRange range;
  final AnalysisMetric metric;
  final ValueChanged<AnalysisRange> onRange;
  final ValueChanged<AnalysisMetric> onMetric;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todayProvider);
    final async = ref.watch(exercisePointsProvider(exercise.key));

    return async.when(
      loading: () => const Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: CircularProgressIndicator())),
      error: (e, _) => const GlassCard(
        child: Text(
            'Die Trainingsdaten konnten nicht geladen werden. Starte die App '
            'neu. Bleibt der Fehler, exportiere unter „Mehr“ eine Sicherung.',
            style: TextStyle(color: AppColors.textSecondary)),
      ),
      data: (points) {
        final inRange = StrengthAnalytics.inRange(points, range, today);
        final series = StrengthAnalytics.series(points, range, metric, today);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GlassCard(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(exercise.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  _MetricTabs(selected: metric, onChanged: onMetric),
                  const SizedBox(height: 10),
                  Text(_explain(metric, exercise),
                      style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12.5,
                          height: 1.35)),
                  const SizedBox(height: 14),
                  _RangePills(selected: range, onChanged: onRange),
                  const SizedBox(height: 16),
                  if (series.points.isEmpty)
                    _Empty(metric: metric)
                  else ...[
                    Text(_bucketNote(series, metric),
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                    const SizedBox(height: 8),
                    SizedBox(height: 210, child: _Chart(series: series, metric: metric)),
                  ],
                ],
              ),
            ),
            if (series.points.isNotEmpty) ...[
              const SizedBox(height: 12),
              _StatTiles(series: series, metric: metric),
            ],
            const SizedBox(height: 12),
            _Summary(
              text: InsightService.strength(
                  exerciseName: exercise.name, points: inRange, range: range),
            ),
          ],
        );
      },
    );
  }
}

/// Drei Text-Reiter mit Unterstreichung statt vieler Chips.
class _MetricTabs extends StatelessWidget {
  const _MetricTabs({required this.selected, required this.onChanged});
  final AnalysisMetric selected;
  final ValueChanged<AnalysisMetric> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      for (final m in AnalysisMetric.values)
        Expanded(
          child: InkWell(
            onTap: () => onChanged(m),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 2.5,
                    color: m == selected
                        ? AppColors.neon
                        : Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              child: Text(_metricName(m),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color:
                          m == selected ? AppColors.neon : AppColors.textSecondary)),
            ),
          ),
        ),
    ]);
  }
}

/// Fünf gleich breite Zeitraum-Pillen in einer Zeile (kein seitliches Scrollen).
class _RangePills extends StatelessWidget {
  const _RangePills({required this.selected, required this.onChanged});
  final AnalysisRange selected;
  final ValueChanged<AnalysisRange> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        for (final r in AnalysisRange.values)
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(r),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: r == selected
                      ? AppColors.neon.withValues(alpha: 0.22)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(_rangeName(r),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: r == selected ? FontWeight.w800 : FontWeight.w500,
                        color: r == selected
                            ? AppColors.neon
                            : AppColors.textSecondary)),
              ),
            ),
          ),
      ]),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.metric});
  final AnalysisMetric metric;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Column(children: [
          Icon(Icons.show_chart,
              size: 40, color: AppColors.neon.withValues(alpha: 0.5)),
          const SizedBox(height: 10),
          Text(
            metric == AnalysisMetric.e1rm
                ? 'Noch kein e1RM im gewählten Zeitraum.\nTrage ein Training mit höchstens 6 Wiederholungen pro Satz ein.'
                : 'Im gewählten Zeitraum gibt es noch keine Einheiten.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
          ),
        ]),
      );
}

String _fmt(AnalysisMetric m, double v) => m == AnalysisMetric.volume
    ? '${fmtKg(v, maxDecimals: 0)} kg'
    : '${fmtKg(v, maxDecimals: 1)} kg';

String _bucketNote(Series s, AnalysisMetric m) {
  final sum = m == AnalysisMetric.volume;
  return switch (s.bucket) {
    Bucket.day => 'Jede Trainingseinheit ein Punkt',
    Bucket.week => sum ? 'Summe pro Woche' : 'Bester Wert pro Woche',
    Bucket.month => sum ? 'Summe pro Monat' : 'Bester Wert pro Monat',
  };
}

class _StatTiles extends StatelessWidget {
  const _StatTiles({required this.series, required this.metric});
  final Series series;
  final AnalysisMetric metric;

  @override
  Widget build(BuildContext context) {
    final p = series.points;
    final last = p.last.value;
    final best = p.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final delta = last - p.first.value;
    final hasDelta = p.length >= 2;
    final color = !hasDelta
        ? AppColors.textPrimary
        : (delta > 0.05
            ? AppColors.success
            : (delta < -0.05 ? AppColors.danger : AppColors.textPrimary));

    Widget tile(String label, String value, {Color? c}) => Expanded(
          child: GlassCard(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            child: Column(children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(value,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: c ?? AppColors.textPrimary)),
              ),
              const SizedBox(height: 3),
              Text(label,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12)),
            ]),
          ),
        );

    return Row(children: [
      tile('Zuletzt', _fmt(metric, last)),
      const SizedBox(width: 10),
      tile('Bestwert', _fmt(metric, best)),
      const SizedBox(width: 10),
      tile(
          'Veränderung',
          !hasDelta
              ? '–'
              : '${delta >= 0 ? '+' : '−'}${_fmt(metric, delta.abs())}',
          c: color),
    ]);
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => GlassCard(
        glow: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.neon.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_awesome,
                    size: 16, color: AppColors.neon),
              ),
              const SizedBox(width: 10),
              const Text('Fazit',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            ]),
            const SizedBox(height: 10),
            Text(text, style: const TextStyle(height: 1.45)),
          ],
        ),
      );
}

class _Chart extends StatelessWidget {
  const _Chart({required this.series, required this.metric});
  final Series series;
  final AnalysisMetric metric;

  @override
  Widget build(BuildContext context) {
    final p = series.points;
    final first = p.first.date;
    final spots = [
      for (final e in p) FlSpot(daysBetween(first, e.date).toDouble(), e.value)
    ];
    final ys = spots.map((s) => s.y);
    var minY = ys.reduce((a, b) => a < b ? a : b);
    var maxY = ys.reduce((a, b) => a > b ? a : b);
    final pad = ((maxY - minY) * 0.15).clamp(1.0, double.infinity);
    minY = (minY - pad).clamp(0, double.infinity);
    maxY = maxY + pad;
    final spanX = spots.last.x - spots.first.x;
    final interval = spanX <= 0 ? 1.0 : (spanX / 3).ceilToDouble();

    return LineChart(LineChartData(
      minY: minY,
      maxY: maxY,
      minX: spots.first.x - (spanX == 0 ? 1 : 0),
      maxX: spots.last.x + (spanX == 0 ? 1 : 0),
      gridData: FlGridData(
        drawVerticalLine: false,
        getDrawingHorizontalLine: (_) =>
            FlLine(color: Colors.white.withValues(alpha: 0.06), strokeWidth: 1),
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(),
        rightTitles: const AxisTitles(),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 44,
            minIncluded: false,
            maxIncluded: false,
            getTitlesWidget: (v, meta) => Text(
                fmtKg(v, maxDecimals: metric == AnalysisMetric.volume ? 0 : 1),
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 11)),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 24,
            interval: interval,
            getTitlesWidget: (v, meta) {
              final d = addDays(first, v.round());
              final label = series.bucket == Bucket.month
                  ? '${monthNamesDe[d.month - 1].substring(0, 3)} ${d.year % 100}'
                  : '${d.day}.${d.month}.';
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(label,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 11)),
              );
            },
          ),
        ),
      ),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touched) => [
            for (final t in touched)
              LineTooltipItem(
                '${formatDateDe(addDays(first, t.x.round()))}\n${_fmt(metric, t.y)}',
                const TextStyle(color: Colors.white, fontSize: 12),
              ),
          ],
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: spots.length > 2,
          preventCurveOverShooting: true,
          color: AppColors.neon,
          barWidth: 3,
          dotData: FlDotData(
            show: true,
            checkToShowDot: (s, _) => spots.length <= 24 || s == spots.last,
            getDotPainter: (s, a, b, c) => FlDotCirclePainter(
              radius: s == spots.last ? 5 : 3,
              color: AppColors.neon,
              strokeWidth: s == spots.last ? 2.5 : 0,
              strokeColor: AppColors.navy,
            ),
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.neon.withValues(alpha: 0.30),
                AppColors.neon.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
