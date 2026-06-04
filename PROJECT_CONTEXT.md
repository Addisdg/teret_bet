# Teret Bet / ተረት ቤት

## Purpose

Teret Bet is a cross-platform Flutter application for illustrated Amharic children's stories.

The primary audience is:

* Children aged 3–6
* Parents reading with children

The application should feel like a calm digital storybook.

## Current Tech Stack

Frontend:

* Flutter
* Provider state management

Backend:

* Firebase Firestore
* Firebase API keys provided with `--dart-define`, not committed

Offline:

* Hive local cache

Platforms:

* Android (primary)
* Web (development/testing)
* iOS (future)

## Current Status

Implemented:

* Firebase integration
* Firestore story loading
* Local JSON fallback
* Hive caching
* Manifest-based local JSON story assets
* Story library screen
* Story details screen
* Page-based story reader
* Reading progress UI
* Reading progress persistence
* Settings screen with font size control
* Local cover illustrations
* Unique local per-page illustrations for all current manifest stories
* Local generated cover illustrations for all current manifest stories
* Optimized WebP story assets
* Story content schema documentation
* Batch 1 local story manifest
* Feedback-ready Amharic adaptations for all Batch 1 manifest stories
* Audio-ready metadata and UI placeholders
* 50-story foundation documentation

Current local library manifest:

* little_rabbit
* lion_and_mouse
* tortoise_and_hare
* fox_and_grapes
* ant_and_grasshopper
* crow_and_pitcher
* boy_who_cried_wolf
* north_wind_and_sun
* dog_and_reflection
* goose_golden_eggs

Additional finished local stories currently kept as assets but not listed in
the Batch 1 manifest:

* brave_tortoise
* little_seed

Story content is stored in:

assets/stories/

Local story images are stored in:

assets/images/stories/

All current manifest stories reference local image assets. Each reader page uses
a unique bundled WebP image path so stories do not repeat the same picture across
pages.

Firestore structure:

stories/{storyId}
stories/{storyId}/pages/{pageId}

## Design Principles

* Child-friendly
* Minimal UI
* Large Amharic text
* Illustration-first experience
* Offline-first architecture
* Easy content management

## Current Content Pipeline

Story loading keeps this priority order:

1. Firestore
2. Hive cache
3. Local JSON assets

`StoryRepository` owns the fallback chain. `FirestoreStoryService` reads cloud
content, and `LocalStoryService` reads story IDs from
`assets/stories/story_manifest.json` before loading each local JSON story.
During MVP review, Firestore and Hive results are supplemented with any missing
local manifest stories so the full bundled catalog remains visible in the app.

## Long-Term Goals

* 20+ stories
* Audio narration
* Language switching
* Story downloads
* Favorites
* Parent settings
* Analytics
* Monetization
