# Turn Slate — plan

## Scope and architecture

Flutter 3.47.7 / Dart version from pinned SDK; single Dart encounter domain with deterministic ordered participant list, current actor index, round count, condition timers and explicit turn history for undo. Versioned JSON snapshots stored locally; UI consumes domain state. Avoid auto-resolving tabletop rules: users own initiative ties, condition expiration convention and counters. No server, account, subscriptions or ruleset integration.

## Platform choice

Windows desktop primary build/release; Android and iOS phones and tablets committed targets. Adaptive widths: phone current-turn focus, tablet roster/detail, Windows resizable board and keyboard shortcuts. Pointer, touch and keyboard use same actions. UX strategy B — custom branded theme rendered with Flutter primitives, neither Material look on iOS nor Cupertino look on Android, nor phone chrome on Windows. Native behavior still required: system back, scrolling, safe areas, font scaling, OS file picker, selection/context actions, screen reader semantics, focus, contrast and hover.

## Dependency order

1. Generated Windows/Android/iOS Flutter scaffold (present); replace default counter and verify exact `com.infinityball.turnslate` IDs. Add Windows Actions CI and Android APK smoke; iOS compile on macOS runner when available.
2. Pure Dart encounter state machine and tests: stable initiative tie order, next/previous, round rollover, condition ticks with explicit owner/event semantics.
3. Local snapshot storage and resume with schema migrations; clear failure messages for corrupt data, no silent overwrite.
4. Phone/tablet/Windows UI; golden/widget tests on `TargetPlatform.iOS`, `TargetPlatform.android`, `TargetPlatform.windows` at 390, 800 and 1280 widths; accessibility audits and keyboard journey.
5. Export readable encounter summary and versioned JSON backup with preview/restore confirmation.
6. Review store copy and icon resource wiring. Generated `AppStore/icon.png` is master; prove Windows ICO, Android mipmaps and iOS app icons derive from it and contain no placeholder icons.
7. Release `.github/workflows/release.yml`: `v*` or manual dispatch, `windows-latest` Flutter test + `flutter build windows --release`, archive complete Release directory and attach zipped portable asset to GitHub release. TestFlight via ASC_KEY_ID, ASC_ISSUER_ID, ASC_KEY_P8, ASC_TEAM_ID and Android Play submission are later opt-in milestones.

## Data/privacy and accessibility

Encounter name, participant labels, order, conditions and counters stored locally; user explicitly chooses export/import destination. No network, ads, analytics or permissions except OS-selected files. Plain-language expiry semantics, high contrast, scalable text, focus order, screen reader turn announcements without speech permission. Backup restore preview and safe failure path. Treat labels as potentially sensitive support-export data; never send automatically.

## Verification

Docker-host `flutter pub get`, `flutter analyze`, `flutter test` with pinned version. Windows Actions `flutter test` plus Windows release build; Android debug APK build on Linux x86_64; iOS simulator compile on macOS when available. Do not equate Linux test with native Windows/iOS proof. Generated scaffold only has Flutter counter test currently. Document actual target and runner on every PR.

## Risks / non-goals

Condition timing varies between tabletop rules; display selected turn/round convention and require user control, not implicit combat rules. Undo needs bounded explicit history. Local data requires recovery export and restore tests. No dice physics, character sheets, campaign sync, remote multiplayer, medical/safety claims, or rulebook content. No native Swift/Xcode-only, React Native, Expo, Kotlin Multiplatform, .NET MAUI, Unity rewrite. Identifiers remain `com.infinityball.turnslate`. App Store Connect registration blocked by `FORBIDDEN_ERROR.PLA_NOT_ACCEPTED`; account owner must accept PLA before TestFlight.
