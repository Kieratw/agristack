import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  final String location; // <--- to jest wymagane

  const MainShell({
    super.key,
    required this.child,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = <_NavItem>[
      const _NavItem(
        location: '/app/home',
        icon: Icons.home_rounded,
        label: 'Home',
      ),
      const _NavItem(
        location: '/app/fields',
        icon: Icons.terrain_rounded,
        label: 'Pola',
      ),
      const _NavItem(
        location: '/app/map',
        icon: Icons.map_rounded,
        label: 'Mapa',
      ),
      const _NavItem(
        location: '/app/diagnosis',
        icon: Icons.science_rounded,
        label: 'Diagnoza',
      ),
    ];

    final currentLocation = location;
    int currentIndex = 0;

    for (var i = 0; i < tabs.length; i++) {
      if (currentLocation.startsWith(tabs[i].location)) {
        currentIndex = i;
        break;
      }
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          final dest = tabs[index].location;
          if (dest != currentLocation) {
            context.go(dest);
          }
        },
        items: [
          for (final t in tabs)
            BottomNavigationBarItem(
              icon: Icon(t.icon),
              label: t.label,
            ),
        ],
      ),
    );
  }
}

class _NavItem {
  final String location;
  final IconData icon;
  final String label;
  const _NavItem({
    required this.location,
    required this.icon,
    required this.label,
  });
}
