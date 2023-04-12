import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'core/application.dart';
import 'main.config.dart';

@InjectableInit()
void _configureDependencies() => GetIt.I.init();

void main() {
  if (FlavorConfig.instance.variables.isEmpty) {
    FlavorConfig(
      name: 'PROD',
      color: Colors.green,
      location: BannerLocation.bottomStart,
      variables: {
        'baseUrl': 'theteam.run',
      },
    );
  }
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  _configureDependencies();
  runApp(const Application());
}
