import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  try {
    final initial = await decideInitialLocation(container);
    runApp(UncontrolledProviderScope(
      container: container,
      child: OverviewApp(initialLocation: initial),
    ));
  } catch (e, st) {
    // Statt eines leeren Bildschirms eine lesbare Fehlerseite anzeigen.
    runApp(StartupErrorApp(error: '$e\n\n$st'));
  }
}

/// Wird angezeigt, wenn die App beim Start (z. B. beim Öffnen der Datenbank)
/// scheitert.
class StartupErrorApp extends StatelessWidget {
  const StartupErrorApp({super.key, required this.error});
  final String error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: Scaffold(
        backgroundColor: AppColors.navyDeep,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Icon(Icons.error_outline, size: 40, color: AppColors.danger),
              const SizedBox(height: 12),
              const Text('Overview konnte nicht starten',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const Text(
                'Beim Öffnen der Daten ist ein Fehler aufgetreten. Deine Daten '
                'wurden nicht gelöscht. Lade die Seite neu. Bleibt der Fehler, '
                'schicke mir den Text unten.',
                style: TextStyle(color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 16),
              SelectableText(error,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
