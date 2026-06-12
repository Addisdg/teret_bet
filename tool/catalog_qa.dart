import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

const _manifestPath = 'assets/stories/story_manifest.json';
const _storyImageWidth = 1200;
const _storyImageHeight = 900;
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
    _expectStoryImageAsset(storyId, coverImage, report);
  } else {
    report.addWarning('$storyId: coverImage should be a bundled asset path.');
  }

  final pages = story['pages'];
  if (pages is! List) {
    report.addError('$storyId: pages must be a list.');
    return;
  }

  if (pages.length < 6) {
    report.addWarning(
      '$storyId: has ${pages.length} pages; expand if the story feels rushed.',
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
      _expectStoryImageAsset(storyId, imageUrl, report);
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

void _expectStoryImageAsset(
  String storyId,
  String path,
  CatalogQaReport report,
) {
  _expectExistingAsset(storyId, path, report);

  final file = File(path);
  if (!file.existsSync()) {
    return;
  }

  if (!path.endsWith('.webp')) {
    report.addError('$storyId: story image should be WebP: $path');
    return;
  }

  final size = _readWebpSize(file);
  if (size == null) {
    report.addError('$storyId: could not read WebP dimensions for $path');
    return;
  }

  if (size.width != _storyImageWidth || size.height != _storyImageHeight) {
    report.addError(
      '$storyId: $path is ${size.width}x${size.height}; '
      'expected ${_storyImageWidth}x$_storyImageHeight.',
    );
  }
}

_ImageSize? _readWebpSize(File file) {
  final bytes = file.readAsBytesSync();
  if (bytes.length < 16) {
    return null;
  }

  final data = ByteData.sublistView(Uint8List.fromList(bytes));
  if (_ascii(bytes, 0, 4) != 'RIFF' || _ascii(bytes, 8, 4) != 'WEBP') {
    return null;
  }

  var offset = 12;
  while (offset + 8 <= bytes.length) {
    final chunkType = _ascii(bytes, offset, 4);
    final chunkSize = data.getUint32(offset + 4, Endian.little);
    final chunkData = offset + 8;
    if (chunkData + chunkSize > bytes.length) {
      return null;
    }

    if (chunkType == 'VP8X' && chunkSize >= 10) {
      final width = _readUint24(bytes, chunkData + 4) + 1;
      final height = _readUint24(bytes, chunkData + 7) + 1;
      return _ImageSize(width, height);
    }

    if (chunkType == 'VP8 ' && chunkSize >= 10) {
      final hasStartCode = bytes[chunkData + 3] == 0x9d &&
          bytes[chunkData + 4] == 0x01 &&
          bytes[chunkData + 5] == 0x2a;
      if (!hasStartCode) {
        return null;
      }

      final width = data.getUint16(chunkData + 6, Endian.little) & 0x3fff;
      final height = data.getUint16(chunkData + 8, Endian.little) & 0x3fff;
      return _ImageSize(width, height);
    }

    if (chunkType == 'VP8L' && chunkSize >= 5 && bytes[chunkData] == 0x2f) {
      final bits = data.getUint32(chunkData + 1, Endian.little);
      final width = (bits & 0x3fff) + 1;
      final height = ((bits >> 14) & 0x3fff) + 1;
      return _ImageSize(width, height);
    }

    offset = chunkData + chunkSize + (chunkSize.isOdd ? 1 : 0);
  }

  return null;
}

String _ascii(List<int> bytes, int offset, int length) {
  if (offset + length > bytes.length) {
    return '';
  }

  return String.fromCharCodes(bytes.sublist(offset, offset + length));
}

int _readUint24(List<int> bytes, int offset) {
  return bytes[offset] | (bytes[offset + 1] << 8) | (bytes[offset + 2] << 16);
}

class _ImageSize {
  final int width;
  final int height;

  const _ImageSize(this.width, this.height);
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
