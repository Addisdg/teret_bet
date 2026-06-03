import 'package:flutter/material.dart';

import '../../data/models/story_model.dart';
import '../widgets/story_image.dart';
import 'story_reader_screen.dart';

class StoryDetailsScreen extends StatelessWidget {
  final Story story;

  const StoryDetailsScreen({
    super.key,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(story.titleAm),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: StoryImage(
                imagePath: story.coverImage,
                height: 260,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              story.titleAm,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              story.summaryAm,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),
            _AudioStatus(audioAvailable: story.audio.storyAudioUrl != null),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StoryReaderScreen(story: story),
                    ),
                  );
                },
                child: const Text(
                  'ጀምር',
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AudioStatus extends StatelessWidget {
  final bool audioAvailable;

  const _AudioStatus({
    required this.audioAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              audioAvailable ? Icons.volume_up : Icons.headphones,
              size: 20,
              color: colorScheme.onSecondaryContainer,
            ),
            const SizedBox(width: 8),
            Text(
              audioAvailable ? 'ድምፅ ዝግጁ ነው' : 'ድምፅ በቅርቡ',
              style: TextStyle(
                color: colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
