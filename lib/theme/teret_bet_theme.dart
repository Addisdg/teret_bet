import 'package:flutter/material.dart';

class TeretBetTheme {
  static const _daySeed = Color(0xFFB85C38);
  static const _bedtimeSeed = Color(0xFFD49A6A);
  static const _dayBackground = Color(0xFFFFF8EE);
  static const _bedtimeBackground = Color(0xFF171720);

  static ThemeData get day {
    final colors = ColorScheme.fromSeed(
      seedColor: _daySeed,
      brightness: Brightness.light,
      surface: _dayBackground,
    );
    return _base(colors).copyWith(scaffoldBackgroundColor: _dayBackground);
  }

  static ThemeData get bedtime {
    final colors = ColorScheme.fromSeed(
      seedColor: _bedtimeSeed,
      brightness: Brightness.dark,
      surface: _bedtimeBackground,
    );
    return _base(colors).copyWith(
      scaffoldBackgroundColor: _bedtimeBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF171720),
        foregroundColor: Color(0xFFF6E7D8),
      ),
    );
  }

  static ThemeData _base(ColorScheme colors) {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'NotoSansEthiopic',
      colorScheme: colors,
      cardTheme: CardThemeData(
        elevation: 0,
        color: colors.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: colors.secondaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }
}
