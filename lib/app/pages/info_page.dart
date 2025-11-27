import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InfoPage extends ConsumerWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('O aplikacji')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            // Logo placeholder (using Icon for now)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.agriculture,
                size: 64,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'AgriStack',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Inteligentna diagnoza upraw',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 32),

            const Divider(),
            const SizedBox(height: 16),

            Text(
              'Aplikacja wspomaga rolników w szybkiej identyfikacji chorób roślin '
              'wykorzystując zaawansowane modele sztucznej inteligencji działające '
              'bezpośrednio na Twoim urządzeniu.',
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(height: 1.5),
            ),

            const SizedBox(height: 32),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Obsługiwane uprawy',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            _buildModelCard(context, 'Pszenica', 'wheat_v1.ptl', Icons.grass),
            const SizedBox(height: 8),
            _buildModelCard(
              context,
              'Ziemniak',
              'potato_v1.ptl',
              Icons.circle_outlined, // potato-ish
            ),
            const SizedBox(height: 8),
            _buildModelCard(
              context,
              'Rzepak',
              'oilseed_rape_v1.ptl',
              Icons.local_florist,
            ),
            const SizedBox(height: 8),
            _buildModelCard(
              context,
              'Pomidor',
              'tomato_v1.ptl',
              Icons.circle,
              color: Colors.red,
            ),

            const SizedBox(height: 48),
            Text(
              'Wersja 1.0.0',
              style: textTheme.labelMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModelCard(
    BuildContext context,
    String name,
    String modelName,
    IconData icon, {
    Color? color,
  }) {
    return Card(
      elevation: 0,
      color: Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      child: ListTile(
        leading: Icon(
          icon,
          color: color ?? Theme.of(context).colorScheme.primary,
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          'Model: $modelName',
          style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
        ),
        dense: true,
      ),
    );
  }
}
