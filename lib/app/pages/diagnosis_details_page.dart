import 'dart:io';
import 'package:agristack/app/services/pdf_service.dart';
import 'package:agristack/data/models/advice_dtos.dart';
import 'package:printing/printing.dart';
import 'package:agristack/app/di.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agristack/app/controllers/diagnosis_details_controller.dart';
import 'package:agristack/domain/entities/entities.dart';

class DiagnosisDetailsPage extends ConsumerStatefulWidget {
  final DiagnosisEntryEntity entry;

  const DiagnosisDetailsPage({super.key, required this.entry});

  @override
  ConsumerState<DiagnosisDetailsPage> createState() =>
      _DiagnosisDetailsPageState();
}

class _DiagnosisDetailsPageState extends ConsumerState<DiagnosisDetailsPage> {
  final _bbchController = TextEditingController();
  final _seasonContextController = TextEditingController();
  final _timeSinceLastSprayController = TextEditingController();
  final _situationDescriptionController = TextEditingController();

  @override
  void dispose() {
    _bbchController.dispose();
    _seasonContextController.dispose();
    _timeSinceLastSprayController.dispose();
    _situationDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final llmState = ref.watch(diagnosisDetailsControllerProvider);
    final e = widget.entry;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Szczegóły diagnozy'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareReport(context, ref),
            tooltip: 'Udostępnij raport',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ImageHeader(entry: e),
          const SizedBox(height: 16),

          Text(
            e.displayLabelPl,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Model: ${e.modelId} • ${(e.confidence * 100).toStringAsFixed(1)}%',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Data: ${e.timestamp.toLocal()}',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          if (e.lat != null && e.lng != null)
            Text(
              'Lokalizacja: ${e.lat!.toStringAsFixed(5)}, ${e.lng!.toStringAsFixed(5)}',
              style: theme.textTheme.bodySmall,
            ),

          const SizedBox(height: 24),
          Text('Zapytaj eksperta AI', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),

          TextField(
            controller: _bbchController,
            decoration: const InputDecoration(
              labelText: 'Faza BBCH (opcjonalnie)',
              hintText: 'np. BBCH 31-39',
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _seasonContextController,
            decoration: const InputDecoration(
              labelText: 'Termin zabiegu / Kontekst sezonu',
              hintText: 'np. T1, T2, jesień, wiosna',
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _timeSinceLastSprayController,
            decoration: const InputDecoration(
              labelText: 'Dni od ostatniego oprysku',
              hintText: 'np. 14',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _situationDescriptionController,
            decoration: const InputDecoration(
              labelText: 'Opis sytuacji / Dodatkowe uwagi',
              hintText: 'np. Wysoka wilgotność, planowany deszcz...',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              FilledButton.icon(
                onPressed: () => _runLlm(context),
                icon: const Icon(Icons.chat_rounded),
                label: const Text('Generuj odpowiedź'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => ref
                    .read(diagnosisDetailsControllerProvider.notifier)
                    .clearAnswer(),
                child: const Text('Wyczyść'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          llmState.when(
            data: (response) {
              if (response == null) {
                return const Text(
                  'Wypełnij formularz i kliknij „Generuj odpowiedź”, aby uzyskać poradę eksperta.',
                  style: TextStyle(color: Colors.grey),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Podsumowanie',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(response.summary),
                        ],
                      ),
                    ),
                  ),
                  if (response.products.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Rekomendowane produkty:',
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    ...response.products.map(
                      (p) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(
                            p.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text('Dawka: ${p.dose}')],
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (response.sources.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text('Źródła:', style: theme.textTheme.titleSmall),
                    ...response.sources.map(
                      (s) => Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 2),
                        child: Text('• $s', style: theme.textTheme.bodySmall),
                      ),
                    ),
                  ],
                  if (response.disclaimer != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Uwaga: ${response.disclaimer}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ],
              );
            },

            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, _) => Text(
              'Błąd podczas generowania odpowiedzi: $e',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _runLlm(BuildContext context) async {
    final entry = widget.entry;
    final bbch = _bbchController.text;
    final seasonContext = _seasonContextController.text;
    final timeSinceLastSpray = int.tryParse(_timeSinceLastSprayController.text);
    final situationDescription = _situationDescriptionController.text;

    try {
      await ref
          .read(diagnosisDetailsControllerProvider.notifier)
          .askExpert(
            entry,
            bbch: bbch.isEmpty ? null : bbch,
            seasonContext: seasonContext.isEmpty ? null : seasonContext,
            timeSinceLastSprayDays: timeSinceLastSpray,
            situationDescription: situationDescription.isEmpty
                ? null
                : situationDescription,
          );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Błąd: $e')));
    }
  }

  Future<void> _shareReport(BuildContext context, WidgetRef ref) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final entry = widget.entry;
      FieldEntity? field;
      FieldSeasonEntity? season;

      // Fetch field data if linked
      if (entry.fieldSeasonId != null) {
        final repo = await ref.read(fieldsRepoProvider.future);
        final allFieldsRes = await repo.getAll();

        if (allFieldsRes.isOk && allFieldsRes.data != null) {
          // Iterate to find the matching season
          for (final f in allFieldsRes.data!) {
            final seasonsRes = await repo.getSeasons(f.id);
            if (seasonsRes.isOk && seasonsRes.data != null) {
              try {
                final s = seasonsRes.data!.firstWhere(
                  (s) => s.id == entry.fieldSeasonId,
                );
                field = f;
                season = s;
                break; // Found it
              } catch (_) {
                // Not in this field
              }
            }
          }
        }
      }

      // Get advice data
      final llmState = ref.read(diagnosisDetailsControllerProvider);
      String? advice;
      List<AdviceProduct>? products;
      if (llmState.hasValue && llmState.value != null) {
        advice = llmState.value!.summary;
        products = llmState.value!.products;
      }

      final pdfBytes = await PdfService.generateDiagnosisReport(
        diagnosis: entry,
        field: field,
        season: season,
        advice: advice,
        products: products,
      );

      if (!context.mounted) return;
      // Close loading dialog
      Navigator.of(context).pop();

      await Printing.layoutPdf(
        onLayout: (_) => pdfBytes,
        name: 'raport_agristack_${entry.id}.pdf',
      );
    } catch (e) {
      if (!context.mounted) return;
      // Close loading dialog
      Navigator.of(context).pop();

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Błąd'),
          content: Text('Nie udało się wygenerować raportu: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

class _ImageHeader extends StatelessWidget {
  final DiagnosisEntryEntity entry;
  const _ImageHeader({required this.entry});

  @override
  Widget build(BuildContext context) {
    final path = entry.imagePath;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 220,
        child: path.isNotEmpty && File(path).existsSync()
            ? Image.file(File(path), fit: BoxFit.cover, width: double.infinity)
            : const Center(child: Text('Brak zdjęcia')),
      ),
    );
  }
}
