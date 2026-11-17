import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/format.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/glass.dart';
import '../../domain/date_utils.dart';
import '../../domain/models.dart';
import '../../domain/views.dart';

Color timingColor(SessionTiming t) => switch (t) {
      SessionTiming.onTime => AppColors.success,
      SessionTiming.early || SessionTiming.late => AppColors.neon,
      SessionTiming.skipped => AppColors.danger,
      SessionTiming.overdue => AppColors.warning,
      SessionTiming.upcoming => AppColors.textSecondary,
    };

Color actionColor(ProgressionAction a) => switch (a) {
      ProgressionAction.increase => AppColors.success,
      ProgressionAction.hold => AppColors.neon,
      ProgressionAction.deload => AppColors.warning,
    };

String actionTitle(ProgressionAction a) => switch (a) {
      ProgressionAction.increase => 'Gewicht erhöhen',
      ProgressionAction.hold => 'Gewicht halten',
      ProgressionAction.deload => 'Deload empfohlen',
    };

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todayProvider);
    final planAsync = ref.watch(planProvider);
    final start = ref.watch(startDateProvider).value ?? today;
    final monday = weekStart(today);
    final sessions = ref
            .watch(sessionsPlannedProvider(
                (from: addDays(today, -7), to: addDays(monday, 6))))
            .value ??
        const <SessionInfo>[];
    final performedToday =
        ref.watch(sessionsPerformedOnProvider(today)).value ?? const [];
    final weightToday = ref.watch(weightTodayProvider).value;
    final nudge = ref.watch(backupNudgeProvider).value;

    return planAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Fehler: $e')),
      data: (plan) {
        final byDate = {for (final s in sessions) dateKey(s.planned): s};
        DayInfo dayFor(DateTime d) =>
            plan.firstWhere((p) => p.weekday == d.weekday);

        // Wochenfortschritt
        final trainingDays = plan.where((d) => !d.isRest).toList();
        final weekDone = [
          for (var i = 0; i < 7; i++) addDays(monday, i)
        ].where((d) {
          final s = byDate[dateKey(d)];
          return s != null && s.status == SessionStatus.done;
        }).length;

        // Offene Trainings der letzten 7 Tage (nur ab Startdatum).
        final overdue = <(DateTime, DayInfo)>[];
        for (var i = 7; i >= 1; i--) {
          final d = addDays(today, -i);
          if (d.isBefore(start)) continue;
          final day = dayFor(d);
          if (day.isRest) continue;
          final s = byDate[dateKey(d)];
          if (s == null || s.status == SessionStatus.open) overdue.add((d, day));
        }

        final todayDay = dayFor(today);
        final todaySession = byDate[dateKey(today)];

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Text(longDateDe(today),
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 14)),
            const SizedBox(height: 2),
            Text('Overview',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            _WeekRingCard(done: weekDone, total: trainingDays.length),
            const SizedBox(height: 12),
            if (nudge != null) ...[
              GlassCard(
                onTap: () => context.go('/settings'),
                child: Row(children: [
                  const Icon(Icons.save_alt, color: AppColors.warning),
                  const SizedBox(width: 12),
                  Expanded(child: Text(nudge)),
                  const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                ]),
              ),
              const SizedBox(height: 12),
            ],
            _TodayCard(
              today: today,
              day: todayDay,
              session: todaySession,
              plan: plan,
              performedToday: performedToday,
            ),
            if (overdue.isNotEmpty) ...[
              const SizedBox(height: 12),
              _OverdueCard(items: overdue, today: today),
            ],
            const SizedBox(height: 12),
            _WeekStrip(
                monday: monday,
                plan: plan,
                byDate: byDate,
                today: today,
                start: start),
            const SizedBox(height: 12),
            GlassCard(
              onTap: () => context.go('/weight'),
              child: Row(children: [
                const Icon(Icons.monitor_weight_outlined,
                    color: AppColors.neon),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Körpergewicht',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        Text(
                          weightToday == null
                              ? 'Heute noch nicht gewogen – nüchtern eintragen.'
                              : 'Heute: ${fmtKg(weightToday)} kg',
                          style:
                              const TextStyle(color: AppColors.textSecondary),
                        ),
                      ]),
                ),
                Icon(weightToday == null ? Icons.add_circle : Icons.check_circle,
                    color: weightToday == null
                        ? AppColors.neon
                        : AppColors.success),
              ]),
            ),
          ],
        );
      },
    );
  }
}

class _WeekRingCard extends StatelessWidget {
  const _WeekRingCard({required this.done, required this.total});
  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      glow: true,
      child: Row(
        children: [
          NeonRing(
            size: 120,
            stroke: 11,
            progress: total == 0 ? 0 : done / total,
            center: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('$done/$total',
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w800)),
              const Text('Trainings',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ]),
          ),
          const SizedBox(width: 18),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Diese Woche',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                SizedBox(height: 6),
                Text(
                  'Der Strength Score erscheint hier, sobald genug Trainingsdaten vorliegen.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayCard extends ConsumerWidget {
  const _TodayCard({
    required this.today,
    required this.day,
    required this.session,
    required this.plan,
    required this.performedToday,
  });

  final DateTime today;
  final DayInfo day;
  final SessionInfo? session;
  final List<DayInfo> plan;
  final List<SessionInfo> performedToday;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final done = session?.status == SessionStatus.done;
    final skipped = session?.status == SessionStatus.skipped;
    final movedHere = performedToday
        .where((s) => s.planned != today)
        .map((s) => (s, plan.firstWhere((d) => d.id == s.planDayId)))
        .toList();

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(weekdayNamesDe[today.weekday - 1],
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 13)),
                    Text(day.name,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w800)),
                  ]),
            ),
            StatusChip(day.isRest ? 'Rest Day' : 'Training Day',
                color: day.isRest ? AppColors.textSecondary : AppColors.neon),
          ]),
          if (day.isRest) ...[
            const SizedBox(height: 10),
            const Text('Heute ist Erholung angesagt.',
                style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text(_nextTraining(),
                style: const TextStyle(color: AppColors.textSecondary)),
          ] else ...[
            const SizedBox(height: 12),
            for (final slot in day.slots) _SlotRow(slot: slot),
            const SizedBox(height: 12),
            if (skipped)
              const StatusChip('Als nicht durchgeführt markiert',
                  color: AppColors.danger)
            else if (done)
              OutlinedButton(
                onPressed: () => context.go('/training/session/${dateKey(today)}'),
                child: const Text('Training ansehen / bearbeiten'),
              )
            else
              FilledButton(
                onPressed: () => context.go('/training/session/${dateKey(today)}'),
                child: const Text('Training starten'),
              ),
          ],
          for (final (s, d) in movedHere) ...[
            const SizedBox(height: 10),
            Row(children: [
              const Icon(Icons.swap_horiz, size: 18, color: AppColors.neon),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(
                      'Heute nachgeholt: ${d.name} (geplant ${weekdayShortDe[s.planned.weekday - 1]} ${s.planned.day}.${s.planned.month}.)')),
            ]),
          ],
        ],
      ),
    );
  }

  String _nextTraining() {
    for (var i = 1; i <= 7; i++) {
      final d = addDays(today, i);
      final p = plan.firstWhere((x) => x.weekday == d.weekday);
      if (!p.isRest) {
        return 'Nächstes Training: ${weekdayNamesDe[d.weekday - 1]} – ${p.name}';
      }
    }
    return '';
  }
}

class _SlotRow extends ConsumerWidget {
  const _SlotRow({required this.slot});
  final SlotInfo slot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final last = ref.watch(lastResultProvider(slot.slotId)).value;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(slot.exerciseName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        Text(slot.targetText,
            style: const TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        if (last == null)
          const Text('Noch keine Daten – Startgewicht frei wählen.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13))
        else
          Row(children: [
            StatusChip(actionTitle(last.action),
                color: actionColor(last.action)),
            const SizedBox(width: 8),
            Flexible(
              child: Text('zuletzt ${fmtKg(last.topWeight)} kg',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13)),
            ),
          ]),
      ]),
    );
  }
}

class _OverdueCard extends StatelessWidget {
  const _OverdueCard({required this.items, required this.today});
  final List<(DateTime, DayInfo)> items;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(children: [
            Icon(Icons.history, color: AppColors.warning),
            SizedBox(width: 8),
            Text('Noch offen',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 8),
          for (final (d, day) in items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(children: [
                Expanded(
                    child: Text(
                        '${day.name} · ${weekdayNamesDe[d.weekday - 1]} ${d.day}.${d.month}.')),
                TextButton(
                  onPressed: () =>
                      context.go('/training/session/${dateKey(d)}'),
                  child: const Text('Heute machen'),
                ),
              ]),
            ),
        ],
      ),
    );
  }
}

class _WeekStrip extends StatelessWidget {
  const _WeekStrip({
    required this.monday,
    required this.plan,
    required this.byDate,
    required this.today,
    required this.start,
  });
  final DateTime monday;
  final List<DayInfo> plan;
  final Map<String, SessionInfo> byDate;
  final DateTime today;
  final DateTime start;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var i = 0; i < 7; i++) _cell(context, addDays(monday, i)),
        ],
      ),
    );
  }

  Widget _cell(BuildContext context, DateTime d) {
    final day = plan.firstWhere((p) => p.weekday == d.weekday);
    final isToday = d == today;
    Color color = Colors.white24;
    IconData? icon;
    final session = byDate[dateKey(d)];
    // Tage vor dem ersten Nutzungstag bleiben neutral (nie „offen“).
    final beforeStart = d.isBefore(start) && session == null;
    if (!day.isRest && !beforeStart) {
      final t = timingOf(session, d, today);
      color = timingColor(t);
      icon = switch (t) {
        SessionTiming.onTime || SessionTiming.early || SessionTiming.late =>
          Icons.check,
        SessionTiming.skipped => Icons.close,
        SessionTiming.overdue => Icons.priority_high,
        SessionTiming.upcoming => null,
      };
    }
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: day.isRest
          ? null
          : () => context.go('/training/session/${dateKey(d)}'),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(weekdayShortDe[d.weekday - 1],
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
                  color: isToday ? AppColors.neon : AppColors.textSecondary)),
          const SizedBox(height: 6),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: day.isRest ? 0.05 : 0.18),
              border: Border.all(
                  color: isToday ? AppColors.neon : color.withValues(alpha: 0.7),
                  width: isToday ? 2 : 1),
            ),
            child: icon == null
                ? (day.isRest
                    ? const Center(
                        child: Text('–',
                            style: TextStyle(color: AppColors.textSecondary)))
                    : null)
                : Icon(icon, size: 16, color: color),
          ),
        ]),
      ),
    );
  }
}
