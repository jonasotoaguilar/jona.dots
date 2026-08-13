# PR Validation (pr-check.yml)

Single workflow with four jobs that gate PR quality. Installed verbatim from `../assets/workflows/pr-check.yml` — canonical, never regenerated per stack.

## Job Gates

| # | Job | Rule |
|---|-----|------|
| 1 | `check-pr-size` | `additions + deletions <= 400` unless `size:exception` label present |
| 2 | `check-issue-reference` | Tracker/main PR: `Closes/Fixes/Resolves #N`; child PR: `Related to #N` |
| 3 | `check-issue-approved` | Referenced issue(s) must have `status:approved` label |
| 4 | `check-type-label` | Exactly one `type:*` label on the PR |

## Behavior Contract

- Triggers on `[opened, edited, synchronize, labeled, unlabeled]`.
- `permissions`: read-only (contents, issues, pull-requests); `github-script` with token only where a label/issue fetch is required.
- `concurrency`: group by `github.event.pull_request.number`, `cancel-in-progress: true`.
- `timeout-minutes: 5` per job.
- The asset pins `actions/github-script@v9` (floating major); re-verify the current major before install.

## Deployment

- Copy `../assets/workflows/pr-check.yml` to the target repo's workflow directory.
- Ensure the referenced labels exist in the repo (`size:exception`, `status:approved`, `type:*` set); the CONTRIBUTING doc must document the same label set.
- Do not weaken the canonical asset: gates and thresholds are deliberate review-focus policy.
