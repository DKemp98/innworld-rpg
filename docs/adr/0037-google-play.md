# ADR 0037: Google Play preparation

Status: accepted (2026-10-11)

## Context
The user wants the game on Google Play. Play takes only an Android App Bundle (AAB), built with Gradle. New apps
must target API 36 (from 2026-08-31). The game uses pirateaba's world, and the fanworks policy does not name games
(`docs/DESIGN.md` section 7). Play removes apps that use another person's work without permission.

## Decision
- The user picked: build everything now, upload only after pirateaba says yes in writing.
- New export preset `Android Play` (Gradle build, AAB, target SDK 36, arm64-v8a, same package and version as
  `Android`). The old `Android` preset (no Gradle) still makes the GitHub apk.
- The Gradle template (`game/android/`) is gitignored (user pick). `tools/release.ps1` installs it when missing and
  sets `org.gradle.jvmargs=-Xmx2g`: the default 4.5 GB made the Gradle JVM run out of memory on a 16 GB PC.
- Play App Signing: Google keeps the app signing key; our release keystore is the upload key.
- Store kit: `docs/PLAY_STORE.md` (steps, listing text, form answers), `PRIVACY.md` (no data collected),
  `tools/build_store_art.py` (feature graphic 1024 × 500, 32-bit icon, screenshots 2x) into `export/play/`.
- Target audience 16+ so the Families policy does not apply.

## Consequences
- Each Play upload needs a higher `version/code` in both Android presets.
- The Play app and the GitHub apk have different signatures: a player can not update one with the other.
- With API 36, Android ignores the landscape lock on large screens (600 dp and up). A tablet check is open.
