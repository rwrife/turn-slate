# Turn Slate

Offline tabletop encounter board: game masters track initiative, rounds, conditions, and resource counters across phones, tablets, and Windows without accounts.

## Why / who

During tabletop encounters, paper initiative lists obscure whose turn comes next and when conditions expire. Turn Slate gives game masters a private, readable encounter clock for in-person sessions. It does not replace a ruleset or automate combat.

## Intended workflow

1. Create a named encounter with ordered participants; manually set or roll outside the app and enter initiative numbers. Break ties with explicit drag order.
2. Advance, skip, or rewind turns with confirmation; mark conditions with a remaining-turn or remaining-round counter, or no timer. Show whose clock decrements each condition.
3. Track optional resource counters, edit them manually, pause, then resume a saved encounter. End encounter without deleting its record.
4. Export a human-readable encounter summary or versioned JSON backup to user-selected storage; preview before importing a backup.

Phone: focused current-turn card and next controls. Tablet: participant rail plus detail. Windows: resizable board with shortcuts, pointer controls, and always-visible roster. Touch and keyboard/mouse supported throughout.

## Status and milestones

**Early Flutter scaffold only.** Generated Windows, Android, and iOS folders exist; placeholder screen does not track encounters yet. `.github/workflows/ci.yml` gates Flutter 3.47.7 on Windows (including release build), Android (debug APK), and iOS (simulator compile). Widget smoke tests cover iOS, Android, Windows at phone, tablet, and desktop widths. `AppStore/description.txt` remains pre-release copy. Icon resources require release review; encounter logic, saves, adaptive board, backup and Windows packaging remain backlog work.

## Platforms and design

Flutter/Dart single codebase. Windows is primary CI and zipped portable `v*` release target; Android and iOS phones/tablets are committed build targets. iPad and Android tablet support enabled. Additional platforms uncommitted. UX strategy **B: fully custom branded UI**, not Material-on-iOS or Cupertino-on-Android; preserve OS back/scroll/dialog/file-picker behaviors, safe areas, font scaling, focus, selection, screen reader semantics, keyboard shortcuts, hover and contrast. Test `TargetPlatform.iOS`, `TargetPlatform.android`, `TargetPlatform.windows` at phone/tablet/desktop widths. No native Swift/Xcode-only, React Native, Expo, Kotlin Multiplatform, .NET MAUI, Unity rewrite.

Android applicationId, iOS bundle ID, and planned Windows identity: `com.infinityball.turnslate`.

## Privacy and permissions

Encounter data stays on device; no account, ads, analytics, tracking, network sync, microphone, or camera. Export/import only on explicit user action via system picker. Local storage and backup format arrive in later issues; no saved encounters exist in starter scaffold. This is a general tabletop aid, not a medical, gambling, or safety tool.

## App icon

`AppStore/icon.png` artwork is generated via OpenAI Images through spark-media; platform icon assets must derive from this opaque square master and be checked against release output. No textual marks or rounded corners baked into image.

## Quickstart

Pinned Flutter version in `toolchain.json`; from repository root run `flutter pub get --enforce-lockfile && flutter analyze && flutter test && flutter run -d windows` on Windows with Visual Studio C++ desktop tooling. Linux host can run Flutter tests with pinned 3.47.7 SDK. CI verifies native Windows release build, Android debug APK and unsigned iOS simulator compile; downloadable Windows release packaging is separate backlog work.

## Manual setup required

App Store Connect registration for `com.infinityball.turnslate` failed: `FAILED bundleId lookup rejected: FORBIDDEN_ERROR.PLA_NOT_ACCEPTED`. Account owner must accept current Apple Program License Agreement, then rerun `/home/rwrife/workspaces/tool-lab/asc_create_bundle_id.py turn-slate`. Four repository Actions secret **names** already configured: `ASC_KEY_ID`, `ASC_ISSUER_ID`, `ASC_KEY_P8`, `ASC_TEAM_ID`. No store upload until registration and signed build evidence.

## License

MIT; see `LICENSE`.
