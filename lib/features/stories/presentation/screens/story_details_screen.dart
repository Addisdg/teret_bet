import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/story_model.dart';
import '../providers/story_provider.dart';
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
    final storyProvider = context.watch<StoryProvider>();
    final isFavorite = storyProvider.isFavorite(story.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(story.titleAm),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: isFavorite ? 'Remove favorite' : 'Add favorite',
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            onPressed: () {
              storyProvider.toggleFavorite(story.id);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
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
                      _StoryInfo(story: story),
                      const SizedBox(height: 16),
                      _AudioStatus(
                        audioAvailable: story.audio.storyAudioUrl != null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
      ),
    );
  }
}

class _StoryInfo extends StatelessWidget {
  final Story story;

  const _StoryInfo({
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    final collectionLabel = _collectionLabel(story.collection);
    final hasMoral = story.moralAm.trim().isNotEmpty;

    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            _InfoChip(
              icon: Icons.child_care,
              label: 'ዕድሜ ${story.ageMin}-${story.ageMax}',
            ),
            if (collectionLabel != null)
              _InfoChip(
                icon: Icons.auto_stories,
                label: collectionLabel,
              ),
          ],
        ),
        if (hasMoral) ...[
          const SizedBox(height: 14),
          _MoralBox(moral: story.moralAm),
        ],
      ],
    );
  }

  String? _collectionLabel(String collection) {
    return switch (collection) {
      'original' => 'ኦሪጅናል',
      'aesop' => 'ተረት እና ትምህርት',
      'grimm' => 'የተለመዱ ተረቶች',
      'andersen' => 'የተለመዱ ተረቶች',
      'world_classics' => 'ዓለም ተረቶች',
      'world_folktales' => 'ዓለም ተረቶች',
      'african_folktales' => 'የአፍሪካ ተረቶች',
      _ => null,
    };
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoralBox extends StatelessWidget {
  final String moral;

  const _MoralBox({
    required this.moral,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.favorite,
              size: 20,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                moral,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
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
