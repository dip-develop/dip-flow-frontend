import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_route.dart';

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
    if (GetIt.I<AppRoute>().route.location ==
        GetIt.I<AppRoute>().route.namedLocation(AppRoute.dashboardRouteName)) {
      _selectedTab = 0;
    } else if (GetIt.I<AppRoute>().route.location.contains(
        GetIt.I<AppRoute>().route.namedLocation(AppRoute.teamRouteName))) {
      _selectedTab = 1;
    } else if (GetIt.I<AppRoute>().route.location.contains(GetIt.I<AppRoute>()
        .route
        .namedLocation(AppRoute.timeTrackingRouteName))) {
      _selectedTab = 2;
    } else if (GetIt.I<AppRoute>().route.location.contains(
        GetIt.I<AppRoute>().route.namedLocation(AppRoute.settingsRouteName))) {
      _selectedTab = 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      useDrawer: false,
      selectedIndex: _selectedTab,
      internalAnimations: false,
      onSelectedIndexChange: (int index) {
        switch (index) {
          case 0:
            context.goNamed(AppRoute.dashboardRouteName);
            break;
          case 1:
            context.goNamed(AppRoute.teamRouteName);
            break;
          case 2:
            context.goNamed(AppRoute.timeTrackingRouteName);
            break;
          case 3:
            context.goNamed(AppRoute.settingsRouteName);
            break;
          default:
        }
        setState(() {
          _selectedTab = index;
        });
      },
      destinations: <NavigationDestination>[
        NavigationDestination(
          icon: const Icon(Icons.dashboard_outlined),
          selectedIcon: const Icon(Icons.dashboard),
          label: AppLocalizations.of(context)!.dashboard,
        ),
        NavigationDestination(
          icon: const Icon(Icons.people_outline),
          selectedIcon: const Icon(Icons.people),
          label: AppLocalizations.of(context)!.team,
        ),
        NavigationDestination(
          icon: const Icon(Icons.timer_outlined),
          selectedIcon: const Icon(Icons.timer),
          label: AppLocalizations.of(context)!.timeTracking,
        ),
        NavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: AppLocalizations.of(context)!.settings,
        ),
      ],
      body: (_) => widget.child,
      //smallBody: (_) => widget.child,
    );
  }
}
