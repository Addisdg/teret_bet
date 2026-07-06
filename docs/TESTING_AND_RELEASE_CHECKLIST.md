# Testing and Release Checklist

## Every integrated story batch

- [ ] Run `python3 tool/verify_pilot_review_packet.py` before distributing a
      pilot review bundle; never refresh a frozen revision checksum silently.
- [ ] Page numbers are sequential; length follows narrative flow.
- [ ] Every page has natural Amharic and English text and accurate artwork.
- [ ] Provenance, rights, review evidence, and image logs are complete.
- [ ] `dart run tool/catalog_qa.dart`
- [ ] Strict editorial QA passes for every story assigned `release_ready`.
- [ ] `flutter analyze`
- [ ] `flutter test`
- [ ] App launches and all five stories open from bundled assets.
- [ ] Firestore -> Hive -> bundled JSON order remains intact.

## Accessibility and interaction

- [ ] Text scaling produces no clipping or unreachable controls.
- [ ] TalkBack labels and traversal make sense in both languages.
- [ ] Contrast passes in daytime and bedtime modes.
- [ ] Touch targets are large enough for young children.
- [ ] Colour is never the only status cue.
- [ ] Swipe actions have visible button alternatives.
- [ ] Portrait and landscape preserve story order, controls, and position.

## Offline and performance

- [ ] Install cleanly, enable airplane mode before first launch, and open every
      story and image.
- [ ] Favourites, language, settings, history, and position persist on device.
- [ ] Pixel 8a is usable within 3 seconds.
- [ ] Page turns show no blank frame.
- [x] Small-phone, older-supported-Android, and 10-inch-tablet emulator checks pass.
  Automated viewport coverage is supplemented by release-APK passes on an API
  24 720×1280 phone and API 35 1280×800 10-inch tablet. Evidence is recorded in
  `EMULATOR_MATRIX_2026-07-04.md`.
- [ ] APK/AAB size is measured; investigate anything above the 100 MB target.

## Closed test and production

Use `PLAY_CLOSED_TEST_READINESS.md` for the current policy references,
provisional declaration map, tester instructions, and privacy-safe evidence log.

- [ ] Signed release APK and AAB build successfully.
- [ ] Play target audience, content rating, Data safety, and Families answers are
      accurate and reviewed against current policy.
- [ ] Privacy policy, website, support email, publisher identity, screenshots,
      descriptions, and support process are ready.
      Bilingual draft copy and the asset/capture plan are in
      `PLAY_STORE_LISTING_DRAFT.md`.
- [ ] Parent-only feedback form collects no child identity.
- [ ] Reviewer contact mapping and raw scorecards remain outside Git; committed
      findings use the anonymous process in `REVIEWER_OPERATIONS.md`.
- [ ] At least 12 parent testers receive instructions covering language,
      story flow, age fit, illustrations, usability, and offline use.
- [ ] Feedback is triaged; no release blocker remains open.

Do not perform Firebase writes, signing, Play Console, upload, or release actions
without explicit owner approval.
