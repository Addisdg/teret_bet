# Emulator Matrix — 2026-07-04

## Result

The current signed release APK passes the remaining small-phone,
minimum-supported-Android, and 10-inch-tablet runtime checks.

| AVD | Android | Display | Result |
| --- | ---: | --- | --- |
| `TeretBet_API24_Small` | API 24 / Android 7.0 | 720×1280, 320 dpi | Pass |
| `TeretBet_API35_Tablet` | API 35 | 1280×800, 160 dpi | Pass |

Windows Emulator 36.6.11 used Windows Hypervisor Platform successfully. The
AVD userdata lives under `D:\AndroidAVD` because C: did not have enough free
space for the generated partitions. System images remain in the normal Windows
Android SDK.

## API 24 small phone

- Release APK installed successfully.
- Clean first launch rendered the bilingual language chooser.
- With emulator network access disabled, the Amharic library loaded all 50
  bundled stories; a direct ping produced zero replies.
- The 720×1280 library retained search, collection, age/theme, story-count,
  story-card, favourite, and three-destination navigation controls.
- A story opened through details into the reader.
- Portrait reader artwork retained the complete composition.
- Longer Amharic text uses an independently scrollable text region while text
  sizing, page count, Back, and Next controls remain fixed and reachable.
- First cold activity launch measured 6,446 ms on this old emulated guest. This
  is diagnostic evidence, not the physical-device performance gate; Pixel 8a
  remains the under-three-second target and already passes.

## API 35 10-inch tablet

- Release APK installed successfully.
- Wi-Fi was disabled before app data was cleared.
- Clean first launch rendered the centered bilingual language chooser; direct
  network access reported `Network is unreachable`.
- The Amharic library loaded all 50 bundled stories.
- The 1280×800 library rendered five columns. Ten story-card semantics were
  visible across the first two rows, with the first five full cards on screen.
- Story details and Start remained reachable.
- Landscape reader visually passed: full illustration on the left, readable
  Amharic text on the right, and fixed text-size, page, Back, and Next controls.
- First cold activity launch measured 11,171 ms while the large tablet AVD used
  SwiftShader and a wiped data image. It is not treated as physical performance
  evidence.

## ADB boundary lesson

Windows emulators cannot register while `localhost:5037` is owned by the WSL
ADB server used for the USB-attached Pixel. For emulator runs:

1. Stop the WSL ADB server.
2. Start the Windows SDK's `adb.exe` server.
3. Launch the Windows AVD and validate it through Windows `adb.exe`.
4. Kill the AVDs and Windows ADB server.
5. Restart the WSL ADB server before reconnecting the Pixel.

The initial guests were healthy but invisible until this ownership conflict was
resolved. Do not diagnose that symptom as a failed Android boot without first
checking which ADB server owns port 5037.

## Artifacts and cleanup

Temporary deployment and screenshots were staged in `D:\TeretBetEmulator` and
were not added to the repository or promoted as Play Store assets. Both AVDs
were shut down cleanly after validation. The WSL ADB server was restored; the
physical Pixel was not attached at the end of this run and can be reattached by
the existing USBIP workflow when needed.
