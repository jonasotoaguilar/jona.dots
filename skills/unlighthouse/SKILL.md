---
name: unlighthouse
description: "Trigger: SEO review/audit, Lighthouse site-wide or one-page scoring, performance/accessibility/SEO/best-practices evidence, CI budget checks, static HTML reports. Activate on audit/review requests — no explicit 'unlighthouse' mention needed. Not debugging or E2E testing."
license: Apache-2.0
metadata:
  author: jonasotoaguilar
  version: "1.4"
allowed-tools: Bash(unlighthouse *), Bash(unlighthouse-ci *), Bash(npx --yes unlighthouse *), Bash(npx --yes unlighthouse-ci *)
---

## Activation Contract

Load for site-wide audits of a web/UI application: measure performance, accessibility, SEO, and best practices across its pages. Activate in one mode: **scan** (audit the whole site), **single** (one-page Lighthouse scoring only — never interactive debugging), **verify** (threshold gate, typically CI), or **report** (synthesize evidence). Produces measured runtime evidence only; design authority stays with the UI design contract, implementation critique with `impeccable`, E2E certification with `playwright`, spec verification with `sdd-verify`.

**Selection boundaries (route, never load recursively):**

- Unlighthouse = site-wide sampled Lighthouse audit; not UI debugging and not E2E.
- One-page interactive debugging (console/network/DOM/a11y on a live page) → `browser-testing-with-devtools`.
- User journeys / E2E certification → `playwright`.
- Task-oriented browser automation (navigate, fill, click, scrape user-authorized data, screenshots, repetitive web tasks; Electron/Slack/ cloud on explicit request) → `agent-browser` (execution adapter — never produces Lighthouse scores).

## Hard Rules

- **Reachability first**: confirm the target URL returns HTTP 2xx/3xx before scanning. Unreachable → report and stop; never emit evidence from a failed run.
- **Runner**: use local `unlighthouse`/`unlighthouse-ci` if available; otherwise `npx --yes`.
- **Explicit scope**: define routes/sitemap/URLs before running; never claim coverage beyond what was scanned. Record the scanned URL list or discovery source.
- **Auth/SPA**: login-gated pages and JS-rendered SPAs need explicit Unlighthouse setup (browser profile/auth storage, route config). If not configured, report the coverage limitation; never claim pages that could not be reached were audited.
- **Sampling awareness**: Unlighthouse discovers and samples pages dynamically; similar pages can be omitted by design. Report the scanned page count and note coverage is sampled, not exhaustive.
- **Deterministic output**: persist stable artifacts — the static HTML report built with `--build-static` (output in `.unlighthouse/`) plus per-page LHR JSON. JSON/CSV reporter formats are experimental and non-authoritative; never use them as primary evidence or CI gate.
- **CLI/CI route only**: framework integrations are deprecated. Scores are lab-based (Lighthouse): never field/CrUX evidence and never E2E certification.

## Decision Gates

| Situation                                                 | Mode / command                                                                                                                                                         |
| --------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Audit the whole site, discover pages                      | scan: `unlighthouse --site <url>` (or `npx --yes` if not local)                                                                                                        |
| Score exactly one page (Lighthouse only, never debugging) | single: `unlighthouse --site <url> --urls <path>` (or equivalent include config) with an explicit URL list — report the exact command/config, never a special CLI mode |
| Gate scores against a threshold (CI)                      | verify: `unlighthouse-ci --site <url> --budget <1-100>` (or `npx --yes` if not local)                                                                                  |
| Summarize evidence into a report                          | report: synthesize the artifacts below                                                                                                                                 |
| One-page interactive debugging needed                     | route to `browser-testing-with-devtools`                                                                                                                               |
| Target unreachable or CLI missing                         | stop; report the gap                                                                                                                                                   |

## Execution Steps

1. Confirm the mode and target URL; check reachability (Hard Rules). Runner: local if available, else `npx --yes`.
2. Define scope: routes/sitemap/URLs plus any required auth/SPA setup.
3. Run the mode's command with the chosen runner: scan `unlighthouse --site <url>`; single — `--urls` (or include config) with the exact URL list and command recorded; verify — `unlighthouse-ci --site <url> --budget <1-100>` with the gate result recorded; static report via `--build-static`.
4. Collect stable artifacts: static HTML report (`.unlighthouse/`, `--build-static`) and optional LHR JSON; record scanned page count and scores per category (performance, accessibility, SEO, best-practices).
5. Report limitations (auth/SPA, dynamic sampling, lab-based scores) and stop.

## Output Contract

Return: target URL and scope; mode used with the exact command/config and runner (project-local or `npx --yes`); scanned page count; per-page/category scores; stable artifact paths (static HTML report in `.unlighthouse/`; LHR JSON optional); budget result for `verify`; limitations (auth/SPA, sampling, lab-only); actual skill-resolution status plus any reference files loaded (never claim injection unconditionally).

## References

None. Self-contained; no supporting files.
