# Soft Margin

A complete offline teacher for movement, attention, breath and rest. Ten original sessions, five short lessons, three breathing patterns and a private journal.

Complete onboarding, walk the session on Walk, run Four columns, browse or search Range and save a Tablet note. Walk includes shortcuts to Range and Tablet. All lessons, preferences, practice history and notes stay on the device. No account, login, cloud sync or remote AI.

App identity: `com.app.softmargin.build`. Metadata: `com.app.softmargin.build.json`. Existing SQLite filenames are retained for compatibility with existing data when upgrading the same installation.

Run `flutter analyze` and `flutter test` at the package root. In `example`, run widget tests or `flutter test integration_test/plugin_integration_test.dart -d <simulator-id>`.

Verified: static analysis clean; 18 package tests, 2 example widget tests and 1 iOS integration test pass. The integration test covers onboarding, Walk completion, Four columns controls, Range, saving a Tablet note and reading it after rebuilding the app. Separate timer tests complete all four breath rounds. Simulator onboarding preview: `srcs/soft-margin-preview.png`.

The externally hosted support and privacy URLs are preserved. The current privacy URL refers to Cadence Room; publish or provide a Soft Margin policy before store submission. No store submission was performed.

Icon generated using built-in ImageGen. Source: `assets/soft_margin_app_icon.png`. Production master: `assets/app_icon.png`; all iOS app icon sizes derive from this master.

Icon prompt: “Use case: logo-brand. Create a square full-bleed app icon for Soft Margin, a private offline practice teacher. One sculptural folded ribbon of thick terracotta paper forming a stepped open book and abstract S negative space. A small warm ochre folded corner. Dark burgundy #542D35 and terracotta #A54C39 paper planes, pale warm parchment #F5EBDD background filling all corners. Swiss editorial restraint, crisp origami geometry, slight tactile grain and soft physical shadow, centered bold silhouette readable at 32px. Flat front three-quarter view, generous margins. No text, letters, numbers, leaves, rings, circle motifs, watermark, border, or rounded outer corners. Opaque square 1024x1024.”
