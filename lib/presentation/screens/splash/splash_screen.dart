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
import 'package:system_tray/system_tray.dart';

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

      // ignore: use_build_context_synchronously
      await _initSystemTray(context);
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

  Future<void> _initSystemTray(BuildContext context) async {
    final path = Platform.isWindows
        ? 'assets/images/launch_icon.ico'
        : 'assets/images/launch_icon.png';

    final appWindow = AppWindow();
    final systemTray = SystemTray();
    await systemTray.initSystemTray(
      title: AppLocalizations.of(context)!.exitApp,
      iconPath: path,
    );
    final Menu menu = Menu();
    await menu.buildFrom([
      MenuItemLabel(
          // ignore: use_build_context_synchronously
          label: AppLocalizations.of(context)!.showWindow,
          onClicked: (menuItem) => appWindow.show()),
      MenuItemLabel(
          // ignore: use_build_context_synchronously
          label: AppLocalizations.of(context)!.exitApp,
          onClicked: (menuItem) => appWindow.close()),
    ]);
    await systemTray.setContextMenu(menu);
    systemTray.registerSystemTrayEventHandler((eventName) {
      if (eventName == kSystemTrayEventClick) {
        Platform.isWindows ? appWindow.show() : systemTray.popUpContextMenu();
      } else if (eventName == kSystemTrayEventRightClick) {
        Platform.isWindows ? systemTray.popUpContextMenu() : appWindow.show();
      }
    });
  }
}
