import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tray_manager/tray_manager.dart';

import '../../../core/app_route.dart';
import '../../../core/cubits/application_cubit.dart';
import '../../../domain/usecases/usecases.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> _initApp(BuildContext context) async {
    await Hive.initFlutter('theteam').catchError((onError) {});
    if (!GetIt.I.isRegistered<PackageInfo>()) {
      await PackageInfo.fromPlatform().then((value) {
        GetIt.I.registerSingleton<PackageInfo>(value);
      }).catchError((onError) {});
    }
    if (!GetIt.I.isRegistered<BaseDeviceInfo>()) {
      await DeviceInfoPlugin().deviceInfo.then((value) {
        GetIt.I.registerSingleton<BaseDeviceInfo>(value);
      }).catchError((onError) {});
    }

    if (!kIsWeb &&
        (Platform.isLinux || Platform.isWindows || Platform.isMacOS)) {
      launchAtStartup.setup(
        appName: GetIt.I<PackageInfo>().appName,
        appPath: Platform.resolvedExecutable,
      );
      await GetIt.I<ApplicationCubit>().checkLaunchAtStartup();
      await trayManager.setIcon(
        Platform.isWindows
            ? 'assets/images/tray_icon.ico'
            : 'assets/images/tray_icon.png',
      );
      final menu = Menu(
        items: [
          MenuItem(
            key: 'show_window',
            // ignore: use_build_context_synchronously
            label: AppLocalizations.of(context)!.showWindow,
          ),
          MenuItem.separator(),
          MenuItem(
            key: 'exit_app',
            // ignore: use_build_context_synchronously
            label: AppLocalizations.of(context)!.exitApp,
          ),
        ],
      );
      await trayManager.setContextMenu(menu);
    }

    FlutterNativeSplash.remove();
    return Future.delayed(Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    if (!GetIt.I.isRegistered<PackageInfo>()) {
      _initApp(context).whenComplete(() => GetIt.I<AuthUseCase>().isAuth.then(
          (isAuth) => context.goNamed(
              isAuth ? AppRoute.dashboardRouteName : AppRoute.authRouteName)));
    }
    return Material(
      child: Center(
          child: Text(
        'TheTeam',
        style: Theme.of(context).textTheme.headlineLarge,
      )),
    );
  }
}
