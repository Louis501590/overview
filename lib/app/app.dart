import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import '../core/widgets/glass.dart';
import '../domain/date_utils.dart';
import 'providers.dart';
import 'router.dart';

/// Entscheidet beim Start, welche Seite zuerst erscheint:
/// Onboarding → Gewichtsseite (falls heute noch nicht gewogen) → Dashboard.
Future<String> decideInitialLocation(ProviderContainer c) async {
  final repo = c.read(repositoryProvider);
  final profile = await repo.watchProfile().first;
  if (profile == null) return '/onboarding';
  return await _weightPromptNeeded(c) ? '/weight' : '/';
}

/// Einmal pro Tag zur Gewichtsseite, solange noch nicht gewogen wurde.
Future<bool> _weightPromptNeeded(ProviderContainer c) async {
  final repo = c.read(repositoryProvider);
  final today = dateOnly(DateTime.now());
  if (await repo.weightOn(today) != null) return false;
  final prompted = await repo.getSetting('weightPromptDate');
  if (prompted == dateKey(today)) return false;
  await repo.setSetting('weightPromptDate', dateKey(today));
  return true;
}

class OverviewApp extends ConsumerStatefulWidget {
  const OverviewApp({super.key, required this.initialLocation});
  final String initialLocation;

  @override
  ConsumerState<OverviewApp> createState() => _OverviewAppState();
}

class _OverviewAppState extends ConsumerState<OverviewApp>
    with WidgetsBindingObserver {
  late final GoRouter _router = buildRouter(widget.initialLocation);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Kommt die PWA zurück in den Vordergrund (z. B. nach der 05:00-Erinnerung),
  /// wird der Tag aktualisiert und ggf. direkt die Gewichtsseite geöffnet.
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) return;
    ref.read(todayProvider.notifier).refresh();
    final profile = await ref.read(repositoryProvider).watchProfile().first;
    if (profile == null || !mounted) return;
    if (await _weightPromptNeeded(ProviderScope.containerOf(context))) {
      _router.go('/weight');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Overview',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      locale: const Locale('de'),
      supportedLocales: const [Locale('de')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: _router,
      builder: (context, child) => AppBackground(child: child ?? const SizedBox()),
    );
  }
}
