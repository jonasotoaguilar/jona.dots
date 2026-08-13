# Accessibility Checklist (WCAG 2.2 AA)

Use when building or modifying UI and during the verification pass. Meet the project's stated accessibility target; default to **WCAG 2.2 AA** for new work.

## Requirements

**Keyboard navigation**

- Every interactive element is focusable and operable by keyboard (Tab, Enter, Space, arrows); no keyboard traps; Tab order matches visual order; skip links reach main content.
- Visible focus indicator on every interactive element (`:focus-visible`); never `outline: none` without a replacement.

**Labels and names**

- Every input has a visible `<label>`; `aria-label` only when no visible label is possible.
- Icon-only buttons have an accessible name; images have meaningful `alt` (decorative: `alt=""`).
- Errors are connected to fields (`aria-describedby`/`aria-errormessage`) and announced.

**Semantics and structure**

- Prefer semantic HTML (`button`, `a`, `label`, `table`, `nav`, `main`) over ARIA; one `<h1>` per page; no skipped heading levels; landmarks for header/nav/main/footer; `aria-live` for async updates.
- Native elements win: a `<div role="button" tabIndex={0}>` is only acceptable when a `<button>` genuinely cannot be used.

**Contrast**

- Normal text ≥ 4.5:1; large text (≥18pt or 14pt bold) ≥ 3:1; UI component boundaries, icons, and focus indicators ≥ 3:1.
- Audit every interactive control against its actual background — CTA buttons and form fields included (white-on-white, transparent-over-photo, and light placeholder-on-light-background patterns fail this).

**Motion**

- Honor `prefers-reduced-motion`: reduce/disable non-essential animation, never a global kill that removes feedback; animations never block focus, reading, or task completion; animate `transform`/`opacity` only.

**States**

- State is never conveyed by color alone (add icon, text, or pattern); disabled, loading, empty, error, and success states are programmatically identifiable (`aria-busy`, `role="status"`, etc.).

## Verification Checklist (pre-ship)

- [ ] Component renders without console errors; axe-core run and clean.
- [ ] Full keyboard walkthrough: every interactive element reachable and operable, no traps.
- [ ] Screen-reader pass (VoiceOver/NVDA/ORCA) conveys content and structure.
- [ ] Responsive at 320px, 768px, 1024px, 1440px; no horizontal scroll from this change.
- [ ] Loading, error, empty, and success states handled and identifiable.
- [ ] Focus visible, contrast met (CTAs and forms included), reduced-motion honored.
- [ ] Forced-colors/zoom-to-200% spot check.

## Testing Tools

- axe-core (`@axe-core/playwright`, `axe` browser extension, or `@axe-core/cli`) — fix all violations.
- Manual passes: keyboard walkthrough, screen reader, 200% zoom, forced colors.
