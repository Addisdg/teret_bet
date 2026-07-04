# Privacy and Content Rights

## Version 1 privacy baseline

Teret Bet requires no account and should collect no names, email addresses,
child profiles, birth dates, advertising identifiers, precise location,
contacts, photos, microphone data, or cloud reading history.

Favourites, reading position, language, settings, and the latest 20 history
entries remain on device. Version 1 contains no ads, purchases, analytics, or
crash-reporting SDK. Any future SDK requires a documented data-flow and child-
privacy review before dependency approval.

Release preflight enforces the current baseline by rejecting known advertising,
analytics, authentication, crash-reporting, and tracking packages, plus Android
advertising-ID, location, camera, microphone, contacts, phone, and Bluetooth-scan
permissions. This guard supplements rather than replaces review of the exact
signed artifact and provider disclosures.

Android application backup is explicitly disabled. Reinstalling Teret Bet must
not restore favourites, reading history, language, settings, or reading position
from Android cloud backup or device-transfer state. This keeps the stated local-
only model accurate and ensures a genuine new installation asks for language.

Implemented history records contain only story ID, last page, page count,
completion state, and UTC last-read time. Families can clear all history from
the library after a confirmation step.

## Pre-release privacy register

| Component | Data handled | Location | Third party | Release action |
| --- | --- | --- | --- | --- |
| Hive preferences | Favourites, history, position, language, settings | Device; Android backup disabled | None | Verify deletion/clear controls |
| Firestore story reads | Public catalogue request | Firebase | Google | Document network access and configuration |
| Feedback form | Parent ratings and optional comments | To be selected | To be selected | No child identity; publish retention rules |
| Support email | Parent support correspondence | To be selected | Email provider | Publish contact and retention process |

Before Play release, verify current Google Play Families, Data safety, COPPA,
GDPR, and applicable regional requirements with appropriate professional advice.

## Content-rights gate

- Record the traditional/public-domain basis and the modern sources consulted.
- Write new Amharic and English expression; do not copy protected translations.
- Record permission or licence for every non-public-domain reference.
- Do not copy source illustrations, character designs, prompts, or branded
  additions.
- Record AI image tool/model, prompt, date, reference rights, edits, and review.
- Treat unknown rights or unknown provenance as release-blocking.

## Public documents required before release

- Complete `PRIVACY_POLICY_DRAFT.md`, then publish it at a stable public URL.
- Dedicated Teret Bet support email.
- Simple public website.
- Accurate Play Data safety declaration and Families-policy responses.
- Content/provenance acknowledgements where licences or permissions require them.
