# Illustration System and Provenance Log

## House style

Use one calm, warm, illustration-led Teret Bet style. Ethiopian settings,
clothing, homes, landscapes, plants, and objects should be specific and
respectful rather than decorative stereotypes. Collections may vary palette
and setting while retaining a unified rendering style.

## Story workflow

1. Lock both language adaptations and page order.
2. Create a character sheet covering proportions, face, clothing, colour, and
   recurring objects.
3. Create a setting and palette sheet.
4. Write one image specification for every story beat.
5. Generate the complete story set systematically.
6. Review the set together for character, setting, lighting, scale, safety, and
   page-to-page continuity.
7. Regenerate failures rather than accepting a visibly inconsistent patch.

There is no fixed number of images. When story continuity requires a new page,
create a matching image unless deliberate reuse is clearly stronger.

## Asset requirements

- Bundled 960 x 720 quality-80 WebP for every cover and page.
- No embedded text, signatures, watermarks, brands, or copied characters.
- Warm expressions and age-appropriate danger.
- The image must show the current page beat, not merely generic cover art.
- Keep recurring characters recognisable in portrait and landscape crops.

## Per-image provenance record

Record:

| Field | Required value |
| --- | --- |
| Asset path | Repository path |
| Story and page | Stable story ID and page number |
| Prompt/specification | Exact generation brief |
| Tool and model | Generator and model/version when known |
| Generation date | ISO date |
| References | Source and rights status for every reference |
| Human edits | Tool and description |
| Reviewer | Name or reviewer ID |
| Review status | Draft, changes requested, or approved |
| Notes | Continuity, cultural, safety, or rights notes |

Do not release an image with unknown generation provenance or unresolved rights.
