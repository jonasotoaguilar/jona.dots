# Database Operations Reference

**Load only when a relational store is chosen and operational characteristics are in scope** — connection management, access paths, write/read load, transaction behavior, or data volume. Strategy altitude only: this reference decides budgets, access-path strategy, and validation gates; it contains no SQL, no vendor configuration, and no schema recipes.

## Connection Budget

The connection budget is a capacity inequality, not a formula:

```
pool_per_instance × max_instances ≤ server_connection_limit − reserved_headroom
```

- `server_connection_limit` is the database's configured max; each connection consumes real memory (order of ~MB each), so the budget is about memory, not "connections are free".
- `reserved_headroom` covers maintenance (backups, migrations, admin), monitoring probes, and spikes; it is never zero.
- There is **no universal per-instance formula**: any sizing heuristic is an estimate at best and wrong for many workloads — never a guarantee. Size pools from the budget inequality and validate by measurement.
- **Little's Law as the starting estimate**: required concurrency ≈ throughput × latency (requests/s × seconds). It gives a first-order pool size; validate and tune by measured **P99 connection-acquisition time and pool saturation**, not by the estimate alone.
- **Proxies/poolers tradeoff**: a pooler in transaction mode serves far more concurrent users from a small server pool but is incompatible with session-bound state (prepared statements, temp tables, advisory locks held across transactions) — those need session mode, which carries more connections. Decide per workload which mode, and name what breaks if the wrong mode is chosen.

## Indexing & Access Paths

- Indexes are **access-path-driven**: an index earns its place only when a real query path needs it (filters, sorts, join keys, uniqueness). Do not index columns on principle.
- Index concepts that matter at strategy altitude:
  - **FK columns** need explicit indexes in most relational stores (they are not auto-indexed); they protect join performance and parent-delete locking behavior.
  - **Composite** (column order = leftmost-prefix usability; leading columns must match filter usage).
  - **Covering** (include non-key columns for index-only scans).
  - **Partial** (index a hot subset — smaller, cheaper to maintain).
  - **Operator-specific** (GIN/GiST-style for containment, range, full-text, JSON) when the query operator needs it.
- **Write cost is an index budget**: every index slows writes and increases storage and maintenance. Insert/update-heavy paths must justify each index; index-first designs on hot write paths are a defect.
- **Query plans (EXPLAIN-style analysis) are an NFR validation gate**, not a debugging afterthought: when the change carries performance NFRs, the plan for the hot queries must be validated against the access-path design (full scans on large tables, poor selectivity, missing join strategy are plan-level signals).

## Transaction Behavior

- **Transactions are short, and never span external I/O** (network calls, user input, third-party APIs). Holding locks across external I/O is a contention and deadlock factory; move I/O outside the transaction, keep the transaction around the store operations only.
- **Atomic upsert vs check-then-insert**: check-then-insert is a race by construction; when the store supports atomic insert-or-update (conflict-target based), the atomic form is the decision unless semantics require otherwise.
- **Timeout/retry policy**: set statement timeouts to bound runaway work; deadlock/conflict retries are bounded with backoff (see `data-consistency.md`).

## Volume-Driven Decisions

- **Partitioning is triggered by volume and retention, not by preference**: very large tables (>100M-row scale), time-series workloads with range queries, or retention flows that must drop old data cheaply. Partition by a natural pruning key; the partitioning decision belongs to the architecture, the mechanism to implementation.
- **Multitenancy isolation is a decision**: choose between shared-schema-with-row-level-security, schema-per-tenant, or database-per-tenant by the isolation/scale/complexity tradeoff — the choice shapes backups, connection budgets, and security policy, so it is architecture-level.

## Gate

- Relational store chosen and operational characteristics (connections, access paths, transaction load, volume) in scope → load this reference.
- Selecting which store → `database-selection.md` (which points here after a relational store is chosen).
- Schema/table-level implementation, SQL, indexes at DDL level, and pooling configuration are implementation concerns, not part of this strategy-level reference.
