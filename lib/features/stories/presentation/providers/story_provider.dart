import 'package:flutter/material.dart';

import '../../data/models/story_model.dart';
import '../../data/repositories/story_repository.dart';

class StoryProvider with ChangeNotifier {
  final StoryRepository _repository = StoryRepository();

  List<Story> _stories = [];
  bool _isLoading = false;

  List<Story> get stories => _stories;
  bool get isLoading => _isLoading;

  Future<void> loadStories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _stories = await _repository.fetchStories();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
