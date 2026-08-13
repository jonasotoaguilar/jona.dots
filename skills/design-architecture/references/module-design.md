# Module Design Reference

**Load only when module boundaries or testability are genuinely in question** — a new module/subsystem, a boundary being challenged, or a refactor where the interface shape matters. Applies to in-process modules and service boundaries alike. This is decision support for boundaries; it is not a codebase-scanning or refactoring workflow.

## Decision Principles

### Deep modules
Prefer modules whose **interface is small relative to the implementation they hide**. A shallow module (interface nearly as complex as what it hides) shifts burden to every caller. Signal of shallowness: callers must understand the implementation to use the interface correctly, or must orchestrate many tiny calls to get one unit of value.

### The deletion test
For any boundary under question, ask: **would deleting this module concentrate complexity, or just move it?** "Concentrates" is the signal the boundary earns its place — the module absorbs complexity from callers. "Just moves it" means the module is a wrapper with no real leverage.

### Seams only with real adapters
A seam (interface behind which an implementation is substituted) is justified only when it has **at least two real adapters** (e.g., HTTP in production, in-memory in tests). One adapter = a hypothetical seam: it adds indirection without a second consumer. Interface-as-test-surface is the common second adapter, not a mock you build later.

### The interface is the test surface
Tests should exercise the module through its public interface, not its internals. If the interface cannot express the behaviors that matter, the interface — not the testability technique — is the problem. Substitution points (dependency injection) follow from real adapter needs, not from a testing preference.

### Dependency substitution classes
When a seam is justified, match the substitution mechanism to the dependency kind:

| Dependency kind | Substitution |
|-----------------|--------------|
| In-process (pure, no I/O) | Direct call; no seam needed |
| Local-substitutable (filesystem, clock, in-memory store) | Interface with a test double at the seam |
| Ports & adapters (external service, DB, queue) | Interface implemented by a real adapter per environment |
| Mock (uncontrolled external behavior) | Contract/mock at the boundary only — never mock what you own internally |

Mocking what you own internally is a smell: it usually means the interface is wrong or the boundary is misdrawn.

### Architecture-friction signals
Revisit boundaries when any of these appear:
- Understanding one concept requires bouncing between many small modules.
- Modules are shallow (interface as wide as implementation).
- Tightly-coupled modules leak across their seams (internals referenced at call sites).
- Pure functions extracted "for testability" while real bugs hide in how they're called (no locality — bugs concentrate where the calling logic lives, not where the extracted function is).
- Code is hard to test through its current interface (tests reach into internals).

## Vocabulary

Use the boundary vocabulary precisely: **module, interface, implementation, depth, seam, adapter, leverage, locality**. Do not drift into "component", "service", "API", or "boundary" when the decision is about module shape.

## Gate

- Module boundary, interface shape, or testability of a subsystem in question → load this reference.
- Topology-level decisions (monolith vs microservices) → `architecture-patterns.md`, not this file.
- Codebase scanning, review reports, or refactoring workflows → out of scope for this skill; report as out-of-scope output.
