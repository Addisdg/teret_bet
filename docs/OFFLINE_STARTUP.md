# Bounded Offline Startup

## Contract

Teret Bet preserves the required content priority:

1. Firestore
2. Hive cache
3. Bundled JSON and illustrations

Firebase initialization and each Firestore catalogue or page read have a
1.2-second upper bound. A timeout is treated like other cloud unavailability:
the app continues to the next source instead of leaving the family at a spinner
indefinitely. Successful cloud responses still retain first priority and are
cached as before.

The timeout does not delete cache data, reorder sources, write to Firebase, or
require a connectivity dependency. A later retry can use Firestore normally.

## Verification

The repository test suite includes a Firestore service whose futures never
complete. With a short injected test timeout, both catalogue and page reads
reach bundled content within the asserted bound. Production keeps the
1.2-second default.

## Pixel 8a clean-install evidence — 2026-07-04

The signed release was installed from a genuinely cleared state with airplane
mode enabled and Wi-Fi off. Android backup was disabled so preferences from an
older installation could not satisfy the test.

- First clean offline launch: 721 ms total / 723 ms wait.
- Bilingual language chooser displayed before the library.
- Choosing Amharic immediately exposed all 50 bundled stories and their images.
- The language choice persisted across a force-stop and cold offline restart.
- Cold offline restart: 315 ms total / 323 ms wait.

This passes the provisional three-second device target and confirms the full
first-launch catalogue does not require Firebase or prior Hive cache. Slow but
available network behavior and every-story manual opening remain separate
checks.
