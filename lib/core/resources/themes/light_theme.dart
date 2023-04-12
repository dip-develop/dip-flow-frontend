import 'package:flutter/material.dart';

import 'theme.dart';

class LightAppThemeImpl implements AppTheme {
  const LightAppThemeImpl();

  @override
  ThemeData get themeData => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF006874),
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFF97F0FF),
          onPrimaryContainer: Color(0xFF001F24),
          secondary: Color(0xFF1660A5),
          onSecondary: Color(0xFFFFFFFF),
          secondaryContainer: Color(0xFFD3E4FF),
          onSecondaryContainer: Color(0xFF001C38),
          tertiary: Color(0xFFA83900),
          onTertiary: Color(0xFFFFFFFF),
          tertiaryContainer: Color(0xFFFFDBCF),
          onTertiaryContainer: Color(0xFF380D00),
          error: Color(0xFFBA1A1A),
          errorContainer: Color(0xFFFFDAD6),
          onError: Color(0xFFFFFFFF),
          onErrorContainer: Color(0xFF410002),
          background: Color(0xFFFAFDFD),
          onBackground: Color(0xFF191C1D),
          surface: Color(0xFFFAFDFD),
          onSurface: Color(0xFF191C1D),
          surfaceVariant: Color(0xFFDBE4E6),
          onSurfaceVariant: Color(0xFF3F484A),
          outline: Color(0xFF6F797A),
          onInverseSurface: Color(0xFFEFF1F1),
          inverseSurface: Color(0xFF2E3132),
          inversePrimary: Color(0xFF4FD8EB),
          shadow: Color(0xFF000000),
          surfaceTint: Color(0xFF006874),
          outlineVariant: Color(0xFFBFC8CA),
          scrim: Color(0xFF000000),
        ),
      );
}
