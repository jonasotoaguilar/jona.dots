# API Design Reference

**Load only when the change affects API decisions that are not already decided.** If an API style (REST/GraphQL/events) or method semantics already exist in the codebase or `ARCHITECTURE.md`, respect them and do not re-litigate; load this reference only when the change opens a genuine API decision (new surface, new paradigm, explicit challenge).

Architecture identifies and documents required contracts and high-level constraints; it does not produce publishable or detailed API contracts.

## Contract-First

Define the interface before implementing it: input and output shapes are declared up front (types, schemas, OpenAPI). "We'll document the API later" inverts the process — the types/contract ARE the documentation.

## API Style Decision Gate

Treat REST vs GraphQL as an architectural decision only when materially relevant: a public/partner surface, a broad client ecosystem, or a case where the paradigm shapes tooling, caching, or the operational model. When neither side has a strong reason, default to REST and do not force a paradigm write-up.

| Need / Constraint                                                                                 | Prefer                |
| ------------------------------------------------------------------------------------------------- | --------------------- |
| Resource-oriented CRUD, external integrations, simple HTTP caching, broad client compatibility    | REST                  |
| Public/partner API where OpenAPI, gateways, standard status codes matter most                     | REST                  |
| Clients need flexible field selection, aggregate reads, multiple UI shapes over same domain graph | GraphQL               |
| Frontend suffers from over/under-fetching across many related resources                           | GraphQL               |
| Strong schema introspection and typed client generation are primary requirements                  | GraphQL               |
| File upload/download, webhooks, simple commands, infrastructure callbacks                         | REST or event/webhook |

Choose GraphQL only when client flexibility offsets its operational cost: resolver perf, auth per field, query depth limits, caching complexity, schema governance.

## Method Semantics (non-obvious only)

- Choose methods by semantics, not style defaults: prefer safe methods (GET, HEAD, OPTIONS, PUT, DELETE) for reads; side effects that clients may retry require `Idempotency-Key` (see Operational Constraints).
- **QUERY** (RFC 10008, Proposed Standard, June 2026) — read-only operation with a request body; safe and idempotent like GET and, like POST, permits request content. Consider it when query complexity/size exceeds URL query parameters (complex filters, query languages); responses are cacheable with the request content in the cache key, and servers may expose query/result URIs for later GET. Verify intermediary, cache, and client tooling support before adopting; fall back to POST where they do not. QUERY is an HTTP method defined by the IETF, not a third API paradigm beside REST and GraphQL.

## Operational Constraints

- **Statelessness**: APIs MUST be stateless unless a stateful protocol is explicitly justified; any healthy instance handles any request behind a load balancer.
- **API Gateway**: only when microservices or multiple backend services sit behind one API boundary; keep business logic out of the gateway.
- **Versioning & Evolution**: define the evolution strategy before implementation — consistent URL/header versioning for REST; additive schema evolution with field deprecation before removal for GraphQL. Document deprecation dates, migration paths, and supported versions.
- **Error Contract**: one consistent error model, never mixed. REST: standard status-code semantics (400 invalid data, 401 unauthenticated, 403 unauthorized, 404 missing, 409 conflict, 422 invalid semantics, 500 server error — never internal details). GraphQL: built-in errors for unexpected/auth failures, typed unions for expected business errors.
- **Idempotency, Retries, Async**: `Idempotency-Key` for side-effecting POST endpoints clients may retry (payments, orders, imports); store keys with TTL, cache status/body/headers atomically. Retry only transient failures (network, 429, 5xx) with exponential backoff and jitter. Work exceeding request timeout → `202 Accepted` with a job/status resource.
- **Rate Limiting**: decide per endpoint group — layer (edge: CDN/API gateway/nginx before app code; app-level only for per-account logic), tier per route group (auth strictest, e.g. login 5/min; reads higher, e.g. 100/min), key dimension (per client/user/account/tenant; per-account for auth, not per-IP), shared counter across replicas (Redis or gateway), `429` + `Retry-After` + `X-RateLimit-Limit`/`-Remaining`/`-Reset`.

## Contract Stability & Evolution

- **Observable behavior is the contract (Hyrum's Law)**: anything observable may be depended on regardless of documentation. Be intentional about the observable surface.
- **Prefer the one-version world**: extend rather than fork; multi-version coexistence multiplies maintenance cost and creates diamond-dependency conflicts. Breaking change → additive migration (deprecate → migrate → remove), not parallel versions.
- **Additive evolution first**: new fields/endpoints are additive and optional; changing types, removing fields, or redefining semantics is breaking and needs a deprecation plan with dates, migration path, and supported window.
- **Schema compatibility applies to events too**: consumers must tolerate unknown fields; removed fields go through deprecation like API fields.
- **Validate at trust boundaries, not everywhere**: input from outside (request bodies, query params, third-party responses, config/env) is validated at the edge; internal code sharing type contracts does not re-validate. Third-party responses are untrusted data.
- **Multi-instance operation is a contract requirement**: health/readiness endpoints that reflect real dependency state; graceful draining (stop accepting new work, finish in-flight) so load balancers roll instances safely.

## Webhook Delivery Contract

Webhooks are a client-facing API shape: delivery guarantees and security are part of YOUR contract.

- **Signature**: every delivery is signed; receivers can verify authenticity and reject forged deliveries.
- **Replay & dedup**: deliveries may legitimately repeat (network retry, at-least-once); include a unique event ID per delivery; receivers dedup and ignore duplicates after successful processing.
- **Persist-or-enqueue**: the receiver's first action is persistence or enqueue — never process-in-place from the HTTP handler.
- **Fast 2xx**: acknowledge quickly; actual processing is async. Slow webhook handlers are a retry storm.
- **Retries with backoff**: failed/unsigned deliveries retry with backoff and expire after a bounded window; the expiry policy is a declared contract choice.

## Style-Specific Constraints (high-level, for `ARCHITECTURE.md`)

- **REST**: plural nouns, shallow nesting (≤2 levels); filters, sorting, pagination in query parameters; URL or header versioning, consistent; one error envelope, standard status-code semantics.
- **GraphQL**: schema shaped by client jobs, not database tables; resolver-level authorization; query depth/complexity limits; no N+1; cursor-based connections for large lists; typed unions for expected errors; persisted queries where the threat model or traffic demands them.

## Interface Type Decisions

When the change defines an API type surface, name up front: the discriminant for variant/state modeling, the input/output type split (inputs carry only what callers provide; outputs add server-generated fields), and ID branding to prevent cross-ID confusion.

## API Quality Checklist

- [ ] API style justified when materially relevant; no forced paradigm write-ups.
- [ ] Method semantics intentional, including QUERY where read-with-body fits.
- [ ] API stateless across instances; health/readiness reflects dependencies; graceful draining.
- [ ] AuthN/AuthZ per endpoint — mechanisms per trust boundary live in `nfr-checklist.md`; this reference does not prescribe implementations.
- [ ] Versioning and deprecation strategy documented; evolution additive; observable behaviors treated as commitments.
- [ ] Error model consistent and documented; required contracts identified at high level (publishable docs out of scope).
- [ ] List endpoints define pagination, filtering, sorting; side-effecting retries use idempotency keys.
- [ ] Webhook receivers: signature verification, event-ID dedup, persist-or-enqueue, fast 2xx, bounded retries.
- [ ] Rate limits and headers documented (edge-first placement, per-surface tiers, `429`/`Retry-After`); gateway used only when justified.
- [ ] No internals, secrets, or PII leaked in logs/errors.
