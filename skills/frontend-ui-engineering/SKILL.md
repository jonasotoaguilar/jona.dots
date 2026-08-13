---
name: frontend-ui-engineering
description: "Trigger: implementing UI: components, pages, layouts, state management, WCAG accessibility, responsive UIs. Implementation-only; design decisions belong to design-ui, not here."
license: Apache-2.0
metadata:
  author: jonasotoaguilar
  version: "3.4.0"
---

## Activation Contract

Use this skill when building or modifying user-facing UI: new components/pages, responsive layouts, interactivity or state management, WCAG accessibility work, or fixing visual/UX issues. It is **implementation-only**: read the project's existing `DESIGN.md` (when present) for tokens, palette, typography, and component rules and implement against them. This skill does not own design decisions or docs and has no design-direction dependency. `impeccable` may be loaded for refinement/polish of an existing surface ONLY when explicitly selected for that task; visual assets/reference comps arrive as typed `image-generation` handoffs from an approved brief.

## Hard Rules

- **Design contract first.** Read `DESIGN.md` when present and implement against its tokens, palette, typography, and component rules. Absent a design system, define only the minimal coherent tokens the work needs (spacing, type scale, neutral colors, one accent) — never invent product direction, brand, or aesthetic decisions; surface those gaps for the design owner.
- **Motion: intent vs mechanics.** `design-ui` and the existing `DESIGN.md` own product motion intent and intensity. `ui-motion` owns implementation mechanics — whether a concrete candidate is justified within that intent, plus easing/duration/springs/stagger/interruptibility/reduced-motion values — and motion review/verification. When intent/values exist in `DESIGN.md`, load `ui-motion`'s standards/physics references and implement them verbatim. When intent is missing, report it as a design dependency for `design-ui`/`sdd-design` and proceed with non-motion work — never invent it or mutate design docs.
- **Compose, don't configure.** Prefer composition over configuration props; components do one thing; separate data fetching from presentation.
- **State by ownership.** Place state by lifecycle, shareability, URL derivability, and server authority (local → lifted → context → URL → server state → global store), not by prop-depth convenience.
- **Accessibility.** Meet the project's stated accessibility target; default to WCAG 2.2 AA for new work: keyboard-operable with visible focus, labels/ARIA names, contrast 4.5:1 (3:1 large), state never color-only, `prefers-reduced-motion` honored.
- **Responsive by content.** Support the smallest and largest viewports the content plausibly targets; no horizontal scroll from your change — fix candidate-caused overflow; pre-existing overflow is not this change's defect.
- **Every surface has states.** Loading, error, empty, and success states designed; loading feedback (skeleton, spinner, optimistic) chosen by expected latency and layout stability.
- **Verification before done.** Keyboard walkthrough, screen-reader pass, and no console errors / axe violations.

## Decision Gates

| Need                                                                                             | Action                                    |
| ------------------------------------------------------------------------------------------------ | ----------------------------------------- |
| Component structure, composition, container/presentational, state ladder                         | `references/component-architecture.md`    |
| Design-system adherence, tokens/scale/type, responsive, content overflow, state/loading evidence | `references/design-system-adherence.md`   |
| Accessibility requirements + verification checklist (WCAG 2.2 AA default)                        | `references/accessibility-checklist.md`   |
| Implementation integrity gates (dependency verification, state cycles, motion handoff)           | `references/implementation-guardrails.md` |
| Apple Liquid Glass web approximation (CSS skeleton)                                              | `references/liquid-glass.md`              |
| More design detail than `DESIGN.md`/`design.md` carries                                          | `../design-ui/references/*` — on-demand   |

If a `design-ui` reference is loaded for detail, implement against it; never re-decide — surface gaps to the design owner (`design-ui`/`sdd-design`).

## Execution Steps

1. Read the project's existing `DESIGN.md` (when present); implement against its tokens and component rules.
2. When the change adds or changes animation: apply the Motion hard rule — load `ui-motion` values when intent exists in `DESIGN.md`; otherwise report the missing intent as a design dependency.
3. Load the reference the Decision Gate names for the current work.
4. Build components per `references/component-architecture.md` (colocate files, compose, container/presentational, simplest state).
5. Apply design-system adherence, responsive, accessibility, and loading/error/empty/success states per the loaded references.
6. Verify against `references/accessibility-checklist.md` (keyboard, screen reader, breakpoints, contrast on CTAs/forms, console errors, axe).

## Output Contract

Return:

- Files changed (exact paths).
- Components built, with their state handling (loading/error/empty/success).
- Accessibility, responsive, and performance notes.
- Verification results: keyboard walkthrough, screen-reader pass, breakpoints tested, console-error check, axe result.

## References

- `references/component-architecture.md` — file structure, composition, container/presentational, state ladder.
- `references/design-system-adherence.md` — contract adherence: tokens/scale, type hierarchy, responsive + content overflow, state/loading evidence, red flags.
- `references/accessibility-checklist.md` — WCAG 2.2 AA requirements + pre-ship verification checklist (keyboard, contrast, states, axe).
- `references/implementation-guardrails.md` — implementation-integrity gates: dependency verification, full state cycles, viewport mechanics, motion handoff to `ui-motion`.
- `references/liquid-glass.md` — Apple Liquid Glass web approximation CSS skeleton (direction: `design-ui`).
- `../design-ui/references/*` — on-demand detail when `DESIGN.md`/`design.md` is too thin; never re-decide.
- `ui-motion` — motion mechanics authority: standards/physics references for exact easing, duration, springs, stagger, interruptibility, reduced motion; intent/intensity belongs to `design-ui`/`DESIGN.md`.
- `impeccable` — refinement/polish executor, loaded only when explicitly selected for that task; `image-generation` — visual assets/comps handoffs from an approved brief.
