# Component Design Guidelines

Use this reference when designing reusable UI primitives, components, blocks, templates, or design system APIs. This file is the component **design contract**; implementation mechanics (composition, state, a11y code, responsive build) are executed by `frontend-ui-engineering` — do not re-implement its playbooks here.

## Component Taxonomy

- **Primitive**: low-level accessible building block, e.g. Button, Input, Dialog.
- **Component**: composed reusable UI with product semantics, e.g. SearchBox, PricingCard.
- **Block**: larger reusable section, e.g. Hero, FeatureGrid, CheckoutForm.
- **Template**: full-page layout with slots and content structure.

## Component Rules

- Start with semantic HTML and accessibility behavior before styling.
- Define anatomy: root, label, control, icon, helper text, error text, content, actions.
- Define variants by intent and state, not by arbitrary visual names.
- Support the full state contract where applicable: default, hover, focus-visible, active, disabled, loading, error, success (plus selected, invalid, empty when the component needs them).
- Keep geometry stable across states: `border-width`, padding, and height never change between states — signal state via background, outline, or box-shadow; the `:focus-visible` ring is visible, instant (never animated), and ≥ 3:1 contrast.
- Expose a single, explicit way for parents to read and override interactive state; do not mix ownership patterns accidentally.
- Use data attributes for styling states: `data-state`, `data-disabled`, `data-invalid`, `data-loading`.
- Keep component APIs small; prefer composition/slots for advanced customization.
- Use polymorphism (`asChild`/`as`) only when semantic output remains accessible.
- Document keyboard behavior for interactive components.

## Accessibility Requirements

- Inputs must have visible labels and associated accessible names.
- Icon-only controls need accessible labels.
- Errors must be connected to fields with `aria-describedby`/`aria-errormessage` where applicable.
- Dialogs, menus, comboboxes, tabs, accordions, and popovers need correct ARIA patterns and focus management.
- All functionality must work with keyboard only.
- Focus indicators must be visible and consistent.

## Styling and Tokens

- Use semantic tokens: `surface`, `text`, `primary`, `danger`, `border`, `focus`, not one-off hex values. Applies to fonts too: `font-family` references font tokens, never a raw face at the call site. When a needed value has no token, promote it to the token source of truth (`DESIGN.md` + token file) first, then reference it by name.
- Keep spacing, typography, radius, shadow, and motion tied to the design system.
- Avoid hardcoding colors inside components unless creating/updating tokens in `DESIGN.md`.
- Design light/dark variants together; do not invert colors mechanically.

## Block Library (Contract)

The Pattern Vocabulary (`design-direction.md` § 11) names patterns; the Block Library implements them with real props, real motion specs, and real code sketches. One block per file; every block works standalone (drop it into a page, it renders); every block passes the Pre-Flight Check (`preflight-check.md`).

**Schema (required per block file):**

- **Frontmatter:** `name`, `category`, `dial_compatibility` (`variance`/`motion`/`density` ranges), `when_to_use`, `not_for`, `stack`.
- **Body sections:** visual sketch; props API; minimal code sketch (Server Component default, Client island for motion); explicit mobile fallback (< 768px); one motion variant per `MOTION_INTENSITY` band (1-3, 4-7, 8-10) with explicit reduced-motion fallback; dark-mode token strategy; anti-patterns; links to real production examples.
- Blocks that depend on a design system live under `blocks/<category>/<name>--<system>.md`.

## Documentation Checklist

- [ ] Purpose and when to use.
- [ ] Anatomy and slots.
- [ ] Props/API and state-ownership behavior.
- [ ] Variants and states.
- [ ] Accessibility and keyboard interactions.
- [ ] Responsive behavior.
- [ ] Examples for common and edge cases.
- [ ] Token dependencies and `DESIGN.md` impact.
