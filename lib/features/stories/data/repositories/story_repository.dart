import 'dart:convert';

import 'package:hive/hive.dart';

import '../models/story_model.dart';
import '../models/story_page_model.dart';
import '../services/firestore_story_service.dart';
import '../services/local_story_service.dart';

class StoryRepository {
  final FirestoreStoryService _firestoreService;
  final LocalStoryService _localStoryService;
  final Box _cache;

  StoryRepository({
    FirestoreStoryService? firestoreService,
    LocalStoryService? localStoryService,
    Box? cache,
  })  : _firestoreService = firestoreService ?? FirestoreStoryService(),
        _localStoryService = localStoryService ?? LocalStoryService(),
        _cache = cache ?? Hive.box('story_cache');

  Future<List<Story>> fetchStories() async {
    try {
      final stories = await _firestoreService.fetchStories();

      if (stories.isNotEmpty) {
        await _cacheStories(stories);
        return stories;
      }
    } catch (_) {
      // Firestore is the first choice, but the app still works offline.
    }

    final cachedStories = _readCachedStories();

    if (cachedStories.isNotEmpty) {
      return cachedStories;
    }

    return _localStoryService.fetchStories();
  }

  Future<List<StoryPage>> fetchStoryPages(String storyId) async {
    try {
      final pages = await _firestoreService.fetchStoryPages(storyId);

      if (pages.isNotEmpty) {
        await _cacheStoryPages(storyId, pages);
        return pages;
      }
    } catch (_) {
      // If Firestore cannot load pages, try the saved pages next.
    }

    final cachedPages = _readCachedStoryPages(storyId);

    if (cachedPages.isNotEmpty) {
      return cachedPages;
    }

    return _localStoryService.fetchStoryPages(storyId);
  }

  Future<int> getLastReadPageIndex(String storyId) async {
    final savedPageIndex = _cache.get(_progressKey(storyId), defaultValue: 0);

    if (savedPageIndex is int) {
      return savedPageIndex;
    }

    return 0;
  }

  Future<void> saveLastReadPageIndex(String storyId, int pageIndex) async {
    await _cache.put(_progressKey(storyId), pageIndex);
  }

  Future<void> _cacheStories(List<Story> stories) async {
    final storyMaps = stories.map(_storyToJson).toList();
    await _cache.put('stories', jsonEncode(storyMaps));
  }

  List<Story> _readCachedStories() {
    final cachedStories = _cache.get('stories');

    if (cachedStories == null) {
      return [];
    }

    final decoded = jsonDecode(cachedStories as String) as List;

    return decoded
        .map((item) => Story.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<void> _cacheStoryPages(String storyId, List<StoryPage> pages) async {
    final pageMaps = pages.map(_pageToJson).toList();
    await _cache.put('pages_$storyId', jsonEncode(pageMaps));
  }

  List<StoryPage> _readCachedStoryPages(String storyId) {
    final cachedPages = _cache.get('pages_$storyId');

    if (cachedPages == null) {
      return [];
    }

    final decoded = jsonDecode(cachedPages as String) as List;
    final pages = decoded
        .map((item) => StoryPage.fromMap(Map<String, dynamic>.from(item)))
        .toList();

    pages.sort((a, b) => a.pageNumber.compareTo(b.pageNumber));
    return pages;
  }

  Map<String, dynamic> _storyToJson(Story story) {
    return {
      'id': story.id,
      'titleAm': story.titleAm,
      'titleEn': story.titleEn,
      'coverImage': story.coverImage,
      'summaryAm': story.summaryAm,
      'ageMin': story.ageMin,
      'ageMax': story.ageMax,
    };
  }

  Map<String, dynamic> _pageToJson(StoryPage page) {
    return {
      'pageNumber': page.pageNumber,
      'textAm': page.textAm,
      'textEn': page.textEn,
      'imageUrl': page.imageUrl,
    };
  }

  String _progressKey(String storyId) {
    return 'progress_$storyId';
  }
}
