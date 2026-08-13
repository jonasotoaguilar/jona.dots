---
name: shipping-and-launch
description: "Trigger: release readiness, deploy authorization, rollout/canary/rollback, go/no-go, release notes, pre-launch checks. Release/rollout contract, not pipeline or workflow implementation."
license: Apache-2.0
metadata:
  author: jonasotoaguilar
  version: "1.5"
---

## Activation Contract

Use when preparing a production deployment, a significant user-facing release, or authoring a GitHub release: pre-launch readiness, staged or canary rollout, monitoring, rollback, or release notes. Serves as a release-readiness and rollout/rollback contract, and covers GitHub release authoring whether the release is cut by a workflow (CI/tag-driven) or manually (`gh release create`).

## Hard Rules

- **Never deploy autonomously.** The user initiates the deploy; you prepare, verify, and present a go/no-go. Never trigger the deployment or advance a rollout without explicit go-ahead.
- **Evidence, not invented thresholds.** Use the project's own tests, security tooling, observability, SLOs, and rollout mechanisms. Do not fabricate metric thresholds or checklist items that do not apply.
- **Rollback before rollout.** A concrete, tested rollback path exists before any deploy: what triggers it, how it runs, how long it takes, and what happens to new data.
- **Observability before launch.** Health checks, error reporting, logs, and SLO-relevant metrics are live and verified before rollout.
- **Authorization is explicit.** Confirm who approves this deploy/rollout and that approval is granted for this specific release.
- **Data migrations: expand/contract, not universal down migrations.** Use additive/backward-compatible phases (expand → dual-write/backfill → switch reads → retire) so the deploy stays reversible without a destructive down migration. Every migration ships with a tested rollback/data-recovery plan (restore path or forward repair) that does not block or break the rollback path. A down migration is required only when safe and supported by the storage engine and tooling; irreversible transformations require backup/restore or forward repair plus explicit risk approval.
- **Release notes follow the repo format.** Use `assets/github-release-template.md` as an adaptable example: adjust it to the project's conventions and to what actually changed in this release; never invent changelog entries, versions, provenance, or known issues — every claimed change is backed by an issue or commit.
- **Single current release document — mechanics owned by `ci-cd-and-automation`.** Release notes live in exactly ONE current narrative document, `docs/releases/<tag>.md`; the lifecycle mechanics (`git mv` rename, template never installed, preflight validation, `--notes-file` publication) are defined once in `../ci-cd-and-automation/references/release-notes.md` — do not repeat them here. This skill owns notes quality and content: accurate provenance, honest known issues, sections matching the exact bytes released. Published releases are the history; the in-repo document is renamed for the next release.
- **Ownership boundary.** Notes quality (accuracy, provenance, known issues), go/no-go, and rollout belong here. Pipeline mechanics — preflight validation of the notes file, rename/automation hooks, workflow templates — belong to `ci-cd-and-automation`; do not duplicate its template or validation guidance.
- **Prerelease and stable conventions are explicit.** Mark RCs as prereleases and state what to test; a stable promotion states its exact provenance (candidate/tag/SHA); keep the known-issues section honest for the exact bytes released.
- **Assets match the notes.** Install commands and integrity steps (checksums, signatures) must match the assets actually attached; verify before publishing, workflow or manual.

## Decision Gates

| Situation                         | Action                                                                                                                                                                                                                                                                                                                                                                |
| --------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Go/no-go evidence incomplete      | Hold; do not roll out                                                                                                                                                                                                                                                                                                                                                 |
| High-risk or irreversible change  | Canary: small slice first, advance on evidence, roll back on regression                                                                                                                                                                                                                                                                                               |
| Broad but low-risk release        | Staged: environment/cohort order with a gate at each step                                                                                                                                                                                                                                                                                                             |
| Simple, low-risk, fully verified  | Full rollout with post-launch monitoring                                                                                                                                                                                                                                                                                                                              |
| SLO or error-budget breach        | Roll back; escalate rather than continue                                                                                                                                                                                                                                                                                                                              |
| Rollout cannot be observed        | Stop; enable monitoring first                                                                                                                                                                                                                                                                                                                                         |
| Release cut by workflow or manual | Follow the repo's automation contract: workflow-owned tags/drafts go through the pipeline unchanged; manual cuts use `gh release create` with the single current release document (`--notes-file docs/releases/<tag>.md`) and an explicit prerelease flag. Notes doc missing, misnamed, or placeholder-filled → fix it in git before publishing, never publish a stub |

## Execution Steps

1. **Verify readiness with project-specific evidence:** run the repository's own tests, lint/type checks, build, and security audit; confirm docs (setup, API, changelog) current.
2. **Confirm observability:** health checks, error reporting, logs, and SLO-relevant metrics configured and checked; establish what "normal" looks like.
3. **Check data migration and authorization:** rollback/data-recovery plan tested (down migration where safe and supported, else backup/restore or forward repair with risk approval); deploy/rollout approval explicit.
4. **Choose the rollout mode** per the Decision Gates (full/staged/canary); define the advance/rollback gate at each step.
5. **After deploy:** verify health, watch the agreed metrics for the defined window, compare against baseline, run the critical user flow.
6. **Confirm rollback readiness** (feature flag off or prior version restore) before and after the rollout; execute immediately on regression.
7. **Author the GitHub release notes** in the single current release document (`docs/releases/<tag>.md` — rename the previous one via `git mv`, replace its content) by adapting `assets/github-release-template.md` to this project and this release's actual changes. Validate before publishing: name/H1 match the exact tag, narrative sections present, no placeholders, install commands/assets/provenance accurate. Publish (workflow or manual) consumes the file via `--notes-file`; verify attached assets and prerelease flag match the notes.

## Output Contract

Return: go/no-go decision with rationale; evidence produced (tests, security, SLOs, migrations, docs, authorization); chosen rollout mode and advance/rollback gates; monitoring window and observed results; rollback plan with trigger conditions and steps; unresolved risks and who owns them. When a release was requested: drafted release notes, the exact tag/version and prerelease flag used, and the asset/integrity checklist (checksums, signatures, install commands verified against attached assets).

## References

- `assets/github-release-template.md` — adaptable example structure for GitHub release notes (stable, prerelease, compact patch) plus asset and integrity conventions and the single-current-release-document lifecycle.
- `../ci-cd-and-automation/references/release-notes.md` — the pipeline-side contract (preflight validation, exactly-one-document enforcement); this skill owns notes quality and the go/no-go, not the mechanics.
