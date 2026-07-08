# Pilot Feedback Triage Workflow

Packet: `PILOT-FAMILY-R1-2026-07-05`

Status: **Ready to use when first-wave feedback returns**

This workflow converts private WhatsApp, PDF, or scorecard responses into
repository-safe evidence. It protects reviewer and child privacy while keeping
story, illustration, cultural, and technical issues traceable enough to drive
R2 revisions.

## Privacy boundary

Raw feedback remains outside Git. Do not commit:

- reviewer names, phone numbers, email addresses, school names, neighbourhoods,
  exact child ages, photos, audio, video, screenshots, or family relationships;
- the private code-to-person roster;
- unredacted WhatsApp messages or filled PDFs;
- medical, developmental, behavioural, or family-context details.

Repository notes may include only:

- anonymous session code;
- broad age band, such as `A34` or `A56`;
- reviewed packet revision;
- story and page number;
- de-identified observation;
- issue category, severity, status, and owner decision.

## Intake steps

Use this sequence for each returned session.

1. Confirm the session code matches the private roster.
2. Confirm which exact packet revision was reviewed.
3. Save the raw response in the private owner archive outside Git.
4. Remove identifying details before copying any finding into the repository.
5. Split long comments into one issue per row in
   `PILOT_REVIEW_FINDINGS_REGISTER.md`.
6. Add only story-level coverage totals and decision summaries to
   `PILOT_FAMILY_REVIEW_RESULTS.md`.
7. Pause that story if a stop finding appears.

## Issue categories

Use one primary category per finding.

| Category | Use when the finding concerns |
| --- | --- |
| `language` | Amharic or English wording, rhythm, pronouns, vocabulary, read-aloud ease |
| `flow` | page split/merge, pacing, missing transition, unclear cause and effect |
| `age-fit` | child attention, comprehension, boredom, length, age-band mismatch |
| `safety` | fear, distress, unsafe imitation, shame, unresolved danger |
| `culture` | attribution, names, setting, relationships, clothing, custom, respect |
| `image-text` | picture does not match the page text or language version |
| `continuity` | character, clothing, object, setting, or scale changes unexpectedly |
| `composition` | cramped picture, important action cropped, unclear focal point |
| `technical` | PDF, file, display, font, device, or app issue |

## Severity

| Severity | Meaning | Default action |
| --- | --- | --- |
| `S0 stop` | Cultural-attribution, child-safety, rights, or serious trust issue | Pause circulation of the affected story |
| `S1 must fix` | Blocks text lock, visual approval, or age-fit approval | Revise before wider review |
| `S2 should fix` | Material improvement but not a stop issue | Queue for R2 or owner decision |
| `S3 note` | Useful preference, isolated reaction, or future enhancement | Record; no immediate blocker |

If unsure between two severities, choose the higher one until the owner reviews
the finding. Safety and cultural objections are never averaged away.

## Status values

- `open` — needs owner/editor decision.
- `resolved` — revision or correction has been made.
- `accepted` — owner accepts the issue without a change and records why.
- `deferred` — valid, but intentionally moved outside the current pilot scope.
- `replacement trigger` — the finding may require replacing the story candidate.

## Stop findings

Immediately pause additional sessions for the affected story if any reviewer
raises:

- cultural attribution is wrong or misleading;
- cultural or visual representation feels disrespectful;
- the premise is unsafe or inappropriate for ages 3-6;
- the child becomes frightened in a way tied to the story, not merely tired;
- a picture introduces unintended religious, political, or adult meaning;
- a rights/provenance concern appears.

Record the finding in `PILOT_REVIEW_FINDINGS_REGISTER.md` and wait for an owner
decision before sending that same R1 story to more reviewers.

## Triage meeting order

When several findings arrive, triage in this order:

1. `S0 stop` safety, culture, rights, or replacement triggers.
2. Repeated wording changes from independent adults.
3. Repeated page-flow confusion or attention loss.
4. Image-text mismatches and character continuity problems.
5. Cropping, composition, and visual clarity.
6. Isolated preferences and future enhancements.

## R2 decision rule

Create a new packet revision instead of editing R1 in place when:

- any page text changes;
- a page is added, removed, split, merged, or reordered;
- any selected illustration is replaced;
- a story status advances or retreats based on reviewer evidence;
- a finding needs targeted re-review.

The R2 packet must get a new revision ID, new checksums, and updated provenance.
R1 feedback remains valid only for the exact text and pictures reviewed.

## Owner summary format

Use this compact format when asking the owner to approve a revision path:

```text
Story:
Packet reviewed:
Sessions received:
Stop findings:
Must-fix findings:
Suggested R2 changes:
Questions for owner:
Recommended decision: Proceed / Revise R2 / Replace / Pause
```

