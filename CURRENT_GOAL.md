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
clean-install airplane-mode validation now passes: the language chooser appears,
all 50 bundled stories and images load, and first launch measures 721 ms.

The warm day palette and manual persistent bedtime mode are now implemented.
Bedtime mode dims interface surfaces without modifying illustrations, and both
theme variants pass automated Settings text-contrast guidance. The official
Google Fonts Noto Sans Ethiopic variable typeface and its SIL Open Font License
are now bundled, removing the device-dependent Amharic font fallback.

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
The font-inclusive optimized release was subsequently confirmed on the Pixel:
the full composition remains visible in landscape, controls and text fit, and
an unlocked cold activity launch measured 371 ms.

A reversible full-catalogue image pilot is recorded in
`docs/IMAGE_OPTIMIZATION_PILOT_2026-07-03.md`. Quality 80 at 960 x 720 reduces
the temporary image set by 48.53% and projects an approximately 85.8 MB arm64
bundle. The owner approved this option and the optimized assets have since
replaced the live catalogue after the originals were archived and verified.

The owner approved the 960 x 720 quality-80 option on 2026-07-04. All 585
originals were archived and checksum-verified in Windows Documents before the
live assets were replaced. The optimized catalogue totals 65,424,746 image
bytes. The fresh multi-ABI release AAB is 119.3 MB, down from 181.0 MB. Pixel
8a-targeted bundletool measurement is 74.8 MB compressed (85.8 MB in selected
split APK entries), below the provisional 100 MB user-download target. Pixel
visual verification now passes; final Play Console processing remains an active
gate. The normal upload artifact is 119.3 MB because it serves multiple device
variants.

After bundling Noto Sans Ethiopic, the fresh release AAB is 119.9 MB and the
font-inclusive Pixel 8a compressed download is 75.4 MB. Typography consistency
therefore adds only about 0.54 MB and does not threaten the download-size gate.

Release-signing integrity is now hardened. Gradle no longer substitutes the
debug key when release credentials are absent: release tasks fail explicitly,
while debug builds remain unaffected. Release preflight checks this policy and
the current locally signed 119.9 MB AAB builds successfully.

Android application backup is now explicitly disabled so favourites, reading
history, settings, language, and position remain device-local as promised. The
backup-disabled manifest is covered by release preflight and was confirmed on
the clean-installed Pixel package.

Accessibility automation now covers the complete product shell at 200 percent
system text scale. A labelled-target audit found and fixed the story-card tap
surface, which now announces a localized “title, open story” action separately
from its favourite button. Physical Pixel maximum-text inspection now passes,
and the active TalkBack hierarchy confirms ordered localized controls without a
duplicate visible-title stop. Parent listening review of Amharic pronunciation
remains the active accessibility gate.

Responsive device-matrix preflight now covers 320 x 568 small-phone and
1280 x 800 tablet viewports in widget tests, including adaptive library columns,
labelled controls, and Android touch targets. The app declares API 24 (Android
7.0) as its minimum.

The real emulator matrix is now complete using Windows-hosted AVDs. The release
APK passes offline first launch, the 50-story Amharic library, story entry, and
reader usability on an API-24 720×1280 small phone and API-35 1280×800 10-inch
tablet. Evidence and the WSL/Windows ADB ownership procedure are recorded in
`docs/EMULATOR_MATRIX_2026-07-04.md`.

Play closed-test preparation is now defined in
`docs/PLAY_CLOSED_TEST_READINESS.md`. It maps the current child-directed,
ad-free, account-free, local-state product to provisional Console answers and
provides privacy-safe adult tester instructions and evidence fields. Policy
answers, uploads, tester contact, domain, support email, and public hosting
remain owner-controlled pre-release actions.

A publication-oriented privacy-policy draft now records the implemented local
reading state, Firestore catalogue access, absent data/monetization features,
children's privacy posture, and future support correspondence. It remains
non-public and deliberately contains placeholders for the legal publisher,
support email, retention period, effective date, and jurisdictional review.

The bilingual Google Play listing copy and preview-asset plan are now drafted in
`docs/PLAY_STORE_LISTING_DRAFT.md`. The existing 1254×1254 icon source is suitable
for a dedicated Play export. Final screenshot capture and feature-graphic work
remain gated on approved story content and the exact signed release candidate.

Release preflight now enforces the child-directed dependency and permission
baseline. It fails if known ad, analytics, authentication, crash-reporting, or
tracking SDKs appear, or if the release inputs declare advertising-ID, location,
camera, microphone, contacts, phone, or Bluetooth-scan access.

Catalogue QA now has a single-story `--strict-editorial` gate for future
release-ready content. It enforces bilingual summaries, morals, and page text;
valid 3-6 age ranges and machine status; source/adaptation metadata; review
status; and additional bilingual cultural context for community-specific work.
Normal QA remains backward-compatible with the unapproved legacy catalogue.

Reviewer operations are now defined without creating a roster in Git. The plan
sets family, language, cultural, and owner roles; anonymous codes; pilot coverage
targets; recruitment waves; privacy-safe evidence handling; and escalation
rules. Actual reviewer contact and scheduling remain owner-controlled external
work.

The five provisional pilot drafts are now frozen as review packet
`PILOT-FAMILY-R1-2026-07-05`. All 56 pages have paired Amharic and English text
plus an illustration beat; owner wording changes are reconciled; and checksums
bind incoming feedback to the exact reviewed wording. This is a review freeze,
not text lock or catalogue integration approval.

Reviewer operations, the family guide, the reusable scorecard, and the
de-identified results template now capture real visual evidence alongside text:
image-text alignment, character continuity, cultural and setting fit, emotional
safety, child response, and portrait/landscape cropping.

Five printable R1 reviewer PDFs now accompany the checksum-bound Markdown
sources. Each of the 56 story sheets pairs its review illustration with Amharic,
English, the expected visual beat, and focused image/text questions. The visual
scorecard covers alignment, continuity, cultural respect, and cropping. All 71
PDF pages were regenerated, structurally verified, rendered, and visually
inspected. The Lion and the Mouse pages 1-8 and Stone Soup pages 1-10 now use
newly generated, prompt-recorded review artwork instead of the preserved legacy
WebP fallbacks.
Distribution copies remain approximately 2-4 MB each.

Five privacy-safe single-story reviewer bundles can now be generated with
`tool/build_pilot_reviewer_bundles.py`. Each contains one illustrated PDF, the
guide, blank scorecard, and placeholders for the owner's anonymous session code
and private return route. The archives are generated locally and ignored by
Git; their checksum manifest verifies the exact files being distributed.

## Deferred until approved content exists

- Firestore production catalogue upload.
- Final release build and Play rollout.
- Audio implementation.
- Catalogue growth beyond 50.

## Repository state at foundation start

- Branch started from local `master`, which was one intentional commit ahead of
  `origin/master`: `0018ad1 Add Firestore catalog upload workflow`.
- Do not push, merge, or commit without explicit owner approval.
