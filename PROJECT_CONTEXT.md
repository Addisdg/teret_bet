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
* Multiple local JSON story assets
* Story library screen
* Story details screen
* Page-based story reader
* Reading progress UI
* Reading progress persistence
* Settings screen with font size control
* Local cover illustrations
* Local per-page illustrations
* Optimized WebP story assets
* Story content schema documentation

Current sample story:

* little_rabbit
* brave_tortoise

Story content is stored in:

assets/stories/

Local story images are stored in:

assets/images/stories/

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
content, and `LocalStoryService` reads every JSON file in `assets/stories/` so
new local fallback stories appear in the library automatically.

## Long-Term Goals

* 20+ stories
* Audio narration
* Language switching
* Story downloads
* Favorites
* Parent settings
* Analytics
* Monetization
