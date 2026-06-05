import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/story_provider.dart';
import 'settings_screen.dart';
import '../widgets/story_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      context.read<StoryProvider>().loadStories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ተረት ቤት'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _StoryLibraryBody(provider: provider),
    );
  }
}

class _StoryLibraryBody extends StatelessWidget {
  final StoryProvider provider;

  const _StoryLibraryBody({
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    if (provider.errorMessage != null) {
      return _LibraryMessage(
        message: provider.errorMessage!,
        actionText: 'እንደገና ሞክር',
        onPressed: provider.loadStories,
      );
    }

    if (provider.stories.isEmpty) {
      return const _LibraryMessage(
        message: 'እስካሁን ታሪኮች አልተገኙም።',
      );
    }

    final visibleStories = provider.visibleStories;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                value: false,
                icon: Icon(Icons.menu_book),
                label: Text('ሁሉም'),
              ),
              ButtonSegment(
                value: true,
                icon: Icon(Icons.favorite),
                label: Text('የተወደዱ'),
              ),
            ],
            selected: {provider.showFavoritesOnly},
            onSelectionChanged: (selection) {
              provider.setShowFavoritesOnly(selection.first);
            },
          ),
        ),
        Expanded(
          child: visibleStories.isEmpty
              ? const _LibraryMessage(
                  message: 'እስካሁን የተወደዱ ታሪኮች የሉም።',
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: visibleStories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final story = visibleStories[index];
                    return StoryCard(story: story);
                  },
                ),
        ),
      ],
    );
  }
}

class _LibraryMessage extends StatelessWidget {
  final String message;
  final String? actionText;
  final VoidCallback? onPressed;

  const _LibraryMessage({
    required this.message,
    this.actionText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                height: 1.5,
              ),
            ),
            if (actionText != null && onPressed != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onPressed,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
