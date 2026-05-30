import 'package:flutter/material.dart';

import 'features/stories/presentation/screens/home_screen.dart';

class TeretBetApp extends StatelessWidget {
  const TeretBetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ተረት ቤት',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'NotoSansEthiopic',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4FB7A5),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
