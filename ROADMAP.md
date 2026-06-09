# Roadmap

## Completed

* Flutter setup
* Firebase setup
* Firestore integration
* Local JSON fallback
* Hive caching
* First story
* Multiple local JSON stories
* Reading progress persistence
* Settings screen with font size control
* StoryRepository, FirestoreStoryService, and LocalStoryService split
* Local story cover illustrations
* Local per-page story illustrations
* Optimized bundled WebP story assets
* Story content schema documentation
* More polished reader controls
* Better illustrations
* More local story content
* 50-story foundation documentation
* Story schema upgrade for content roadmap
* Manifest-based 50-story local catalog
* Audio-ready UI placeholders
* First Batch 1 story adaptation: lion_and_mouse
* Second Batch 1 story adaptation: tortoise_and_hare
* Third Batch 1 story adaptation: fox_and_grapes
* Fourth Batch 1 story adaptation: ant_and_grasshopper
* Fifth Batch 1 story adaptation: crow_and_pitcher
* Sixth Batch 1 story adaptation: boy_who_cried_wolf
* Seventh Batch 1 story adaptation: north_wind_and_sun
* Eighth Batch 1 story adaptation: dog_and_reflection
* Ninth Batch 1 story adaptation: goose_golden_eggs
* Feedback-ready local MVP catalog
* Local cover illustrations for all current manifest stories
* Removed placeholder image URLs from local story JSON
* Cover-style local page illustrations for all current manifest stories
* Favorite stories with local persistence and library filtering
* Library search for Amharic titles, English titles, summaries, collections,
  and themes
* First catalog expansion batch with longer adaptations and page-specific local
  artwork
* Second catalog expansion batch with longer adaptations and page-specific local
  artwork
* Expanded selected narrative-heavy stories beyond 10 pages after story-length
  review
* First six-page backlog batch expanded with matching page-specific local art
* Second six-page backlog batch expanded with matching page-specific local art
* Third six-page backlog batch expanded with matching page-specific local art
* Fourth six-page backlog batch expanded with matching page-specific local art
* Fifth six-page backlog batch expanded with matching page-specific local art

## Next

### Phase 1

* Continue expanding very short stories without a fixed upper page limit
* Re-audit expanded stories by reading flow, not page count
* Add matching page-specific local WebP art for every new page
* Final short-story expansion batch: `anansi_pot_beans`, `sun_moon_sky`,
  `monkey_and_shark`, `clever_rabbit_lion`, `magic_porridge_pot`, and
  `cinderella`
* For each expansion batch, run `dart run tool/catalog_qa.dart`,
  `flutter analyze`, `flutter test`, and a launch smoke check
* Review full 50-story wording with parent/child feedback
* Polish story wording and page art based on feedback
* Resolve any final launch-blocking UI issues found during catalog review
* Upload reviewed 50-story catalog to Firestore
* Prepare Android release signing credentials outside the repository

### Phase 2

* Audio narration
* Language toggle

### Phase 3

* Downloads
* Parent dashboard
* Analytics

### Phase 4

* Monetization
* Publishing
