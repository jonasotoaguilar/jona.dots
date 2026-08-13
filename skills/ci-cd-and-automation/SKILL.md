---
name: ci-cd-and-automation
description: "Trigger: pipeline and config mechanics: CI/CD workflows, build/test jobs, repository hooks, PR validation gates, GitHub issue/PR templates. Owns pipeline/automation implementation, not release or rollout decisions."
license: MIT
metadata:
  author: jonasotoaguilar
  version: "1.6.0"
---

## Activation Contract

Load when the task sets up, modifies, or debugs build/deployment pipelines, automated quality gates, workflows, repository hooks, or deployment automation — for design, implementation, or verification. Apply inline; not an SDD phase or subagent.

## Hard Rules

- **Evidence over assumptions.** Detect stack and test commands from the repo (lockfiles, manifests, existing scripts); never invent a command or pin a runtime the repo does not pin.
- **No silent skips.** Missing test command or coverage decision fails with an explicit message; never claim checks ran when nothing was collected.
- **Minimum permissions.** Declare `permissions` at workflow scope; never rely on org defaults.
- **Pin actions to floating major tags** (`@vN`); never `@main`/`@latest`/narrow tags.
- **No script injection.** Pass attacker-controllable values through `env:`, never into a `run:` script body.
- **Reversible deploys.** Every deployment has a rollback story.
- **Secrets stay in the secrets manager**, never in code or workflow files.
- **Tag-only release authorization.** Release workflows MUST trigger on an explicit stable version tag (`push: tags: ["v*", "!v*-*"]`), never on a branch push. The maintainer pushing the stable tag is the release go/no-go; pre-release tags never reach publication.
- **Curated release notes (single current release document).** Every release publishes a curated, narrative body from the ONE current release document (`docs/releases/<tag>.md`), reviewed in git before tagging — never a raw commit log or auto-generated changelog. Preflight hooks MUST fail before publication on zero/multiple documents, wrong filename, or empty/placeholder/malformed/mismatched body; the publish hook creates the release from the curated notes. Contract: `references/release-notes.md`; template: `assets/release-notes-template.md`.
- **Gate ownership boundaries.** This skill owns repository-local hooks and automated PR-quality gates (size/issue/type-label checks); the canonical `pr-check.yml` is installed verbatim, never weakened. PR creation → `branch-pr`; chained splitting → `chained-pr`; issue lifecycle → `issue-creation`; releases/shipping → `shipping-and-launch`; root-cause debugging → `debugging-and-error-recovery`. Do not duplicate their guidance.
- **Architecture checks are signal-gated.** Add lightweight import-cycle/forbidden-import/dependency-direction/adapter-boundary checks ONLY when the project declares boundaries/dependency rules in docs or config (`references/workflow-patterns.md`); never invent architecture policy.
- **`.github` templates and governance assets owned here.** Canonical issue forms, PR template, and community/governance documents (CODE_OF_CONDUCT.md, CODEOWNERS, CONTRIBUTING.md, SECURITY.md) live in `assets/` with authoring guidance in `references/community-docs-guide.md`. Install into the project's `.github/`; resolve every per-project placeholder (e.g. Discussions URL in `config.yml`) before install; never overwrite existing files. Issue lifecycle → `issue-creation`; PR creation → `branch-pr`.

## Decision Gates

| Situation                                                           | Action                                                                                                                                                                       |
| ------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| New pipeline (CI/CD)                                                | `references/workflow-patterns.md` (structural rules, generation contract, stack detection) + `references/pipeline-patterns.md`                                               |
| Modify an existing pipeline                                         | `references/workflow-patterns.md`; diff against existing behavior; preserve working steps                                                                                    |
| CI failure / troubleshooting                                        | `references/pipeline-patterns.md` + `debugging-and-error-recovery` for root cause                                                                                            |
| Hooks                                                               | `references/hooks.md` — repo-local; staged-file scope; full runs in CI/pre-push                                                                                              |
| PR-quality workflow (size/issue/type gates)                         | `references/pr-check.md` + `assets/workflows/pr-check.yml` (canonical)                                                                                                       |
| Deployment automation (staging/prod, rollback, flags, environments) | `references/pipeline-patterns.md` (deployment strategies)                                                                                                                    |
| Pipeline optimization (slow CI)                                     | `references/pipeline-patterns.md` (CI optimization)                                                                                                                          |
| Project declares boundaries/dependency rules                        | `references/workflow-patterns.md` architecture-check rules; no declared boundaries → no architecture checks                                                                  |
| Dependency-update automation                                        | `references/pipeline-patterns.md` (automation beyond CI)                                                                                                                     |
| Release workflow                                                    | `assets/workflows/release.yml` (tag-only trigger, preflight → publication → verification, curated notes); `references/release-notes.md` + `assets/release-notes-template.md` |
| GitHub issue forms / PR template (`.github`)                        | `assets/ISSUE_TEMPLATE/*` + `assets/PULL_REQUEST_TEMPLATE.md` (canonical, install verbatim); resolve per-project placeholders                                                |
| Governance/community docs                                           | `references/community-docs-guide.md` + canonical templates in `assets/`; resolve every placeholder; never overwrite existing files                                           |

## Execution Steps

1. Inspect the repo: lockfiles/manifests, existing workflows, test config, deployment targets, existing hooks. Note what exists; missing context is reported, not assumed.
2. Load only the reference(s) the Decision Gate names.
3. Design the pipeline per the generation contract; use the repo's own commands and native caches.
4. Apply structural rules (permissions, concurrency, timeouts, pins, injection safety).
5. Validate: workflow syntax, test command resolvable, coverage behavior explicit, rollback defined; hooks repo-local; PR-quality workflow installed verbatim with its labels verified.
6. Report gates met, stack detected, hook and PR-gate status, and any unresolved decisions.

## Output Contract

Return: the pipeline/workflow config (or diff for modifications); stack detected + test/coverage resolution; structural-rule confirmation; rollback story; hook and PR-gate status (which gates passed: size/issue/type-label); references consulted; unresolved decisions that blocked honest checks; boundary handoffs per the Gate ownership boundaries hard rule.

## References

- `references/workflow-patterns.md` — structural rules, pinning, injection prevention, stack-adaptive CI generation contract, signal-gated architecture checks.
- `references/pipeline-patterns.md` — quality gates, deployment strategies, environments, automation beyond CI, optimization.
- `references/hooks.md` — repo-local hook defaults.
- `references/pr-check.md` + `assets/workflows/pr-check.yml` — PR validation contract and canonical install.
- `assets/workflows/release.yml` — canonical generic release contract (tag-only trigger, read-only permissions, per-tag concurrency, bounded preflight → publication → verification, exact-tag checkout, project-owned fail-closed hooks, curated notes, credentials via secrets).
- `references/release-notes.md` + `assets/release-notes-template.md` — curated notes contract: single current document (`docs/releases/<tag>.md`, renamed via `git mv`; template never installed), preflight validation, `--notes-file` publication.
- `references/community-docs-guide.md` + `assets/` governance templates (CODE_OF_CONDUCT.md, CODEOWNERS, CONTRIBUTING.md, SECURITY.md) — placeholder rules; CONTRIBUTING.md documents the `pr-check.yml` label set.
- `assets/ISSUE_TEMPLATE/*` — canonical issue forms (`bug`/`enhancement` + `status:needs-review` labels, `status:approved` gate matching `pr-check.yml`); `config.yml` — `blank_issues_enabled: false`, Discussions `{owner}/{repo}` placeholder resolved before install.
- `assets/PULL_REQUEST_TEMPLATE.md` — canonical PR body: issue linkage, exactly-one `type:*` set, Chain Context table, test plan, automated-checks table, contributor checklist.
