import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:agristack/app/pages/splash_page.dart';
import 'package:agristack/app/pages/start_page.dart';
import 'package:agristack/app/pages/home_page.dart';
import 'package:agristack/app/pages/fields_page.dart';
import 'package:agristack/app/pages/map_page.dart';
import 'package:agristack/app/pages/diagnosis_page.dart';
import 'package:agristack/app/pages/info_page.dart';
import 'package:agristack/app/shell/main_shell.dart';
import 'package:agristack/app/pages/diagnosis_details_page.dart';
import 'package:agristack/app/pages/photo_guide_page.dart';
import 'package:agristack/domain/entities/entities.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/start', builder: (context, state) => const StartPage()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/fields',
                builder: (context, state) => const FieldsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/map',
                builder: (context, state) {
                  final fieldIdStr = state.uri.queryParameters['fieldId'];
                  final fieldId = fieldIdStr != null
                      ? int.tryParse(fieldIdStr)
                      : null;
                  final isPicker =
                      state.uri.queryParameters['isPicker'] == 'true';
                  return MapPage(fieldId: fieldId, isPicker: isPicker);
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/app/diagnosis',
                builder: (context, state) => const DiagnosisPage(),
                routes: [
                  GoRoute(
                    path: 'guide',
                    builder: (context, state) => const PhotoGuidePage(),
                  ),
                  GoRoute(
                    path: 'details',
                    builder: (context, state) {
                      final extra = state.extra;
                      if (extra is! DiagnosisEntryEntity) {
                        throw StateError(
                          'Brak poprawnej diagnozy w state.extra dla /app/diagnosis/details',
                        );
                      }
                      return DiagnosisDetailsPage(entry: extra);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(path: '/app/info', builder: (context, state) => const InfoPage()),
    ],
  );
});
