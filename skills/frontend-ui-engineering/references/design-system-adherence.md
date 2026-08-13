# Design System Adherence

Implement against the project's design contract — tokens, scale, and component rules from `DESIGN.md` — never substitute invented values or parallel styles.

## Contract Adherence

**Spacing and layout**

- Use the project's spacing scale; never invent values (no `13px`, no `2.3rem`).
- Component structure follows the documented layout rules, not a generic default.

**Typography**

- Respect the type hierarchy (`h1` → `h2` → `h3` → body → small); no skipped heading levels; no heading styles on non-heading content.

**Color**

- Use semantic color tokens (`text-primary`, `bg-surface`, `border-default`), never raw hex values.
- Sufficient contrast: 4.5:1 normal text, 3:1 large text, 3:1 UI components/icons/focus (see `accessibility-checklist.md`).
- Never rely on color alone to convey state.

**Responsive and content overflow**

- Mobile-first; every multi-column layout declares its `< 768px` fallback.
- Test at 320px, 768px, 1024px, 1440px; no horizontal scroll from this change — fix candidate-caused overflow (pre-existing overflow is not this change's defect).
- Use realistic content in examples and previews — placeholder text hides length/wrapping/overflow defects.

**State and loading evidence**

- Loading feedback matches the final layout's shape (skeleton, not a generic spinner), chosen by expected latency and layout stability.
- Optimistic updates apply locally and roll back on error, per the project's data layer.
- Empty states indicate how to populate; error states offer a fix, never blame.

## Red Flags

- Inline styles or arbitrary pixel values instead of the scale/tokens.
- Missing error, loading, or empty states; no keyboard-navigation testing.
- Color as the sole state indicator; unchecked contrast on CTAs and forms.
- Components so large they need splitting (no hard line count — use judgment).
