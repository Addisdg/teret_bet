import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'features/stories/presentation/providers/story_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
      create: (_) => StoryProvider(),
      child: const TeretBetApp(),
    ),
  );
}
