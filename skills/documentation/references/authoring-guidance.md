# Authoring Guidance

Compact guidance for documentation quality. Apply on top of the templates and per-document references.

## Document the why, not the what

- Write only what the reader lacks — no tutorial prose, no restating nearby content, no padding simple changes. If cutting a sentence loses no rule or decision, cut it.
- Comment the non-obvious intent, never restate the code. `// increment counter` is noise; a comment explaining a sliding-window rate-limit reset boundary earns its place.
- Do not comment self-explanatory code, leave TODO comments for work you should just do, or keep commented-out code — git has history.
- Document known gotchas inline where they matter, with a link to the ADR or design note that explains the rationale.

## Changelog maintenance

For shipped features, keep a curated, human-readable changelog grouped by impact (`Added / Changed / Fixed / Deprecated / Removed / Security`), newest on top. Write the entry with the change, not reconstructed at release time. A changelog is not `git log`.

## Documentation for agents

- **Rules files** (AGENTS.md) — document project conventions so agents follow them.
- **Specs** — keep spec-driven requirements current so agents build the right thing.
- **ADRs** — help agents (and humans) understand why past decisions were made; prevents re-deciding.
- **Inline gotchas** — prevent agents from falling into known traps.

## Common rationalizations

| Rationalization                            | Reality                                                                                           |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------- |
| "The code is self-documenting"             | Code shows what. It doesn't show why, what alternatives were rejected, or what constraints apply. |
| "We'll write docs when the API stabilizes" | APIs stabilize faster when documented; the doc is the first test of the design.                   |
| "Nobody reads docs"                        | Agents do, future engineers do, your 3-months-later self does.                                    |
| "ADRs are overhead"                        | A 10-minute ADR prevents a 2-hour debate about the same decision six months later.                |
| "Comments get outdated"                    | Comments on _why_ are stable; comments on _what_ get outdated — write only the former.            |

## Red flags

- Architectural decisions with no written rationale.
- Public APIs with no documentation or types.
- README that doesn't explain how to run the project.
- Commented-out code instead of deletion.
- TODO comments that have been there for weeks.
- Documentation that restates the code instead of explaining intent.
