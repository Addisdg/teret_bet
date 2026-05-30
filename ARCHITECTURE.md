# Architecture

## Folder Structure

lib/

features/
└── stories/
├── data/
│   ├── models/
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

StoryService implements this fallback chain.

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

## Future Additions

* Repository layer
* Audio service
* Download manager
* Story categories
* Favorites
* Reading progress persistence
