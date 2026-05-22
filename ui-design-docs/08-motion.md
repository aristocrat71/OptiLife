# OptiLife — Motion & Animation Spec (POP)

**Audience:** Flutter engineers. Uses motion tokens from `05-foundations-tokens.md §6`. POP motion is **bouncy and confident** — overshoot on entrances, squish on press, nothing eases linearly. Implementation: native `AnimationController` + `CustomPainter` (Design Doc §8.4) — no heavy animation packages for the signature pieces.

---

## 1. Motion principles
1. **Squish, don't ripple** — press feedback is scale `0.96` (`press`), never Material ink.
2. **Overshoot entrances** — lands use `easeOutBack` (`pop`).
3. **The meter is the payoff** — every LE change ends at the LE ring: a chip flies there, then the ring fills (`fill`). This closes the core loop visually.
4. **Respect reduced-motion** — see §8.

---

## 2. Signature animations

### 2.1 Heartbeat + ripple (CentralNav)
- **Swell**: scale `1.0→1.08→1.0`, `heartbeat` (800ms), `repeat(reverse:true)`, `easeInOut`. `ScaleTransition`.
- **Ripple**: 3 rings behind the button, each scales `~70px → ~130px` while opacity `0.42 → 0`, `ripple` (1600ms) `repeat`, staggered ~530ms so beats read as successive pings. `IgnorePointer`. Compact spread (rings hug the button).
- Same controller family so each beat both swells and emits.

### 2.2 Liquid-fill background
- `CustomPainter`, two phase-shifted sine waves (natural wobble). Height ∝ `leIntoCurrentLevel/50`; animates to new height on LE change (`fill`, 600ms). Tint = recent quest category @16% over `cream`.
- Continuous gentle horizontal drift (slow, ~6s loop) so it feels alive at rest. All screens except Biome; gated by `settings.liquidFillEnabled`.

### 2.3 Quest complete (MARK)
Sequence (≈900ms total): card squish (`press`) → **ConfettiBurst** in category colour → done-wash sweeps L→R across card → **LeFlyChip** `+10` flies to LE ring → ring fills (`fill`) → card settles into `done` state. Unmark = reverse, `−10` chip in `negative`.

### 2.4 Habit log
Toggle fills `positive` + check/shield draw-on (`pop`) → `+2` LeFlyChip → ring fill. Un-log reverses (`−2`). Slip does not exist (single binary toggle).

### 2.5 Level-up → placement
1. `LevelUpOverlay`: full-screen `popPurple` hero gradient (rare gradient moment), big `LV n` (`numXL`), category-colour confetti, copy "A {Category} tree is ready 🌳". Auto-advance ~1.4s or tap.
2. Transition into **placement mode** on Biome: ghost tree sprite follows finger, valid cells shimmer, invalid show soft ✕. Plant = bouncy squash-settle + dust puff + category burst. Everything else dimmed/locked.

### 2.6 Level-down
Newest tree uproots with a quick reverse-pop and vanishes; brief `Toast` "Level down — newest tree removed". No placement.

### 2.7 Biome reboot — "dimensional travel"
On confirm: world warps/zooms into a swirl tunnel (purple→pink→teal gradient), `travel` (1400ms) `easeInOutCubic`, then settles on a fresh empty grid; liquid drains to empty; `WORLD n` HUD ticks up. The signature long-term moment.

### 2.8 Reroll
Cards shuffle out (spin off) → fresh roll deals in like cards from a deck, `pop`, staggered. `−10` LeFlyChip to ring.

---

## 3. Micro-interactions
| Element | Motion | Token |
|---|---|---|
| Any button/card tap | scale 0.96 + shadow collapse + translate +1,+1 | `press` |
| Card/sheet/petal entrance | slide/scale with overshoot | `pop` |
| Disabled tap (reroll, read-only) | horizontal shake ±6px ×2 | `shake` |
| LE ring change | arc tween | `fill` |
| Checkbox | check path draw-on + tiny overshoot | `pop` |
| Page change (swipe) | native PageView physics | — |
| Day change (vertical) | content vertical slide (page-turn-ish) | `pop` |
| Radial menu | petals spring out staggered; scrim fade | `pop` |

---

## 4. Page-dot & date-change feedback
- Dot indicator: active dot stretches to a pill (`pop`) on page settle.
- Near vertical day-change threshold: rubber-band stretch of content + tug haptic at trigger; commit → vertical slide to new day.

---

## 5. Toasts & fly-chips
- `Toast`: pop in (`pop`), hold ~1.2s, fade out. Topmost, non-blocking.
- `LeFlyChip`: spawns at the action's global position, tweens along a slight arc to the LE ring's global position (~450ms `easeOutCubic`), then triggers ring fill. Implement as `OverlayEntry`.

---

## 6. Confetti / bursts
- `ConfettiBurst`: 12–20 particles in the category colour (+ white sparks), additive, gravity + fade, ~700ms. Used on quest-complete and level-up. Non-blocking overlay; never delays the state change.

---

## 7. Timing summary (single source = tokens)
`press 90` · `pop 260` · `fill 600` · `heartbeat 800` · `ripple 1600` · `shake 320` · `travel 1400`. Do not introduce new durations without adding a token.

---

## 8. Reduced motion & performance
- Honour `MediaQuery.disableAnimations` / a future "Calm POP" setting: drop ripple, confetti, liquid drift, and travel warp to simple cross-fades; keep functional transitions (fill, page change) but shorten.
- Keep the biome (Flame) and liquid `CustomPainter` at 60fps; avoid rebuilding the whole tree on every tick — isolate animated layers with `RepaintBoundary`.
- LeFlyChip/confetti are overlay-only; they must never block input or the underlying state write.
