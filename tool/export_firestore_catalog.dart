import 'dart:convert';
import 'dart:io';

const _manifestPath = 'assets/stories/story_manifest.json';
const _defaultOutputPath = 'build/firestore/catalog_export.json';

void main(List<String> args) {
  final outputPath = _readOutputPath(args);
  final manifestFile = File(_manifestPath);

  if (!manifestFile.existsSync()) {
    stderr.writeln('Missing manifest: $_manifestPath');
    exitCode = 1;
    return;
  }

  final storyIds = _readStringList(manifestFile);
  final stories = <Map<String, dynamic>>[];
  var pageCount = 0;

  for (final storyId in storyIds) {
    final storyFile = File('assets/stories/$storyId.json');
    if (!storyFile.existsSync()) {
      stderr.writeln('Missing story JSON file: ${storyFile.path}');
      exitCode = 1;
      return;
    }

    final storyJson = _readMap(storyFile);
    final pages = _readPageList(storyId, storyJson['pages']);
    pageCount += pages.length;

    stories.add({
      'id': storyId,
      'path': 'stories/$storyId',
      'data': _storyData(storyJson, storyId),
      'pages': [
        for (final page in pages)
          {
            'id':
                'page_${(page['pageNumber'] as int).toString().padLeft(2, '0')}',
            'path':
                'stories/$storyId/pages/page_${(page['pageNumber'] as int).toString().padLeft(2, '0')}',
            'data': page,
          },
      ],
    });
  }

  final export = {
    'format': 'teret_bet_firestore_catalog_export',
    'formatVersion': 1,
    'generatedAt': DateTime.now().toUtc().toIso8601String(),
    'firestoreRoot': 'stories',
    'storyCount': stories.length,
    'pageCount': pageCount,
    'stories': stories,
  };

  final outputFile = File(outputPath);
  outputFile.parent.createSync(recursive: true);
  const encoder = JsonEncoder.withIndent('  ');
  outputFile.writeAsStringSync('${encoder.convert(export)}\n');

  stdout.writeln('Firestore catalog export');
  stdout.writeln('Stories: ${stories.length}');
  stdout.writeln('Pages: $pageCount');
  stdout.writeln('Output: ${outputFile.path}');
}

String _readOutputPath(List<String> args) {
  for (var index = 0; index < args.length; index += 1) {
    final arg = args[index];
    if (arg == '--out' && index + 1 < args.length) {
      return args[index + 1];
    }

    if (arg.startsWith('--out=')) {
      return arg.substring('--out='.length);
    }
  }

  return _defaultOutputPath;
}

Map<String, dynamic> _readMap(File file) {
  final value = jsonDecode(file.readAsStringSync());
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }

  throw FormatException('${file.path} must contain a JSON object.');
}

List<String> _readStringList(File file) {
  final value = jsonDecode(file.readAsStringSync());
  if (value is List) {
    return value.whereType<String>().toList();
  }

  throw FormatException('${file.path} must contain a JSON list.');
}

Map<String, dynamic> _storyData(Map<String, dynamic> story, String storyId) {
  final data = Map<String, dynamic>.from(story)..remove('pages');
  data['id'] = storyId;
  return data;
}

List<Map<String, dynamic>> _readPageList(String storyId, Object? value) {
  if (value is! List) {
    throw FormatException('$storyId: pages must be a JSON list.');
  }

  return [
    for (var index = 0; index < value.length; index += 1)
      _readPage(storyId, index, value[index]),
  ];
}

Map<String, dynamic> _readPage(String storyId, int index, Object? value) {
  if (value is! Map) {
    throw FormatException(
        '$storyId page ${index + 1}: page must be an object.');
  }

  final page = Map<String, dynamic>.from(value);
  final pageNumber = page['pageNumber'];
  if (pageNumber != index + 1) {
    throw FormatException(
      '$storyId page ${index + 1}: pageNumber should be ${index + 1}.',
    );
  }

  return page;
}
