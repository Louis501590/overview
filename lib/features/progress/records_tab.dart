import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/format.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/glass.dart';
import '../../domain/date_utils.dart';
import '../../domain/engines/analytics.dart';
import '../../domain/models.dart';
import '../../domain/plan_seed.dart';

/// Persönliche Bestleistungen. Aktualisiert sich automatisch mit jedem Training.
class RecordsTab extends ConsumerWidget {
  const RecordsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: [
      for (final e in PlanSeed.exercises) ...[
        _RecordCard(exercise: e),
        const SizedBox(height: 12),
      ],
    ]);
  }
}

class _RecordCard extends ConsumerWidget {
  const _RecordCard({required this.exercise});
  final ExerciseSeed exercise;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final points = ref.watch(exercisePointsProvider(exercise.key)).value ?? const [];
    final rec = RecordsEngine.compute(points);
    final bw = exercise.loadType == LoadType.addedBodyweight;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            const Icon(Icons.emoji_events, color: AppColors.warning, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(exercise.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800)),
            ),
            if (bw)
              const Text('Zusatzgewicht',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ]),
          const SizedBox(height: 12),
          _row('Höchstes Trainingsgewicht', rec.maxWeight),
          const Divider(height: 20),
          _row('Höchster e1RM', rec.maxE1rm),
        ],
      ),
    );
  }

  Widget _row(String label, RecordInfo? r) => Row(children: [
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 13)),
                const SizedBox(height: 2),
                Text(r == null ? '–' : '${fmtKg(r.value, maxDecimals: 1)} kg',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w800)),
              ]),
        ),
        Text(r == null ? 'noch kein Eintrag' : formatDateDe(r.date),
            style: const TextStyle(color: AppColors.textSecondary)),
      ]);
}
