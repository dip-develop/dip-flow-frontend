import 'package:flutter/material.dart';

import 'theme.dart';

class LightAppThemeImpl implements AppTheme {
  const LightAppThemeImpl();

  @override
  ThemeData get themeData => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF8B5000),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFFFDCBE),
          onPrimaryContainer: Color(0xFF2C1600),
          secondary: Color(0xFF006C47),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFF77FBBB),
          onSecondaryContainer: Color(0xFF002113),
          tertiary: Color(0xFF4C4AD6),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFFE2DFFF),
          onTertiaryContainer: Color(0xFF0B006B),
          error: Color(0xFFBA1A1A),
          errorContainer: Color(0xFFFFDAD6),
          onError: Color(0xFFFFFFFF),
          onErrorContainer: Color(0xFF410002),
          background: Color(0xFFFFFBFF),
          onBackground: Color(0xFF201B16),
          surface: Color(0xFFFFFBFF),
          onSurface: Color(0xFF201B16),
          surfaceVariant: Color(0xFFF2DFD1),
          onSurfaceVariant: Color(0xFF51453A),
          outline: Color(0xFF837468),
          onInverseSurface: Color(0xFFFAEFE7),
          inverseSurface: Color(0xFF352F2B),
          inversePrimary: Color(0xFFFFB870),
          shadow: Color(0xFF000000),
          surfaceTint: Color(0xFF8B5000),
          outlineVariant: Color(0xFFD5C3B5),
          scrim: Color(0xFF000000),
        ),
      );
}
