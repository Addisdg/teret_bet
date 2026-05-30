import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../data/models/story_model.dart';
import '../screens/story_details_screen.dart';

class StoryCard extends StatelessWidget {
  final Story story;

  const StoryCard({
    super.key,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
              child: CachedNetworkImage(
                imageUrl: story.coverImage,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (_, __, ___) => const Icon(Icons.image, size: 48),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                story.titleAm,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
