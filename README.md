# OptiLife

> Level up your life, one quest at a time.

OptiLife is a gamified self-improvement app. Each day you roll a few **side
quests**; completing them earns **Life Energy (LE)**, which levels you up. Every
level-up lets you **plant a tree** in your isometric **biome**. Fill the biome
(100 trees) and you "reboot" it — a fresh world — teaching the art of letting
go. Alongside quests there are **habits** (good/bad, +2⚡ each) and a daily
**journal**, plus **analytics** and a **PDF journal export**.

Fully **offline / local-first** — all data lives in an on-device SQLite
database. No accounts, no backend, no network calls (except opening the online
guide in a browser).

- **Bundle / application id:** `com.dreamscape.optilife`
- **Online guide:** https://optilife-web.netlify.app/guide
- _Dreamy · Projekt Dreamscape_

---

## Tech stack

| Concern | Choice |
|---|---|
| Framework | Flutter (Dart SDK `^3.11.1`) |
| State | Riverpod (`flutter_riverpod`) |
| Local DB | Drift over SQLite (`drift`, `sqlite3_flutter_libs`) |
| Biome rendering | Flame + `flame_svg` (2.5D isometric) |
| Vector art / icons | `flutter_svg` |
| PDF export | `pdf` + `printing` |
| Notifications | `flutter_local_notifications` + `timezone` + `flutter_timezone` |
| Misc | `url_launcher` (guide), `gal` (save biome photos), `path_provider`, `uuid` |
| Visuals | Custom `CustomPainter` charts/animations + `AnimationController` (POP design system) |

## Project structure

```
lib/
  main.dart            # entry; initializes notifications, then runs the app
  core/                # enums, date utils, LE math, limits
  data/                # Drift tables, database, game_repository, seed quests
  state/               # Riverpod providers (app_providers.dart)
  screens/             # app_shell + Side Quests, Tasks, Journal+Habits,
    biome/             #   Biome (Flame), Workshop, Settings, Analytics
  services/            # notifications.dart
  theme/               # tokens, colors, typography, app_assets (POP design system)
  widgets/             # shared UI (DayPager, modals, charts, tutorial, export…)
assets/
  icon/   trees/   illustrations/   icons/   fonts/
design-docs/           # quest_pool.md (curated preset quests)
ui-design-docs/        # full design system + per-screen specs
```

## Getting started

Prerequisites: Flutter SDK, and a JDK for Android builds (the one bundled with
Android Studio at `/Applications/Android Studio.app/Contents/jbr/Contents/Home`
works).

```bash
flutter pub get
dart run build_runner build      # generate Drift code (database.g.dart)
flutter run                      # launch on a connected device / simulator
```

> The DB schema is a clean **v1** (migrations were squashed pre-release). If you
> have an old install from development, **uninstall it first** — the app can't
> downgrade an older on-device schema.

Verify changes with `flutter analyze`.

## Building

```bash
flutter build apk --release       # Android APK
flutter build appbundle --release # Android App Bundle (.aab)
flutter build ios --release       # iOS (then archive in Xcode)
```

### Android release signing

Release builds are signed with a real keystore **when `android/key.properties`
is present**; otherwise they fall back to debug keys (so a fresh clone still
builds). To set up signing:

1. **Generate a keystore** (kept outside the repo):
   ```bash
   mkdir -p ~/keystores && "/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/keytool" -genkey -v \
     -keystore ~/keystores/optilife-release.jks \
     -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. **Create `android/key.properties`** from the template:
   ```bash
   cp android/key.properties.example android/key.properties
   ```
   then fill in `storePassword`, `keyPassword`, `keyAlias=upload`, and the
   absolute `storeFile` path.

`android/app/build.gradle.kts` auto-detects the file and signs `--release` with
it. `key.properties`, `*.jks`, and `*.keystore` are gitignored.

> ⚠️ **Back up the keystore + passwords.** Lose them and future builds get a
> different signing identity → updates won't install over an existing app
> (Android wipes the old app + its local data on reinstall).

> Note: a self-signed sideloaded build still triggers Google **Play Protect**'s
> "unrecognized app" prompt — signing doesn't bypass that (only distribution
> through Play does). Tap "install anyway" when sideloading.

## App icon & splash

The master is `assets/icon/app_icon.svg` (the OptiLife logo). PNGs in
`assets/icon/` feed the generators:

```bash
dart run flutter_launcher_icons         # launcher + adaptive + web icons
dart run flutter_native_splash:create   # native splash screens
```

Icon/splash are baked at build time — a **full rebuild/reinstall** is needed to
see changes (hot reload won't show them).

## Notifications

Two optional daily local reminders (morning quests, evening journal) at
user-picked times, toggled in **Settings → Notifications**. Scheduling lives in
`lib/services/notifications.dart` (initialized in `main()`); times are stored in
`settings`. No push server — everything is local.

## Quests

The starter pool of preset quests lives in `lib/data/seed_quests.dart` (seeded
on first launch only). The curated source list + tone notes are in
`design-docs/quest_pool.md`.

## Design docs

`ui-design-docs/` holds the full POP design system and per-screen specs
(side quests, biome, tasks, journal+habits, navigation, motion, assets).
