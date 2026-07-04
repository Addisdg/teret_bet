import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

const _manifestPath = 'assets/stories/story_manifest.json';
const _storyImageWidth = 960;
const _storyImageHeight = 720;
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

void main(List<String> args) {
  final report = CatalogQaReport();
  final strictEditorial = args.contains('--strict-editorial');
  final selectedStoryId = _readStorySelection(args, report);
  final manifestFile = File(_manifestPath);

  if (!manifestFile.existsSync()) {
    report.addError('Missing manifest: $_manifestPath');
    report.printSummary();
    exitCode = 1;
    return;
  }

  final manifest = _readStringList(manifestFile);
  final seenIds = <String>{};
  final storiesToReview = selectedStoryId == null
      ? manifest
      : manifest.where((storyId) => storyId == selectedStoryId).toList();

  if (manifest.length != 50) {
    report.addWarning('Manifest has ${manifest.length} stories, expected 50.');
  }

  if (selectedStoryId != null && storiesToReview.isEmpty) {
    report.addError('$selectedStoryId: story is not listed in the manifest.');
  }

  for (final storyId in storiesToReview) {
    if (!seenIds.add(storyId)) {
      report.addError('Duplicate story ID in manifest: $storyId');
      continue;
    }

    _reviewStory(storyId, report, strictEditorial: strictEditorial);
  }

  report.printSummary();
  if (report.errors.isNotEmpty) {
    exitCode = 1;
  }
}

String? _readStorySelection(List<String> args, CatalogQaReport report) {
  final selections = args.where((arg) => arg.startsWith('--story=')).toList();
  if (selections.length > 1) {
    report.addError('Use at most one --story=story_id argument.');
    return null;
  }

  if (selections.isEmpty) {
    return null;
  }

  final storyId = selections.single.substring('--story='.length).trim();
  if (storyId.isEmpty) {
    report.addError('--story requires a non-empty story ID.');
    return null;
  }

  return storyId;
}

void _reviewStory(
  String storyId,
  CatalogQaReport report, {
  required bool strictEditorial,
}) {
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

  if (story['id'] != storyId) {
    report.addError('$storyId: JSON id must match the manifest story ID.');
  }

  _expectNonEmptyString(storyId, story, 'titleAm', report, required: true);
  _expectNonEmptyString(storyId, story, 'titleEn', report, required: true);
  _expectNonEmptyString(storyId, story, 'summaryAm', report, required: true);
  _expectNonEmptyString(storyId, story, 'moralAm', report, required: true);
  _expectNonEmptyString(storyId, story, 'collection', report, required: true);
  _expectNonEmptyString(storyId, story, 'status', report, required: true);
  if (strictEditorial) {
    _expectNonEmptyString(storyId, story, 'summaryEn', report, required: true);
    _expectNonEmptyString(storyId, story, 'moralEn', report, required: true);
  }

  const validStatuses = {
    'draft',
    'ready_for_review',
    'release_ready',
    'published',
  };
  final status = story['status'];
  if (status is String && !validStatuses.contains(status)) {
    report.addError('$storyId: unsupported status "$status".');
  }

  if (status == 'draft') {
    report.addError('$storyId: manifest stories should not use draft status.');
  }
  if (strictEditorial && status != 'release_ready') {
    report.addError(
      '$storyId: strict editorial QA requires status release_ready.',
    );
  }

  _reviewAgeRange(storyId, story, report);
  if (strictEditorial) {
    _reviewSource(storyId, story['source'], report);
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

    final textEn = page['textEn'];
    if (textEn is! String || textEn.trim().isEmpty) {
      _addRequirement(
        report,
        '$storyId page $pageNumber: textEn is required.',
        required: strictEditorial,
      );
    } else if (textEn.length > 280) {
      report.addWarning(
        '$storyId page $pageNumber: English text is ${textEn.length} '
        'characters; check read-aloud length.',
      );
    }

    _expectNonEmptyString(
      storyId,
      page,
      'illustrationPrompt',
      report,
      location: 'page $pageNumber',
      required: true,
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

void _reviewAgeRange(
  String storyId,
  Map<String, dynamic> story,
  CatalogQaReport report,
) {
  final ageMin = story['ageMin'];
  final ageMax = story['ageMax'];
  if (ageMin is! int || ageMax is! int) {
    report.addError('$storyId: ageMin and ageMax must be integers.');
    return;
  }

  if (ageMin < 3 || ageMax > 6 || ageMin > ageMax) {
    report.addError(
      '$storyId: age range $ageMin-$ageMax must stay within 3-6 and be ordered.',
    );
  }
}

void _reviewSource(
  String storyId,
  dynamic source,
  CatalogQaReport report,
) {
  if (source is! Map<String, dynamic>) {
    _addRequirement(
      report,
      '$storyId: source must be an object.',
      required: true,
    );
    return;
  }

  for (final field in ['type', 'name', 'notes']) {
    _expectNonEmptyString(
      storyId,
      source,
      field,
      report,
      location: 'source',
      required: true,
    );
  }

  if (source['type'] != 'original') {
    _expectNonEmptyString(
      storyId,
      source,
      'sourceUrl',
      report,
      location: 'source',
      required: true,
    );
  }

  for (final field in [
    'adaptationBasisAm',
    'adaptationBasisEn',
    'reviewStatus',
  ]) {
    _expectNonEmptyString(
      storyId,
      source,
      field,
      report,
      location: 'source',
      required: true,
    );
  }

  final originCommunity = source['originCommunity'];
  if (originCommunity is String && originCommunity.trim().isNotEmpty) {
    for (final field in [
      'originLabelAm',
      'originLabelEn',
      'culturalContextAm',
      'culturalContextEn',
    ]) {
      _expectNonEmptyString(
        storyId,
        source,
        field,
        report,
        location: 'source',
        required: true,
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
  bool required = false,
}) {
  final value = data[field];
  if (value is String && value.trim().isNotEmpty) {
    return;
  }

  final prefix = location == null ? storyId : '$storyId $location';
  _addRequirement(
    report,
    '$prefix: $field should be a non-empty string.',
    required: required,
  );
}

void _addRequirement(
  CatalogQaReport report,
  String message, {
  required bool required,
}) {
  if (required) {
    report.addError(message);
  } else {
    report.addWarning(message);
  }
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
