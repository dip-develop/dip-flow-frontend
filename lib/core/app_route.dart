import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/screens/splash/splash_screen.dart';

class AppRoute {
  static String splashLocationName = 'splash';

  final _listenners = List<ValueChanged<String>>.empty(growable: true);

  late final GoRouter _router;

  GoRouter get route => _router;

  void addListenner(ValueChanged<String> listenner) {
    _listenners.add(listenner);
  }

  void clearListenners() {
    _listenners.clear();
  }

  AppRoute() {
    _router = GoRouter(
      routes: <GoRoute>[
        GoRoute(
          name: splashLocationName,
          path: '/',
          pageBuilder: (context, state) =>
              _getTransition(state: state, child: const SplashScreen()),
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        switch (state.location) {
          default:
            return null;
        }
      },
      errorBuilder: (context, state) {
        return const Center(child: Text('ERROR - Page not found'));
      },
    );
    _router.addListener(_routeListtenner);
  }

  void _routeListtenner() {
    for (var element in _listenners) {
      element.call(_router.location);
    }
  }

  Page<void> _getTransition({
    required GoRouterState state,
    required Widget child,
  }) {
    return MaterialPage<void>(
      key: state.pageKey,
      child: child,
    );
  }

  void dispose() {
    _router.removeListener(_routeListtenner);
  }
}
