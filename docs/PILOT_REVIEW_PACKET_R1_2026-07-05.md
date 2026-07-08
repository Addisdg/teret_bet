# Pilot Family Review Packet — R1

Packet ID: `PILOT-FAMILY-R1-2026-07-05`  
Status: **Ready for combined image/text family and cultural review; not locked**

This index identifies the exact five drafts approved provisionally by the owner
and prepared for external review. It contains no reviewer names or contact
details. Assign reviewer/session codes using `REVIEWER_OPERATIONS.md` and keep
the private roster and raw scorecards outside Git.

## Packet contents

| Review revision | Story | Pages | Primary review coverage |
| --- | --- | ---: | --- |
| `PILOT-FAMILY-R1-2026-07-05-MOUSE-RAT` | [The Rat Who Prepared Early](pilot_drafts/mouse_deer_prepared_early.md) | 9 | Ages 3-4 and 5-6; Wolayita context; animal term and preparation joke |
| `PILOT-FAMILY-R1-2026-07-05-RAT-KING` | [The Rat King's Son](pilot_drafts/rat_kings_son.md) | 14 | Ages 5-6; Oromia context; repeated chain and family frame |
| `PILOT-FAMILY-R1-2026-07-05-CUB-KID` | [The Cub and the Kid](pilot_drafts/cub_and_kid.md) | 11 | Ages 5-6; Amhara context; trust and emotional-safety decision |
| `PILOT-FAMILY-R1-2026-07-05-LION-MOUSE` | [The Lion and the Mouse](pilot_drafts/lion_and_mouse.md) | 10 | Ages 3-4 and 5-6; natural Amharic; safe problem/rescue sequence |
| `PILOT-FAMILY-R1-2026-07-05-STONE-SOUP` | [Stone Soup](pilot_drafts/stone_soup.md) | 12 | Ages 3-4 and 5-6; traveller framing; food and setting coherence |

Structural check: 56 pages; each page has one Amharic text block, one complete
English text block, one embedded review illustration, and one illustration beat.

## Printable reviewer copies

- [The Rat Who Prepared Early PDF](../output/pdf/PILOT-FAMILY-R1-2026-07-05_mouse_deer_prepared_early.pdf)
- [The Rat King's Son PDF](../output/pdf/PILOT-FAMILY-R1-2026-07-05_rat_kings_son.pdf)
- [The Cub and the Kid PDF](../output/pdf/PILOT-FAMILY-R1-2026-07-05_cub_and_kid.pdf)
- [The Lion and the Mouse PDF](../output/pdf/PILOT-FAMILY-R1-2026-07-05_lion_and_mouse.pdf)
- [Stone Soup PDF](../output/pdf/PILOT-FAMILY-R1-2026-07-05_stone_soup.pdf)

Each PDF contains a privacy reminder, one image-and-bilingual-text sheet per
story page, the expected illustration beat, focused image/text review prompts,
page-specific note lines, an expanded visual scorecard, and an observations
sheet. Generate and verify them with `tool/generate_pilot_review_pdfs.py`. The
generator fails when an illustration, page label, scorecard, observations sheet,
or expected page is missing. Markdown remains the authoritative text source.
PDF metadata and document IDs are invariant, so rebuilding unchanged inputs is
byte-for-byte reproducible. Use `--story lion_and_mouse` (or another story
slug) to rebuild and verify only one corrected packet; omit `--story` for all
five.

The integrated set contains 56 embedded illustrations across 71 PDF pages. All
71 pages were rendered and visually inspected on 2026-07-05. Distribution files
are approximately 2-4 MB each; review-only JPEG derivatives are generated under
`tmp/pdfs/` and do not replace the source artwork.

## Integrity checks

The text checksum identifies the exact R1 wording:

```bash
sha256sum -c docs/pilot_drafts/PILOT_FAMILY_R1_2026-07-05.sha256
```

The visual checksum binds all 56 selected source illustrations and the five
reproducible reviewer PDFs:

```bash
sha256sum -c docs/pilot_drafts/PILOT_FAMILY_R1_2026-07-05_VISUAL.sha256
```

The combined verifier also checks exact file coverage and prompt provenance:

```bash
python3 tool/verify_pilot_review_packet.py
```

If a draft, selected image, or PDF changes, do not silently update its checksum
while reviews are in progress. Create a new revision, record which findings
caused the change, and route later sessions to that revision. Feedback is valid
only for the exact text-and-visual revision the adult actually reviewed.

## Owner-change reconciliation

R1 includes the owner-reviewed wording recorded before this packet:

- The Rat Who Prepared Early uses `አይጠ መጎጥ`, depicts/translates the animal as
  a small rat, includes the revised winter-preparation dialogue, and ends with
  `ትክክለኛውን ነገር ማዘጋጀት`.
- The Rat King's Son uses `ደመና`, the revised family framing, the full
  cloud-wind-mountain chain, and the revised closing contrast with
  `በመብለጥ ሳይሆን`.
- The Lion and the Mouse includes the revised mane, grain, respectful address,
  tangled-rope sequence, and `ነገር ግን ገመዱ...` wording.
- Stone Soup includes the revised traveller opening, village-door sequence,
  ingredient contributions, and resident-focused ending.
- The Cub and the Kid remains the provisionally accepted high-risk draft with
  no owner wording changes; its premise must still pass cultural and safety
  review or be replaced.

This reconciliation confirms inclusion, not final linguistic or cultural
approval.

## What to send for one session

Send only:

1. The single assigned story link/file from the table above.
2. `PILOT_FAMILY_REVIEW_GUIDE.md`.
3. A blank `PILOT_FAMILY_REVIEW_SCORECARD.md`.
4. One anonymous session code.
5. The owner's private feedback-return instructions.

Ask the adult to comment on both story and artwork: whether each picture matches
both languages, characters remain recognisable, cultural and setting details
feel respectful, emotions feel safe, and the important action survives cropping.

Do not ask one family to review all five in one sitting. Amharic and English
should be separate sittings when practical.

### Per-story distribution bundles

Run `python3 tool/build_pilot_reviewer_bundles.py` to create five separate ZIP
files under `output/reviewer_bundles/`. Each archive contains only one story
PDF, the review guide, the blank scorecard, and a session-instructions template.
Before sending, the owner must fill the anonymous session code and private
feedback-return route in the template or accompanying message. Never add names,
contact details, or the private reviewer roster to Git.

Verify the generated archives from their output directory with:

```bash
sha256sum -c SHA256SUMS
```

For an assigned session, prefer `tool/build_pilot_review_session.py` as
documented in `REVIEWER_OPERATIONS.md`. It inserts the validated anonymous code
and owner-controlled private return instructions into one ignored, story-only
archive after the frozen packet integrity check passes.

## First-wave assignment board

Codes and launch order are defined in `PILOT_FIRST_WAVE_LAUNCH_PLAN.md`. Do not
add names or contact information here.

| Story | Cultural/specialist code | Family session code(s) | State |
| --- | --- | --- | --- |
| The Rat Who Prepared Early | `C01` | `R01` | Prepared; awaiting private match |
| The Cub and the Kid | `C02` | Second wave after specialist review | Prepared; awaiting private match |
| The Rat King's Son | `C03` | `R02` | Prepared; awaiting private match |
| The Lion and the Mouse | N/A / language reviewer | `R03` | Prepared; awaiting private match |
| Stone Soup | N/A / setting reviewer | `R04` | Prepared; awaiting private match |

## Return and triage

- Raw scorecards stay outside Git until de-identified.
- Transfer page-specific material findings to
  `PILOT_REVIEW_FINDINGS_REGISTER.md`; keep
  `PILOT_FAMILY_REVIEW_RESULTS.md` for story-level coverage and decisions.
- Use `PILOT_FEEDBACK_TRIAGE.md` for category, severity, stop-finding, and R2
  revision rules.
- Mark each material finding `open`, `resolved`, `accepted`, or
  `replacement trigger`; use `deferred` only for an explicit owner-approved
  non-pilot item.
- Pause further circulation of a draft after a cultural-attribution or
  child-safety concern until the owner triages it.
- Do not advance any story beyond `Language reviewed; provisional` from this
  packet alone.

## Exit from R1 review

R1 closes only when each story has the required independent sessions and
specialist coverage, every material finding is resolved or accepted explicitly,
and the owner chooses one of:

- advance to `Read-aloud approved`;
- issue R2 for targeted re-review; or
- replace the candidate.
