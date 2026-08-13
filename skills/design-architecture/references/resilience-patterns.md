# Resilience Patterns Reference

**Load only when resilience decisions are open for the change**: timeouts, retries, circuit breaking, load protection, durable execution, or disaster recovery targets. Decision altitude only — mechanisms are named and decided, not implemented. Resilience execution (chaos runs, capacity plans, SLO operations) belongs to the `sre-engineer` complement skill.

## Decision Matrix

| Concern | Decision to make | Guidance |
|---------|------------------|----------|
| **Timeout / deadline budgets** | Per-call timeout + overall request deadline | Every external dependency gets a timeout, and the sum of timeouts must respect the caller's deadline. Deadlines propagate across hops; a deadline budget is an architecture artifact, not per-function tuning. |
| **Retries** | Which failures may retry, how often, with what spacing | Retry only **transient** failures (network blips, 429/5xx-class, connection resets). Never retry on deterministic errors (validation, 4xx, auth). Backoff with **jitter**; bounded attempts. Retrying non-idempotent operations without dedup is a double-apply hazard (see `data-consistency.md`). |
| **Circuit breaker** | Open/closed/half-open thresholds | Trip on repeated failure (error rate and/or consecutive failures), cool down, half-open probe before closing. Decisions: what counts as failure, thresholds, and how long the circuit stays open. Fail fast instead of queueing into a dead dependency. |
| **Bulkheads** | Resource isolation between workloads/dependencies | Isolate pools (connections, threads, workers) so one saturated dependency cannot starve unrelated traffic. Per-dependency pools with their own budgets. |
| **Load shedding / admission control** | Behavior under overload | Decide what degrades first and in what order: reject excess work early (429/503 with clear semantics) rather than queuing unboundedly. Name the load signal (queue depth, request rate, CPU saturation) that triggers shedding. |
| **Dependency failure budget** | How much failure a dependency may cause | Total impact of a failing dependency on your SLO is budgeted: timeouts + retries + circuit trip + fallback must contain the blast radius within the dependency's share. |
| **Durable workflow / state machine** | When crash recovery, timers, or human steps matter | Multi-step processes that must survive crashes, wait on timers, or pause for human approval need a durable execution model (state machine or workflow engine with persisted state), not in-memory orchestration. Decision trigger: can a crash mid-flow leave the process unrecoverable? |
| **DR strategy / RTO & RPO** | Recovery targets and the strategy that meets them | State RTO (time to recover) and RPO (data loss tolerance) explicitly, then validate the strategy (failover, restore, replication) against them. Unvalidated DR targets are fiction — the validation is part of the design, not an afterthought. |

## Cross-Cutting Rules

- **Resilience is a chain**: a timeout without a retry policy is a hang; a retry without a circuit breaker is a thundering herd; a breaker without a degradation story is still a failure — decide the full chain per external dependency.
- **Degradation must be named**: every dependency failure has a defined fallback (cached/stale response, default value, queued work) or a defined rejection (error with clear semantics). "It fails" is not a design.
- **Durable workflows are not default**: introduce a workflow/state-machine layer only when crash recovery, timers, or human steps are real requirements — otherwise it is machinery without a job.

## Gate

- Resilience decisions open (timeouts, retries, breakers, shedding, DR) → load this reference.
- Executing SRE workflows (chaos experiments, capacity runs, error-budget operations) → hand off to `sre-engineer`.
- Telemetry design for these mechanisms → `nfr-checklist.md` (instrumentation seams) with `observability-and-instrumentation` for implementation.
