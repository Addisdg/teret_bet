# Teret Bet / ተረት ቤት

A cross-platform Flutter app for illustrated Amharic children's stories.

## MVP Features

- Story library screen
- Story details screen
- Page-based story reader
- Amharic-first UI
- Firebase Firestore integration
- Cached network images
- Prepared for offline support with Hive

## Tech Stack

- Flutter
- Firebase Firestore
- Provider for state management
- Cached Network Image
- Hive planned for full offline story caching

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
        │   └── services/
        │       └── story_service.dart
        └── presentation/
            ├── providers/
            │   └── story_provider.dart
            ├── screens/
            │   ├── home_screen.dart
            │   ├── story_details_screen.dart
            │   └── story_reader_screen.dart
            └── widgets/
                └── story_card.dart
