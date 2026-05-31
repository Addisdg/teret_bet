import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:teret_bet_app/features/stories/data/models/story_model.dart';
import 'package:teret_bet_app/features/stories/data/models/story_page_model.dart';
import 'package:teret_bet_app/features/stories/data/repositories/story_repository.dart';
import 'package:teret_bet_app/features/stories/data/services/firestore_story_service.dart';
import 'package:teret_bet_app/features/stories/data/services/local_story_service.dart';
import 'package:teret_bet_app/features/stories/presentation/providers/settings_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final tempDir = Directory.systemTemp.createTempSync('teret_bet_tests_');

  setUpAll(() {
    Hive.init(tempDir.path);
  });

  tearDownAll(() async {
    await Hive.close();
    tempDir.deleteSync(recursive: true);
  });

  test('local story service discovers every JSON story asset', () async {
    final service = LocalStoryService();

    final stories = await service.fetchStories();
    final storyIds = stories.map((story) => story.id).toSet();

    expect(storyIds, contains('little_rabbit'));
    expect(storyIds, contains('brave_tortoise'));
    expect(stories.length, greaterThanOrEqualTo(2));
    expect(
      stories.every((story) => story.coverImage.startsWith('assets/')),
      isTrue,
    );
  });

  test('local story service loads pages for a story asset', () async {
    final service = LocalStoryService();

    final pages = await service.fetchStoryPages('little_rabbit');

    expect(pages, isNotEmpty);
    expect(pages.first.pageNumber, 1);
    expect(pages.first.textAm, isNotEmpty);
    expect(pages.first.imageUrl, startsWith('assets/'));
  });

  test('repository falls back to local stories when Firestore and cache fail',
      () async {
    final cache = await Hive.openBox('repository_fallback_test');
    final repository = StoryRepository(
      firestoreService: _ThrowingFirestoreStoryService(),
      localStoryService: _FakeLocalStoryService(),
      cache: cache,
    );

    final stories = await repository.fetchStories();
    final pages = await repository.fetchStoryPages('local_story');

    expect(stories.single.id, 'local_story');
    expect(pages.single.pageNumber, 1);

    await cache.deleteFromDisk();
  });

  test('repository saves and restores reading progress', () async {
    final cache = await Hive.openBox('reading_progress_test');
    final repository = StoryRepository(
      firestoreService: _ThrowingFirestoreStoryService(),
      localStoryService: _FakeLocalStoryService(),
      cache: cache,
    );

    await repository.saveLastReadPageIndex('little_rabbit', 3);

    expect(await repository.getLastReadPageIndex('little_rabbit'), 3);
    expect(await repository.getLastReadPageIndex('unknown_story'), 0);

    await cache.deleteFromDisk();
  });

  test('settings provider saves and resets reader font size', () async {
    final box = await Hive.openBox('settings_provider_test');
    final settings = SettingsProvider(settingsBox: box);

    await settings.updateFontSize(30);

    expect(settings.fontSize, 30);

    await settings.resetFontSize();

    expect(settings.fontSize, SettingsProvider.defaultFontSize);

    await box.deleteFromDisk();
  });
}

class _ThrowingFirestoreStoryService extends FirestoreStoryService {
  @override
  Future<List<Story>> fetchStories() {
    throw Exception('Firestore unavailable in test');
  }

  @override
  Future<List<StoryPage>> fetchStoryPages(String storyId) {
    throw Exception('Firestore unavailable in test');
  }
}

class _FakeLocalStoryService extends LocalStoryService {
  @override
  Future<List<Story>> fetchStories() async {
    return [
      Story(
        id: 'local_story',
        titleAm: 'የሙከራ ታሪክ',
        titleEn: 'Test Story',
        coverImage: 'assets/images/stories/test.png',
        summaryAm: 'የሙከራ ማጠቃለያ',
        ageMin: 3,
        ageMax: 6,
      ),
    ];
  }

  @override
  Future<List<StoryPage>> fetchStoryPages(String storyId) async {
    return [
      StoryPage(
        pageNumber: 1,
        textAm: 'የሙከራ ገጽ',
        imageUrl: 'assets/images/stories/test.png',
      ),
    ];
  }
}
