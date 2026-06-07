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
* Firebase API keys provided with `--dart-define`, not committed

Offline:

* Hive local cache

Platforms:

* Android (primary)
* Web (development/testing)
* iOS (future)

Android release identity:

* Package: `com.teretbet.app`
* Launcher label: `Teret Bet`

## Current Status

Implemented:

* Firebase integration
* Firestore story loading
* Local JSON fallback
* Hive caching
* Manifest-based local JSON story assets
* Story library screen
* Story details screen
* Page-based story reader
* Reading progress UI
* Reading progress persistence
* Favorite stories with local persistence and a library favorites filter
* Library search across Amharic titles, English titles, summaries, collections,
  and themes
* Settings screen with font size control
* Local cover illustrations
* Unique cover-style local per-page illustrations for all current manifest stories
* Local generated cover illustrations for all current manifest stories
* Optimized WebP story assets
* Story content schema documentation
* 50-story local story manifest
* Feedback-ready Amharic adaptations for all current manifest stories
* First catalog expansion batch with longer content-driven adaptations and
  page-specific local WebP artwork for:
  * three_billy_goats_gruff
  * name_of_tree
  * chicken_little
  * jack_and_beanstalk
  * stone_soup
* Audio-ready metadata and UI placeholders
* 50-story foundation documentation
* Android release identity: `com.teretbet.app` with launcher label `Teret Bet`
* Android release signing hook for ignored local/CI keystore secrets
* Web, iOS, and macOS display metadata configured with the Teret Bet name
* Branded launcher icons for Android, iOS, macOS, and web

Current local library manifest:

* little_rabbit
* lion_and_mouse
* tortoise_and_hare
* fox_and_grapes
* ant_and_grasshopper
* crow_and_pitcher
* boy_who_cried_wolf
* north_wind_and_sun
* dog_and_reflection
* goose_golden_eggs
* hansel_and_gretel
* rapunzel
* bremen_town_musicians
* snow_white
* rumpelstiltskin
* golden_goose
* fisherman_and_wife
* elves_and_shoemaker
* little_red_cap
* wolf_seven_young_kids
* ugly_duckling
* emperors_new_clothes
* thumbelina
* princess_and_pea
* snow_queen
* little_match_girl
* nightingale
* fir_tree
* swineherd
* steadfast_tin_soldier
* goldilocks_three_bears
* jack_and_beanstalk
* stone_soup
* three_billy_goats_gruff
* chicken_little
* little_red_hen
* gingerbread_man
* town_mouse_country_mouse
* selfish_giant
* happy_prince
* anansi_and_turtle
* anansi_pot_beans
* sun_moon_sky
* name_of_tree
* monkey_and_shark
* clever_rabbit_lion
* magic_porridge_pot
* puss_in_boots
* cinderella
* sleeping_beauty

All 50 manifest stories have bundled local cover/page artwork and do not depend
on placeholder image URLs.

Additional finished local stories currently kept as assets but not listed in
the 50-story manifest:

* brave_tortoise
* little_seed

Story content is stored in:

assets/stories/

Local story images are stored in:

assets/images/stories/

All current manifest stories reference local image assets. Each reader page uses
a unique bundled WebP image path so stories do not repeat the same picture across
pages.

Story length is content-driven. Do not force stories into a six-page or ten-page
shape. Use as many pages as the story needs, and add matching page-specific
local WebP art for every new page.

Firestore structure:

stories/{storyId}
stories/{storyId}/pages/{pageId}

## Design Principles

* Child-friendly
* Minimal UI
* Large Amharic text
* Illustration-first experience
* Offline-first architecture
* Simple local personalization before account features
* Easy content management

## Current Content Pipeline

Story loading keeps this priority order:

1. Firestore
2. Hive cache
3. Local JSON assets

`StoryRepository` owns the fallback chain. `FirestoreStoryService` reads cloud
content, and `LocalStoryService` reads story IDs from
`assets/stories/story_manifest.json` before loading each local JSON story.
During MVP review, Firestore and Hive results are supplemented with any missing
local manifest stories so the full bundled catalog remains visible in the app.

Current expansion priority: continue expanding the remaining very short six-page
stories, starting with `puss_in_boots`, `town_mouse_country_mouse`,
`little_red_hen`, `selfish_giant`, and `sleeping_beauty`.

## Long-Term Goals

* Audio narration
* Language switching
* Story downloads
* Parent settings
* Analytics
* Monetization
* Publishing
