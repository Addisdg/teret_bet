# Story Status Board

## Status sequence

`Candidate -> Researched -> Drafted -> Language reviewed -> Read-aloud approved
-> Text locked -> Illustrated -> Visual approved -> QA passed -> Release ready`

Statuses are evidence-based and advance only in order. Record reviewer, date,
decision, and notes in the story's review record. `ready_for_review` in existing
JSON means technically available for review, not editorially approved.

## Pilot batch

| Slot | Story | Work type | Current status | Next evidence |
| --- | --- | --- | --- | --- |
| 1 | The Rat Who Prepared Early | Ethiopian candidate | Language reviewed; provisional | Family read-aloud and age-fit review |
| 2 | The Cub and the Kid | Ethiopian candidate | Language reviewed; provisional | Family read-aloud and trust/safety review |
| 3 | The Rat King's Son | Ethiopian candidate | Language reviewed; provisional | Family read-aloud and age-fit review |
| 4 | The Lion and the Mouse | Existing repair | Language reviewed; provisional | Family read-aloud and age-fit review |
| 5 | Stone Soup | Existing repair | Language reviewed; provisional | Family read-aloud and age-fit review |

The three Ethiopian candidates are proposed replacements for `little_match_girl`,
`steadfast_tin_soldier`, and `swineherd`. No manifest change is approved yet.

The five exact provisional drafts are frozen for review as packet
`PILOT-FAMILY-R1-2026-07-05`; see `PILOT_REVIEW_PACKET_R1_2026-07-05.md`.
Freezing the review copy does not lock text or approve replacement/integration.
The packet now includes 56 review-candidate illustrations embedded beside the
matching bilingual page text. All PDF-selected illustrations are newly
generated PNG assets with exact prompts recorded; the 18 formerly selected
legacy WebPs for The Lion and the Mouse and Stone Soup are retained only as
inactive reference fallbacks. This supports combined family, cultural, and
visual feedback; it does not advance any story to `Illustrated` or `Visual
approved`.

## Catalogue summary

| Measure | Current | Release requirement |
| --- | ---: | ---: |
| Manifest stories | 50 | 50 |
| Pages | 521 | Content-driven; may grow |
| Ethiopian-origin approved stories | 0 confirmed | At least 10 |
| Existing JSON `published` | 1 | Not an editorial approval measure |
| Existing JSON `ready_for_review` | 49 | Not an editorial approval measure |
| Stories with recorded source URL | 0 | 50 |
| Stories at `Release ready` | 0 | 50 |

Update this board after every owner approval and completed quality gate.

Family-test instructions, scorecards, and de-identified results are maintained
in `PILOT_FAMILY_REVIEW_GUIDE.md`, `PILOT_FAMILY_REVIEW_SCORECARD.md`, and
`PILOT_FAMILY_REVIEW_RESULTS.md`.

## Batch 2 draft lane

Batch 2 is a parallel text/provenance preparation lane only. It does not change
the live catalogue, story manifest, images, or first pilot review packet.
This lower-risk Aesop batch is a voice-calibration batch, not a future selection
constraint. Later content batches should include the most significant stories
for the Teret Bet mission even when those stories require more pages, more
review, and more illustration scope.

| Slot | Story | Work type | Current status | Next evidence |
| --- | --- | --- | --- | --- |
| 1 | The Fox and the Grapes | Existing Aesop repair | Drafted; not owner-reviewed | Owner Amharic read-aloud and page-flow review |
| 2 | The Tortoise and the Hare | Existing Aesop repair | Drafted; not owner-reviewed | Owner Amharic read-aloud and page-flow review |
| 3 | The Crow and the Pitcher | Existing Aesop repair | Drafted; not owner-reviewed | Owner Amharic read-aloud and age-3-4 clarity review |
| 4 | The Dog and His Reflection | Existing Aesop repair | Drafted; not owner-reviewed | Owner terminology review for `ጥላ` / reflection |
| 5 | The Goose That Laid the Golden Eggs | Existing Aesop repair | Drafted; not owner-reviewed | Owner safety review of violence-free ending |

The Batch 2 draft files are in `docs/batch2_drafts/` as
`BATCH2-AESOP-R1-DRAFT-2026-07-08`. They are not text locked and are not
release-ready.
