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
import '../../domain/plan_seed.dart';

/// Kraftentwicklung: Trainingsgewicht, e1RM und Volumen je Übung und Zeitraum.
class StrengthTab extends ConsumerStatefulWidget {
  const StrengthTab({super.key});

  @override
  ConsumerState<StrengthTab> createState() => _StrengthTabState();
}

class _StrengthTabState extends ConsumerState<StrengthTab> {
  String _key = ExerciseKeys.weightedDip;
  AnalysisRange _range = AnalysisRange.threeMonths;
  AnalysisMetric _metric = AnalysisMetric.e1rm;

  static String _short(AnalysisMetric m) => switch (m) {
        AnalysisMetric.weight => 'Gewicht',
        AnalysisMetric.e1rm => 'e1RM',
        AnalysisMetric.volume => 'Volumen',
      };

  Widget _chip(String label, bool selected, VoidCallback onTap) => ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        showCheckmark: false,
        selectedColor: AppColors.neon.withValues(alpha: 0.22),
        backgroundColor: Colors.white.withValues(alpha: 0.05),
        side: BorderSide(
            color: selected
                ? AppColors.neon
                : Colors.white.withValues(alpha: 0.12)),
        labelStyle: TextStyle(
            color: selected ? AppColors.neon : AppColors.textPrimary,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500),
      );

  @override
  Widget build(BuildContext context) {
    final today = ref.watch(todayProvider);
    final name =
        PlanSeed.exercises.firstWhere((e) => e.key == _key).name;
    final async = ref.watch(exercisePointsProvider(_key));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(spacing: 8, runSpacing: 4, children: [
          for (final e in PlanSeed.exercises)
            _chip(e.name, e.key == _key, () => setState(() => _key = e.key)),
        ]),
        const SizedBox(height: 10),
        SegmentedButton<AnalysisMetric>(
          showSelectedIcon: false,
          segments: [
            for (final m in AnalysisMetric.values)
              ButtonSegment(value: m, label: Text(_short(m))),
          ],
          selected: {_metric},
          onSelectionChanged: (s) => setState(() => _metric = s.first),
          style: SegmentedButton.styleFrom(
            selectedBackgroundColor: AppColors.neon.withValues(alpha: 0.2),
            selectedForegroundColor: AppColors.neon,
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            for (final r in AnalysisRange.values) ...[
              _chip(r.label, r == _range, () => setState(() => _range = r)),
              const SizedBox(width: 8),
            ],
          ]),
        ),
        const SizedBox(height: 12),
        async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Fehler: $e'),
          data: (points) {
            final inRange = StrengthAnalytics.inRange(points, _range, today);
            final series =
                StrengthAnalytics.series(points, _range, _metric, today);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ChartCard(title: '$name · ${_metric.label}', series: series, metric: _metric),
                const SizedBox(height: 12),
                _StatsRow(series: series, metric: _metric),
                const SizedBox(height: 12),
                GlassCard(
                  glow: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(children: [
                        Icon(Icons.insights, size: 18, color: AppColors.neon),
                        SizedBox(width: 8),
                        Text('Fazit',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700)),
                      ]),
                      const SizedBox(height: 8),
                      Text(
                        InsightService.strength(
                            exerciseName: name, points: inRange, range: _range),
                        style: const TextStyle(height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

String _fmt(AnalysisMetric m, double v) => m == AnalysisMetric.volume
    ? '${fmtKg(v, maxDecimals: 0)} kg'
    : '${fmtKg(v, maxDecimals: 1)} kg';

String _bucketNote(Series s, AnalysisMetric m) {
  final sum = m == AnalysisMetric.volume;
  return switch (s.bucket) {
    Bucket.day => 'Je Trainingseinheit',
    Bucket.week => sum ? 'Summe pro Woche' : 'Bestwert pro Woche',
    Bucket.month => sum ? 'Summe pro Monat' : 'Bestwert pro Monat',
  };
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.series, required this.metric});
  final Series series;
  final AnalysisMetric metric;

  @override
  Widget build(BuildContext context) {
    final p = series.points;
    if (p.isEmpty) return const SizedBox.shrink();
    final last = p.last.value;
    final best = p.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final delta = last - p.first.value;
    Widget cell(String label, String value, {Color? color}) => Expanded(
          child: Column(children: [
            Text(value,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: color ?? AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12)),
          ]),
        );
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Row(children: [
        cell('Zuletzt', _fmt(metric, last)),
        cell('Bestwert', _fmt(metric, best)),
        cell(
            'Veränderung',
            p.length < 2
                ? '–'
                : '${delta >= 0 ? '+' : '−'}${_fmt(metric, delta.abs())}',
            color: p.length < 2
                ? null
                : (delta > 0
                    ? AppColors.success
                    : (delta < 0 ? AppColors.danger : null))),
      ]),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard(
      {required this.title, required this.series, required this.metric});
  final String title;
  final Series series;
  final AnalysisMetric metric;

  @override
  Widget build(BuildContext context) {
    final p = series.points;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          if (p.isNotEmpty)
            Text(_bucketNote(series, metric),
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 12),
          if (p.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 36),
              child: Center(
                child: Text('Keine Einheiten im gewählten Zeitraum.',
                    style: TextStyle(color: AppColors.textSecondary)),
              ),
            )
          else
            SizedBox(height: 200, child: _chart()),
        ],
      ),
    );
  }

  Widget _chart() {
    final p = series.points;
    final first = p.first.date;
    final spots = [
      for (final e in p)
        FlSpot(daysBetween(first, e.date).toDouble(), e.value)
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
          dotData: FlDotData(show: spots.length <= 24),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.neon.withValues(alpha: 0.28),
                AppColors.neon.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
