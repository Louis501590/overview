import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/database.dart';
import '../data/repositories/app_repository.dart';
import '../core/format.dart';
import '../domain/date_utils.dart';
import '../domain/engines/schedule.dart';
import '../domain/models.dart';
import '../domain/views.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = false;
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final repositoryProvider =
    Provider<AppRepository>((ref) => AppRepository(ref.watch(databaseProvider)));

/// „Heute“ als Kalendertag. Wird beim Zurückkehren in die App aktualisiert
/// (damit die App nach Mitternacht nicht den alten Tag anzeigt).
class TodayNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => dateOnly(DateTime.now());

  void refresh() {
    final now = dateOnly(DateTime.now());
    if (now != state) state = now;
  }
}

final todayProvider =
    NotifierProvider<TodayNotifier, DateTime>(TodayNotifier.new);

final planProvider = FutureProvider<List<DayInfo>>(
    (ref) => ref.watch(repositoryProvider).loadPlan());

final profileProvider = StreamProvider<UserProfileData?>(
    (ref) => ref.watch(repositoryProvider).watchProfile());

/// Einheiten mit geplantem Tag im Bereich (inklusive).
final sessionsPlannedProvider =
    StreamProvider.family<List<SessionInfo>, ({DateTime from, DateTime to})>(
        (ref, r) => ref
            .watch(repositoryProvider)
            .watchSessionsPlannedBetween(r.from, r.to));

final sessionsPerformedOnProvider =
    StreamProvider.family<List<SessionInfo>, DateTime>((ref, day) =>
        ref.watch(repositoryProvider).watchSessionsPerformedOn(day));

/// Letztes Ergebnis eines Plan-Slots (Hinweise, Vorbelegung).
final lastResultProvider = FutureProvider.family<SlotResult?, int>(
    (ref, slotId) => ref.watch(repositoryProvider).lastResultForSlot(slotId));

final weightTodayProvider = StreamProvider<double?>((ref) {
  final today = ref.watch(todayProvider);
  return ref
      .watch(repositoryProvider)
      .watchWeightOn(today)
      .map((e) => e?.weightKg);
});

final weightEntriesProvider = StreamProvider<List<BodyWeightEntry>>(
    (ref) => ref.watch(repositoryProvider).watchWeights());

/// Hinweis auf fehlende Datensicherung.
final backupNudgeProvider = FutureProvider<String?>((ref) async {
  final repo = ref.watch(repositoryProvider);
  final today = ref.watch(todayProvider);
  final db = ref.watch(databaseProvider);
  final hasData = (await db.select(db.workoutSessions).get()).isNotEmpty ||
      (await db.select(db.bodyWeightEntries).get()).length >= 3;
  if (!hasData) return null;
  final last = await repo.getSetting('lastBackup');
  if (last == null) {
    return 'Noch keine Sicherung erstellt. Sichere deine Daten unter Einstellungen.';
  }
  final days = daysBetween(parseDateKey(last), today);
  if (days >= 14) return 'Letzte Sicherung vor $days Tagen.';
  return null;
});

/// Zeit-Status einer Einheit relativ zum Plan (für Chips).
SessionTiming timingOf(SessionInfo? s, DateTime planned, DateTime today) =>
    Schedule.timing(
      planned: planned,
      today: today,
      status: s?.status ?? SessionStatus.open,
      performed: s?.performed,
    );

/// Erster Nutzungstag. Tage davor zählen nie als „offen“ oder „ausgelassen“.
final startDateProvider = FutureProvider<DateTime>((ref) async {
  final raw = await ref.watch(repositoryProvider).getSetting('startDate');
  return raw == null ? ref.watch(todayProvider) : parseDateKey(raw);
});

String longDateDe(DateTime d) =>
    '${weekdayNamesDe[d.weekday - 1]}, ${d.day}. ${monthNamesDe[d.month - 1]}';
