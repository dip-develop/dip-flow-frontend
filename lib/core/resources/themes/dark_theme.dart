import 'package:flutter/material.dart';

import 'theme.dart';

class DarkAppThemeImpl implements AppTheme {
  const DarkAppThemeImpl();

  @override
  ThemeData get themeData => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFFFFB870),
          onPrimary: Color(0xFF4A2800),
          primaryContainer: Color(0xFF693C00),
          onPrimaryContainer: Color(0xFFFFDCBE),
          secondary: Color(0xFF58DEA1),
          onSecondary: Color(0xFF003823),
          secondaryContainer: Color(0xFF005235),
          onSecondaryContainer: Color(0xFF77FBBB),
          tertiary: Color(0xFFC2C1FF),
          onTertiary: Color(0xFF1700A7),
          tertiaryContainer: Color(0xFF322DBD),
          onTertiaryContainer: Color(0xFFE2DFFF),
          error: Color(0xFFFFB4AB),
          errorContainer: Color(0xFF93000A),
          onError: Color(0xFF690005),
          onErrorContainer: Color(0xFFFFDAD6),
          background: Color(0xFF201B16),
          onBackground: Color(0xFFEBE0D9),
          surface: Color(0xFF201B16),
          onSurface: Color(0xFFEBE0D9),
          surfaceVariant: Color(0xFF51453A),
          onSurfaceVariant: Color(0xFFD5C3B5),
          outline: Color(0xFF9D8E81),
          onInverseSurface: Color(0xFF201B16),
          inverseSurface: Color(0xFFEBE0D9),
          inversePrimary: Color(0xFF8B5000),
          shadow: Color(0xFF000000),
          surfaceTint: Color(0xFFFFB870),
          outlineVariant: Color(0xFF51453A),
          scrim: Color(0xFF000000),
        ),
      );
}
