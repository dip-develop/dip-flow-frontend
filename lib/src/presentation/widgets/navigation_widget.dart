import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_route.dart';
import '../../core/generated/i18n/app_localizations.dart';
import 'user_button_widget.dart';

class NavigationWidget extends StatefulWidget {
  final Widget child;

  const NavigationWidget({super.key, required this.child});

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  int? _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectMenu();
  }

  @override
  void didUpdateWidget(covariant NavigationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldSelectedTab = _selectedTab;
    _selectMenu();
    if (oldSelectedTab != _selectedTab) {
      setState(() {});
    }
  }

  void _selectMenu() {
    final route = GetIt.I<AppRoute>().route;
    final location = route.state.uri.path;
    if (location == route.namedLocation(AppRoute.dashboardRouteName)) {
      _selectedTab = 0;
    } else if (location
        .contains(route.namedLocation(AppRoute.timeTrackingRouteName))) {
      _selectedTab = 1;
    } else if (location
        .contains(route.namedLocation(AppRoute.tasksRouteName))) {
      _selectedTab = 2;
    } else if (location
        .contains(route.namedLocation(AppRoute.projectsRouteName))) {
      _selectedTab = 3;
    } else if (location
        .contains(route.namedLocation(AppRoute.teamsRouteName))) {
      _selectedTab = 4;
    } else if (location.contains(route.namedLocation(AppRoute.hrRouteName))) {
      _selectedTab = 5;
    } else if (location
        .contains(route.namedLocation(AppRoute.recruiterRouteName))) {
      _selectedTab = 6;
    } else if (location
        .contains(route.namedLocation(AppRoute.reportsRouteName))) {
      _selectedTab = 7;
    } else if (location
            .contains(route.namedLocation(AppRoute.profileRouteName)) ||
        location.contains(route.namedLocation(AppRoute.settingsRouteName))) {
      _selectedTab = 8;
    } else {
      _selectedTab = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (Theme.of(context).brightness == Brightness.dark
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light)
          .copyWith(
              systemNavigationBarColor: Theme.of(context).colorScheme.surface),
      child: AdaptiveScaffold(
        appBar: AppBar(actions: const [
          UserButtonWidget(),
        ]),
        leadingExtendedNavRail: Breakpoints.mediumAndUp.isActive(context)
            ? const UserButtonWidget()
            : const SizedBox(
                height: 16.0,
              ),
        leadingUnextendedNavRail: Breakpoints.mediumAndUp.isActive(context)
            ? const UserButtonWidget()
            : null,
        selectedIndex: _selectedTab,
        internalAnimations: false,
        onSelectedIndexChange: (int index) {
          switch (index) {
            case 0:
              context.goNamed(AppRoute.dashboardRouteName);
              break;
            case 1:
              context.pushNamed(AppRoute.timeTrackingRouteName);
              break;
            case 2:
              context.pushNamed(AppRoute.tasksRouteName);
              break;
            case 3:
              context.pushNamed(AppRoute.projectsRouteName);
              break;
            case 4:
              context.pushNamed(AppRoute.teamsRouteName);
              break;
            case 5:
              context.pushNamed(AppRoute.hrRouteName);
              break;
            case 6:
              context.pushNamed(AppRoute.recruiterRouteName);
              break;
            case 7:
              context.pushNamed(AppRoute.reportsRouteName);
              break;
            case 8:
              context.pushNamed(AppRoute.settingsRouteName);
              break;
            default:
          }
          setState(() {
            _selectedTab = index;
          });

          /* if (Scaffold .of(context).isDrawerOpen) {
            Scaffold.of(context).closeDrawer();
          } */
        },
        drawerBreakpoint: Breakpoints.small,
        destinations: <NavigationDestination>[
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: AppLocalizations.of(context)!.dashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.timer_outlined),
            selectedIcon: const Icon(Icons.timer),
            label: AppLocalizations.of(context)!.timeTracking,
          ),
          NavigationDestination(
            icon: const Icon(Icons.task_outlined),
            selectedIcon: const Icon(Icons.task),
            label: AppLocalizations.of(context)!.tasks,
          ),
          NavigationDestination(
            icon: const Icon(Icons.code_outlined),
            selectedIcon: const Icon(Icons.code),
            label: AppLocalizations.of(context)!.projects,
          ),
          NavigationDestination(
            icon: const Icon(Icons.group_outlined),
            selectedIcon: const Icon(Icons.group),
            label: AppLocalizations.of(context)!.teams,
          ),
          NavigationDestination(
            icon: const Icon(Icons.diversity_3_outlined),
            selectedIcon: const Icon(Icons.diversity_3),
            label: AppLocalizations.of(context)!.hr,
          ),
          NavigationDestination(
            icon: const Icon(Icons.find_replace_outlined),
            selectedIcon: const Icon(Icons.find_replace),
            label: AppLocalizations.of(context)!.recruiter,
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart),
            label: AppLocalizations.of(context)!.reports,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: AppLocalizations.of(context)!.settings,
          ),
        ],
        body: (_) => SafeArea(child: widget.child),
      ),
    );
  }
}
