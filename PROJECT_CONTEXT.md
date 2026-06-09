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
* Second catalog expansion batch with longer content-driven adaptations and
  page-specific local WebP artwork for:
  * puss_in_boots
  * town_mouse_country_mouse
  * little_red_hen
  * selfish_giant
  * sleeping_beauty
* Follow-up 10-page audit expansion for narrative-heavy stories that still felt
  compressed:
  * jack_and_beanstalk: 14 pages
  * puss_in_boots: 13 pages
  * sleeping_beauty: 12 pages
  * selfish_giant: 12 pages
* First six-page backlog expansion batch:
  * little_rabbit: 10 pages
  * hansel_and_gretel: 11 pages
  * rapunzel: 11 pages
  * bremen_town_musicians: 11 pages
  * snow_white: 11 pages
* Second six-page backlog expansion batch:
  * rumpelstiltskin: 11 pages
  * golden_goose: 11 pages
  * fisherman_and_wife: 11 pages
  * elves_and_shoemaker: 11 pages
  * little_red_cap: 11 pages
* Third six-page backlog expansion batch:
  * wolf_seven_young_kids: 11 pages
  * ugly_duckling: 11 pages
  * emperors_new_clothes: 11 pages
  * thumbelina: 11 pages
  * princess_and_pea: 11 pages
* Fourth six-page backlog expansion batch:
  * snow_queen: 11 pages
  * little_match_girl: 11 pages
  * nightingale: 11 pages
  * fir_tree: 11 pages
  * swineherd: 11 pages
* Fifth six-page backlog expansion batch:
  * steadfast_tin_soldier: 11 pages
  * goldilocks_three_bears: 11 pages
  * gingerbread_man: 11 pages
  * happy_prince: 11 pages
  * anansi_and_turtle: 11 pages
* Final six-page backlog expansion batch:
  * anansi_pot_beans: 11 pages
  * sun_moon_sky: 11 pages
  * monkey_and_shark: 11 pages
  * clever_rabbit_lion: 11 pages
  * magic_porridge_pot: 11 pages
  * cinderella: 11 pages
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
shape. Ten pages is not an upper limit; longer stories should continue beyond it
when the narrative needs more room. Add matching page-specific local WebP art
for every new page.

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

Current content priority: re-audit the full 50-story catalog by reading flow,
age fit, Amharic wording, and illustration match. The documented six-page
backlog has been expanded.

Latest committed content expansion: `089abbc Expand fifth six-page story batch`.
After the current final six-page expansion pass, `dart run tool/catalog_qa.dart`,
`flutter analyze`, `flutter test`, and a web-server launch smoke check all
passed.

When continuing expansion, decide the page count by reading flow. Add pages only
where the story needs more setup, transition, emotional beat, or resolution.
Every added page must have a matching local 1200 x 900 WebP image and the JSON
page numbers must remain sequential.

There are no manifest stories left in the documented six-page backlog after the
latest pass. Continue future content work in focused review batches so story
text, images, visual review, and QA can stay reliable.

## Long-Term Goals

* Audio narration
* Language switching
* Story downloads
* Parent settings
* Analytics
* Monetization
* Publishing
