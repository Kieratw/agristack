import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

import 'package:agristack/app/controllers/diagnosis_controller.dart';
import 'package:agristack/app/di.dart';
import 'package:agristack/domain/entities/entities.dart';

class DiagnosisPage extends ConsumerWidget {
  const DiagnosisPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(diagnosisControllerProvider);
    final ctrl = ref.read(diagnosisControllerProvider.notifier);

    final fieldsAsync = ref.watch(fieldsListProvider);
    final seasonsAsync = state.selectedFieldId != null
        ? ref.watch(fieldSeasonsByFieldProvider(state.selectedFieldId!))
        : const AsyncValue<List<FieldSeasonEntity>>.data([]);

    return Scaffold(
      appBar: AppBar(title: const Text('Nowa diagnoza')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ImagePickerSection(state: state, ctrl: ctrl),
            const SizedBox(height: 16),

            _CropSelector(selected: state.crop, onChanged: ctrl.setCrop),

            const SizedBox(height: 16),

            // --- wybór pola ---
            fieldsAsync.when(
              data: (fields) => _FieldDropdown(
                fields: fields,
                selectedId: state.selectedFieldId,
                onChanged: ctrl.setFieldId,
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text(
                'Błąd pól: $e',
                style: const TextStyle(color: Colors.red),
              ),
            ),

            const SizedBox(height: 12),

            // --- wybór sezonu dla wybranego pola ---
            if (state.selectedFieldId != null)
              seasonsAsync.when(
                data: (seasons) => _FieldSeasonDropdown(
                  seasons: seasons,
                  selectedId: state.selectedFieldSeasonId,
                  onChanged: ctrl.setFieldSeasonId,
                ),
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text(
                  'Błąd sezonów: $e',
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else
              const Text(
                'Wybierz pole, aby zobaczyć sezony.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),

            const SizedBox(height: 16),

            if (state.label != null && state.confidence != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Wynik diagnozy (podgląd)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Choroba: ${state.label}'),
                      Text(
                        'Pewność: ${(state.confidence! * 100).toStringAsFixed(1)}%',
                      ),
                    ],
                  ),
                ),
              ),

            if (state.error != null) ...[
              const SizedBox(height: 8),
              Text(state.error!, style: const TextStyle(color: Colors.red)),
            ],

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: state.isRunning
                        ? null
                        : () => ctrl.runInferencePreview(),
                    icon: state.isRunning
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.analytics),
                    label: const Text('Uruchom diagnozę'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: state.isSaving
                        ? null
                        : () async {
                            double? lat, lng;
                            try {
                              // Sprawdź uprawnienia
                              LocationPermission permission =
                                  await Geolocator.checkPermission();
                              if (permission == LocationPermission.denied) {
                                permission =
                                    await Geolocator.requestPermission();
                              }

                              if (permission == LocationPermission.whileInUse ||
                                  permission == LocationPermission.always) {
                                final pos =
                                    await Geolocator.getCurrentPosition();
                                lat = pos.latitude;
                                lng = pos.longitude;
                              }
                            } catch (e) {
                              // Ignorujemy błędy lokalizacji, zapisujemy bez niej
                              debugPrint('Błąd lokalizacji: $e');
                            }

                            await ctrl.saveDiagnosis(lat: lat, lng: lng);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Diagnoza zapisana'),
                                ),
                              );
                            }
                          },
                    icon: state.isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: const Text('Zapisz diagnozę'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagePickerSection extends StatelessWidget {
  final DiagnosisState state;
  final DiagnosisController ctrl;

  const _ImagePickerSection({required this.state, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Zdjęcie', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 4 / 3,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade900,
            ),
            clipBehavior: Clip.antiAlias,
            child: state.imagePath == null
                ? const Center(
                    child: Text(
                      'Brak zdjęcia',
                      style: TextStyle(color: Colors.white54),
                    ),
                  )
                : Image.file(File(state.imagePath!), fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final picker = ImagePicker();
                final xFile = await picker.pickImage(
                  source: ImageSource.camera,
                );
                if (xFile != null) {
                  ctrl.setImagePath(xFile.path);
                }
              },
              icon: const Icon(Icons.photo_camera),
              label: const Text('Zrób zdjęcie'),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () async {
                final picker = ImagePicker();
                final xFile = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (xFile != null) {
                  ctrl.setImagePath(xFile.path);
                }
              },
              icon: const Icon(Icons.photo_library),
              label: const Text('Z galerii'),
            ),
          ],
        ),
      ],
    );
  }
}

class _CropSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _CropSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Uprawa', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selected,
          items: const [
            DropdownMenuItem(value: 'wheat', child: Text('Pszenica')),
            DropdownMenuItem(value: 'potato', child: Text('Ziemniak')),
            DropdownMenuItem(value: 'oilseed_rape', child: Text('Rzepak')),
            DropdownMenuItem(value: 'tomato', child: Text('Pomidor')),
          ],
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ],
    );
  }
}

class _FieldDropdown extends StatelessWidget {
  final List<FieldEntity> fields;
  final int? selectedId;
  final ValueChanged<int?> onChanged;

  const _FieldDropdown({
    required this.fields,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (fields.isEmpty) {
      return const Text(
        'Brak pól. Dodaj je na ekranie "Fields".',
        style: TextStyle(fontStyle: FontStyle.italic),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pole', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: selectedId,
          items: fields
              .map(
                (f) => DropdownMenuItem<int>(value: f.id, child: Text(f.name)),
              )
              .toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ],
    );
  }
}

class _FieldSeasonDropdown extends StatelessWidget {
  final List<FieldSeasonEntity> seasons;
  final int? selectedId;
  final ValueChanged<int?> onChanged;

  const _FieldSeasonDropdown({
    required this.seasons,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (seasons.isEmpty) {
      return const Text(
        'Brak sezonów dla tego pola.',
        style: TextStyle(fontStyle: FontStyle.italic),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Sezon', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: selectedId,
          items: seasons
              .map(
                (s) => DropdownMenuItem<int>(
                  value: s.id,
                  child: Text('${s.year} • ${s.crop}'),
                ),
              )
              .toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ],
    );
  }
}
