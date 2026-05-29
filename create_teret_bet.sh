#!/bin/bash

APP_NAME="teret_bet_app"

flutter create $APP_NAME
cd $APP_NAME || exit

mkdir -p lib/core/theme
mkdir -p lib/features/stories/data/models
mkdir -p lib/features/stories/data/services
mkdir -p lib/features/stories/presentation/screens
mkdir -p lib/features/stories/presentation/widgets
mkdir -p lib/features/stories/presentation/providers

cat > pubspec.yaml <<'EOF'
name: teret_bet_app
description: Amharic children's storybook app.
publish_to: "none"

version: 1.0.0+1

environment:
  sdk: ">=3.4.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.8
  firebase_core: ^3.8.0
  cloud_firestore: ^5.5.0
  provider: ^6.1.2
  cached_network_image: ^3.4.1
  hive: ^2.2.3
  hive_flutter: ^1.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true
EOF

cat > lib/main.dart <<'EOF'
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
EOF

cat > lib/app.dart <<'EOF'
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
EOF

cat > lib/features/stories/data/models/story_model.dart <<'EOF'
class Story {
  final String id;
  final String titleAm;
  final String titleEn;
  final String coverImage;
  final String summaryAm;
  final int ageMin;
  final int ageMax;

  Story({
    required this.id,
    required this.titleAm,
    required this.titleEn,
    required this.coverImage,
    required this.summaryAm,
    required this.ageMin,
    required this.ageMax,
  });

  factory Story.fromFirestore(Map<String, dynamic> data, String id) {
    return Story(
      id: id,
      titleAm: data['titleAm'] ?? '',
      titleEn: data['titleEn'] ?? '',
      coverImage: data['coverImage'] ?? '',
      summaryAm: data['summaryAm'] ?? data['summary'] ?? '',
      ageMin: data['ageMin'] ?? 3,
      ageMax: data['ageMax'] ?? 6,
    );
  }
}
EOF

cat > lib/features/stories/data/models/story_page_model.dart <<'EOF'
class StoryPage {
  final int pageNumber;
  final String textAm;
  final String? textEn;
  final String imageUrl;

  StoryPage({
    required this.pageNumber,
    required this.textAm,
    this.textEn,
    required this.imageUrl,
  });

  factory StoryPage.fromMap(Map<String, dynamic> data) {
    return StoryPage(
      pageNumber: data['pageNumber'] ?? 0,
      textAm: data['textAm'] ?? '',
      textEn: data['textEn'],
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
EOF

cat > lib/features/stories/data/services/story_service.dart <<'EOF'
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/story_model.dart';
import '../models/story_page_model.dart';

class StoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Story>> fetchStories() async {
    final snapshot = await _db.collection('stories').get();

    return snapshot.docs.map((doc) {
      return Story.fromFirestore(doc.data(), doc.id);
    }).toList();
  }

  Future<List<StoryPage>> fetchStoryPages(String storyId) async {
    final snapshot = await _db
        .collection('stories')
        .doc(storyId)
        .collection('pages')
        .orderBy('pageNumber')
        .get();

    return snapshot.docs.map((doc) {
      return StoryPage.fromMap(doc.data());
    }).toList();
  }
}
EOF

cat > lib/features/stories/presentation/providers/story_provider.dart <<'EOF'
import 'package:flutter/material.dart';

import '../../data/models/story_model.dart';
import '../../data/services/story_service.dart';

class StoryProvider with ChangeNotifier {
  final StoryService _service = StoryService();

  List<Story> _stories = [];
  bool _isLoading = false;

  List<Story> get stories => _stories;
  bool get isLoading => _isLoading;

  Future<void> loadStories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _stories = await _service.fetchStories();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
EOF

cat > lib/features/stories/presentation/screens/home_screen.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/story_provider.dart';
import '../widgets/story_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<StoryProvider>(context, listen: false).loadStories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ተረት ቤት'),
        centerTitle: true,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: provider.stories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final story = provider.stories[index];
                return StoryCard(story: story);
              },
            ),
    );
  }
}
EOF

cat > lib/features/stories/presentation/widgets/story_card.dart <<'EOF'
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../data/models/story_model.dart';
import '../screens/story_details_screen.dart';

class StoryCard extends StatelessWidget {
  final Story story;

  const StoryCard({
    super.key,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StoryDetailsScreen(story: story),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: story.coverImage,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (_, __, ___) => const Icon(Icons.image, size: 48),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                story.titleAm,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
EOF

cat > lib/features/stories/presentation/screens/story_details_screen.dart <<'EOF'
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../data/models/story_model.dart';
import 'story_reader_screen.dart';

class StoryDetailsScreen extends StatelessWidget {
  final Story story;

  const StoryDetailsScreen({
    super.key,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(story.titleAm),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CachedNetworkImage(
                imageUrl: story.coverImage,
                height: 260,
                width: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => const Icon(Icons.image, size: 80),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              story.titleAm,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              story.summaryAm,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                height: 1.6,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StoryReaderScreen(story: story),
                    ),
                  );
                },
                child: const Text(
                  'ጀምር',
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
EOF

cat > lib/features/stories/presentation/screens/story_reader_screen.dart <<'EOF'
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../data/models/story_model.dart';
import '../../data/models/story_page_model.dart';
import '../../data/services/story_service.dart';

class StoryReaderScreen extends StatefulWidget {
  final Story story;

  const StoryReaderScreen({
    super.key,
    required this.story,
  });

  @override
  State<StoryReaderScreen> createState() => _StoryReaderScreenState();
}

class _StoryReaderScreenState extends State<StoryReaderScreen> {
  final StoryService _storyService = StoryService();
  final PageController _pageController = PageController();

  List<StoryPage> _pages = [];
  bool _isLoading = true;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadPages();
  }

  Future<void> _loadPages() async {
    final pages = await _storyService.fetchStoryPages(widget.story.id);

    setState(() {
      _pages = pages;
      _isLoading = false;
    });
  }

  void _goNext() {
    if (_currentPageIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _goBack() {
    if (_currentPageIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_pages.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.story.titleAm)),
        body: const Center(
          child: Text('No pages found for this story.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E7),
      appBar: AppBar(
        title: Text(widget.story.titleAm),
        centerTitle: true,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentPageIndex + 1) / _pages.length,
            minHeight: 6,
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final page = _pages[index];

                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: CachedNetworkImage(
                            imageUrl: page.imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) =>
                                const Icon(Icons.image, size: 80),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        flex: 3,
                        child: SingleChildScrollView(
                          child: Text(
                            page.textAm,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 25,
                              height: 1.7,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _currentPageIndex == 0 ? null : _goBack,
                    child: const Text(
                      'ተመለስ',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        _currentPageIndex == _pages.length - 1 ? null : _goNext,
                    child: const Text(
                      'ቀጣይ',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
EOF

cat > README.md <<'EOF'
# Teret Bet / ተረት ቤት

A cross-platform Flutter app for illustrated Amharic children's stories.

## MVP Features

- Story library screen
- Story details screen
- Page-based story reader
- Amharic-first UI
- Firebase Firestore integration
- Cached network images
- Prepared for offline support with Hive

## Tech Stack

- Flutter
- Firebase Firestore
- Provider for state management
- Cached Network Image
- Hive planned for full offline story caching

## Project Structure

```text
lib/
├── main.dart
├── app.dart
├── core/
│   └── theme/
└── features/
    └── stories/
        ├── data/
        │   ├── models/
        │   │   ├── story_model.dart
        │   │   └── story_page_model.dart
        │   └── services/
        │       └── story_service.dart
        └── presentation/
            ├── providers/
            │   └── story_provider.dart
            ├── screens/
            │   ├── home_screen.dart
            │   ├── story_details_screen.dart
            │   └── story_reader_screen.dart
            └── widgets/
                └── story_card.dart