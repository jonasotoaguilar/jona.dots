---
name: design-architecture
description: "Trigger: backend/API architecture, system boundaries, data flow, persistence, cross-service, ADRs, ARCHITECTURE.md. Decision support for sdd-design that maintains shared architecture docs; never composes design.md."
disable-model-invocation: true
user-invocable: false
license: Apache-2.0
metadata:
  author: jonasotoaguilar
  version: "7.1.0"
  delegate_only: true
---

## Execution Role

Decision support for the `sdd-design` phase: supply patterns, criteria, tradeoffs, constraints, and comparisons against existing authority; then maintain shared architecture authority when a decided change requires it. `sdd-design` exclusively owns design.md composition, wording, sections, persistence, and lifecycle. Do this work yourself; never delegate, call the Skill tool, or launch another phase. Never write or mutate `DESIGN.md` or `PRD.md`.

## Activation Contract

Load when the change has architecture surface and `sdd-design` requests architecture knowledge: API and system boundaries, data flow, persistence and consistency, modules and topology, cross-service and realtime communication, resilience, NFRs, dependency-version decisions. Not feature design.

## Hard Rules

- **Authority first.** Read `./ARCHITECTURE.md`, `./DESIGN.md`, `./PRD.md`, and ADRs before reasoning; decided constraints win; surface conflicts, never override silently.
- **Design boundary.** Never prescribe or compose design.md sections, wording, headings, insertion points, or integration packages.
- **Lazy references.** Load `references/*` only when the decision surface demands it.
- **Context7.** Pin exact manifest versions; cite; surface conflicts.
- **Shared-document ownership.** Update `ARCHITECTURE.md` only when a decided change adds or changes shared boundaries, flows, ownership, or principles. Create an ADR only for a durable decision with meaningful alternatives and tradeoffs. Change-local or unresolved decisions never mutate shared docs.
- **ADR history.** When a decided change replaces an existing ADR, create the replacement and mark the prior ADR `Superseded`; never delete or silently rewrite ADR history.
- **Documentation discipline.** Follow the project's existing architecture/ADR location, structure, and numbering. Merge narrowly, preserve unrelated content, and run existing validation when available.

## Decision Gates

### Decision Classification

| Class                   | Meaning                           | Action                                                     |
| ----------------------- | --------------------------------- | ---------------------------------------------------------- |
| Existing authority      | Covered by `ARCHITECTURE.md`/ADRs | Cite it; no document change unless the decision changes it |
| Conflict                | Change contradicts authority      | Surface conflict and options; parent decides               |
| Change-local            | Scoped to this change             | Supply knowledge; shared docs usually unchanged            |
| Cross-cutting candidate | Durable, project-wide impact      | Supply knowledge and classify documentation impact         |

### Documentation Impact

Apply only to decided changes; unresolved proposals never update shared documentation.

| Impact                | Use when                                                        | Action                                                                                   |
| --------------------- | --------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| `none`                | Existing authority applies, or change-local                     | Do not mutate shared docs                                                                |
| `update_architecture` | Adds/changes shared boundaries, flows, ownership, or principles | Update relevant `ARCHITECTURE.md` content narrowly and validate                          |
| `create_adr`          | Durable decision with meaningful alternatives/tradeoffs         | Create ADR per project convention; capture choice, alternatives, rationale, consequences |
| `supersede_adr`       | Decided change replaces an existing durable ADR                 | Create replacement ADR; mark prior superseded; never delete it                           |

### Reference Loading

| Decision surface                      | Load                                                                                                                                     |
| ------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| API design                            | `references/api-design.md`                                                                                                               |
| Store / consistency                   | `references/database-selection.md`, `references/database-operations.md`, `references/data-consistency.md`                                |
| Modules / topology / resilience / NFR | `references/module-design.md`, `references/architecture-patterns.md`, `references/resilience-patterns.md`, `references/nfr-checklist.md` |
| Cross-service / realtime              | `references/cross-service-guidance.md`, `references/realtime-communication.md`                                                           |
| No architecture surface               | `not_applicable`; STOP                                                                                                                   |
| Fully covered (read first)            | `not_needed`; STOP                                                                                                                       |

## Execution Steps

1. Resolve project root; read authority docs (`ARCHITECTURE.md`, `DESIGN.md`, `PRD.md`, `docs/adr/`). Fully covered → `not_needed`; STOP.
2. Classify each decision surface per Decision Classification; unresolved choices remain unresolved and have no documentation impact.
3. Load the reference matched by Reference Loading; use Context7 only when new/version-sensitive.
4. For each decided change, classify documentation impact as `none`, `update_architecture`, `create_adr`, or `supersede_adr` and explain why.
5. Apply every non-`none` documentation impact directly: update `ARCHITECTURE.md`, create an ADR, or create a replacement ADR and mark the prior one superseded.
6. Validate changed docs with existing project validators when available; otherwise perform structural readback and verify links/ADR references.
7. Return concise decision knowledge plus exact documentation paths changed and validation evidence; never compose design.md.

## Output Contract

- Status: `applicable` | `not_needed` | `not_applicable` | `blocked`.
- `applicable`: concise per-surface decision knowledge — classification, options and tradeoffs, constraints, authority comparison, chosen documentation impact, rationale.
- Documentation changes: exact paths changed, action (`updated` | `created` | `superseded`), validation evidence; `None` when impact is `none`.
- Block unresolved conflicts instead of mutating shared authority. Never return design.md sections, wording, insertion points, package fields, phase routing, or delegation instructions.

## References

- `references/*` — per-surface architecture knowledge, loaded lazily by gate.
