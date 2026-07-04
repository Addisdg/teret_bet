# Decision Log

Use this append-only log for product decisions that affect scope, content,
architecture, privacy, release, or collaboration.

| Date | Decision | Rationale and consequence |
| --- | --- | --- |
| 2026-07-02 | Android-first; Amharic and English at launch | Focus testing and release work while supporting diaspora families. |
| 2026-07-02 | Keep exactly 50 launch stories; at least 10 Ethiopian-origin | Catalogue breadth remains, but every story must pass the full release gate. |
| 2026-07-02 | Prioritise Amharic traditions while including wider Ethiopian communities | Regional origin must be precise and culturally reviewed. |
| 2026-07-02 | Use a two-source provenance preference | One credible source is mandatory; corroboration and community review reduce misattribution. |
| 2026-07-02 | Natural bilingual adaptations | Amharic and English must each read naturally and retain the same story beats. |
| 2026-07-02 | Story length is content-driven with no upper page limit | Continuity outranks a fixed page count; add matching art when pages grow. |
| 2026-07-02 | Text approval precedes final illustration generation | Avoid costly visual rework and lock page beats first. |
| 2026-07-02 | Balanced child/parent navigation | Children browse visually; parent tools remain accessible and unobtrusive. |
| 2026-07-02 | Discover, Favourites, Settings | History, continuation, search, and filters live within Discover. |
| 2026-07-02 | Same-page language switching persists globally | Switching language must not lose reading position. |
| 2026-07-02 | Latest 20 reading-history entries stay on device | Include completed and unfinished stories, with a clear-history action. |
| 2026-07-02 | Manual persistent bedtime mode | Dim interface colours without modifying illustrations. |
| 2026-07-02 | No accounts, ads, purchases, analytics, or crash SDK at launch | Minimise child-data and policy risk. |
| 2026-07-02 | Full first-launch offline catalogue | Installation alone must provide all story text and art. |
| 2026-07-02 | Freeze growth beyond 50 until release feedback is resolved | Protect editorial focus. |
| 2026-07-02 | Audio is post-launch and voice sourcing is undecided | Hide unfinished playback controls; preserve nullable metadata. |
| 2026-07-02 | Work in owner-approved five-story batches | Human approvals remain explicit; commits and remote actions require permission. |
| 2026-07-02 | Pixel 8a is the primary physical test device | Supplement with small-phone, older-Android, and tablet emulators. |
| 2026-07-02 | Teret Bet is the public-facing publisher name initially | Domain, support email, website, and privacy-policy hosting are pre-release tasks. |
| 2026-07-02 | Approve the five-story pilot selections | Draft three Ethiopian stories plus repairs of The Lion and the Mouse and Stone Soup; provisionally replace The Little Match Girl, The Steadfast Tin Soldier, and The Swineherd. |
| 2026-07-04 | Never use debug signing for release artifacts | Gradle release tasks fail when release credentials are absent; debug development remains available and preflight guards against regression. |
