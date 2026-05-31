# Story Content Schema

Teret Bet stories use the same shape in local JSON assets and Firestore. This
keeps the MVP content pipeline simple: write or review a JSON story first, then
copy the story fields and pages into Firestore when ready.

## Local JSON File

Place local fallback stories in `assets/stories/`.

File name:

```text
assets/stories/story_id.json
```

Required story fields:

```json
{
  "id": "story_id",
  "titleAm": "Amharic title",
  "titleEn": "English title",
  "summaryAm": "Short Amharic summary",
  "coverImage": "assets/images/stories/story_id_cover.png",
  "ageMin": 3,
  "ageMax": 6,
  "pages": []
}
```

Required page fields:

```json
{
  "pageNumber": 1,
  "textAm": "Amharic page text",
  "textEn": "Optional English helper text",
  "imageUrl": "assets/images/stories/story_id_cover.png"
}
```

`coverImage` and `imageUrl` may be local asset paths or hosted image URLs. Local
paths should start with `assets/` so the app can load them offline. For bundled
stories, prefer one cover image plus one unique image per story page:

```text
assets/images/stories/story_id_cover.png
assets/images/stories/story_id_page_01.png
assets/images/stories/story_id_page_02.png
```

When a story ID exists in both Firestore/Hive and local JSON, the app keeps the
Firestore/Hive text data but uses the bundled local image paths. This prevents
stale cached placeholder URLs from hiding packaged artwork during MVP testing.

## Firestore Shape

Story document:

```text
stories/{storyId}
```

Fields:

```text
titleAm: string
titleEn: string
summaryAm: string
coverImage: string
ageMin: number
ageMax: number
```

Page documents:

```text
stories/{storyId}/pages/{pageId}
```

Fields:

```text
pageNumber: number
textAm: string
textEn: string
imageUrl: string
```

## Publishing Checklist

1. Add or update the story JSON file in `assets/stories/`.
2. Add local cover and page images in `assets/images/stories/` or confirm hosted URLs are valid.
3. Run `flutter test` to confirm local stories can be discovered and loaded.
4. Copy the story-level fields into `stories/{storyId}` in Firestore.
5. Copy each page into `stories/{storyId}/pages/{pageId}`.
6. Confirm Firestore page documents have increasing `pageNumber` values.
7. Run the app and open the story from the library.
