import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../models/story_model.dart';
import '../models/story_page_model.dart';

class StoryService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Box _cache = Hive.box('story_cache');

  Future<List<Story>> fetchStories() async {
    try {
      final snapshot = await _db.collection('stories').get();

      if (snapshot.docs.isNotEmpty) {
        final storyMaps = snapshot.docs.map((doc) {
          return {'id': doc.id, ...doc.data()};
        }).toList();

        await _cache.put('stories', jsonEncode(storyMaps));

        return storyMaps.map(Story.fromJson).toList();
      }
    } catch (_) {
      // Firestore failed, try cache next.
    }

    final cachedStories = _cache.get('stories');

    if (cachedStories != null) {
      final decoded = jsonDecode(cachedStories as String) as List;

      return decoded
          .map((item) => Story.fromJson(Map<String, dynamic>.from(item)))
          .toList();
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
        final pageMaps = snapshot.docs.map((doc) => doc.data()).toList();

        await _cache.put('pages_$storyId', jsonEncode(pageMaps));

        return pageMaps.map(StoryPage.fromMap).toList();
      }
    } catch (_) {
      // Firestore failed, try cache next.
    }

    final cachedPages = _cache.get('pages_$storyId');

    if (cachedPages != null) {
      final decoded = jsonDecode(cachedPages as String) as List;

      return decoded
          .map((item) => StoryPage.fromMap(Map<String, dynamic>.from(item)))
          .toList()
        ..sort((a, b) => a.pageNumber.compareTo(b.pageNumber));
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
