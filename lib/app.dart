import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/stories/presentation/providers/settings_provider.dart';
import 'features/stories/presentation/screens/home_screen.dart';
import 'features/stories/presentation/screens/language_selection_screen.dart';
import 'theme/teret_bet_theme.dart';

class TeretBetApp extends StatelessWidget {
  const TeretBetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) => MaterialApp(
        title: 'ተረት ቤት',
        debugShowCheckedModeBanner: false,
        theme: TeretBetTheme.day,
        darkTheme: TeretBetTheme.bedtime,
        themeMode: settings.bedtimeMode ? ThemeMode.dark : ThemeMode.light,
        home: settings.hasSelectedLanguage
            ? const HomeScreen()
            : const LanguageSelectionScreen(),
      ),
    );
  }
}
