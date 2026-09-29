# Mosslight

A complete offline field guide for body awareness, movement, breathing, rest and private observations.

- Walk selects from ten original guided sessions using your intention, time, pace and recent practice.
- Four columns follows inhale / pause / exhale / pause with four rising columns. Soft current and Even leaves have no holds.
- Range includes category filters and five quick lessons with setup, breathing and alternatives.
- Rest contains Evening inventory and Moss rest.
- Tablet saves a prompt, mood, observation and timestamp to local SQLite storage.

No account, login, cloud sync, remote AI or network service is used by the Flutter app. Existing local database filenames are retained to preserve prior data when upgrading the same installation.

The iOS example is configured as `com.app.mosslight.build`. Build metadata is in `com.app.mosslight.build.json`. App name, native icons, store copy and review instructions use Mosslight.

The support and privacy URLs in the metadata are externally hosted and were preserved. The privacy URL currently refers to STILLROOM; the owner needs to supply or publish a Mosslight policy URL before store submission. No submission was performed.

## Run and verify

From the package root: `flutter analyze` and `flutter test`.
From `example`: `flutter run`, `flutter test test/widget_test.dart`, or `flutter test integration_test/plugin_integration_test.dart -d <simulator-id>`.

## Icon provenance

Generated with the built-in ImageGen tool. Source: `assets/mosslight_app_icon.png`; 1024px production master: `assets/app_icon.png`. The iOS app icon sizes are derived from that master and have no alpha channel.

Prompt: “Use case: logo-brand. Create a square full bleed mobile app icon for Mosslight, a fully offline body-awareness and breathing teacher. A single luminous chartreuse folded leaf intersecting three fine concentric contour arcs, like sunlight finding a forest clearing. Deep solid evergreen background #102C26, chartreuse #DDF28B and ivory accents. Premium precise minimal graphic design, striking asymmetric leaf centered in generous negative space, tactile matte finish but bold silhouette readable at tiny size. Fill every corner with opaque evergreen, no rounded outer border, no text, no letters, no watermark. Output square 1024x1024.”
