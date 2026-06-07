# Story Adaptation Guidelines

## Story Length

Stories for the MVP should be short enough for bedtime reading but long enough
to feel like complete stories instead of summaries:

* At least 6 pages per story for ages 3-6
* Use as many pages as the story needs; do not force a 6-page or 10-page limit
* 1-3 short sentences per page
* One clear action or emotional beat per page
* Simple page endings that invite the child to continue

## Language

Use simple, natural Amharic. The goal is not literal translation. The goal is a
warm Amharic story that a parent can comfortably read aloud.

Prefer:

* Familiar verbs and nouns
* Short sentence structures
* Gentle repetition
* Clear cause and effect
* Warm read-aloud rhythm

Avoid:

* Overly literal English-to-Amharic phrasing
* Long paragraphs
* Abstract moral explanation on every page
* Harsh scolding language

## Adaptation Principles

When adapting public-domain classics:

* Preserve the main moral or emotional theme.
* Create original Amharic wording.
* Shorten plots for page-based reading.
* Soften violence, abandonment, punishment, and scary details.
* Avoid outdated stereotypes.
* Avoid making any culture, body type, disability, gender, class, or region the joke.
* Include repeated phrases where useful for early literacy.
* Keep the ending emotionally safe for ages 3-6.

## Repeated Phrases

Repeated phrases help children anticipate and join the story. Use one short
phrase that can appear two or three times, such as:

* "በቀስታ በቀስታ..."
* "እንደገና ሞከረ።"
* "ጓደኛዬ፣ እረዳሃለሁ።"

Repetition should feel musical, not mechanical.

## Required Metadata

Future story JSON and Firestore documents should support these fields:

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
  "pages": [
    {
      "pageNumber": 1,
      "textAm": "",
      "textEn": "",
      "imageUrl": "",
      "illustrationPrompt": "",
      "audioUrl": null
    }
  ]
}
```

Optional fields must remain backward compatible so older JSON and Firestore data
continue to load.
