import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/widgets/glass.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        body: SafeArea(bottom: false, child: shell),
        bottomNavigationBar: NavigationBar(
          selectedIndex: shell.currentIndex,
          onDestinationSelected: (i) =>
              shell.goBranch(i, initialLocation: i == shell.currentIndex),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: 'Overview'),
            NavigationDestination(
                icon: Icon(Icons.fitness_center_outlined),
                selectedIcon: Icon(Icons.fitness_center),
                label: 'Training'),
            NavigationDestination(
                icon: Icon(Icons.show_chart),
                selectedIcon: Icon(Icons.stacked_line_chart),
                label: 'Fortschritt'),
            NavigationDestination(
                icon: Icon(Icons.monitor_weight_outlined),
                selectedIcon: Icon(Icons.monitor_weight),
                label: 'Gewicht'),
            NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'Mehr'),
          ],
        ),
      ),
    );
  }
}
