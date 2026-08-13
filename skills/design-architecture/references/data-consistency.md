# Data Consistency Reference

**Load only when the change has data-consistency or concurrency decisions open**: transaction boundaries, conflict handling, async delivery guarantees, or consistency models. If the store and its consistency model are already decided, respect them; load only for new decisions or explicit challenges. Strategy altitude only — no SQL, no broker config.

## Local Transaction Decisions

- **Boundary**: make the transaction boundary the smallest unit that preserves invariants. Two writes that must never be observed apart share one boundary; independent writes do not.
- **Isolation choice**: pick the isolation level by the anomalies you must prevent, not by default habit. Each step up (read committed → repeatable read → serializable) costs throughput and lock/abort rates.
- **Lost updates / races**: any read-modify-write is a race. Choose the enforcement mechanism by semantics (see below), never by "check-then-act" code — it wins races, not correctness.

## Concurrency Control Decision Matrix

| Situation | Mechanism |
|-----------|-----------|
| Contention is rare, conflict is detectable after the fact | Optimistic (version/updated-at check, CAS) |
| Contention is real and blocking is acceptable | Pessimistic (row lock acquired before read-modify-write) |
| A value must be derived atomically (counters, balances) | Atomic single-statement update (CAS/`UPDATE ... WHERE old value`), not read-then-write |
| Uniqueness must be enforced under concurrency | Unique constraints / indexes as the enforcement point, not app-level checks |
| Two operations may conflict and retry is cheap | Deadlock/conflict retry with bounded attempts + backoff; design so conflicts are rare enough that retry succeeds |

Idempotency is the cross-cutting answer: give every retryable side effect a deduplication key, enforced by the store (unique constraint), so a retry can never double-apply.

## Consistency Models

- **Strong vs eventual** is a product contract: name, per data set, what readers may observe (stale reads allowed? ordering?). Every holder that is not the source of truth is a cache/projection/replica with a defined staleness story.
- **Dual-write hazard**: writing to two systems in one logical operation (DB + queue, DB + search index) can never be atomic without a transaction spanning both. Break the coupling with an **outbox**: write the event in the same transaction as the state change; a relay publishes it. Consumers see the event exactly if the state change committed.
- **Saga** (multi-step, multi-owner operation): choose orchestration (a coordinator drives steps and compensations) when the flow is explicit and control matters; choreography (each step reacts to events) when steps are independently owned. Either way, design **compensation actions** per step and a **manual intervention path** — sagas can fail mid-flow and must end in a resolvable state, not a silent partial commit.
- **Distributed ordering caveat**: only when distributed ordering actually matters (same-entity event ordering across partitions) does clock skew/ordering become an architectural concern. Do not introduce ordering machinery for workloads that tolerate per-entity serialization or best-effort order.

## CQRS / Event Sourcing — strict when-NOT gate

- **CQRS** (separate read model from write model): justified only when read and write workloads genuinely diverge (different shapes, scale, or consistency needs). NOT justified as a general style — a single normalized store with queries usually wins on simplicity.
- **Event sourcing** (events as source of truth, state as projection): justified when audit/history is a first-class requirement or past states must be reconstructible. NOT justified for CRUD-shaped domains — it adds replay, versioning, and projection complexity for no product gain.
- When either is chosen, the **read model is a projection** with its own consistency and rebuild story; document rebuild (full replay) as a recovery path.

## Zero-Downtime Schema Evolution

Schema change on live data is an architecture decision, not an implementation detail:
- **Expand, backfill, contract**: additive column/table changes first (safe, non-breaking); backfill new fields from old state; only then contract the old shape, after all consumers stop relying on it.
- **Contract**: old columns/fields remain readable during the migration window; removal is the final, scheduled step — never simultaneous with the expansion.
- Treat schema and API evolution as one contract: a breaking API change must not precede the data it depends on, and vice versa.

## Gate

- Transaction/concurrency/consistency decisions open → load this reference.
- Selecting a store → `database-selection.md`; operational characteristics of a chosen relational store → `database-operations.md`.
- Delivery semantics of events/messages across services → `cross-service-guidance.md`; this file covers the consistency side only.
