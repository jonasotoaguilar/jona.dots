---
name: image-generation
description: "Trigger: AI image, generate image, text to image, t2i, flux, image editing, web design reference, mobile app screens. Produce/edit visual assets and reference comps via belt; implementation hands off to its owner."
license: Apache-2.0
metadata:
  author: "jonasotoaguilar"
  version: "1.1"
allowed-tools: Bash(belt *)
---

## Execution Role

Produces and edits visual assets, and produces image-based reference comps from an approved design brief. This skill NEVER implements code and never owns product design decisions: `design-ui` owns product UI/UX decisions and the visual system; `frontend-ui-engineering`/`impeccable` own implementation; `ui-motion` owns motion mechanics. Implementation requests are analyzed here and handed off as typed constraints.

## Activation Contract

Use for one explicit intent: generating/editing images via `belt`, or producing image-based reference comps for web/mobile surfaces from an approved design brief. Not for product UI/UX decisions (route `design-ui`), not for implementing UI from images (route the implementation owner), not for motion mechanics (route `ui-motion`).

## Hard Rules

- `belt` MUST be on PATH. If missing, report and stop — no silent install; setup happens out-of-band with explicit user approval.
- No silent `belt login`. Generation is remote and paid: obtain explicit user approval for paid runs when cost/side effects are not already authorized; use `belt app run --estimate` to surface predicted cost when uncertain.
- Choose exactly one role per request: asset generation/editing, reference comp from approved brief, or implementation handoff. Never blend role contracts.
- Scope, image count, aspect, and framing come from the approved brief and the deliverable need — no universal "one image per section" rule, no universal phone-mockup presentation, no fixed style/category variation engines.
- Reference comps are produced FROM an approved design brief; they never establish product design decisions (that is `design-ui`'s contract).
- Regenerate fresh standalone images only when cropping an existing render would destroy fidelity — a conditional, not the default.
- Load the role's reference and apply the shared quality gates before delivery.

## Decision Gates

| Intent                                                           | Role                                            | Load                             |
| ---------------------------------------------------------------- | ----------------------------------------------- | -------------------------------- |
| AI art, products, social graphics, editing, upscaling via `belt` | Asset generation/editing                        | `references/models.md`           |
| Web comps (heroes, sections, pages) from approved brief          | Reference comp — web                            | `references/web-direction.md`    |
| Mobile comps (screens, flows) from approved brief                | Reference comp — mobile                         | `references/mobile-direction.md` |
| Implementation from images                                       | Analyze + typed handoff to implementation owner | `references/image-to-code.md`    |

## Execution Steps

1. Confirm `belt` on PATH and auth; obtain explicit approval for paid runs (Hard Rules).
2. Declare the role from the user's intent.
3. For comps: read the approved brief (DESIGN.md / surface brief) and scope count/aspect/framing from it.
4. Run `belt` per `references/models.md`; use `--estimate` for cost awareness.
5. Apply the shared quality gates (`references/quality.md`) before delivery.
6. Implementation requests: analyze the references, return the extracted constraints, and hand off — never write code.

## Output Contract

- Asset: image(s) or CLI result, including the app ID and artifact paths.
- Comp: labeled images scoped per the brief, with consistency and legibility gates applied.
- Implementation handoff: reference analysis + typed handoff to the implementation owner (`frontend-ui-engineering`, or `impeccable` when explicitly selected for refinement implementation).
- Auth/cost status when relevant to the run.

## References

- `references/models.md` — `belt` setup, auth, dynamic catalog discovery, run examples.
- `references/quality.md` — shared anti-slop, consistency, legibility, and provenance gates.
- `references/web-direction.md` — web comp art direction from an approved brief.
- `references/mobile-direction.md` — mobile comp framing and flow rules.
- `references/image-to-code.md` — image analysis and implementation handoff contract.
