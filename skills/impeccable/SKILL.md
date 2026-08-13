---
name: impeccable
description: "Trigger: UI critique, refinement, polish, redesign execution, live browser iteration. Heuristic UX/visual critique and refinement executor after an approved design contract; not the design authority."
version: 4.1.0
user-invocable: true
argument-hint: "[critique|audit|polish|bolder|quieter|distill|harden|onboard|animate|colorize|typeset|layout|delight|overdrive|clarify|adapt|optimize|shape|init|document|extract|live] [target]"
license: Apache 2.0
allowed-tools:
  - Bash(npx impeccable *)
  - Bash(node .opencode/skills/impeccable/scripts/*)
---

## Execution Role

UI refinement/polish executor and heuristic UX/visual critique adapter. Operates AFTER an approved design contract (DESIGN.md / surface brief) or an explicit user request to redesign. NOT the canonical design owner: product UI/UX decisions → `design-ui`/`sdd-design`; DESIGN.md template/schema/writing → `documentation`; generic UI implementation → `frontend-ui-engineering`; motion mechanics → `ui-motion`; image assets/comps → `image-generation`; browser automation/diagnosis/audits → `agent-browser` / `browser-testing-with-devtools` / `playwright` / `unlighthouse`. In SDD, `design-ui` supplies approved design decisions and `sdd-apply` may load this skill for an explicit refinement implementation task; `sdd-verify` and the browser tools own evidence. This skill never creates SDD artifacts or verdicts.

## Activation Contract

Load for UI critique/refinement/polish/redesign execution and explicit commands (`/impeccable ...`). Command index and intent groups live in `reference/routing.md`. Not every frontend design request: implementation without a critique/refinement intent routes to `frontend-ui-engineering`; design decisions to `design-ui`.

## Hard Rules

- **The brief wins.** Honor pinned aesthetics, eras, materials, fonts, and palettes even against a saturated-pattern warning; never redirect a clear brief toward your taste.
- **Refinement preserves; redesign replaces.** Refinement keeps incumbent identity, behavior, copy, and everything outside scope; ask before replacing factual copy. Redesign requires explicit user approval and returns proposed design-contract changes to `design-ui`/the parent — never directly replaces DESIGN.md.
- **Design contract first.** Read the existing DESIGN.md and surface brief before acting; a missing DESIGN.md alone is not greenfield.
- **Visitor modes from the surface.** Persuade (decide/act), Operate (task), Read (comprehension), Experience (artifact-led); persist only in the surface brief.
- **Bounded QA, one cycle.** One batched inspection (desktop + mobile) → one fix batch → at most one confirmation pass; then stop. Open-ended self-QA is prohibited.
- **Explicit-only operations.** The context script runs ONCE, read-only; the design detector hook, `live`, `pin`/`unpin`, and `doctor` are never auto-run. `doctor` repair, context mutation, and drift fixes happen only on explicit user request; a `CONTEXT_STALE` finding is reported, not acted on.
- **Implementation only when selected.** This skill implements/refines UI only when explicitly selected for that task; otherwise it returns critique and plans.
- **One-way handoffs.** Route motion mechanics to `ui-motion`, assets/comps to `image-generation`, browser evidence to the browser tools; never load them recursively.

## Decision Gates

| Situation                              | Route                                                                                                                                                                                     |
| -------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| No argument                            | Load `reference/routing.md`; present its context-aware menu; never auto-run a command                                                                                                     |
| Explicit or clearly implied command    | Load its reference (native variant on native platforms); ask once if two fit                                                                                                              |
| New surface / replacement visual world | `reference/new-work.md` (redesign approval first, per Hard Rules)                                                                                                                         |
| Missing PRODUCT.md                     | `init` (teach aliases init), then the surface flow                                                                                                                                        |
| Build intent (`shape`)                 | `reference/shape.md`; enters new-work only for visual-world/surface-concept decisions                                                                                                     |
| Deprecated alias                       | `craft` → `new-work` (adds nothing)                                                                                                                                                       |
| `document` intent                      | `reference/document.md`: inspect UI/code, extract grounded visual evidence; missing decisions → `design-ui`; approved/existing → typed payload → `documentation` (never writes DESIGN.md) |
| Ambiguous intent                       | Ask one question                                                                                                                                                                          |

Command → reference index and intent groups (Build, Evaluate, Refine, Enhance, Fix, Iterate) live in `reference/routing.md` (lazy).

## Execution Steps

1. Run the context script ONCE, read-only: `node .opencode/skills/impeccable/
scripts/context.mjs --target <path>` (when the runtime shows this skill's loaded base directory, run `node <skill-base-dir>/scripts/context.mjs`; keep cwd at the user's project). Follow its directives; do not rerun it.
2. Determine preserve vs. redesign (Hard Rules); secure explicit approval for any redesign.
3. Load the ONE playbook that owns the request: the command's reference, or `reference/new-work.md` for a new surface or replacement world. Inspect the target and at least one representative source of incumbent visual truth (tokens, theme, CSS, component, or asset) before editing.
4. Immediately before editing UI, load `reference/craft-floor.md` (quality floor, absolute bans, reflexes no detector catches); not for planning-only work.
5. Execute per the playbook; implement/refine only when explicitly selected for the task; follow the committed world, never category habit.
6. Run the bounded QA cycle: one batched desktop/mobile inspection, one fix batch, at most one confirmation pass.
7. Route evidence and handoffs: browser evidence paths, proposed design-contract changes to `design-ui`/parent, motion mechanics to `ui-motion`.

## Output Contract

Return: files changed (exact paths); critique/audit scored findings with locations, severity (P0-P3), and evidence; bounded QA results (inspection, fix batch, confirmation pass); typed handoffs (design-contract changes → `design-ui`/parent, never applied here; visual-evidence payload → `documentation` for DESIGN.md writing; motion mechanics → `ui-motion`; asset needs → `image-generation`; browser evidence paths); commands/scripts actually run. No SDD artifacts or verdicts.

## References

- `reference/routing.md` — command → reference index and no-argument menu.
- `reference/craft-floor.md` — quality floor; load before editing UI.
- `reference/new-work.md` — new surfaces and replacement worlds (redesign).
- `reference/{command}.md` — per-command playbooks; native variants on native platforms; lazy-load only the one you run.
- `reference/degraded/` — fallback flows for harnesses without subagent/browser support.
- `scripts/` — `context.mjs` (read-only), `detect.mjs`, `pin.mjs`, `doctor.mjs`, `live*.mjs` (explicit-only).
