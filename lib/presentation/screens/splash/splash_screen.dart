import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:window_size/window_size.dart';

import '../../../core/app_route.dart';
import '../../../domain/usecases/usecases.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> _initApp(BuildContext context) async {
    await Hive.initFlutter('musmula').catchError((onError) {});
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
    if (defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      setWindowMinSize(const Size(640, 400));
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
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.onPrimary
              ]),
        ),
        child: const Center(
            child: /*  Image.asset(
          'assets/images/logo_long_dark.png',
          width: 285.0,
        ) */

                Text('Loading...')),
      ),
    );
  }
}
