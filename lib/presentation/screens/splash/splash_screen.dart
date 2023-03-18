import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:window_size/window_size.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> _initApp(BuildContext context) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;

    GetIt.I.registerSingleton<PackageInfo>(packageInfo);
    GetIt.I.registerSingleton<BaseDeviceInfo>(deviceInfo);

    if (defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      setWindowMinSize(const Size(640, 540));
    }
    FlutterNativeSplash.remove();

    return Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    if (!GetIt.I.isRegistered<PackageInfo>()) {
      _initApp(
              context) /* .whenComplete(() =>
          context.pushReplacementNamed(AppRoute.connectionsLocationName)) */
          ;
    }
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2C3B53), Color(0xFF090F19)]),
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
