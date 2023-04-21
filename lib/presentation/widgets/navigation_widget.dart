import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

import '../../core/app_route.dart';
import 'user_button_widget.dart';

class NavigationWidget extends StatefulWidget {
  final Widget child;

  const NavigationWidget({super.key, required this.child});

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget>
    with TrayListener, WindowListener {
  int? _selectedTab;

  @override
  void initState() {
    trayManager.addListener(this);
    windowManager.addListener(this);
    super.initState();
    _selectMenu();
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    windowManager.removeListener(this);
    super.dispose();
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
    final location = route.location;
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
  void onTrayMenuItemClick(MenuItem menuItem) {
    if (menuItem.key == 'show_window') {
      windowManager.show();
    } else if (menuItem.key == 'exit_app') {
      windowManager.destroy();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: AppBar(actions: const [UserButtonWidget()]),
      leadingExtendedNavRail: const UserButtonWidget(),
      leadingUnextendedNavRail: const UserButtonWidget(),
      selectedIndex: _selectedTab,
      internalAnimations: false,
      onSelectedIndexChange: (int index) {
        switch (index) {
          case 0:
            context.goNamed(AppRoute.dashboardRouteName);
            break;
          case 1:
            context.goNamed(AppRoute.timeTrackingRouteName);
            break;
          case 2:
            context.goNamed(AppRoute.tasksRouteName);
            break;
          case 3:
            context.goNamed(AppRoute.projectsRouteName);
            break;
          case 4:
            context.goNamed(AppRoute.teamsRouteName);
            break;
          case 5:
            context.goNamed(AppRoute.hrRouteName);
            break;
          case 6:
            context.goNamed(AppRoute.recruiterRouteName);
            break;
          case 7:
            context.goNamed(AppRoute.reportsRouteName);
            break;
          case 8:
            context.goNamed(AppRoute.settingsRouteName);
            break;
          default:
        }
        setState(() {
          _selectedTab = index;
        });
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
    );
  }
}
