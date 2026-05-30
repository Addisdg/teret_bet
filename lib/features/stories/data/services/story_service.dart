import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../models/story_model.dart';
import '../models/story_page_model.dart';

class StoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Story>> fetchStories() async {
    try {
      final snapshot = await _db.collection('stories').get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          return Story.fromFirestore(doc.data(), doc.id);
        }).toList();
      }
    } catch (_) {
      // If Firestore fails, fall back to local JSON assets.
    }

    return _fetchStoriesFromAssets();
  }

  Future<List<StoryPage>> fetchStoryPages(String storyId) async {
    try {
      final snapshot = await _db
          .collection('stories')
          .doc(storyId)
          .collection('pages')
          .orderBy('pageNumber')
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          return StoryPage.fromMap(doc.data());
        }).toList();
      }
    } catch (_) {
      // If Firestore fails, fall back to local JSON assets.
    }

    return _fetchStoryPagesFromAssets(storyId);
  }

  Future<List<Story>> _fetchStoriesFromAssets() async {
    final story = await _loadStoryJson('little_rabbit');

    return [Story.fromJson(story)];
  }

  Future<List<StoryPage>> _fetchStoryPagesFromAssets(String storyId) async {
    final story = await _loadStoryJson(storyId);

    final pages = List<Map<String, dynamic>>.from(story['pages'] as List);

    return pages.map(StoryPage.fromMap).toList()
      ..sort((a, b) => a.pageNumber.compareTo(b.pageNumber));
  }

  Future<Map<String, dynamic>> _loadStoryJson(String storyId) async {
    final jsonString = await rootBundle.loadString(
      'assets/stories/$storyId.json',
    );

    return jsonDecode(jsonString) as Map<String, dynamic>;
  }
}
