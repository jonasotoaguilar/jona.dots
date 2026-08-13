# Community Documents Guide

Ownership: the `ci-cd-and-automation` skill creates, maintains, and places `.github/` community documents — CODE_OF_CONDUCT.md, CODEOWNERS, CONTRIBUTING.md, and SECURITY.md. Their canonical templates live in `assets/`.

## Common rules

- **Never overwrite existing files.** If the project already has a community document (repo-root or `.github/`), preserve it — never overwrite, delete, or migrate automatically.
- **No bare placeholders.** Every `PLACEHOLDER_*` token and `@OWNER` (CODEOWNERS) MUST be resolved before the file is considered final — including `PLACEHOLDER_CODE_OF_CONDUCT_CONTACT`.
- **Canonical location**: `.github/` (GitHub-native). Do not create duplicate repo-root copies.

## Per-document guidance

| Document | Template | Placeholder rules |
|----------|----------|-------------------|
| **CODE_OF_CONDUCT.md** | `../assets/CODE_OF_CONDUCT.md` | Resolve `PLACEHOLDER_CODE_OF_CONDUCT_CONTACT` to a real private enforcement contact (email, team alias, or reporting form). Never overwrite an existing Code of Conduct; never create a duplicate repo-root copy when one exists. |
| **CODEOWNERS** | `../assets/CODEOWNERS` | Detect real owners from repo/GitHub evidence (e.g., `git log --format='%ae' | sort -u`, `gh api repos/:owner/:repo/collaborators`, team membership). Replace `@OWNER` with the actual handle or team; validate every handle/team exists before writing. Do NOT leave `@OWNER` in the final file. |
| **CONTRIBUTING.md** | `../assets/CONTRIBUTING.md` | See the CONTRIBUTING.md subsection below. Replace `PLACEHOLDER_*` tokens with the project's actual lint/test commands; verify documented labels exist and match `pr-check.yml`; single canonical contribution doc. |
| **SECURITY.md** | `../assets/SECURITY.md` | Replace every `PLACEHOLDER_*` token — private reporting URL or real security contact, supported versions with support status, realistic response timeframes. |

## CONTRIBUTING.md

The single canonical contribution document (`.github/CONTRIBUTING.md`), generated from `../assets/CONTRIBUTING.md`. Open with the contribution path (branches, PRs, review gates), then group setup, development loop, and review expectations into short sections.

### Minimum coverage

| Area | Include |
|------|---------|
| Local setup | Link to setup docs; don't duplicate them |
| Development loop | Run, test, lint, typecheck commands |
| Branch/PR workflow | Never commit to `main`/`master`; PRs for all merges |
| Commit conventions | Conventional commits; no AI attribution |
| Pre-PR checklist | Tests pass; docs updated if scope changed; no secrets |

### Boundaries

- `.github/CONTRIBUTING.md` is the ONLY contribution document generated. Do not create a duplicate repo-root `CONTRIBUTING.md`.
- Preserve existing-project behavior: if a project already has a contribution file (repo-root or `.github/`), never overwrite, delete, or migrate it automatically.
- Do not invent CI workflows or merge policies the repo does not have; document what exists.

## Cognitive design

Apply the same principles as other docs: lead with the action path, chunk sections, use tables/checklists over prose, and link to deeper docs instead of duplicating.
