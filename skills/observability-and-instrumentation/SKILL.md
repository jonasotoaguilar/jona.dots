---
name: observability-and-instrumentation
description: "Trigger: implement, verify, or scoped-review feature telemetry (logs, metrics, tracing, alerts) against an approved contract. Not telemetry design, debugging, incident diagnosis, or platform policy."
license: MIT
metadata:
  author: addyosmani
  source: addyosmani/agent-skills
  version: "2.1.0"
  upstream: https://github.com/addyosmani/agent-skills
  adapted-by: jonasotoaguilar
---

## Activation Contract

Load when implementing, verifying, or scoped-reviewing feature telemetry (structured logs, metrics, tracing, alerts) against an approved/existing observability contract or signal map. Not telemetry design, debugging, incident diagnosis, platform policy, or review without a supplied contract.

## Hard Rules

- **Contract input.** Supplied contract/signal map is the source of signal truth; never define, invent, or redesign signals; absent → report the missing contract/dependency and stop.
- **Correlation.** Correlation context on logs, spans, and outbound calls belonging to the request/operation flow — request ID at the system boundary, propagated through that flow. Background jobs use trace/job correlation appropriate to the contract.
- **No secrets/PII.** Allowlist fields; never whole bodies or credentials.
- **Bounded cardinality.** Labels from small fixed sets (route template, status class, provider); never user IDs, raw URLs, request IDs, or error text.
- **Symptom-based, actionable alerts.** Page on symptoms (error rate, latency, queue age), not causes; each alert has a runbook link and threshold/duration justified by the contract's SLOs/history; severities: page and ticket.
- **Feature-scoped.** Only the assigned feature's telemetry; platform governance (SLO targets, error budgets, runbook authoring, alert-platform config) → surface as dependency; don't duplicate/invent. Platform SLO/error-budget/runbook policy remains `sre-engineer`-owned.
- **Authorized verification only.** Test-fire alerts or induce failures only with explicit authorization, in a safe non-production or lowest-risk environment; otherwise return unavailable/blocked evidence — never cause side effects.
- **Verify the signals.** Trigger paths and confirm actual output: structured logs, series appear, spans complete, each alert fires once.

## Decision Gates

| Situation                       | Action                                                                                                                     |
| ------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| No contract/signal map supplied | Report the missing contract/dependency; do not invent signals                                                              |
| Implementation                  | Write instrumentation code/config per the contract                                                                         |
| Verification                    | Check vs contract, test-fire, record missing as findings/dependencies; do not change                                       |
| Scoped review                   | Audit vs contract; findings/dependencies only; no redesign                                                                 |
| Format conventions              | `references/instrumentation-examples.md`                                                                                   |
| Pre-launch gate                 | `references/observability-checklist.md`                                                                                    |
| Platform governance             | Surface as dependency; do not duplicate                                                                                    |
| No staging                      | Test-fire alerts only with explicit authorization in the lowest-risk environment; else return unavailable/blocked evidence |

## Execution Steps

1. Confirm contract supplied; absent → report missing and STOP.
2. Implementation: correlation context on the request/operation flow; structured logging; bounded-label RED metrics (or USE for resources); OTel spans; page/ticket alerts with contract-justified thresholds and runbook links.
3. Verification: with explicit authorization, test-fire each alert once or induce a staging failure found via telemetry alone (safe non-production or lowest-risk environment only); without authorization, return unavailable/blocked evidence. Missing definitions/signals → findings/dependencies.
4. Scoped review: audit telemetry vs contract (correlation, secrets/PII, label cardinality, alert actionability, coverage); findings/dependencies only.

## Output Contract

- Implementation: instrumentation code/config, alert definitions with threshold justification and runbook link.
- Verification: evidence (staging failure found via telemetry, or test-fire results); missing definitions/signals as findings/dependencies.
- Scoped review: findings/dependencies; no redesign.
- All: contract as input; confirm each hard rule (correlation, no secrets, bounded cardinality, symptom-based alerts).

## References

- `references/instrumentation-examples.md` — implementation format conventions.
- `references/observability-checklist.md` — pre-launch gate checklist.
