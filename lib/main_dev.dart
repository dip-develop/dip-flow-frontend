import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

import 'main.dart' as m;

void main() {
  FlavorConfig(
    name: 'DEVELOP',
    color: Colors.red,
    location: BannerLocation.bottomStart,
    variables: {
      'baseUrl': '127.0.0.1',
    },
  );
  m.main();
}
