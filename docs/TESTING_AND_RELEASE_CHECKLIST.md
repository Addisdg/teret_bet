# Testing and Release Checklist

## Every integrated story batch

- [ ] Page numbers are sequential; length follows narrative flow.
- [ ] Every page has natural Amharic and English text and accurate artwork.
- [ ] Provenance, rights, review evidence, and image logs are complete.
- [ ] `dart run tool/catalog_qa.dart`
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
- [ ] Small-phone, older-supported-Android, and 10-inch-tablet emulator checks pass.
  Automated shell preflight covers 320 x 568 and 1280 x 800 logical viewports;
  physical/emulator validation is still required. The declared minimum Android
  version is API 24 (Android 7.0).
- [ ] APK/AAB size is measured; investigate anything above the 100 MB target.

## Closed test and production

- [ ] Signed release APK and AAB build successfully.
- [ ] Play target audience, content rating, Data safety, and Families answers are
      accurate and reviewed against current policy.
- [ ] Privacy policy, website, support email, publisher identity, screenshots,
      descriptions, and support process are ready.
- [ ] Parent-only feedback form collects no child identity.
- [ ] At least 12 parent testers receive instructions covering language,
      story flow, age fit, illustrations, usability, and offline use.
- [ ] Feedback is triaged; no release blocker remains open.

Do not perform Firebase writes, signing, Play Console, upload, or release actions
without explicit owner approval.
