# Implementation Guardrails

> Load when the request needs implementation-integrity rules: dependency verification, interactive-state completeness, viewport mechanics, motion handoff. Where a rule is owned by another skill, this file defers instead of duplicating.

## Ownership Map (defer, don't duplicate)

| Rule area                                     | Owner                                                                         |
| --------------------------------------------- | ----------------------------------------------------------------------------- |
| Design contract, tokens, DESIGN.md            | existing `DESIGN.md` (read generically; never overrides it)                   |
| Responsive floor, breakpoints, CWV targets    | existing `DESIGN.md` / responsive contract                                    |
| Motion intent, values, physics, skeletons     | `ui-motion` — load its standards/physics references; never invent motion here |
| Implementation, audit, polish, live iteration | `impeccable` (executes when explicitly selected)                              |

## Integrity Gates

- **Dependency verification (mandatory).** Before importing ANY third-party library, check `package.json`. Missing → output the install command first; never assume a library exists.
- **Full state cycles.** LLMs default to "static successful state only": implement loading, empty, error, and success states with tactile feedback (`:active` press). Contrast-audit every CTA and form field against its actual background (see `accessibility-checklist.md`).
- **Viewport stability.** Full-viewport sections use `min-h-[100dvh]`, never `h-screen` (mobile address-bar jump). Prefer CSS Grid over flex percentage math for multi-column layouts.
- **Motion handoff.** Any added animation: if intent/values exist in `DESIGN.md`, implement per `ui-motion`'s standards; if missing, report the missing motion intent as a design dependency for `design-ui`/`sdd-design` and proceed with non-motion work. No fixed skeletons here.
