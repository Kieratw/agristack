import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:agristack/app/controllers/fields_controller.dart';
import 'package:agristack/domain/entities/entities.dart';

class FieldsPage extends ConsumerWidget {
  const FieldsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fieldsControllerProvider);
    final controller = ref.read(fieldsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Pola i uprawy')),
      body: switch ((state.isLoading, state.error, state.items.isEmpty)) {
        (true, _, _) => const Center(child: CircularProgressIndicator()),
        (false, String err, _) when err.isNotEmpty => _ErrorView(
          message: err,
          onRetry: controller.load,
        ),
        (false, _, true) => const Center(
          child: Text('Brak pól. Dodaj pierwsze pole przyciskiem +.'),
        ),
        _ => ListView.builder(
          itemCount: state.items.length,
          itemBuilder: (ctx, index) {
            final row = state.items[index];
            return _FieldTile(
              row: row,
              onToggle: () => controller.toggleExpanded(row.field.id),
              onRename: (newName) => controller.renameField(row.field, newName),
              onDelete: () => controller.deleteField(row.field.id),
              onAddSeason: (year, crop) => controller.addSeason(
                fieldId: row.field.id,
                year: year,
                crop: crop,
              ),
              onDeleteDiagnosis: (id) =>
                  controller.deleteDiagnosis(id, row.field.id),
            );
          },
        ),
      },
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFieldDialog(context, controller),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Błąd: $message', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Spróbuj ponownie'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldTile extends StatelessWidget {
  final FieldRowState row;
  final VoidCallback onToggle;
  final ValueChanged<String> onRename;
  final VoidCallback onDelete;
  final void Function(int year, String crop) onAddSeason;
  final ValueChanged<int> onDeleteDiagnosis;

  const _FieldTile({
    required this.row,
    required this.onToggle,
    required this.onRename,
    required this.onDelete,
    required this.onAddSeason,
    required this.onDeleteDiagnosis,
  });

  @override
  Widget build(BuildContext context) {
    final field = row.field;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ExpansionTile(
        initiallyExpanded: row.expanded,
        onExpansionChanged: (_) => onToggle(),
        title: Text(
          field.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: _buildSubtitle(context),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Edytuj nazwę pola',
              icon: const Icon(Icons.edit_rounded),
              onPressed: () => _showRenameFieldDialog(context, field, onRename),
            ),
            IconButton(
              tooltip: 'Usuń pole',
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
              onPressed: () => _confirmDeleteField(context, field, onDelete),
            ),
          ],
        ),
        children: [
          if (row.error != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Błąd: ${row.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          _SeasonsSection(seasons: row.seasons, onAddSeason: onAddSeason),
          const Divider(height: 1),
          _DiagnosesSection(
            diagnoses: row.diagnoses,
            onDelete: onDeleteDiagnosis,
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    final hasCoords =
        row.field.centerLat != null && row.field.centerLng != null;
    final hasPolygon =
        row.field.polygon != null && row.field.polygon!.isNotEmpty;
    final seasonsCount = row.seasons.length;
    final diagCount = row.diagnoses.length;

    final parts = <String>[];
    if (row.field.area != null && row.field.area! > 0) {
      parts.add('${row.field.area!.toStringAsFixed(2)} ha');
    }
    if (seasonsCount > 0) parts.add('Uprawy: $seasonsCount');
    if (diagCount > 0) parts.add('Diagnozy: $diagCount');
    if (hasCoords && !hasPolygon) parts.add('Ma punkt');
    if (hasPolygon) parts.add('Ma granice');

    // Always show map button to allow editing polygon
    // const showMapButton = true;

    // if (parts.isEmpty && !showMapButton) return const SizedBox.shrink();

    return Row(
      children: [
        Expanded(
          child: Text(parts.join(' • '), style: const TextStyle(fontSize: 12)),
        ),
        IconButton(
          icon: const Icon(Icons.map, size: 20),
          tooltip: 'Pokaż na mapie / Edytuj granice',
          onPressed: () {
            context.go('/app/map?fieldId=${row.field.id}');
          },
        ),
      ],
    );
  }
}

class _SeasonsSection extends StatelessWidget {
  final List<FieldSeasonEntity> seasons;
  final void Function(int year, String crop) onAddSeason;

  const _SeasonsSection({required this.seasons, required this.onAddSeason});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          dense: true,
          title: const Text(
            'Uprawy (sezony)',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          trailing: IconButton(
            tooltip: 'Dodaj uprawę',
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _showAddSeasonDialog(context, onAddSeason),
          ),
        ),
        if (seasons.isEmpty)
          const Padding(
            padding: EdgeInsets.only(left: 16, bottom: 8),
            child: Text(
              'Brak zdefiniowanych sezonów dla pola.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: seasons.map((s) {
                return Chip(
                  label: Text('${s.year} • ${_translateCropName(s.crop)}'),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class _DiagnosesSection extends StatelessWidget {
  final List<DiagnosisEntryEntity> diagnoses;
  final ValueChanged<int> onDelete;

  const _DiagnosesSection({required this.diagnoses, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ListTile(
          dense: true,
          title: Text(
            'Diagnozy dla pola',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        if (diagnoses.isEmpty)
          const Padding(
            padding: EdgeInsets.only(left: 16, bottom: 12),
            child: Text(
              'Brak zapisanych diagnoz dla tego pola.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: diagnoses.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (ctx, index) {
              final d = diagnoses[index];
              final conf = (d.confidence * 100).toStringAsFixed(1);
              final date = d.timestamp;
              final dateStr =
                  '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

              return ListTile(
                dense: true,
                title: Text(d.displayLabelPl),
                subtitle: Text('$dateStr • pewność: $conf%'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () =>
                          _confirmDeleteDiagnosis(context, d, onDelete),
                    ),
                    const Icon(Icons.chevron_right_rounded),
                  ],
                ),
                onTap: () {
                  // push zamiast go, żeby działał back button
                  context.push('/app/diagnosis/details', extra: d);
                },
              );
            },
          ),
      ],
    );
  }
}

/// ======== Dialogi / helpery ========

void _showAddFieldDialog(BuildContext context, FieldsController controller) {
  final controllerText = TextEditingController();

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Dodaj pole'),
      content: TextField(
        controller: controllerText,
        decoration: const InputDecoration(labelText: 'Nazwa pola'),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Anuluj'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = controllerText.text.trim();
            if (name.isNotEmpty) {
              controller.addField(name);
            }
            Navigator.of(ctx).pop();
          },
          child: const Text('Zapisz'),
        ),
      ],
    ),
  );
}

void _showRenameFieldDialog(
  BuildContext context,
  FieldEntity field,
  ValueChanged<String> onRename,
) {
  final textCtrl = TextEditingController(text: field.name);

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Edytuj pole'),
      content: TextField(
        controller: textCtrl,
        decoration: const InputDecoration(labelText: 'Nazwa pola'),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Anuluj'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = textCtrl.text.trim();
            if (name.isNotEmpty) {
              onRename(name);
            }
            Navigator.of(ctx).pop();
          },
          child: const Text('Zapisz'),
        ),
      ],
    ),
  );
}

void _confirmDeleteField(
  BuildContext context,
  FieldEntity field,
  VoidCallback onDelete,
) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Usuń pole'),
      content: Text(
        'Czy na pewno chcesz usunąć pole "${field.name}"?\n'
        'Wszystkie powiązane sezony i diagnozy zostaną utracone (jeśli tak działa repo).',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Anuluj'),
        ),
        ElevatedButton(
          onPressed: () {
            onDelete();
            Navigator.of(ctx).pop();
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Usuń'),
        ),
      ],
    ),
  );
}

void _confirmDeleteDiagnosis(
  BuildContext context,
  DiagnosisEntryEntity diagnosis,
  ValueChanged<int> onDelete,
) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Usuń diagnozę'),
      content: const Text('Czy na pewno chcesz usunąć tę diagnozę?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Anuluj'),
        ),
        ElevatedButton(
          onPressed: () {
            onDelete(diagnosis.id);
            Navigator.of(ctx).pop();
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Usuń'),
        ),
      ],
    ),
  );
}

void _showAddSeasonDialog(
  BuildContext context,
  void Function(int year, String crop) onAddSeason,
) {
  final yearCtrl = TextEditingController(text: DateTime.now().year.toString());
  String crop = 'wheat';

  showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        return AlertDialog(
          title: const Text('Dodaj uprawę / sezon'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: yearCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Rok'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                key: ValueKey(crop),
                initialValue: crop,
                decoration: const InputDecoration(labelText: 'Uprawa'),
                items: const [
                  DropdownMenuItem(value: 'wheat', child: Text('Pszenica')),
                  DropdownMenuItem(value: 'potato', child: Text('Ziemniak')),
                  DropdownMenuItem(
                    value: 'oilseed_rape',
                    child: Text('Rzepak'),
                  ),
                  DropdownMenuItem(value: 'tomato', child: Text('Pomidor')),
                ],
                onChanged: (v) {
                  if (v != null) {
                    setState(() => crop = v);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Anuluj'),
            ),
            ElevatedButton(
              onPressed: () {
                final year = int.tryParse(yearCtrl.text.trim());
                if (year != null) {
                  onAddSeason(year, crop);
                }
                Navigator.of(ctx).pop();
              },
              child: const Text('Zapisz'),
            ),
          ],
        );
      },
    ),
  );
}

String _translateCropName(String raw) {
  switch (raw) {
    case 'wheat':
      return 'Pszenica';
    case 'oilseed_rape':
      return 'Rzepak';
    case 'potato':
      return 'Ziemniak';
    case 'tomato':
      return 'Pomidor';
    default:
      return raw;
  }
}
