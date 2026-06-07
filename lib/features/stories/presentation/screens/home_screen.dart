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

class _StoryLibraryBody extends StatefulWidget {
  final StoryProvider provider;

  const _StoryLibraryBody({
    required this.provider,
  });

  @override
  State<_StoryLibraryBody> createState() => _StoryLibraryBodyState();
}

class _StoryLibraryBodyState extends State<_StoryLibraryBody> {
  late final TextEditingController _searchController;

  StoryProvider get provider => widget.provider;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: provider.searchQuery);
  }

  @override
  void didUpdateWidget(_StoryLibraryBody oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_searchController.text != provider.searchQuery) {
      _searchController.text = provider.searchQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
    final hasSearch = provider.searchQuery.trim().isNotEmpty;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onChanged: provider.setSearchQuery,
                decoration: InputDecoration(
                  hintText: 'ታሪክ ፈልግ',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: hasSearch
                      ? IconButton(
                          tooltip: 'ፍለጋን አጥፋ',
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _searchController.clear();
                            provider.setSearchQuery('');
                          },
                        )
                      : null,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              SegmentedButton<bool>(
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
              if (provider.availableCollections.isNotEmpty) ...[
                const SizedBox(height: 10),
                _CollectionFilter(provider: provider),
              ],
              const SizedBox(height: 8),
              _LibraryStatusBar(
                visibleCount: visibleStories.length,
                totalCount: provider.stories.length,
                hasActiveFilters: provider.hasActiveFilters,
                onClearFilters: () {
                  _searchController.clear();
                  provider.clearFilters();
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: visibleStories.isEmpty
              ? _LibraryMessage(
                  message: _emptyMessage(provider),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount =
                        (constraints.maxWidth / 190).floor().clamp(2, 5);

                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: visibleStories.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        final story = visibleStories[index];
                        return StoryCard(story: story);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  String _emptyMessage(StoryProvider provider) {
    final hasSearch = provider.searchQuery.trim().isNotEmpty;
    final hasCollection = provider.selectedCollection != null;

    if (hasSearch && provider.showFavoritesOnly && hasCollection) {
      return 'በዚህ ምድብ እና በተወደዱ ታሪኮች ውስጥ ይህን ፍለጋ የሚመስል ታሪክ አልተገኘም።';
    }

    if (hasSearch && provider.showFavoritesOnly) {
      return 'በተወደዱ ታሪኮች ውስጥ ይህን ፍለጋ የሚመስል ታሪክ አልተገኘም።';
    }

    if (hasSearch && hasCollection) {
      return 'በዚህ ምድብ ውስጥ ይህን ፍለጋ የሚመስል ታሪክ አልተገኘም።';
    }

    if (hasSearch) {
      return 'ይህን ፍለጋ የሚመስል ታሪክ አልተገኘም።';
    }

    if (hasCollection && provider.showFavoritesOnly) {
      return 'በዚህ ምድብ ውስጥ የተወደደ ታሪክ አልተገኘም።';
    }

    if (hasCollection) {
      return 'በዚህ ምድብ ውስጥ ታሪክ አልተገኘም።';
    }

    return 'እስካሁን የተወደዱ ታሪኮች የሉም።';
  }
}

class _LibraryStatusBar extends StatelessWidget {
  final int visibleCount;
  final int totalCount;
  final bool hasActiveFilters;
  final VoidCallback onClearFilters;

  const _LibraryStatusBar({
    required this.visibleCount,
    required this.totalCount,
    required this.hasActiveFilters,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final countText = hasActiveFilters
        ? '$visibleCount / $totalCount ታሪኮች'
        : '$totalCount ታሪኮች';

    return Row(
      children: [
        Text(
          countText,
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        if (hasActiveFilters)
          TextButton.icon(
            onPressed: onClearFilters,
            icon: const Icon(Icons.clear_all),
            label: const Text('ማጣሪያ አጥፋ'),
          ),
      ],
    );
  }
}

class _CollectionFilter extends StatelessWidget {
  final StoryProvider provider;

  const _CollectionFilter({
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final selectedCollection = provider.selectedCollection;

    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: const Text('ሁሉም ምድቦች'),
              selected: selectedCollection == null,
              onSelected: (_) {
                provider.setSelectedCollection(null);
              },
            ),
          ),
          for (final collection in provider.availableCollections)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(_collectionLabel(collection)),
                selected: selectedCollection == collection,
                onSelected: (_) {
                  provider.setSelectedCollection(collection);
                },
              ),
            ),
        ],
      ),
    );
  }

  String _collectionLabel(String collection) {
    return switch (collection) {
      'original' => 'ኦሪጅናል',
      'aesop' => 'ኤሶፕ',
      'grimm' => 'ግሪም',
      'andersen' => 'አንደርሰን',
      'world_classics' => 'ዓለም ክላሲክ',
      'world_folktales' => 'ዓለም ተረቶች',
      'african_folktales' => 'አፍሪካ',
      _ => collection,
    };
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
