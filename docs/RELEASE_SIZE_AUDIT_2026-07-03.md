# Release Size Audit — 2026-07-03

## Fresh build results

| Artifact | Build | Result |
| --- | --- | ---: |
| Pixel 8a analysis bundle | `flutter build appbundle --release --analyze-size --target-platform android-arm64` | 147.5 MB |
| Normal Play upload bundle | `flutter build appbundle --release` | 181,025,712 bytes (181.0 MB as reported by Flutter) |

Both builds compiled the current product shell successfully. The arm64 size
analysis reported:

- compressed assets: 122 MB;
- native libraries: 8 MB;
- dex: 723 KB;
- Dart application code: approximately 99 KB;
- debug-symbol bundle metadata: 9 MB;
- obfuscation metadata: 1 MB.

The analysis snapshot was written outside the repository to
`~/.flutter-devtools/aab-code-size-analysis_01.json`.

## Illustration evidence

- 585 bundled story WebP files
- 127,113,070 raw bytes
- 217,287-byte average
- 92 files above 300 KB
- 15 files above 400 KB
- no byte-identical WebP duplicate groups

Largest story image sets:

| Story ID | Images | Raw bytes |
| --- | ---: | ---: |
| `goldilocks_three_bears` | 12 | 3,981,678 |
| `rapunzel` | 12 | 3,802,450 |
| `jack_and_beanstalk` | 15 | 3,484,664 |
| `sleeping_beauty` | 13 | 3,479,740 |
| `puss_in_boots` | 14 | 3,403,880 |
| `fir_tree` | 12 | 3,258,632 |
| `selfish_giant` | 13 | 3,239,344 |
| `magic_porridge_pot` | 12 | 3,145,948 |

Assets, not Dart code or native dependencies, dominate the bundle. Blind code
minification or dependency removal cannot close the size gap.

## Build stability

The previous Gradle configuration reserved an 8 GB heap plus 4 GB metaspace in
a WSL environment with approximately 7.7 GB total RAM. Release packaging was
killed by the host. The repository now limits Gradle to a 2 GB heap, 768 MB
metaspace, 128 MB code cache, and one worker. The normal multi-ABI AAB then
completed in 98.6 seconds.

## Decision boundary

No illustrations were recompressed, resized, removed, or replaced in this
audit. Reaching a provisional 100 MB upload target would require material asset
change and visual comparison, not a harmless cleanup. Before that work:

1. measure Play Console delivered download size and device splits;
2. choose a representative high-detail and low-detail image sample;
3. compare dimensions and WebP quality settings on Pixel 8a;
4. approve a maximum visible-quality loss;
5. optimize in a reversible batch and rerun catalogue/image QA.

The 100 MB target remains unmet and visible; release size is not claimed ready.
