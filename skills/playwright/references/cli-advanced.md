# `playwright-cli` Advanced Patterns

Patterns that go beyond the basic command surface. The CLI is a thin wrapper over the Playwright API; anything it does not cover explicitly can be done with `run-code`.

## `run-code` basics

`run-code` evaluates a single async function expression in a `playwright-cli` host. `import` / `export` / `require` are not supported.

```bash
playwright-cli run-code "async page => { /* Playwright code */ }"
playwright-cli run-code --filename=./my-script.js
```

## Geolocation

```bash
playwright-cli run-code "async page => {
  await page.context().grantPermissions(['geolocation']);
  await page.context().setGeolocation({ latitude: 37.7749, longitude: -122.4194 });
}"

playwright-cli run-code "async page => {
  await page.context().clearPermissions();
}"
```

## Permissions

```bash
playwright-cli run-code "async page => {
  await page.context().grantPermissions([
    'geolocation', 'notifications', 'camera', 'microphone'
  ]);
}"

# Per-origin
playwright-cli run-code "async page => {
  await page.context().grantPermissions(['clipboard-read'], { origin: 'https://example.com' });
}"
```

## Media emulation

```bash
playwright-cli run-code "async page => { await page.emulateMedia({ colorScheme: 'dark' }); }"
playwright-cli run-code "async page => { await page.emulateMedia({ colorScheme: 'light' }); }"
playwright-cli run-code "async page => { await page.emulateMedia({ reducedMotion: 'reduce' }); }"
playwright-cli run-code "async page => { await page.emulateMedia({ media: 'print' }); }"
```

## Wait strategies

Prefer the strategies in this order: `expect(locator).toBeVisible()`, locator `waitFor({ state: 'visible'/'hidden' })`, `page.waitForFunction(...)`. Never use `waitForLoadState('networkidle')` or arbitrary timeouts.

```bash
playwright-cli run-code "async page => {
  await page.locator('.loading').waitFor({ state: 'hidden' });
}"

playwright-cli run-code "async page => {
  await page.waitForFunction(() => window.appReady === true);
}"

playwright-cli run-code "async page => {
  await page.locator('.result').waitFor({ timeout: 10000 });
}"
```

## Frames and iframes

```bash
playwright-cli run-code "async page => {
  const frame = page.locator('iframe#my-iframe').contentFrame();
  await frame.locator('button').click();
}"

playwright-cli run-code "async page => {
  return page.frames().map(f => f.url());
}"
```

## File downloads

```bash
playwright-cli run-code "async page => {
  const downloadPromise = page.waitForEvent('download');
  await page.getByRole('link', { name: 'Download' }).click();
  const download = await downloadPromise;
  await download.saveAs('./downloaded-file.pdf');
  return download.suggestedFilename();
}"
```

## Clipboard

```bash
playwright-cli run-code "async page => {
  await page.context().grantPermissions(['clipboard-read']);
  return await page.evaluate(() => navigator.clipboard.readText());
}"

playwright-cli run-code "async page => {
  await page.evaluate(text => navigator.clipboard.writeText(text), 'Hello clipboard!');
}"
```

## Page information

```bash
playwright-cli run-code "async page => { return await page.title(); }"
playwright-cli run-code "async page => { return page.url(); }"
playwright-cli run-code "async page => { return await page.content(); }"
playwright-cli run-code "async page => { return page.viewportSize(); }"
```

## JavaScript execution

```bash
playwright-cli run-code "async page => {
  return await page.evaluate(() => ({
    userAgent: navigator.userAgent,
    language: navigator.language,
    cookiesEnabled: navigator.cookieEnabled
  }));
}"

# Pass arguments
playwright-cli run-code "async page => {
  return await page.evaluate(m => document.querySelectorAll('li').length * m, 5);
}"
```

## Error handling inside `run-code`

```bash
playwright-cli run-code "async page => {
  try {
    await page.getByRole('button', { name: 'Submit' }).click({ timeout: 1000 });
    return 'clicked';
  } catch (e) {
    return 'element not found';
  }
}"
```

## Complex workflows

```bash
playwright-cli run-code "async page => {
  await page.goto('https://example.com/login');
  await page.getByRole('textbox', { name: 'Email' }).fill('user@example.com');
  await page.getByRole('textbox', { name: 'Password' }).fill('secret');
  await page.getByRole('button', { name: 'Sign in' }).click();
  await page.waitForURL('**/dashboard');
  await page.context().storageState({ path: 'auth.json' });
  return 'Login successful';
}"
```

## Request mocking

Basic mocking uses the `route` command. Use `run-code` for anything conditional.

```bash
# Static
playwright-cli route "**/api/users" --body='[{"id":1,"name":"Alice"}]' --content-type=application/json
playwright-cli route "**/*.jpg" --status=404
playwright-cli route "**/*" --remove-header=cookie,authorization
playwright-cli route-list
playwright-cli unroute "**/*.jpg"
playwright-cli unroute                          # clear all
```

URL patterns: `**/api/users`, `**/api/*/details`, `**/*.{png,jpg,jpeg}`, `**/search?q=*`.

Conditional response based on request body:

```bash
playwright-cli run-code "async page => {
  await page.route('**/api/login', route => {
    const body = route.request().postDataJSON();
    if (body.username === 'admin') {
      route.fulfill({ body: JSON.stringify({ token: 'mock-token' }) });
    } else {
      route.fulfill({ status: 401, body: JSON.stringify({ error: 'Invalid' }) });
    }
  });
}"
```

Modify a real response:

```bash
playwright-cli run-code "async page => {
  await page.route('**/api/user', async route => {
    const response = await route.fetch();
    const json = await response.json();
    json.isPremium = true;
    await route.fulfill({ response, json });
  });
}"
```

Simulate network failures:

```bash
playwright-cli run-code "async page => {
  await page.route('**/api/offline', route => route.abort('internetdisconnected'));
}"
# Options: connectionrefused | timedout | connectionreset | internetdisconnected
```

Delayed response:

```bash
playwright-cli run-code "async page => {
  await page.route('**/api/slow', async route => {
    await new Promise(r => setTimeout(r, 3000));
    route.fulfill({ body: JSON.stringify({ data: 'loaded' }) });
  });
}"
```

## Tracing

`tracing-start` / `tracing-stop` capture DOM snapshots, screenshots, network, console, and timing for every action. Trace files (`trace-*.trace`, `trace-*.network`, `resources/`) live in `traces/`.

```bash
playwright-cli tracing-start
playwright-cli open https://app.example.com
playwright-cli click e5
playwright-cli tracing-stop
```

Open the trace in the Trace Viewer. Clean up old traces:

```bash
find .playwright-cli/traces -mtime +7 -delete
```

| Feature | Trace | Video | Screenshot |
| --- | --- | --- | --- |
| Format | `.trace` | `.webm` | `.png` / `.jpeg` |
| DOM inspection | Yes | No | No |
| Network details | Yes | No | No |
| Step-by-step replay | Yes | Continuous | Single frame |
| File size | Medium | Large | Small |
| Best for | Debugging | Demos | Quick capture |

## Video recording

```bash
playwright-cli open
playwright-cli video-start demo.webm
playwright-cli video-chapter "Getting Started" --description="Opening the homepage" --duration=2000
playwright-cli goto https://example.com
playwright-cli snapshot
playwright-cli click e1
playwright-cli video-chapter "Filling Form" --description="Entering test data" --duration=2000
playwright-cli fill e2 "test input"
playwright-cli video-stop
```

For polished hero / demo videos, use `run-code` with `page.screencast` so you can control pauses, type with `pressSequentially w/ delay`, and overlay chapter cards and highlights:

```js
async page => {
  await page.screencast.start({ path: 'video.webm', size: { width: 1280, height: 800 } });
  await page.goto('https://demo.playwright.dev/todomvc');

  await page.screencast.showChapter('Adding Todo Items', {
    description: 'We will add several items to the todo list.',
    duration: 2000,
  });

  await page.getByRole('textbox', { name: 'What needs to be done?' })
    .pressSequentially('Walk the dog', { delay: 60 });
  await page.getByRole('textbox', { name: 'What needs to be done?' }).press('Enter');
  await page.waitForTimeout(1000);

  const annotation = await page.screencast.showOverlay(`
    <div style="position: absolute; top: 8px; right: 8px;
      padding: 6px 12px; background: rgba(0,0,0,0.7);
      border-radius: 8px; font-size: 13px; color: white;">
      ✓ Item added successfully
    </div>
  `);

  await page.getByRole('textbox', { name: 'What needs to be done?' })
    .pressSequentially('Buy groceries', { delay: 60 });
  await page.getByRole('textbox', { name: 'What needs to be done?' }).press('Enter');
  await page.waitForTimeout(1500);

  await annotation.dispose();

  const bounds = await page.getByText('Walk the dog').boundingBox();
  await page.screencast.showOverlay(`
    <div style="position: absolute; top: ${bounds.y}px; left: ${bounds.x}px;
      width: ${bounds.width}px; height: ${bounds.height}px;
      border: 1px solid red;"></div>
  `, { duration: 2000 });

  await page.screencast.stop();
}
```

Overlays are `pointer-events: none` and do not block interactions.

| Method | Use case |
| --- | --- |
| `page.screencast.showChapter(title, { description?, duration?, styleSheet? })` | Full-screen chapter card with blurred backdrop |
| `page.screencast.showOverlay(html, { duration? })` | Sticky HTML overlay; pass `disposable.dispose()` to remove |
| `page.screencast.hideOverlays()` / `showOverlays()` | Toggle all overlays |

## Storage state (file format and auth reuse)

`state-save` writes a JSON file with cookies, origins, localStorage entries per origin.

```json
{
  "cookies": [
    {
      "name": "session_id",
      "value": "abc123",
      "domain": "example.com",
      "path": "/",
      "expires": 1735689600,
      "httpOnly": true,
      "secure": true,
      "sameSite": "Lax"
    }
  ],
  "origins": [
    {
      "origin": "https://example.com",
      "localStorage": [
        { "name": "theme", "value": "dark" },
        { "name": "user_id", "value": "12345" }
      ]
    }
  ]
}
```

Auth reuse pattern:

```bash
# Login once and persist
playwright-cli open https://app.example.com/login
playwright-cli snapshot
playwright-cli fill e1 "user@example.com"
playwright-cli fill e2 "password123"
playwright-cli click e3
playwright-cli state-save auth.json

# Reuse later
playwright-cli state-load auth.json
playwright-cli open https://app.example.com/dashboard
```

Security: never commit `auth-state` files; add `*.auth-state.json` to `.gitignore`; default sessions are in-memory (safer for sensitive data).

## IndexedDB

There is no first-class command. Use `run-code`:

```bash
playwright-cli run-code "async page => {
  return await page.evaluate(async () => indexedDB.databases());
}"

playwright-cli run-code "async page => {
  await page.evaluate(() => indexedDB.deleteDatabase('myDatabase'));
}"
```

## Element attribute inspection

The snapshot exposes structure and ARIA; for `id`, `class`, `data-*`, computed styles, etc. use `eval`:

```bash
playwright-cli eval "el => el.id" e7
playwright-cli eval "el => el.className" e7
playwright-cli eval "el => el.getAttribute('data-testid')" e7
playwright-cli eval "el => el.getAttribute('aria-label')" e7
playwright-cli eval "el => getComputedStyle(el).display" e7
```

## Session management

```bash
playwright-cli -s=auth open https://app.example.com/login
playwright-cli -s=public open https://example.com
playwright-cli -s=auth fill e1 "user@example.com"
playwright-cli -s=public snapshot
```

Each `-s` session has its own cookies, localStorage, sessionStorage, IndexedDB, cache, history, and tabs. `-s` defaults from `PLAYWRIGHT_CLI_SESSION` env.

```bash
playwright-cli list
playwright-cli close-all
playwright-cli kill-all                           # force-kill zombie daemons
playwright-cli -s=mysession delete-data
```

Persistent profile:

```bash
playwright-cli open https://example.com --persistent
playwright-cli open https://example.com --profile=/path/to/profile
```

Attach (external browser, leaves it running):

```bash
playwright-cli attach --cdp=chrome
playwright-cli attach --cdp=msedge
playwright-cli attach --cdp=http://localhost:9222
playwright-cli attach --extension
playwright-cli -s=msedge detach
```
