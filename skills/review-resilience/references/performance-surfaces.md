# Static Performance Surfaces

Not a performance benchmark and not a universal checklist. This lens never measures: it reports only when the diff visibly introduces one of the surfaces below AND a concrete failure mode is observable from the candidate (unbounded growth, blocked request path, work scaling per item). Do not report performance for code the change does not touch, and do not require or claim runtime numbers; measured evidence may support a finding only when already present in the candidate or manifest.

## Surfaces (report only on their signal)

| Signal in the diff | Concrete failure mode to confirm | Named direction |
| --- | --- | --- |
| N+1: per-item fetch/query inside a loop or map | One request becomes N+1 external calls; latency and load grow with list size | Batch, join, or preload once |
| Unbounded fetching: query, loop, or queue without a limit | Payload or work grows without bound; memory or latency degrades with data size | Add limits or pagination |
| Missing pagination/limits on a changed list endpoint | Response size or query cost scales with the whole table | Page with take/skip or a cursor |
| Synchronous blocking in an async/request path | A blocking call stalls the event loop or a worker; concurrency collapses | Make it async or offload |

Apply a row only when the change visibly introduces the surface; never report findings for absent categories.

## DO / DON'T

**DO:**
- Apply a surface only when the change visibly introduces it and the failure mode is observable from the candidate.
- Report only with hunk, created-path, or before/after evidence within manifest scope.
- Use measured evidence only when it is already present in the candidate or manifest.

**DON'T:**
- Run profiling, load tests, benchmarks, or measurement of any kind; this lens is static.
- Report Core Web Vitals, budgets, memoization tuning, keep/revert experiments, or performance CI — those belong to `performance-optimization` or project verification.
- Flag an existing slow surface the change does not touch.
- Report behavior-change-only work (e.g., "this now does more") without a concrete failure mode.

## Boundaries

- Reliability, security, and maintainability concerns stay in their owning lenses (R3, R1, R2).
- A surface visible in the manifest with no observable failure mode from the candidate is not a finding.
