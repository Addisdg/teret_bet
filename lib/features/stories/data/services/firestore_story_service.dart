import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/story_model.dart';
import '../models/story_page_model.dart';

class FirestoreStoryService {
  final FirebaseFirestore _db;

  FirestoreStoryService({
    FirebaseFirestore? db,
  }) : _db = db ?? FirebaseFirestore.instance;

  Future<List<Story>> fetchStories() async {
    final snapshot = await _db.collection('stories').get();

    return snapshot.docs.map((doc) {
      return Story.fromFirestore(doc.data(), doc.id);
    }).toList();
  }

  Future<List<StoryPage>> fetchStoryPages(String storyId) async {
    final snapshot = await _db
        .collection('stories')
        .doc(storyId)
        .collection('pages')
        .orderBy('pageNumber')
        .get();

    return snapshot.docs.map((doc) {
      return StoryPage.fromMap(doc.data());
    }).toList();
  }
}
