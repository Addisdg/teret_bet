import 'dart:convert';
import 'dart:io';

const _defaultExportPath = 'build/firestore/catalog_export.json';
const _defaultDatabase = '(default)';
const _batchLimit = 400;

Future<void> main(List<String> args) async {
  final options = _UploadOptions.fromArgs(args);
  final exportFile = File(options.exportPath);

  if (!exportFile.existsSync()) {
    stderr.writeln(
      'Missing export: ${options.exportPath}. '
      'Run `dart tool/export_firestore_catalog.dart` first.',
    );
    exitCode = 1;
    return;
  }

  final projectId = options.projectId ?? _readFirebaseProjectId();
  if (projectId == null || projectId.trim().isEmpty) {
    stderr.writeln(
      'Missing Firebase project ID. Pass --project=<project-id> or configure '
      'firebase.json.',
    );
    exitCode = 1;
    return;
  }

  final export = _readJsonObject(exportFile);
  _validateExport(export);
  final writes = _buildWrites(export, projectId, options.database);

  stdout.writeln('Firestore catalog upload');
  stdout.writeln('Project: $projectId');
  stdout.writeln('Database: ${options.database}');
  stdout.writeln('Export: ${exportFile.path}');
  stdout.writeln('Stories: ${export['storyCount']}');
  stdout.writeln('Pages: ${export['pageCount']}');
  stdout.writeln('Writes: ${writes.length}');

  if (!options.commit) {
    stdout.writeln('Dry run only. Re-run with --commit to upload.');
    return;
  }

  final accessToken = Platform.environment['FIRESTORE_ACCESS_TOKEN'];
  if (accessToken == null || accessToken.trim().isEmpty) {
    stderr.writeln(
      'Missing FIRESTORE_ACCESS_TOKEN. Create one with an authenticated Google '
      'Cloud session, for example: '
      '`export FIRESTORE_ACCESS_TOKEN="\$(gcloud auth print-access-token)"`.',
    );
    exitCode = 1;
    return;
  }

  final uploader = _FirestoreUploader(
    projectId: projectId,
    database: options.database,
    accessToken: accessToken,
  );

  var uploaded = 0;
  for (final batch in _chunks(writes, _batchLimit)) {
    await uploader.batchWrite(batch);
    uploaded += batch.length;
    stdout.writeln('Uploaded $uploaded/${writes.length} documents...');
  }

  stdout.writeln('Firestore catalog upload complete.');
}

Map<String, dynamic> _readJsonObject(File file) {
  final value = jsonDecode(file.readAsStringSync());
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }

  throw FormatException('${file.path} must contain a JSON object.');
}

String? _readFirebaseProjectId() {
  final file = File('firebase.json');
  if (!file.existsSync()) {
    return null;
  }

  try {
    final data = _readJsonObject(file);
    final flutter = data['flutter'];
    if (flutter is Map) {
      final dart = flutter['dart'];
      if (dart is Map) {
        final firebaseOptions = dart['lib/firebase_options.dart'];
        if (firebaseOptions is Map && firebaseOptions['projectId'] is String) {
          return firebaseOptions['projectId'] as String;
        }
      }

      final platforms = flutter['platforms'];
      if (platforms is Map) {
        final android = platforms['android'];
        if (android is Map) {
          final defaultConfig = android['default'];
          if (defaultConfig is Map && defaultConfig['projectId'] is String) {
            return defaultConfig['projectId'] as String;
          }
        }
      }
    }
  } on FormatException {
    return null;
  }

  return null;
}

void _validateExport(Map<String, dynamic> export) {
  if (export['format'] != 'teret_bet_firestore_catalog_export') {
    throw FormatException('Unrecognized export format.');
  }

  final stories = export['stories'];
  if (stories is! List || stories.isEmpty) {
    throw FormatException('Export must include a non-empty stories list.');
  }

  final storyCount = export['storyCount'];
  if (storyCount is! int || storyCount != stories.length) {
    throw FormatException('storyCount does not match stories list length.');
  }

  final pageCount = export['pageCount'];
  if (pageCount is! int || pageCount <= 0) {
    throw FormatException('pageCount must be a positive integer.');
  }
}

List<Map<String, dynamic>> _buildWrites(
  Map<String, dynamic> export,
  String projectId,
  String database,
) {
  final writes = <Map<String, dynamic>>[];
  final stories = export['stories'] as List;

  for (final storyValue in stories) {
    if (storyValue is! Map) {
      throw FormatException('Each story export entry must be an object.');
    }

    final story = Map<String, dynamic>.from(storyValue);
    final path = _readString(story, 'path');
    final data = _readMap(story, 'data');
    writes.add(_writeFor(path, data, projectId, database));

    final pages = story['pages'];
    if (pages is! List) {
      throw FormatException('$path: pages must be a list.');
    }

    for (final pageValue in pages) {
      if (pageValue is! Map) {
        throw FormatException('$path: page entries must be objects.');
      }

      final page = Map<String, dynamic>.from(pageValue);
      final pagePath = _readString(page, 'path');
      final pageData = _readMap(page, 'data');
      writes.add(_writeFor(pagePath, pageData, projectId, database));
    }
  }

  return writes;
}

Map<String, dynamic> _writeFor(
  String documentPath,
  Map<String, dynamic> data,
  String projectId,
  String database,
) {
  return {
    'update': {
      'name': 'projects/$projectId/databases/$database/documents/$documentPath',
      'fields': _encodeMap(data),
    },
  };
}

String _readString(Map<String, dynamic> data, String key) {
  final value = data[key];
  if (value is String && value.isNotEmpty) {
    return value;
  }

  throw FormatException('Missing string field "$key".');
}

Map<String, dynamic> _readMap(Map<String, dynamic> data, String key) {
  final value = data[key];
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }

  throw FormatException('Missing object field "$key".');
}

Map<String, dynamic> _encodeMap(Map<String, dynamic> data) {
  return {
    for (final entry in data.entries) entry.key: _encodeValue(entry.value),
  };
}

Map<String, dynamic> _encodeValue(Object? value) {
  if (value == null) {
    return {'nullValue': 'NULL_VALUE'};
  }

  if (value is bool) {
    return {'booleanValue': value};
  }

  if (value is int) {
    return {'integerValue': value.toString()};
  }

  if (value is double) {
    return {'doubleValue': value};
  }

  if (value is String) {
    return {'stringValue': value};
  }

  if (value is List) {
    return {
      'arrayValue': {
        'values': [for (final item in value) _encodeValue(item)],
      },
    };
  }

  if (value is Map) {
    return {
      'mapValue': {
        'fields': _encodeMap(Map<String, dynamic>.from(value)),
      },
    };
  }

  throw FormatException('Unsupported Firestore value: $value');
}

Iterable<List<T>> _chunks<T>(List<T> values, int size) sync* {
  for (var index = 0; index < values.length; index += size) {
    final end = index + size;
    yield values.sublist(index, end > values.length ? values.length : end);
  }
}

class _FirestoreUploader {
  final String projectId;
  final String database;
  final String accessToken;

  _FirestoreUploader({
    required this.projectId,
    required this.database,
    required this.accessToken,
  });

  Future<void> batchWrite(List<Map<String, dynamic>> writes) async {
    final uri = Uri.https(
      'firestore.googleapis.com',
      '/v1/projects/$projectId/databases/$database/documents:batchWrite',
    );
    final client = HttpClient();

    try {
      final request = await client.postUrl(uri);
      request.headers.contentType = ContentType.json;
      request.headers
          .set(HttpHeaders.authorizationHeader, 'Bearer $accessToken');
      request.write(jsonEncode({'writes': writes}));

      final response = await request.close();
      final body = await utf8.decodeStream(response);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException(
          'Firestore batchWrite failed with HTTP ${response.statusCode}: $body',
          uri: uri,
        );
      }

      final decoded = jsonDecode(body);
      if (decoded is Map && decoded['status'] is List) {
        final statuses = decoded['status'] as List;
        for (var index = 0; index < statuses.length; index += 1) {
          final status = statuses[index];
          if (status is Map && status.isNotEmpty) {
            throw StateError('Write $index failed: $status');
          }
        }
      }
    } finally {
      client.close(force: true);
    }
  }
}

class _UploadOptions {
  final bool commit;
  final String? projectId;
  final String database;
  final String exportPath;

  _UploadOptions({
    required this.commit,
    required this.projectId,
    required this.database,
    required this.exportPath,
  });

  factory _UploadOptions.fromArgs(List<String> args) {
    return _UploadOptions(
      commit: args.contains('--commit'),
      projectId: _readOption(args, '--project'),
      database: _readOption(args, '--database') ?? _defaultDatabase,
      exportPath: _readOption(args, '--export') ?? _defaultExportPath,
    );
  }

  static String? _readOption(List<String> args, String name) {
    for (var index = 0; index < args.length; index += 1) {
      final arg = args[index];
      if (arg == name && index + 1 < args.length) {
        return args[index + 1];
      }

      if (arg.startsWith('$name=')) {
        return arg.substring(name.length + 1);
      }
    }

    return null;
  }
}
