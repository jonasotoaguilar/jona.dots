---
name: mutation-testing
description: "Trigger: sdd-verify, mutation testing, genotoxic, strict TDD. Support layer for the sdd-verify phase: one bounded campaign per parent-acquired attempt token, evidence-only typed mutation evidence; parent owns bracket, severity, persistence."
license: Apache-2.0
metadata:
  author: "jonasotoaguilar"
  version: "3.1.0"
  delegate_only: true
---

## Execution Role

SUPPORT LAYER inside the `sdd-verify` phase — an extra step, never standalone, never a phase or sub-agent. Parent owns attempt bracket, baseline, persistence, severity, verdict, transition. Return ONLY the `### Mutation Testing Evidence` block (evidence-level): never emit/prescribe phase severity or verdicts; never mention remediation/reverify.

## Activation Contract

Load when sdd-verify has changed/impacted executable production targets. Consume baseline and strict-TDD evidence plus any parent-delivered prior verify-report (`contextFiles.verifyReport`); run only the mutation check.

## Hard Rules

- **Attempt ownership.** NEVER invoke `gentle-ai sdd-attempt acquire|settle`. Exactly ONE bounded campaign per parent-acquired attempt token; continuation ONLY on a parent-reoffered active attempt. Verify after remediation = NEW attempt.
- **Evidence-level only.** Manifest status is evidence; triage labels are NOT severity.
- **No persistence/delegation.** Return only the block; never search/persist Engram, never write OpenSpec or artifacts. Prior evidence ONLY from parent-delivered `contextFiles.verifyReport` — no cache/Engram/tmp authority.
- **Scope.** Only changed executable production targets + impacted functions (transitive included); none → typed `not_applicable` or unchanged-candidate reuse; never claim PASS from mutation evidence. Compare baselines only when comparable; drift reported as drift, never attributed to the candidate.
- **No manual substitutes, no installs, no fabricated commands.** Framework unavailable → typed `unavailable` with preserved error; never invent PASS/retry. Optional analyzers absent → run without them, record limitation. Only documented, runtime-proven invocations.
- **Evidence continuity.** Only the parent-delivered prior manifest counts; weak/missing/unavailable/blocked/interrupted or not re-supplied → full.
- **Strict TDD.** Only mutation-specific contradictions vs parent RED/GREEN evidence.

## Decision Gates

| Condition → Action                                                                                                                                  |
| --------------------------------------------------------------------------------------------------------------------------------------------------- |
| No changed/impacted executable target → `not_applicable`; reuse only under the unchanged-candidate rule                                             |
| Baseline precondition failed → `blocked` with preserved evidence                                                                                    |
| Framework unavailable → `unavailable` with preserved error                                                                                          |
| `harness-disposition: invalidated` → reused prohibited; incremental only with additive/strengthening test-only proof; otherwise full                |
| Baseline kind not attested (`opaque` default) → full, no reuse/incremental                                                                          |
| Prior present/absent → reused/incremental/full per matrix; weak/missing/unavailable/blocked/interrupted → full; invalidations are audit events |
| Strict TDD contradiction vs RED/GREEN → mutation-specific gap; sdd-verify decides severity                                                          |

### Survivor Buckets

| Bucket                                                       | Actionability                            |
| ------------------------------------------------------------ | ---------------------------------------- |
| `equivalent` / `unreachable` / `cosmetic` / `false_positive` | non-actionable internal label            |
| `missing_test` / `fuzzing_target` / `corroborated`           | actionable; `remediation_required: true` |

## Execution Steps

1. Receive scope, targets, baseline results, strict-TDD status, prior verify-report, harness disposition; confirm baseline passed (precondition).
2. Decide reused/incremental/full per the matrix; no or weak prior → full.
3. Scope ONE bounded campaign to changed/impacted targets; none → `not_applicable` (unchanged-candidate rule).
4. Run the campaign; normalize outcomes; triage survivors into the bucket table (strict-TDD gaps only).
5. Return ONLY the block with the `gentle-ai.mutation-evidence/v1` manifest; actionable findings `remediation_required: true`.

## Output Contract

Return ONLY a machine-readable `### Mutation Testing Evidence` section embedding the evidence manifest (`references/evidence-manifest.md`): evidence-level status (pass/fail/not_applicable/unavailable/blocked), scope, framework, counts, counts_source, triage buckets, strict-TDD comparison, survivors with exact file:line/mutation/function/action. Record exact command/config/seed/timeout, project-relative cwd. `sdd-verify` alone maps severity and picks the verdict; never redefine its envelope, persistence, or attempt authority.

## References

- `references/evidence-manifest.md` — canonical schema, status vocabulary, deterministic reuse matrix, counts_source.
- `references/campaign-scoping.md` — scoping, reproducibility, impact proof, matrix mirror.
- `references/mutation-frameworks.md` — framework selection per stack; normalization notes.
