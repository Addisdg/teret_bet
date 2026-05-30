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
