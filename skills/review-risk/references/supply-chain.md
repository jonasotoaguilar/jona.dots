# Supply Chain Detection Reference

Signal-triggered checks for the security lens. Load when the change modifies dependency manifests/lockfiles, adds dependencies, or touches CI/registry config. Report only with confirmed impact within the reviewed scope.

## Lens rules (non-negotiable)

- **Reachability, not raw severity.** Audit findings are not findings by themselves: report only when the changed code makes a vulnerable path reachable, or the change itself pins a vulnerable/unsafe version. Severity without reachability context is not evidence.
- **This lens never runs audits or scans** (`npm audit`, `pip-audit`, equivalents), never applies remediation, and never blocks on raw audit output. Remediation/upgrade belongs to the implementation phase.

## Reportable patterns

- **Unpinned/floating dependencies introduced by the change:** ranges (`^`, `~`, `>=`, `*`, `latest`) in manifests where the repo pins elsewhere; lockfile missing, not committed, or in `.gitignore` when the change adds dependencies.
- **Dependency confusion:** internal-only package names resolvable from a public registry (public `index-url`/`extra-index-url` before the internal one, unscoped npm names with an internal registry); or a newly added dependency whose name matches a known public package the org could be impersonated with.
- **Typosquatting-shaped new dependencies:** names one character off from popular packages (omission, swap, doubling, homoglyph, suffix padding).
- **Registry credentials committed:** `_authToken`/password literals in `.npmrc`/`.pypirc`/`pip.conf`/`bunfig.toml` introduced by the change.
- **Untrusted code execution in the change's install path:** `preinstall`/`postinstall`/`prepare` scripts fetching or executing remote content, obfuscated code, env exfiltration, reverse shells, or miners in newly added package code within the reviewed scope.
- **Unpinned CI actions added by the change** (`uses: ...@main|@latest|@master` without a pinned SHA) or secrets as literals in workflow `env:` — pipeline mechanics beyond these two signals belong to `ci-cd-and-automation`.

## Not findings

- Presence of lockfiles, integrity hashes (`--require-hashes`, `npm ci`), signature verification, vendoring choices, or missing SBOMs — absence is policy, not a candidate-caused defect, unless the change actively regresses an existing practice.

## Evidence gate

- Confirm the dependency/config change is introduced/activated/worsened by the candidate.
- Final severity comes from the Output Contract in SKILL.md, never from this reference.
