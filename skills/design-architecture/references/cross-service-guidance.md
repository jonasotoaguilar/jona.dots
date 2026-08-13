# Cross-Service Guidance

Per-feature knowledge for changes that cross services, repos, or teams, or when implementation constraints are still implicit despite a clear product intent. Surfaces invariants, trust boundaries, and ownership BEFORE architecture or code decisions harden around unstated assumptions. This guidance is knowledge within `ARCHITECTURE.md`, ADRs, or the conversation — never a standalone file, never an output of this skill; system-level topology and ADR-worthy choices belong in `ARCHITECTURE.md` and ADRs, not here.

## When It Applies

Apply when:

- A PRD, roadmap item, or founder note exists but invariants, ownership, lifecycle, or rollout are still implicit.
- A feature crosses multiple services, repos, or teams and needs explicit constraints before any team codes.
- Senior engineers keep restating the same hidden assumptions during review.
- The ask touches trust boundaries, data ownership, or compliance.

Do not apply to:

- A simple bug fix or one-component implementation change.
- System-wide topology or technology choice — that is ADR + `ARCHITECTURE.md` territory.
- Pure UI work with no cross-service surface — that belongs to the UI design/implementation skills (`design-ui`, `impeccable`).

## Constraint Probes (answer before design hardens)

| Category              | Probe                                                        | Must name                                                                                  |
| --------------------- | ------------------------------------------------------------ | ------------------------------------------------------------------------------------------ |
| Business rules        | What policies or commercial rules bind this capability?      | The binding rules                                                                          |
| Scope boundaries      | What is explicitly out of scope?                             | Non-goals                                                                                  |
| Invariants            | What must always be true, even under failure?                | The invariant, placed in `ARCHITECTURE.md`/ADR                                             |
| Trust boundaries      | Where does ownership/responsibility cross an untrusted seam? | AuthN/AuthZ decision and blast radius per seam                                             |
| Data ownership        | Which service/system is the source of truth for each entity? | Source of truth; every other holder is a cache/projection with a defined consistency story |
| Lifecycle transitions | What states exist? What triggers a transition?               | State transitions and triggers                                                             |
| Rollout / migration   | Backwards compatibility, dual-write window, cut-over plan?   | The migration plan                                                                         |
| Failure and recovery  | What degrades, and how is it detected and recovered?         | Degradation order and recovery path                                                        |

Unanswered probes surface as OPEN QUESTIONS in the conversation or `ARCHITECTURE.md`; never paper over a gap.

## Failure and Coordination Concerns

- **Sync vs async is a boundary decision.** Identify queue/event hops at design time; request-response over events (and vice versa) is a coordination smell.
- **Idempotency and retries.** Side-effecting operations that clients may retry need idempotency keys; retries apply to transient failures only.
- **Observability at the seam.** Cross-service failures are diagnosed at the boundary; alerting must precede user reports.

## Async Delivery Semantics (events/messages between your services)

Decide delivery guarantees per queue/event stream; they are part of the contract, not broker defaults:

- **Delivery semantics**: at-least-once is the pragmatic default (consumers must be idempotent); exactly-once is a distributed-systems claim, not a default — state how duplicates are deduplicated instead.
- **Ordering**: only guaranteed within a partition/stream per key in most brokers. If global or per-entity order matters, name the keying that preserves it; do not assume cross-partition order.
- **Backpressure**: producers must not overrun slow consumers — bounded queues, rejection or shedding on backlog, and a defined consumer-lag policy.
- **Retry budget & poison messages**: message processing gets a bounded retry budget; messages that keep failing are routed to a DLQ, not retried forever. The DLQ has a reprocessing story (inspect → fix or discard → redeliver).
- **Event envelope is minimal**: events carry facts (IDs, changed values), not payloads that go stale or bloat the stream; consumers fetch current state from the owner when they need it.
- **Deadlines across hops**: a request that fans out across services needs a deadline budget shared across hops (see `resilience-patterns.md`) so late hops fail fast instead of piling up.

These are knowledge decisions, not broker configuration: this guidance sets the semantics; the broker config belongs to implementation.

## Anti-Patterns

- **Inventing product truth.** Mark open questions explicitly.
- **Conflating with `ARCHITECTURE.md`.** This guidance is per-feature knowledge; system-level topology and ADR-worthy choices go in `ARCHITECTURE.md` and ADRs.
- **Skipping non-goals.** A capability without explicit non-goals accretes scope mid-implementation.
- **Treating open questions as resolved.** An unresolved product or ownership decision blocks hardening — report it.
