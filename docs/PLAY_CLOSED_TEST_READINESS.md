# Google Play Closed-Test Readiness

Last policy check: 2026-07-04. Recheck every linked Google requirement before
upload because Play policy and Console wording can change.

## Release posture

Teret Bet is a parent-operated storybook for children ages 3-6. Version 1 has
no ads, purchases, accounts, analytics, crash reporting, social features, user
content, location, camera, or microphone access. Reading history, favourites,
language, settings, and position stay on the device, with Android backup and
device transfer disabled. Firestore is used only to read the public story
catalogue; bundled JSON and images provide offline fallback.

The intended Play target audience is **Ages 5 and under**. The owner must confirm
the exact Console selection before submission. Teret Bet should not add older
age groups merely because parents operate the app: the content is designed for
young children and therefore must comply with the Families Policy.

## Current official requirements

- New personal developer accounts created after 13 November 2023 must run a
  closed test with at least 12 testers continuously opted in for 14 days before
  applying for production access. Confirm whether this account rule applies in
  the Play Console dashboard.
- Closed-test users need Google or Google Workspace accounts. Each person must
  join through the opt-in link; being present in an email list is not enough.
- Data safety is required for closed, open, and production tracks. Even an app
  declaring no collection or sharing must complete the form and provide a
  privacy-policy URL. Internal-only testing is exempt from the Data safety form.
- Apps including children in their audience must accurately complete Target
  audience and content, Data safety, and the IARC content-rating questionnaire.
- The privacy policy must be publicly accessible, non-geofenced, non-editable,
  and served as a web page rather than a PDF. It must identify Teret Bet or the
  developer identity shown in the store listing.

Official references:

- [New personal-account testing requirements](https://support.google.com/googleplay/android-developer/answer/14151465?hl=en)
- [Set up internal and closed tests](https://support.google.com/googleplay/android-developer/answer/9845334?hl=en)
- [Data safety form](https://support.google.com/googleplay/android-developer/answer/10787469?hl=en)
- [Google Play Families Policy](https://support.google.com/googleplay/android-developer/answer/9893335?hl=en)
- [Target audience guidance](https://support.google.com/googleplay/android-developer/answer/9867159?hl=en)
- [User Data and privacy-policy requirements](https://support.google.com/googleplay/android-developer/answer/10144311?hl=en)

## Provisional Console declaration map

These are preparation notes, not authorization to submit answers.

| Console area | Provisional answer | Evidence / remaining check |
| --- | --- | --- |
| App name | Teret Bet | Public-facing name approved; Android label matches. |
| Target audience | Ages 5 and under | Product is designed for ages 3-6; confirm Console grouping. |
| Ads | No | No ads dependency or ad UI. Recheck uploaded AAB. |
| App access | All functionality available without login | No authentication or restricted area. |
| Data collection | No user data collected or shared | Local reading state stays on device. Confirm Firebase/SDK network behavior against the exact Data safety definitions. |
| Location | Not collected; not requested | No location permission or feature. Recheck merged release manifest. |
| Device identifiers | Not collected | No `AD_ID` or telephony permission in the current merged release manifest. Recheck uploaded AAB and SDK disclosures. |
| Children/families | Yes; comply as child-directed | Content, interaction, data, and store assets require Families review. |
| Social/user content | None | No communication, sharing, profiles, or uploads. |
| Purchases | None | No billing dependency or purchase flow. |
| Content rating | Complete accurately in Console | Story conflict is softened for ages 3-6, but all 50 stories require editorial sign-off before final answers. |

Firebase network access must be described accurately in the privacy policy even
if it does not meet Google's definition of collecting user data. Do not promise
that no network request occurs.

## Entry gates before internal testing

- [ ] All 50 stories have completed editorial, age-fit, provenance, and artwork review.
- [ ] `dart run tool/catalog_qa.dart` passes.
- [ ] `flutter analyze` and `flutter test` pass.
- [ ] Strict release preflight passes with the intended Firebase configuration.
- [ ] Preflight confirms no prohibited ad/analytics/auth/crash SDK or sensitive
      child-directed permission has entered the signed release inputs.
- [ ] Signed release AAB builds and its merged manifest/SDK list is audited.
- [ ] Pixel 8a, small-phone, API-24, and tablet checks are complete.
- [ ] Privacy policy text is approved and hosted at a stable public URL.
  Start from `PRIVACY_POLICY_DRAFT.md`; do not publish it with placeholders.
- [ ] Dedicated support email exists and its retention process is documented.
- [ ] Store listing, screenshots, icon, feature graphic, and content declarations are ready.
  Use `PLAY_STORE_LISTING_DRAFT.md` for bilingual copy and the capture brief.
- [ ] A parent-only feedback channel is available; it requests no child identity.

## Closed-test cohort

Recruit at least 15 adults so normal attrition does not drop the continuously
opted-in group below 12. Testers should be parents, caregivers, educators, or
trusted adults able to read with a child. Record only an anonymous tester code,
broad device class, Android version, languages exercised, and completion dates.

Do not record a child's name, email, birth date, photo, voice, exact location,
school, or free-form identifying details. Adults should paraphrase child
reactions and remove identifying information before submitting comments.

### Tester instructions

1. Join with the supplied Google Play opt-in link and remain opted in until the
   owner confirms the test is complete.
2. Install from Google Play, not from a separately shared APK.
3. Choose Amharic or English on first launch, then test switching languages.
4. Open at least five stories, including one longer story; turn every page in
   portrait and landscape.
5. Try search, age/theme filters, favourites, Continue Reading, history clear,
   text sizing, and bedtime mode.
6. Enable airplane mode, relaunch, and open previously unvisited bundled stories.
7. Report confusing language, cramped pages, mismatched art, frightening
   moments, inaccessible controls, blank images, crashes, or lost progress.
8. Submit feedback as an adult and do not include identifying child information.

### Feedback record

| Field | Entry |
| --- | --- |
| Anonymous tester code | |
| Device class / Android version | |
| Test dates | |
| Languages tested | Amharic / English / both |
| Stories completed | |
| Offline test passed | Yes / No |
| Accessibility settings used | |
| Crash, freeze, or blank screen | |
| Language/story-flow issue and page | |
| Illustration issue and page | |
| Child-safety or age-fit concern | |
| Navigation or readability issue | |
| Release blocker? | Yes / No |
| Adult tester's recommendation | Revise / Ready |

## Production-access evidence

Maintain a test log with the release version, start date, each anonymous
tester's opt-in confirmation, meaningful areas exercised, issue IDs, fixes, and
retest result. When applying for production access, answer from this evidence;
do not treat 12 passive opt-ins as sufficient product testing.

## Owner-controlled actions

The following remain intentionally unperformed: create or configure a Play app,
upload an AAB, submit policy declarations, create tester lists, contact testers,
purchase a domain, create a support mailbox, host the privacy policy, or apply
for production access.
