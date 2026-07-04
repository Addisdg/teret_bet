# App Technical Baseline Audit

Date: 2026-07-03  
Branch: `codex/app-baseline-audit`

This audit records the current app before product-shell implementation. It does
not change application code, content, dependencies, Firebase, or assets.

## Validation evidence

| Check | Result |
| --- | --- |
| `flutter analyze` | Pass; no issues, 8.5 seconds |
| `flutter test` | Pass; 30 tests |
| `dart run tool/catalog_qa.dart` | Pass; 0 errors, 0 warnings |
| Web-server smoke launch | Pass; `lib/main.dart` served locally |
| Connected Flutter devices | WSL Linux desktop only |
| Pixel 8a / Android emulator | Not visible in this session |

The web-server's approximately 54-second first debug compilation is not a user
startup measurement and must not be compared with the 3-second Pixel 8a goal.

## What is already sound

- Firestore -> Hive cache -> bundled JSON order is implemented in
  `StoryRepository` and covered by fallback tests.
- Bundled local stories and images keep a complete 50-story corpus available.
- Reading position, favourites, and reader font size persist in Hive.
- Catalogue image existence, format, dimensions, and page order pass QA.
- The library grid adapts its column count at wider widths.
- Reader pages support swipe, visible previous/next buttons, page jumping, and
  adjustable text size.

These are technical foundations, not proof of release usability or editorial
readiness.

## Confirmed release gaps

### P0 — Launch-language contract is not implemented

- The app has no first-launch language choice, locale state, or same-page
  language switching.
- Screens always render Amharic fields and hard-coded Amharic controls.
- Models do not yet parse `summaryEn` or `moralEn`.
- English story pages exist but are never selected in the reader.
- Search cannot use an English summary because that field does not exist.

### P0 — Unfinished audio is presented in the interface

- Story details display `ድምፅ በቅርቡ` when audio is absent.
- The reader displays a disabled headphone button.
- A widget test explicitly requires the stale “coming soon” behavior.

Remove these controls and update the test before release. Nullable audio data may
remain for post-launch work.

### P0 — Required discovery and history behavior is missing

- No Discover/Favourites/Settings primary navigation.
- Favourites are a segmented library filter, not a destination.
- No Continue Reading section.
- No latest-20 Recently Read list, timestamps, completion state, or clear-history
  action.
- No overlapping age 3-4/5-6 filters.
- No theme filters; only collection filters exist.

### P0 — Accessibility evidence is absent

- No explicit `Semantics` widgets or accessibility guideline tests were found.
- Only two of 30 tests are widget tests; neither covers the reader, library,
  settings, navigation, text scaling, contrast, focus order, or orientation.
- Several tooltips are English while the visible app is Amharic-only.
- The controls-hidden tap gesture has no explicit semantic description.

Built-in Material semantics may help, but release evidence is still required.

### P0 — Reader layout is likely cramped in landscape and large text

- Reader content always uses a vertical 5:3 image/text split.
- Text lives in a nested scroll area with fixed 20-pixel padding and 24-pixel
  spacing.
- The control panel always stacks toolbar, slider, and two large buttons.
- There is no orientation-specific or short-height layout.

This is a source-confirmed responsiveness gap; exact clipping and usability must
still be tested on Pixel 8a and emulator sizes.

### P1 — First offline launch may wait on unavailable cloud calls

- `main()` waits for Firebase initialization before `runApp()`.
- Story and page loading await Firestore before reading Hive or bundled JSON.
- No explicit short timeout or immediate bundled-first presentation is visible.

The fallback order must remain Firestore -> Hive -> bundled JSON, but the UI
needs measured behavior so airplane mode does not leave a child staring at a
spinner while a network call expires.

### Resolved — Typeface configuration

The theme's `NotoSansEthiopic` family is now backed by the official Google Fonts
variable asset bundled in `pubspec.yaml`. Regular, medium, and bold application
weights resolve to the same variable file, so Amharic rendering no longer
depends on an Android platform fallback.

### P1 — Release size exceeds the provisional target

- Bundled assets: approximately 125 MB.
- Story images: 585 files, 127,113,070 bytes total; approximately 217 KB each.
- Existing APK: 180,528,531 bytes.
- Existing AAB: 180,089,688 bytes.

The APK/AAB artifacts predate this audit and were not rebuilt today, but they
show that the current package is roughly 80 MB above the provisional 100 MB
target. Do not reduce image quality until Play-delivery size and asset breakdown
are measured from a fresh release build.

### P1 — Provenance is not visible in the product

The model contains only a minimal `StorySource`, and the details screen does not
display source, origin, adaptation basis, cultural context, or review evidence.
The approved child-facing origin label and parent “About this story” section are
not implemented.

### P2 — Current visual system is a placeholder baseline

- Theme uses one teal seed colour rather than the approved warm palette.
- No manual bedtime mode or persisted theme selection.
- Library opens as a dense search/filter/grid screen rather than visual
  discovery shelves.
- No reusable design tokens for spacing, shape, type, or daytime/bedtime colour.

## Recommended implementation sequence

### Batch A — Release-contract foundation

1. Add backward-compatible language fields and persistent language state.
2. Implement first-launch choice and same-page switching.
3. Remove unfinished audio UI and stale tests.
4. Add origin/about metadata shape without filling unapproved catalogue data.
5. Add unit/widget tests for language persistence and backward compatibility.

### Batch B — Reader responsiveness and accessibility

1. Create short-height/landscape reader layouts.
2. Ensure text scaling never clips and controls remain reachable.
3. Add semantics, focus/traversal checks, and visible alternatives to gestures.
4. Add Flutter accessibility-guideline widget tests.
5. Validate daytime and bedtime contrast on actual screens.

### Batch C — Discovery and local history

1. Add Discover/Favourites/Settings navigation.
2. Add Continue Reading and latest-20 Recently Read.
3. Add clear-history action.
4. Add age-band and theme filters.
5. Keep all personal state local in Hive.

### Batch D — Visual system and performance

1. Prototype the warm palette and approved typography on real devices.
2. Add manual persistent bedtime mode.
3. Measure Firebase/offline startup and add bounded cloud waits if needed while
   preserving repository priority.
4. Build a fresh release AAB with size analysis.
5. Optimise only assets proven to dominate delivered size.

## Next approval recommendation

Begin Batch A with the smallest coherent change: backward-compatible language
state plus removal of unfinished audio UI. Keep story drafts outside the live
catalogue until family review and text lock.
