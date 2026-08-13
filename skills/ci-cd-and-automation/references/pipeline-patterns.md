# Pipeline & Deployment Patterns

Concise reference for CI quality gates, deployment strategies, environment handling, and automation beyond CI. Load per Decision Gate; do not preload.

## Quality Gate Pipeline

Every change passes these gates before merge (skip none — fix the code, never disable the rule):

```
PR opened → lint → type check → unit tests → build → integration → e2e (optional) → security audit → bundle size → ready for review
```

Move checks upstream: static analysis before tests, tests before staging, staging before production.

## Deployment Strategies

- **Preview deployments**: every PR gets a preview for manual testing (Vercel/Netlify-style). Gate on `if: github.event_name == 'pull_request'`.
- **Feature flags**: decouple deploy from release — ship code without enabling it, roll back by disabling the flag, canary (1% → 10% → 100%), A/B tests. Flag lifecycle: create → test → canary → full rollout → remove flag and dead code. Set a cleanup date at creation; flags that live forever become technical debt.
- **Staged rollouts**: merge → staging (auto) → manual verification → production (manual/auto after staging) → monitor 15 min → rollback on errors or clean.
- **Rollback plan**: every deployment must be reversible. Provide a manual rollback path (e.g., workflow_dispatch with a `version` input) or redeploy-previous; never leave a deploy without a revert story.

## Environment Management

```
.env.example       → committed (template)
.env                → NOT committed (local dev)
.env.test           → committed (test env, no real secrets)
CI secrets          → stored in secrets manager / platform vault
Production secrets  → stored in deployment platform / vault
```

CI must never receive production secrets; use separate CI-scoped secrets.

## Automation Beyond CI

- **Dependency updates**: Dependabot/Renovate for `github-actions` and ecosystem manifests; group non-major updates to reduce PR noise.
- **Build Cop role**: one person keeps CI green; when the build breaks they fix or revert — not the author of the breaking change.
- **Branch protection**: require CI pass + ≥1 approval before merge; no force-pushes to main; auto-merge when all checks pass and approved.

## Feeding CI Failures Back to Agents

Copy the failure output and feed it to the agent with the specific error; agent fixes locally and re-pushes. Map failures:

```
Lint failure → run `lint --fix` and commit
Type error  → read the error location, fix the type
Test failure → follow debugging-and-error-recovery
Build error → check config and dependencies
```

## CI Optimization (when pipeline exceeds ~10 min)

In order of impact:
1. Cache dependencies (native setup-* cache keyed on lockfile; avoid generic `actions/cache`).
2. Run jobs in parallel (split lint, typecheck, test, build into separate jobs).
3. Only run what changed (path filters skip unrelated jobs, e.g. skip e2e for docs-only PRs).
4. Matrix builds (shard test suites across runners) — only when a real multi-target need exists.
5. Optimize the test suite (remove slow tests from the critical path; run on a schedule).
6. Larger/self-hosted runners for CPU-heavy builds.

## Quality Checklist

- All gates present (lint, types, tests, build, audit) and none disabled.
- Pipeline runs on every PR and push to main; failures block merge.
- CI results feed back into the development loop.
- Secrets in the secrets manager, never in code/config.
- Deployment has a rollback mechanism.
- Pipeline runs in reasonable time for the suite.
