# Melody Match 2.0

An offline Flutter instrument-matching game inspired by the supplied reference.
`UserScreen` and the game entry point remain in `lib/main.dart`.

## Screens and features

- **Home:** continue the journey, open Daily encore or start untimed Free play.
- **Journey:** 24 levels in three venues, sequential unlocks, best scores and up to three stars per level. Each level has a shorter countdown.
- **Game:** 16 tiles, matching, time bonuses, pause/resume, hints, shuffle, a ten-second time freeze, automatic matching, sound toggle and confirmed restart.
- **Daily encore:** a date-seeded board, 90-second countdown and a 150-coin first-win bonus once per local date.
- **Free play:** an untimed board; Freeze is disabled.
- **Collection:** discover eight instruments and open an educational detail page for each.
- **Quests:** five lifetime milestones with rewards that can be claimed once.
- **Shop:** buy boosters with earned coins; insufficient balances disable buying. No real-money purchases.
- **Settings:** sound, statistics, instructions, save status and confirmed progress reset.

Progress is saved in `melody_match_v1.db`, separate from the previous app's database. Saved data includes coins, boosters, unlocked levels, stars, best scores, collected instruments, claimed rewards, daily completions and sound settings. An unfinished board starts over when reopened. There is no account or cloud backup. Instrument artwork uses system emoji and varies by platform; audio uses system click feedback.

## Run

```sh
cd example
flutter pub get
flutter run
```

The example host imports the public `UserScreen` export. The iOS display name is Melody Match. The bundle ID is `com.app.melodymatch.build` (including Debug, Profile and Release configurations). RunnerTests uses the matching `.RunnerTests` suffix. The app icon is the new paired-violin artwork in `assets/melody_match_app_icon.png`; `assets/app_icon.png` and every native iOS icon size derive from this opaque 1024 × 1024 master.

## Source layout

- `lib/main.dart`: UserScreen, playable board and shared visual widgets.
- `lib/src/melody/melody_hub.dart`: home, navigation and the additional screens (part of the main library).
- `lib/src/melody/progress.dart`: progression rules and serialized SQLite storage.
- `lib/user_screen.dart`: public entry-point exports.

Previous Ember Atlas source remains in the repository, but is not exposed in Melody Match navigation.

## Metadata

`com.app.melodymatch.build.json`, `meta-data-apple-store.txt` and `APPLE_REVIEW_NOTES.txt` describe Melody Match 2.0.0. Metadata uses the new bundle identity. Contact information and existing support/privacy URLs are preserved. The privacy URL still points to the existing Ember Atlas page; that external page was not edited. No store submission was performed.

## Validation

```sh
flutter analyze
flutter test
cd example
flutter test
flutter test integration_test/plugin_integration_test.dart -d <simulator-id>
```

Tests cover gameplay, layout on small/landscape/tablet screens with enlarged text, navigation, progression, rewards, purchases, storage recovery and reset. The native integration test uses a separate test database to verify SQLite persistence without resetting normal gameplay data.

## App icon

Created with the built-in ImageGen tool. The final generation prompt is saved in `assets/melody_match_app_icon.prompt.txt`. All PNG variants in the iOS AppIcon asset catalog have been regenerated. The runnable native host in this repository is iOS; no Android app project is currently configured.
