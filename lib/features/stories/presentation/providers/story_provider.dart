import 'package:flutter/material.dart';

import '../../data/models/story_model.dart';
import '../../data/repositories/story_repository.dart';

class StoryProvider with ChangeNotifier {
  final StoryRepository _repository = StoryRepository();

  List<Story> _stories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Story> get stories => _stories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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
}
