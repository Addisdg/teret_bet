# Day and Bedtime Theme System

## Day mode

Day mode uses a warm terracotta seed and cream background rather than the
temporary teal baseline. Material 3 derives accessible surface, container,
outline, and control colors from that seed.

## Bedtime mode

Bedtime mode is a manual, persistent setting. It uses a dark charcoal-navy
background with warm low-glare accents and light text. It does not follow the
system clock, infer bedtime, or collect usage behavior.

The mode changes interface surfaces, navigation, cards, fields, and reader
chrome. Story illustrations retain their original colors and brightness, as
required by the product decision.

## Persistence and accessibility

The selected mode is stored in the existing on-device Hive settings box. No
account or cloud preference is created. Provider tests cover default,
persistence, and reset behavior. Widget tests run Flutter's text-contrast
guideline against both day and bedtime Settings surfaces.

Pixel 8a checks remain required for illustration glare, real-device contrast,
maximum text size, and comfortable shared reading in a dark room.

## Typeface boundary

This batch does not bundle a font. The app still requests Noto Sans Ethiopic
and relies on platform fallback until a specific font file, license, weights,
and size impact are reviewed and approved.
