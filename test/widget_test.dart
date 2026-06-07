import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:teret_bet_app/features/stories/data/models/story_model.dart';
import 'package:teret_bet_app/features/stories/data/models/story_page_model.dart';
import 'package:teret_bet_app/features/stories/data/repositories/story_repository.dart';
import 'package:teret_bet_app/features/stories/data/services/firestore_story_service.dart';
import 'package:teret_bet_app/features/stories/data/services/local_story_service.dart';
import 'package:teret_bet_app/features/stories/presentation/providers/settings_provider.dart';
import 'package:teret_bet_app/features/stories/presentation/providers/story_provider.dart';
import 'package:teret_bet_app/features/stories/presentation/screens/story_details_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final tempDir = Directory.systemTemp.createTempSync('teret_bet_tests_');
  late Box widgetCacheBox;
  late Box widgetSettingsBox;

  setUpAll(() async {
    Hive.init(tempDir.path);
    widgetCacheBox = await Hive.openBox('widget_story_cache');
    widgetSettingsBox = await Hive.openBox('widget_settings');
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
    expect(stories.length, 50);
    expect(
      stories.where((story) => story.status == 'draft').length,
      0,
    );
    expect(
      stories.where((story) => story.status == 'ready_for_review').length,
      49,
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

  test('manifest stories use existing non-placeholder image assets', () async {
    final service = LocalStoryService();
    final stories = await service.fetchStories();

    for (final story in stories) {
      expect(story.coverImage, isNot(contains('placehold.co')));

      if (story.coverImage.startsWith('assets/')) {
        expect(File(story.coverImage).existsSync(), isTrue);
      }

      final pages = await service.fetchStoryPages(story.id);
      final pageImageUrls = pages.map((page) => page.imageUrl).toSet();

      expect(pageImageUrls.length, pages.length);
      expect(pageImageUrls, isNot(contains(story.coverImage)));

      for (final page in pages) {
        expect(page.imageUrl, isNot(contains('placehold.co')));

        if (page.imageUrl.startsWith('assets/')) {
          expect(File(page.imageUrl).existsSync(), isTrue);
          expect(File(page.imageUrl).lengthSync() < 500000, isTrue);
        }
      }
    }
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

  test('lion and mouse includes a full adaptation ready for review', () async {
    final service = LocalStoryService();

    final stories = await service.fetchStories();
    final lionAndMouse =
        stories.firstWhere((story) => story.id == 'lion_and_mouse');
    final pages = await service.fetchStoryPages('lion_and_mouse');

    expect(lionAndMouse.collection, 'aesop');
    expect(lionAndMouse.status, 'ready_for_review');
    expect(lionAndMouse.source.type, 'public_domain');
    expect(lionAndMouse.audio.storyAudioUrl, isNull);
    expect(pages, hasLength(8));
    expect(pages.first.textAm, isNot(contains('በቅርቡ')));
    expect(pages.first.illustrationPrompt, isNotEmpty);
    expect(pages.first.audioUrl, isNull);
  });

  test('tortoise and hare includes a full adaptation ready for review',
      () async {
    final service = LocalStoryService();

    final stories = await service.fetchStories();
    final tortoiseAndHare =
        stories.firstWhere((story) => story.id == 'tortoise_and_hare');
    final pages = await service.fetchStoryPages('tortoise_and_hare');

    expect(tortoiseAndHare.collection, 'aesop');
    expect(tortoiseAndHare.status, 'ready_for_review');
    expect(tortoiseAndHare.source.type, 'public_domain');
    expect(tortoiseAndHare.audio.storyAudioUrl, isNull);
    expect(pages, hasLength(8));
    expect(pages.first.textAm, isNot(contains('በቅርቡ')));
    expect(pages.map((page) => page.textAm).join(' '), contains('በቀስታ በቀስታ'));
    expect(pages.first.illustrationPrompt, isNotEmpty);
    expect(pages.first.audioUrl, isNull);
  });

  test('fox and grapes includes a full adaptation ready for review', () async {
    final service = LocalStoryService();

    final stories = await service.fetchStories();
    final foxAndGrapes =
        stories.firstWhere((story) => story.id == 'fox_and_grapes');
    final pages = await service.fetchStoryPages('fox_and_grapes');

    expect(foxAndGrapes.collection, 'aesop');
    expect(foxAndGrapes.status, 'ready_for_review');
    expect(foxAndGrapes.source.type, 'public_domain');
    expect(foxAndGrapes.audio.storyAudioUrl, isNull);
    expect(pages, hasLength(7));
    expect(pages.first.textAm, isNot(contains('በቅርቡ')));
    expect(pages.map((page) => page.textAm).join(' '), contains('እውነተኛ'));
    expect(pages.first.illustrationPrompt, isNotEmpty);
    expect(pages.first.audioUrl, isNull);
  });

  test('ant and grasshopper includes a full adaptation ready for review',
      () async {
    final service = LocalStoryService();

    final stories = await service.fetchStories();
    final antAndGrasshopper =
        stories.firstWhere((story) => story.id == 'ant_and_grasshopper');
    final pages = await service.fetchStoryPages('ant_and_grasshopper');

    expect(antAndGrasshopper.collection, 'aesop');
    expect(antAndGrasshopper.status, 'ready_for_review');
    expect(antAndGrasshopper.source.type, 'public_domain');
    expect(antAndGrasshopper.audio.storyAudioUrl, isNull);
    expect(pages, hasLength(8));
    expect(pages.first.textAm, isNot(contains('በቅርቡ')));
    expect(pages.map((page) => page.textAm).join(' '), contains('መዘጋጀት'));
    expect(pages.first.illustrationPrompt, isNotEmpty);
    expect(pages.first.audioUrl, isNull);
  });

  test('crow and pitcher includes a full adaptation ready for review',
      () async {
    final service = LocalStoryService();

    final stories = await service.fetchStories();
    final crowAndPitcher =
        stories.firstWhere((story) => story.id == 'crow_and_pitcher');
    final pages = await service.fetchStoryPages('crow_and_pitcher');

    expect(crowAndPitcher.collection, 'aesop');
    expect(crowAndPitcher.status, 'ready_for_review');
    expect(crowAndPitcher.source.type, 'public_domain');
    expect(crowAndPitcher.audio.storyAudioUrl, isNull);
    expect(pages, hasLength(8));
    expect(pages.first.textAm, isNot(contains('በቅርቡ')));
    expect(pages.map((page) => page.textAm).join(' '), contains('አንድ ድንጋይ'));
    expect(pages.first.illustrationPrompt, isNotEmpty);
    expect(pages.first.audioUrl, isNull);
  });

  test('boy who cried wolf includes a full adaptation ready for review',
      () async {
    final service = LocalStoryService();

    final stories = await service.fetchStories();
    final boyWhoCriedWolf =
        stories.firstWhere((story) => story.id == 'boy_who_cried_wolf');
    final pages = await service.fetchStoryPages('boy_who_cried_wolf');

    expect(boyWhoCriedWolf.collection, 'aesop');
    expect(boyWhoCriedWolf.status, 'ready_for_review');
    expect(boyWhoCriedWolf.source.type, 'public_domain');
    expect(boyWhoCriedWolf.audio.storyAudioUrl, isNull);
    expect(pages, hasLength(8));
    expect(pages.first.textAm, isNot(contains('በቅርቡ')));
    expect(pages.map((page) => page.textAm).join(' '), contains('መተማመን'));
    expect(pages.first.illustrationPrompt, isNotEmpty);
    expect(pages.first.audioUrl, isNull);
  });

  test('remaining batch 1 stories are full adaptations ready for review',
      () async {
    final service = LocalStoryService();

    final stories = await service.fetchStories();
    final expectedStories = {
      'north_wind_and_sun': (pages: 8, keyword: 'ደግነት'),
      'dog_and_reflection': (pages: 7, keyword: 'ማመስገን'),
      'goose_golden_eggs': (pages: 8, keyword: 'ትዕግሥት'),
    };

    for (final entry in expectedStories.entries) {
      final story = stories.firstWhere((story) => story.id == entry.key);
      final pages = await service.fetchStoryPages(entry.key);
      final storyText = pages.map((page) => page.textAm).join(' ');

      expect(story.collection, 'aesop');
      expect(story.status, 'ready_for_review');
      expect(story.source.type, 'public_domain');
      expect(story.audio.storyAudioUrl, isNull);
      expect(pages, hasLength(entry.value.pages));
      expect(pages.first.textAm, isNot(contains('በቅርቡ')));
      expect(storyText, contains(entry.value.keyword));
      expect(pages.first.illustrationPrompt, isNotEmpty);
      expect(pages.first.audioUrl, isNull);
    }
  });

  test('later batch story assets are complete and visible in manifest', () {
    const storyCollections = {
      'hansel_and_gretel': 'grimm',
      'rapunzel': 'grimm',
      'bremen_town_musicians': 'grimm',
      'snow_white': 'grimm',
      'rumpelstiltskin': 'grimm',
      'golden_goose': 'grimm',
      'fisherman_and_wife': 'grimm',
      'elves_and_shoemaker': 'grimm',
      'little_red_cap': 'grimm',
      'wolf_seven_young_kids': 'grimm',
      'ugly_duckling': 'andersen',
      'emperors_new_clothes': 'andersen',
      'thumbelina': 'andersen',
      'princess_and_pea': 'andersen',
      'snow_queen': 'andersen',
      'little_match_girl': 'andersen',
      'nightingale': 'andersen',
      'fir_tree': 'andersen',
      'swineherd': 'andersen',
      'steadfast_tin_soldier': 'andersen',
      'goldilocks_three_bears': 'world_classics',
      'jack_and_beanstalk': 'world_classics',
      'stone_soup': 'world_folktales',
      'three_billy_goats_gruff': 'world_folktales',
      'chicken_little': 'world_classics',
      'little_red_hen': 'world_classics',
      'gingerbread_man': 'world_classics',
      'town_mouse_country_mouse': 'aesop',
      'selfish_giant': 'world_classics',
      'happy_prince': 'world_classics',
      'anansi_and_turtle': 'african_folktales',
      'anansi_pot_beans': 'african_folktales',
      'sun_moon_sky': 'african_folktales',
      'name_of_tree': 'african_folktales',
      'monkey_and_shark': 'african_folktales',
      'clever_rabbit_lion': 'african_folktales',
      'magic_porridge_pot': 'world_classics',
      'puss_in_boots': 'world_classics',
      'cinderella': 'world_classics',
      'sleeping_beauty': 'world_classics',
    };
    final manifest = jsonDecode(
      File('assets/stories/story_manifest.json').readAsStringSync(),
    ) as List;

    for (final entry in storyCollections.entries) {
      final storyId = entry.key;

      expect(manifest, contains(storyId));

      final storyJson = jsonDecode(
        File('assets/stories/$storyId.json').readAsStringSync(),
      ) as Map<String, dynamic>;
      final story = Story.fromJson(storyJson);
      final pages = (storyJson['pages'] as List)
          .map((item) => StoryPage.fromMap(Map<String, dynamic>.from(item)))
          .toList();

      expect(story.id, storyId);
      expect(story.collection, entry.value);
      expect(story.status, 'ready_for_review');
      expect(story.source.type, 'public_domain');
      expect(story.coverImage, 'assets/images/stories/${storyId}_cover.webp');
      expect(File(story.coverImage).existsSync(), isTrue);
      expect(File(story.coverImage).lengthSync() < 500000, isTrue);
      expect(story.audio.storyAudioUrl, isNull);
      expect(story.moralAm, isNotEmpty);
      expect(story.themes, isNotEmpty);
      expect(pages, hasLength(6));

      for (var index = 0; index < pages.length; index += 1) {
        final page = pages[index];

        expect(page.pageNumber, index + 1);
        expect(page.textAm, isNotEmpty);
        expect(page.textAm, isNot(contains('በቅርቡ')));
        expect(
          page.imageUrl,
          'assets/images/stories/${storyId}_page_${(index + 1).toString().padLeft(2, '0')}.webp',
        );
        expect(File(page.imageUrl).existsSync(), isTrue);
        expect(File(page.imageUrl).lengthSync() < 500000, isTrue);
        expect(page.illustrationPrompt, isNotEmpty);
        expect(page.audioUrl, isNull);
      }
    }
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

  test('repository appends local stories missing from Firestore', () async {
    final cache = await Hive.openBox('partial_firestore_merge_test');
    final repository = StoryRepository(
      firestoreService: _PartialFirestoreStoryService(),
      localStoryService: _TwoStoryLocalStoryService(),
      cache: cache,
    );

    final stories = await repository.fetchStories();

    expect(stories.map((story) => story.id), [
      'remote_story',
      'local_story',
    ]);
    expect(stories.first.coverImage, 'assets/images/stories/remote.webp');

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

  test('story provider saves and restores favorite stories', () async {
    final cache = await Hive.openBox('favorites_story_cache_test');
    final settings = await Hive.openBox('favorites_settings_test');
    final repository = StoryRepository(
      firestoreService: _ThrowingFirestoreStoryService(),
      localStoryService: _TwoStoryLocalStoryService(),
      cache: cache,
    );
    final provider = StoryProvider(
      repository: repository,
      settingsBox: settings,
    );

    await provider.loadStories();
    await provider.toggleFavorite('local_story');

    expect(provider.isFavorite('local_story'), isTrue);
    expect(provider.isFavorite('remote_story'), isFalse);

    final restoredProvider = StoryProvider(
      repository: repository,
      settingsBox: settings,
    );

    expect(restoredProvider.isFavorite('local_story'), isTrue);

    await cache.deleteFromDisk();
    await settings.deleteFromDisk();
  });

  test('story provider filters visible stories to favorites', () async {
    final cache = await Hive.openBox('favorites_filter_cache_test');
    final settings = await Hive.openBox('favorites_filter_settings_test');
    final provider = StoryProvider(
      repository: StoryRepository(
        firestoreService: _ThrowingFirestoreStoryService(),
        localStoryService: _TwoStoryLocalStoryService(),
        cache: cache,
      ),
      settingsBox: settings,
    );

    await provider.loadStories();
    await provider.toggleFavorite('local_story');

    provider.setShowFavoritesOnly(true);

    expect(provider.visibleStories.map((story) => story.id), ['local_story']);

    provider.setShowFavoritesOnly(false);

    expect(provider.visibleStories, hasLength(2));

    await cache.deleteFromDisk();
    await settings.deleteFromDisk();
  });

  test('story provider filters visible stories by search query', () async {
    final cache = await Hive.openBox('search_filter_cache_test');
    final settings = await Hive.openBox('search_filter_settings_test');
    final provider = StoryProvider(
      repository: StoryRepository(
        firestoreService: _ThrowingFirestoreStoryService(),
        localStoryService: _SearchableLocalStoryService(),
        cache: cache,
      ),
      settingsBox: settings,
    );

    await provider.loadStories();

    provider.setSearchQuery('አበባ');

    expect(provider.searchQuery, 'አበባ');
    expect(provider.visibleStories.map((story) => story.id), ['flower_story']);

    provider.setSearchQuery('forest');

    expect(provider.visibleStories.map((story) => story.id), ['forest_story']);

    provider.setSearchQuery('kindness');

    expect(provider.visibleStories.map((story) => story.id), ['flower_story']);

    await cache.deleteFromDisk();
    await settings.deleteFromDisk();
  });

  test('story provider combines favorites and search filters', () async {
    final cache = await Hive.openBox('favorites_search_filter_cache_test');
    final settings =
        await Hive.openBox('favorites_search_filter_settings_test');
    final provider = StoryProvider(
      repository: StoryRepository(
        firestoreService: _ThrowingFirestoreStoryService(),
        localStoryService: _SearchableLocalStoryService(),
        cache: cache,
      ),
      settingsBox: settings,
    );

    await provider.loadStories();
    await provider.toggleFavorite('forest_story');

    provider.setShowFavoritesOnly(true);
    provider.setSearchQuery('አበባ');

    expect(provider.visibleStories, isEmpty);

    provider.setSearchQuery('forest');

    expect(provider.visibleStories.map((story) => story.id), ['forest_story']);

    await cache.deleteFromDisk();
    await settings.deleteFromDisk();
  });

  testWidgets('story details shows audio coming soon when audio is missing',
      (tester) async {
    final repository = StoryRepository(
      firestoreService: _ThrowingFirestoreStoryService(),
      localStoryService: _FakeLocalStoryService(),
      cache: widgetCacheBox,
    );

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => StoryProvider(
          repository: repository,
          settingsBox: widgetSettingsBox,
        ),
        child: MaterialApp(
          home: StoryDetailsScreen(
            story: Story(
              id: 'audio_placeholder_test',
              titleAm: 'የድምፅ ሙከራ',
              titleEn: 'Audio Placeholder Test',
              coverImage: '',
              summaryAm: 'የሙከራ ማጠቃለያ',
              ageMin: 3,
              ageMax: 6,
            ),
          ),
        ),
      ),
    );

    expect(find.text('ድምፅ በቅርቡ'), findsOneWidget);
    expect(find.byIcon(Icons.headphones), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('story details shows parent-facing story metadata',
      (tester) async {
    final repository = StoryRepository(
      firestoreService: _ThrowingFirestoreStoryService(),
      localStoryService: _FakeLocalStoryService(),
      cache: widgetCacheBox,
    );

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => StoryProvider(
          repository: repository,
          settingsBox: widgetSettingsBox,
        ),
        child: MaterialApp(
          home: StoryDetailsScreen(
            story: Story(
              id: 'details_metadata_test',
              collection: 'aesop',
              titleAm: 'የመረጃ ሙከራ',
              titleEn: 'Details Metadata Test',
              coverImage: '',
              summaryAm: 'የሙከራ ማጠቃለያ',
              moralAm: 'ትንሽ ደግነት ትልቅ እርዳታ ይሆናል።',
              ageMin: 4,
              ageMax: 6,
            ),
          ),
        ),
      ),
    );

    expect(find.text('ዕድሜ 4-6'), findsOneWidget);
    expect(find.text('ተረት እና ትምህርት'), findsOneWidget);
    expect(find.text('ትንሽ ደግነት ትልቅ እርዳታ ይሆናል።'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
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

class _PartialFirestoreStoryService extends FirestoreStoryService {
  @override
  Future<List<Story>> fetchStories() async {
    return [
      Story(
        id: 'remote_story',
        titleAm: 'የሩቅ ታሪክ',
        titleEn: 'Remote Story',
        coverImage: 'https://placehold.co/800x600/png?text=Old+Remote',
        summaryAm: 'ከፋየርስቶር የመጣ ታሪክ',
        ageMin: 3,
        ageMax: 6,
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

class _TwoStoryLocalStoryService extends LocalStoryService {
  @override
  Future<List<Story>> fetchStories() async {
    return [
      Story(
        id: 'remote_story',
        titleAm: 'የሩቅ ታሪክ',
        titleEn: 'Remote Story',
        coverImage: 'assets/images/stories/remote.webp',
        summaryAm: 'የአካባቢ ምስል ያለው ታሪክ',
        ageMin: 3,
        ageMax: 6,
      ),
      Story(
        id: 'local_story',
        titleAm: 'የአካባቢ ታሪክ',
        titleEn: 'Local Story',
        coverImage: 'assets/images/stories/local.webp',
        summaryAm: 'በአሴት ውስጥ ያለ ታሪክ',
        ageMin: 3,
        ageMax: 6,
      ),
    ];
  }
}

class _SearchableLocalStoryService extends LocalStoryService {
  @override
  Future<List<Story>> fetchStories() async {
    return [
      Story(
        id: 'flower_story',
        titleAm: 'የአበባዋ ታሪክ',
        titleEn: 'Flower Story',
        coverImage: 'assets/images/stories/flower.webp',
        summaryAm: 'ስለ ደግነት የሚናገር ታሪክ',
        ageMin: 3,
        ageMax: 6,
        themes: const ['kindness'],
      ),
      Story(
        id: 'forest_story',
        titleAm: 'የጫካው ታሪክ',
        titleEn: 'Forest Story',
        coverImage: 'assets/images/stories/forest.webp',
        summaryAm: 'ስለ ጓደኝነት የሚናገር ታሪክ',
        ageMin: 3,
        ageMax: 6,
        themes: const ['friendship'],
      ),
    ];
  }
}
