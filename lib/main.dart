import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'features/stories/presentation/providers/settings_provider.dart';
import 'features/stories/presentation/providers/story_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter('teret_bet');
  await Hive.openBox('story_cache');
  await Hive.openBox('settings');

  await _initializeFirebase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoryProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const TeretBetApp(),
    ),
  );
}

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error) {
    // Linux/desktop can still run the MVP from Hive/local JSON assets.
    debugPrint('Firebase unavailable on this platform: $error');
  }
}
