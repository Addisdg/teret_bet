import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../data/models/story_model.dart';
import '../../data/repositories/story_repository.dart';

class StoryProvider with ChangeNotifier {
  static const String _favoriteStoryIdsKey = 'favorite_story_ids';

  final StoryRepository _repository;
  final Box _settingsBox;

  List<Story> _stories = [];
  Set<String> _favoriteStoryIds = {};
  bool _isLoading = false;
  bool _showFavoritesOnly = false;
  String _searchQuery = '';
  String? _selectedCollection;
  String? _errorMessage;

  StoryProvider({
    StoryRepository? repository,
    Box? settingsBox,
  })  : _repository = repository ?? StoryRepository(),
        _settingsBox = settingsBox ?? Hive.box('settings') {
    _favoriteStoryIds = _readFavoriteStoryIds();
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

  bool get showFavoritesOnly => _showFavoritesOnly;
  String get searchQuery => _searchQuery;
  String? get selectedCollection => _selectedCollection;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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

  bool _storyMatchesSearch(Story story, String normalizedQuery) {
    final searchableText = [
      story.titleAm,
      story.titleEn,
      story.summaryAm,
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
