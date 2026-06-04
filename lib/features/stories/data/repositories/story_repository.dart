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
        final combinedStories = await _combineWithBundledStories(stories);
        await _cacheStories(combinedStories);
        return combinedStories;
      }
    } catch (_) {
      // Firestore is the first choice, but the app still works offline.
    }

    final cachedStories = _readCachedStories();

    if (cachedStories.isNotEmpty) {
      return _combineWithBundledStories(cachedStories);
    }

    return _localStoryService.fetchStories();
  }

  Future<List<StoryPage>> fetchStoryPages(String storyId) async {
    try {
      final pages = await _firestoreService.fetchStoryPages(storyId);

      if (pages.isNotEmpty) {
        final pagesWithLocalImages = await _useBundledPageImages(
          storyId,
          pages,
        );
        await _cacheStoryPages(storyId, pagesWithLocalImages);
        return pagesWithLocalImages;
      }
    } catch (_) {
      // If Firestore cannot load pages, try the saved pages next.
    }

    final cachedPages = _readCachedStoryPages(storyId);

    if (cachedPages.isNotEmpty) {
      return _useBundledPageImages(storyId, cachedPages);
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

  Future<List<Story>> _combineWithBundledStories(List<Story> stories) async {
    try {
      final localStories = await _localStoryService.fetchStories();
      final localStoryById = {
        for (final story in localStories) story.id: story,
      };

      final storiesWithLocalImages = stories.map((story) {
        final localStory = localStoryById[story.id];

        if (localStory == null || !_isLocalAsset(localStory.coverImage)) {
          return story;
        }

        return story.copyWith(coverImage: localStory.coverImage);
      }).toList();

      final existingStoryIds =
          storiesWithLocalImages.map((story) => story.id).toSet();
      final missingLocalStories = localStories
          .where((story) => !existingStoryIds.contains(story.id))
          .toList();

      // Firestore and Hive stay first, but bundled MVP stories fill any gaps.
      return [...storiesWithLocalImages, ...missingLocalStories];
    } catch (_) {
      // If local assets cannot be read, keep the Firestore or cache data.
      return stories;
    }
  }

  Future<List<StoryPage>> _useBundledPageImages(
    String storyId,
    List<StoryPage> pages,
  ) async {
    try {
      final localPages = await _localStoryService.fetchStoryPages(storyId);
      final localPageByNumber = {
        for (final page in localPages) page.pageNumber: page,
      };

      return pages.map((page) {
        final localPage = localPageByNumber[page.pageNumber];

        if (localPage == null || !_isLocalAsset(localPage.imageUrl)) {
          return page;
        }

        return page.copyWith(imageUrl: localPage.imageUrl);
      }).toList();
    } catch (_) {
      // Remote-only stories will not have bundled pages, and that is fine.
      return pages;
    }
  }

  Future<void> _cacheStories(List<Story> stories) async {
    final storyMaps = stories.map((story) => story.toJson()).toList();
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
    final pageMaps = pages.map((page) => page.toJson()).toList();
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

  String _progressKey(String storyId) {
    return 'progress_$storyId';
  }

  bool _isLocalAsset(String path) {
    return path.startsWith('assets/');
  }
}
