# Pilot Illustration Provenance - R1

Packet: `PILOT-FAMILY-R1-2026-07-05`

Status: **Generated-asset prompts captured; legacy release provenance incomplete**

Exact revised prompts for all 39 project-generated PNG assets are stored in
`pilot_illustration_prompts_r1.json`. The manifest maps each committed path to
its generation event filename, tool, date, references, edits, and review status.

## Asset groups

| Assets | Creation basis | Tool/date | Rights and provenance status |
| --- | --- | --- | --- |
| `mouse_deer_prepared_early/page_01_r1.png` through `page_09_r1.png` | Original prompts built from the matching draft page beat plus repeated character, Ethiopian-setting, crop, safety, and no-text constraints | Codex built-in image generator, 2026-07-05 | Exact prompts captured; family/cultural/visual and owner approval pending |
| `rat_kings_son/page_01_r1.png` through `page_14_r1.png` | Same page-beat workflow with repeated king, prince, elder, mountain, and shawl specifications | Codex built-in image generator, 2026-07-05 | Exact prompts captured; family/cultural/visual and owner approval pending |
| `cub_and_kid/page_01_r1.png` through `page_11_r1.png` | Same page-beat workflow with repeated cub, kid, river, family-distance, safety, and crop specifications | Codex built-in image generator, 2026-07-05 | Exact prompts captured; page 6 was regenerated to remove an incorrect extra character; review and owner approval pending |
| `lion_and_mouse/page_01.webp` through `page_08.webp` | Copies of existing bundled catalogue art; originals remain under `assets/images/stories/` | Legacy project assets; tool/model/date not recorded | Provenance gap; review only, not release-approved |
| `lion_and_mouse/page_09_r1.png` and `page_10_r1.png` | Original page-beat prompts; page 9 was safely reframed after an automated generation rejection | Codex built-in image generator, 2026-07-05 | Exact prompts captured; family/visual and owner approval pending |
| `stone_soup/page_01.webp` through `page_10.webp` | Copies of existing bundled catalogue art; originals remain under `assets/images/stories/` | Legacy project assets; tool/model/date not recorded | Provenance gap; review only, not release-approved |
| `stone_soup/page_11_r1.png` and `page_12_r1.png` | Original page-beat prompts with Ethiopian highland village, shared meal, respectful setting, and no-text constraints | Codex built-in image generator, 2026-07-05 | Exact prompts captured; family/cultural/visual and owner approval pending |

## References and human edits

- No third-party illustration was supplied as a generation reference.
- The five draft Markdown files supplied the narrative and illustration beats.
- Existing catalogue images were copied non-destructively for review.
- Generated images were not manually repainted. PDF-only JPEG derivatives are
  resized and encoded under `tmp/pdfs/`; they are not source assets.

## Review gate

Every image is `Draft - family/cultural/visual review pending`. Reviewer notes
must cover image-text alignment, character continuity, cultural fit, emotional
safety, child appeal, and portrait/landscape cropping. Before any image is moved
into the release catalogue, resolve applicable legacy provenance gaps, record
reviewer evidence, and obtain explicit owner approval.
