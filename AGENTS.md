# Agent Instructions

## Setup Commands

Use these commands when working in this Flutter repository:

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d web-server
flutter build apk --release
```

## Architecture Rules

* Preserve the Firestore -> Hive cache -> local JSON assets fallback chain.
* Keep Provider as the state management approach.
* Keep the feature-based folder structure under `lib/features/stories/`.
* Keep services and repositories small enough for beginner Flutter developers to follow.
* Do not introduce Riverpod, Bloc, complex Clean Architecture layers, or unnecessary abstraction.

## Code Style

* Write null-safe Dart.
* Keep model parsing clear and explicit.
* Optional fields must not crash older JSON or Firestore data.
* Prefer simple readable code over clever abstractions.
* Use English for code comments.
* Use Amharic primarily for story content and reader-facing story text.

## Quality Gates

Before handing off meaningful changes:

* Run `flutter analyze`.
* Run `flutter test` if tests exist.
* Ensure the app still launches.
* Ensure Android release build is not broken for release-sensitive changes.

## Content Rules

* Do not copy modern copyrighted story text.
* Public-domain classics may be used as source inspiration only.
* Create original, child-friendly Amharic adaptations.
* Keep scary or violent material soft enough for ages 3-6.
