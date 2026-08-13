# `playwright-cli` Command Surface

Quick reference for every command. Commands take refs (e.g. `e15`) from the most recent `snapshot`. You can also pass a CSS selector or a Playwright locator expression.

## Quick start

```bash
playwright-cli open
playwright-cli open https://example.com/
playwright-cli goto https://playwright.dev
playwright-cli click e15
playwright-cli fill e5 "user@example.com" --submit   # --submit presses Enter after fill
playwright-cli press Enter
playwright-cli snapshot
playwright-cli screenshot
playwright-cli close
```

## Core interaction

```bash
playwright-cli open [url]
playwright-cli goto <url>
playwright-cli type "search query"
playwright-cli click e3
playwright-cli dblclick e7
playwright-cli fill e5 "value" [--submit]
playwright-cli drag e2 e8
playwright-cli drop e4 --path=./image.png
playwright-cli drop e4 --data="text/plain=hello world"
playwright-cli hover e4
playwright-cli select e9 "option-value"
playwright-cli upload ./document.pdf
playwright-cli check e12
playwright-cli uncheck e12
playwright-cli snapshot [eN] [--filename=after.yaml] [--depth=4] [--boxes]
playwright-cli eval "document.title"
playwright-cli eval "el => el.textContent" e5
playwright-cli eval "el => el.getAttribute('data-testid')" e5
playwright-cli dialog-accept ["confirmation text"]
playwright-cli dialog-dismiss
playwright-cli resize 1920 1080
playwright-cli close
```

## Navigation

```bash
playwright-cli go-back
playwright-cli go-forward
playwright-cli reload
```

## Keyboard

```bash
playwright-cli press Enter        # or ArrowDown, Escape, Tab, etc.
playwright-cli keydown Shift
playwright-cli keyup Shift
```

## Mouse

```bash
playwright-cli mousemove 150 300
playwright-cli mousedown [right]
playwright-cli mouseup [right]
playwright-cli mousewheel 0 100
```

## Save as

```bash
playwright-cli screenshot [eN] [--filename=page.png]
playwright-cli pdf --filename=page.pdf
```

## Tabs

```bash
playwright-cli tab-list
playwright-cli tab-new [url]
playwright-cli tab-close [index]
playwright-cli tab-select <index>
```

## Storage

```bash
# Full storage state (cookies + localStorage + sessionStorage)
playwright-cli state-save [filename]
playwright-cli state-load <filename>

# Cookies
playwright-cli cookie-list [--domain=example.com] [--path=/api]
playwright-cli cookie-get  <name>
playwright-cli cookie-set  <name> <value> [--domain=...] [--path=...] [--httpOnly] [--secure] [--sameSite=Lax] [--expires=1735689600]
playwright-cli cookie-delete <name>
playwright-cli cookie-clear

# LocalStorage
playwright-cli localstorage-list
playwright-cli localstorage-get <key>
playwright-cli localstorage-set <key> <value>          # value is JSON if it starts with { or [
playwright-cli localstorage-delete <key>
playwright-cli localstorage-clear

# SessionStorage
playwright-cli sessionstorage-list | get | set | delete | clear
```

See `cli-advanced.md` for storage state file format and auth-state patterns.

## Network

```bash
playwright-cli route "**/*.jpg" --status=404
playwright-cli route "https://api.example.com/**" --body='{"mock": true}' [--content-type=application/json] [--header="X-Custom: value"] [--remove-header=cookie,authorization]
playwright-cli route-list
playwright-cli unroute ["**/*.jpg"]   # no arg clears all
```

URL pattern syntax: `**/api/users`, `**/api/*/details`, `**/*.{png,jpg,jpeg}`, `**/search?q=*`. For conditional responses, request body inspection, response modification, or delays see `cli-advanced.md` (request mocking).

## DevTools

```bash
playwright-cli console [warning|error|info|log|debug]
playwright-cli requests
playwright-cli request <index>
playwright-cli run-code "async page => await page.context().grantPermissions(['geolocation'])"
playwright-cli run-code --filename=./script.js
playwright-cli tracing-start
playwright-cli tracing-stop
playwright-cli video-start <file.webm>
playwright-cli video-chapter "Title" [--description="..."] [--duration=2000]
playwright-cli video-stop
playwright-cli show --annotate
playwright-cli generate-locator e5 [--raw]
playwright-cli highlight e5 [--style="outline: 3px dashed red"] [--hide]
```

## Open parameters

```bash
playwright-cli open --browser=chrome|firefox|webkit|msedge
playwright-cli open --persistent
playwright-cli open --profile=/path/to/profile
playwright-cli open --config=my-config.json
playwright-cli open --headed
playwright-cli attach --extension=chrome
playwright-cli attach --cdp=chrome|msedge|chrome-canary|msedge-canary
playwright-cli attach --cdp=http://localhost:9222
playwright-cli close
playwright-cli -s=msedge detach           # detach leaves external browser running
playwright-cli delete-data               # delete user data for default session
```

## Snapshots

After most commands, the CLI prints a snapshot of the current page state. Snapshot is also saved to `.playwright-cli/page-<timestamp>.yml` by default.

```bash
playwright-cli snapshot                          # full page, default
playwright-cli snapshot --filename=after.yaml   # save to file
playwright-cli snapshot "#main"                  # CSS-scope
playwright-cli snapshot --depth=4                # shallow
playwright-cli snapshot e34                      # scope to one ref
playwright-cli snapshot --boxes                  # include [box=x,y,w,h]
```

Use refs from the snapshot to interact:

```bash
playwright-cli click e15
playwright-cli click "#main > button.submit"      # CSS selector
playwright-cli click "getByRole('button', { name: 'Submit' })"  # Playwright locator
playwright-cli click "getByTestId('submit-button')"
```

## Raw and JSON output

```bash
playwright-cli --raw eval "JSON.stringify(performance.timing)" | jq '.loadEventEnd - .navigationStart'
playwright-cli --raw snapshot > before.yml
playwright-cli click e5
playwright-cli --raw snapshot > after.yml
diff before.yml after.yml
TOKEN=$(playwright-cli --raw cookie-get session_id)
playwright-cli --raw localstorage-get theme
playwright-cli list --json
```

`--raw` strips page status, generated code, and snapshot sections, returning only the result value. `--json` wraps every reply as JSON.

## Browser sessions

```bash
# Named, isolated sessions (cookies, storage, tabs)
playwright-cli -s=mysession open example.com --persistent
playwright-cli -s=mysession click e6
playwright-cli -s=mysession close
playwright-cli -s=mysession delete-data

playwright-cli list
playwright-cli close-all
playwright-cli kill-all                          # force-kill zombie processes

export PLAYWRIGHT_CLI_SESSION="mysession"        # default -s for the shell
```

Concurrent scraping pattern:

```bash
playwright-cli -s=site1 open https://site1.com &
playwright-cli -s=site2 open https://site2.com &
playwright-cli -s=site3 open https://site3.com &
wait
playwright-cli -s=site1 snapshot
playwright-cli close-all
```

## Targeting by channel / CDP / extension

```bash
# Channel (browser must allow remote debugging)
playwright-cli attach --cdp=chrome
playwright-cli attach --cdp=msedge-dev
playwright-cli detach                           # tear down attached session only

# CDP endpoint
playwright-cli attach --cdp=http://localhost:9222

# Playwright extension
playwright-cli attach --extension
```

## Installation

```bash
# Local (preferred when present)
npx --no-install playwright-cli --version

# Global fallback
npm install -g @playwright/cli@latest
```

## Common patterns

Form submission:

```bash
playwright-cli open https://example.com/form
playwright-cli snapshot
playwright-cli fill e1 "user@example.com"
playwright-cli fill e2 "password123"
playwright-cli click e3
playwright-cli snapshot
playwright-cli close
```

Multi-tab:

```bash
playwright-cli open https://example.com
playwright-cli tab-new https://example.com/other
playwright-cli tab-list
playwright-cli tab-select 0
playwright-cli snapshot
playwright-cli close
```

Debug with DevTools:

```bash
playwright-cli open https://example.com
playwright-cli click e4
playwright-cli fill e7 "test"
playwright-cli console
playwright-cli requests
playwright-cli close
```

Trace a flow:

```bash
playwright-cli open https://example.com
playwright-cli tracing-start
playwright-cli click e4
playwright-cli fill e7 "test"
playwright-cli tracing-stop
playwright-cli close
```

Inspect hidden attributes when the snapshot does not show them:

```bash
playwright-cli snapshot
playwright-cli eval "el => el.id" e7
playwright-cli eval "el => el.className" e7
playwright-cli eval "el => el.getAttribute('data-testid')" e7
playwright-cli eval "el => el.getAttribute('aria-label')" e7
playwright-cli eval "el => getComputedStyle(el).display" e7
```

Interactive session (ask the user to annotate):

```bash
playwright-cli open https://example.com
playwright-cli show --annotate
```
