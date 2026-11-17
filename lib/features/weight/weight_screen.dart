import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/format.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/glass.dart';
import '../../data/db/database.dart';
import '../../domain/date_utils.dart';

class WeightScreen extends ConsumerStatefulWidget {
  const WeightScreen({super.key});

  @override
  ConsumerState<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends ConsumerState<WeightScreen> {
  final _ctrl = TextEditingController();
  DateTime? _date; // null = heute
  bool _saving = false;

  DateTime get _effective => _date ?? ref.read(todayProvider);

  @override
  void initState() {
    super.initState();
    _loadFor(_effective);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _loadFor(DateTime d) async {
    final e = await ref.read(repositoryProvider).weightOn(d);
    if (mounted) _ctrl.text = e == null ? '' : fmtKg(e.weightKg);
  }

  Future<void> _pickDate() async {
    final today = ref.read(todayProvider);
    final picked = await showDatePicker(
      context: context,
      initialDate: _effective,
      firstDate: DateTime(today.year - 5),
      lastDate: today,
      helpText: 'Datum der Messung',
    );
    if (picked == null) return;
    setState(() => _date = dateOnly(picked));
    await _loadFor(dateOnly(picked));
  }

  Future<void> _save() async {
    final v = parseDecimal(_ctrl.text);
    if (v == null || v < 20 || v > 400) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
            const SnackBar(content: Text('Bitte ein gültiges Gewicht eintragen (20–400 kg).')));
      return;
    }
    setState(() => _saving = true);
    await ref
        .read(repositoryProvider)
        .saveWeight(_effective, double.parse(v.toStringAsFixed(2)));
    ref.invalidate(backupNudgeProvider);
    if (!mounted) return;
    setState(() => _saving = false);
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Gewicht gespeichert')));
  }

  @override
  Widget build(BuildContext context) {
    final today = ref.watch(todayProvider);
    final entries = ref.watch(weightEntriesProvider).value ?? const [];
    final isToday = _effective == today;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Text('Gewicht',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        GlassCard(
          glow: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Row(children: [
                Icon(Icons.info_outline, size: 18, color: AppColors.neon),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Gewicht auf nüchternen Magen nach dem Toilettengang eintragen.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ]),
              const SizedBox(height: 16),
              TextField(
                controller: _ctrl,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w800),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                decoration: const InputDecoration(
                    suffixText: 'kg', hintText: '0,0'),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.event, size: 18),
                label: Text(isToday ? 'Heute' : longDateDe(_effective)),
              ),
              const SizedBox(height: 4),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: const Text('Speichern'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _ChartCard(entries: entries),
        const SizedBox(height: 12),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Letzte Messungen',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              if (entries.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('Noch keine Messungen.',
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
              for (final e in entries.take(14))
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(longDateDe(parseDateKey(e.date))),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text('${fmtKg(e.weightKg)} kg',
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      color: AppColors.textSecondary,
                      onPressed: () async {
                        await ref
                            .read(repositoryProvider)
                            .deleteWeight(parseDateKey(e.date));
                        if (e.date == dateKey(_effective)) _ctrl.clear();
                      },
                    ),
                  ]),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.entries});
  final List<BodyWeightEntry> entries;

  @override
  Widget build(BuildContext context) {
    // Die letzten 30 Messungen, aufsteigend nach Datum.
    final data = entries.take(30).toList().reversed.toList();
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Verlauf',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          if (data.length < 2)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('Ab zwei Messungen erscheint hier der Verlauf.',
                    style: TextStyle(color: AppColors.textSecondary)),
              ),
            )
          else
            SizedBox(height: 170, child: _chart(data)),
        ],
      ),
    );
  }

  Widget _chart(List<BodyWeightEntry> data) {
    final first = parseDateKey(data.first.date);
    final spots = [
      for (final e in data)
        FlSpot(daysBetween(first, parseDateKey(e.date)).toDouble(), e.weightKg)
    ];
    final ys = spots.map((s) => s.y);
    final minY = ys.reduce((a, b) => a < b ? a : b) - 1;
    final maxY = ys.reduce((a, b) => a > b ? a : b) + 1;
    return LineChart(LineChartData(
      minY: minY,
      maxY: maxY,
      gridData: FlGridData(
        drawVerticalLine: false,
        getDrawingHorizontalLine: (_) =>
            FlLine(color: Colors.white.withValues(alpha: 0.06), strokeWidth: 1),
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(),
        rightTitles: const AxisTitles(),
        bottomTitles: const AxisTitles(),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            maxIncluded: false,
            minIncluded: false,
            getTitlesWidget: (v, meta) => Text(fmtKg(v, maxDecimals: 1),
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 11)),
          ),
        ),
      ),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (spots) => [
            for (final s in spots)
              LineTooltipItem(
                  '${fmtKg(s.y)} kg', const TextStyle(color: Colors.white)),
          ],
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          preventCurveOverShooting: true,
          color: AppColors.neon,
          barWidth: 3,
          dotData: FlDotData(show: spots.length <= 14),
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
