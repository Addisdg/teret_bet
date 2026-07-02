import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/stories/presentation/providers/settings_provider.dart';
import 'features/stories/presentation/screens/home_screen.dart';
import 'features/stories/presentation/screens/language_selection_screen.dart';

class TeretBetApp extends StatelessWidget {
  const TeretBetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) => MaterialApp(
        title: 'ተረት ቤት',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'NotoSansEthiopic',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4FB7A5),
          ),
        ),
        home: settings.hasSelectedLanguage
            ? const HomeScreen()
            : const LanguageSelectionScreen(),
      ),
    );
  }
}
