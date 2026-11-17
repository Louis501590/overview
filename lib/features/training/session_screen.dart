import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/format.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/glass.dart';
import '../../domain/date_utils.dart';
import '../../domain/engines/schedule.dart';
import '../../domain/models.dart';
import '../../domain/views.dart';
import '../dashboard/dashboard_screen.dart' show actionColor, actionTitle, timingColor;

class _SetCtrl {
  _SetCtrl({String weight = '', String reps = '', String rir = ''})
      : weight = TextEditingController(text: weight),
        reps = TextEditingController(text: reps),
        rir = TextEditingController(text: rir);
  final TextEditingController weight;
  final TextEditingController reps;
  final TextEditingController rir;
  void dispose() {
    weight.dispose();
    reps.dispose();
    rir.dispose();
  }
}

/// Trainingsseite: Gewicht/Wiederholungen je Satz erfassen, speichern,
/// danach e1RM, Volumen und Progressions-Empfehlung anzeigen.
class SessionScreen extends ConsumerStatefulWidget {
  const SessionScreen({super.key, required this.plannedDateKey});
  final String plannedDateKey;

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen> {
  late final DateTime _planned = parseDateKey(widget.plannedDateKey);
  late DateTime _performed;
  DayInfo? _day;
  SessionInfo? _existing;
  final Map<int, List<_SetCtrl>> _ctrls = {};
  final Map<int, SlotResult> _last = {};
  Map<int, SlotResult> _results = {};
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _performed = ref.read(todayProvider);
    _load();
  }

  @override
  void dispose() {
    for (final l in _ctrls.values) {
      for (final c in l) {
        c.dispose();
      }
    }
    super.dispose();
  }

  Future<void> _load() async {
    final repo = ref.read(repositoryProvider);
    final plan = await ref.read(planProvider.future);
    final day = plan.firstWhere((d) => d.weekday == _planned.weekday);
    final existing = await repo.sessionForPlannedDate(_planned);
    final saved = existing != null && existing.status == SessionStatus.done
        ? await repo.resultsForSession(existing.id)
        : <int, SlotResult>{};

    for (final slot in day.slots) {
      final last =
          await repo.lastResultForSlot(slot.slotId, excludeSessionId: existing?.id);
      if (last != null) _last[slot.slotId] = last;

      final list = <_SetCtrl>[];
      final savedSets = saved[slot.slotId]?.sets;
      if (savedSets != null && savedSets.isNotEmpty) {
        for (final s in savedSets) {
          list.add(_SetCtrl(
              weight: fmtKg(s.weight),
              reps: '${s.reps}',
              rir: s.rir == null ? '' : '${s.rir}'));
        }
      } else {
        for (var i = 0; i < slot.targetSets; i++) {
          // Gewicht aus der letzten Einheit dieses Slots vorbelegen.
          final w = last == null
              ? null
              : (i < last.sets.length ? last.sets[i].weight : last.topWeight);
          list.add(_SetCtrl(weight: w == null ? '' : fmtKg(w)));
        }
      }
      _ctrls[slot.slotId] = list;
    }

    if (!mounted) return;
    setState(() {
      _day = day;
      _existing = existing;
      _results = saved;
      if (existing?.performed != null) _performed = existing!.performed!;
      _loading = false;
    });
  }

  void _toast(String msg) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _pickPerformed() async {
    final today = ref.read(todayProvider);
    final picked = await showDatePicker(
      context: context,
      initialDate: _performed.isAfter(today) ? today : _performed,
      firstDate: addDays(_planned, -60),
      lastDate: today,
      helpText: 'Durchgeführt am',
    );
    if (picked != null) setState(() => _performed = dateOnly(picked));
  }

  Future<void> _save() async {
    final day = _day!;
    final setsBySlot = <int, List<SetResult>>{};
    var any = false;
    for (final slot in day.slots) {
      final sets = <SetResult>[];
      final list = _ctrls[slot.slotId]!;
      for (var i = 0; i < list.length; i++) {
        final c = list[i];
        final repsText = c.reps.text.trim();
        if (repsText.isEmpty) continue;
        final reps = int.tryParse(repsText);
        if (reps == null || reps < 0 || reps > 100) {
          _toast('${slot.exerciseName}, Satz ${i + 1}: Wiederholungen ungültig.');
          return;
        }
        if (reps == 0) continue;
        final w = parseDecimal(c.weight.text);
        if (w == null || w < 0 || w > 500) {
          _toast('${slot.exerciseName}, Satz ${i + 1}: Gewicht fehlt oder ist ungültig.');
          return;
        }
        int? rir;
        if (c.rir.text.trim().isNotEmpty) {
          rir = int.tryParse(c.rir.text.trim());
          if (rir == null || rir < 0 || rir > 10) {
            _toast('${slot.exerciseName}, Satz ${i + 1}: RIR ungültig.');
            return;
          }
        }
        sets.add(SetResult(weight: w, reps: reps, rir: rir));
      }
      if (sets.isNotEmpty) any = true;
      setsBySlot[slot.slotId] = sets;
    }
    if (!any) {
      _toast('Bitte mindestens einen Satz mit Wiederholungen eintragen.');
      return;
    }

    setState(() => _saving = true);
    try {
      final res = await ref.read(repositoryProvider).saveSession(
            day: day,
            planned: _planned,
            performed: _performed,
            setsBySlot: setsBySlot,
          );
      ref.invalidate(lastResultProvider);
      final existing =
          await ref.read(repositoryProvider).sessionForPlannedDate(_planned);
      if (!mounted) return;
      setState(() {
        _results = res;
        _existing = existing;
      });
      _toast('Gespeichert');
    } catch (e) {
      if (mounted) _toast('Speichern fehlgeschlagen: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<bool> _confirm(String title, String body) async =>
      await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(c, false),
                child: const Text('Abbrechen')),
            TextButton(
                onPressed: () => Navigator.pop(c, true),
                child: const Text('Bestätigen')),
          ],
        ),
      ) ??
      false;

  Future<void> _skip() async {
    if (!await _confirm('Nicht durchgeführt?',
        'Die Einheit wird als "Nicht durchgeführt" markiert. Du kannst sie später jederzeit nachtragen.')) {
      return;
    }
    await ref.read(repositoryProvider).markSkipped(_day!, _planned);
    ref.invalidate(lastResultProvider);
    if (mounted) _back();
  }

  Future<void> _reset() async {
    if (!await _confirm('Zurücksetzen?',
        'Alle erfassten Sätze dieser Einheit werden gelöscht.')) {
      return;
    }
    await ref.read(repositoryProvider).resetSession(_planned);
    ref.invalidate(lastResultProvider);
    if (mounted) _back();
  }

  void _back() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/training');
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = ref.watch(todayProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back), onPressed: _back),
        title: Text(_day?.name ?? 'Training'),
        actions: [
          if (!_loading && _day != null && !_day!.isRest)
            PopupMenuButton<String>(
              onSelected: (v) => v == 'skip' ? _skip() : _reset(),
              itemBuilder: (_) => [
                const PopupMenuItem(
                    value: 'skip', child: Text('Als nicht durchgeführt markieren')),
                if (_existing != null)
                  const PopupMenuItem(
                      value: 'reset', child: Text('Zurücksetzen')),
              ],
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _day!.isRest
              ? const Center(child: Text('Rest Day – kein Training geplant.'))
              : _buildBody(today),
    );
  }

  Widget _buildBody(DateTime today) {
    final day = _day!;
    final timing = Schedule.timing(
        planned: _planned,
        today: today,
        status: SessionStatus.done,
        performed: _performed);
    final skipped = _existing?.status == SessionStatus.skipped;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      children: [
        GlassCard(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(children: [
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Geplant',
                              style: TextStyle(
                                  color: AppColors.textSecondary, fontSize: 12)),
                          Text(longDateDe(_planned),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16)),
                        ]),
                  ),
                  StatusChip(timing.labelDe, color: timingColor(timing)),
                ]),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: _pickPerformed,
                  icon: const Icon(Icons.event, size: 18),
                  label: Text('Durchgeführt am ${longDateDe(_performed)}'),
                ),
                if (skipped)
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                        'Diese Einheit ist als "Nicht durchgeführt" markiert. Speichern trägt sie nach.',
                        style: TextStyle(color: AppColors.warning)),
                  ),
              ]),
        ),
        const SizedBox(height: 12),
        for (final slot in day.slots) ...[
          _slotCard(slot),
          const SizedBox(height: 12),
        ],
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Speichern'),
        ),
      ],
    );
  }

  Widget _slotCard(SlotInfo slot) {
    final ctrls = _ctrls[slot.slotId]!;
    final last = _last[slot.slotId];
    final result = _results[slot.slotId];

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(slot.exerciseName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          Text(slot.targetText,
              style: const TextStyle(color: AppColors.textSecondary)),
          Text(slot.progressionText,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          if (last != null) ...[
            const SizedBox(height: 8),
            Row(children: [
              StatusChip(actionTitle(last.action),
                  color: actionColor(last.action)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                    'letztes Mal: ${last.sets.map((s) => '${fmtKg(s.weight)}×${s.reps}').join(', ')}',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
              ),
            ]),
          ],
          const SizedBox(height: 12),
          for (var i = 0; i < ctrls.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(children: [
                SizedBox(
                  width: 52,
                  child: Text('Satz ${i + 1}',
                      style: const TextStyle(color: AppColors.textSecondary)),
                ),
                Expanded(
                    flex: 3,
                    child: _field(ctrls[i].weight, 'kg', decimal: true)),
                const SizedBox(width: 8),
                Expanded(flex: 2, child: _field(ctrls[i].reps, 'Wdh.')),
                const SizedBox(width: 8),
                Expanded(flex: 2, child: _field(ctrls[i].rir, 'RIR')),
              ]),
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () {
                final prevW = ctrls.isEmpty ? '' : ctrls.last.weight.text;
                setState(() => ctrls.add(_SetCtrl(weight: prevW)));
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Satz hinzufügen'),
            ),
          ),
          if (result != null) ...[
            const Divider(height: 24),
            Row(children: [
              Expanded(child: _stat('e1RM', '${fmtKg(result.e1rm, maxDecimals: 1)} kg')),
              Expanded(
                  child: _stat('Volumen', '${fmtKg(result.volume, maxDecimals: 0)} kg')),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              StatusChip(actionTitle(result.action),
                  color: actionColor(result.action)),
            ]),
            const SizedBox(height: 6),
            Text(result.message,
                style: const TextStyle(color: AppColors.textSecondary)),
          ],
        ],
      ),
    );
  }

  Widget _stat(String label, String value) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 12)),
            Text(value,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          ]);

  Widget _field(TextEditingController c, String label, {bool decimal = false}) =>
      TextField(
        controller: c,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.numberWithOptions(decimal: decimal),
        inputFormatters: [
          FilteringTextInputFormatter.allow(
              decimal ? RegExp(r'[0-9.,]') : RegExp(r'[0-9]')),
        ],
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        ),
      );
}
