# `AGENTS.md` Defaults

Create only when a repo-root `skills/` directory exists.
Do not use global `.agents/` or `.claude/` directories for this step.

Generate `AGENTS.md` at repo root using this generalized template:

```markdown
# {Project Name} — Agent Skills Index

When working on this project, load the relevant skill(s) BEFORE writing any code.

Naming convention: project-prefixed skills are repo-specific workflow skills. Unprefixed skills are portable skills and keep their canonical names.

## How to Use

1. Match the task to the trigger.
2. Read the referenced `SKILL.md`.
3. Follow all rules from that skill.
4. Load multiple skills when needed.

## Skills

| Skill | Trigger | Path |
|---|---|---|
| `{resolved-skill-name}` | `{description from frontmatter}` | `{relative-path}` |
```

Rules:
- Read `name` and `description` from frontmatter.
- Use a project-specific prefix only for repo-specific skills.
- Keep canonical ecosystem skill names unprefixed.
- If `AGENTS.md` already exists, append missing entries only.
- If no repo-root `skills/` exists, report `not applicable`.

### OpenSpec projects

When the project uses OpenSpec (a repo-root `openspec/` with `config.yaml`), add an entry so agents route requirements work to the spec store instead of inventing parallel specs:

| Reference | When to add |
|-----------|-------------|
| `openspec/` | Add when present: `openspec/config.yaml`, `openspec/specs/` (main specs), `openspec/changes/` (active changes). Spec-driven requirements live here, not in a parallel doc. |

Place it in the `## Project Documentation` list; omit when the project does not use OpenSpec.

## Project doc references

If the project has a `docs/` directory at repo root, scan for key files and add references to `AGENTS.md`:

| Reference | When to add |
|-----------|-------------|
| `ARCHITECTURE.md` (repo root) | Always add. Covers backend design, architecture decisions, system design. |
| `DESIGN.md` (repo root) | Always add. Covers UI/UX design, component design, frontend architecture. |
| `docs/` directory | Scan for significant docs (guides, ADRs, runbooks, API docs, etc.) and add entries for the most relevant ones. |

Entries go below the Skills table:

```markdown
## Project Documentation

- `ARCHITECTURE.md` — Backend design, architecture decisions, system design
- `DESIGN.md` — UI/UX design and frontend component design
- `docs/{filename}` — {brief description}
```

Skip files that are not useful as agent references (e.g. meeting notes, drafts).
