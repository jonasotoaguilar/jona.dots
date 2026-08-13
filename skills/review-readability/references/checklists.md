# Review Scope and Internal Prioritization

Reference for review scope, internal prioritization, and signal-driven check selection.

## The Review Mindset

**Goals of Code Review:**

- Catch maintainability defects that obscure behavior
- Ensure code maintainability
- Share knowledge across team
- Enforce coding standards
- Improve design and architecture
- Build team culture

**Not the Goals:**

- Show off knowledge
- Nitpick formatting (use linters)
- Block progress unnecessarily
- Rewrite to your preference

## Review Scope

**What to Review (this lens):**

- Misleading names and unclear API design
- Duplicated or dead logic
- Unexplained business constants
- Unsafe complexity
- Missing change context
- Documentation and comments that mislead

**Architecture and simplification signals (report only with concrete maintenance impact):**

- New conditional bolted onto an unrelated flow — a separate concern riding an existing path
- Repeated conditionals on the same shape — the same check over the same field in several places
- Feature-specific logic leaking into a shared or general-purpose module
- A bespoke helper duplicating an existing canonical one
- A refactor that relocates complexity instead of reducing it (reader still holds the same concepts)
- Gratuitous casts, `any`/`unknown`, or silent fallbacks that paper over an unclear invariant
- Boolean flag parameters hiding meaning at call sites
- Pass-through wrappers that add indirection without clarifying the API
- Redundant type assertions and unnecessary async wrappers
- Comments that explain what instead of why

**Architectural maintainability signals (report only with concrete maintenance impact and causal evidence in the reviewed scope):**

- Dependency-direction violation — a high-level module far from IO now imports a low-level IO-near module (adapter, transport, persistence, framework binding)
- Framework or I/O leakage into policy — UI, filesystem, database, network, framework, or device details entering high-level policy code
- Accidental public API — widened visibility or a new export with no consumer beyond internal needs or test access
- Low-level data-shape leakage — high-level modules depending on low-level DTOs, persistence shapes, framework types, or transport formats
- Weak information hiding — a module exposing representation or I/O details so consumers couple to internals or bypass invariants
- Broad interface owned by the wrong layer — one interface spanning unrelated concerns, or an IO-near module owning the interface high-level dependents must use

Each requires causal evidence inside the reviewed scope: the hunk, created path, or before/after proof showing the change introduces or widens the violation. A hypothetical boundary or dependency rule the change does not exhibit is never a finding.

**What Belongs to Other Lenses:**

- Security vulnerabilities → risk lens
- Performance implications, load → resilience lens
- Test coverage and quality → reliability lens
- Error-handling correctness → reliability lens
- Runtime measurement, budgets, benchmarks → performance-optimization or project verification

**What Not to Review Manually:**

- Code formatting (use Prettier, Black, etc.)
- Import organization
- Linting violations
- Simple typos
- Architecture preference without concrete maintenance impact (including hypothetical boundaries or dependency rules the change does not exhibit)
- File size alone (without evidence in the reviewed scope of crossing a healthy boundary)

## Internal Prioritization (Never Emitted)

Use these only to order your own attention before mapping to Output Contract severities:

- **Blocks behavior** — candidate for BLOCKER/CRITICAL in the Output Contract
- **Hides behavior** — candidate for WARNING
- **Optional improvement** — candidate for SUGGESTION

The Output Contract in SKILL.md decides output severity. Never emit these internal labels or any review labels in the output; never add fields.

## Signal-Driven Check Selection

No universal checklist. For this lens, checks are selected per signal observed in the change:

| Signal in the change                          | Check                                                                                                                                                             |
| --------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| New or renamed identifier                     | Does the name state intent without reading the body?                                                                                                              |
| Repeated block                                | Is it true duplication or a deliberate branch?                                                                                                                    |
| Added branch that is unreachable              | Is it dead logic?                                                                                                                                                 |
| New literal or magic value                    | Is it an unexplained business constant?                                                                                                                           |
| Deeply nested or long function                | Is complexity hiding behavior?                                                                                                                                    |
| Change without surrounding context            | Is the behavior change understandable in isolation?                                                                                                               |
| Conditional bolted onto an unrelated flow     | Does the branch belong to a separate concern riding an existing path?                                                                                             |
| Repeated conditionals on the same shape       | Do the same checks over the same field repeat? Missing model or dispatcher?                                                                                       |
| Feature logic in a shared module              | Does the change couple a general-purpose module to one feature?                                                                                                   |
| Bespoke helper duplicating a canonical one    | Does an existing helper already satisfy the contract?                                                                                                             |
| Refactor that moves code around               | Does the reader still hold the same number of concepts?                                                                                                           |
| New cast, `as`, `!`, `any`, or `unknown`      | Does a type assertion paper over an unclear invariant?                                                                                                            |
| Boolean flag parameters                       | Is positional meaning hidden at call sites?                                                                                                                       |
| Pass-through wrapper                          | Does the function forward calls without adding meaning?                                                                                                           |
| Redundant type assertion                      | Is a cast applied to a type already inferred?                                                                                                                     |
| Unnecessary async wrapper                     | Does an `async` function only await and forward?                                                                                                                  |
| Comment above clear code                      | Does it restate what instead of why?                                                                                                                              |
| File materially grows an already-large file   | Does the change push the file past a healthy boundary with no decomposition? (optional; report only with evidence in the reviewed scope of the pre-existing size) |
| Dependency-direction violation                | Does policy now import an IO-near module (adapter, transport, persistence, framework binding)?                                                                    |
| Framework or I/O details in policy code       | Do core rules depend on UI, filesystem, database, network, framework, or device types?                                                                            |
| Widened visibility or new export              | Is the surface enlarged with no consumer beyond internal needs or tests?                                                                                          |
| Low-level data shape crossing a boundary      | Do high-level modules consume DTOs, persistence shapes, framework types, or transport formats?                                                                    |
| Exposed representation or internals           | Does a module leak representation details or allow invariant bypass?                                                                                              |
| Broad interface spanning concerns or IO-owned | Does one interface cover unrelated concerns, or sit in the layer that should depend on the policy interface?                                                      |

Apply a row only when the change exhibits its signal; never report findings for absent categories.

## Named Structural Remedies

When a structural signal is confirmed, propose the named move — not just the problem:

- Replace a chain of conditionals with a typed model or an explicit dispatcher.
- Collapse duplicate branches into a single clearer flow.
- Separate orchestration from business logic so each reads on its own.
- Move feature-specific logic out of a shared module into the package that owns the concept.
- Reuse the canonical helper instead of a bespoke near-duplicate.
- Make a type boundary explicit so downstream branching disappears.
- Delete a pass-through wrapper that adds indirection without clarifying the API.
- Extract a helper or split a large file into focused modules.
- Invert a dependency-direction violation: define the narrow interface in the high-level module and make the IO-near adapter depend inward.
- Isolate framework/I/O behind the policy-owned interface so core rules do not import delivery details.
- Narrow an accidental public API to the consumers that exist; keep test-only access out of the committed surface.
- Translate low-level data shapes at the boundary so high-level modules see only their own types.
- Hide representation behind the module's interface and enforce invariants at entry points.
- Narrow or re-own a broad interface: split unrelated concerns, or move the interface to the layer whose contract it expresses.

Prefer the remedy that removes moving pieces over one that spreads the same complexity around.
