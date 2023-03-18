import 'package:flutter/material.dart';

import 'theme.dart';

class LightAppThemeImpl implements AppTheme {
  const LightAppThemeImpl();

  @override
  ThemeData get themeData {
    final theme = ThemeData.light();
    return theme.copyWith(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFF8F4E00),
        onPrimary: Color(0xFFFFFFFF),
        primaryContainer: Color(0xFFFFDCC2),
        onPrimaryContainer: Color(0xFF2E1500),
        secondary: Color(0xFF006D33),
        onSecondary: Color(0xFFFFFFFF),
        secondaryContainer: Color(0xFF72FD9A),
        onSecondaryContainer: Color(0xFF00210B),
        tertiary: Color(0xFF00629D),
        onTertiary: Color(0xFFFFFFFF),
        tertiaryContainer: Color(0xFFCFE5FF),
        onTertiaryContainer: Color(0xFF001D34),
        error: Color(0xFFBA1A1A),
        errorContainer: Color(0xFFFFDAD6),
        onError: Color(0xFFFFFFFF),
        onErrorContainer: Color(0xFF410002),
        background: Color(0xFFFFFBFF),
        onBackground: Color(0xFF201B17),
        surface: Color(0xFFFFFBFF),
        onSurface: Color(0xFF201B17),
        surfaceVariant: Color(0xFFF3DFD1),
        onSurfaceVariant: Color(0xFF51443B),
        outline: Color(0xFF847469),
        onInverseSurface: Color(0xFFFAEEE8),
        inverseSurface: Color(0xFF352F2B),
        inversePrimary: Color(0xFFFFB77B),
        shadow: Color(0xFF000000),
        surfaceTint: Color(0xFF8F4E00),
        outlineVariant: Color(0xFFD6C3B6),
        scrim: Color(0xFF000000),
      ),
    );
  }
}
