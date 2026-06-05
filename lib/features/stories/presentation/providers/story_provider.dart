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
    if (!_showFavoritesOnly) {
      return _stories;
    }

    return _stories.where((story) => isFavorite(story.id)).toList();
  }

  bool get showFavoritesOnly => _showFavoritesOnly;
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
}
