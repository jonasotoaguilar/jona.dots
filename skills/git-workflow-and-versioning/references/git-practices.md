# Git Practices Reference

Condensed operational guidance for branching, committing, debugging, release/versioning, and change summaries. Load per Decision Gate; not a substitute for the SKILL.md hard rules.

## Commit Discipline

- **Atomic commits**: one logical thing per commit; formatting separate from behavior, refactors separate from features. Commits are save points — commit after each test-passing increment.
- **Descriptive messages** explain the _why_: `<type>: <short description>` + body; types `feat`, `fix`, `refactor`, `test`, `docs`, `chore`; no AI attribution.
- PR size/splitting is owned by `chained-pr`; CI enforces the canonical 400 changed-line gate (see `ci-cd-and-automation`).

## Branching

- Create the root/tracker branch from the default branch; never work, commit, or push directly on `main`/`master`. Name by intent following `branch-pr`'s authoritative rule: `type/<description>`, lowercase, only `a-z0-9._-`.
- Under `chained-pr`, child branches may derive from their immediate parent branch.
- Keep branches short-lived; delete after merge. `chained-pr` owns stacked/feature topology; `merge-pr` owns merging.

## Save Point Pattern

Work in slices: after each test-passing increment, commit. If an agent goes off the rails, `git reset --hard HEAD` returns to the last known-good state — never lose more than one increment.

## Change Summaries

After any modification, return a structured summary: CHANGES MADE, THINGS I DIDN'T TOUCH (intentionally), POTENTIAL CONCERNS. This catches wrong assumptions early and shows scope discipline.

## Pre-Commit Hygiene

Before every commit: `git diff --staged`; scan for secrets (`password|secret|api_key|token`); run tests, lint, typecheck. Repository-local hook automation is owned by `ci-cd-and-automation`.

## Handling Generated Files

- Commit generated files only when the project expects them (lockfiles, committed migrations).
- Never commit build output (`dist/`, `.next/`), env files, or IDE-local config unless shared.

## Git Debugging

```bash
git bisect start && git bisect bad HEAD && git bisect good <known-good>  # find introducing commit
git log --oneline -20
git diff HEAD~5..HEAD -- src/
git blame src/services/task.ts
git log --grep="validation" --oneline
```

## Release & Versioning

A **version** is how consumers track change. Use SemVer — `MAJOR` breaking, `MINOR` additive, `PATCH` fix — and let the number match the code (a behavior change consumers relied on is a major whatever the diff size).

- **Tag the release; the tag is the source of truth**: `git tag -a v1.4.0 -m "Release 1.4.0"` and push it. Derive the version from the tag, not hand-edited files.
- **Changelog for humans**: curated, grouped by `Added / Changed / Fixed / Deprecated / Removed / Security`, newest on top, phrased around user impact. Write the entry in the same change, not reconstructed at release time. Breaking changes get a migration note + deprecation window (see `deprecation-and-migration`).
- **Versioned metadata travels with the change**: manifests carrying a version (e.g. `package.json`) are bumped in the same change that alters behavior, with SemVer — never a separate "version bump" commit later.
- Shipping the release (publication, rollout) is `shipping-and-launch`'s job; tag/PR mechanics for GitHub → `cli-gh`.

## Red Flags

Large uncommitted changes accumulating; messages like "fix"/"update"/"misc"; formatting mixed with behavior; no `.gitignore`; committing `node_modules`/`.env`/build artifacts; long-lived divergent branches; force-pushing shared branches; breaking change under a minor/patch bump; release with no tag or version hand-edited out of sync; changelog that's a dumped commit log; metadata version not bumped in the same change as the behavior change.
