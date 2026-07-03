import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../localization/app_language.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  final bool embedded;

  const SettingsScreen({super.key, this.embedded = false});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final language = settings.language;

    final body = ListView(
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
        const Divider(height: 36),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: Icon(
            settings.bedtimeMode ? Icons.bedtime : Icons.light_mode,
          ),
          value: settings.bedtimeMode,
          onChanged: settings.updateBedtimeMode,
          title: Text(language.choose(
            amharic: 'የመኝታ ሰዓት ሁነታ',
            english: 'Bedtime mode',
          )),
          subtitle: Text(language.choose(
            amharic: 'ማታ ለማንበብ የመተግበሪያውን ቀለሞች ያደበዝዛል።',
            english: 'Dims the interface colors for evening reading.',
          )),
        ),
      ],
    );

    if (embedded) {
      return body;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(language.choose(amharic: 'ቅንብሮች', english: 'Settings')),
        centerTitle: true,
      ),
      body: body,
    );
  }
}
