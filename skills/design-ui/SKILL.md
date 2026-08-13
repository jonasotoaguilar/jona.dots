---
name: design-ui
description: "Trigger: UI/UX design decisions, flows, states, accessibility, responsive behavior, DESIGN.md, design systems. Decision support for sdd-design that maintains shared DESIGN.md; never composes design.md. Not component implementation."
disable-model-invocation: true
user-invocable: false
license: MIT
metadata:
  author: jonasotoaguilar
  version: "7.0.0"
  delegate_only: true
---

## Execution Role

UI/UX decision support for the `sdd-design` phase: supply criteria, patterns, alternatives, tradeoffs, states, accessibility, responsive behavior, and interaction/motion intent against existing authority; then maintain shared UI/UX authority when a decided change requires it. `sdd-design` exclusively owns design.md composition, wording, sections, persistence, and lifecycle. Do the UI decision and documentation work yourself; never delegate, call the Skill tool, or launch another phase. Never write or mutate `ARCHITECTURE.md`, ADRs, or `PRD.md`.

## Activation Contract

Load when the change has a UI surface and the parent `sdd-design` phase requests UI/UX knowledge. Knowledge surfaces: views, layout, content hierarchy, interaction patterns, states, accessibility, responsive behavior, motion/interaction intent, design-system and dependency choices. Not component implementation.

## Hard Rules

- **Authority first.** Read `./DESIGN.md`, `./ARCHITECTURE.md`, `./PRD.md`, and ADRs before reasoning; decided constraints win; conflicts surface, never override silently.
- **Design boundary.** Never prescribe or compose design.md sections, wording, headings, insertion points, or integration packages; `sdd-design` decides where UI/UX reasoning appears in the change-specific design.md.
- **Lazy references.** Load `references/*` only when the decision surface demands it.
- **Context7.** Pin exact manifest versions for framework/library/design-system picks; cite source; surface conflicts.
- **Anti-template.** Two-altitude check before locking direction; emojis content-only, never functional icons.
- **Shared-document ownership.** Update `DESIGN.md` only when a decided change adds or changes durable shared UI/UX authority: visual/design-system principles, global interaction patterns, states, responsive/accessibility rules, content hierarchy, shared tokens/components behavior. A change-local UI decision or unresolved proposal never mutates shared docs.
- **No architecture ownership.** Never write or mutate `ARCHITECTURE.md`, ADRs, or `PRD.md`. Technical architecture questions (system/API boundaries, persistent data contracts) are outside this skill: surface the constraint to `sdd-design`, without routing or delegating. Change-specific technical contracts (types, reducers, CSS/data/ARIA contracts) may inform `sdd-design`; where they are written is not this skill's call.
- **Implementation boundary.** This skill decides; it does not build. Implementation mechanics (composition, state code, a11y code, responsive build, CSS skeletons) belong to `frontend-ui-engineering`; motion values to `ui-motion`; library installs to `references/libraries/` + Context7. Never duplicate implementation playbooks here.
- **Documentation discipline.** Follow the project's existing `DESIGN.md` structure and the `documentation` skill's mechanics/contract (structure, redaction, validation); reference that contract, never delegate. Merge narrowly, preserve unrelated content, and run existing validation when available; otherwise perform structural readback.

## Decision Gates

### Decision Classification

| Class                   | Meaning                      | Action                                                               |
| ----------------------- | ---------------------------- | -------------------------------------------------------------------- |
| Existing authority      | Covered by `DESIGN.md`       | Cite it; no document change unless the decision changes it           |
| Conflict                | Change contradicts authority | Surface conflict and options; parent decides                         |
| Change-local            | Scoped to this change        | Supply knowledge for the local choice; shared docs usually unchanged |
| Cross-cutting candidate | Durable, project-wide impact | Supply knowledge and classify its documentation impact               |

### Documentation Impact

Classify only decided UI changes. Unresolved proposals never update shared documentation.

| Impact          | Use when                                                                                                                                                                                                                 | Action                                                                    |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------- |
| `none`          | Existing authority still applies, or the decision is change-local                                                                                                                                                        | Do not mutate shared docs                                                 |
| `update_design` | The decision adds or changes durable shared UI/UX authority (visual/design-system principles, global interaction patterns, states, responsive/accessibility rules, content hierarchy, shared tokens/components behavior) | Update the relevant existing `DESIGN.md` content narrowly and validate it |

### Reference Loading

| Decision surface                                 | Load                                                                                                                                                                    |
| ------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Existing UI / redesign                           | `references/preflight-and-preservation.md`                                                                                                                              |
| Screen flow / design priority                    | `references/ui-ux-guidelines.md`                                                                                                                                        |
| Visual direction / anti-template                 | `references/design-direction.md`                                                                                                                                        |
| Web interfaces (a11y, forms, motion, perf, i18n) | `references/web-interface-guidelines.md`                                                                                                                                |
| Mobile / native interfaces                       | `references/mobile-interface-guidelines.md`                                                                                                                             |
| Components, states, tokens, block schema         | `references/component-guidelines.md`                                                                                                                                    |
| Public-page SEO / content                        | `references/seo-ui-guidelines.md`                                                                                                                                       |
| Redesign workflow                                | `references/redesign-protocol.md`                                                                                                                                       |
| Final pre-flight gate                            | `references/preflight-check.md`                                                                                                                                         |
| Library / design-system                          | `references/libraries/web.md`, `references/libraries/design-systems.md`, `references/libraries/native.md` + Context7; `references/libraries/catalogs.md` reference-only |
| Evidence datasets                                | `assets/` via `scripts/search.py` — query-only, never `--persist`                                                                                                       |
| No UI surface                                    | `not_applicable`; STOP                                                                                                                                                  |
| Fully covered (read first)                       | `not_needed`; STOP                                                                                                                                                      |

### External Routing

| Need                                                                     | Route                                                                                                     |
| ------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------- |
| Motion values / physics (easing, springs, durations, stagger)            | `ui-motion` — intent lives here (`design-direction.md` § 6); values live there                            |
| Implementation (stack conventions, state code, a11y code, CSS skeletons) | `frontend-ui-engineering`                                                                                 |
| Technical dependency / design system install                             | `references/libraries/web.md` / `design-systems.md` / `native.md` — ONE pick, install only when requested |
| Site-wide SEO/runtime audit (all pages)                                  | `unlighthouse` — measured evidence only; design authority stays here                                      |
| Validate updated DESIGN.md                                               | `npx @google/design.md lint DESIGN.md`; fix errors or report blocker                                      |
| Multi-domain (UI + backend)                                              | Read `design-architecture` first                                                                          |

## Execution Steps

1. Resolve project root; read authority docs (`DESIGN.md`, `ARCHITECTURE.md`, `PRD.md`, ADRs). Fully covered → `not_needed`; STOP.
2. Classify each UI decision surface per Decision Classification; unresolved choices remain unresolved and have no documentation impact.
3. Lazy-load the minimal reference per surface; use Context7 only when new/version-sensitive.
4. For each decided change, classify documentation impact as `none` or `update_design` and explain why.
5. Apply every `update_design` impact directly: update the relevant existing `DESIGN.md` content narrowly, preserving unrelated content.
6. Validate changed docs with existing project validators when available (per `documentation` mechanics); otherwise perform structural readback and verify links/references.
7. Return concise decision knowledge plus exact `DESIGN.md` path changed and validation evidence; never compose design.md.

## Output Contract

- Status: `applicable` | `not_needed` | `not_applicable` | `blocked`.
- For `applicable`: concise per-surface decision knowledge — classification, options and tradeoffs, constraints, authority comparison, chosen documentation impact, and rationale.
- Documentation changes: exact `DESIGN.md` path changed, action (`updated`), and validation evidence; `None` when impact is `none`.
- Block unresolved conflicts instead of mutating shared authority. Never return design.md sections, wording, insertion points, package fields, phase routing, or delegation instructions.

## References

- `references/design-direction.md` — visual direction: brief inference, dials, system map, typography/color/layout/materiality, anti-template, content honesty.
- `references/ui-ux-guidelines.md`, `references/web-interface-guidelines.md`, `references/mobile-interface-guidelines.md` — screen flow and platform interface rules.
- `references/component-guidelines.md`, `references/seo-ui-guidelines.md`, `references/preflight-and-preservation.md`, `references/redesign-protocol.md`, `references/preflight-check.md` — components/blocks, public-page SEO, existing-UI pre-flight, redesign workflow, final gate.
- `references/libraries/` — library/design-system selection aids and catalogs.
- `assets/` — datasets; `scripts/search.py` — query-only search CLI (never `--persist`).
