---
name: playwright
description: "Trigger: configured Playwright: playwright.config.*, @playwright/test, playwright-cli, E2E author/heal/runner certification, page objects, selectors. Not generic browser diagnosis."
license: Apache-2.0
metadata:
  author: jonasotoaguilar
  version: "2.5"
allowed-tools:
  - Bash(playwright-cli:*)
  - Bash(npx:*)
  - Bash(npm:*)
  - Bash(pnpm:*)
  - Bash(yarn:*)
  - Bash(bun:*)
---

## Activation Contract

Activate for one mode: **CLI review** (drive a UI), **Author** (create / update E2E tests; CLI explore first if reachable), or **Heal** (run, debug, fix existing tests). Skip static review or non-Playwright frameworks.

**Not every UI change needs E2E.** E2E is for critical business flows, full journeys, cross-page flows, and browser integration that lower layers (unit/integration) cannot demonstrate — and only when E2E capabilities are available. Pick the highest test layer that fits; degrade E2E → integration → unit when the tool is missing.

**Selection boundaries (route, never load recursively):**

- Playwright = configured Playwright E2E author/heal/runner certification. CLI exploration is complementary, not broad DevTools performance/network/a11y ownership.
- Deep ad-hoc DevTools diagnostics (console/network/DOM/performance/a11y on a live page) → `browser-testing-with-devtools`.
- Site-wide sampled Lighthouse audits → `unlighthouse`.
- Task-oriented browser automation (navigate, fill, click, scrape user-authorized data, screenshots, repetitive web tasks; Electron/Slack/ cloud on explicit request) → `agent-browser` (execution adapter — never certifies E2E).

## Hard Rules

- Stay inside the chosen mode. One behaviour per test, independent (fresh page, storage, deterministic setup). Diagnostics on failure.
- Locator priority: `getByRole` → `getByLabel` → `getByText` (static) → `getByTestId`. Avoid CSS / XPath. Web-first assertions; auto-wait mandatory. No `waitForTimeout`, `setTimeout`, `waitForLoadState('networkidle')`, or asserts on manual reads.
- Inspect repo first; follow the convention. Never fix flakiness with sleeps, skipped hooks, or `networkidle`. `test.fixme(...)` for intentional skips; env-gate external tests.
- **No silent installs.** Never run `npm init playwright@latest` (or any setup) on your own. If Playwright or the CLI is missing, you may offer setup, but never execute it silently — block and report the capability gap for an explicit decision.
- **"E2E runs certify; CLI review investigates."** Existing E2E tests run through the runner. The CLI is for exploration, diagnosis, generation, or a complementary runtime harness — it works against a reachable UI even without repo config, but it never certifies scenarios and never declares PASS.

## Mode Routing

CLI review = drive the UI. Author = create or update tests (CLI first if reachable; code-only otherwise, mark every assumption). Heal = run, debug, fix.

## Decision Gates

| Situation                                   | Action                                                                                      |
| ------------------------------------------- | ------------------------------------------------------------------------------------------- |
| Drive/inspect a reachable UI                | CLI review mode                                                                             |
| Create/update E2E tests for a critical flow | Author mode (CLI explore first if reachable)                                                |
| Existing test failing/flaky                 | Heal mode                                                                                   |
| Static review or non-Playwright framework   | Do not activate                                                                             |
| Test layer decision (E2E vs lower)          | Pick the highest layer that fits; degrade E2E → integration → unit when the tool is missing |
| Playwright or CLI missing                   | Block and report the capability gap; never install silently                                 |

## Execution Steps

Use the lockfile's pm: `pnpm-lock.yaml` → `pnpm`, `yarn.lock` → `yarn`, `bun.lockb` → `bun`, else `npx`. `npx` in the examples stands in.

### CLI review

`playwright-cli open <url>` (or `attach --cdp=...` / `--extension`) → `snapshot` (or `snapshot eN`) → drive with `playwright-cli {click|fill|press|hover|select|drag|upload|eval|run-code}`. Diagnostics, `--raw snapshot`, and teardown commands in `references/cli-commands.md`.

### Author

1. Read config + existing tests, fixtures, page objects, runner script. Reuse before creating. Verify Playwright is installed; if missing, do NOT install silently — block/report the capability gap per Hard Rules.
2. Run the seed under debug, attach, walk the flow with `playwright-cli`. Each action prints Playwright TS — keep it. Convert `- expect:` into `expect(...)` (see references). One test per file. Failure → Heal.

### Heal

1. Collect failing `<file>:<line>` with the project's test command. Re-run under debug, attach, step to the failure:
   ```bash
   PLAYWRIGHT_HTML_OPEN=never npx playwright test <file>:<line> --debug=cli
   playwright-cli attach tw-XXXX
   ```
2. Diagnose with `playwright-cli {snapshot|console|requests|show --annotate}`. Edit, rerun, reconcile. Ask if intent is unclear.

## Output Contract

- **CLI review:** runtime evidence — actions driven, snapshots/diagnostics captured, findings with URLs/steps. Exploratory only; never a PASS and never a test certification.
- **Author:** files created/updated (test paths), RED→GREEN evidence with the exact runner command and result, assumptions marked.
- **Heal:** failing `<file>:<line>`, root cause, exact change applied, rerun result.
- Always include the actual skill-resolution status and the paths of any reference files loaded (never claim injection unconditionally).

## References

- `references/cli-commands.md` — commands.
- `references/cli-advanced.md` — `run-code`, mocking, tracing, video, storage, sessions.
- `references/cli-test-generation.md` — assertions, generated code, debug attach, spec workflow.
