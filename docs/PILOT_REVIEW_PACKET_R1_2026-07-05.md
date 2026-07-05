# Pilot Family Review Packet — R1

Packet ID: `PILOT-FAMILY-R1-2026-07-05`  
Status: **Ready to send for family and cultural review; not text locked**

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
English text block, and one illustration beat.

## Printable reviewer copies

- [The Rat Who Prepared Early PDF](../output/pdf/PILOT-FAMILY-R1-2026-07-05_mouse_deer_prepared_early.pdf)
- [The Rat King's Son PDF](../output/pdf/PILOT-FAMILY-R1-2026-07-05_rat_kings_son.pdf)
- [The Cub and the Kid PDF](../output/pdf/PILOT-FAMILY-R1-2026-07-05_cub_and_kid.pdf)
- [The Lion and the Mouse PDF](../output/pdf/PILOT-FAMILY-R1-2026-07-05_lion_and_mouse.pdf)
- [Stone Soup PDF](../output/pdf/PILOT-FAMILY-R1-2026-07-05_stone_soup.pdf)

Each PDF contains a privacy reminder, one uncluttered sheet per story page,
illustration-beat context, page-specific note lines, a session scorecard, and an
observations/recommendation sheet. Generate and verify them with the bundled PDF
runtime using `tool/generate_pilot_review_pdfs.py`. The generator fails if page
counts, repeated page labels, the scorecard, or the final observations sheet are
missing. Markdown remains the authoritative text source.

## Integrity check

The checksum file identifies the exact R1 wording:

```bash
sha256sum -c docs/pilot_drafts/PILOT_FAMILY_R1_2026-07-05.sha256
```

If a draft changes, do not silently update the checksum while reviews are in
progress. Create a new revision, record which findings caused the change, and
route later sessions to that revision. Feedback is valid only for the revision
the adult actually read.

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

Do not ask one family to review all five in one sitting. Amharic and English
should be separate sittings when practical.

## First-wave assignment board

Fill codes only; do not add names or contact information.

| Story | Cultural/specialist code | Family session code(s) | State |
| --- | --- | --- | --- |
| The Rat Who Prepared Early | | | Unassigned |
| The Cub and the Kid | | | Unassigned |
| The Rat King's Son | | | Unassigned |
| The Lion and the Mouse | N/A / language reviewer | | Unassigned |
| Stone Soup | N/A / setting reviewer | | Unassigned |

## Return and triage

- Raw scorecards stay outside Git until de-identified.
- Transfer page-specific findings to `PILOT_FAMILY_REVIEW_RESULTS.md`.
- Mark each material finding `open`, `resolved`, `accepted`, or
  `replacement trigger`.
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
