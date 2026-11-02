# Teret Bet Wiki

## Overview

Teret Bet is an Android-first illustrated story library for Ethiopian children ages 3-6 and the adults who read with them. The app aims to make reading warm, calm, and offline-friendly, with launch support for Amharic and English. The project is intentionally simple and beginner-friendly: Flutter + Provider, Firestore for cloud content, Hive for local caching, and bundled JSON/WebP assets for fully offline use.

## Mission

The product mission is to create a safe, culturally careful digital story library that supports shared reading at home. The app should feel gentle and readable for young children while giving parents and caregivers an easy way to continue stories, save favorites, and keep the experience usable without internet access.

## Audience and product goals

- Primary audience: Ethiopian children ages 3-6
- Reading context: usually with an adult or caregiver
- Launch languages: Amharic and English
- Experience goals: warm, calm, easy to navigate, offline-capable, and safe for young readers
- Core reading modes: story library, story detail view, and page-based reader

## Current architecture

The app follows a straightforward layered architecture that keeps state management and feature structure easy to understand.

### Data source priority

The project preserves a clear fallback chain:

1. Firestore
2. Hive cache
3. Bundled local JSON assets

This pattern is implemented in the story repository so the app can load fresh cloud data when available, fall back to on-device cache, and finally use bundled story data for offline reliability.

### State management and structure

- App uses Flutter
- State management uses Provider
- Feature structure remains under `lib/features/stories/`
- Services and repositories are intentionally small and readable
- No Riverpod, Bloc, or heavy abstraction layers are introduced

## Project structure

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

## Core features

The app includes or plans the following capabilities:

- Story library screen
- Story details screen
- Page-based story reader
- Favorites and local persistence
- Reader font size controls
- Search and filtering
- Continue reading and recently read support
- Settings screen
- Offline-first story loading
- Android-first packaging and launcher configuration

## Content and editorial rules

A major part of the project is the editorial quality bar. The repository explicitly states that the app is not release-ready based on technical checks alone. Stories must pass editorial, cultural, visual, offline, and technical gates.

Key constraints include:

- Amharic and English are independent natural adaptations
- Content should be warm and age-appropriate for 3-6 year olds
- Story page count is content-driven, not fixed to a target number
- One clear story beat should be kept per page
- Original retellings should avoid copying modern copyrighted text or artwork
- Provenance and rights status should be recorded for stories and images
- Conflict should remain soft and safe

## Content workflow

The project has a strong review-first workflow for story creation:

- Draft text and provenance preparation happen before final illustration work
- Stories are reviewed in batches
- Existing draft folders are treated as review artifacts, not live catalogue content
- Final artwork should match locked story text and page beats
- Approval is required before a story is treated as release-ready

## Assets and catalog model

The project stores local story assets in:

- `assets/stories/`
- `assets/images/stories/`

It also includes a manifest system to define local catalogue entries. This makes the offline bundle robust and keeps the app usable without connected network access or Firestore availability.

## Offline and release expectations

This project is designed around a strong offline experience after installation. The product definition requires that the app be completely usable offline from the first-run experience onward. Release-sensitive work must verify:

- Airplane-mode first launch behavior
- Both languages
- Portrait and landscape viewing
- Scalable text support
- Semantics, contrast, and touch targets
- Android build quality and performance

## Quality gates

For meaningful implementation work, the repo expects validation with:

- `dart run tool/catalog_qa.dart`
- `flutter analyze`
- `flutter test`
- an app launch smoke check

Release-sensitive changes also need deeper verification, including device flow and signed Android build checks.

## Current state

The project is in a documentation-and-catalogue review phase with emphasis on:

- product definition and quality gates
- story review batches
- cultural and editorial validation
- local asset quality and offline correctness
- preparing for safe release testing

The README and project docs make it clear that the bundled catalogue is technically functional but not automatically editorially approved. Human review remains a required gate for launch readiness.

## Key references

This project is documented across several key files:

- `README.md`
- `ARCHITECTURE.md`
- `PROJECT_CONTEXT.md`
- `CURRENT_GOAL.md`
- `ROADMAP.md`
- `docs/PRODUCT_DEFINITION.md`
- `docs/EDITORIAL_STYLE_GUIDE.md`
- `docs/FIVE_STORY_BATCH_WORKFLOW.md`
- `docs/STORY_STATUS_BOARD.md`
- `docs/DECISION_LOG.md`

## Summary

Teret Bet is a child-first story app built for Amharic and English reading in an Ethiopian context. It combines Flutter, local caching, Firebase-backed content, and bundled offline storytelling assets to create a calm, scalable reading experience. The project’s strongest emphasis is not just technical build quality, but cultural care, content review, and reliable offline behavior before release.

---

This page was created as a project overview for the repository wiki and summarizes the app architecture, product goals, editorial workflow, and release quality gates based on the current repository documents.
