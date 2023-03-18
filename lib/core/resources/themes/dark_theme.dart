import 'package:flutter/material.dart';

import 'theme.dart';

class DarkAppThemeImpl implements AppTheme {
  const DarkAppThemeImpl();

  @override
  ThemeData get themeData => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFFFFB77B),
          onPrimary: Color(0xFF4C2700),
          primaryContainer: Color(0xFF6D3A00),
          onPrimaryContainer: Color(0xFFFFDCC2),
          secondary: Color(0xFF53E080),
          onSecondary: Color(0xFF003918),
          secondaryContainer: Color(0xFF005225),
          onSecondaryContainer: Color(0xFF72FD9A),
          tertiary: Color(0xFF99CBFF),
          onTertiary: Color(0xFF003355),
          tertiaryContainer: Color(0xFF004A78),
          onTertiaryContainer: Color(0xFFCFE5FF),
          error: Color(0xFFFFB4AB),
          errorContainer: Color(0xFF93000A),
          onError: Color(0xFF690005),
          onErrorContainer: Color(0xFFFFDAD6),
          background: Color(0xFF201B17),
          onBackground: Color(0xFFECE0DA),
          surface: Color(0xFF201B17),
          onSurface: Color(0xFFECE0DA),
          surfaceVariant: Color(0xFF51443B),
          onSurfaceVariant: Color(0xFFD6C3B6),
          outline: Color(0xFF9E8E82),
          onInverseSurface: Color(0xFF201B17),
          inverseSurface: Color(0xFFECE0DA),
          inversePrimary: Color(0xFF8F4E00),
          shadow: Color(0xFF000000),
          surfaceTint: Color(0xFFFFB77B),
          outlineVariant: Color(0xFF51443B),
          scrim: Color(0xFF000000),
        ),
      );
}
