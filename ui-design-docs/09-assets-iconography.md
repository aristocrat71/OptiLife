# OptiLife — Assets & Iconography (POP)

**Audience:** Flutter engineers + whoever produces art. Defines the icon style, the complete asset manifest, naming, sizes, and bundling. Tree sprite art is the one TBD art pass (Design Doc §10) — this file specifies the slots and contract so code can be built against placeholders.

---

## 1. Iconography style
- **Rounded-stroke**, 2px nominal, filled accents — matches the chunky outline language.
- Default colour `ink`; on coloured fills use `cream`/`paper`. Icons inherit `currentColor` where possible.
- Sizes: 13 (in-chip), 16 (inline), 22 (shell/button), 26 (FAB/dice), 30 (nav heart). Keep on the 1px grid; avoid sub-pixel strokes.
- Format: **SVG** via `flutter_svg`, OR a curated icon font. Prefer SVG for the hand-drawn POP feel. Bundle locally (offline-first) — no remote icon fetches.

### 1.1 Category glyphs (5 — `normal` has no quest glyph)
| Category | Glyph concept | Asset |
|---|---|---|
| adventure | compass | `ic_cat_adventure.svg` |
| fitness | dumbbell | `ic_cat_fitness.svg` |
| social | people/hug | `ic_cat_social.svg` |
| creative | paint/brush | `ic_cat_creative.svg` |
| night | moon | `ic_cat_night.svg` |

### 1.2 System icons
`ic_calendar`, `ic_calendar_back` (← badge variant), `ic_bolt` (⚡ LE), `ic_heart` (nav), `ic_dice`, `ic_check`, `ic_shield` (avoided), `ic_undo`, `ic_plus`, `ic_camera`, `ic_world` (globe), `ic_tree_count`, `ic_chevron`, `ic_trash`, `ic_edit`, `ic_font`, `ic_settings`, `ic_close`, radial petal icons (`ic_nav_bio/sq/task/hj/set/analytics`).

---

## 2. Tree sprites (Flame layer) — 6 types
Rendered by Flame in 2.5D isometric (Design Doc §7). Each category → one tree; `normal` is the neutral fallback (habit-driven level-ups, Data Models §7.8).

| Category | Tree concept | Sprite slot |
|---|---|---|
| adventure | wild, untamed tree | `tree_adventure` |
| fitness | strong oak | `tree_fitness` |
| social | flowering tree | `tree_social` |
| creative | rare glowing plant | `tree_creative` |
| night | moonlit plant | `tree_night` |
| normal | plain neutral tree | `tree_normal` |

**Sprite contract (so placement/rendering code is art-independent):**
- Isometric, foot-anchored: the **base/contact point is bottom-centre** of the sprite bounds (used to seat the tree on a grid cell).
- Provide 1×/2×/3× (or a single high-res + downscale). Target on-grid footprint ≈ one cell (~62px wide at 1×).
- States: `idle` (static), `plant-in` (squash-settle), optional gentle idle sway. `ghost` variant (semi-transparent) for placement preview.
- Naming: `tree_{category}_{state}@{scale}.png` (or a sprite sheet `trees.png` + atlas JSON).
- Until art lands, ship **placeholder sprites** matching the POP mock trees (outlined canopy + trunk in the category colour) so the loop is testable.

### 2.1 Biome environment assets
`ground_tile` (iso diamond, grid-lined top), `sun`, `cloud`, `dust_puff` (plant FX), `travel_swirl` (reboot tunnel gradient). Ground may be drawn procedurally (as in the mock) rather than imaged.

---

## 3. Illustrations (empty/celebration)
Chunky, outlined, POP-coloured. Slots:
- `empty_quests`, `empty_tasks`, `empty_journal`, `empty_biome` (first sprout), `future_locked` (sun/“see you then”).
- `levelup_hero`, `reboot_world`.
Keep them as SVG or single PNGs; one warm line of copy accompanies each (see screen files).

---

## 4. Bundling & pubspec
```yaml
flutter:
  assets:
    - assets/icons/        # SVGs
    - assets/illustrations/
    - assets/trees/        # sprites / atlas
  fonts:
    - family: Fredoka
      fonts: [{ asset: assets/fonts/Fredoka-VariableFont.ttf }]
    - family: Nunito
      fonts: [{ asset: assets/fonts/Nunito-VariableFont.ttf }]
    - family: Caveat
      fonts: [{ asset: assets/fonts/Caveat-VariableFont.ttf }]
    - family: Lora
      fonts: [{ asset: assets/fonts/Lora-VariableFont.ttf }]
```
- **Bundle fonts locally** (don't rely on `google_fonts` runtime fetch) — offline-first (Design Doc §2).
- App icon / splash: POP heart on `cream`; splash shows logo + a single heartbeat before first frame.

---

## 5. Asset naming conventions
- snake_case, prefixed by kind: `ic_` icons, `tree_` sprites, `empty_`/`illus_` illustrations, `bg_` backgrounds.
- One concept per file; no baked-in colour for icons meant to tint (use `currentColor`).
- Reference through a generated constants class (e.g. `flutter_gen`) — no raw asset-path strings in widgets.

---

## 6. Handoff checklist for art
- [ ] 5 category glyphs + system icon set (SVG)
- [ ] 6 tree sprites (idle + plant-in + ghost), foot-anchored, 1–3×
- [ ] biome ground/sun/cloud/dust/travel-swirl
- [ ] empty/celebration illustrations
- [ ] 4 font families (variable TTFs) for local bundling
- [ ] app icon + splash
