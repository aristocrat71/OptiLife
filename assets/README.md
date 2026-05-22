# OptiLife — Assets

Drop-in slots for app assets. Full specs in `../ui-design-docs/09-assets-iconography.md`.
Reference assets in code via `lib/theme/app_assets.dart` (`AppAssets.*`) — never raw path strings.

## What's wired ✅
- `fonts/` — **Fredoka, Nunito, Caveat, Lora** variable TTFs (real, OFL-licensed). Declared in `pubspec.yaml` and used by family name (`fontFamily: 'Fredoka'`).
- `trees/` — 6 **placeholder** category sprites (`tree_*.svg`). Foot-anchored, base = bottom-centre. Swap for real art (keep the names + the foot-anchor contract).
- `icon/app_icon.svg` — master app-icon design (POP heart).

## What you still need to add ✎
| Slot | File(s) | Spec |
|---|---|---|
| **App icon** | `icon/app_icon.png` (1024×1024, opaque) + `icon/app_icon_foreground.png` (transparent, for Android adaptive) | Export from `app_icon.svg`. Then `dart run flutter_launcher_icons`. |
| **Splash** | `icon/splash_logo.png` (~512px, transparent) | Then `dart run flutter_native_splash:create`. |
| **Category glyphs** | `icons/ic_cat_{adventure,fitness,social,creative,night}.svg` | 2px rounded-stroke, `currentColor`. |
| **System icons** | `icons/ic_*.svg` (calendar, bolt, heart, dice, check, shield, undo, plus, camera, world, chevron, trash, edit, font, settings, close, nav petals) | See manifest §1.2. |
| **Illustrations** | `illustrations/empty_*.svg`, `future_locked.svg`, `levelup_hero.svg`, `reboot_world.svg` | Chunky, outlined, POP-coloured. |
| **Tree sprites (real)** | `trees/tree_*.{svg or png + atlas}` — `idle` / `plant-in` / `ghost` states | Foot-anchored, ~62px footprint @1×. Rendered by Flame. |

## Generators (already configured in pubspec.yaml)
```bash
dart run flutter_launcher_icons          # app icon → all platforms
dart run flutter_native_splash:create    # splash screen
```

## Notes
- `icons/` and `illustrations/` currently hold only `.gitkeep` so the dirs resolve at build time — replace with real SVGs.
- Fonts are **bundled locally** (offline-first); do not switch to `google_fonts` runtime fetch.
- Flame (biome rendering) is **not** added yet — add it when building the Biome screen, then load `trees/` sprites through it.
