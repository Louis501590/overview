import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/glass.dart';
import '../../domain/date_utils.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  DateTime? _birth;
  String _sex = 'male';
  bool _saving = false;

  Future<void> _pickBirth() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birth ?? DateTime(now.year - 25, 6, 1),
      firstDate: DateTime(now.year - 90),
      lastDate: DateTime(now.year - 14, 12, 31),
      helpText: 'Geburtsdatum',
    );
    if (picked != null) setState(() => _birth = picked);
  }

  Future<void> _save() async {
    if (_birth == null) return;
    setState(() => _saving = true);
    final repo = ref.read(repositoryProvider);
    await repo.saveProfile(_birth!, _sex);
    await repo.setSetting('startDate', dateKey(dateOnly(DateTime.now())));
    ref.invalidate(startDateProvider);
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.bolt, size: 56, color: AppColors.neon),
                  const SizedBox(height: 12),
                  Text('Overview',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  const Text(
                    'Deine persönliche Fitness-App. Alle Daten bleiben auf diesem Gerät.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 28),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                            'Für Strength Score und Altersgruppe brauche ich zwei Angaben.',
                            style: TextStyle(color: AppColors.textSecondary)),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: _pickBirth,
                          icon: const Icon(Icons.cake_outlined),
                          label: Text(_birth == null
                              ? 'Geburtsdatum wählen'
                              : formatDateDe(_birth!)),
                        ),
                        const SizedBox(height: 14),
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(value: 'male', label: Text('Männlich')),
                            ButtonSegment(
                                value: 'female', label: Text('Weiblich')),
                          ],
                          selected: {_sex},
                          onSelectionChanged: (s) =>
                              setState(() => _sex = s.first),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _birth == null || _saving ? null : _save,
                    child: const Text('Los geht\'s'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
