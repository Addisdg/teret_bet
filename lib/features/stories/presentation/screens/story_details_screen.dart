import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/story_model.dart';
import '../localization/app_language.dart';
import '../providers/settings_provider.dart';
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
    final language = context.watch<SettingsProvider>().language;
    final isFavorite = storyProvider.isFavorite(story.id);
    final title = language == AppLanguage.english && story.titleEn.isNotEmpty
        ? story.titleEn
        : story.titleAm;
    final summary =
        language == AppLanguage.english && story.summaryEn.isNotEmpty
            ? story.summaryEn
            : story.summaryAm;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: language.choose(
              amharic: isFavorite ? 'ከተወዳጅ አስወግድ' : 'ወደ ተወዳጅ ጨምር',
              english: isFavorite ? 'Remove favorite' : 'Add favorite',
            ),
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
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        summary,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _StoryInfo(story: story, language: language),
                      if (story.source.hasDisplayMetadata) ...[
                        const SizedBox(height: 16),
                        _AboutStory(source: story.source, language: language),
                      ],
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
                  child: Text(
                    language.choose(amharic: 'ጀምር', english: 'Start'),
                    style: const TextStyle(fontSize: 22),
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
  final AppLanguage language;

  const _StoryInfo({
    required this.story,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final collectionLabel = _collectionLabel(story.collection, language);
    final originLabel =
        language == AppLanguage.english && story.source.originLabelEn.isNotEmpty
            ? story.source.originLabelEn
            : story.source.originLabelAm;
    final moral = language == AppLanguage.english && story.moralEn.isNotEmpty
        ? story.moralEn
        : story.moralAm;
    final hasMoral = moral.trim().isNotEmpty;

    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            _InfoChip(
              icon: Icons.child_care,
              label: language.choose(
                amharic: 'ዕድሜ ${story.ageMin}-${story.ageMax}',
                english: 'Ages ${story.ageMin}-${story.ageMax}',
              ),
            ),
            if (collectionLabel != null)
              _InfoChip(
                icon: Icons.auto_stories,
                label: collectionLabel,
              ),
            if (originLabel.isNotEmpty)
              _InfoChip(
                icon: Icons.public,
                label: originLabel,
              ),
          ],
        ),
        if (hasMoral) ...[
          const SizedBox(height: 14),
          _MoralBox(moral: moral),
        ],
      ],
    );
  }

  String? _collectionLabel(String collection, AppLanguage language) {
    if (language == AppLanguage.english) {
      return switch (collection) {
        'original' => 'Original stories',
        'aesop' => 'Fables',
        'grimm' || 'andersen' => 'Classic tales',
        'world_classics' || 'world_folktales' => 'World tales',
        'african_folktales' => 'African tales',
        _ => null,
      };
    }
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

class _AboutStory extends StatelessWidget {
  final StorySource source;
  final AppLanguage language;

  const _AboutStory({required this.source, required this.language});

  @override
  Widget build(BuildContext context) {
    final adaptation =
        language == AppLanguage.english && source.adaptationBasisEn.isNotEmpty
            ? source.adaptationBasisEn
            : source.adaptationBasisAm;
    final culturalContext =
        language == AppLanguage.english && source.culturalContextEn.isNotEmpty
            ? source.culturalContextEn
            : source.culturalContextAm;

    return Card(
      margin: EdgeInsets.zero,
      child: ExpansionTile(
        leading: const Icon(Icons.info_outline),
        title: Text(language.choose(
          amharic: 'ስለዚህ ታሪክ',
          english: 'About this story',
        )),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (source.originCommunity.isNotEmpty)
            _AboutRow(
              label: language.choose(amharic: 'መነሻ', english: 'Origin'),
              value: source.originCommunity,
            ),
          if (adaptation.isNotEmpty)
            _AboutRow(
              label: language.choose(
                amharic: 'የታሪኩ መሠረት',
                english: 'Adaptation basis',
              ),
              value: adaptation,
            ),
          if (culturalContext.isNotEmpty)
            _AboutRow(
              label: language.choose(
                amharic: 'ባህላዊ አውድ',
                english: 'Cultural context',
              ),
              value: culturalContext,
            ),
          if (source.reviewStatus.isNotEmpty)
            _AboutRow(
              label: language.choose(amharic: 'ግምገማ', english: 'Review'),
              value: source.reviewStatus,
            ),
        ],
      ),
    );
  }
}

class _AboutRow extends StatelessWidget {
  final String label;
  final String value;

  const _AboutRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(height: 1.45)),
        ],
      ),
    );
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
