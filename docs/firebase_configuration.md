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

Register this exact Android package in Firebase before building a Firestore-backed
release, then apply any Android API key restrictions to the same package name and
the release signing certificate SHA fingerprints.

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
keystore. Without it, release builds fall back to the debug key for local smoke
testing only.

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

Keep real values in a local shell, password manager, CI secret, or ignored
`.env` file. Do not paste real keys into tracked Dart, JSON, Gradle, plist, or
documentation files.

## Secret Alert Cleanup

If GitHub reports a leaked Google API key:

1. Rotate any key still in use so workflows do not break unexpectedly.
2. Revoke the exposed key in Google Cloud Console.
3. Check Google Cloud and Firebase security logs for unexpected usage.
4. Close the GitHub alert only after the key is revoked.

Removing the key from new commits does not protect the already-exposed key,
because it may still exist in Git history or GitHub alert records.
