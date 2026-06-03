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

  test('local story service loads stories from the story manifest', () async {
    final service = LocalStoryService();

    final stories = await service.fetchStories();
    final storyIds = stories.map((story) => story.id).toSet();

    expect(stories.first.id, 'little_rabbit');
    expect(storyIds, contains('little_rabbit'));
    expect(storyIds, contains('lion_and_mouse'));
    expect(storyIds, contains('goose_golden_eggs'));
    expect(storyIds, isNot(contains('story_manifest')));
    expect(stories.length, 10);
    expect(
      stories.where((story) => story.status == 'draft').length,
      9,
    );

    final localCoverStories = stories.where(
      (story) => story.coverImage.startsWith('assets/'),
    );

    expect(
      localCoverStories.every((story) => File(story.coverImage).existsSync()),
      isTrue,
    );
    expect(
      localCoverStories.every(
        (story) => File(story.coverImage).lengthSync() < 500000,
      ),
      isTrue,
    );
  });

  test('story model reads upgraded metadata without breaking old fields',
      () async {
    final service = LocalStoryService();

    final stories = await service.fetchStories();
    final littleRabbit =
        stories.firstWhere((story) => story.id == 'little_rabbit');

    expect(littleRabbit.collection, 'original');
    expect(littleRabbit.status, 'published');
    expect(littleRabbit.priority, 101);
    expect(littleRabbit.moralAm, contains('ደግነት'));
    expect(littleRabbit.source.type, 'original');
    expect(littleRabbit.themes, contains('friendship'));
    expect(littleRabbit.audio.storyAudioUrl, isNull);
  });

  test('story model keeps old Firestore data backward compatible', () {
    final story = Story.fromFirestore(
      {
        'titleAm': 'የቆየ ታሪክ',
        'titleEn': 'Old Story',
        'summary': 'Old summary field',
        'coverImage': 'https://example.com/cover.png',
      },
      'old_story',
    );
    final page = StoryPage.fromMap({
      'pageNumber': 1,
      'textAm': 'የቆየ ገጽ',
      'imageUrl': 'https://example.com/page.png',
    });

    expect(story.id, 'old_story');
    expect(story.summaryAm, 'Old summary field');
    expect(story.collection, '');
    expect(story.status, 'published');
    expect(story.ageMin, 3);
    expect(story.audio.durationSeconds, isNull);
    expect(page.illustrationPrompt, '');
    expect(page.audioUrl, isNull);
  });

  test('local story service loads pages for a story asset', () async {
    final service = LocalStoryService();

    final pages = await service.fetchStoryPages('little_rabbit');
    final imagePaths = pages.map((page) => page.imageUrl).toSet();

    expect(pages, isNotEmpty);
    expect(pages.first.pageNumber, 1);
    expect(pages.first.textAm, isNotEmpty);
    expect(pages.first.imageUrl,
        'assets/images/stories/little_rabbit_page_01.webp');
    expect(imagePaths.length, pages.length);
    expect(
      imagePaths.every((path) => File(path).existsSync()),
      isTrue,
    );
  });

  test('brave tortoise also uses unique bundled page art', () async {
    final service = LocalStoryService();

    final pages = await service.fetchStoryPages('brave_tortoise');
    final imagePaths = pages.map((page) => page.imageUrl).toSet();

    expect(pages, hasLength(6));
    expect(pages.last.imageUrl,
        'assets/images/stories/brave_tortoise_page_06.webp');
    expect(imagePaths.length, pages.length);
    expect(
      imagePaths.every((path) => File(path).existsSync()),
      isTrue,
    );
  });

  test('little seed story includes a complete bundled page set', () async {
    final service = LocalStoryService();

    final pages = await service.fetchStoryPages('little_seed');
    final imagePaths = pages.map((page) => page.imageUrl).toSet();

    expect(pages, hasLength(6));
    expect(pages.first.textAm, contains('ዘር'));
    expect(
        pages.last.imageUrl, 'assets/images/stories/little_seed_page_06.webp');
    expect(pages.first.illustrationPrompt, isNotEmpty);
    expect(pages.first.audioUrl, isNull);
    expect(imagePaths.length, pages.length);
    expect(
      imagePaths.every((path) => File(path).existsSync()),
      isTrue,
    );
  });

  test('batch 1 placeholder stories include draft metadata and pages',
      () async {
    final service = LocalStoryService();

    final stories = await service.fetchStories();
    final lionAndMouse =
        stories.firstWhere((story) => story.id == 'lion_and_mouse');
    final pages = await service.fetchStoryPages('lion_and_mouse');

    expect(lionAndMouse.collection, 'aesop');
    expect(lionAndMouse.status, 'draft');
    expect(lionAndMouse.source.type, 'public_domain');
    expect(lionAndMouse.audio.storyAudioUrl, isNull);
    expect(pages, hasLength(3));
    expect(pages.first.illustrationPrompt, isNotEmpty);
    expect(pages.first.audioUrl, isNull);
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

  test('repository uses bundled images for stories that exist locally',
      () async {
    final cache = await Hive.openBox('bundled_image_override_test');
    final repository = StoryRepository(
      firestoreService: _StaleImageFirestoreStoryService(),
      localStoryService: _FakeLocalStoryService(),
      cache: cache,
    );

    final stories = await repository.fetchStories();
    final pages = await repository.fetchStoryPages('local_story');

    expect(stories.single.coverImage, 'assets/images/stories/test.webp');
    expect(pages.single.imageUrl, 'assets/images/stories/test_page_01.webp');

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

  test('settings provider changes reader font size in safe steps', () async {
    final box = await Hive.openBox('settings_step_test');
    final settings = SettingsProvider(settingsBox: box);

    await settings.increaseFontSize();

    expect(
      settings.fontSize,
      SettingsProvider.defaultFontSize + SettingsProvider.fontSizeStep,
    );

    await settings.updateFontSize(100);

    expect(settings.fontSize, SettingsProvider.maxFontSize);

    await settings.updateFontSize(1);

    expect(settings.fontSize, SettingsProvider.minFontSize);

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

class _StaleImageFirestoreStoryService extends FirestoreStoryService {
  @override
  Future<List<Story>> fetchStories() async {
    return [
      Story(
        id: 'local_story',
        titleAm: 'የሙከራ ታሪክ',
        titleEn: 'Test Story',
        coverImage: 'https://placehold.co/800x600/png?text=Old+Cover',
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
        imageUrl: 'https://placehold.co/800x600/png?text=Old+Page',
      ),
    ];
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
        coverImage: 'assets/images/stories/test.webp',
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
        imageUrl: 'assets/images/stories/test_page_01.webp',
      ),
    ];
  }
}
