# Discovery Filters

## Age bands

Teret Bet exposes overlapping family-friendly age bands:

- Ages 3-4
- Ages 5-6

A story matches when its declared age range overlaps a selected band. Selecting
both bands shows stories matching either band rather than requiring a story to
belong exclusively to one group.

## Themes

Theme options come from the loaded catalogue metadata. Multiple selected themes
use match-any behavior so families can browse broadly. Common themes have
Amharic display labels; unknown future tags remain readable as title-cased
metadata until editorial localization is added.

## Combined filtering

Age and theme selections combine with search, collection, and favourites.
Within age selections and within theme selections the behavior is match-any;
between filter categories the behavior is match-all. The active count is shown
on the filter button, and Clear filters resets every category.

## Verification

Provider tests cover age overlap, multiple-band broadening, theme filtering,
active counts, and clearing without changing the catalogue records.
