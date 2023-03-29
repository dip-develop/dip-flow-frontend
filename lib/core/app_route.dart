import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../domain/models/models.dart';
import '../presentation/screens/auth/sign_in/sign_in_screen.dart';
import '../presentation/screens/auth/sign_up/sign_up_screen.dart';
import '../presentation/screens/dashboard/dashboard_screen.dart';
import '../presentation/screens/splash/splash_screen.dart';
import 'cubit/application_cubit.dart';

class AppRoute {
  static String splashRouteName = 'splash';
  static String authRouteName = 'auth';
  static String signInRouteName = 'signin';
  static String signUpRouteName = 'signup';
  static String dashBoardRouteName = 'dashboard';

  late final GoRouter _router;

  GoRouter get route => _router;

  AppRoute() {
    _router = GoRouter(
      routes: <GoRoute>[
        GoRoute(
            name: splashRouteName,
            path: '/',
            pageBuilder: (context, state) =>
                _getTransition(state: state, child: const SplashScreen()),
            routes: [
              GoRoute(
                  name: authRouteName,
                  path: 'auth',
                  redirect: (context, state) {
                    if (state.location == route.namedLocation(authRouteName)) {
                      return route.namedLocation(signInRouteName);
                    }
                    return state.location;
                  },
                  routes: [
                    GoRoute(
                      name: signInRouteName,
                      path: 'signin',
                      pageBuilder: (context, state) => _getTransition(
                          state: state, child: const SignInScreen()),
                    ),
                    GoRoute(
                      name: signUpRouteName,
                      path: 'signup',
                      pageBuilder: (context, state) => _getTransition(
                          state: state, child: const SignUpScreen()),
                    ),
                  ]),
              GoRoute(
                name: dashBoardRouteName,
                path: 'dashboard',
                pageBuilder: (context, state) => _getTransition(
                    state: state, child: const DashBoardScreen()),
              ),
            ]),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        if (state.location != route.namedLocation(splashRouteName) &&
            state.location != route.namedLocation(authRouteName) &&
            state.location != route.namedLocation(signInRouteName) &&
            state.location != route.namedLocation(signUpRouteName)) {
          final appCubit = GetIt.I<ApplicationCubit>();
          if (appCubit.state.auth != AuthState.authorized) {
            return route.namedLocation(authRouteName);
          }
          return null;
        }
        return null;
      },
      errorBuilder: (context, state) {
        return const Center(child: Text('ERROR - Page not found'));
      },
    );
  }

  Page<void> _getTransition({
    required GoRouterState state,
    required Widget child,
  }) =>
      (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS)
          ? MaterialPage(
              key: state.pageKey,
              child: child,
            )
          : NoTransitionPage(key: state.pageKey, child: child);
}
