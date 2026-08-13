---
name: merge-pr
description: "Trigger: merge chained PRs, stacked PRs, tracker merge, branch chain cleanup. Merge PR chains safely in dependency order with conventional commit messages."
license: Apache-2.0
metadata:
  author: jonasotoaguilar
  version: "1.3"
---

## Activation Contract

Load this skill when merging chained, stacked, tracker, or parent/child PRs, or when deciding merge order, merge type, retargeting, rebasing, branch cleanup, or crafting the merge commit message for a PR chain.

## Hard Rules

- Merge PRs in dependency order; never merge a child before its parent.
- Never delete a branch that is the base for downstream PRs in the same chain.
- Preserve child history with regular merge; squash only the final tracker PR.
- Merge or squash commit messages MUST use conventional commit format with `(#PR)` in the subject and `Closes #issue.` in the footer.
- When squash-merging a PR, the commit body MUST list every commit included in that PR.
- After all PRs in the chain are merged, clean remote branches, switch local checkout to `main`, and prune stale local branch references.
- If chain state, PR targets, or dependency order are unclear, STOP and inspect before merging.

### Merge Commit Format

Every merge or squash commit follows this shape:

```
type(scope): description (#PR)

Body.

Closes #issue.
```

| Element     | Rule                                                                                                 |
| ----------- | ---------------------------------------------------------------------------------------------------- |
| Type        | One of: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert` |
| Scope       | Affected area (optional, recommended). Examples: `auth`, `api`, `workflows`, `ui`                    |
| Description | Imperative mood, present tense, ≤72 chars. Append `(#PR)`.                                           |
| Body        | Required for squash merges; optional for regular merges. Mention chain relationship if chained.      |
| Footer      | `Closes #issue.` referencing the shared spec issue. Add `BREAKING CHANGE: ...` if applicable.        |

### Squash Body

For squash merges, include every commit from the PR as a bullet list in the commit body:

```
- feat(core): add delegation record model
- test(core): cover delegation lifecycle transitions
- docs(readme): document delegation usage
```

### Breaking Changes

Signal breaking changes with `!` after the type/scope, OR with a `BREAKING CHANGE` footer:

```
feat!(api): drop legacy v1 endpoints (#34)
BREAKING CHANGE: Legacy v1 REST endpoints removed. Clients must migrate to v2.
Closes #55.
```

### Example

```
feat(auth): add JWT refresh token rotation (#21)
Refresh token rotation with reuse detection and family invalidation.
Closes #102.
```

## Decision Gates

| Chain state                                  | Action                                                                                                              |
| -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| `stacked-to-main`                            | Merge earliest PR first, then retarget/rebase the next PR onto the updated base.                                    |
| `feature-branch-chain` with children pending | Merge children into parent branches in order; keep tracker draft/no-merge.                                          |
| All children integrated into tracker         | Delete child branches if safe, mark tracker ready, then merge tracker to `main`.                                    |
| Any child still targets a parent branch      | Do not delete that parent branch.                                                                                   |
| All PRs merged                               | Delete merged remote branches, switch local checkout to `main`, fetch/prune, and delete safe merged local branches. |

## Execution Steps

1. Load the chain map: PR number, branch, base branch, parent, and child dependencies.
2. Verify each PR is approved, green, and targeted to the expected base.
3. Format the merge/squash commit: subject with `(#PR)`, body, `Closes #issue.`. For squash, include every PR commit in the body.
4. Merge the next eligible PR only using the chosen merge type.
5. After each merge, retarget/rebase downstream PRs until their diffs are clean.
6. Clean up only branches with no downstream dependents.
7. After the full chain is merged: delete merged remote branches, switch local checkout to `main`, run fetch/prune, and delete safe merged local branches.
8. Return the updated chain state and the next mergeable PR, if any.

## Output Contract

Return: merge order used, PR merged, merge type, merge commit message, branches preserved/deleted locally/remotely, downstream retarget/rebase actions, prune result, remaining blockers, and next safe merge step.

## References

None. Self-contained; no supporting files.
