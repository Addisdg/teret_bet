import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../data/models/reading_history_entry.dart';
import '../../data/models/story_model.dart';
import '../../data/repositories/story_repository.dart';

class StoryProvider with ChangeNotifier {
  static const String _favoriteStoryIdsKey = 'favorite_story_ids';
  static const String _readingHistoryKey = 'reading_history';
  static const int readingHistoryLimit = 20;

  final StoryRepository _repository;
  final Box _settingsBox;

  List<Story> _stories = [];
  Set<String> _favoriteStoryIds = {};
  bool _isLoading = false;
  bool _showFavoritesOnly = false;
  String _searchQuery = '';
  String? _selectedCollection;
  Set<String> _selectedAgeBands = {};
  Set<String> _selectedThemes = {};
  String? _errorMessage;
  List<ReadingHistoryEntry> _readingHistory = [];

  StoryProvider({
    StoryRepository? repository,
    Box? settingsBox,
  })  : _repository = repository ?? StoryRepository(),
        _settingsBox = settingsBox ?? Hive.box('settings') {
    _favoriteStoryIds = _readFavoriteStoryIds();
    _readingHistory = _readReadingHistory();
  }

  List<Story> get stories => _stories;
  List<Story> get visibleStories {
    Iterable<Story> filteredStories = _stories;

    if (_showFavoritesOnly) {
      filteredStories = filteredStories.where((story) => isFavorite(story.id));
    }

    if (_selectedCollection != null) {
      filteredStories = filteredStories.where(
        (story) => story.collection == _selectedCollection,
      );
    }

    if (_selectedAgeBands.isNotEmpty) {
      filteredStories = filteredStories.where(_matchesSelectedAgeBand);
    }

    if (_selectedThemes.isNotEmpty) {
      filteredStories = filteredStories.where(
        (story) => story.themes.any(_selectedThemes.contains),
      );
    }

    final normalizedQuery = _searchQuery.trim().toLowerCase();
    if (normalizedQuery.isNotEmpty) {
      filteredStories = filteredStories.where(
        (story) => _storyMatchesSearch(story, normalizedQuery),
      );
    }

    return filteredStories.toList();
  }

  List<String> get availableCollections {
    final collections = _stories
        .map((story) => story.collection)
        .where((collection) => collection.isNotEmpty)
        .toSet()
        .toList();

    collections.sort((left, right) {
      final leftIndex = _collectionSortOrder.indexOf(left);
      final rightIndex = _collectionSortOrder.indexOf(right);

      if (leftIndex != -1 || rightIndex != -1) {
        return _sortIndex(leftIndex).compareTo(_sortIndex(rightIndex));
      }

      return left.compareTo(right);
    });

    return collections;
  }

  List<String> get availableThemes {
    final themes = _stories.expand((story) => story.themes).toSet().toList();
    themes.sort();
    return themes;
  }

  bool get showFavoritesOnly => _showFavoritesOnly;
  String get searchQuery => _searchQuery;
  String? get selectedCollection => _selectedCollection;
  Set<String> get selectedAgeBands => Set.unmodifiable(_selectedAgeBands);
  Set<String> get selectedThemes => Set.unmodifiable(_selectedThemes);
  int get discoveryFilterCount =>
      _selectedAgeBands.length + _selectedThemes.length;
  bool get hasActiveFilters =>
      _showFavoritesOnly ||
      _searchQuery.trim().isNotEmpty ||
      _selectedCollection != null ||
      discoveryFilterCount > 0;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<ReadingHistoryEntry> get readingHistory =>
      List.unmodifiable(_readingHistory);
  List<Story> get recentlyReadStories => _storiesForHistory(_readingHistory);
  List<Story> get continueReadingStories => _storiesForHistory(
        _readingHistory.where((entry) => !entry.isCompleted),
      );

  bool isFavorite(String storyId) {
    return _favoriteStoryIds.contains(storyId);
  }

  Future<void> loadStories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _stories = await _repository.fetchStories();
    } catch (_) {
      _stories = [];
      _errorMessage = 'ታሪኮችን መጫን አልተቻለም። እባክዎ እንደገና ይሞክሩ።';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String storyId) async {
    if (_favoriteStoryIds.contains(storyId)) {
      _favoriteStoryIds.remove(storyId);
    } else {
      _favoriteStoryIds.add(storyId);
    }

    await _settingsBox.put(
      _favoriteStoryIdsKey,
      _favoriteStoryIds.toList()..sort(),
    );
    notifyListeners();
  }

  Future<void> recordReadingProgress({
    required String storyId,
    required int pageIndex,
    required int pageCount,
  }) async {
    if (storyId.isEmpty || pageCount <= 0) {
      return;
    }

    final safePageIndex = pageIndex.clamp(0, pageCount - 1).toInt();
    _readingHistory.removeWhere((entry) => entry.storyId == storyId);
    _readingHistory.insert(
      0,
      ReadingHistoryEntry(
        storyId: storyId,
        lastPageIndex: safePageIndex,
        pageCount: pageCount,
        lastReadAt: DateTime.now().toUtc(),
        isCompleted: safePageIndex == pageCount - 1,
      ),
    );

    if (_readingHistory.length > readingHistoryLimit) {
      _readingHistory = _readingHistory.take(readingHistoryLimit).toList();
    }

    await _saveReadingHistory();
    notifyListeners();
  }

  Future<void> clearReadingHistory() async {
    if (_readingHistory.isEmpty) {
      return;
    }

    _readingHistory = [];
    await _settingsBox.delete(_readingHistoryKey);
    notifyListeners();
  }

  void setShowFavoritesOnly(bool value) {
    if (_showFavoritesOnly == value) {
      return;
    }

    _showFavoritesOnly = value;
    notifyListeners();
  }

  void setSearchQuery(String value) {
    if (_searchQuery == value) {
      return;
    }

    _searchQuery = value;
    notifyListeners();
  }

  void setSelectedCollection(String? value) {
    if (_selectedCollection == value) {
      return;
    }

    _selectedCollection = value;
    notifyListeners();
  }

  void toggleAgeBand(String ageBand) {
    if (_selectedAgeBands.contains(ageBand)) {
      _selectedAgeBands.remove(ageBand);
    } else {
      _selectedAgeBands.add(ageBand);
    }
    notifyListeners();
  }

  void toggleTheme(String theme) {
    if (_selectedThemes.contains(theme)) {
      _selectedThemes.remove(theme);
    } else {
      _selectedThemes.add(theme);
    }
    notifyListeners();
  }

  void clearDiscoveryFilters() {
    if (discoveryFilterCount == 0) {
      return;
    }
    _selectedAgeBands = {};
    _selectedThemes = {};
    notifyListeners();
  }

  void clearFilters() {
    if (!hasActiveFilters) {
      return;
    }

    _showFavoritesOnly = false;
    _searchQuery = '';
    _selectedCollection = null;
    _selectedAgeBands = {};
    _selectedThemes = {};
    notifyListeners();
  }

  bool _matchesSelectedAgeBand(Story story) {
    return _selectedAgeBands.any((ageBand) {
      final (minAge, maxAge) = switch (ageBand) {
        '3-4' => (3, 4),
        '5-6' => (5, 6),
        _ => (0, 0),
      };
      return story.ageMin <= maxAge && story.ageMax >= minAge;
    });
  }

  bool _storyMatchesSearch(Story story, String normalizedQuery) {
    final searchableText = [
      story.titleAm,
      story.titleEn,
      story.summaryAm,
      story.summaryEn,
      story.collection,
      ...story.themes,
    ].join(' ').toLowerCase();

    return searchableText.contains(normalizedQuery);
  }

  Set<String> _readFavoriteStoryIds() {
    final savedStoryIds = _settingsBox.get(
      _favoriteStoryIdsKey,
      defaultValue: const <String>[],
    );

    if (savedStoryIds is List) {
      return savedStoryIds
          .whereType<String>()
          .where((storyId) => storyId.isNotEmpty)
          .toSet();
    }

    return {};
  }

  List<ReadingHistoryEntry> _readReadingHistory() {
    final savedHistory = _settingsBox.get(
      _readingHistoryKey,
      defaultValue: const <dynamic>[],
    );

    if (savedHistory is! List) {
      return [];
    }

    final entries = savedHistory
        .whereType<Map>()
        .map((item) => ReadingHistoryEntry.fromMap(
              Map<String, dynamic>.from(item),
            ))
        .where((entry) => entry.storyId.isNotEmpty)
        .toList();
    entries.sort((left, right) => right.lastReadAt.compareTo(left.lastReadAt));
    return entries.take(readingHistoryLimit).toList();
  }

  Future<void> _saveReadingHistory() {
    return _settingsBox.put(
      _readingHistoryKey,
      _readingHistory.map((entry) => entry.toMap()).toList(),
    );
  }

  List<Story> _storiesForHistory(Iterable<ReadingHistoryEntry> entries) {
    final storiesById = {for (final story in _stories) story.id: story};
    return entries
        .map((entry) => storiesById[entry.storyId])
        .whereType<Story>()
        .toList();
  }

  static const _collectionSortOrder = [
    'original',
    'aesop',
    'grimm',
    'andersen',
    'world_classics',
    'world_folktales',
    'african_folktales',
  ];

  int _sortIndex(int index) {
    return index == -1 ? _collectionSortOrder.length : index;
  }
}
