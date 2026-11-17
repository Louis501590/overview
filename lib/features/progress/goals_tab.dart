import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/format.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/glass.dart';
import '../../domain/engines/goal_engine.dart';
import '../../domain/engines/insights.dart';

/// Ziele mit aktuellem Stand, Fortschritt in % und geschätztem Erreichungsdatum.
class GoalsTab extends ConsumerWidget {
  const GoalsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: [
      for (var i = 0; i < Goals.all.length; i++) ...[
        _GoalCard(index: i + 1, goal: Goals.all[i]),
        const SizedBox(height: 12),
      ],
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          'Stand = bester e1RM der letzten 90 Tage, umgerechnet auf das '
          'Zusatzgewicht für 3 Wiederholungen (inkl. Körpergewicht). '
          'Das Datum ist eine Schätzung aus dem Trend der letzten 12 Wochen.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ),
    ]);
  }
}

class _GoalCard extends ConsumerWidget {
  const _GoalCard({required this.index, required this.goal});
  final int index;
  final GoalDef goal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todayProvider);
    final points = ref.watch(exercisePointsProvider(goal.exerciseKey)).value ?? const [];
    final weights = ref.watch(weightEntriesProvider).value;
    final bw = (weights == null || weights.isEmpty) ? null : weights.first.weightKg;
    final status = GoalEngine.evaluate(
        goal: goal, points: points, today: today, bodyweight: bw);
    final pct = (status.progress * 100).floor();
    final reached = status.state == EtaState.reached;

    return GlassCard(
      glow: reached,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Ziel $index',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          Text(goal.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          Text('${fmtKg(goal.targetKg)} kg Zusatzgewicht für ${goal.reps} Wiederholungen',
              style: const TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Aktueller Stand',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                    Text(
                      status.currentKg == null
                          ? '–'
                          : '≈ ${fmtKg(status.currentKg!, maxDecimals: 1)} kg × ${goal.reps}',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                  ]),
            ),
            Text('$pct %',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: reached ? AppColors.success : AppColors.neon)),
          ]),
          const SizedBox(height: 12),
          _Bar(value: status.progress, done: reached),
          const SizedBox(height: 14),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(
                reached ? Icons.check_circle : Icons.flag_outlined,
                size: 18,
                color: reached ? AppColors.success : AppColors.neon),
            const SizedBox(width: 8),
            Expanded(
                child: Text(InsightService.eta(status),
                    style: const TextStyle(height: 1.3))),
          ]),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.value, required this.done});
  final double value;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final color = done ? AppColors.success : AppColors.neon;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(children: [
          Container(height: 12, color: Colors.white.withValues(alpha: 0.08)),
          FractionallySizedBox(
            widthFactor: v,
            child: Container(
              height: 12,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [color.withValues(alpha: 0.6), color]),
                boxShadow: [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 8)],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
