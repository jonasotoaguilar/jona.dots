# Realtime Communication Reference

**Load only when the change chooses or challenges a realtime transport**: server-push, live updates, or event delivery to clients (browsers, mobile, external systems). Decision altitude only — transport choice and its consequences; no vendor configuration, no client/server protocol recipes.

## Transport Decision Matrix

| Transport | Directionality | Latency profile | Fits when | Costs / constraints |
|-----------|----------------|-----------------|-----------|---------------------|
| **Polling** | Client-initiated pull | Request latency + interval; stale by design | Simple, low-frequency updates, stateless servers, firewalls/proxies that block long-lived connections | Wasteful at scale (requests per second = clients / interval); choose when push is not worth infrastructure |
| **Long polling** | Client-initiated pull, server holds response | Near-real-time; one open request per client | Half-duplex push without persistent connections; proxies that terminate long-lived sockets | One in-flight request per client; reconnect storms on deploy/network flake; partial upgrade path to SSE/WebSocket |
| **SSE (server-sent events)** | Server → client push, one-way | Near-real-time | One-way server push, automatic reconnect built into the protocol, plain HTTP works through most proxies/LBs | No client→server channel (use normal HTTP); connection-count limits on some infrastructure |
| **WebSocket** | Bidirectional, persistent | Real-time both ways | True interactive duplex (chat, collaborative editing, live cursors), sustained connection semantics | Stateful by design: sticky routing or shared session state, reconnect/replay handling, proxy and LB timeouts, backpressure is manual |
| **Webhook** | Server → server push | Async, bounded retries | Event delivery to systems you do not own the connection to (integrations) | Delivery is fire-and-forget with retries; receiver must be reachable; signature, dedup, and replay handling are YOUR contract (see `api-design.md`) |

## Decision Drivers

- **Directionality**: one-way server→client push → SSE; bidirectional live duplex → WebSocket; scheduled/intervaled reads → polling; server→server async events → webhook.
- **Latency requirement**: only true real-time needs (sub-second perceived) justify persistent connections; seconds-of-staleness tolerance usually makes polling simpler and more robust.
- **Concurrency & connection economics**: persistent connections are a capacity dimension — each held connection occupies server, proxy, and LB resources. Estimate peak concurrent connections against that budget before choosing a persistent transport.
- **Reconnect & backpressure**: every push transport needs a defined reconnect story (what the client misses while disconnected, how it catches up) and backpressure (server must not buffer unboundedly for slow consumers). Design the catch-up mechanism (replay, last-known-state snapshot, resync) per transport.
- **Proxies, load balancers & statefulness**: WebSocket requires either sticky sessions or shared session state; SSE/polling are stateless and LB-friendly. Name the stateful requirement explicitly — it changes deployment topology.
- **Ordering**: per-connection ordering is usually guaranteed by the transport; cross-connection ordering (a client with multiple connections) is not. Only introduce ordering machinery when clients depend on global order (see `data-consistency.md` for the caveat).

## Gate

- Realtime transport decision open → load this reference.
- Webhook contract details (signatures, dedup, retries) → `api-design.md`.
- Delivery semantics of internal async messaging (queues/events between your own services) → `cross-service-guidance.md`; this file covers client-facing transport.
