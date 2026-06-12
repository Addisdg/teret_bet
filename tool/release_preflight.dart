import 'dart:convert';
import 'dart:io';

const _expectedAndroidPackage = 'com.teretbet.app';
const _expectedAppName = 'Teret Bet';
const _catalogExportPath = 'build/firestore/catalog_export.json';
const _catalogManifestPath = 'assets/stories/story_manifest.json';

void main(List<String> args) {
  final strict = args.contains('--strict');
  final report = _PreflightReport();

  _checkAndroidIdentity(report);
  _checkPubspecVersion(report);
  _checkFirebaseOptions(report);
  _checkAndroidSigning(report);
  _checkFirestoreExport(report);

  report.printSummary(strict: strict);

  if (report.failures.isNotEmpty || (strict && report.warnings.isNotEmpty)) {
    exitCode = 1;
  }
}

void _checkAndroidIdentity(_PreflightReport report) {
  final buildGradle = File('android/app/build.gradle.kts');
  final manifest = File('android/app/src/main/AndroidManifest.xml');
  final strings = File('android/app/src/main/res/values/strings.xml');

  final gradleText = _readOptional(buildGradle);
  if (gradleText == null) {
    report.fail('Missing Android Gradle config: ${buildGradle.path}');
  } else {
    _expectContains(
      report,
      gradleText,
      'namespace = "$_expectedAndroidPackage"',
      'Android namespace is $_expectedAndroidPackage.',
      'Android namespace should be $_expectedAndroidPackage.',
    );
    _expectContains(
      report,
      gradleText,
      'applicationId = "$_expectedAndroidPackage"',
      'Android applicationId is $_expectedAndroidPackage.',
      'Android applicationId should be $_expectedAndroidPackage.',
    );
  }

  final manifestText = _readOptional(manifest);
  if (manifestText == null) {
    report.fail('Missing Android manifest: ${manifest.path}');
  } else {
    _expectContains(
      report,
      manifestText,
      'android:label="@string/app_name"',
      'Android label uses @string/app_name.',
      'Android label should use @string/app_name.',
    );
  }

  final stringsText = _readOptional(strings);
  if (stringsText == null) {
    report.fail('Missing Android strings file: ${strings.path}');
  } else {
    _expectContains(
      report,
      stringsText,
      '<string name="app_name">$_expectedAppName</string>',
      'Android launcher label is $_expectedAppName.',
      'Android launcher label should be $_expectedAppName.',
    );
  }
}

void _checkPubspecVersion(_PreflightReport report) {
  final pubspec = File('pubspec.yaml');
  final text = _readOptional(pubspec);
  if (text == null) {
    report.fail('Missing pubspec.yaml.');
    return;
  }

  final versionMatch =
      RegExp(r'^version:\s*(\d+\.\d+\.\d+\+\d+)\s*$', multiLine: true)
          .firstMatch(text);
  if (versionMatch == null) {
    report.fail('pubspec.yaml should define version as x.y.z+build.');
    return;
  }

  report.pass('App version is ${versionMatch.group(1)}.');
}

void _checkFirebaseOptions(_PreflightReport report) {
  final file = File('lib/firebase_options.dart');
  final text = _readOptional(file);
  if (text == null) {
    report.fail('Missing Firebase options file: ${file.path}');
    return;
  }

  _expectContains(
    report,
    text,
    "String.fromEnvironment('FIREBASE_ANDROID_API_KEY')",
    'Android Firebase API key is read from --dart-define.',
    'Android Firebase API key should be read from --dart-define.',
  );
  _expectContains(
    report,
    text,
    "appId: '1:391218282653:android:bc2cc6282b721779bb9474'",
    'Android Firebase app ID is configured.',
    'Android Firebase app ID is missing or changed.',
  );

  final apiKey = Platform.environment['FIREBASE_ANDROID_API_KEY'];
  if (apiKey == null || apiKey.trim().isEmpty) {
    report.warn(
      'FIREBASE_ANDROID_API_KEY is not set in the environment; '
      'Firebase-backed Android builds still need it.',
    );
  } else {
    report.pass('FIREBASE_ANDROID_API_KEY is present in the environment.');
  }
}

void _checkAndroidSigning(_PreflightReport report) {
  final keyPropertiesFile = File('android/key.properties');
  if (!keyPropertiesFile.existsSync()) {
    report.warn(
      'android/key.properties is absent; release builds will use debug signing '
      'fallback for local smoke tests only.',
    );
    return;
  }

  final properties = _readProperties(keyPropertiesFile);
  const requiredKeys = {
    'storeFile',
    'storePassword',
    'keyAlias',
    'keyPassword',
  };
  var hasSigningFailure = false;

  for (final key in requiredKeys) {
    final value = properties[key];
    if (value == null || value.trim().isEmpty) {
      hasSigningFailure = true;
      report.fail('android/key.properties is missing $key.');
    }
  }

  final storeFile = properties['storeFile'];
  if (storeFile != null && storeFile.trim().isNotEmpty) {
    final keyStorePath = File('android/$storeFile').absolute;
    if (keyStorePath.existsSync()) {
      report.pass('Release keystore file exists at $storeFile.');
    } else {
      hasSigningFailure = true;
      report.fail('Release keystore file does not exist: $storeFile.');
    }
  }

  if (!hasSigningFailure) {
    report
        .pass('android/key.properties has the required release signing keys.');
  }
}

void _checkFirestoreExport(_PreflightReport report) {
  final exportFile = File(_catalogExportPath);
  if (!exportFile.existsSync()) {
    report.warn(
      'Firestore catalog export is missing; run '
      '`dart tool/export_firestore_catalog.dart` before upload.',
    );
    return;
  }

  final export = _readJsonObject(exportFile, report);
  if (export == null) {
    return;
  }

  final manifest = File(_catalogManifestPath);
  final manifestIds = _readJsonList(manifest, report)?.whereType<String>();
  final expectedStoryCount = manifestIds?.length;
  final storyCount = export['storyCount'];
  final pageCount = export['pageCount'];
  final stories = export['stories'];

  if (export['format'] != 'teret_bet_firestore_catalog_export') {
    report.fail('Firestore export format is not recognized.');
  }

  if (expectedStoryCount != null && storyCount != expectedStoryCount) {
    report.fail(
      'Firestore export has $storyCount stories; expected $expectedStoryCount.',
    );
  }

  if (pageCount is! int || pageCount <= 0) {
    report.fail('Firestore export pageCount should be a positive number.');
  }

  if (stories is! List || stories.length != storyCount) {
    report.fail('Firestore export stories list does not match storyCount.');
  }

  if (report.failures
      .every((failure) => !failure.contains('Firestore export'))) {
    report
        .pass('Firestore catalog export is present and matches the manifest.');
  }
}

String? _readOptional(File file) {
  if (!file.existsSync()) {
    return null;
  }

  return file.readAsStringSync();
}

Map<String, String> _readProperties(File file) {
  final properties = <String, String>{};
  for (final line in file.readAsLinesSync()) {
    final trimmed = line.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#')) {
      continue;
    }

    final separator = trimmed.indexOf('=');
    if (separator <= 0) {
      continue;
    }

    properties[trimmed.substring(0, separator).trim()] =
        trimmed.substring(separator + 1).trim();
  }

  return properties;
}

Map<String, dynamic>? _readJsonObject(File file, _PreflightReport report) {
  try {
    final value = jsonDecode(file.readAsStringSync());
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
  } on FormatException catch (error) {
    report.fail('${file.path} is not valid JSON: ${error.message}');
    return null;
  }

  report.fail('${file.path} should contain a JSON object.');
  return null;
}

List<dynamic>? _readJsonList(File file, _PreflightReport report) {
  if (!file.existsSync()) {
    report.fail('Missing JSON list file: ${file.path}');
    return null;
  }

  try {
    final value = jsonDecode(file.readAsStringSync());
    if (value is List) {
      return value;
    }
  } on FormatException catch (error) {
    report.fail('${file.path} is not valid JSON: ${error.message}');
    return null;
  }

  report.fail('${file.path} should contain a JSON list.');
  return null;
}

void _expectContains(
  _PreflightReport report,
  String text,
  String pattern,
  String passMessage,
  String failureMessage,
) {
  if (text.contains(pattern)) {
    report.pass(passMessage);
  } else {
    report.fail(failureMessage);
  }
}

class _PreflightReport {
  final passes = <String>[];
  final warnings = <String>[];
  final failures = <String>[];

  void pass(String message) {
    passes.add(message);
  }

  void warn(String message) {
    warnings.add(message);
  }

  void fail(String message) {
    failures.add(message);
  }

  void printSummary({required bool strict}) {
    stdout.writeln('Release preflight');
    stdout.writeln('Passes: ${passes.length}');
    stdout.writeln('Warnings: ${warnings.length}');
    stdout.writeln('Failures: ${failures.length}');
    if (strict) {
      stdout.writeln('Strict: enabled');
    }

    if (passes.isNotEmpty) {
      stdout.writeln('\nPasses');
      for (final message in passes) {
        stdout.writeln('- $message');
      }
    }

    if (warnings.isNotEmpty) {
      stdout.writeln('\nWarnings');
      for (final message in warnings) {
        stdout.writeln('- $message');
      }
    }

    if (failures.isNotEmpty) {
      stdout.writeln('\nFailures');
      for (final message in failures) {
        stdout.writeln('- $message');
      }
    }
  }
}
