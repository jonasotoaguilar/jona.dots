# Fluid Interface Physics

How Apple builds interfaces that feel alive (chiefly _Designing Fluid Interfaces_, WWDC 2018), distilled for the web platform (CSS, Pointer Events, `requestAnimationFrame`, spring libraries like Motion).

The through-line: **an interface feels alive when motion starts from the current on-screen value, inherits the user's velocity, projects momentum forward, and can be grabbed and reversed at any instant.** Springs are the tool that makes this natural, because they are inherently interruptible and velocity-aware.

## 1. Response — kill latency

- **Respond on pointer-down, not on release.** Highlight a button the instant it's pressed; waiting for click/touch-up feels dead.
- **Audit every latency:** debounces, artificial timers, transition waits, the ~300ms tap delay. Anything on the input path that isn't essential is a regression.
- **Feedback is continuous during the interaction**, not just at the end: update 1:1 with the pointer the whole way through a drag, slider, or drawer.

## 2. Direct manipulation — 1:1 tracking

- Touch and content move together: the element stays glued to the finger, respecting the offset from _where it was grabbed_ (never snap to its center on grab).
- Use Pointer Events with `setPointerCapture` so tracking continues when the pointer leaves the element's bounds.
- Track a short velocity/position history (last few `pointermove` events) — you need velocity at release.

## 3. Interruptibility — the single most important principle

- Every animation must be interruptible and redirectable at any moment; never lock out input during a transition.
- **Always animate from the presentation (current) value, never the target value.** On interrupt, read the element's live on-screen transform and start the new animation there — starting from the logical value causes a visible jump.
- **Avoid CSS transitions and `@keyframes` for gesture-driven motion** — they can't be smoothly grabbed and reversed mid-flight. Springs animate from the current value by default.
- **On reversal, blend velocity — don't hard-cut it.** Replacing one animation with another creates a velocity discontinuity ("brick wall"); a spring that carries velocity through a re-target avoids it.
- **Decompose 2D motion into independent X and Y springs** — a single spring on a 2D distance desyncs when X and Y velocities differ.

## 4. Behavior over animation — use springs

A pre-scripted, fixed-duration animation can't respond to new input; a spring can — new input just changes the target and the motion stays continuous. Reach for springs for anything a user can touch.

Think in two designer-friendly parameters (not mass/stiffness/damping):

- **Damping ratio** — controls overshoot. `1.0` = critically damped, no bounce, smooth settle; `< 1.0` oscillates, lower = bouncier.
- **Response** — how quickly the value reaches the target, in seconds. Lower = snappier. **Not "duration"** — a spring has no fixed duration; settle time emerges from the parameters.

**Defaults:** critically damped (`damping 1.0`) for most UI; add bounce (`damping ~0.8`) **only when the gesture itself carried momentum** (flick, throw, drag release). Overshoot on a menu that just faded in feels wrong; overshoot on a card you flicked feels right.

| Interaction                  | Damping | Response |
| ---------------------------- | ------- | -------- |
| Move / reposition (e.g. PiP) | `1.0`   | `0.4`    |
| Rotation                     | `0.8`   | `0.4`    |
| Drawer / sheet               | `0.8`   | `0.3`    |

Web mapping (Motion/Framer Motion): `bounce` + `duration` maps closely to damping + response. House style: `bounce: 0` springs by default; reserve bounce for momentum-driven physical interactions.

```js
import { animate } from "motion";
animate(el, { y: 0 }, { type: "spring", bounce: 0, duration: 0.4 }); // critically damped
animate(el, { y: target }, { type: "spring", bounce: 0.2, duration: 0.4 }); // momentum: bounce only because a flick preceded it
```

## 5. Velocity handoff — the seam between drag and animation

When a gesture ends, the animation continues at the finger's exact velocity so there is no visible seam. Pass the pointer's release velocity as the spring's initial velocity. Some APIs want **relative** velocity — normalize by remaining distance:

```
relativeVelocity = gestureVelocity / (targetValue − currentValue)
```

Framer Motion / Motion take absolute px/s directly (`velocity` option).

## 6. Momentum projection — animate to where the gesture is going

Don't snap to the nearest boundary from the release point. Use velocity to **project the resting position** (like scroll deceleration), then snap to the target nearest that projection — a flick throws the element.

Apple's exact projection (exponential-decay form, NOT the physics-textbook `v²/(2·decel)`):

```js
function project(initialVelocity, /* px/s */ decelerationRate = 0.998) {
  return (initialVelocity / 1000) * decelerationRate / (1 - decelerationRate);
}
const target = nearestSnapPoint(currentPosition + project(releaseVelocity));
animateSpringTo(target, { velocity: releaseVelocity }); // then hand off velocity
```

`decelerationRate ≈ 0.998` for normal scroll feel, `0.99` for snappier. This is the standard behavior in good bottom-sheets and carousels (Vaul, Embla).

## 7. Spatial consistency — symmetric paths, anchored origins

- **Enter and exit along the same path.** A panel that slides in from the right must dismiss to the right; in-from-right / out-the-bottom feels disconnected.
- **Anchor interactions to their source:** set `transform-origin` to the trigger so the spatial relationship between button and content is obvious.
- **Mirror the easing on reversible transitions** (inverse cubic-bézier control points) so the return path matches the outbound path.

## 8. Hint in the direction of the gesture

Humans predict a final state from a trajectory. Intermediate frames should telegraph where things are going (Control Center modules "grow up and out toward your finger") — not interpolate blindly.

## 9. Rubber-banding — soft boundaries

At an edge, resist progressively instead of stopping hard: a hard stop reads as "frozen"; continuous resistance reads as "responsive, but there's nothing more here." Apply damping that increases the further past the boundary the user drags.

```js
function rubberband(overshoot, dimension, constant = 0.55) {
  return (overshoot * dimension * constant) /
    (dimension + constant * Math.abs(overshoot));
}
```

## 10. Gesture design details

- **Tap:** highlight on touch-down (instant), commit on touch-up; ~10px hysteresis/hit padding; allow cancel-by-dragging-away and back.
- **Drag/swipe:** small movement threshold (~10px) before committing to a direction, then track 1:1.
- **Detect all plausible gestures in parallel from the first move**, then cancel the losers once intent is clear; avoid recognizers that only report a final state (`swipeleft`-type events) — they throw away continuous tracking.
- **Minimize disambiguation delays:** double-tap detection delays single taps; only pay that cost where double-tap truly exists.

## 11. Frame-level smoothness

Smoothness is about _what's in the frames_, not just frame rate. Keep per-frame positional change below the perception threshold; for very fast motion a subtle motion blur/stretch encodes speed better than a hard sharp streak. Animate only compositor-friendly properties (`transform`, `opacity`); hint `will-change` where motion is imminent.

## 12. Materials and depth

Translucent materials read as a floating functional layer that brings structure without stealing focus. On the web: `backdrop-filter`.

- Build nav/toolbars/sheets as translucent layers with content scrolling underneath — not opaque bars consuming a fixed strip.
- Material weight encodes hierarchy: heavier = structural (sidebars), lighter = interactive (buttons). **Never stack a light translucent surface on another** — legibility collapses. Bigger surfaces read as thicker: stronger blur + deeper shadow.
- Dim to focus (modal + scrim), separate to keep flow (parallel panel with translucency, no scrim). For stacked sheets, progressively dim and push back each parent.
- Over blurred surfaces, avoid flat gray text: higher contrast, slightly heavier weight, small letter-spacing bump; put color on a solid layer, not the translucent foreground.
- Scroll edge effects, not hard dividers: fade a blur/gradient mask where floating UI overlaps content instead of a 1px border.
- Materialize, don't just fade: for glass surfaces, animate blur radius and scale together on enter/exit so the surface reads as a material arriving.

```css
.toolbar {
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(20px) saturate(180%);
  border-top: 1px solid rgba(255, 255, 255,
    0.4); /* bright top edge = light catching the material */
}
```

## 13. Multimodal feedback — motion + sound + haptics

1. **Causality** — feedback fires on the actual causal event (toggle flipping, item snapping home) and matches the action's physicality.
2. **Harmony** — visual, sound, and haptic fire on the **same frame**; latency between them destroys the illusion (don't let a CSS transition lag the Vibration API).
3. **Utility** — feedback only where it earns its place: success, error, commit, snap. Over-feedback trains users to ignore all of it.

## 14. Reduced motion and accessibility

Reduced motion means gentler, non-vestibular equivalents, not zero feedback. Respond to three independent signals:

- **`prefers-reduced-motion: reduce`** — replace slides/springs/parallax with short opacity cross-fades or static transitions; drop elastic/overshoot; keep opacity/color changes that aid comprehension.
- **`prefers-reduced-transparency: reduce`** — make translucent surfaces frostier/solid: raise background opacity, drop the blur.
- **`prefers-contrast: more`** — near-solid backgrounds with a defined, contrasting border.

Also: avoid full-viewport moving backgrounds, slow looping oscillations (near 0.2 Hz), and abrupt brightness jumps (ease dark↔light theme changes). Make large moving objects semi-transparent while they travel; fade big surfaces out during a large reposition and back in once settled.

```css
@media (prefers-reduced-motion: reduce) {
  .sheet {
    transition: opacity 200ms ease;
    transform: none !important;
  }
}
@media (prefers-reduced-transparency: reduce) {
  .toolbar {
    background: white;
    backdrop-filter: none;
  }
}
```

## Quick reference

| Need                        | Technique                            | Concrete value                                       |
| --------------------------- | ------------------------------------ | ---------------------------------------------------- |
| Default UI spring           | Critically damped, no overshoot      | `damping 1.0`, `response 0.3–0.4`                    |
| Momentum / flick spring     | Under-damped, slight bounce          | `damping ~0.8`, `response 0.3–0.4`                   |
| Gesture → spring velocity   | Hand off release velocity            | `gestureVelocity / (target − current)` if normalized |
| Flick landing point         | Project momentum                     | `current + (v/1000)·d/(1−d)`, `d ≈ 0.998`            |
| Interrupt cleanly           | Start from presentation (live) value | read the on-screen transform                         |
| Avoid reversal "brick wall" | Carry velocity through re-target     | spring that blends velocity                          |
| Reversible transition       | Mirror the easing curve              | inverse cubic-bézier                                 |
| Decide reverse vs. commit   | Use velocity **sign**, not position  | at release                                           |
| 1:1 drag                    | Pointer Events + capture             | respect the grab offset                              |
| Feedback                    | On pointer-down, continuous          | never only at the end                                |
| Boundary                    | Rubber-band, don't hard-stop         | progressive resistance                               |
| Translucent chrome          | `backdrop-filter` layer              | content scrolls under                                |
| Reduced motion              | Cross-fade, not slide/spring         | `@media (prefers-reduced-motion)`                    |
