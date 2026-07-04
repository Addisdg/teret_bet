# Google Play Store Listing Draft

Status: **Copy and asset brief only. Do not submit before the release gates pass.**

Last requirements check: 2026-07-04. Google currently limits the app name to
30 characters, short description to 80, and full description to 4,000. Recheck
the Console before upload.

Official references:

- [Create and set up a store listing](https://support.google.com/googleplay/android-developer/answer/9859152?hl=en)
- [Preview-asset requirements](https://support.google.com/googleplay/android-developer/answer/9866151?hl=en)
- [Store-listing best practices](https://support.google.com/googleplay/android-developer/answer/13393723?hl=en)

## Recommended listing setup

- Public name: `Teret Bet` in English and `ተረት ቤት` in Amharic.
- Recommended category: **Books & Reference**, because version 1 is a story
  library rather than a curriculum or scored learning product. Owner/Console
  review must confirm the category.
- Recommended primary listing language: Amharic, with a complete English
  localization. Confirm Play Console support and diaspora discoverability
  before selecting the default locale.
- Contact email and website: `[REQUIRED BEFORE CLOSED TEST]`.
- Privacy-policy URL: `[REQUIRED BEFORE CLOSED TEST]`.

## Amharic listing

### App name — 6 characters

`ተረት ቤት`

### Short description — 46 characters

`ለቤተሰብ ንባብ የተዘጋጁ በአማርኛና በእንግሊዝኛ የቀረቡ ሥዕላዊ ተረቶች።`

### Full description — draft for owner language review

ተረት ቤት ከ3-6 ዓመት ልጆች ጋር ለቤተሰብ ንባብ የተዘጋጀ የሥዕል ተረት መድብል ነው።

ታሪኮቹን በአማርኛ ወይም በእንግሊዝኛ ያንብቡ። በታሪኩ መካከል ቋንቋ ሲቀይሩ በዚያው ገጽ መቀጠል ይችላሉ።

ተረት ቤት የሚያቀርባቸው፦

- 50 ሥዕላዊ ታሪኮች
- የአማርኛና የእንግሊዝኛ ንባብ
- ታሪክ ፍለጋ እና በዕድሜና በጭብጥ ማጣሪያ
- የተወደዱ ታሪኮች እና ንባብን ካቆሙበት ገጽ መቀጠል
- የጽሑፍ መጠን ምርጫ እና የመኝታ ሰዓት ሁነታ
- ያለ ኢንተርኔት የሚከፈቱ በመተግበሪያው የተካተቱ ታሪኮች

መተግበሪያው ማስታወቂያ፣ የመተግበሪያ ውስጥ ግዢ ወይም የተጠቃሚ መለያ የለውም። የተወደዱ ታሪኮች፣ የንባብ ታሪክ እና ቅንብሮች በመሣሪያው ላይ ብቻ ይቀመጣሉ።

ተረት ቤት ልጆች ከወላጅ ወይም ከእንክብካቤ ሰጪ ጋር ተረት የሚጋሩበትን ረጋ ያለ ጊዜ ለመደገፍ የተዘጋጀ ነው።

## English listing

### App name — 9 characters

`Teret Bet`

### Short description — 72 characters

`Illustrated Amharic and English stories for calm family read-aloud time.`

### Full description

Teret Bet is an illustrated story library designed for families reading with
children ages 3-6.

Read each story in Amharic or English. Switch languages while reading and stay
on the same page.

Teret Bet includes:

- 50 illustrated stories
- Amharic and English reading
- Search plus age and theme filters
- Favourites and Continue Reading
- Adjustable text size and a calm bedtime mode
- Bundled stories that remain available without an internet connection

There are no advertisements, in-app purchases, or user accounts. Favourites,
reading history, and settings remain on the device.

Teret Bet is made to support calm, shared story time between young children and
their parents or caregivers.

## Graphic-asset inventory

### Play app icon

- Requirement: 512×512, 32-bit PNG with alpha, no larger than 1,024 KB.
- Approved design source candidate:
  `assets/images/branding/app_icon_source.png` (1254×1254 RGB PNG).
- Export a dedicated Play icon from the source; do not upscale the Android
  192×192 launcher file.
- Check the final export at small size and against light/dark Play surfaces.

### Feature graphic

- Requirement: 1024×500 JPEG or 24-bit PNG without alpha.
- Direction: a warm Teret Bet reading scene using the existing sunrise,
  open-book, and home visual language; one calm Ethiopian family-reading cue;
  generous safe space; no tiny story details.
- Avoid ranking, price, Play badges, third-party characters, or claims not
  present in the release.
- Keep branding complementary to the icon rather than repeating a large icon.

### Phone screenshots

Capture at least six clean 1080×1920 portrait screenshots from the exact signed
release build. Use real in-app UI without device frames or added promotional
claims. Prepare separate Amharic and English sets.

1. Amharic Discover library — establishes the 50-story illustrated catalogue.
2. Story details — shows age, theme, summary, and parent-facing context.
3. Portrait reader — demonstrates large illustration and comfortable text.
4. Landscape reader — demonstrates full-composition artwork and reachable controls.
5. Search and age/theme filters — demonstrates finding an appropriate story.
6. Favourites or Continue Reading — demonstrates private on-device continuity.
7. Settings — optional evidence for language, text size, and bedtime mode.

First-three priority: library, portrait reader, and story details. Do not show
unfinished provenance, draft text, placeholder support details, notifications,
real tester information, debug banners, or network errors.

### Tablet screenshots

If tablet distribution remains enabled, capture at least four 16:9 landscape or
9:16 portrait screenshots between 1080 and 7680 pixels. Use the final tablet
emulator/device after responsive validation; widget-test images are not store
evidence.

Recommended set: five-column library, landscape reader, story details, and
settings/discovery filters.

### Alt text

Provide concise alt text (140 characters or fewer) for every graphic. Drafts:

- Library: `Teret Bet story library showing illustrated Amharic story cards and search controls.`
- Reader: `An illustrated children's story open in the Amharic reader with page controls.`
- Details: `Story details showing age guidance, theme, summary, and reading button.`
- Filters: `Age and theme controls for choosing an appropriate family story.`
- Favourites: `Saved family stories available from the Favourites destination.`
- Settings: `Language, text size, and bedtime display settings in Teret Bet.`

## Capture gate

- [ ] All displayed story text and artwork are release-approved.
- [ ] Exact signed candidate build is installed cleanly.
- [ ] Status bar contains no personal carrier, notification, or tester data.
- [ ] Amharic and English localized sets use the same feature order.
- [ ] Phone images meet 9:16 and minimum-1080 recommendation.
- [ ] Tablet images come from a validated tablet runtime.
- [ ] Every screenshot accurately represents functionality available at launch.
- [ ] Owner approves copy, image selection, ordering, and alt text.
