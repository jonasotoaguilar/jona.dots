---
name: interview-me
description: "Trigger: interview me, grill me, underspecified ask, missing intent. One-question-at-a-time intent discovery; initial-request only, stops on confirmation."
license: Apache-2.0
metadata:
  author: jonasotoaguilar
  version: "1.2.0"
---

## Activation Contract

Use when a request is missing initial intent — who the user is, the problem, the desired outcome, success criteria, why now, or the binding constraint — or when the user explicitly invokes the interview ("interview me", "grill me"). Use for initial idea/request work only, before planning or implementation. Stop once intent is explicitly confirmed and never reactivate automatically later. Do not use for unambiguous self-contained asks, pure information requests, mechanical operations, or when the user explicitly wants speed over verification. Do not use when the problem and desired outcome are already known and the user needs direction, scope, or MVP exploration — that is idea refinement, not intent discovery.

## Hard Rules

- **One question at a time, with a guess attached.** Never batch questions; each question carries your hypothesis for the answer and the reasoning behind it.
- **Hypothesize with a confidence number** each round (0–100%); below ~70%, attach the reason on the same line.
- **Strictly intent discovery.** Produce no plan, spec, task list, or code until the user explicitly confirms the restated intent.
- **Explicit yes gate.** "Whatever you think", "sounds good", and silence are not confirmation — re-ask with concrete options.
- **Restate with all six lines.** Outcome, User, Why now, Success, Constraint, Out of scope — the last is non-negotiable.
- **Stop at 95%.** Done when you can predict the user's reaction to the next three questions you would ask; if several rounds pass without confidence rising, stop and flag that something foundational is missing.
- **No handoffs, no reactivation.** This skill ends at confirmed intent; do not route the user into other named workflows, and never reactivate on its own later.

## Decision Gates

| Situation                                                                | Action                                                    |
| ------------------------------------------------------------------------ | --------------------------------------------------------- |
| Missing who/why/success/constraint                                       | Interview                                                 |
| Ask unambiguous and self-contained                                       | Do not use; proceed normally                              |
| User delegates ("whatever you think")                                    | Re-ask with two concrete options as a choice              |
| Best-practice-sounding answers                                           | Probe what they actually want, not what sounds right      |
| Confidence not rising after several rounds                               | Stop, reframe, and tell the user                          |
| Can predict the next three reactions                                     | Stop; produce the restate                                 |
| Problem and outcome already known; needs direction/scope/MVP exploration | Do not use; that is idea refinement, not intent discovery |
| Intent confirmed                                                         | Stop; do not reactivate automatically later               |

## Execution Steps

1. **Hypothesize:** write your best one-sentence read of what the user wants plus an honest confidence number and, below ~70%, what is missing.
2. **Ask one question at a time**, each with a guess attached; wait for the reaction before the next question.
3. **Listen for want vs. should want:** catch pattern-match answers ("scalable", "clean", "standard approach", "I should probably…") and probe with "if you didn't have to justify this to anyone, what would you actually want?"
4. **Restate** the intent in the user's own words, 5–8 lines: Outcome, User, Why now, Success, Constraint, Out of scope.
5. **Confirm with an explicit yes**; fold in corrections and restate until the yes is unambiguous.
6. **Stop** when you can predict the user's reaction to the next three questions. If the user wants it persisted, offer to save it — `docs/intent/[topic].md` is an output path template, not a reference file; write it only on confirmation.

## Output Contract

Return a confirmed statement of intent: the six-line restate with an explicit user yes, plus the final confidence level and any open questions. Nothing further is produced — no plan, spec, or code — and the skill ends at confirmation; it does not resume automatically later.

## References

None. Self-contained; no supporting files.
