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

## Deferred until approved content exists

- Firestore production catalogue upload.
- Final release build and Play rollout.
- Audio implementation.
- Catalogue growth beyond 50.

## Repository state at foundation start

- Branch started from local `master`, which was one intentional commit ahead of
  `origin/master`: `0018ad1 Add Firestore catalog upload workflow`.
- Do not push, merge, or commit without explicit owner approval.
