# Product Definition and Release Criteria

## Promise

Teret Bet is a free, Android-first library of illustrated Amharic and English
stories for Ethiopian children ages 3-6 and their families. It supports playful
daytime discovery and calm shared bedtime reading without accounts, ads, or an
initial network connection.

## Version 1 scope

- Exactly 50 release-quality stories, including at least 10 of Ethiopian origin.
- Natural Amharic and English, displayed one language at a time.
- First-launch language choice and same-page language switching.
- Discover, Favourites, and Settings navigation.
- Search, overlapping age filters (3-4 and 5-6), theme filters, Continue
  Reading, and the latest 20 Recently Read stories.
- Swipe and button navigation in portrait and landscape.
- Manual persistent bedtime mode.
- On-device favourites, language, settings, history, and reading position.
- Complete bundled text and illustrations available on first airplane-mode
  launch.

Audio, accounts, analytics, crash-reporting SDKs, advertising, purchases, and
catalogue growth beyond 50 are out of scope for version 1. Audio-ready metadata
may remain, but unfinished controls must not appear as working features.

## Story release gate

A story is release-ready only when all evidence is recorded:

1. Provenance and adaptation rights confirmed.
2. Natural Amharic adaptation approved.
3. Natural English adaptation approved.
4. Parent read-aloud test approved.
5. Age 3-6 suitability and cultural review approved.
6. Page-by-page continuity approved.
7. Text explicitly locked before final illustration work.
8. Characters and complete image set visually approved.
9. Offline, accessibility, schema, and app QA passed.

Story length is content-driven. There is no minimum target shape and no upper
page limit. Add a page whenever a narrative beat feels compressed; create a new
matching illustration whenever reused art would weaken continuity.

## Product release gate

- All 50 stories have status `Release ready`.
- The Firestore -> Hive -> bundled JSON chain remains intact.
- A clean installation works completely in airplane mode before first online
  use.
- Pixel 8a, small-phone, older-supported-Android, and 10-inch-tablet checks pass.
- App is usable within 3 seconds on Pixel 8a and page turns show no blank frame.
- Download-size target is below 100 MB when achievable without damaging art.
- Scaled text does not clip; controls have semantics, adequate contrast, and
  large touch targets; gestures always have visible alternatives.
- Signed AAB, Play Families declarations, privacy policy, store listing,
  support email, and public website are ready.
- Closed-test feedback has no unresolved release blocker.

Technical completion never substitutes for editorial approval.
