---
name: ui-motion
description: "Trigger: concrete motion mechanics/review: easing, duration, springs, interruptibility, reduced-motion, effect naming, whether to animate. Product intent stays design-ui; this is implementation/review."
license: Apache-2.0
metadata:
  author: jonasotoaguilar
  version: "1.5.1"
---

## Activation Contract

Use when the task involves motion: whether something should animate, choosing easing/duration/springs, reviewing motion quality, auditing a codebase's animation, improving existing animations, or naming a described effect. Motion is implementation, review, and verification, not visual design — the "whether/how intense" direction is set by `design-ui` intent; the physics values, review bar, and improvement plans live here. It does not run on its own — load only by the orchestrator or explicit invocation.

## Hard Rules

- Restraint first. "Don't animate" is a valid and often correct answer.
- Justified motion. Every animation answers "why does this animate?" — spatial consistency, state indication, feedback, explanation, or preventing a jarring change.
- Budget by context. Interaction frequency, latency, and design intent choose the motion budget — high-frequency/low-latency interactions get less or no animation. Exact tiers and durations live in `references/standards.md`.
- Repeated motion is interruptible. Rapidly-triggered or gesture-driven motion uses transitions or springs so it can be interrupted and retargeted.
- Compositor-friendly properties preferred. Default to compositor-friendly properties (`transform`, `opacity`); exceptions are allowed when measured and documented.
- Reduced motion preserves meaning. Under `prefers-reduced-motion`, keep comprehension and remove nonessential motion; exact behavior per `references/standards.md`.
- Overlay origin where relevant. Trigger-anchored origin and overlay guidance applies only where the pattern is relevant (e.g. popovers); exceptions per `references/standards.md`.
- Cite, don't approximate. Values in findings/plans come from references/standards.md, verbatim.
- Never invent vocabulary. Match a described effect to a real term in references/vocabulary.md or say no match exists.
- Read-only on source. `find`/`review`/`improve`/`design` never apply changes or write repository docs — including DESIGN.md; they produce evidence, plans, and proposed mechanics packages as content.
- Never write DESIGN.md. Product motion intent and intensity belong to `design-ui`/the existing DESIGN.md; this skill owns implementation mechanics (whether a concrete candidate is justified within that intent, plus values) and review/verification. The `design` mode returns a proposed mechanics package to the design owner/parent for integration; missing intent/intensity is a design dependency, not something this skill establishes or records. `impeccable`'s `animate` and motion work route mechanics here — it may request the mechanics package; it never supplies physics values itself.
- Standalone consultation. When invoked explicitly for motion advice, return recommendations as content; no source or doc mutation.
- Decide autonomously. Weigh brief, product, frequency, constraints, pick the best direction, and continue; never build variant harnesses or block waiting for a human pick.

## Decision Gates

| Task                                            | Mode      | Load                                         |
| ----------------------------------------------- | --------- | -------------------------------------------- |
| Whether/how to animate, easing/duration/springs | `design`  | craft.md + physics.md + standards.md         |
| Restraint-first opportunity sweep               | `find`    | opportunities.md + standards.md              |
| Reviewing a diff / existing animations          | `review`  | review.md + standards.md                     |
| Auditing motion and producing plans             | `improve` | improve.md + standards.md + plan-template.md |
| Naming a described effect                       | `name`    | vocabulary.md                                |

Gesture-driven/fluid interfaces (drag, springs, momentum): also read physics.md. General craft context: read craft.md first.

## Execution Steps

1. Route the request to one mode via Decision Gates; if ambiguous, ask one question.
2. `design`: read craft.md, then physics.md if gestures/springs and standards.md for values. Decide: frequency tier, purpose, easing, duration, spring config, reduced-motion fallback. Return the proposed mechanics package as content to the design owner/parent for integration; never write DESIGN.md or any doc.
3. `find`: follow opportunities.md — recon, run the gate, reject most candidates, output the required table + rejected candidates + verdict.
4. `review`: follow review.md — measure against the standards, cite standards.md, apply escalation triggers, render the findings table + verdict.
5. `improve`: follow improve.md — recon → parallel audit → vet/prioritize → produce self-contained plans with plan-template.md, returned as content (write `plans/` files only when explicitly requested).
6. `name`: follow vocabulary.md Quick Start — return best-matching term(s).
7. Stop at the evidence boundary. `find`/`review`/`improve` output evidence and plans; never touch source code.

## Output Contract

Per mode: design → proposed mechanics package with values (purpose, frequency tier, easing, duration, spring config, reduced-motion fallback) + refs used, handed to the design owner/parent for integration; no doc writes. find → opportunities table, rejected candidates, verdict. review → findings table (`file:line` + evidence, severity) + verdict + escalation. improve → vetted findings by leverage, plans per plan-template.md returned as content (`plans/` files only when explicitly requested). name → best-matching term(s) + 1–2 alternates. Always: mode used, refs loaded, source code and docs not modified.

## References

All in `references/` (lazy — load only the ones your mode needs):

- craft.md — design-engineering craft: review format, decision framework, spring config, component principles, performance, a11y.
- physics.md — fluid interface physics: response, direct manipulation, interruptibility, velocity handoff, momentum, rubber-banding, materials, reduced motion.
- vocabulary.md — reverse-lookup glossary: description → exact term.
- standards.md — deduped rule catalog (frequency, easing, duration, physicality, springs, interruptibility, performance, transforms, gestures, a11y, cohesion) + "Hunt for" checklists.
- opportunities.md — the opportunity gate (find mode).
- review.md — the review workflow (review mode).
- improve.md — the audit-then-plan workflow (improve mode).
- plan-template.md — self-contained plan template for executor agents.
- `impeccable` — routes its `animate`/motion mechanics here; never loaded recursively.
