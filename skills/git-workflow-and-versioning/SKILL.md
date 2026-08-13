---
name: git-workflow-and-versioning
description: "Trigger: local Git work: branches, commits, conflicts, tags, version metadata, changelogs, Git diagnostics. Not PR merging (merge-pr) or release publication (shipping-and-launch)."
license: MIT
metadata:
  author: jonasotoaguilar
  version: "2.5.0"
---

## Activation Contract

Generic Git workflow/versioning guidance. Load when the task involves commits, branching, merging, resolving conflicts, releases, semantic versioning, tags, changelogs, Git diagnostics, Git metadata setup (root `.gitignore`/`.gitattributes`), or defining/documenting versioning, release, tag, or changelog conventions (not only executing them). Applies to every code change that flows through git. Apply inline; not an SDD phase or subagent.

## Hard Rules

- **Branch discipline.** Never work, commit, or push directly on `main`/`master`; start changes on a dedicated branch and merge through a PR. Parallel worktree creation and placement belong to `parallel-work` and the repository's CodeGraph guidance; do not infer a worktree location from this skill.
- **PR pre-flight sync.** Before creating/opening a PR, verify the default branch (`main`/`master`) is up to date from its remote: `git fetch` then compare local vs remote default branch. If the remote has new commits, bring them into the PR branch — prefer rebase when appropriate, preserve the repo's existing branch/remote conventions, and never force-push shared branches. On conflict, stop PR creation until conflicts are resolved, then re-run this verification and continue. Creating/opening the PR itself is `branch-pr`'s job.
- **Update affected documentation before commit/PR.**
- **Atomic, descriptive commits.** One logical change per commit; message explains the _why_ (`<type>: <description>`); conventional commit types (`feat`, `fix`, `refactor`, `test`, `docs`, `chore`); no AI attribution.
- **No secrets in diffs.** Scan staged changes before committing.
- **Tag = source of truth.** Cut an annotated tag for each release; derive the version from the tag, never hand-edit scattered version files; write the changelog entry in the same change.
- **Root Git metadata, evidence-gated.** Create or update `.gitignore`/`.gitattributes` only when a real gap exists (untracked noise, secret risk, polyglot/mixed-line-ending evidence). Never dump template files; append missing rules only and preserve every existing entry.
- **Boundaries.** Hooks/automated PR gates (size/issue/type-label) → `ci-cd-and-automation`; PR creation/opening → `branch-pr`; chain strategy/splitting → `chained-pr`; commit work-unit boundaries → `work-unit-commits`; issues → `issue-creation`; chained merge → `merge-pr`; release shipping → `shipping-and-launch`; migration windows → `deprecation-and-migration`. Do not duplicate their guidance.

## Decision Gates

| Situation                                                          | Action                                                                                                                                                                                                                                                        |
| ------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Hooks / automated PR gates (size/issue/type-label)                 | `ci-cd-and-automation` (owner)                                                                                                                                                                                                                                |
| Git setup: root `.gitignore` / `.gitattributes`                    | Audit for gaps (untracked noise, missing secret coverage, polyglot evidence); append missing rules only, preserve existing; no templates. Load `references/git-practices.md`                                                                                  |
| PR pre-flight before opening a PR                                  | Fetch and verify the default branch is up to date from its remote; rebase the PR branch onto it (merge only when the repo's conventions require); on conflict, stop PR creation until resolved, re-verify, then hand off to `branch-pr`. See Execution Step 5 |
| Commits/branching/conflicts                                        | `references/git-practices.md`                                                                                                                                                                                                                                 |
| Release/version/tag/changelog                                      | `references/git-practices.md` (release & versioning) + `shipping-and-launch` boundary                                                                                                                                                                         |
| Define/document versioning, release, tag, or changelog conventions | `references/git-practices.md` (release & versioning); apply the convention to the metadata being edited                                                                                                                                                       |
| Git debugging (bisect, blame, log)                                 | `references/git-practices.md` (git debugging)                                                                                                                                                                                                                 |

## Execution Steps

1. Inspect the repo: default branch, existing branch state, existing `.gitignore`/`.gitattributes`. Respect existing conventions.
2. Load only the reference(s) the Decision Gate names.
3. Apply Git metadata setup only when evidence shows a gap; append, never overwrite or dump templates.
4. Validate: no direct-to-main work, staged-diff secret scan, version matches tag, changelog entry present.
5. PR pre-flight before `branch-pr` handoff: fetch and verify the default branch (`main`/`master`) is up to date from its remote. If the remote has new commits, bring them into the PR branch — prefer rebase when appropriate, preserve existing branch/remote conventions, never force-push shared branches. If rebasing/merging produces conflicts, stop PR creation until they are resolved; then re-run this step and continue.

## Output Contract

Return: files created/modified (exact paths) or `None required`; Git setup outcome (created/updated/skipped with the evidence, especially for `.gitattributes`); version/tag/changelog state; branches touched; PR pre-flight outcome (default branch synced, PR branch rebased/merged, conflicts resolved) or `None required`; references consulted; boundary handoffs.

## References

- `references/git-practices.md` — commit discipline, branching, save points, change summaries, pre-commit hygiene, git debugging, release/versioning (incl. versioned metadata), red flags.
