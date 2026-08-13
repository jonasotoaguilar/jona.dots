# Architecture Patterns

**Load only when system topology or architecture pattern is genuinely in question.** If a pattern is already established (existing codebase, `ARCHITECTURE.md`, or ADR), respect it and do not re-elect; load this reference only when the change opens a topology decision or explicitly challenges the current one.

## Topology Decision Matrix

| Topology              | When It Fits                                                                                 | When It DOESN'T                                                              | Key Guardrail                                                                                              |
| --------------------- | -------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| **Layered / MVC**     | Simple CRUD, small team (1-10), framework-enforced (Rails, Django, Laravel)                  | Complex domains, async-heavy, microservices                                  | Keep controllers thin — no business logic                                                                  |
| **Clean / Hexagonal** | Complex long-lived domain, multiple I/O channels (REST + CLI + Queue), high testability need | Simple CRUD, rapid prototypes, framework-first apps                          | Domain imports nothing from infrastructure; use case = one class                                           |
| **Modular Monolith**  | Growing team (5-20), clear bounded contexts, anticipate future extraction                    | Team < 5, independent scaling required NOW, distributed team                 | Enforce module boundaries with arch tests; no cross-module DB queries                                      |
| **Microservices**     | Large team (20+), independent deploy cadence, different scaling per component                | Team < 10, pre-PMF, no DevOps investment                                     | Each service owns its data; no shared DB; async preferred; never distributed transactions                  |
| **Event-Driven**      | Async processing core requirement, multiple consumers per event, audit trail needed          | Simple request-response, strong consistency needed, small systems            | Events are past-tense facts; idempotent consumers; DLQ for failures; never use events for request-response |
| **Serverless**        | Variable/spiky load, event-driven workloads, no ops team                                     | Long-running processes, consistent high-throughput, sub-100ms latency needed | Functions are stateless; always set concurrency limits and timeouts; connection pooling critical           |

### Combination Notes

- Event-Driven can layer on top of any topology for async boundaries.
- Modular Monolith can extract individual modules to Microservices as needed.
- Serverless can complement any topology for event-driven or burstable workloads.

## Service Decomposition

When a topology decision involves cutting services/modules (or verifying an existing cut), decompose by **business capability or bounded context**: each service/module owns its domain and its data; the cut is driven by business functions, not by technical layers. Each resulting unit needs an ownership story (who owns the data, who may read it) — an accidental cut shows up as shared databases or cross-service transactions. Extracting from an existing system follows the strangler pattern (new capability as a new unit, proxy routes old/new), never a big-bang rewrite.

## CQRS / Event-Sourcing Guardrail

CQRS and event sourcing are NOT default patterns; when either is in question, read `data-consistency.md` for the when-NOT gates and the projection/rebuild obligations before adopting.

## Caching Decisions

When caching is introduced, decide and document four things — the Caching Strategy table in the `ARCHITECTURE.md` template (documentation skill: `../../documentation/assets/ARCHITECTURE.md`) records the concrete instances:

- **Source of truth**: which system owns the data; the cache is always a copy with a defined staleness contract.
- **Staleness & invalidation**: how fresh the cached value must be (TTL vs event-driven invalidation vs both); who invalidates and what the window of staleness is.
- **Stampede protection**: what happens when a hot key expires under load (single-flight regeneration, jittered TTLs, or a designated refresh).
- **Failure behavior**: what the system serves when the cache is down (read-through to source, stale-while-revalidate, or fail closed) — caching must not become a new single point of failure.

## Decision Flow

```
Simple CRUD + small team (≤10)?
  YES → Layered or MVC
  NO  → Complex domain + long-lived?
          YES → Clean or Hexagonal
          NO  → Team > 20 + independent deploy?
                  YES → Microservices
                  NO  → Async/event core?
                          YES → Event-Driven (can combine with any above)
                          NO  → Modular Monolith (safe default)
```

## Cross-Cutting Guardrails

- Architecture must match current scale + near-future. Never design for hypothetical 10M-user scenarios when you have 100.
- Every component you add is something that breaks at 3 AM. Operational complexity IS a design constraint.
- NFRs without numbers are not NFRs. `< 200ms p95` is an NFR; `fast` is not.
- If you can't draw the system diagram, you don't understand the architecture. Start with one.
- Embed a system diagram and any runtime/data-model views the project's `ARCHITECTURE.md` convention supports; follow the project's existing diagram style and tooling.
