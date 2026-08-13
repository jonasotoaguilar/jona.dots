# Workflow Patterns

Reference rules for CI and CD workflows. Deploy, release, scheduled, security-scan, and Docker patterns are generic — generate them inline from the project's stack.

## Structural Rules (every workflow)

- `on:` uses the most specific trigger (avoid `push` on every branch).
- `permissions:` declared at workflow level with minimum scope; never rely on org defaults.
- `concurrency.group` with `cancel-in-progress: true` for CI/PR workflows; group by PR number for PR-bound workflows, by `github.workflow + github.ref` for branch-bound runs.
- `timeout-minutes` set on every job.
- Every `uses:` pinned to a floating major tag (`@vN`) — never `@main` / `@latest` / a narrow tag (see pin policy).
- Never interpolate `github.event.*` attacker-controlled values into a `run:` body — pass through `env:` (see injection).
- No matrices or reusable workflows for simple repos; add them only for a real multi-target/multi-service need.

## Action Pinning Policy

| Pin style               | Immutability         | Auto-updates                                            | Recommended?                                 |
| ----------------------- | -------------------- | ------------------------------------------------------- | -------------------------------------------- |
| `@vN` (major)           | mutable within major | yes — dependency-update tooling covers security patches | **YES** (this skill's policy)                |
| Commit SHA (`@<40hex>`) | fully immutable      | no — manual bumps                                       | stronger security, bypasses auto-update flow |
| `@vN.M` / `@vN.M.P`     | partial              | partial                                                 | avoid — too narrow, drifts                   |
| `@main` / `@latest`     | mutable + breaking   | yes                                                     | NEVER in production                          |

**Tradeoff (explicit with the user):** major tags are mutable; platform hardening guidance is to pin a full commit SHA. This skill chooses major pinning for updateability and requires dependency-update automation (`github-actions`).

### Resolving the latest stable major (at execution time, never frozen)

```bash
LATEST=$(gh release list --repo <owner>/<repo> --limit 5 \
  --json tagName,isPrerelease,isDraft \
  --jq '[.[] | select(.isPrerelease == false and .isDraft == false)][0].tagName')
MAJOR=$(echo "$LATEST" | sed -E 's/^v([0-9]+)\..*/v\1/')
echo "$MAJOR"   # → e.g. v7
```

Apply the resulting tag to every `uses:` line. Filter `--limit 5` defensively in case the most recent non-prerelease tag is a backport on an older major.

## Script Injection Prevention

Any value derived from a PR title, issue body, comment, or other attacker-controllable field must not be interpolated into a `run:` shell; pass it through `env:` so it lands as a process environment variable, never as script source.

```yaml
# WRONG — script injection vector
- run: echo "${{ github.event.issue.title }}"

# CORRECT — pass through env:
- run: echo "$ISSUE_TITLE"
  env:
    ISSUE_TITLE: ${{ github.event.issue.title }}
```

Inside `actions/github-script`, treat `context.payload.*` as untrusted strings; assign to a `const` and use as method arguments — never splice into template literals that become script source.

## CI — Stack-Adaptive Generation Contract

CI workflows are **generated** from evidence, not from a fixed template asset.

1. **Stack from evidence, not assumptions.** Detect from lockfiles/manifests (see table); never pin a runtime the repo does not pin.
2. **Use the repo's own test command.** Resolve from `package.json` scripts, Makefile targets, tox/pytest config, or equivalent; none resolvable → fail with `::error::` naming the missing source, never silently pass.
3. **Run tests and collect coverage on CI.** Native coverage tool per stack. No coverage configured → emit what exists or fail with a clear message; never claim coverage ran when nothing was collected.
4. **Use the stack's native dependency cache** keyed on the lockfile, not a generic `actions/cache` key.
5. **Always include** the structural rules: `permissions`, `concurrency`, `timeout-minutes`, major pins, no script injection.
6. **Upload the coverage artifact** only when a coverage file exists, with `if: always()`; do not assume a third-party coverage service (requires a secret and a user decision).
7. **No matrices or reusable workflows** unless the repo has a multi-target test matrix.

### Stack detection

| Signal (any one)                      | Ecosystem | Setup action                                               | Test command source                    | Native coverage tool                     |
| ------------------------------------- | --------- | ---------------------------------------------------------- | -------------------------------------- | ---------------------------------------- |
| `package-lock.json`                   | npm       | `actions/setup-node@vN`                                    | `npm test` script                      | `nyc` / `c8` / `vitest --coverage`       |
| `pnpm-lock.yaml`                      | pnpm      | `pnpm/action-setup@vN` + `setup-node@vN` (`cache: pnpm`)   | `pnpm test` script                     | `vitest --coverage` / `c8`               |
| `yarn.lock` (v1)                      | yarn      | `actions/setup-node@vN` (`cache: yarn`)                    | `yarn test` script                     | `nyc` / `jest --coverage`                |
| `bun.lockb` / `bun.lock`              | bun       | `oven-sh/setup-bun@vN`                                     | `bun test` script                      | `bun test --coverage`                    |
| `go.mod`                              | Go        | `actions/setup-go@vN` (`cache: true`)                      | `go test ./...`                        | `go test -coverprofile=...`              |
| `requirements.txt` / `pyproject.toml` | pip       | `actions/setup-python@vN` (`cache: pip`)                   | project-defined (`tox`, pytest config) | `coverage` + `pytest-cov`                |
| `Cargo.toml`                          | Rust      | `dtolnay/rust-toolchain@stable` + `Swatinem/rust-cache@v2` | `cargo test`                           | `cargo llvm-cov` / `grcov` / `tarpaulin` |
| `Gemfile`                             | Ruby      | `ruby/setup-ruby@v1` (`bundler-cache: true`)               | `bundle exec rake test` or `rspec`     | `simplecov`                              |
| `pom.xml` / `build.gradle*`           | Java      | `actions/setup-java@vN` (`temurin`)                        | project-defined                        | `jacoco`                                 |
| `*.csproj` / `*.sln`                  | .NET      | `actions/setup-dotnet@vN`                                  | `dotnet test`                          | `coverlet`                               |
| `composer.json`                       | PHP       | `shivammathur/setup-php@vN`                                | `composer test`                        | `pcov` / `xdebug`                        |

Multiple signals → pick the strongest (most specific); ask only when genuinely ambiguous (e.g. `package.json` + `go.mod` polyglot).

### Coverage — explicit behavior, fail-closed

| State                                                      | Behavior                                                                                               |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| Coverage tool installed by project deps, known report file | Run it, upload as `coverage-<job>`, do not gate the build on thresholds                                |
| Tool available but not enabled                             | `--coverage` only if the runner can find the binary; absent → warn and skip artifact, do NOT fail      |
| No configuration and no tool chosen                        | **Fail the workflow** with `::error::` naming the missing decision — never silently claim coverage ran |

## File Naming

| Purpose                                   | Filename                                                  |
| ----------------------------------------- | --------------------------------------------------------- |
| Code quality                              | `ci.yml`                                                  |
| PR validation                             | owned here (canonical `../assets/workflows/pr-check.yml`) |
| Deployment                                | `deploy.yml` or `deploy-{env}.yml`                        |
| Release                                   | `release.yml`                                             |
| Scheduled                                 | `scheduled-{task}.yml`                                    |
| Security                                  | `security.yml`                                            |
| Docker                                    | `docker.yml`                                              |
| Architecture checks (boundaries declared) | step in `ci.yml` or dedicated `architecture.yml`          |

## Architecture Checks (only when boundaries are declared)

Added ONLY when the repo declares boundaries/dependency rules — detected from `ARCHITECTURE.md`, `DESIGN.md`, ADRs, `CONTRIBUTING.md`, or existing dependency config; never invent architecture policy. No declaration → report not applicable, add nothing.

When declared, add one lightweight fail-fast step/job: import-cycle detection; forbidden imports (declared dependency direction); dependency-direction checks (high-level modules far from IO do not depend on low-level modules near IO); adapter-boundary checks (adapters conform to the policy-owned interface). Tool choice follows the stack's existing ecosystem (dependency-cruiser, import-linter, `go list`-based, cargo-based); reuse what the repo uses, never install a new tool. Keep it cheap: one step/job, fail-fast, no coverage gating, no matrix.
