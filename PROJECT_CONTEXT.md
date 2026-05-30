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
* Story library screen
* Story details screen
* Page-based story reader
* Reading progress UI

Current sample story:

* little_rabbit

Story content is stored in:

assets/stories/

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

## Long-Term Goals

* 20+ stories
* Audio narration
* Language switching
* Story downloads
* Favorites
* Parent settings
* Analytics
* Monetization
