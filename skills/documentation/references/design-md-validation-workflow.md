# Validation Workflow

Validate after every create/update of `DESIGN.md` with the canonical entry point:

```bash
scripts/validate-design-md.sh [path-to-DESIGN.md]
```

The script wraps the official check `npx @google/design.md lint DESIGN.md` and adds local fallback checks — YAML front matter presence, required `name`, canonical 8-section order, optional sections after the core — so validation still runs when the official CLI is unavailable (offline / not installed). The official CLI remains the primary check; the local checks are fallback and guardrails, not a replacement.

`omitted:` front matter: sections declared in the `omitted:` list (strings or `{ section, reason }` entries) are intentionally absent. The official CLI suppresses warnings for them, and the local fallback applies the same suppression (at minimum for `colors`).

Useful official-CLI follow-ups:

```bash
npx @google/design.md lint --format json DESIGN.md
npx @google/design.md diff DESIGN.md DESIGN-v2.md
```

Interpretation rules:

- **errors** → fix before considering the file complete
- **warnings** → address when they reflect real quality gaps
- **info** → use as guidance, not blockers
- **CLI unavailable** → the script's local fallback checks still gate schema and section order

Required completion rule:

- Do NOT report the `DESIGN.md` task complete until `scripts/validate-design-md.sh` exits successfully (official lint passes, or its fallback checks pass when the official CLI is blocked by an environment/tooling issue).
- If the official CLI is blocked, explicitly report the blocker and still perform a manual schema + section-order review.
