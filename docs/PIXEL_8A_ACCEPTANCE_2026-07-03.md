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

## Pending device checks

- Install a post-fix release after WSL memory is reset and visually confirm the
  landscape correction.
- Perform a clean-install airplane-mode launch only after explicit approval to
  erase existing app data.
- Complete TalkBack traversal and maximum Android display/text-size checks.
- Confirm the durable udev rule survives USB detach and reattach.
