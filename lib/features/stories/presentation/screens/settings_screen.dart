import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ቅንብሮች'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'የጽሑፍ መጠን',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'አባትና እናት ለልጆች ሲያነቡ ጽሑፉን ትልቅ ወይም ትንሽ ማድረግ ይችላሉ።',
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
          const Divider(height: 36),
          SwitchListTile(
            value: false,
            onChanged: null,
            title: const Text('ቋንቋ'),
            subtitle:
                const Text('Amharic only for MVP. Language toggle later.'),
          ),
        ],
      ),
    );
  }
}
