# Current Goal

Establish the product and editorial foundation, then complete one approved
five-story pilot before scaling review across the 50-story launch catalogue.

## Why this replaced the previous goal

The Android infrastructure, signed builds, 50-story manifest, 521 bundled
pages, and Firestore tooling are technically mature. They do not establish
language accuracy, cultural provenance, age suitability, story continuity, or
illustration consistency. Uploading the current export would prematurely label
unapproved content as production catalogue data.

## Active documentation batch

- Upgrade repository agent guidance and project-scoped Codex defaults.
- Define product and release criteria.
- Define bilingual editorial and illustration systems.
- Add provenance, privacy, testing, decision, and status records.
- Reconcile roadmap and current project context.

This batch changes documentation/configuration only. It does not change story
text, artwork, dependencies, Firebase, or application code.

## Next proposed five-story pilot

1. The Mouse Deer Who Was Cold at Noon — Ethiopian candidate, Wolayita.
2. The Cub and the Kid — Ethiopian candidate, Amhara.
3. The Rat King's Son — Ethiopian candidate, Oromia.
4. The Lion and the Mouse — existing international repair.
5. Stone Soup — existing international repair.

The three Ethiopian candidates are proposed replacements for
`little_match_girl`, `steadfast_tin_soldier`, and `swineherd`. Replacement and
manifest edits require explicit owner approval after provenance and suitability
research.

## Pilot acceptance

- Sources, rights, cultural context, and reviewers recorded.
- Natural Amharic and English adaptations approved.
- Read-aloud, age-fit, and full story-flow reviews approved.
- Page count determined only by narrative continuity; no upper limit.
- Final page order locked before complete illustration generation.
- Every page has accurate, consistent, provenance-recorded artwork.
- Catalogue, accessibility, offline, app, and Pixel 8a checks pass.

## Current checkpoint

All five pilot drafts have provisional owner language approval. The active gate
is privacy-safe family read-aloud and age-fit review using
`docs/PILOT_FAMILY_REVIEW_GUIDE.md`. Do not lock text or begin final
illustrations until material family findings are resolved and the owner gives
explicit approval.

The independent app baseline is recorded in `docs/APP_BASELINE_AUDIT.md`.
While family testing is external, the next recommended implementation batch is
the release-contract foundation: persistent bilingual state and removal of
unfinished audio UI, without integrating unapproved pilot text.

The bilingual release contract is now implemented on its feature branch and
recorded in `docs/BILINGUAL_RELEASE_CONTRACT.md`: first-launch selection,
persistent Amharic/English settings, same-page reader switching, safe Amharic
fallbacks for incomplete English records, and removal of unfinished audio UI.
The pilot content remains outside the application pending family review.

The remaining Batch A model work is also implemented: optional origin,
adaptation, cultural-context, and review fields parse safely across older data.
The app shows their origin chip and “About this story” section only when a
future reviewed record supplies display metadata; no current catalogue claims
were added or changed.

Batch B reader work is now underway. The first slice adds a side-by-side
landscape/short-height layout, compact reachable controls, localized semantics,
and large-text accessibility widget evidence. Pixel 8a and TalkBack checks
remain manual release gates.

Batch C local history is now implemented on its feature branch. The newest 20
on-device records power Continue Reading and Recently Read tabs, retain
completion and page progress, and can be cleared after confirmation. No child
identity, account, analytics, or cloud-history path was introduced.

Batch C discovery filtering is also implemented: the library offers overlapping
ages 3-4 and 5-6 plus catalogue-driven theme filters in a scrollable parent
sheet. These combine predictably with search, collection, and favourites and do
not modify story metadata.

The three-destination product shell is now implemented: Discover, Favourites,
and Settings remain available in one persistent navigation bar. Favourites is
a stable destination scope, while search, collection, age, and theme remain
clearable refinements.

Offline startup now has bounded cloud waits while preserving Firestore -> Hive
-> bundled JSON order. Firebase initialization and Firestore catalogue/page
reads fall through after 1.2 seconds instead of waiting indefinitely. Pixel 8a
clean-install and airplane-mode timing still require device measurement.

The warm day palette and manual persistent bedtime mode are now implemented.
Bedtime mode dims interface surfaces without modifying illustrations, and both
theme variants pass automated Settings text-contrast guidance. Font bundling
remains blocked on choosing and reviewing a licensed Ethiopic font asset.

Release-size hardening now has fresh evidence in
`docs/RELEASE_SIZE_AUDIT_2026-07-03.md`. The normal AAB builds at 181,025,712
bytes and the arm64 analysis attributes 122 MB compressed to assets. Gradle is
stabilized for the available WSL memory, but the provisional 100 MB target is
not met; illustration optimization requires a separately approved visual QA
batch.

Physical Pixel 8a validation is recorded in
`docs/PIXEL_8A_ACCEPTANCE_2026-07-03.md`. Cold activity launch measured 491 ms
and the owner approved the product shell, typography rendering, themes, and
reader controls. Owner review found landscape illustration cropping; the reader
now preserves the complete image with `BoxFit.contain`, with automated coverage.
Post-fix device confirmation remains pending after WSL build memory is reset.

A reversible full-catalogue image pilot is recorded in
`docs/IMAGE_OPTIMIZATION_PILOT_2026-07-03.md`. Quality 80 at 960 x 720 reduces
the temporary image set by 48.53% and projects an approximately 85.8 MB arm64
bundle. Repository illustrations remain unchanged pending Pixel 8a visual
approval of representative fine detail.

The owner approved the 960 x 720 quality-80 option on 2026-07-04. All 585
originals were archived and checksum-verified in Windows Documents before the
live assets were replaced. The optimized catalogue totals 65,424,746 image
bytes. The fresh multi-ABI release AAB is 119.3 MB, down from 181.0 MB. Pixel
visual verification and Play-delivered download measurement remain active
gates; the normal upload artifact is still above the provisional 100 MB target.

## Deferred until approved content exists

- Firestore production catalogue upload.
- Final release build and Play rollout.
- Audio implementation.
- Catalogue growth beyond 50.

## Repository state at foundation start

- Branch started from local `master`, which was one intentional commit ahead of
  `origin/master`: `0018ad1 Add Firestore catalog upload workflow`.
- Do not push, merge, or commit without explicit owner approval.
