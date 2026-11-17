import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'goals_tab.dart';
import 'records_tab.dart';
import 'strength_tab.dart';

/// Tab „Fortschritt“: Kraft · Rekorde · Ziele.
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Text('Fortschritt',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        SegmentedButton<int>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(value: 0, label: Text('Kraft')),
            ButtonSegment(value: 1, label: Text('Rekorde')),
            ButtonSegment(value: 2, label: Text('Ziele')),
          ],
          selected: {_tab},
          onSelectionChanged: (s) => setState(() => _tab = s.first),
          style: SegmentedButton.styleFrom(
            selectedBackgroundColor: AppColors.neon.withValues(alpha: 0.2),
            selectedForegroundColor: AppColors.neon,
          ),
        ),
        const SizedBox(height: 14),
        switch (_tab) {
          0 => const StrengthTab(),
          1 => const RecordsTab(),
          _ => const GoalsTab(),
        },
      ],
    );
  }
}
