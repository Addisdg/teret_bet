# Architecture

## Folder Structure

lib/

features/
└── stories/
├── data/
│   ├── models/
│   ├── repositories/
│   └── services/
├── presentation/
│   ├── providers/
│   ├── screens/
│   └── widgets/

## Data Sources

Priority order:

1. Firestore
2. Hive cache
3. Local JSON assets

StoryRepository implements this fallback chain.

Source-specific services stay small:

* FirestoreStoryService reads Firestore stories and pages.
* LocalStoryService reads JSON files from assets/stories/.

Hive is used by StoryRepository for:

* Cached story lists
* Cached story pages
* Last read page per story

The SettingsProvider uses a separate Hive settings box for reader preferences.

## Story Data Model

Story:

* id
* titleAm
* titleEn
* summaryAm
* coverImage
* ageMin
* ageMax

StoryPage:

* pageNumber
* textAm
* textEn
* imageUrl

Local story images live in assets/images/stories/. The UI accepts both local
asset paths and hosted image URLs, so Firestore can keep using remote images
while the bundled JSON fallback works offline.

## Future Additions

* Audio service
* Download manager
* Story categories
* Favorites
* Full language switching
