import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../localization/app_language.dart';
import '../providers/settings_provider.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsProvider>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_stories,
                      size: 72, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 20),
                  Text(
                    'ተረት ቤት',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'ቋንቋ ይምረጡ\nChoose a language',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, height: 1.5),
                  ),
                  const SizedBox(height: 28),
                  _LanguageButton(
                    label: 'አማርኛ',
                    onPressed: () =>
                        settings.selectLanguage(AppLanguage.amharic),
                  ),
                  const SizedBox(height: 12),
                  _LanguageButton(
                    label: 'English',
                    onPressed: () =>
                        settings.selectLanguage(AppLanguage.english),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _LanguageButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton(
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontSize: 20)),
      ),
    );
  }
}
