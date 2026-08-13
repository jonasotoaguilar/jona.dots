# Design Engineering (Craft)

Runtime craft rules for building and judging motion. Values and citation source: `standards.md`. Background on fluid physics: `physics.md`. Never modify source code in `find`/`review`/`improve` modes.

## Review format (required)

When reviewing UI code, use a single markdown table with `Before | After | Why` columns — never a list with "Before:/After:" on separate lines. One row per issue.

| Before                                | After                                       | Why                                                         |
| ------------------------------------- | ------------------------------------------- | ----------------------------------------------------------- |
| `transition: all 300ms`               | `transition: transform 200ms ease-out`      | Specify exact properties; avoid `all`                       |
| `transform: scale(0)`                 | `transform: scale(0.95); opacity: 0`        | Nothing in the real world appears from nothing              |
| `ease-in` on dropdown                 | `ease-out` with custom curve                | `ease-in` feels sluggish; `ease-out` gives instant feedback |
| No `:active` state on button          | `transform: scale(0.97)` on `:active`       | Buttons must feel responsive to press                       |
| `transform-origin: center` on popover | `transform-origin: var(--transform-origin)` | Popovers scale from their trigger (modals stay centered)    |

## The animation decision framework

Answer in order before writing any animation code:

1. **Should this animate at all?** Frequency decides: 100+ times/day (keyboard shortcuts, command palette) → **no animation, ever**; tens/day (hover effects, list navigation) → remove or drastically reduce; occasional (modals, drawers, toasts) → standard; rare/first-time (onboarding, celebrations) → may add delight. **Never animate keyboard-initiated actions.**
2. **What is the purpose?** Must be one of: spatial consistency (toast enters/exits the same edge), state indication (morphing button), explanation (marketing only), feedback (press scale), preventing a jarring change. "It looks cool" on a frequently-seen element is not valid.
3. **What easing?** Entering/exiting → `ease-out`; moving/morphing on screen → `ease-in-out`; hover/color change → `ease`; constant motion (marquee, progress) → `linear`; default → `ease-out`. **Never `ease-in` on UI.** Built-in CSS easings are too weak — use strong custom curves:
   ```css
   --ease-out: cubic-bezier(0.23, 1, 0.32, 1); /* strong ease-out for UI */
   --ease-in-out: cubic-bezier(0.77, 0, 0.175, 1); /* strong ease-in-out for on-screen movement */
   --ease-drawer: cubic-bezier(0.32, 0.72, 0, 1); /* iOS-like drawer curve (Ionic) */
   ```
   Don't hand-roll curves from scratch — use easing.dev or easings.co.
4. **How fast?** Button press 100–160ms; tooltips/small popovers 125–200ms; dropdowns/selects 150–250ms; modals/drawers 200–500ms; marketing can be longer. **UI stays under 300ms**; complex transitions ≤400ms (500ms only as a documented exception). Perceived performance: a 180ms select feels faster than a 400ms one; fast spinners make loads feel faster.

## Springs

Springs settle on physical parameters instead of fixed durations. Use for drag with momentum, "alive" elements, interruptible gestures, decorative mouse-tracking.

```js
{ type: "spring", duration: 0.5, bounce: 0.2 }   // Apple-style — recommended, easier to reason about
{ type: "spring", mass: 1, stiffness: 100, damping: 10 }  // traditional physics
```

Keep bounce subtle (0.1–0.3); avoid bounce in most UI, reserve for drag-to-dismiss and playful interactions. Springs maintain velocity when interrupted — keyframes restart from zero — so they are ideal for gestures users may reverse mid-motion. Mouse-tracking: interpolate with `useSpring`, never tie the value directly to the pointer (feels artificial); only when the motion is decorative.

## Component principles

- **Buttons feel responsive:** `transform: scale(0.97)` on `:active` with `transition: transform 160ms ease-out`; applies to any pressable element (0.95–0.98).
- **Never animate from `scale(0)`** — start from `scale(0.9–0.97)` + `opacity: 0`; nothing appears from nothing.
- **Popovers are origin-aware:** scale from the trigger (`transform-origin: var(--transform-origin)`), never center. **Modals are exempt** — they appear centered in the viewport.
- **Tooltips:** delay the first appearance, then instant on subsequent hovers (`transition-duration: 0ms` via `data-instant`).
- **Transitions over keyframes for dynamic UI:** transitions can be interrupted and retargeted; keyframes restart from zero. Use for toasts, toggles, anything triggered rapidly. `@starting-style` animates entry without JS (fallback: `data-mounted` attribute pattern).
- **Blur masks imperfect crossfades:** when a crossfade shows two overlapping states, add subtle `filter: blur(2px)` during the transition; keep blur < 20px (expensive, especially Safari).
- **Stagger group entrances 30–80ms between items;** decorative, never block interaction while playing.

## Transform and clip-path

- `translate()` percentages are relative to the element's own size — `translateY(100%)` works regardless of dimensions (how Sonner/Vaul position toasts/drawers). Prefer percentages over hardcoded px.
- `scale()` scales children too (font, icons) — a feature for press feedback.
- `rotateX/Y` + `transform-style: preserve-3d` for depth/orbit/flip without JS.
- `clip-path: inset(t r b l)` eats into the element from each side. Uses: reveal-on-scroll (`inset(0 0 100% 0)` → `inset(0 0 0 0)`), hold-to-delete overlay (2s linear on press, 200ms ease-out snap-back), seamless tab color transitions (duplicate the tab list, clip the active copy), comparison sliders.

## Gesture and drag

- **Momentum dismissal:** compute velocity (`Math.abs(distance) / elapsedMs`); dismiss if `> ~0.11` — a quick flick is enough, never require a distance threshold.
- **Damping at boundaries:** dragging past an edge moves less the further you go; real things slow before they stop.
- **Pointer capture** once dragging starts so tracking continues outside the element's bounds.
- **Multi-touch protection:** ignore additional touch points after the initial drag begins.
- **Friction over hard stops:** allow over-drag with rising resistance, not an invisible wall.

## Performance

- **Animate `transform` and `opacity` only** — GPU-composited; layout properties (`padding`, `margin`, `height`, `width`, `top`, `left`) trigger layout/paint every frame.
- **Never drive child transforms via a CSS variable on the parent** — recalculates styles for all children; set `transform` directly on the element.
- **Framer Motion shorthands (`x`, `y`, `scale`) are NOT hardware-accelerated** — rAF on the main thread, drops frames under load. Use the full `transform` string for hardware acceleration.
- **CSS animations beat JS under load** (off main thread); use CSS for predetermined motion, JS/springs for dynamic and interruptible.
- **WAAPI** gives JS control with CSS performance — hardware-accelerated, interruptible, no library.

## Accessibility

- `prefers-reduced-motion: reduce` → fewer and gentler animations, not zero: keep opacity/color transitions that aid comprehension, remove movement/position animations.
- Gate hover animations behind `@media (hover: hover) and (pointer: fine)` — touch devices fire false hovers on tap.

## Asymmetric timing

Slow where the user is deciding, fast where the system responds: press-and-hold (2s linear on press) vs release (200ms ease-out). Symmetric enter/exit timing on press-and-release interactions is a finding. Exit should be faster than enter (~60–70% of enter duration).

## Debugging and verification

- Play animations in slow motion (2–5x duration or DevTools animation inspector): colors crossfade cleanly, easing doesn't start/stop abruptly, `transform-origin` correct, coordinated properties in sync.
- Step frame-by-frame in Chrome DevTools Animations panel to catch timing drift between coordinated properties.
- Test gestures on real devices (Safari remote devtools; Xcode Simulator is a fallback).
- Review with fresh eyes the next day — imperfections invisible during development surface later.

## Review checklist (fast pass)

| Issue                                   | Fix                                         |
| --------------------------------------- | ------------------------------------------- |
| `transition: all`                       | Specify exact properties                    |
| `scale(0)` entry                        | `scale(0.95)` + `opacity: 0`                |
| `ease-in` on UI                         | `ease-out` or custom curve                  |
| Animation on keyboard action            | Remove entirely                             |
| UI duration > 300ms                     | 150–250ms                                   |
| Hover motion ungated                    | `@media (hover: hover) and (pointer: fine)` |
| Keyframes on rapidly-triggered elements | CSS transitions (interruptible)             |
| Same enter/exit speed                   | Exit faster (60–70% of enter)               |
| Everything at once                      | Stagger 30–80ms                             |
| No reduced-motion handling              | Add `prefers-reduced-motion` fallback       |
