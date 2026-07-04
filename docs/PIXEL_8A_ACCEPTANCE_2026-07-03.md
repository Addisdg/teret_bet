# Pixel 8a Acceptance — 2026-07-03

## Device and installation

- Physical Pixel 8a
- Android 16
- 1080 x 2400 physical display at 420 dpi
- Existing Teret Bet installation updated in place with the repository release
  key; local app data was preserved
- Release version: 1.0.0+1

The device was attached from Windows to Ubuntu WSL through `usbipd-win`. Linux
ADB required the Google USB node to grant the existing `plugdev` group access.
Do not record the device serial or signing secrets in project documentation.

## Automated evidence

Android activity-manager cold launch:

```text
LaunchState: COLD
TotalTime: 491 ms
WaitTime: 493 ms
```

This passes the provisional three-second activity-launch target. It does not by
itself prove clean-install airplane-mode catalogue readiness, because the
existing app data was intentionally preserved.

## Owner visual review

Passed on the installed release:

- Amharic rendered without missing-glyph boxes.
- Library cards, search, filters, and primary navigation displayed correctly.
- Day and bedtime presentation looked good.
- Reader text size and bilingual controls looked good.

Finding:

- Some reader illustrations felt cramped in landscape. Source inspection
  confirmed that landscape used `BoxFit.cover`, which crops compositions to fill
  the side panel.

Correction:

- Landscape reader art now uses `BoxFit.contain` on a themed surface so the
  complete illustration remains visible.
- Portrait reader art and discovery-card thumbnails retain immersive cover
  cropping.
- The 800 x 400 large-text reader test now asserts `BoxFit.contain`.

## Post-fix release validation — 2026-07-04

The font-inclusive, optimized-image release was installed over the existing app
with the release key, preserving local data. Screenshot inspection on the
physical Pixel confirmed:

- Noto Sans Ethiopic renders Amharic cleanly in the library and reader.
- Optimized 960 x 720 covers and story pages retain clear colour and fine
  illustration detail.
- Portrait story art, text, progress, language, and navigation controls render
  without overlap.
- Landscape uses `BoxFit.contain`; the complete 4:3 composition remains visible
  with intentional themed side space instead of cropping.
- Landscape Amharic text and the compact reader controls remain reachable and
  unclipped.

After the device was unlocked and the rotation settings were restored, a fresh
activity-manager cold launch measured:

```text
LaunchState: COLD
TotalTime: 371 ms
WaitTime: 372 ms
```

This reconfirms the three-second activity-launch gate. An earlier 3,039 ms
measurement from the same installation was excluded because Android's keyguard
was covering the activity during launch.

## Clean-install airplane-mode validation — 2026-07-04

After owner approval to erase app data, the signed backup-disabled release was
installed and tested with airplane mode enabled and Wi-Fi off. A transition
install initially restored an old language preference created by the previous
backup-enabled build; clearing that transition data on the corrected build
established the intended clean state.

Passed:

- Genuine first launch showed the bilingual language chooser.
- Clean offline launch measured 721 ms total / 723 ms wait.
- Amharic selection opened the library with all 50 bundled stories and images.
- The language choice persisted after force-stop and cold offline restart.
- Cold offline restart measured 315 ms total / 323 ms wait.
- Android package flags confirm application backup is disabled.
- Airplane mode, mobile data, Wi-Fi state, rotation, and normal screen sleep
  were restored after testing.

## Pending device checks

- Complete TalkBack traversal and maximum Android display/text-size checks.
- Confirm the durable udev rule survives USB detach and reattach.
