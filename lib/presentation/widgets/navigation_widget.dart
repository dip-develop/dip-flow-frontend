import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
            context.goNamed(AppRoute.timeTrackingRouteName);
            break;

          case 2:
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
