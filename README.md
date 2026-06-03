# Teret Bet / ተረት ቤት

Teret Bet is an Amharic-first Flutter app for illustrated children's stories.
The long-term mission is to become a warm digital story library for Ethiopian
children and Ethiopian diaspora families, supporting reading, future narration,
offline access, and safe public-domain-inspired adaptations.

## MVP Features

- Story library screen
- Story details screen
- Page-based story reader
- Amharic-first UI
- Firebase Firestore integration
- Cached network images
- Hive story cache and reading progress
- Manifest-based local JSON fallback with Batch 1 story placeholders
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

## Current Architecture

Story loading keeps one simple fallback chain:

1. Firestore
2. Hive cache
3. Local JSON assets from `assets/stories/story_manifest.json`

`StoryRepository` owns the fallback chain. `FirestoreStoryService` reads cloud
stories and pages. `LocalStoryService` reads the local manifest, then loads each
listed story JSON file. Provider remains the app state management approach.

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

## Story Loading And Content

Local story content lives in:

```text
assets/stories/
assets/images/stories/
```

To add a story:

1. Create `assets/stories/story_id.json`.
2. Add complete metadata, pages, audio placeholders, and illustration prompts.
3. Add cover/page images to `assets/images/stories/` or use temporary hosted placeholder URLs.
4. Add `story_id` to `assets/stories/story_manifest.json`.
5. Run `flutter test`.
6. Run the app and open the story from the library.

To update local library ordering, reorder IDs in:

```text
assets/stories/story_manifest.json
```

Current local manifest:

- `little_rabbit`
- `lion_and_mouse`
- `tortoise_and_hare`
- `fox_and_grapes`
- `ant_and_grasshopper`
- `crow_and_pitcher`
- `boy_who_cried_wolf`
- `north_wind_and_sun`
- `dog_and_reflection`
- `goose_golden_eggs`

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

Run on web server:

```bash
flutter run -d web-server
```

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

Build Android release:

```bash
flutter build apk --release
```

## Current Roadmap

Current goal:

- 50-Story Foundation: documentation, upgraded schema, manifest loading, Batch 1 placeholders, and audio-ready metadata/UI.

Next recommended goal:

- Reading progress persistence + Settings screen polish has already landed, so the next practical product step is replacing Batch 1 placeholders with reviewed full Amharic adaptations and final illustrations.
