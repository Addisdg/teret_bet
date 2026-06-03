import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/story_model.dart';
import '../models/story_page_model.dart';

class LocalStoryService {
  static const String _storyAssetFolder = 'assets/stories/';
  static const String _storyManifestPath =
      '${_storyAssetFolder}story_manifest.json';

  Future<List<Story>> fetchStories() async {
    final storyIds = await _loadStoryIds();
    final stories = <Story>[];

    for (final storyId in storyIds) {
      final storyJson = await _loadStoryJson(storyId);
      stories.add(Story.fromJson(storyJson));
    }

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

  Future<List<String>> _loadStoryIds() async {
    try {
      final jsonString = await rootBundle.loadString(_storyManifestPath);
      final decoded = jsonDecode(jsonString) as List;

      return decoded.whereType<String>().toList();
    } catch (_) {
      // Keep local fallback resilient if the manifest is missing in old builds.
      return _discoverStoryIdsFromAssets();
    }
  }

  Future<List<String>> _discoverStoryIdsFromAssets() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);

    final storyIds = manifest.listAssets().where((path) {
      return path.startsWith(_storyAssetFolder) &&
          path.endsWith('.json') &&
          path != _storyManifestPath;
    }).map((path) {
      return path.replaceFirst(_storyAssetFolder, '').replaceFirst('.json', '');
    }).toList();

    storyIds.sort();
    return storyIds;
  }

  Future<Map<String, dynamic>> _loadStoryJson(String storyId) {
    return _loadStoryJsonFromPath('$_storyAssetFolder$storyId.json');
  }

  Future<Map<String, dynamic>> _loadStoryJsonFromPath(String path) async {
    final jsonString = await rootBundle.loadString(path);
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }
}
