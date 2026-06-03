# Teret Bet / ተረት ቤት

A cross-platform Flutter app for illustrated Amharic children's stories.

## MVP Features

- Story library screen
- Story details screen
- Page-based story reader
- Amharic-first UI
- Firebase Firestore integration
- Cached network images
- Hive story cache and reading progress
- Local JSON fallback with three bundled story assets
- Optimized bundled WebP cover and page illustrations for offline reading
- Settings screen with reader font size control
- Reader controls for page jumping, text-size changes, and distraction-light
  reading
- Audio-ready metadata and placeholder UI

## Tech Stack

- Flutter
- Firebase Firestore
- Provider for state management
- Cached Network Image
- Hive for offline story caching, reading progress, and settings

## Project Structure

```text
lib/
├── main.dart
├── app.dart
├── core/
│   └── theme/
└── features/
    └── stories/
        ├── data/
        │   ├── models/
        │   │   ├── story_model.dart
        │   │   └── story_page_model.dart
        │   ├── repositories/
        │   │   └── story_repository.dart
        │   └── services/
        │       ├── firestore_story_service.dart
        │       └── local_story_service.dart
        └── presentation/
            ├── providers/
            │   ├── settings_provider.dart
            │   └── story_provider.dart
            ├── screens/
            │   ├── home_screen.dart
            │   ├── settings_screen.dart
            │   ├── story_details_screen.dart
            │   └── story_reader_screen.dart
            └── widgets/
                └── story_card.dart
```

## Story Loading

The app keeps the MVP fallback order simple:

1. Load stories from Firestore.
2. If Firestore is unavailable, load the last Hive cache.
3. If no cache exists, load local story IDs from
   `assets/stories/story_manifest.json`.

To add a local fallback story, add a new `.json` file to `assets/stories/`.
Then add the story ID to `assets/stories/story_manifest.json` so the library can
show it.

Bundled MVP stories:

- `little_rabbit`
- Batch 1 draft placeholders from `story_manifest.json`

Story JSON and Firestore fields are documented in
[`docs/story_content_schema.md`](docs/story_content_schema.md).

## Reading Progress And Settings

The reader saves the last opened page for each story in Hive. When the story is
opened again, it starts from that saved page. Readers can move with swipes,
previous/next buttons, or the page slider.

Reader font size is also stored in Hive from the Settings screen. The language
toggle is shown as a disabled placeholder for a future multilingual release.
The reader also includes text-size buttons so parents can adjust the story while
reading.

Stories now include nullable audio metadata. The details and reader screens show
audio placeholders, but playback packages are intentionally deferred.

## Local Testing

Linux desktop can run without Firebase configuration and will use Hive/local JSON
assets:

```bash
flutter run -d linux
```

Hive stores local desktop test data in an app-specific `teret_bet` folder so
Linux/WSL runs do not compete for box locks in the home directory.

For mobile testing, connect an Android device or emulator and run:

```bash
flutter devices
flutter run -d <device-id>
```
