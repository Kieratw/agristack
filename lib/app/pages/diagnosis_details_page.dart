import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agristack/app/controllers/diagnosis_details_controller.dart';
import 'package:agristack/domain/entities/entities.dart';

class DiagnosisDetailsPage extends ConsumerStatefulWidget {
  final DiagnosisEntryEntity entry;

  const DiagnosisDetailsPage({
    super.key,
    required this.entry,
  });

  @override
  ConsumerState<DiagnosisDetailsPage> createState() =>
      _DiagnosisDetailsPageState();
}

class _DiagnosisDetailsPageState
    extends ConsumerState<DiagnosisDetailsPage> {
  final _questionController = TextEditingController();
  final _bbchController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    _bbchController.dispose();
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
          Text(
            'Zapytaj eksperta AI',
            style: theme.textTheme.titleMedium,
          ),
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
            controller: _questionController,
            decoration: const InputDecoration(
              labelText: 'Pytanie do eksperta',
              hintText: 'np. Jakie zabiegi są zalecane na tym etapie?',
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
            data: (answer) {
              if (answer == null || answer.isEmpty) {
                return const Text(
                  'Brak wygenerowanej odpowiedzi.\n'
                  'Wpisz pytanie i kliknij „Generuj odpowiedź”.',
                  style: TextStyle(color: Colors.grey),
                );
              }
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(answer),
                ),
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
    final question = _questionController.text.isEmpty
        ? 'Podaj zwięzłą rekomendację dla tej diagnozy.'
        : _questionController.text;

    try {
      await ref
          .read(diagnosisDetailsControllerProvider.notifier)
          .askExpert(
            entry,
            bbch: bbch,
            question: question,
          );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd: $e')),
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
            ? Image.file(
                File(path),
                fit: BoxFit.cover,
                width: double.infinity,
              )
            : const Center(
                child: Text('Brak zdjęcia'),
              ),
      ),
    );
  }
}
