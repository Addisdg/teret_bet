# Current Goal

Near-release MVP hardening: make the Android build identifiable as Teret Bet,
keep the bundled ten-story catalog feedback-ready, and remove release blockers
before external testing.

## Completed

* Content strategy documentation
* First 50 story candidate list
* Story adaptation guidelines
* Audio roadmap
* Design inspiration notes
* Content review checklist
* Upgraded story schema
* Manifest-based local story loading
* Firestore -> Hive cache -> local JSON fallback chain
* Batch 1 local story manifest
* Feedback-ready Amharic adaptations for all current manifest stories
* Batch 2 Grimm-inspired Amharic stories added with bundled local cover/page artwork
* Batch 3 Andersen-inspired Amharic stories added with bundled local cover/page artwork
* Audio-ready metadata and UI placeholders
* Reading progress persistence
* Favorite stories with local persistence and library filtering
* Settings screen with reader font-size control
* Local cover illustrations for all current manifest stories
* Unique cover-style local page illustrations for all current manifest stories
* Placeholder image URLs removed from the current manifest catalog
* Android app ID and launcher label prepared for release builds
* Android release signing hook prepared for ignored local/CI keystore secrets
* Web, iOS, and macOS display metadata prepared with the Teret Bet name
* Branded launcher icons prepared for Android, iOS, macOS, and web

## Current Release Identity

* Android package: `com.teretbet.app`
* Android launcher label: `Teret Bet`
* Version: `1.0.0+1`

## Next Recommended Task

Continue Batch 4 with the next 10 stories from `docs/FIRST_50_STORIES.md`,
including schema-complete text assets, bundled cover/page artwork, manifest
updates, tests, verification, and one commit for the 10-story batch.

Release signing also remains before external Android testing: create release
signing credentials outside the repository, add the matching local/CI secret
values, then run:

```bash
flutter analyze
flutter test
flutter build apk --release --dart-define=FIREBASE_ANDROID_API_KEY=your_android_key
```

Before a Firestore-backed external test, register `com.teretbet.app` in Firebase
and apply Android API key restrictions for the release signing certificate.
