# Font System

## Launch typeface

Teret Bet bundles **Noto Sans Ethiopic** as its application family. The single
variable TrueType asset supplies the regular (400), medium (500), and bold
(700) weights currently used by the interface and story reader. English text
uses the same family for a calm, consistent bilingual presentation.

Bundling the typeface prevents Amharic appearance and line metrics from changing
with the Android device's installed fallback fonts. It also keeps typography
available offline on first launch.

## Source and rights

- Source: Google Fonts repository, `ofl/notosansethiopic`
- Upstream file: `NotoSansEthiopic[wdth,wght].ttf`
- License: SIL Open Font License 1.1
- Repository asset: `assets/fonts/NotoSansEthiopic-Variable.ttf`
- License copy: `docs/licenses/NotoSansEthiopic-OFL.txt`
- Font SHA-256: `0dbccc00b22d180ebd6a4bd8a733918a29e709fa6798023adc3e6cd40da65077`
- License SHA-256: `72606b23f312cb25973958f2892d4d2c2012deabadbf0f763232624a9649fc69`

The font is redistributed unchanged. Any future replacement or modification
must preserve the applicable license and update these hashes and the visual QA
record.

## Verification

- Automated tests load the bundled font and confirm both themes request it.
- The 1,143,168-byte source asset is stored once in the release bundle even
  though three application weights map to it.
- The fresh release AAB is 119,865,456 bytes. Font bundling added 542,819 bytes
  to the prior AAB and 537,632 bytes to the Pixel 8a compressed download.
- The font-inclusive Pixel 8a download measures 75,359,671 bytes (75.4 MB),
  remaining below the provisional 100 MB target.
- Portrait, landscape, large-text, and bedtime-mode checks remain part of Pixel
  8a release QA.
- Amharic read-aloud review remains an editorial gate; a bundled font solves
  rendering consistency, not language accuracy.
