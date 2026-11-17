import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/glass.dart';
import '../../domain/date_utils.dart';
import '../../domain/models.dart';
import '../../domain/views.dart';
import '../dashboard/dashboard_screen.dart' show timingColor;

/// Wochenplan mit Status je Tag. Vergangene Wochen sind zum Nachtragen erreichbar.
class TrainingScreen extends ConsumerStatefulWidget {
  const TrainingScreen({super.key});

  @override
  ConsumerState<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends ConsumerState<TrainingScreen> {
  int _offset = 0; // Wochen relativ zur aktuellen

  @override
  Widget build(BuildContext context) {
    final today = ref.watch(todayProvider);
    final monday = addDays(weekStart(today), _offset * 7);
    final sunday = addDays(monday, 6);
    final plan = ref.watch(planProvider).value;
    final start = ref.watch(startDateProvider).value ?? today;
    final sessions = ref
            .watch(sessionsPlannedProvider((from: monday, to: sunday)))
            .value ??
        const <SessionInfo>[];
    final byDate = {for (final s in sessions) dateKey(s.planned): s};

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Text('Training',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Row(children: [
          IconButton(
              onPressed: () => setState(() => _offset--),
              icon: const Icon(Icons.chevron_left)),
          Expanded(
            child: Column(children: [
              Text(
                  _offset == 0
                      ? 'Diese Woche'
                      : _offset == -1
                          ? 'Letzte Woche'
                          : _offset == 1
                              ? 'Nächste Woche'
                              : 'Woche',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              Text('${monday.day}.${monday.month}. – ${sunday.day}.${sunday.month}.${sunday.year}',
                  style: const TextStyle(color: AppColors.textSecondary)),
            ]),
          ),
          IconButton(
              onPressed: _offset >= 1 ? null : () => setState(() => _offset++),
              icon: const Icon(Icons.chevron_right)),
        ]),
        const SizedBox(height: 8),
        if (plan == null)
          const Center(child: CircularProgressIndicator())
        else
          for (var i = 0; i < 7; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _DayCard(
                date: addDays(monday, i),
                day: plan.firstWhere((p) => p.weekday == i + 1),
                session: byDate[dateKey(addDays(monday, i))],
                today: today,
                start: start,
              ),
            ),
      ],
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({
    required this.date,
    required this.day,
    required this.session,
    required this.today,
    required this.start,
  });

  final DateTime date;
  final DayInfo day;
  final SessionInfo? session;
  final DateTime today;
  final DateTime start;

  @override
  Widget build(BuildContext context) {
    final isToday = date == today;
    final beforeStart = date.isBefore(start) && session == null;
    final timing = timingOf(session, date, today);

    String? detail;
    if (session?.status == SessionStatus.done &&
        session!.performed != null &&
        session!.performed != date) {
      final p = session!.performed!;
      detail = 'durchgeführt ${weekdayShortDe[p.weekday - 1]} ${p.day}.${p.month}.';
    }

    return GlassCard(
      glow: isToday,
      dimmed: day.isRest,
      onTap: day.isRest
          ? null
          : () => context.go('/training/session/${dateKey(date)}'),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 46,
            child: Column(children: [
              Text(weekdayShortDe[date.weekday - 1],
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: isToday ? AppColors.neon : AppColors.textPrimary)),
              Text('${date.day}.${date.month}.',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12)),
            ]),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(day.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                if (!day.isRest)
                  for (final s in day.slots)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                          '${s.exerciseName} · ${s.targetSets}×${s.repsText}',
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 13)),
                    ),
                if (detail != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(detail,
                        style: const TextStyle(
                            color: AppColors.neon, fontSize: 12)),
                  ),
              ],
            ),
          ),
          if (!day.isRest && !beforeStart)
            StatusChip(timing.labelDe, color: timingColor(timing)),
        ],
      ),
    );
  }
}
