import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:agristack/app/di.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      _init();
    }
  }

  Future<void> _init() async {
    try {
      await Future.wait([
        ref.read(isarProvider.future),
        ref.read(dictionaryInitializerProvider.future),
      ]);
    } catch (_) {
      // w najgorszym wypadku i tak spróbujemy wejść dalej
    }
    if (!mounted) return;
    context.go('/start');
  }

  @override
  Widget build(BuildContext context) {
    return const _FullScreenBackground(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.agriculture_rounded, size: 72, color: Colors.white),
          SizedBox(height: 16),
          Text(
            'AgriStack',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 32),
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16),
          Text(
            'Ładowanie bazy i modeli...',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _FullScreenBackground extends StatelessWidget {
  final Widget child;
  const _FullScreenBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/rzepak_bg.png',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.45),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}
