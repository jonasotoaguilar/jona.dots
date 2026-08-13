# Test Generation, Assertions, and the Spec-driven Workflow

Every `playwright-cli` action prints the equivalent Playwright TypeScript. This file is the bridge between the CLI session and the test files you author or heal.

## Generated code is captured live

```bash
playwright-cli open https://example.com/login
playwright-cli snapshot
# e1 [textbox "Email"], e2 [textbox "Password"], e3 [button "Sign In"]

playwright-cli fill e1 "user@example.com"
# Ran Playwright code:
# await page.getByRole('textbox', { name: 'Email' }).fill('user@example.com');

playwright-cli fill e2 "password123"
# Ran Playwright code:
# await page.getByRole('textbox', { name: 'Password' }).fill('password123');

playwright-cli click e3
# Ran Playwright code:
# await page.getByRole('button', { name: 'Sign In' }).click();
```

The CLI emits role-based locators when possible. Prefer them. Drop the result straight into a test:

```ts
import { test, expect } from '@playwright/test';

test('login flow', async ({ page }) => {
  await page.goto('https://example.com/login');
  await page.getByRole('textbox', { name: 'Email' }).fill('user@example.com');
  await page.getByRole('textbox', { name: 'Password' }).fill('password123');
  await page.getByRole('button', { name: 'Sign In' }).click();

  await expect(page).toHaveURL(/.*dashboard/);
});
```

Generated code captures actions, not assertions. Add expectations manually.

## Generating stable locators and assertion inputs

```bash
playwright-cli --raw generate-locator e5
# getByRole('button', { name: 'Submit' })

playwright-cli --raw eval "el => el.textContent" e5     # expected text for toHaveText
playwright-cli --raw eval "el => el.value" e5           # expected value for toHaveValue / toBeEmpty
playwright-cli --raw snapshot                            # aria snapshot for toMatchAriaSnapshot
playwright-cli --raw snapshot e5                         # scoped to a region
```

When asserting text content, make sure the generated locator does not contain the text being asserted — `getByTestId` or `getByLabel` usually work better than text locators for `toHaveText`. If the locator is text-based, prefer `toBeVisible()`.

The captured aria snapshot does not have to be exhaustive. Only capture what's necessary for the assertion. Use regular expressions for unstable values.

## Assertion recipes

```ts
await expect(page.getByRole('alert', { name: 'Success' })).toBeVisible();
await expect(page.getByTestId('main-header')).toHaveText('Welcome, user');
await expect(page.getByRole('textbox', { name: 'Email' })).toHaveValue('user@example.com');
await expect(page.getByRole('checkbox', { name: 'Enable notifications' })).toBeChecked();

// Match a region of the page
await expect(page).toMatchAriaSnapshot(`
  - heading "Welcome, user"
  - link /\\d+ new messages?/
  - button "Sign out"
`);

await expect(page.getByRole('navigation')).toMatchAriaSnapshot(`
  - link "Home"
  - link /\\d+ new messages?/
  - link "Profile"
`);
```

## Running and debugging tests

Run with the test command (or a project script). Set `PLAYWRIGHT_HTML_OPEN=never` to skip the HTML report popup.

```bash
PLAYWRIGHT_HTML_OPEN=never npx playwright test
PLAYWRIGHT_HTML_OPEN=never npm run special-test-command
```

To debug a failing test, run it with `--debug=cli`. The test pauses at the start and prints "Debugging Instructions" containing a session name. Run the command in the background, wait for the instructions, then attach:

```bash
# Background
PLAYWRIGHT_HTML_OPEN=never npx playwright test --debug=cli
# ...wait for "Debugging Instructions" with session "tw-abcdef"...

playwright-cli attach tw-abcdef
playwright-cli resume           # let the seed run
```

Every `playwright-cli` action while attached prints Playwright TypeScript you can paste back into the test. Stop the background process when done.

## Spec-driven testing (plan → generate → heal)

Three independent sections that share the same mechanic: run the seed in `--debug=cli`, then `playwright-cli attach tw-XXXX`.

### 1. Planning — write a spec file

Verify Playwright is installed first:

```bash
test -f playwright.config.ts || test -f playwright.config.js
npx --no-install playwright --version
# If absent: npm init playwright@latest
```

A **seed test** lands the page in the state every scenario starts from (navigation, login, feature flags). Without one, scenarios have no common starting point.

```ts
// tests/seed.spec.ts
import { test } from '@playwright/test';

test('seed', async ({ page }) => {
  await page.goto('https://example.com/');
});
```

Prefer extending a fixture so every scenario reuses the start state:

```ts
// tests/fixtures.ts
import { test as baseTest } from '@playwright/test';
export { expect } from '@playwright/test';

export const test = baseTest.extend({
  page: async ({ page }, use) => {
    await page.goto('https://example.com/');
    await use(page);
  },
});

// tests/seed.spec.ts
import { test } from './fixtures';
test('seed', async ({ page }) => { /* fixture already navigated */ });
```

Launch the seed under debug, attach, and explore:

```bash
PLAYWRIGHT_HTML_OPEN=never npx playwright test tests/seed.spec.ts --debug=cli
playwright-cli attach tw-XXXX
playwright-cli resume
playwright-cli snapshot
playwright-cli click e5
playwright-cli eval "location.href"
playwright-cli show --annotate
```

Always go through the seed test, not the bare URL — that way you capture any custom setup the test does. Stop the background process when done.

Map out interactive surfaces, primary journeys end-to-end, edge cases (empty states, validation, long input, boundaries), persistence (reload, storage, URL fragments), and navigation (which controls change the URL, back/forward).

Write the spec to `specs/<feature>.plan.md`:

```markdown
# <Feature> Test Plan

## Application Overview

<One paragraph: what the feature does and why it matters.>

## Test Scenarios

### 1. <Group Name>

**Seed:** `tests/seed.spec.ts`

#### 1.1. <kebab-case-scenario-name>

**File:** `tests/<group>/<kebab-case-scenario-name>.spec.ts`

**Steps:**
  1. <Concrete user step>
    - expect: <observable outcome>
    - expect: <another observable outcome>
  2. <Next step>
    - expect: <outcome>

#### 1.2. <next-scenario>
...

### 2. <Next Group>

**Seed:** `tests/seed.spec.ts`
...
```

Rules:

- Each scenario is independent and starts from the seed's fresh state — never chain.
- Scenario names are kebab-case and match the test file name (`should-add-single-todo` → `should-add-single-todo.spec.ts`).
- Cover happy path, edge cases, validation, negative flows, persistence.
- Write steps at the user level, not the API level.
- `- expect:` bullets become assertions during generation.

### 2. Generate — turn a spec into test files

Per scenario, restart the seed and walk the spec:

```bash
PLAYWRIGHT_HTML_OPEN=never npx playwright test <seed> --debug=cli   # background
playwright-cli attach tw-XXXX
playwright-cli resume
```

Treat the spec as the plan and the live app as the source of truth. If a step is vague, references a stale element, or contradicts the app, update the spec to match reality mid-generation — that is expected.

For each `- expect:` add an explicit `expect(...)`. For each step, prefix its actions with `// N. <step text>`.

Generated test shape:

```ts
// spec: specs/basic-operations.plan.md
// seed: tests/seed.spec.ts
import { test, expect } from './fixtures';   // or '@playwright/test' if no fixtures

test.describe('Singing in and out', () => {
  test('should sign in', async ({ page }) => {
    // 1. Navigate to the application
    // (handled by the seed fixture)

    // 2. Type 'John Doe' into the username field
    await page.getByRole('textbox', { name: 'username' }).fill('John Doe');

    // 3. Type password
    await page.getByRole('textbox', { name: 'password' }).fill('TestPassword');

    // 4. Press Enter to submit
    await page.getByRole('textbox', { name: 'password' }).press('Enter');

    await expect(page.getByRole('heading')).toContainText('Welcome, John Doe!');
  });
});
```

Rules:

- **One test per file.** File path, `describe`, and `test` names come verbatim from the spec (minus the ordinal).
- Prefix each step with a `// N. <step text>` comment before its actions.
- `describe` group name verbatim from the spec (no `1.` ordinal).
- Import from `./fixtures` if the project has one; otherwise `@playwright/test`.
- Close the CLI session and stop the background test before moving to the next scenario.

Multiple scenarios: loop per scenario, restarting the seed. Safe to parallelise because each test run gets a unique session name; make sure each run is stopped.

After generation, run once:

```bash
PLAYWRIGHT_HTML_OPEN=never npx playwright test tests/<group>/<scenario>.spec.ts
```

Any failure goes to Heal.

### 3. Heal — diagnose, fix, reconcile

Find failing tests:

```bash
PLAYWRIGHT_HTML_OPEN=never npx playwright test
```

Process one `<file>:<line>` at a time. A single CLI session is shared, so do not parallelise.

Debug one failure:

```bash
PLAYWRIGHT_HTML_OPEN=never npx playwright test tests/<group>/<scenario>.spec.ts:<line> --debug=cli
playwright-cli attach tw-XXXX
```

The test is paused at the start. Step to just before the failure, then diagnose:

```bash
playwright-cli snapshot                # did the element change / move / rename?
playwright-cli console                 # app-side errors?
playwright-cli requests                # failed request? wrong payload?
playwright-cli show --annotate         # ask the user to point somewhere
```

Common causes: selector drift, new wrapper element, label / ARIA rename, timing (transition, async load), assertion text updated in the app, test data leaking between runs.

Rehearse the corrected interaction with `playwright-cli` — paste the generated code back into the test. Edit the test (locator, assertion, step order, or inputs), stop the background debug run, and rerun the single test.

Never fix flakiness with sleeps, skipped hooks, or `networkidle`.

Reconcile with the spec:

- Fix was purely technical (locator drift, assertion shape) and the spec's user-level behaviour still matches → leave the spec alone.
- Fix changed user-visible steps, inputs, order, or expected outcomes that the spec describes → update the spec to match reality. Keep scenario id and file path stable; only the step / expect lines change.
- Unclear whether the app change is intentional (spec is stale) or a regression (test was right, app is wrong) → **stop and ask the user**. Provide the scenario id, the spec lines that no longer match, and the observed app behaviour (quote a snapshot excerpt or a concrete outcome).

If a test must be skipped because the app is intentionally broken and the user confirmed it, mark `test.fixme(...)` with a comment pointing at the user's decision or issue link. Never skip silently.

## Locator priority, in practice

The CLI defaults to role-based locators. When you have to hand-write one:

1. `page.getByRole('button', { name: 'Submit' })` — primary; matches accessibility tree.
2. `page.getByLabel('Email')` — form controls with an associated label.
3. `page.getByText('Welcome')` — static, non-interactive content only.
4. `page.getByTestId('date-picker')` — last resort; add `data-testid` to the app when needed.

Avoid CSS (`page.locator('.btn-primary')`) and XPath unless nothing else works. They break on copy, refactor, and CSS-in-JS renaming.

## Page objects and helpers

Inspect the repo first. If the project already has page objects or helper modules, reuse them. If you are writing from scratch, prefer plain `test(...)` calls in flat `*.spec.ts` files for the first round; introduce a `BasePage` and per-page objects only after at least two specs share genuine reuse, and only the methods that are actually repeated. Do not invent a structure the project does not have.
