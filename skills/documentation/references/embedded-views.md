# Embedded Canonical Views

`ARCHITECTURE.md` embeds Mermaid views when they add clarity for the scope at hand. External generated database schemas may be linked as implementation artifacts but do NOT replace the conceptual/logical ERD in architecture docs.

## When Each View Applies

| View | Diagram Type | When to Include |
|------|--------------|-----------------|
| Data Model / ERD | Mermaid `erDiagram` (or `classDiagram` for class-style ER) | Only when a data model is in scope — new/changed entities, storage decisions, ownership boundaries, data classes. No data model in scope → omit; do not fabricate one. |
| Critical Runtime / Application Flow | Mermaid `sequenceDiagram` (or runtime `flowchart`/`graph` with clear actors) | Recommended when it adds clarity: end-to-end critical use case, sync/async boundaries, queue usage, external call sites, failure recovery. Runtime flowcharts read left-to-right (`graph LR`); sequence diagrams flow top-down in time order. |

## Why Embedded Views

- The architecture is the source of truth for system decomposition, data ownership, and runtime interactions. A canonical view of these must evolve with architecture decisions.
- Generated DB schemas describe a specific implementation at a point in time; they are not the conceptual/logical model. Linking them is fine; replacing the ERD with them is not.
- A runtime sequence for a critical end-to-end use case reveals service boundaries, async vs sync, and failure recovery — include it when the change touches runtime flows.

## What Is Not Required

- C4 Context, C4 Container, Deployment, Data Flow, Component diagrams — add only when they clarify a distinct concern. The 4+1 model is not forced; one diagram per concern is.
- Generated DDL, ORM schemas, or vendor-specific ER tools. Link as implementation artifacts at most.
- ERDs or runtime diagrams for scopes that do not include a data model or runtime flow.

## Validator Behavior

`../scripts/validate-architecture-md.sh` is applicability-aware: it hard-fails only on the core contract (System Overview, Architecture Pattern with a chosen pattern, Component Details, Key Decisions, ADRs section) and on invalid placeholders outside code fences. Diagram blocks that are present are checked for coherence (properly fenced, declared type); absence of ERD/runtime diagrams is a warning, not a failure, since those views are conditional on scope. Prose mentions of the keywords outside code fences do not satisfy any check.

## When You Cannot Produce the ERD Yet

If the data model is genuinely undefined (e.g., the architecture is choosing between 2-3 storage strategies and the entities depend on the choice), leave the `erDiagram` block as a labeled placeholder inside a Mermaid fence, with a comment that the ERD is pending the storage ADR. The validator accepts fenced `erDiagram` blocks even when content is a placeholder comment.
