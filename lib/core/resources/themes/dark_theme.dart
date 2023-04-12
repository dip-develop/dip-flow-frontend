import 'package:flutter/material.dart';

import 'theme.dart';

class DarkAppThemeImpl implements AppTheme {
  const DarkAppThemeImpl();

  @override
  ThemeData get themeData => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFF4FD8EB),
          onPrimary: Color(0xFF00363D),
          primaryContainer: Color(0xFF004F58),
          onPrimaryContainer: Color(0xFF97F0FF),
          secondary: Color(0xFFA3C9FF),
          onSecondary: Color(0xFF00315C),
          secondaryContainer: Color(0xFF004882),
          onSecondaryContainer: Color(0xFFD3E4FF),
          tertiary: Color(0xFFFFB59A),
          onTertiary: Color(0xFF5B1B00),
          tertiaryContainer: Color(0xFF802A00),
          onTertiaryContainer: Color(0xFFFFDBCF),
          error: Color(0xFFFFB4AB),
          errorContainer: Color(0xFF93000A),
          onError: Color(0xFF690005),
          onErrorContainer: Color(0xFFFFDAD6),
          background: Color(0xFF191C1D),
          onBackground: Color(0xFFE1E3E3),
          surface: Color(0xFF191C1D),
          onSurface: Color(0xFFE1E3E3),
          surfaceVariant: Color(0xFF3F484A),
          onSurfaceVariant: Color(0xFFBFC8CA),
          outline: Color(0xFF899294),
          onInverseSurface: Color(0xFF191C1D),
          inverseSurface: Color(0xFFE1E3E3),
          inversePrimary: Color(0xFF006874),
          shadow: Color(0xFF000000),
          surfaceTint: Color(0xFF4FD8EB),
          outlineVariant: Color(0xFF3F484A),
          scrim: Color(0xFF000000),
        ),
      );
}
