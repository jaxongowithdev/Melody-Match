# Ember Atlas

A complete offline teacher with a three-station Walk, side navigation, expandable route collections, guided step checklist and full-screen journal editor.

Ten original four-step practices, five field skills and three breathing patterns are included. Complete onboarding, walk a session on Walk, run Four columns, open Range and save a Tablet note. Search notes by body, prompt or feeling. No account, login, cloud sync or remote AI.

Identity: `com.app.emberatlas.build`. Metadata file: `com.app.emberatlas.build.json`. All iOS app configurations use this bundle ID and the display name Ember Atlas. The SQLite filename is retained; a different bundle ID has a separate app sandbox. Existing note data is not deleted.

Run `flutter analyze` and `flutter test` at the root. Run widget tests in `example` and `flutter test integration_test/plugin_integration_test.dart -d <simulator-id>` for the native workflow.

Verification: static analysis is clean. All 38 package tests, 2 example widget tests and 1 iOS integration test pass. Coverage includes enlarged-text narrow/landscape layouts in both themes, the full note editor, completed session and breath timers, expandable Range lessons, drawer navigation, note creation/search and reading saved notes after rebuilding the app.

Native iPhone onboarding was visually checked. Preview: `srcs/ember-atlas-onboarding.png`.

External support and privacy URLs are preserved from the current metadata. The privacy URL still refers to Tideframe; provide or publish an Ember Atlas policy before store submission. No store submission was performed.

The icon was generated with the built-in ImageGen tool. Source: `assets/ember_atlas_app_icon.png`. Production master: `assets/app_icon.png`; all iOS icon sizes derive from it.

Final icon prompt: Use case: logo-brand. Asset type: opaque square iOS app icon for Ember Atlas, a private offline practice teacher. A single sculptural amber lantern formed from three stacked curved terracotta and golden stone arches, a glowing pale-gold diamond ember in its centre. Background is full-bleed warm charcoal #24231F, with a barely visible matte mineral texture. Frontal, symmetrical, bold minimal silhouette with generous margin, readable at tiny size. Material: satin carved stone with warm internal light, restrained soft shadow, contemporary and calm. No text, letters, numbers, waves, books, leaves, border, watermark, rounded outer corners, phone or mockup. 1024x1024.
