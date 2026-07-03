# Image Optimization Pilot — 2026-07-03

## Purpose and safety boundary

The release audit showed that compressed assets account for 122 MB of the
arm64 bundle. This pilot measured reversible WebP alternatives in `/tmp` only.
No repository illustration was resized, recompressed, replaced, or deleted.

## Catalogue baseline

- 585 WebP illustrations
- 1200 x 900 pixels each
- 127,113,070 raw bytes total
- 217,287-byte average
- no byte-identical duplicate groups

## Full-catalogue measurements

| Option | Image bytes | Saved bytes | Saved | Projected normal AAB | Projected arm64 bundle |
| --- | ---: | ---: | ---: | ---: | ---: |
| Current 1200 x 900 | 127,113,070 | — | — | 181,025,712 | about 147.5 MB |
| 1200 x 900, WebP quality 80 | 98,665,194 | 28,447,876 | 22.38% | about 152.6 MB | about 119.1 MB |
| 960 x 720, WebP quality 80 | 65,424,746 | 61,688,324 | 48.53% | about 119.3 MB | about 85.8 MB |

Every image was smaller under both quality-80 options. Projections subtract raw
asset savings from measured bundles; a real post-change AAB is still required.

## Representative visual sample

The seven-image sample covered:

- three dense, high-byte story pages with hair, foliage, flowers, wood, and
  fabric detail;
- three representative international covers;
- one African folktale cover with multiple characters and patterned clothing.

At 1200 x 900 quality 80, sample savings ranged from 7.0% to 48.2%. SSIM ranged
from 0.958557 to 0.990313. Side-by-side inspection showed no meaningful change
at normal reading size.

At 960 x 720 quality 80, sample savings ranged from 38.2% to 64.9%. After
scaling back to the original dimensions for comparison, SSIM ranged from
0.928174 to 0.961557. Side-by-side inspection remained close, but fine detail
loss is more plausible and requires Pixel 8a review.

Quality 75 was rejected as the default recommendation. It saved more bytes but
consistently reduced structural similarity compared with quality 80.

## Recommendation

Use a two-gate optimization batch:

1. Put a representative 960 x 720 quality-80 sample on the Pixel 8a and compare
   faces, hair, patterned clothing, foliage, and low-contrast bedtime viewing.
2. If approved, replace the catalogue mechanically in a reversible branch,
   retain filenames and story mappings, and run image, catalogue, app, and
   release-bundle QA.

The 960 x 720 option is recommended for review because it is the first measured
option projected below 100 MB for the Pixel arm64 delivery. It does not project
the normal multi-ABI upload below 100 MB, so the project must distinguish Play
delivered download size from upload bundle size.

## Approval required

Repository image replacement remains explicitly unapproved. Owner visual
approval is required before applying either option to bundled illustrations.
