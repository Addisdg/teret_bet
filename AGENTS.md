# Teret Bet Agent Instructions

## Product mission

Teret Bet is an Android-first illustrated story library for Ethiopian children
ages 3-6 and the adults who read with them. Launch languages are Amharic and
English. The experience should be warm, calm, culturally careful, and fully
usable offline after installation.

Quality is the deadline. Do not describe a story as release-ready until it has
passed the editorial, cultural, visual, offline, and technical gates in
`docs/PRODUCT_DEFINITION.md`.

## Commands

Run Flutter through `/home/en23/flutter/bin/flutter` if `flutter` is not on the
shell `PATH`.

```bash
flutter pub get
dart run tool/catalog_qa.dart
flutter analyze
flutter test
flutter run -d web-server
flutter build apk --release
flutter build appbundle --release
```

## Architecture

- Preserve the Firestore -> Hive cache -> bundled JSON fallback chain.
- Keep Provider state management and the feature structure under
  `lib/features/stories/`.
- Keep services and repositories small and readable for beginner Flutter
  developers.
- Do not introduce Riverpod, Bloc, complex Clean Architecture layers, or
  unnecessary abstraction.
- Keep optional JSON and Firestore fields backward compatible and null-safe.

## Content and editorial rules

- Work in approved five-story batches. Text approval comes before final images.
- Amharic and English are independent natural adaptations, not literal
  translations or summaries of one another.
- Use warm spoken standard Amharic suitable for reading aloud.
- Never force a story into a fixed page count. Story continuity determines
  length. Add pages whenever setup, transition, emotion, action, or resolution
  needs room.
- Keep one clear story beat per page. Generate or commission matching artwork
  for every new page when existing art does not accurately support that beat.
- Do not copy modern copyrighted story text or illustrations. Traditional and
  public-domain material must be retold in original wording with provenance.
- Record origin, source, adaptation basis, cultural context, rights status, and
  reviewer evidence for every release story and image.
- Keep conflict soft enough for ages 3-6. Avoid graphic danger, shaming,
  stereotypes, and unsafe endings.
- Use English for code comments. Use the currently selected app language for
  reader-facing text.

## Collaboration and approvals

Read-only inspection and agreed routine validation are allowed. Ask before:

- dependency or architecture changes;
- story text entering or leaving the 50-story catalogue;
- illustration generation or replacement;
- Firebase writes;
- commits, pushes, merges, or other remote Git actions;
- release, Play Console, expense, or external-account actions.

Preserve user-owned changes. Do not discard, overwrite, stage, or commit them
without explicit approval. Record meaningful decisions in
`docs/DECISION_LOG.md` and progress in `docs/STORY_STATUS_BOARD.md`.

## Quality gates

For meaningful implementation changes, run catalog QA, `flutter analyze`,
`flutter test`, and an app launch check. For release-sensitive changes, also
verify a signed Android build and the Pixel 8a device flow. Check airplane-mode
first launch, both languages, portrait and landscape, scalable text, semantics,
contrast, touch targets, and release size.

Do not upload the catalogue to Firestore or call the app release-ready merely
because automated checks pass. Human language, read-aloud, cultural, and visual
approval remain mandatory.
