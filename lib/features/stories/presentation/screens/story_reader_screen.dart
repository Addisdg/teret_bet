import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/story_model.dart';
import '../../data/models/story_page_model.dart';
import '../../data/repositories/story_repository.dart';
import '../localization/app_language.dart';
import '../providers/settings_provider.dart';
import '../widgets/story_image.dart';

class StoryReaderScreen extends StatefulWidget {
  final Story story;
  final StoryRepository? repository;
  final FutureOr<void> Function(int pageIndex, int pageCount)? onProgress;

  const StoryReaderScreen({
    super.key,
    required this.story,
    this.repository,
    this.onProgress,
  });

  @override
  State<StoryReaderScreen> createState() => _StoryReaderScreenState();
}

class _StoryReaderScreenState extends State<StoryReaderScreen> {
  late final StoryRepository _storyRepository;

  PageController? _pageController;
  List<StoryPage> _pages = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _currentPageIndex = 0;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _storyRepository = widget.repository ?? StoryRepository();
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
      await widget.onProgress?.call(safePageIndex, pages.length);
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
    final language = settings.language;
    final title =
        language == AppLanguage.english && widget.story.titleEn.isNotEmpty
            ? widget.story.titleEn
            : widget.story.titleAm;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: _ReaderMessage(
          message: language.choose(
            amharic: 'ታሪኩን መክፈት አልተቻለም። እባክዎ እንደገና ይሞክሩ።',
            english: 'The story could not be opened. Please try again.',
          ),
          actionText:
              language.choose(amharic: 'እንደገና ሞክር', english: 'Try again'),
          onPressed: _loadPages,
        ),
      );
    }

    if (_pages.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: _ReaderMessage(
          message: language.choose(
            amharic: 'ለዚህ ታሪክ ገጾች አልተገኙም።',
            english: 'No pages were found for this story.',
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
          TextButton(
            key: const Key('reader_language_switch'),
            style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
            onPressed: () {
              final next = language == AppLanguage.amharic
                  ? AppLanguage.english
                  : AppLanguage.amharic;
              settings.selectLanguage(next);
            },
            child: Semantics(
              label: language.choose(
                amharic: 'ወደ እንግሊዝኛ ቀይር',
                english: 'Switch to Amharic',
              ),
              button: true,
              excludeSemantics: true,
              child: Text(language == AppLanguage.amharic ? 'EN' : 'አማ'),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final compactControls = constraints.maxHeight < 560;

          return Column(
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
                    _storyRepository.saveLastReadPageIndex(
                        widget.story.id, index);
                    widget.onProgress?.call(index, _pages.length);
                  },
                  itemBuilder: (context, index) {
                    final page = _pages[index];

                    return Semantics(
                      container: true,
                      label: language.choose(
                        amharic: _showControls
                            ? 'የንባብ መቆጣጠሪያዎችን ደብቅ'
                            : 'የንባብ መቆጣጠሪያዎችን አሳይ',
                        english: _showControls
                            ? 'Hide reading controls'
                            : 'Show reading controls',
                      ),
                      onTap: _toggleControls,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _toggleControls,
                        child: _ReaderPage(
                          page: page,
                          fontSize: settings.fontSize,
                          language: language,
                        ),
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
                        language: language,
                        compact: compactControls,
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReaderPage extends StatelessWidget {
  final StoryPage page;
  final double fontSize;
  final AppLanguage language;

  const _ReaderPage({
    required this.page,
    required this.fontSize,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final text = language == AppLanguage.english &&
            (page.textEn?.trim().isNotEmpty ?? false)
        ? page.textEn!
        : page.textAm;

    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontal = constraints.maxWidth > constraints.maxHeight;
        final image = Semantics(
          image: true,
          label: language.choose(
            amharic: 'የታሪኩ ምስል፣ ገጽ ${page.pageNumber}',
            english: 'Story illustration, page ${page.pageNumber}',
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: StoryImage(
              imagePath: page.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        );
        final storyText = SingleChildScrollView(
          padding: const EdgeInsets.all(4),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize,
              height: 1.7,
              fontWeight: FontWeight.w500,
            ),
          ),
        );

        return Padding(
          padding: EdgeInsets.all(horizontal ? 12 : 20),
          child: horizontal
              ? Row(
                  children: [
                    Expanded(flex: 6, child: image),
                    const SizedBox(width: 16),
                    Expanded(flex: 5, child: storyText),
                  ],
                )
              : Column(
                  children: [
                    Expanded(flex: 5, child: image),
                    const SizedBox(height: 20),
                    Expanded(flex: 3, child: storyText),
                  ],
                ),
        );
      },
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
  final AppLanguage language;
  final bool compact;

  const _ReaderControls({
    required this.currentPageIndex,
    required this.pageCount,
    required this.fontSize,
    required this.onBack,
    required this.onNext,
    required this.onPageSelected,
    required this.onDecreaseFontSize,
    required this.onIncreaseFontSize,
    required this.language,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final canGoBack = currentPageIndex > 0;
    final canGoNext = currentPageIndex < pageCount - 1;
    final canDecreaseFontSize = fontSize > SettingsProvider.minFontSize;
    final canIncreaseFontSize = fontSize < SettingsProvider.maxFontSize;

    if (compact) {
      return _CompactReaderControls(
        currentPageIndex: currentPageIndex,
        pageCount: pageCount,
        canGoBack: canGoBack,
        canGoNext: canGoNext,
        canDecreaseFontSize: canDecreaseFontSize,
        canIncreaseFontSize: canIncreaseFontSize,
        onBack: onBack,
        onNext: onNext,
        onDecreaseFontSize: onDecreaseFontSize,
        onIncreaseFontSize: onIncreaseFontSize,
        language: language,
      );
    }

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
                  tooltip: language.choose(
                    amharic: 'ጽሑፍ አሳንስ',
                    english: 'Decrease text size',
                  ),
                  onPressed: canDecreaseFontSize ? onDecreaseFontSize : null,
                  icon: const Icon(Icons.text_decrease),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  tooltip: language.choose(
                    amharic: 'ጽሑፍ አሳድግ',
                    english: 'Increase text size',
                  ),
                  onPressed: canIncreaseFontSize ? onIncreaseFontSize : null,
                  icon: const Icon(Icons.text_increase),
                ),
                const Spacer(),
                Text(
                  language.choose(
                    amharic: 'ገጽ ${currentPageIndex + 1} / $pageCount',
                    english: 'Page ${currentPageIndex + 1} / $pageCount',
                  ),
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
                    label: Text(
                      language.choose(amharic: 'ተመለስ', english: 'Back'),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: canGoNext ? onNext : null,
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(
                      language.choose(amharic: 'ቀጣይ', english: 'Next'),
                      style: const TextStyle(fontSize: 20),
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

class _CompactReaderControls extends StatelessWidget {
  final int currentPageIndex;
  final int pageCount;
  final bool canGoBack;
  final bool canGoNext;
  final bool canDecreaseFontSize;
  final bool canIncreaseFontSize;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onDecreaseFontSize;
  final VoidCallback onIncreaseFontSize;
  final AppLanguage language;

  const _CompactReaderControls({
    required this.currentPageIndex,
    required this.pageCount,
    required this.canGoBack,
    required this.canGoNext,
    required this.canDecreaseFontSize,
    required this.canIncreaseFontSize,
    required this.onBack,
    required this.onNext,
    required this.onDecreaseFontSize,
    required this.onIncreaseFontSize,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
        child: Row(
          children: [
            IconButton.filledTonal(
              tooltip: language.choose(
                amharic: 'ጽሑፍ አሳንስ',
                english: 'Decrease text size',
              ),
              onPressed: canDecreaseFontSize ? onDecreaseFontSize : null,
              icon: const Icon(Icons.text_decrease),
            ),
            IconButton.filledTonal(
              tooltip: language.choose(
                amharic: 'ጽሑፍ አሳድግ',
                english: 'Increase text size',
              ),
              onPressed: canIncreaseFontSize ? onIncreaseFontSize : null,
              icon: const Icon(Icons.text_increase),
            ),
            const Spacer(),
            IconButton.filled(
              tooltip:
                  language.choose(amharic: 'ተመለስ', english: 'Previous page'),
              onPressed: canGoBack ? onBack : null,
              icon: const Icon(Icons.arrow_back),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '${currentPageIndex + 1} / $pageCount',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            IconButton.filled(
              tooltip: language.choose(amharic: 'ቀጣይ', english: 'Next page'),
              onPressed: canGoNext ? onNext : null,
              icon: const Icon(Icons.arrow_forward),
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
