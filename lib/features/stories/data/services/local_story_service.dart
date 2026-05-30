import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/story_model.dart';
import '../models/story_page_model.dart';

class LocalStoryService {
  static const String _storyAssetFolder = 'assets/stories/';

  Future<List<Story>> fetchStories() async {
    final storyFiles = await _findStoryAssetFiles();
    final stories = <Story>[];

    for (final path in storyFiles) {
      final storyJson = await _loadStoryJsonFromPath(path);
      stories.add(Story.fromJson(storyJson));
    }

    stories.sort((a, b) => a.titleAm.compareTo(b.titleAm));
    return stories;
  }

  Future<List<StoryPage>> fetchStoryPages(String storyId) async {
    final storyJson = await _loadStoryJson(storyId);
    final pagesJson = storyJson['pages'] as List? ?? [];

    final pages = pagesJson
        .map((item) => StoryPage.fromMap(Map<String, dynamic>.from(item)))
        .toList();

    pages.sort((a, b) => a.pageNumber.compareTo(b.pageNumber));
    return pages;
  }

  Future<List<String>> _findStoryAssetFiles() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);

    final storyFiles = manifest.listAssets().where((path) {
      return path.startsWith(_storyAssetFolder) && path.endsWith('.json');
    }).toList();

    storyFiles.sort();
    return storyFiles;
  }

  Future<Map<String, dynamic>> _loadStoryJson(String storyId) {
    return _loadStoryJsonFromPath('$_storyAssetFolder$storyId.json');
  }

  Future<Map<String, dynamic>> _loadStoryJsonFromPath(String path) async {
    final jsonString = await rootBundle.loadString(path);
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }
}
