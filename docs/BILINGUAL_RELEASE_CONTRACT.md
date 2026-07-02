# Bilingual Release Contract

## Supported launch languages

Teret Bet supports Amharic and English as reader-selectable languages. A new
installation asks the family to choose one before opening the library. The
choice is stored in the existing Hive settings box and can be changed later in
Settings.

## Story fallback rules

- Amharic is the canonical fallback for all story content.
- English titles, summaries, morals, and page text are shown only when the
  corresponding English field is present and non-empty.
- Missing optional English fields must never hide a story or crash older local
  JSON, cached Hive, or Firestore records.
- Changing language in the reader keeps the family on the same story page.

## Launch interface rules

- Library, details, reader, and settings controls follow the selected language.
- Story cards and details use English metadata when available, then fall back
  to Amharic.
- Audio is post-launch. Disabled headphones and "coming soon" audio controls
  are not shown in the release interface.

## Verification

- Model tests cover backward compatibility for missing English metadata.
- Provider tests cover persisted language selection.
- Widget tests ensure unfinished audio controls stay absent.
- `flutter analyze`, `flutter test`, catalogue QA, and a web-server launch smoke
  test must pass before this batch is handed off.
