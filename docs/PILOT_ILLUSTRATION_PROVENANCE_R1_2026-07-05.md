# Pilot Illustration Provenance - R1

Packet: `PILOT-FAMILY-R1-2026-07-05`

Status: **All review-selected illustrations generated and prompts captured**

Exact revised prompts for all 57 project-generated PNG assets are stored in
`pilot_illustration_prompts_r1.json`. The manifest maps each committed path to
its generation event filename, tool, date, references, edits, and review status.

## Asset groups

| Assets | Creation basis | Tool/date | Rights and provenance status |
| --- | --- | --- | --- |
| `mouse_deer_prepared_early/page_01_r1.png` through `page_09_r1.png` | Original prompts built from the matching draft page beat plus repeated character, Ethiopian-setting, crop, safety, and no-text constraints | Codex built-in image generator, 2026-07-05 | Exact prompts captured; family/cultural/visual and owner approval pending |
| `rat_kings_son/page_01_r1.png` through `page_14_r1.png` | Same page-beat workflow with repeated king, prince, elder, mountain, and shawl specifications | Codex built-in image generator, 2026-07-05 | Exact prompts captured; family/cultural/visual and owner approval pending |
| `cub_and_kid/page_01_r1.png` through `page_11_r1.png` | Same page-beat workflow with repeated cub, kid, river, family-distance, safety, and crop specifications | Codex built-in image generator, 2026-07-05 | Exact prompts captured; page 6 was regenerated to remove an incorrect extra character; review and owner approval pending |
| `lion_and_mouse/page_01_r1.png` through `page_10_r1.png` | Original page-beat prompts with repeated natural lion and mouse specifications, Ethiopian savanna setting, emotional-safety constraints, and no-text constraints; page 9 was safely reframed after an automated generation rejection | Codex built-in image generator, 2026-07-05 | Exact prompts captured; family/visual and owner approval pending |
| `stone_soup/page_01_r1.png` through `page_12_r1.png` | Original page-beat prompts with a recurring traveller, Ethiopian highland village, shared meal, respectful setting, child safety, and no-text constraints | Codex built-in image generator, 2026-07-05 to 2026-07-06 local time | Exact prompts captured; family/cultural/visual and owner approval pending |

## References and human edits

- No third-party illustration was supplied as a generation reference.
- The five draft Markdown files supplied the narrative and illustration beats.
- Existing catalogue WebPs remain preserved non-destructively as inactive
  reference fallbacks. The PDF generator selects the matching `_r1.png` first.
- Generated images were not manually repainted. PDF-only JPEG derivatives are
  resized and encoded under `tmp/pdfs/`; they are not source assets.

## Review gate

Every image is `Draft - family/cultural/visual review pending`. Reviewer notes
must cover image-text alignment, character continuity, cultural fit, emotional
safety, child appeal, and portrait/landscape cropping. Before any image is moved
into the release catalogue, resolve applicable legacy provenance gaps, record
reviewer evidence, and obtain explicit owner approval.
