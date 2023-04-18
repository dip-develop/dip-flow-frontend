import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../domain/models/models.dart';
import '../domain/usecases/usecases.dart';
import '../presentation/screens/auth/sign_in/sign_in_screen.dart';
import '../presentation/screens/auth/sign_up/sign_up_screen.dart';
import '../presentation/screens/dashboard/dashboard_screen.dart';
import '../presentation/screens/hr/hr_screen.dart';
import '../presentation/screens/projects/projects_screen.dart';
import '../presentation/screens/recruiter/recruiter_screen.dart';
import '../presentation/screens/reports/reports_screen.dart';
import '../presentation/screens/settings/settings_screen.dart';
import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/tasks/tasks_screen.dart';
import '../presentation/screens/team/team_screen.dart';
import '../presentation/screens/time_tracking/time_tracking_screen.dart';
import '../presentation/widgets/navigation_widget.dart';
import 'cubit/application_cubit.dart';

class AppRoute {
  static String splashRouteName = 'splash';
  static String authRouteName = 'auth';
  static String signInRouteName = 'signin';
  static String signUpRouteName = 'signup';
  static String dashboardRouteName = 'dashboard';

  static String timeTrackingRouteName = 'timetracking';
  static String tasksRouteName = 'tasks';
  static String projectsRouteName = 'projects';
  static String teamsRouteName = 'teams';
  static String hrRouteName = 'hr';
  static String recruiterRouteName = 'recruiter';
  static String reportsRouteName = 'reports';
  static String settingsRouteName = 'settings';

  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  final _shellNavigatorKey = GlobalKey<NavigatorState>();

  late final GoRouter _router;

  GoRouter get route => _router;

  AppRoute() {
    _router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      routes: [
        GoRoute(
            parentNavigatorKey: _rootNavigatorKey,
            name: splashRouteName,
            path: '/',
            pageBuilder: (context, state) =>
                _getTransition(state: state, child: const SplashScreen()),
            routes: [
              GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  name: authRouteName,
                  path: 'auth',
                  pageBuilder: (context, state) =>
                      _getTransition(state: state, child: const SignInScreen()),
                  redirect: (context, state) {
                    if (state.location == route.namedLocation(authRouteName)) {
                      return route.namedLocation(signInRouteName);
                    }
                    return state.location;
                  },
                  routes: [
                    GoRoute(
                      parentNavigatorKey: _rootNavigatorKey,
                      name: signInRouteName,
                      path: 'signin',
                      pageBuilder: (context, state) => _getTransition(
                          state: state, child: const SignInScreen()),
                    ),
                    GoRoute(
                      parentNavigatorKey: _rootNavigatorKey,
                      name: signUpRouteName,
                      path: 'signup',
                      pageBuilder: (context, state) => _getTransition(
                          state: state, child: const SignUpScreen()),
                    ),
                  ]),
            ]),
        ShellRoute(
            navigatorKey: _shellNavigatorKey,
            pageBuilder: (context, state, child) {
              return _getTransition(
                  state: state, child: NavigationWidget(child: child));
            },
            routes: [
              GoRoute(
                parentNavigatorKey: _shellNavigatorKey,
                name: dashboardRouteName,
                path: '/dashboard',
                pageBuilder: (context, state) => _getTransition(
                    state: state, child: const DashBoardScreen()),
              ),
              GoRoute(
                parentNavigatorKey: _shellNavigatorKey,
                name: timeTrackingRouteName,
                path: '/time-tracking',
                pageBuilder: (context, state) => _getTransition(
                    state: state, child: const TimeTrackingScreen()),
              ),
              GoRoute(
                parentNavigatorKey: _shellNavigatorKey,
                name: tasksRouteName,
                path: '/tasks',
                pageBuilder: (context, state) =>
                    _getTransition(state: state, child: const TasksScreen()),
              ),
              GoRoute(
                parentNavigatorKey: _shellNavigatorKey,
                name: projectsRouteName,
                path: '/projects',
                pageBuilder: (context, state) =>
                    _getTransition(state: state, child: const ProjectsScreen()),
              ),
              GoRoute(
                parentNavigatorKey: _shellNavigatorKey,
                name: teamsRouteName,
                path: '/teams',
                pageBuilder: (context, state) =>
                    _getTransition(state: state, child: const TeamScreen()),
              ),
              GoRoute(
                parentNavigatorKey: _shellNavigatorKey,
                name: hrRouteName,
                path: '/hr',
                pageBuilder: (context, state) =>
                    _getTransition(state: state, child: const HRScreen()),
              ),
              GoRoute(
                parentNavigatorKey: _shellNavigatorKey,
                name: recruiterRouteName,
                path: '/recruiter',
                pageBuilder: (context, state) => _getTransition(
                    state: state, child: const RecruiterScreen()),
              ),
              GoRoute(
                parentNavigatorKey: _shellNavigatorKey,
                name: reportsRouteName,
                path: '/reports',
                pageBuilder: (context, state) =>
                    _getTransition(state: state, child: const ReportsScreen()),
              ),
              GoRoute(
                parentNavigatorKey: _shellNavigatorKey,
                name: settingsRouteName,
                path: '/settings',
                pageBuilder: (context, state) =>
                    _getTransition(state: state, child: const SettingsScreen()),
              ),
            ]),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        GetIt.I<AnalyticsUseCase>().logScreenView(
            name: state.path ?? state.location, path: state.location);
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
