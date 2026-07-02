import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../localization/app_language.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final language = settings.language;

    return Scaffold(
      appBar: AppBar(
        title: Text(language.choose(amharic: 'ቅንብሮች', english: 'Settings')),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            language.choose(amharic: 'የጽሑፍ መጠን', english: 'Text size'),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            language.choose(
              amharic: 'አባትና እናት ለልጆች ሲያነቡ ጽሑፉን ትልቅ ወይም ትንሽ ማድረግ ይችላሉ።',
              english:
                  'Make the story text larger or smaller for reading together.',
            ),
            style: TextStyle(
              fontSize: settings.fontSize,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Slider(
            min: SettingsProvider.minFontSize,
            max: SettingsProvider.maxFontSize,
            divisions: 7,
            value: settings.fontSize,
            label: settings.fontSize.round().toString(),
            onChanged: settings.updateFontSize,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: settings.resetFontSize,
              child: Text(language.choose(
                amharic: 'ወደ መደበኛ መልስ',
                english: 'Reset text size',
              )),
            ),
          ),
          const Divider(height: 36),
          Text(
            language.choose(amharic: 'ቋንቋ', english: 'Language'),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          SegmentedButton<AppLanguage>(
            segments: const [
              ButtonSegment(value: AppLanguage.amharic, label: Text('አማርኛ')),
              ButtonSegment(value: AppLanguage.english, label: Text('English')),
            ],
            selected: {language},
            onSelectionChanged: (selection) {
              settings.selectLanguage(selection.first);
            },
          ),
        ],
      ),
    );
  }
}
