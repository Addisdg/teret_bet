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

This is deterministic fallback evidence, not a Pixel 8a startup measurement.
Airplane-mode clean-install timing, cached timing, slow-network behavior, and
the three-second device target remain manual release checks.
