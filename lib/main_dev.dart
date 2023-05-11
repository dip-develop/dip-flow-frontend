import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:logging/logging.dart';

import 'main.dart' as m;

void main() {
  Logger.root.level = Level.ALL;
  FlavorConfig(
    name: 'DEVELOP',
    variables: {
      'baseUrl': 'localhost',
      'basePort': 8080,
    },
  );
  m.main();
}
