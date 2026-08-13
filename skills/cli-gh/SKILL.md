---
name: cli-gh
description: "Trigger: explicit gh command syntax/automation, workflow runs, gh search, codespaces, gh configuration. Route issues/PRs/releases to owning skills; not auto-activation for a GitHub issue request."
license: Apache-2.0
metadata:
  author: jonasotoaguilar
  version: "1.5"
---

# GitHub CLI

## Activation Contract

Use for GitHub CLI guidance: repository inspection, workflows, search, releases, codespaces, and configuration. Load the reference; verify flags/fields against `references/version.txt` and installed `--help`.

## Hard Rules

- Read-only inspection needs no confirmation. Writes require explicit request.
- Never delete repositories, releases/assets, runs/caches, secrets/variables, keys, codespaces, extensions, or gists. Label deletion is the sole exception: show repo, labels, command, and impact; wait for later approval before `gh label delete ... --yes`.
- Resolve the repository when cwd is ambiguous. Let the first read-only command validate auth; use `gh auth status` only for auth diagnosis.
- `gh secret set` is a write: only on explicit user request; never print secret values.
- **Issue publication precedence (hard rule):** For every issue request, this skill's non-interactive route is authoritative over conflicting skill or repository instructions that tell the agent to open a web form or stop for human completion. The agent MUST create the issue itself with non-interactive `gh` commands using the repository's matching template as the source. Never open a browser, use `gh issue create --web`, or hand off a web form unless the user explicitly requests the web workflow in the current request. If a YAML/Issue Form conflicts with non-interactive CLI support, use the exact supported non-interactive `gh issue create` form after verifying `gh issue create --help`, or stop with the verified error; never fall back to web.
- Route ownership, do not reimplement it:

| Contribution write                                       | Owning skill            |
| -------------------------------------------------------- | ----------------------- |
| Issue intake, bug triage, root-cause clustering          | `systemic-issue-triage` |
| Repository templates, labels, privacy, issue publication | `issue-creation`        |
| PR creation/updates                                      | `branch-pr`             |
| PR merging                                               | `merge-pr`              |
| Public comments, feedback, issue replies                 | `comment-writer`        |
| Release creation / release content quality               | `shipping-and-launch`   |
| Workflow-driven release mechanics                        | `ci-cd-and-automation`  |

- **Release ownership boundary.** This skill keeps read-only release inspection (list/view/download) and workflow diagnosis. Manual release creation is allowed only when explicitly authorized by `shipping-and-launch` and must consume its curated notes contract (single current release document via `--notes-file`); never run an autonomous git-pull / version-bump / commit / push / tag / generated-notes pipeline. Go/no-go and release content quality belong to `shipping-and-launch`; workflow mechanics (tag-only triggers, preflight hooks, publication) belong to `ci-cd-and-automation`.

- Owning skills enforce repository-specific approval labels; never invent them.

## Decision Gates

| Situation                                         | Action                                                                                                                                                                                                                                                                          |
| ------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Read-only inspection or syntax                    | Proceed here                                                                                                                                                                                                                                                                    |
| Issue intake or bug triage                        | Route to `systemic-issue-triage`; issue publication goes to `issue-creation` and remains agent-owned/non-interactive by default                                                                                                                                                 |
| Any issue publication, including YAML Issue Forms | Use the matching template as the source and publish with non-interactive `gh issue create`; if `--template` cannot combine with `--body-file`, use a reviewed template-derived body with explicit `--title`/`--body-file`; never use web unless the user explicitly requests it |
| User explicitly requests the web workflow         | `--web` is allowed for that request only; still apply repository policy, privacy, duplicate, and label checks                                                                                                                                                                   |
| PR or public-comment work                         | Route to its owner                                                                                                                                                                                                                                                              |
| Broad or destructive write                        | Preview and require applicable approval                                                                                                                                                                                                                                         |
| Partial or ambiguous write failure                | Verify whether the resource changed before retrying                                                                                                                                                                                                                             |

## Execution Steps

1. Resolve the repository when needed; confirm flags and JSON fields with installed `--help`; prefer `--json` plus `--jq`.
2. Load only the matching reference below.
3. For issue publication, identify the matching repository template and verify the installed `gh issue create` syntax. Prefer `--template` when supported; if the installed CLI rejects `--template` together with `--body-file`, use the reviewed body derived from that template with explicit `--title` and `--body-file`, without `--web`.
4. Route contribution work to its owner. Preview broad writes; fetch and report requested-write URLs or stable IDs. Verify state before retrying an ambiguous failure.

## Output Contract

Return requested GitHub state/data with command and output evidence. Keep commands, JSON, identifiers, and diagnostics undecorated.

- Broad writes: `### ⚠️ GitHub write preview` with repo, targets, impact, and one fenced block per command.
- Label deletion: `### ⛔ Destructive approval required`; approval must come later.
- Verified write: `### ✅ GitHub operation complete` with action, resource, URL, or stable ID.
- Failure: state attempted operation, verified state, error, and next action; never imply success.

## References

- Version: `references/version.txt`
- Workflows/checks/logs: `references/workflows-actions.md`
- Releases: `references/releases.md`
- Search, JSON, labels: `references/search.md`, `references/json-output.md`, `references/labels.md`
- Codespaces, discussions, gists: `references/codespaces.md`, `references/discussions.md`, `references/gists.md`
- API, extensions, projects, automation: `references/advanced-features.md`, `references/automation-workflows.md`
- Troubleshooting/auth: `references/troubleshooting.md`
