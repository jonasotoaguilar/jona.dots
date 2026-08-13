# ADR-{number}: {Title}

## Before you write — does this need an ADR?

| Question                                                 | If YES → ADR | If NO → skip                              |
| -------------------------------------------------------- | ------------ | ----------------------------------------- |
| Two viable technologies with real trade-offs?            | Write ADR    | Not needed                                |
| Decision affects ≥2 teams or has long-term consequences? | Write ADR    | Not needed                                |
| Architecture pattern choice (monolith vs microservices)? | Write ADR    | Not needed                                |
| Infrastructure/deployment model choice?                  | Write ADR    | Not needed                                |
| Framework/library choice based on team familiarity?      | Skip ADR     | Record in `ARCHITECTURE.md` Key Decisions |
| Config values, linting rules, folder structure?          | Skip ADR     | Document in README                        |

> Reviewers: the **Decision** section is the answer. Read that first. Context supports it; Options/Trade-off Analysis are optional depth.

## Status

[Proposed | Accepted | Deprecated | Superseded by ADR-XXX]

## Date

[YYYY-MM-DD]

## Deciders

[Names of people who need to sign off on this decision]

## Context

[Describe the situation and forces at play. What is the problem? What constraints exist? What are we trying to achieve? What are the business and technical drivers?]

## Decision

[State the decision clearly and concisely. What are we going to do? Be specific — not «We will use a database» but «We will use PostgreSQL 15 on AWS RDS with Multi-AZ deployment».]

## Consequences

### Positive

- [Benefit 1 — what becomes easier, faster, cheaper, or more reliable]
- [Benefit 2]

### Negative

- [Drawback 1 — what becomes harder, slower, more expensive, or more complex]
- [Drawback 2]

### Neutral

- [Side effect that is neither good nor bad, just different]
- [e.g., Team will need to learn a new tool]

## Options Considered _(optional — only when the alternatives materially shaped the decision)_

Include this section only when the options genuinely informed the choice. Use pros/cons, or a small comparison table covering ONLY the dimensions that actually differed (e.g., complexity, cost, operational overhead) — never a forced fixed-dimension table.

### Option A: [Name]

**Pros:**

- [Pro 1]
- [Pro 2]

**Cons:**

- [Con 1]
- [Con 2]

### Option B: [Name]

[Same format; add as many options as were genuinely considered. Omit the whole section when the Decision stands on its own.]

## Trade-off Analysis _(optional — pairs with Options Considered)_

[Key trade-offs between the options. What are we gaining and what are we giving up? Why does the chosen option win despite its drawbacks? Omit when Options Considered is omitted.]

## References

- [Link to relevant documentation, RFCs, discussions]
- [Link to related ADRs if this decision builds on or supersedes another]

---

## ADR Naming Convention

```
docs/
└── adr/
    ├── 0001-use-postgresql-database.md
    ├── 0002-adopt-modular-monolith.md
    └── 0003-implement-circuit-breaker.md
```

### File naming: `NNNN-lowercase-slug.md`

- Use 4-digit zero-padded numbers.
- Slug describes the decision in 3-6 words.
- Keep it lowercase, use hyphens.

### Linking

Link every ADR from the `ADRs` section of `ARCHITECTURE.md`. Do not create an additional README index under `docs/adr/` — ARCHITECTURE.md is the index.

### Lifecycle

```
PROPOSED → ACCEPTED → (SUPERSEDED or DEPRECATED)
```

- Never delete a superseded or deprecated ADR: it preserves decision history.
- When a decision changes, write a new ADR and set the old one's Status to `Superseded by ADR-XXX` (or `Deprecated`), linking the successor from its References section.
