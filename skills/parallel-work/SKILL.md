---
name: parallel-work
description: "Trigger: 2+ independent tasks run in parallel, background agents, isolated worktrees/lanes, combining parallel work, 4R parallel launch, SDD apply. Dependent or stateful work stays sequential."
license: Apache-2.0
metadata:
  author: "jonasotoaguilar"
  version: "3.1"
---

# Parallel Work

## Activation Contract

Load when TWO OR MORE tasks can run concurrently: separate changes, independent features, split batches, SDD apply batches. Sequential is the default; prefer parallel whenever independence allows it — never serialize independent work out of habit. Parallel `background: true` is reserved for independent tasks: disjoint scopes share the base branch; colliding scopes isolate in worktrees and combine after validation. Owns topology and isolation only; PR mechanics → `branch-pr`/`merge-pr`; commits → `work-unit-commits`.

## Hard Rules

- Sequential is the default. Parallel `background: true` only for independent tasks; dependent or stateful work (shared state, ordered writes) stays sequential on the base.
- Worktrees are optional, for collision only: create one branch + worktree per lane only when lanes may touch the same files; disjoint or sequential work runs on the shared base branch. Placement and `.codegraph/` per AGENTS.md CodeGraph rule.
- Isolated lanes: `git worktree add -b <type/desc> <path> <base>`; shared-base lanes: `git checkout -b <type/desc> <base>`.
- Isolated prompts name the lane's absolute worktree path and require every git/file command to run in that cwd; shared-base prompts omit it.
- 4R review ALWAYS runs four read-only agents in parallel: one `task` call per R1–R4 lens in the same message, `background: true`, same frozen candidate, separate evidence; never merge lenses.
- Launch `background: true` in one message; foreground only for decisions or unmet dependencies. Never poll; act on completion notifications.
- Validate a lane before launching successors or combining. Combine only validated lanes: direct merge into the integration base, or a branch chain (`branch-pr` → `chained-pr` if >400 lines → `merge-pr`) in dependency order; resolve conflicts at combine time; no force-push.
- Remove worktrees only after integration (`git worktree remove` + `git worktree prune`).
- One cost/side-effect forecast before long or multi-agent work.

## Decision Gates

| Situation                               | Action                                                 |
| --------------------------------------- | ------------------------------------------------------ |
| Independent tasks, disjoint scopes      | Parallel `background: true` on the shared base branch  |
| Independent tasks, colliding scopes     | One worktree/branch per lane; combine after validation |
| Dependent or stateful work              | Sequential on the base; no worktrees                   |
| SDD independent work units              | Parallel `sdd-apply` agents, one per unit              |
| 4R review                               | ALWAYS four parallel `task` calls, one per lens        |
| Needs a decision or gates another start | Foreground                                             |
| Lane >400 lines or stacked              | Load `chained-pr` before writing                       |
| Lane creates commits or a PR            | Load `work-unit-commits`, then `branch-pr`             |

## Execution Steps

1. Build a dependency graph; `A → B` means B waits for validated A.
2. Mark ready independent lanes; one active writer per lane.
3. Colliding lanes only: `git worktree add -b <type/desc> <repo-parent>/<repo-name>-worktrees/<lane> <base>`.
4. Launch ready lanes with `background: true` in one message.
5. Continue main-thread work; never wait or poll.
6. On notification, validate that lane's tests, scoped diff, and spec coverage.
7. Launch validated dependents; stall and report invalid lanes without blind retries.
8. Combine validated lanes: direct merge into the integration base, or chain PRs (`branch-pr`, `chained-pr` if needed, `merge-pr` in order).
9. After integration, remove each lane's worktree and prune (`git worktree remove` + `git worktree prune`).

## Output Contract

Return lanes (worktree + branch), status per lane, per-lane evidence, blocked lanes with reasons, chosen combination strategy, per-lane publish/merge status. Mark a lane done only when its evidence is complete and its branch is integrated or published.

## References

- `../chained-pr/SKILL.md` — Split oversized or stacked lanes.
- `../branch-pr/SKILL.md` — Gate each lane's PR with evidence.
- `../merge-pr/SKILL.md` — Merge branch chains in dependency order.
- `../work-unit-commits/SKILL.md` — Keep commits reviewable by work unit.
- `../judgment-day/SKILL.md` — Validate adversarially when evidence is challenged.
