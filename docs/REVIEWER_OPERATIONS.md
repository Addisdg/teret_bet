# Reviewer Operations

This plan turns the pilot review guides into a repeatable, privacy-safe process.
It does not contain a reviewer roster. Names, contact details, family links, and
the mapping from people to anonymous codes must remain outside Git in an
owner-controlled location.

## Roles

### Owner/editor

- Selects the draft version being reviewed.
- Assigns anonymous reviewer and session codes.
- Removes identifying details before transferring findings into the repository.
- Triages wording, flow, safety, cultural, and visual findings.
- Makes the explicit advance, revise, or replace decision.

### Family read-aloud reviewer

- Is an adult parent, caregiver, educator, or trusted reader.
- Reads naturally with a child in an applicable broad age band.
- Records observations without testing, coaching, photographing, or recording
  the child.
- Reviews Amharic and English in separate sittings where practical.

### Cultural reviewer

- Has relevant language, community, regional, folklore, or cultural knowledge.
- Reviews origin wording, cultural context, names, relationships, setting,
  adaptation choices, claims about the tradition, and visual representation.
- May reject an attribution or candidate even when the story reads smoothly.
- Is not presented as representing an entire community.

### Language reviewer

- Reviews natural spoken Amharic or English independently of the source text.
- Marks literal translation, unnatural rhythm, unclear pronouns, register
  shifts, and wording adults spontaneously replace while reading.
- May also be a family or cultural reviewer, but the role used for each finding
  must be recorded.

## Anonymous coding

Use codes that reveal no name, location, school, or family relationship:

- Adult reviewer: `R01`, `R02`, ...
- Cultural reviewer: `C01`, `C02`, ...
- Session: `PILOT-STORYID-R01-A34-AM-01`
- Broad age band only: `A34` or `A56`
- Language only: `AM` or `EN`

The private roster may map `R01` to an adult's contact details for scheduling.
Never commit that roster. Repository summaries may contain the anonymous code
only when it is needed to demonstrate independent review coverage.

## Pilot coverage target

Before text lock, each story needs at least three independent adult read-aloud
reviews and every applicable age band represented. The owner may contribute one
session, but at least two sessions should come from other adults. Across the
five-story pilot, aim for 5-8 adult reviewers so one household or reading style
does not dominate the evidence.

| Story | Age 3-4 | Age 5-6 | Minimum adult sessions | Additional specialist |
| --- | ---: | ---: | ---: | --- |
| The Rat Who Prepared Early | 1+ | 1+ | 3 | Wolayita cultural review |
| The Cub and the Kid | Optional | 2+ | 3 | Amhara cultural and child-safety review |
| The Rat King's Son | Optional | 2+ | 3 | Oromia cultural review |
| The Lion and the Mouse | 1+ | 1+ | 3 | Independent Amharic read-aloud review |
| Stone Soup | 1+ | 1+ | 3 | Setting/food coherence review |

One qualified person may cover both a cultural and language role, but cultural
approval must remain a separate recorded decision from family enjoyment.

## Recruitment sequence

1. Recruit cultural reviewers for the three Ethiopian candidates first. A
   provenance or attribution problem can stop work before more families invest
   time in the draft.
2. Recruit 5-8 adult family reviewers with a mix of Amharic confidence, English
   confidence, age bands, and Android familiarity.
3. Assign codes in the private roster and send one story per session.
4. Schedule a small first wave for the highest-risk stories rather than sending
   all drafts to everyone.
5. Revise material problems before the second wave so reviewers are not all
   reporting the same known issue.

Recommended first wave:

- The Cub and the Kid: one cultural/safety review before family sessions.
- The Rat King's Son: one cultural review plus one age-5-6 Amharic session.
- The Rat Who Prepared Early: one cultural review plus one age-3-4 Amharic session.
- The Lion and the Mouse and Stone Soup: one Amharic session each to establish
  the imported-story repair baseline.

The prepared seven-session order, anonymous codes, invitation copy, and owner
launch checklist are in `PILOT_FIRST_WAVE_LAUNCH_PLAN.md`.

## Adult invitation template

> Teret Bet is preparing illustrated Amharic and English stories for families
> with children ages 3-6. I am looking for adults willing to read one short
> draft naturally with a child and give feedback on wording, story flow,
> attention, emotional safety, and age fit. This is a review of the story, not a
> test of the child. Please do not send names, photos, audio, video, exact ages,
> school details, or other identifying child information. Participation is
> voluntary, and you may stop at any time.

The owner should add a private reply method outside the repository. Do not put a
personal phone number or reviewer email into committed documents.

## Session package

Send only:

- one versioned illustrated story PDF;
- `PILOT_FAMILY_REVIEW_GUIDE.md`;
- the scorecard embedded in the PDF (or a separate blank copy of
  `PILOT_FAMILY_REVIEW_SCORECARD.md` when preferred);
- the assigned anonymous session code; and
- a private return route controlled by the owner.

Do not send unreconciled alternate drafts. Put the draft date or revision ID in
the session record so later feedback can be matched to the wording reviewed.

### Build a ready-to-send session archive

Keep private return instructions in a plain-text file outside this repository,
then build exactly one assigned session. For example:

```bash
python3 tool/build_pilot_review_session.py \
  --story lion_and_mouse \
  --session-code PILOT-LION-MOUSE-R01-A34-AM-01 \
  --return-file /private/path/return-instructions.txt
```

The tool validates the story-specific anonymous-code format, verifies the
frozen text-and-visual packet, and writes one ignored ZIP plus a SHA-256 sidecar
under `output/reviewer_sessions/`. It does not print the private return route.
Never place the return-instructions file, reviewer roster, or generated session
archive in Git.

## Evidence handling

1. Keep raw scorecards outside Git.
2. Check free-form notes for names, locations, schools, medical details, or
   other identifiers.
3. Convert findings into page-specific, de-identified statements.
4. Add only those statements and coverage totals to
   `PILOT_FAMILY_REVIEW_RESULTS.md`.
5. Record every material finding in `PILOT_REVIEW_FINDINGS_REGISTER.md` as
   `open`, `resolved`, `accepted`, `deferred`, or `replacement trigger`.
6. Keep contradictory observations visible; do not average away a safety or
   cultural concern.
7. Separate text, image-text alignment, character continuity, cultural/setting,
   emotional-safety, and crop findings so a visual concern is not misfiled as a
   wording problem.
8. Use `PILOT_FEEDBACK_TRIAGE.md` to assign category, severity, stop-finding,
   and R2 revision decisions.

Example repository-safe finding:

`Two independent age-3-4 Amharic sessions required rereading page 4; split the
cause and response into separate pages.`

Example that must remain outside Git until de-identified:

`[Child name] from [school/location] became frightened because of a recent
personal event.`

## Escalation rules

- Any cultural-attribution objection pauses text lock and illustration work.
- Any child-safety concern is reviewed before additional sessions use that draft.
- Two independent spontaneous rewrites of the same phrase trigger revision.
- Repeated confusion about cause and effect triggers a page-flow revision, not
  a smaller font or denser page.
- A core-premise concern for The Cub and the Kid triggers replacement review
  rather than repeated cosmetic softening.
- New pages added for continuity require new illustration scope.

## Pilot review readiness checklist

- [ ] Private reviewer roster location selected.
- [ ] Anonymous code sequence created.
- [ ] Private feedback return route selected.
- [ ] Wolayita, Amhara, and Oromia cultural-review candidates contacted.
- [ ] At least five adult family reviewers available.
- [ ] Both age bands can be represented.
- [ ] Every outgoing draft has a revision date or ID.
- [ ] Every outgoing PDF opens correctly and shows its page illustrations.
- [ ] Reviewers receive the no-child-identity instruction.
- [ ] Raw scorecards remain outside Git.
- [ ] Owner has time reserved to triage findings between waves.

The pilot is operationally ready when these boxes are complete. Story approval
still follows the evidence rules in `PILOT_FAMILY_REVIEW_GUIDE.md`.
