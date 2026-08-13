# Campaign Scoping

How to scope and run exactly ONE bounded mutation campaign per parent-acquired attempt token for the sdd-verify mutation support check.

## Scope

- Mutate ONLY changed executable production targets + impacted functions (transitive callers/callees reachable from the change count as impacted). Never the whole repo; never test-only or generated code.
- Prove the impacted set with the dependency/call graph (Trailmark or the project's own graph tooling) when row 3 of the reuse matrix needs it.
- No changed/impacted executable target → `not_applicable` (or unchanged-candidate reuse per the matrix).
- Exactly ONE bounded campaign per attempt: no counters, no retries, no parallel campaigns, no overnight/two-phase scheduling.

## Reproducibility (required for every executed campaign)

- Record `repro` in the manifest: exact `command`, project-relative POSIX `cwd` (never absolute/home/tmp), `seed` (deterministic seed only when the framework documents one; never invent a seed flag; else `null`), `timeout_seconds` (bounded, explicit).
- Use ONLY documented, runtime-proven invocations; parse ONLY formats the tool demonstrably emits. Never fabricate commands, flags, or parse schemas.
- Cleanup: reconcile/regenerate the mutant database after scope changes, remove ephemeral artifacts, record regenerable paths in `cache_manifest` (never authoritative). NO `/tmp` authority — never consume tmp/cache leftovers as evidence.
- No installs and no manual substitutes: framework unavailable → typed `unavailable` with the preserved error; never invent PASS/retry. Optional analyzers (Trailmark, Necessist) absent → run without them and record the limitation; never block on them.

## Differential Baseline

Compare survivor sets only when comparable (same tool version, mutation-type set, config, target scope — verified via fingerprints, never by assumption). Drift is reported as drift (`scope_drift`/`config_drift`/`tool_drift`), never attributed to the candidate change. Matching uses `stable_id` only; never framework IDs across campaigns.

## Campaign Decision

Decide BEFORE running: reused / incremental / full per the canonical deterministic matrix in `references/evidence-manifest.md` — rows top-to-bottom, first match wins; rejected priors become `invalidation_reasons` audit events. Prior evidence ONLY from the parent-delivered `contextFiles.verifyReport`. Mirrored here for execution; `evidence-manifest.md` is canonical.

| # | Condition                                                                                                                   | Decision                                                                                                                                                    |
| - | --------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1 | No relevant change + strong identical bindings + prior `pass` with no survivors                                             | **reused** — zero execution; counts inherited                                                                                                               |
| 2 | Test-only additions/strengthening + prior survivors all resolvable + targeted rerun supported + `incremental_eligible` true | **incremental** — rerun prior survivors only; mixed counts                                                                                                  |
| 3 | Production change with impacted targets PROVEN via dependency/call graph + framework can target mutants                     | **incremental** — impacted IDs only, unchanged evidence preserved; else **full**                                                                            |
| 4 | Config/tool/version/dependency drift                                                                                        | **full** (`config_drift`/`tool_drift`/`dependency_drift`)                                                                                                   |
| 5 | Tests deleted/weakened OR harness invalidated without test-only proof                                                       | **full** (`test_suite_weakened`/`harness_invalidated`)                                                                                                      |
| 6 | Prior manifest missing/weak/malformed/schema unsupported                                                                    | **full** (`prior_malformed`/`prior_schema_unsupported`)                                                                                                     |
| 7 | Prior status unavailable/blocked/interrupted                                                                                | **full** (`prior_unavailable`) — never inherit a pass                                                                                                       |
| 8 | Baseline kind opaque/missing (no parent attestation)                                                                        | **full** (`baseline_opaque`)                                                                                                                                |
| 9 | No changed/impacted executable target                                                                                       | **not_applicable**; reuse ONLY under the unchanged-candidate rule (re-delivered prior `pass` with matching strong bindings → **reused**, never incremental) |
