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
- Manifest-based local JSON fallback with a feedback-ready 50-story catalog
- Optimized bundled WebP cover illustrations for the full manifest catalog
- Unique cover-style bundled WebP page illustrations for the full manifest catalog
- Settings screen with reader font size control
- Reader controls for page jumping, text-size changes, and distraction-light
  reading
- Favorite stories with local persistence and a library favorites filter
- Library search across Amharic titles, English titles, summaries,
  collections, and themes
- Audio-ready metadata and placeholder UI
- Android release package and launcher label configured for Teret Bet
- Web, iOS, and macOS display metadata configured with the Teret Bet name
- Branded launcher icons for Android, iOS, macOS, and web

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
listed story JSON file. If Firestore or Hive returns only part of the MVP
catalog, the repository appends missing local manifest stories while keeping
cloud/cache data first for matching story IDs. Provider remains the app state
management approach.

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
- `hansel_and_gretel`
- `rapunzel`
- `bremen_town_musicians`
- `snow_white`
- `rumpelstiltskin`
- `golden_goose`
- `fisherman_and_wife`
- `elves_and_shoemaker`
- `little_red_cap`
- `wolf_seven_young_kids`
- `ugly_duckling`
- `emperors_new_clothes`
- `thumbelina`
- `princess_and_pea`
- `snow_queen`
- `little_match_girl`
- `nightingale`
- `fir_tree`
- `swineherd`
- `steadfast_tin_soldier`
- `goldilocks_three_bears`
- `jack_and_beanstalk`
- `stone_soup`
- `three_billy_goats_gruff`
- `chicken_little`
- `little_red_hen`
- `gingerbread_man`
- `town_mouse_country_mouse`
- `selfish_giant`
- `happy_prince`
- `anansi_and_turtle`
- `anansi_pot_beans`
- `sun_moon_sky`
- `name_of_tree`
- `monkey_and_shark`
- `clever_rabbit_lion`
- `magic_porridge_pot`
- `puss_in_boots`
- `cinderella`
- `sleeping_beauty`

All 50 manifest stories have bundled local cover/page images and do not depend
on placeholder image URLs.

### Catalog Expansion Status

Story length is content-driven. Do not force stories into a six-page or
ten-page shape; use as many pages as each story needs. Every added page must
include matching local WebP artwork and a complete page entry in the story JSON.

Expanded so far:

- `three_billy_goats_gruff`
- `name_of_tree`
- `chicken_little`
- `jack_and_beanstalk`
- `stone_soup`
- `puss_in_boots`
- `town_mouse_country_mouse`
- `little_red_hen`
- `selfish_giant`
- `sleeping_beauty`

Next recommended expansion batch:

- `little_rabbit`
- `hansel_and_gretel`
- `rapunzel`
- `bremen_town_musicians`
- `snow_white`

Story JSON and Firestore fields are documented in
[`docs/story_content_schema.md`](docs/story_content_schema.md).

Firebase API keys are intentionally not committed. Local Firebase runs use
`--dart-define` values; see
[`docs/firebase_configuration.md`](docs/firebase_configuration.md).

Android release builds use package `com.teretbet.app` and launcher label
`Teret Bet`. Release signing can be provided through ignored local/CI keystore
secrets; see [`docs/firebase_configuration.md`](docs/firebase_configuration.md).

The launcher icon source is tracked at
`assets/images/branding/app_icon_source.png`; platform icon sizes are generated
from that source into the standard Flutter Android, iOS, macOS, and web icon
locations.

## Reading Progress And Settings

The reader saves the last opened page for each story in Hive. When the story is
opened again, it starts from that saved page. Readers can move with swipes,
previous/next buttons, or the page slider.

Reader font size is also stored in Hive from the Settings screen. The language
toggle is shown as a disabled placeholder for a future multilingual release.
The reader also includes text-size buttons so parents can adjust the story while
reading.

Favorite story IDs are stored locally in Hive so children and parents can keep a
small personal shelf even when the app is offline. The home library can switch
between all stories and favorite stories.

Stories now include nullable audio metadata. The details and reader screens show
audio placeholders, but playback packages are intentionally deferred.

All current manifest stories use local image assets so web and mobile feedback
builds do not depend on placeholder image URLs. Each story page has its own
cover-style bundled illustration path, so the reader no longer repeats the cover
image or lower-quality temporary panels.

## Local Testing

Run catalog QA before feedback sessions or Firestore upload:

```bash
dart run tool/catalog_qa.dart
```

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

To test against Firebase, add the platform API key at run/build time:

```bash
flutter run -d <device-id> \
  --dart-define=FIREBASE_ANDROID_API_KEY=your_android_key
```

Build a local Android release smoke APK. If `android/key.properties` is missing,
Gradle uses the debug signing fallback documented in
[`docs/firebase_configuration.md`](docs/firebase_configuration.md):

```bash
flutter build apk --release
```

Build a Firebase-backed Android release:

```bash
flutter build apk --release \
  --dart-define=FIREBASE_ANDROID_API_KEY=your_android_key
```

## Current Roadmap

Current goal:

- Near-release MVP hardening: review the full 50-story local library in-app,
  polish story wording and page art from parent/child feedback, and remove
  release blockers before external Android testing.

Next recommended goal:

- Complete full-catalog content QA and illustration QA, prepare release signing
  credentials outside the repository, then upload the reviewed catalog to
  Firestore for external testing.
