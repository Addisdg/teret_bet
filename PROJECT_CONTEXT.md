# Teret Bet Project Context

## Mission and audience

Teret Bet is an Android-first illustrated Amharic and English story library for
Ethiopian children ages 3-6, usually with a parent or caregiver reading aloud.
It should combine playful visual discovery with a quiet bedtime reader and work
completely offline immediately after installation.

## Technical foundation

- Flutter with Provider.
- Firebase Firestore cloud catalogue.
- Hive cache and on-device preferences.
- Bundled JSON and WebP assets.
- Required loading order: Firestore -> Hive -> bundled JSON.
- Android package `com.teretbet.app`, display name `Teret Bet`.
- Current manifest: 50 stories and 521 pages.

Keep the architecture simple, null-safe, backward compatible, and understandable
to a beginner Flutter developer.

## Product direction

- Amharic and English launch together as independent natural adaptations.
- At least 10 launch stories have verified Ethiopian origin.
- Exactly 50 stories remain in the initial catalogue.
- No account, ads, purchases, analytics, or crash SDK at launch.
- On-device favourites, settings, language, reading position, and latest-20
  history.
- Discover, Favourites, and Settings navigation.
- Search, age 3-4/5-6 filters, themes, Continue Reading, and Recently Read.
- Manual bedtime mode; swipe and buttons; portrait and landscape.
- Audio is post-launch. Do not expose unfinished playback controls.

## Editorial truth

The bundled catalogue is a technically functional review corpus, not a released
editorial catalogue. Existing JSON statuses do not prove Amharic accuracy,
natural English, provenance, cultural approval, age fit, flow, or illustration
consistency.

Story length is always content-driven. Never impose six, ten, or any other page
limit. Add pages when setup, transition, emotion, action, or resolution needs
space. Lock the final page sequence before generating a complete consistent
image set, and add a matching image whenever a new page requires one.

Every story must advance through the evidence-based sequence in
`docs/STORY_STATUS_BOARD.md`. Human approval remains required after automated
QA.

## Current priority

Complete and approve the documentation foundation, then run the proposed
five-story pilot. Do not upload the existing 50-story export to production
Firestore until reviewed content is approved.

Primary references:

- `docs/PRODUCT_DEFINITION.md`
- `docs/EDITORIAL_STYLE_GUIDE.md`
- `docs/FIVE_STORY_BATCH_WORKFLOW.md`
- `docs/CONTENT_PROVENANCE_REGISTER.md`
- `docs/ILLUSTRATION_SYSTEM.md`
- `docs/TESTING_AND_RELEASE_CHECKLIST.md`
- `docs/PRIVACY_AND_CONTENT_RIGHTS.md`
- `docs/DECISION_LOG.md`
