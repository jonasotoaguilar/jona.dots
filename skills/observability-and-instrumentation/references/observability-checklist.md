# Observability Checklist (pre-launch gate)

At-a-glance version of the Verification list in this skill. **Gate rule**: a feature ships only when every item below is answerable from telemetry alone — without reading source or reproducing the issue.

## Pre-Launch Gate

1. On-call questions for the feature are written down (2–4), and each signal maps to one.
2. All logs are structured (JSON) with stable event names and a correlation ID on every line; no secrets, tokens, or unredacted PII (spot-check actual output).
3. RED metrics exist for every new endpoint and every external dependency, with bounded label sets (no user IDs, raw URLs, or error-message text as labels).
4. Latency is a histogram; p95/p99 are queryable. Averages are not the primary signal.
5. A single request can be followed end-to-end (HTTP, queue, DB calls) without broken spans.
6. Every new alert is symptom-based (user-facing impact, not cause), links a runbook, has a threshold/duration justified by the SLO or history, and was test-fired once.
7. An induced failure in staging was located via telemetry alone.

If any item fails, the feature is not instrumented yet — telemetry is written alongside the feature, not after it.
