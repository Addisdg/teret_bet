import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/story_model.dart';
import '../localization/app_language.dart';
import '../providers/settings_provider.dart';
import '../providers/story_provider.dart';
import '../screens/story_details_screen.dart';
import 'story_image.dart';

class StoryCard extends StatelessWidget {
  final Story story;

  const StoryCard({
    super.key,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    final storyProvider = context.watch<StoryProvider>();
    final language = context.watch<SettingsProvider>().language;
    final isFavorite = storyProvider.isFavorite(story.id);
    final title = language == AppLanguage.english && story.titleEn.isNotEmpty
        ? story.titleEn
        : story.titleAm;

    return Semantics(
      container: true,
      button: true,
      label: language.choose(
        amharic: '$title፣ ታሪኩን ክፈት',
        english: '$title, open story',
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StoryDetailsScreen(story: story),
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    StoryImage(
                      imagePath: story.coverImage,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surface
                              .withValues(alpha: 0.88),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          tooltip: language.choose(
                            amharic: isFavorite ? 'ከተወዳጅ አስወግድ' : 'ወደ ተወዳጅ ጨምር',
                            english:
                                isFavorite ? 'Remove favorite' : 'Add favorite',
                          ),
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                          ),
                          color: isFavorite
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface,
                          onPressed: () {
                            storyProvider.toggleFavorite(story.id);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ExcludeSemantics(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
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
