# Mobile and Native Interface Guidelines

Distilled rules for mobile/native UI quality: touch, safe areas, native navigation, lists as performance, images, motion, platform adaptation, text rendering, icon discipline. Load when designing or reviewing React Native, iOS, Android, or any native app interface, or when the UI "doesn't look professional" and the cause isn't obvious.

Not for: backend logic, state architecture, build tooling, monorepo dependency graphs, JS/TS micro-optimizations unrelated to UI. Web/desktop interaction patterns live in `web-interface-guidelines.md`.

**Execution boundary:** this file is the contract. Verify the changed UI directly against the checklist — static and runtime design-system checks; dataset queries for specific rules go to `scripts/search.py`.

## Touch and tap targets

- Minimum 44×44pt (iOS) / 48×48dp (Android); expand via `hitSlop` when the icon is smaller; spacing ≥8pt between adjacent targets.
- Press feedback within 80–150ms (ripple/opacity/scale) — never shift layout bounds; gestures alone never carry critical actions; standard gestures (swipe-back, pinch-zoom) not redefined.

## Safe areas and system chrome

- Respect top/bottom safe areas for fixed headers, tab bars, CTA bars; reserve space for status bar, nav bar, gesture home indicator.
- `contentInsetAdjustmentBehavior="automatic"` (iOS) over `SafeAreaView` for root scrollables; `env(safe-area-inset-*)` for full-bleed web/mobile-web; `contentInset` (not padding) for dynamic offsets.

## Native navigation

- Native navigators (native stack, `react-native-bottom-tabs`) over JS stacks when native feel matters; native headers (large titles, search, blur) not custom replacements.
- Bottom nav ≤5 items, icon + label, current location highlighted; preserve back behavior (scroll position, filters, form input).
- iOS: bottom Tab Bar for top-level; Android: Top App Bar; adaptive ≥1024px prefers sidebar. Focus moves to main content after route change. Dangerous actions visually and spatially separated.

## Native modals, menus, sheets

- Native `<Modal>` `presentationStyle="formSheet"` or React Navigation v7 native form sheet over JS bottom sheets; native context menus (`zeego`) over custom JS.
- Clear close/dismiss affordance; swipe-down to dismiss; modals never primary navigation; confirm before dismissing with unsaved changes.

## Lists as UX and performance

- List virtualizer (LegendList, FlashList) for any scrollable list — not `ScrollView + map`; lightweight items (no queries, minimal hooks).
- Primitives to items for effective `memo()`; hoist callbacks; avoid inline objects/styles; `getItemType`/`getEstimatedItemSize` for heterogeneous lists; stable parent array references.

## Images and media

- Optimized image components (`expo-image`) with caching, blurhash/thumbnail placeholder, `contentFit`, `priority`, `cachePolicy`; request ≤2× retina; native gallery for lightboxes (pinch-zoom, pan-to-close).

## Motion

- `transform`/`opacity` only (GPU); never `width`/`height`/`top`/`left`/`margin`/`padding`; press feedback subtle scale 0.95–1.05; modals/sheets animate from trigger source; navigation directions logically consistent; interruptible; honors `prefers-reduced-motion`.
- Values per the `ui-motion` contract; never duplicate its value tables here.

## State as ground truth

- Store state (pressed, progress, isOpen); derive visuals via interpolation; Reanimated shared values for scroll/animation — never `useState` for scroll position; minimum variables, derive the rest.

## Platform adaptation

- iOS: large titles, blur, swipe-back, SF Symbols, form sheets. Android: Material patterns, Top App Bar, predictive back, Material icons.
- Light/dark designed together, never inverted; state contrast parity in both themes; modal scrim typically 40–60% black.

## Text and rendering pitfalls

- Strings inside `<Text>` (direct text children of `<View>` crash in React Native); never `{value && <Component />}` when `value` may be `0`/`""`; hoist `Intl.*` formatters; minimize font-size variants (weight/color for hierarchy); support Dynamic Type without truncation.

## Light and dark mode

- Light and dark variants designed together; body text contrast ≥4.5:1 in both modes, secondary ≥3:1; borders/dividers visible in both themes; test dark contrast independently.

## Icon and visual discipline

- **No emojis as structural icons** — vector icons only (SVG, react-native-vector-icons, @expo/vector-icons); emojis are font-dependent, unthemeable, and inconsistent across platforms.
- **Vector-only assets**; official brand logos with correct proportions and clear space; consistent icon sizing (tokens: icon-sm/md/lg), one stroke width per layer, one filled-vs-outline style per hierarchy level; icons aligned to text baseline; WCAG contrast (4.5:1 small, 3:1 large glyphs).
- **Stable interaction states** — pressed feedback via color/opacity/elevation, never layout-bound shifts.

## Accessibility

- Every interactive element has descriptive `accessibilityLabel`/`accessibilityHint`; focus order matches visual order; color never the only indicator; Dynamic Type + Reduced Motion supported; haptics for confirmations, never overused; standard gestures with escape routes.

## Pre-Delivery Evidence

Run every box before delivering app UI code; a single unticked box means the UI is not done:

### Process

- [ ] Ran `--domain ux "animation accessibility z-index loading"` as a validation pass before implementation
- [ ] Tested on 375px (small phone) and in landscape orientation
- [ ] Verified with **reduced-motion** enabled and **Dynamic Type**/largest system text size
- [ ] Checked dark mode contrast independently (never assume light-mode values carry over)
- [ ] Confirmed all touch targets ≥44pt and no content hidden behind safe areas

### Visual Quality

- [ ] No emojis as icons; consistent icon family/style; official brand assets correct
- [ ] Pressed-state visuals do not shift layout bounds or cause jitter
- [ ] Semantic theme tokens used consistently (no ad-hoc per-screen hardcoded colors)

### Interaction

- [ ] All tappable elements give pressed feedback; touch targets ≥44x44pt (iOS) / 48x48dp (Android)
- [ ] Micro-interaction timing 150-300ms with native-feeling easing
- [ ] Disabled states visually clear and non-interactive
- [ ] Screen reader focus order matches visual order; labels descriptive
- [ ] No nested/conflicting gestures (tap/drag/back-swipe)

### Light/Dark Mode

- [ ] Primary text ≥4.5:1 and secondary ≥3:1 in both modes
- [ ] Dividers/borders and interaction states distinguishable in both modes
- [ ] Modal/drawer scrim strong enough for foreground legibility (40-60% black)

### Layout

- [ ] Safe areas respected; scroll content not hidden behind fixed/sticky bars
- [ ] Verified on small phone, large phone, and tablet (portrait + landscape)
- [ ] Horizontal insets/gutters adapt by device size and orientation
- [ ] 4/8dp spacing rhythm maintained; long-form text readable on large devices

### Accessibility

- [ ] Meaningful images/icons have accessibility labels
- [ ] Form fields have labels, hints, and clear error messages
- [ ] Color is not the only indicator
- [ ] Reduced motion and dynamic text size supported without layout breakage
