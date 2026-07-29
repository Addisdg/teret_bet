# Five-Story Batch Workflow

## Approval rhythm

1. Codex proposes five stories, intended replacements, risks, and sources.
2. Owner approves the batch plan.
3. Research provenance, cultural context, rights, and age suitability.
4. Draft complete Amharic and English adaptations with content-driven page
   breaks. Do not generate final art yet.
5. Owner and reviewers request revisions, perform read-aloud checks, and
   explicitly lock text.
6. Prepare character sheets, settings, page specifications, and a provenance
   plan for the entire image set.
7. Owner approves the illustration plan before generation.
8. Generate and review the complete set; correct consistency failures.
9. Integrate the approved batch and run catalogue, app, accessibility, offline,
   and device QA.
   Run `dart run tool/catalog_qa.dart --strict-editorial --story=story_id` for
   each story before assigning `release_ready`.
10. Owner approves any commit, push, or merge.

## Story flow review

Read each whole story without looking at its page count. Mark rushed setup,
missing transitions, unexplained decisions, repeated resolutions, abrupt
endings, and text-image mismatch. Add, remove, split, merge, or reorder pages
as the narrative requires. Page count may increase at any stage before text
lock, and artwork scope increases with it.

## Story significance and batch selection

Do not choose only the shortest or easiest stories merely to keep batches small.
When a story is important to the product mission, cultural breadth, emotional
range, Ethiopian visibility, or the balanced 50-story launch catalogue, include
it even if it needs more pages, more review time, or more illustration work.

Use page count as a planning and production estimate, not as a quality limit.
If a significant story needs extra setup, transition, emotion, action, or
resolution pages, expand it. If a story becomes too dense for young children,
split the beats instead of shrinking the language or artwork.

## Batch definition of done

All five stories reach the same board status; provenance and image logs are
complete; local assets and Firestore export remain schema-compatible; automated
checks pass; and unresolved human-review notes are visible rather than hidden.
