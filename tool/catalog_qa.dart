import 'dart:convert';
import 'dart:io';

const _manifestPath = 'assets/stories/story_manifest.json';
const _riskTerms = [
  'ገደለ',
  'ሞተ',
  'ደም ',
  'ቢላ',
  'መቃብር',
  'ጨካኝ',
  'ጭካኔ',
  'አስፈሪ',
];

void main() {
  final report = CatalogQaReport();
  final manifestFile = File(_manifestPath);

  if (!manifestFile.existsSync()) {
    report.addError('Missing manifest: $_manifestPath');
    report.printSummary();
    exitCode = 1;
    return;
  }

  final manifest = _readStringList(manifestFile);
  final seenIds = <String>{};

  if (manifest.length != 50) {
    report.addWarning('Manifest has ${manifest.length} stories, expected 50.');
  }

  for (final storyId in manifest) {
    if (!seenIds.add(storyId)) {
      report.addError('Duplicate story ID in manifest: $storyId');
      continue;
    }

    _reviewStory(storyId, report);
  }

  report.printSummary();
  if (report.errors.isNotEmpty) {
    exitCode = 1;
  }
}

void _reviewStory(String storyId, CatalogQaReport report) {
  final storyFile = File('assets/stories/$storyId.json');
  if (!storyFile.existsSync()) {
    report.addError('$storyId: missing story JSON file.');
    return;
  }

  final story = jsonDecode(storyFile.readAsStringSync());
  if (story is! Map<String, dynamic>) {
    report.addError('$storyId: story JSON must be an object.');
    return;
  }

  _expectNonEmptyString(storyId, story, 'titleAm', report);
  _expectNonEmptyString(storyId, story, 'titleEn', report);
  _expectNonEmptyString(storyId, story, 'summaryAm', report);
  _expectNonEmptyString(storyId, story, 'moralAm', report);
  _expectNonEmptyString(storyId, story, 'collection', report);
  _expectNonEmptyString(storyId, story, 'status', report);

  if (story['status'] == 'draft') {
    report.addError('$storyId: manifest stories should not use draft status.');
  }

  final themes = story['themes'];
  if (themes is! List || themes.whereType<String>().isEmpty) {
    report.addWarning('$storyId: themes should include at least one value.');
  }

  final coverImage = story['coverImage'];
  if (coverImage is String && coverImage.startsWith('assets/')) {
    _expectExistingAsset(storyId, coverImage, report);
  } else {
    report.addWarning('$storyId: coverImage should be a bundled asset path.');
  }

  final pages = story['pages'];
  if (pages is! List) {
    report.addError('$storyId: pages must be a list.');
    return;
  }

  if (pages.length < 6 || pages.length > 10) {
    report.addWarning(
      '$storyId: has ${pages.length} pages; guidelines prefer 6-10.',
    );
  }

  for (var index = 0; index < pages.length; index += 1) {
    final pageNumber = index + 1;
    final page = pages[index];
    if (page is! Map<String, dynamic>) {
      report.addError('$storyId page $pageNumber: page must be an object.');
      continue;
    }

    if (page['pageNumber'] != pageNumber) {
      report.addError(
        '$storyId page $pageNumber: pageNumber should be $pageNumber.',
      );
    }

    final textAm = page['textAm'];
    if (textAm is! String || textAm.trim().isEmpty) {
      report.addError('$storyId page $pageNumber: textAm is required.');
    } else {
      _reviewPageText(storyId, pageNumber, textAm, report);
    }

    _expectNonEmptyString(
      storyId,
      page,
      'illustrationPrompt',
      report,
      location: 'page $pageNumber',
    );

    final imageUrl = page['imageUrl'];
    if (imageUrl is String && imageUrl.startsWith('assets/')) {
      _expectExistingAsset(storyId, imageUrl, report);
    } else {
      report.addWarning(
        '$storyId page $pageNumber: imageUrl should be a bundled asset path.',
      );
    }
  }
}

void _reviewPageText(
  String storyId,
  int pageNumber,
  String textAm,
  CatalogQaReport report,
) {
  final sentenceCount = '።'.allMatches(textAm).length;
  if (sentenceCount == 0 || sentenceCount > 3) {
    report.addWarning(
      '$storyId page $pageNumber: has $sentenceCount sentence markers; '
      'guidelines prefer 1-3 short sentences.',
    );
  }

  if (textAm.length > 220) {
    report.addWarning(
      '$storyId page $pageNumber: text is ${textAm.length} characters; '
      'check read-aloud length.',
    );
  }

  for (final term in _riskTerms) {
    if (textAm.contains(term)) {
      report.addWarning(
        '$storyId page $pageNumber: review age-suitability term "$term".',
      );
    }
  }
}

void _expectNonEmptyString(
  String storyId,
  Map<String, dynamic> data,
  String field,
  CatalogQaReport report, {
  String? location,
}) {
  final value = data[field];
  if (value is String && value.trim().isNotEmpty) {
    return;
  }

  final prefix = location == null ? storyId : '$storyId $location';
  report.addWarning('$prefix: $field should be a non-empty string.');
}

void _expectExistingAsset(
  String storyId,
  String path,
  CatalogQaReport report,
) {
  if (!File(path).existsSync()) {
    report.addError('$storyId: missing asset $path');
  }
}

List<String> _readStringList(File file) {
  final value = jsonDecode(file.readAsStringSync());
  if (value is List) {
    return value.whereType<String>().toList();
  }

  return const [];
}

class CatalogQaReport {
  final errors = <String>[];
  final warnings = <String>[];

  void addError(String message) {
    errors.add(message);
  }

  void addWarning(String message) {
    warnings.add(message);
  }

  void printSummary() {
    stdout.writeln('Catalog QA');
    stdout.writeln('Errors: ${errors.length}');
    stdout.writeln('Warnings: ${warnings.length}');

    if (errors.isNotEmpty) {
      stdout.writeln('\nErrors');
      for (final error in errors) {
        stdout.writeln('- $error');
      }
    }

    if (warnings.isNotEmpty) {
      stdout.writeln('\nWarnings');
      for (final warning in warnings) {
        stdout.writeln('- $warning');
      }
    }
  }
}
