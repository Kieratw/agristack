import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agristack/app/di.dart';

class InfoPage extends ConsumerWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final asyncKey = ref.watch(geminiApiKeyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Informacje'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('AgriStack', style: textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Aplikacja do lokalnej diagnozy chorób roślin na podstawie zdjęć. '
              'Wyniki są zapisywane w lokalnej bazie danych (Isar), a modele CNN '
              'działają offline na urządzeniu.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            Text('Wersje modeli', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            const Text('- wheat_v1.ptl  •  pszenica'),
            const Text('- potato_v1.ptl •  ziemniak'),
            const Text('- oilseed_rape_v1.ptl • rzepak'),
            const SizedBox(height: 24),

            Text('Klucz API Gemini (LLM)', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            asyncKey.when(
              data: (key) {
                final masked = (key == null || key.isEmpty)
                    ? 'brak zapisanej wartości'
                    : '********${key.substring(key.length.clamp(0, 4) - 4)}';
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Stan: $masked',
                        style: textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () => _showEditKeyDialog(context, ref, key),
                      child: Text(
                        key == null || key.isEmpty ? 'Ustaw' : 'Zmień',
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Text('Ładowanie...'),
              error: (e, _) => Text('Błąd: $e'),
            ),

            const SizedBox(height: 32),
            Text('Projekt inżynierski', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            const Text('Autor: TU_WPISZ_SIEBIE'),
            const Text('Uczelnia: TU_WPISZ_UCZELNIĘ'),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditKeyDialog(
    BuildContext context,
    WidgetRef ref,
    String? current,
  ) async {
    final controller = TextEditingController(text: current ?? '');
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Klucz API Gemini'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Klucz API',
              hintText: 'AIza...',
            ),
            maxLines: 1,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Anuluj'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Zapisz'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      final value = controller.text.trim();
      await ref.read(secretsServiceProvider).saveGeminiApiKey(value);
      ref.invalidate(geminiApiKeyProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Klucz Gemini zapisany')),
        );
      }
    }
  }
}
