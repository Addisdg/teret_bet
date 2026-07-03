# Local Reading History

## Behavior

- Reading history is stored only in the existing on-device Hive settings box.
- Each story has one entry containing its last page, page count, completion
  state, and UTC last-read timestamp.
- Reopening a story moves it to the front rather than creating a duplicate.
- The list retains the latest 20 stories.
- Reaching the final page marks an entry complete; incomplete entries appear in
  Continue Reading.
- Recently Read includes completed and incomplete entries in recency order.
- A parent-facing confirmation is required before clearing all history.

The existing repository reading-position key remains responsible for reopening
the reader on the saved page. The history record supports discovery and does
not replace the Firestore -> Hive -> bundled JSON content fallback chain.

## Privacy

History never leaves the device. It contains story IDs, page numbers, a
completion flag, and timestamps only. It contains no child identity, account,
free-form notes, analytics identifier, or cloud synchronization field.

## Verification

Provider tests verify persistence, completion, newest-first ordering, the
20-entry limit, restoration, and clearing. Reader regression tests continue to
verify page navigation and same-page language switching.
