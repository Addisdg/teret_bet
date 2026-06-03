import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/story_model.dart';
import '../../data/models/story_page_model.dart';
import '../../data/repositories/story_repository.dart';
import '../providers/settings_provider.dart';
import '../widgets/story_image.dart';

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
  String? _errorMessage;
  int _currentPageIndex = 0;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _loadPages();
  }

  Future<void> _loadPages() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final pages = await _storyRepository.fetchStoryPages(widget.story.id);
      final savedPageIndex = await _storyRepository.getLastReadPageIndex(
        widget.story.id,
      );
      final safePageIndex =
          pages.isEmpty ? 0 : savedPageIndex.clamp(0, pages.length - 1).toInt();

      if (!mounted) {
        return;
      }

      _pageController?.dispose();

      setState(() {
        _pages = pages;
        _currentPageIndex = safePageIndex;
        _pageController = PageController(initialPage: safePageIndex);
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = 'ታሪኩን መክፈት አልተቻለም። እባክዎ እንደገና ይሞክሩ።';
      });
    }
  }

  void _goNext() {
    if (_currentPageIndex < _pages.length - 1) {
      _goToPage(_currentPageIndex + 1);
    }
  }

  void _goBack() {
    if (_currentPageIndex > 0) {
      _goToPage(_currentPageIndex - 1);
    }
  }

  void _goToPage(int index) {
    if (_pages.isEmpty) {
      return;
    }

    final safeIndex = index.clamp(0, _pages.length - 1).toInt();

    _pageController?.animateToPage(
      safeIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
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

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.story.titleAm)),
        body: _ReaderMessage(
          message: _errorMessage!,
          actionText: 'እንደገና ሞክር',
          onPressed: _loadPages,
        ),
      );
    }

    if (_pages.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.story.titleAm)),
        body: const _ReaderMessage(
          message: 'ለዚህ ታሪክ ገጾች አልተገኙም።',
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

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _toggleControls,
                  child: _ReaderPage(
                    page: page,
                    fontSize: settings.fontSize,
                  ),
                );
              },
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            child: _showControls
                ? _ReaderControls(
                    currentPageIndex: _currentPageIndex,
                    pageCount: _pages.length,
                    fontSize: settings.fontSize,
                    onBack: _goBack,
                    onNext: _goNext,
                    onPageSelected: _goToPage,
                    onDecreaseFontSize: settings.decreaseFontSize,
                    onIncreaseFontSize: settings.increaseFontSize,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _ReaderPage extends StatelessWidget {
  final StoryPage page;
  final double fontSize;

  const _ReaderPage({
    required this.page,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: StoryImage(
                imagePath: page.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
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
                  fontSize: fontSize,
                  height: 1.7,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReaderControls extends StatelessWidget {
  final int currentPageIndex;
  final int pageCount;
  final double fontSize;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final ValueChanged<int> onPageSelected;
  final VoidCallback onDecreaseFontSize;
  final VoidCallback onIncreaseFontSize;

  const _ReaderControls({
    required this.currentPageIndex,
    required this.pageCount,
    required this.fontSize,
    required this.onBack,
    required this.onNext,
    required this.onPageSelected,
    required this.onDecreaseFontSize,
    required this.onIncreaseFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final canGoBack = currentPageIndex > 0;
    final canGoNext = currentPageIndex < pageCount - 1;
    final canDecreaseFontSize = fontSize > SettingsProvider.minFontSize;
    final canIncreaseFontSize = fontSize < SettingsProvider.maxFontSize;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton.filledTonal(
                  tooltip: 'ጽሑፍ አሳንስ',
                  onPressed: canDecreaseFontSize ? onDecreaseFontSize : null,
                  icon: const Icon(Icons.text_decrease),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  tooltip: 'ጽሑፍ አሳድግ',
                  onPressed: canIncreaseFontSize ? onIncreaseFontSize : null,
                  icon: const Icon(Icons.text_increase),
                ),
                const SizedBox(width: 8),
                const IconButton.filledTonal(
                  tooltip: 'ድምፅ በቅርቡ',
                  onPressed: null,
                  icon: Icon(Icons.headphones),
                ),
                const Spacer(),
                Text(
                  'ገጽ ${currentPageIndex + 1} / $pageCount',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Slider(
              min: 0,
              max: (pageCount - 1).toDouble(),
              divisions: pageCount > 1 ? pageCount - 1 : null,
              value: currentPageIndex.toDouble(),
              label: '${currentPageIndex + 1}',
              onChanged: pageCount > 1
                  ? (value) => onPageSelected(value.round())
                  : null,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: canGoBack ? onBack : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text(
                      'ተመለስ',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: canGoNext ? onNext : null,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text(
                      'ቀጣይ',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReaderMessage extends StatelessWidget {
  final String message;
  final String? actionText;
  final VoidCallback? onPressed;

  const _ReaderMessage({
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
