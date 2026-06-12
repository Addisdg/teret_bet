# Current Goal

Near-release MVP hardening: make the Android build identifiable as Teret Bet,
keep the bundled 50-story catalog feedback-ready, and remove release blockers
before external testing.

## Completed

* Content strategy documentation
* First 50 story candidate list
* Story adaptation guidelines
* Audio roadmap
* Design inspiration notes
* Content review checklist
* Upgraded story schema
* Manifest-based local story loading
* Firestore -> Hive cache -> local JSON fallback chain
* Batch 1 local story manifest
* Feedback-ready Amharic adaptations for all current manifest stories
* Batch 2 Grimm-inspired Amharic stories added with bundled local cover/page artwork
* Batch 3 Andersen-inspired Amharic stories added with bundled local cover/page artwork
* Batch 4 world classic and folktale Amharic stories added with bundled local cover/page artwork
* Batch 5 African folktale and world classic Amharic stories added with bundled local cover/page artwork
* Audio-ready metadata and UI placeholders
* Reading progress persistence
* Favorite stories with local persistence and library filtering
* Settings screen with reader font-size control
* Local cover illustrations for all current manifest stories
* Unique cover-style local page illustrations for all current manifest stories
* Placeholder image URLs removed from the current manifest catalog
* Android app ID and launcher label prepared for release builds
* Android release signing hook prepared for ignored local/CI keystore secrets
* Web, iOS, and macOS display metadata prepared with the Teret Bet name
* Branded launcher icons prepared for Android, iOS, macOS, and web
* Library search added for Amharic titles, English titles, summaries,
  collections, and themes
* Local Android release smoke build passes without Firebase/signing secrets,
  using debug signing fallback for the generated APK
* First story expansion batch completed with page-specific local artwork:
  `three_billy_goats_gruff`, `name_of_tree`, `chicken_little`,
  `jack_and_beanstalk`, and `stone_soup`
* Second story expansion batch completed with page-specific local artwork:
  `puss_in_boots`, `town_mouse_country_mouse`, `little_red_hen`,
  `selfish_giant`, and `sleeping_beauty`
* Story-length audit completed for 10-page stories. Narrative-heavy stories
  that still felt compressed were expanded beyond 10 pages with matching local
  artwork:
  `jack_and_beanstalk`, `puss_in_boots`, `sleeping_beauty`, and
  `selfish_giant`
* Six-page story expansion pass started. The first short-story batch was
  expanded with matching local artwork:
  `little_rabbit`, `hansel_and_gretel`, `rapunzel`,
  `bremen_town_musicians`, and `snow_white`
* Second six-page backlog batch expanded with matching local artwork:
  `rumpelstiltskin`, `golden_goose`, `fisherman_and_wife`,
  `elves_and_shoemaker`, and `little_red_cap`
* Third six-page backlog batch expanded with matching local artwork:
  `wolf_seven_young_kids`, `ugly_duckling`, `emperors_new_clothes`,
  `thumbelina`, and `princess_and_pea`
* Fourth six-page backlog batch expanded with matching local artwork:
  `snow_queen`, `little_match_girl`, `nightingale`, `fir_tree`, and
  `swineherd`
* Fifth six-page backlog batch expanded with matching local artwork:
  `steadfast_tin_soldier`, `goldilocks_three_bears`, `gingerbread_man`,
  `happy_prince`, and `anansi_and_turtle`
* Final six-page backlog batch expanded with matching local artwork:
  `anansi_pot_beans`, `sun_moon_sky`, `monkey_and_shark`,
  `clever_rabbit_lion`, `magic_porridge_pot`, and `cinderella`
* Tests and catalog QA now allow stories to grow beyond fixed page counts; story
  length is content-driven with no hard upper page limit
* First full-catalog flow review pass started. Early-ending expansion artifacts
  were smoothed into bridge pages for:
  `little_rabbit`, `hansel_and_gretel`, `rapunzel`, `snow_white`,
  `ugly_duckling`, `nightingale`, `fir_tree`, `golden_goose`,
  `goldilocks_three_bears`, `sun_moon_sky`, `rumpelstiltskin`, and
  `elves_and_shoemaker`
* Second full-catalog flow review pass completed. Additional early-ending and
  duplicated resolution beats were smoothed into bridge pages for:
  `bremen_town_musicians`, `fisherman_and_wife`, `little_red_cap`,
  `wolf_seven_young_kids`, `emperors_new_clothes`, `thumbelina`,
  `princess_and_pea`, `snow_queen`, `anansi_and_turtle`,
  `anansi_pot_beans`, `cinderella`, `magic_porridge_pot`,
  `monkey_and_shark`, `steadfast_tin_soldier`, and `swineherd`
* Third full-catalog flow review pass completed across the remaining manifest
  stories. Most remaining stories already read cleanly; final bridge-page
  polish was applied to:
  `little_match_girl`, `gingerbread_man`, `happy_prince`, and
  `clever_rabbit_lion`
* Strict story-order consistency pass completed for expanded stories with
  old-short-version artifacts still interleaved into the page flow:
  `anansi_and_turtle`, `anansi_pot_beans`, `sun_moon_sky`,
  `magic_porridge_pot`, and `cinderella`
* Duplicate mini-ending review pass completed for stories where expanded pages
  still repeated a lesson/resolution beat before the final page:
  `little_rabbit`, `selfish_giant`, `clever_rabbit_lion`,
  `monkey_and_shark`, `wolf_seven_young_kids`, `princess_and_pea`,
  `gingerbread_man`, and `nightingale`
* Matching page artwork refreshed for the duplicate mini-ending review pass so
  revised story beats and bundled WebP assets stay aligned:
  `little_rabbit_page_06`, `selfish_giant_page_04`,
  `clever_rabbit_lion_page_05`, `monkey_and_shark_page_04`,
  `wolf_seven_young_kids_page_06`, `princess_and_pea_page_05`,
  `gingerbread_man_page_04`, `gingerbread_man_page_07`,
  `gingerbread_man_page_08`, `gingerbread_man_page_09`,
  `nightingale_page_05`, and `nightingale_page_06`
* Matching page artwork refreshed for the strict story-order consistency pass:
  `anansi_and_turtle_page_04` through `page_10`,
  `anansi_pot_beans_page_04` through `page_06`,
  `magic_porridge_pot_page_05` and `page_06`,
  `sun_moon_sky_page_04` through `page_06`, and
  `cinderella_page_05`, `page_06`, `page_08`, `page_09`, and `page_10`
* Catalog QA now validates bundled story image format and dimensions so every
  manifest cover/page asset stays as a readable 1200 x 900 WebP file

## Current Release Identity

* Android package: `com.teretbet.app`
* Android launcher label: `Teret Bet`
* Version: `1.0.0+1`

## Latest Validation

Latest committed asset refresh:

* `3b23935 Refresh artwork for strict story order pass`

Quality gates passed after the story image QA hardening:

* `dart run tool/catalog_qa.dart`
* `flutter analyze`
* `flutter test`
* `timeout 90s flutter run -d web-server --web-port 0`

The smoke run served the app locally before timeout.

## Next Recommended Task

Continue catalog review before broad feedback review. The documented six-page
backlog has now been expanded; the current priority is to re-audit the full
50-story catalog by reading flow, age fit, Amharic wording, and illustration
match. Keep using as many pages as each story needs if any longer story still
feels compressed.

After each expansion batch, run `dart run tool/catalog_qa.dart`,
`flutter analyze`, and `flutter test`. Use the library search, collection
filters, and favorites filter to review by collection, theme, and story title
during feedback sessions.

Release signing also remains before external Android testing: create release
signing credentials outside the repository, add the matching local/CI secret
values, then run:

```bash
flutter analyze
flutter test
flutter build apk --release --dart-define=FIREBASE_ANDROID_API_KEY=your_android_key
```

Before a Firestore-backed external test, register `com.teretbet.app` in Firebase
and apply Android API key restrictions for the release signing certificate.
