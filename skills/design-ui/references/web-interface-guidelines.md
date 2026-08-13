# Web Interface Guidelines

Distilled review rules for web UI. Load when reviewing web code for compliance, or when designing web pages/components and you want the durable interface contract (a11y, focus, forms, motion, content, performance, i18n).

Sourced from Vercel Web Interface Guidelines (canonical: `vercel-labs/web-interface-guidelines/command.md`). Local distillation only — refresh by re-reading the canonical file when needed; never require a runtime fetch to apply.

**Execution boundary:** this file is the contract. Verify the changed UI against the checklist directly — static and runtime design-system checks against the implemented surface; dataset queries for specific rules go to `scripts/search.py`. Do not re-implement audit procedures here.

## Accessibility

- Icon-only buttons: `aria-label`; form controls: `<label>` or `aria-label`; images: `alt` (`alt=""` if decorative); decorative icons `aria-hidden="true"`.
- Semantic HTML (`button`, `a`, `label`, `table`) before ARIA.
- Async updates (toasts, validation) announce via `aria-live="polite"`.
- Heading hierarchy `<h1>`–`<h6>`; skip link to main content; `scroll-margin-top` on heading anchors.

## Focus states

- Visible focus on every interactive element (`focus-visible:ring-*` or equivalent); never `outline-none` without replacement; prefer `:focus-visible` over `:focus`; `:focus-within` for compound controls.

## Forms

- `autocomplete` + meaningful `name`; correct `type`/`inputmode`; never block paste.
- Labels clickable; checkbox/radio label+control share one hit target.
- Submit enabled until request starts, then spinner; errors inline next to fields; focus first error on submit.
- Placeholders end with `…`; `autocomplete="off"` on non-auth fields to avoid password-manager triggers; warn before navigating with unsaved changes.

## Animation

- Honor `prefers-reduced-motion`; animate `transform`/`opacity` only; never `transition: all` — list properties; animations interruptible.
- Correct `transform-origin` (SVG: `<g>` wrapper + `transform-box: fill-box`). Values per `ui-motion` contract (ease-out both ways, ≤400ms complex, stagger 30–50ms) — no tables here.

## Typography

- `…` not `...`; curly quotes `"` `"`; non-breaking spaces for units/shortcuts (`10&nbsp;MB`); loading states end with `…`.
- `font-variant-numeric: tabular-nums` for number columns; `text-wrap: balance`/`text-pretty` on headings.

## Content handling

- Text containers handle long content: `truncate`, `line-clamp-*`, `break-words`; flex children need `min-w-0`.
- Handle empty states; anticipate short/average/very long user-generated content.

## Images and media

- `<img>` needs explicit `width`/`height` (CLS); below-fold `loading="lazy"`; above-fold critical `priority`/`fetchpriority="high"`.
- **Never lazy-load the LCP media.** The hero image/video is the LCP element; `loading="lazy"` on it leaves the first viewport blank and tanks LCP. Use `fetchpriority="high"` (video: `preload="metadata"`) and reserve its space.
- **Correct dimensions, modern formats:** `srcset` with width descriptors, `<picture>` for art direction, WebP/AVIF where supported.
- **Prioritize critical media** above the fold; defer below-fold media with `loading="lazy"`.

## Responsive floor (design-time)

Design mobile-first and verify the output at **320 / 375 / 414 / 768 px** before delivering:

- No horizontal scroll on any viewport.
- Image-bearing grid tracks use `minmax(0, 1fr)`, never bare `1fr`.
- Long display text can wrap: allow wrapping inside long words with `overflow-wrap: anywhere` and `min-width: 0` on grid/flex children.
- Clickable text never wraps into unusable controls: buttons, nav links, footer links, breadcrumbs, and CTAs stay single-line affordances. Fix order: shorten the label → `white-space: nowrap` on the affordance (parent reflows) → hide a low-priority item at narrow widths → collapse the nav into a sheet. Never a two-line primary CTA or top-level nav link.
- Section layouts collapse intentionally at small widths — every multi-column section head has a matching single-column mobile rule.

Supporting rules:

- `min-width` media queries going up; breakpoints where the content breaks, in `rem`.
- `clamp()` for continuous sizing; media queries for discrete layout change.
- Hover-only interactions need a touch equivalent (`@media (hover: hover)` / `(pointer: coarse)`).
- `dvh`/`svh` for viewport heights; never `width: 100vw`.
- `env(safe-area-inset-*)` for notch / system-nav-bar regions.

## Performance

- Large lists (>50): virtualize (`virtua`, `content-visibility: auto`); no layout reads in render; batch DOM reads/writes.
- Prefer uncontrolled inputs; controlled must be cheap per keystroke; `<link rel="preconnect">`; critical fonts `<link rel="preload" as="font">` with `font-display: swap`.

## Navigation and state

- URL reflects state (filters, tabs, pagination in query params); links use `<a>`/`<Link>`; deep-link all stateful UI.
- Destructive actions need confirmation or undo window — never immediate.

## Touch and interaction

- `touch-action: manipulation`; `-webkit-tap-highlight-color` set intentionally; `overscroll-behavior: contain` in modals/drawers/sheets.
- During drag: disable text selection, `inert` on dragged elements; `autoFocus` sparingly — desktop only, single primary input.

## Safe areas and layout

- Full-bleed layouts: `env(safe-area-inset-*)`; avoid unwanted scrollbars (`overflow-x-hidden`); Flex/Grid over JS measurement.

## Dark mode and theming

- `color-scheme: dark` on `<html>` (scrollbar/inputs); `<meta name="theme-color">` matches page background; native `<select>` explicit `background-color`/`color`.

## Locale and i18n

- `Intl.DateTimeFormat`/`Intl.NumberFormat` — never hardcoded formats; language via `Accept-Language`/`navigator.languages`, not IP; `translate="no"` on brand names/code tokens.

## Hydration safety

- Inputs with `value` need `onChange` (or `defaultValue`); guard date/time rendering against mismatch; `suppressHydrationWarning` only where truly needed.

## Hover and interactive states

- Buttons/links need `hover:` state; interactive states increase contrast (hover/active/focus more prominent than rest).

## Content and copy

- Active voice, second person; Title Case headings/buttons; numerals for counts; specific button labels ("Save API Key" not "Continue"); error messages include fix/next step; `&` over "and" where space-constrained.

## Anti-patterns (flag these)

`user-scalable=no`/`maximum-scale=1`; `onPaste`+`preventDefault`; `transition: all`; `outline-none` without replacement; inline `onClick` navigation without `<a>`; `<div>`/`<span>` click handlers; images without dimensions; large `.map()` without virtualization; form inputs without labels; icon buttons without `aria-label`; hardcoded formats (use `Intl.*`); `autoFocus` without justification.

## Review output

Findings are grouped by file with `file:line` references, terse; each finding cites the violated rule from the checklist above.
