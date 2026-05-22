# OptiLife — UI Design Docs (POP Theme)

UI screen specs for OptiLife, derived from `tech-docs/OptiLife-Design-Doc.md` and `tech-docs/Optilife Data Models.md`. The visual language is **POP** — bold candy-bright color, chunky rounded shapes, thick ink outlines, hard offset shadows, bouncy spring motion.

## Read in order

**Conceptual + screens**
1. **[00-design-system.md](00-design-system.md)** — Conceptual foundations: the POP language, the always-on shell (LE ring · central nav · calendar), navigation model, shared components.
2. **[01-side-quests.md](01-side-quests.md)** — Landing screen. Roll → mark → ⚡LE → level → tree. Quest cards, reroll, date states.
3. **[02-biome.md](02-biome.md)** — 2.5D isometric world. Tree placement mode, photo mode, biome reboot ("dimensional travel"), world HUD.
4. **[03-tasks.md](03-tasks.md)** — Calm life-admin. No LE, no confetti. Future dates editable (the planning exception).
5. **[04-journal-habits.md](04-journal-habits.md)** — Combined JH screen. Habit logging (+2⚡) lives inside the journal entry; custom typography; scroll-vs-day-change.

**Engineering handoff (Flutter-ready)**
6. **[05-foundations-tokens.md](05-foundations-tokens.md)** — **Authoritative tokens** as Dart: colors, type, spacing, radii, the thin-shadow system, motion, z-index, theme assembly. (Wins over `00` on values.)
7. **[06-components.md](06-components.md)** — Component library with every state; component→token map; Flutter widget mapping.
8. **[07-ia-navigation-state.md](07-ia-navigation-state.md)** — Route graph, Riverpod state surface, interaction locks (placement / read-only), full screen-state matrix, Settings+Workshop IA.
9. **[08-motion.md](08-motion.md)** — Per-animation spec (heartbeat+ripple, liquid fill, level-up, placement, reboot travel, confetti) + reduced-motion.
10. **[09-assets-iconography.md](09-assets-iconography.md)** — Icon style, full asset manifest, tree-sprite contract, font bundling, art handoff checklist.
11. **[10-secondary-screens.md](10-secondary-screens.md)** — Layout specs for every screen beyond the four core pages: radial menu, date picker, Settings, Workshop, editor sheets, level-up, tree placement, reboot, and all state variants.

## Mockups (Paper canvas)
Pixel mockups live on the Paper file. Built so far: the 4 core screens + Radial Menu, Date Picker, Settings, Workshop (Quests tab). The remaining screens in `10-secondary-screens.md` are fully specced and will be added to the canvas when the Paper tool budget resets — none block development.

## Conventions used in these docs
- ASCII wireframes show **layout and hierarchy**, not pixel-exact composition; the **Paper canvas** holds the pixel-level mockups.
- Every behavior cites its source section in the tech docs so design stays traceable to spec.
- Conceptual tokens use `--name`; **`05` is the code-ready source of truth** (Dart constants). Build widgets against `05`/`06`, never raw literals.

## Scope notes (from the design doc)
- **MVP (v1.0):** all four screens above + the shell, Workshop (in Settings), Tier-1 photo mode.
- **Deferred (v1.x):** Analytics (central-nav petal), journal export, notifications — referenced but not specced as primary screens here.
- **Tree sprite art** is the Flame engine layer (TBD art pass); these docs cover the Flutter chrome around it.
