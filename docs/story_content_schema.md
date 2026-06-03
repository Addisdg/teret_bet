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

Add the story ID to the local manifest so it appears in the library:

```text
assets/stories/story_manifest.json
```

The manifest is an ordered JSON list of story IDs:

```json
[
  "little_rabbit",
  "lion_and_mouse"
]
```

Required story fields:

```json
{
  "id": "story_id",
  "collection": "aesop",
  "status": "draft",
  "priority": 1,
  "titleAm": "Amharic title",
  "titleEn": "English title",
  "summaryAm": "Short Amharic summary",
  "moralAm": "Short Amharic moral",
  "source": {
    "type": "public_domain",
    "name": "Source collection",
    "sourceUrl": "",
    "notes": "Create original Amharic adaptation."
  },
  "ageMin": 3,
  "ageMax": 6,
  "themes": ["kindness", "helping"],
  "coverImage": "assets/images/stories/story_id_cover.webp",
  "audio": {
    "storyAudioUrl": null,
    "durationSeconds": null,
    "narratorName": null
  },
  "pages": []
}
```

Required page fields:

```json
{
  "pageNumber": 1,
  "textAm": "Amharic page text",
  "textEn": "Optional English helper text",
  "imageUrl": "assets/images/stories/story_id_page_01.webp",
  "illustrationPrompt": "Short prompt for future image generation",
  "audioUrl": null
}
```

New metadata fields are optional in Dart parsing so older Firestore documents,
Hive cache entries, and local JSON files continue to load. New content should
include the full schema so future audio, review, and collection workflows have
the data they need.

`coverImage` and `imageUrl` may be local asset paths or hosted image URLs. Local
paths should start with `assets/` so the app can load them offline. For bundled
stories, prefer optimized WebP assets with one cover image plus one unique image
per story page:

```text
assets/images/stories/story_id_cover.webp
assets/images/stories/story_id_page_01.webp
assets/images/stories/story_id_page_02.webp
```

When a story ID exists in both Firestore/Hive and local JSON, the app keeps the
Firestore/Hive text data but uses the bundled local image paths. This prevents
stale cached placeholder URLs from hiding packaged artwork during MVP testing.

## Illustration Style

Bundled story covers should be readable in the library grid, where they appear
as small thumbnails. Prefer:

* Large, friendly main characters
* Clear story action in the center of the image
* Warm natural colors and soft children's-book lighting
* No text inside the image, because titles are rendered by Flutter
* Optimized WebP files under about 500 KB each

The current cover set uses 1200 x 900 WebP images so the same asset works well
on mobile, desktop, and web during MVP testing.

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
moralAm: string
collection: string
status: string
priority: number
source: map
themes: array
coverImage: string
ageMin: number
ageMax: number
audio: map
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
illustrationPrompt: string
audioUrl: string | null
```

## Publishing Checklist

1. Add or update the story JSON file in `assets/stories/`.
2. Add the story ID to `assets/stories/story_manifest.json`.
3. Add local cover and page images in `assets/images/stories/` or confirm hosted URLs are valid.
4. Run `flutter test` to confirm local stories can be discovered and loaded.
5. Copy the story-level fields into `stories/{storyId}` in Firestore.
6. Copy each page into `stories/{storyId}/pages/{pageId}`.
7. Confirm Firestore page documents have increasing `pageNumber` values.
8. Run the app and open the story from the library.
