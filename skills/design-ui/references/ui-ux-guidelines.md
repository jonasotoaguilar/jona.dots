# UI/UX Design Guidelines

Use this reference when designing a screen flow — page, route, multi-step flow, or any user task surface. Covers the durable priority hierarchy distilled from web + mobile interface practice.

For atmosphere/color/typography/anti-template, read `design-direction.md`. For the web review contract, `web-interface-guidelines.md`; for mobile/native, `mobile-interface-guidelines.md`. **Execution boundary:** this file states the design contract, not the audit procedure; verify the changed UI directly against the contract with static/runtime design-system checks. Dataset queries go to `scripts/search.py`.

## Priority hierarchy

Apply in order when conflicts arise. Higher priority wins.

1. **Accessibility** (CRITICAL) — contrast, focus, labels, keyboard, semantic HTML, screen reader, reduced motion.
2. **Touch and interaction** (CRITICAL) — 44×44pt targets, 8pt spacing, press feedback, haptics, no gesture-only critical actions.
3. **Performance** (HIGH) — Core Web Vitals (CLS < 0.1, LCP < 2.5s, INP < 100ms), reserved space, lazy loading, no layout reads in render.
4. **Style selection** (HIGH) — match product type, consistent style/icon family, platform-adaptive, light/dark designed together.
5. **Layout and responsive** (HIGH) — mobile-first, 16px body minimum, no horizontal scroll, 65–75ch line length, semantic z-index.
6. **Typography and color** (MEDIUM) — line-height 1.5–1.75, semantic color tokens, weight-driven hierarchy, tabular-nums for data.
7. **Animation** (MEDIUM) — motion with intent, transform/opacity only, interruptible, honors reduced motion. Values per the `ui-motion` contract (ease-out both ways, ≤400ms complex, stagger 30–50ms) — no tables here.
8. **Forms and feedback** (MEDIUM) — visible labels, inline errors with fix, progressive disclosure, success/error/empty/disabled states.
9. **Navigation** (HIGH) — predictable back, ≤5 bottom nav items, deep-linkable state, current location highlighted.
10. **Charts and data** (LOW) — legends, tooltips, accessible colors with patterns/text, screen-reader summary, no color-only meaning.

## Visual design rules

- Near-black/near-white tokens over pure black/white for softer contrast; semantic color roles before raw values; never color-only state.
- Tune saturation per mode (raise in light if washed out, lower in dark to avoid glare); simple readable fonts with weight/size hierarchy, not novelty; left-align blocks of four+ lines.
- Scrim/overlay for text over images; consistent spacing scale (tighter inside groups, looser between); inner radius slightly smaller than outer; pick a color strategy (restrained/committed/full palette/drenched) before picking colors — see `design-direction.md`.

## Forms and inputs

- Visible labels always (placeholders are hints only, allowed in search); `inputmode` and masks for phone/date/currency/card/numeric.
- Field width matches data (avoid full-width for short values); boxes/borders/fills over underlines alone; stack labels on mobile.
- Limit fields; "Other" or progressive disclosure instead of long forms; errors show where and why, never blame, announced in live regions; validate on blur not keystroke; focus first invalid field on submit; show the fix, not just the problem.

## Buttons, CTAs, and actions

- One primary button per decision area; label clear and actionable ("Save changes", not "OK"); generous side padding; primary CTAs in the thumb zone on mobile.
- Icons paired with labels unless universally obvious with an accessible name; subtle press scale 0.95–1.05 with no layout shift.

## Selection, search, and navigation

- 2–3 values: show all (radio/checkbox); toggle tokens/chips for large selectable lists; search supports typing and scrolling.
- Tabs 3–5 with short labels; predictable back; active location shown; breadcrumbs for 3+ levels; focus moves to main content after route change.

## Content and feedback

- Break content with headings, icons, cards, tables, bullets; "Read more" for secondary long text.
- Success/loading/empty/disabled/hover/focus/error states for every interactive element; skeleton/shimmer for known layouts; real progress for multi-step flows.
- Active voice, second person, numerals for counts, Title Case for headings/buttons.

## Anti-template principle

The strongest universal design test: would someone guess the theme + palette from the category alone? If yes, it's the AI category reflex. Run at two altitudes (first-order: domain alone; second-order: alternative to the obvious reflex) and rework until neither answer is obvious. Full check and AI-tell anti-patterns in `design-direction.md`.

**Quality gate:** primary task and CTA obvious above the fold; hierarchy not color-only; tokens reused or `DESIGN.md` updated; all states (loading, empty, success, error, disabled, hover, focus) designed; touch targets/mobile layout/keyboards appropriate; no category-reflex design; audit evidence collected against the contract before handoff (web or native per surface).
