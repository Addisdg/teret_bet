import 'package:flutter_test/flutter_test.dart';
import 'package:teret_bet_app/features/stories/data/services/local_story_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('local story service discovers every JSON story asset', () async {
    final service = LocalStoryService();

    final stories = await service.fetchStories();
    final storyIds = stories.map((story) => story.id).toSet();

    expect(storyIds, contains('little_rabbit'));
    expect(storyIds, contains('brave_tortoise'));
    expect(stories.length, greaterThanOrEqualTo(2));
  });

  test('local story service loads pages for a story asset', () async {
    final service = LocalStoryService();

    final pages = await service.fetchStoryPages('little_rabbit');

    expect(pages, isNotEmpty);
    expect(pages.first.pageNumber, 1);
    expect(pages.first.textAm, isNotEmpty);
  });
}
