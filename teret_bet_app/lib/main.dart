import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'features/stories/presentation/providers/story_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // After Firebase setup, this initializes Firebase.
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (_) => StoryProvider(),
      child: const TeretBetApp(),
    ),
  );
}
