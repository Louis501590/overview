import 'package:go_router/go_router.dart';

import '../features/dashboard/dashboard_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/progress/progress_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/training/session_screen.dart';
import '../features/training/training_screen.dart';
import '../features/weight/weight_screen.dart';
import 'shell.dart';

GoRouter buildRouter(String initialLocation) => GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: '/onboarding',
          builder: (_, _) => const OnboardingScreen(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) => AppShell(shell: shell),
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(
                  path: '/', builder: (_, _) => const DashboardScreen()),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                path: '/training',
                builder: (_, _) => const TrainingScreen(),
                routes: [
                  GoRoute(
                    path: 'session/:date',
                    builder: (_, state) =>
                        SessionScreen(plannedDateKey: state.pathParameters['date']!),
                  ),
                ],
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  path: '/progress',
                  builder: (_, _) => const ProgressScreen()),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  path: '/weight', builder: (_, _) => const WeightScreen()),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                  path: '/settings',
                  builder: (_, _) => const SettingsScreen()),
            ]),
          ],
        ),
      ],
    );
