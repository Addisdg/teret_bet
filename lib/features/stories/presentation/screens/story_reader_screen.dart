import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/story_repository.dart';
import '../../data/models/story_model.dart';
import '../../data/models/story_page_model.dart';
import '../providers/settings_provider.dart';

class StoryReaderScreen extends StatefulWidget {
  final Story story;

  const StoryReaderScreen({
    super.key,
    required this.story,
  });

  @override
  State<StoryReaderScreen> createState() => _StoryReaderScreenState();
}

class _StoryReaderScreenState extends State<StoryReaderScreen> {
  final StoryRepository _storyRepository = StoryRepository();

  PageController? _pageController;
  List<StoryPage> _pages = [];
  bool _isLoading = true;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadPages();
  }

  Future<void> _loadPages() async {
    final pages = await _storyRepository.fetchStoryPages(widget.story.id);
    final savedPageIndex = await _storyRepository.getLastReadPageIndex(
      widget.story.id,
    );
    final safePageIndex =
        pages.isEmpty ? 0 : savedPageIndex.clamp(0, pages.length - 1).toInt();

    if (!mounted) {
      return;
    }

    setState(() {
      _pages = pages;
      _currentPageIndex = safePageIndex;
      _pageController = PageController(initialPage: safePageIndex);
      _isLoading = false;
    });
  }

  void _goNext() {
    if (_currentPageIndex < _pages.length - 1) {
      _pageController?.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _goBack() {
    if (_currentPageIndex > 0) {
      _pageController?.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_pages.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.story.titleAm)),
        body: const Center(
          child: Text('No pages found for this story.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E7),
      appBar: AppBar(
        title: Text(widget.story.titleAm),
        centerTitle: true,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentPageIndex + 1) / _pages.length,
            minHeight: 6,
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
                _storyRepository.saveLastReadPageIndex(widget.story.id, index);
              },
              itemBuilder: (context, index) {
                final page = _pages[index];

                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: CachedNetworkImage(
                            imageUrl: page.imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) =>
                                const Icon(Icons.image, size: 80),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        flex: 3,
                        child: SingleChildScrollView(
                          child: Text(
                            page.textAm,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: settings.fontSize,
                              height: 1.7,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _currentPageIndex == 0 ? null : _goBack,
                    child: const Text(
                      'ተመለስ',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        _currentPageIndex == _pages.length - 1 ? null : _goNext,
                    child: const Text(
                      'ቀጣይ',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
