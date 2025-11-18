import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _HomeAction(
        icon: Icons.science_rounded,
        label: 'Nowa diagnoza',
        description: 'Zrób zdjęcie lub wybierz z galerii',
        route: '/app/diagnosis',
      ),
      _HomeAction(
        icon: Icons.terrain_rounded,
        label: 'Pola',
        description: 'Zarządzaj polami i sezonami',
        route: '/app/fields',
      ),
      _HomeAction(
        icon: Icons.map_rounded,
        label: 'Mapa diagnoz',
        description: 'Zobacz choroby na mapie',
        route: '/app/map',
      ),
      _HomeAction(
        icon: Icons.info_outline_rounded,
        label: 'Informacje',
        description: 'Wersje modeli i szczegóły projektu',
        route: '/app/info',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('AgriStack'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 3 / 3.4,
          children: [
            for (final item in items)
              _HomeCard(
                icon: item.icon,
                label: item.label,
                description: item.description,
                onTap: () => context.go(item.route),
              ),
          ],
        ),
      ),
    );
  }
}

class _HomeAction {
  final IconData icon;
  final String label;
  final String description;
  final String route;
  _HomeAction({
    required this.icon,
    required this.label,
    required this.description,
    required this.route,
  });
}

class _HomeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;

  const _HomeCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: colorScheme.primary),
              const SizedBox(height: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
