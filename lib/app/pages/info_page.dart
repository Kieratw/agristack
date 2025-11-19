import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InfoPage extends ConsumerWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Informacje')),
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

            Text('Projekt inżynierski', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            const Text('Autor: TU_WPISZ_SIEBIE'),
            const Text('Uczelnia: TU_WPISZ_UCZELNIĘ'),
          ],
        ),
      ),
    );
  }
}
