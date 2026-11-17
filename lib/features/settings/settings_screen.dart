import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/file_io.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/glass.dart';
import '../../domain/date_utils.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _toast(BuildContext c, String msg) => ScaffoldMessenger.of(c)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    final repo = ref.read(repositoryProvider);
    final today = ref.read(todayProvider);
    try {
      final json = await repo.exportJson();
      await downloadTextFile('overview-backup-${dateKey(today)}.json', json);
      await repo.setSetting('lastBackup', dateKey(today));
      ref.invalidate(backupNudgeProvider);
      if (context.mounted) {
        _toast(context,
            'Sicherung erstellt. Speichere die Datei in „Dateien“/iCloud Drive.');
      }
    } catch (e) {
      if (context.mounted) _toast(context, 'Export fehlgeschlagen: $e');
    }
  }

  Future<void> _import(BuildContext context, WidgetRef ref) async {
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['json'],
    );
    if (picked.isEmpty) return;
    final bytes = await picked.first.readAsBytes();
    if (!context.mounted) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Sicherung importieren?'),
        content: const Text(
            'Alle aktuellen Daten in der App werden durch die Sicherung ersetzt.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: const Text('Abbrechen')),
          TextButton(
              onPressed: () => Navigator.pop(c, true),
              child: const Text('Ersetzen')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(repositoryProvider).importJson(utf8.decode(bytes));
      ref.invalidate(planProvider);
      ref.invalidate(lastResultProvider);
      ref.invalidate(startDateProvider);
      ref.invalidate(backupNudgeProvider);
      if (context.mounted) _toast(context, 'Sicherung importiert.');
    } on FormatException catch (e) {
      if (context.mounted) _toast(context, e.message);
    } catch (e) {
      if (context.mounted) _toast(context, 'Import fehlgeschlagen: $e');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).value;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Text('Mehr',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        if (profile != null)
          GlassCard(
            child: Row(children: [
              const Icon(Icons.person_outline, color: AppColors.neon),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                    '${profile.sex == 'male' ? 'Männlich' : 'Weiblich'} · geboren ${formatDateDe(profile.birthDate)}'),
              ),
            ]),
          ),
        const SizedBox(height: 12),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Datensicherung',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              const Text(
                'Alle Daten liegen nur auf diesem Gerät. Erstelle regelmäßig eine Sicherung und lege sie in iCloud Drive ab. '
                'Ohne Sicherung gehen die Daten verloren, wenn die App gelöscht oder der Browserspeicher geleert wird.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => _export(context, ref),
                icon: const Icon(Icons.download),
                label: const Text('Sicherung exportieren'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _import(context, ref),
                icon: const Icon(Icons.upload_file),
                label: const Text('Sicherung importieren'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Wiege-Erinnerung um 05:00',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              SizedBox(height: 6),
              Text(
                'Eine Web-App kann auf dem iPhone keine geplanten Benachrichtigungen senden. '
                'Das erledigt die iOS-App „Kurzbefehle“ kostenlos:',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              SizedBox(height: 8),
              Text('1. Kurzbefehle öffnen → Tab „Automation“ → „+“ → „Tageszeit“.\n'
                  '2. 05:00 Uhr, „Täglich“, „Sofort ausführen“ wählen.\n'
                  '3. Aktion „Mitteilung anzeigen“ mit dem Text '
                  '„⚖️ Zeit zum Wiegen. Bitte Gewicht nüchtern erfassen.“ hinzufügen.\n'
                  '4. Beim Öffnen von Overview wechselt die App einmal pro Tag '
                  'automatisch zur Gewichtsseite, solange noch nicht gewogen wurde.'),
            ],
          ),
        ),
      ],
    );
  }
}
