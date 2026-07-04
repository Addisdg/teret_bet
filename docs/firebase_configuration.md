# Firebase Configuration

Firebase API keys must not be committed to this repository. The app reads them
from Dart compile-time environment values instead.

## Dart Define Names

Use these names when running or building the app:

```text
FIREBASE_WEB_API_KEY
FIREBASE_ANDROID_API_KEY
FIREBASE_IOS_API_KEY
FIREBASE_MACOS_API_KEY
FIREBASE_WINDOWS_API_KEY
```

The app still launches without these values. Firebase initialization will fail
gracefully, then the MVP can keep using Hive cache and bundled local JSON
stories.

## Android App Identity

The Android release package name is:

```text
com.teretbet.app
```

This Android app has been registered in Firebase. The release SHA-1 and SHA-256
fingerprints have been added for this package. Keep any API key restrictions
aligned with the same package name and release signing certificate fingerprints.

Current Android Firebase app ID:

```text
1:391218282653:android:fd5955c8f7475445bb9474
```

`android/app/google-services.json` is intentionally ignored by Git. Keep
`lib/firebase_options.dart` free of literal API keys; it should continue reading
keys from the `FIREBASE_*_API_KEY` `--dart-define` values.

## Android Release Signing

Release signing secrets stay out of Git. For a locally signed release build,
create `android/key.properties` with values like:

```properties
storeFile=../path/to/teret-bet-release.jks
storePassword=your_store_password
keyAlias=teret-bet
keyPassword=your_key_password
```

When `android/key.properties` exists, Gradle signs release builds with that
keystore. Without it, Gradle fails release tasks with an explicit error; it
never creates a debug-signed artifact labelled as a release. Debug builds remain
available without release credentials. The local release signing files are
intentionally ignored by Git.

## Firestore Catalog Export

Generate a reviewed-catalog payload from the local manifest before writing the
catalog to Firestore:

```bash
dart tool/export_firestore_catalog.dart
```

The default output is ignored by Git:

```text
build/firestore/catalog_export.json
```

The export contains story documents for `stories/{storyId}` and page documents
for `stories/{storyId}/pages/page_XX`. It is an app-specific staging payload,
not a Firebase managed export/import backup.

Preview the upload plan without writing to Firestore:

```bash
dart tool/upload_firestore_catalog.dart
```

The upload tool reads the project ID from `firebase.json` by default and prints
the number of story/page document writes it would send. To write the catalog,
provide a short-lived OAuth access token from a local authenticated Google Cloud
session and pass `--commit`:

```bash
export FIRESTORE_ACCESS_TOKEN="$(gcloud auth print-access-token)"
dart tool/upload_firestore_catalog.dart --commit
```

You can override defaults when needed:

```bash
dart tool/upload_firestore_catalog.dart \
  --project=teret-bet \
  --database='(default)' \
  --export=build/firestore/catalog_export.json
```

The token is read only from the local environment and must not be committed.

## Local Examples

Web:

```bash
flutter run -d web-server \
  --dart-define=FIREBASE_WEB_API_KEY=your_web_key
```

Android:

```bash
flutter run -d <device-id> \
  --dart-define=FIREBASE_ANDROID_API_KEY=your_android_key
```

Android release:

```bash
flutter build apk --release \
  --dart-define=FIREBASE_ANDROID_API_KEY=your_android_key
```

Before building for external Android testing, run the local release preflight:

```bash
dart tool/release_preflight.dart
```

The preflight checks Android identity, app version format, Firebase option
wiring, release signing file readiness, and the Firestore catalog export.
Missing signing credentials or `FIREBASE_ANDROID_API_KEY` are warnings in normal
preflight mode because those values stay outside Git, although Gradle itself
will refuse a release build without signing credentials. Use `--strict` when
you want all preflight warnings to fail a CI or release checklist run.

Keep real values in a local shell, password manager, CI secret, or ignored
`.env` file. Do not paste real keys into tracked Dart, JSON, Gradle, plist, or
documentation files.

## Firestore Rules

External test builds use public read-only access to the reviewed story catalog:

```js
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /stories/{storyId} {
      allow read: if true;
      allow write: if false;

      match /pages/{pageId} {
        allow read: if true;
        allow write: if false;
      }
    }
  }
}
```

## Secret Alert Cleanup

If GitHub reports a leaked Google API key:

1. Rotate any key still in use so workflows do not break unexpectedly.
2. Revoke the exposed key in Google Cloud Console.
3. Check Google Cloud and Firebase security logs for unexpected usage.
4. Close the GitHub alert only after the key is revoked.

Removing the key from new commits does not protect the already-exposed key,
because it may still exist in Git history or GitHub alert records.
