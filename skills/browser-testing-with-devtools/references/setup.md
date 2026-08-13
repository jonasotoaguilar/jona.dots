# Setup: Chrome DevTools MCP

## Installation

Add the following to your project's `.mcp.json` or OpenCode/Claude Code MCP settings:

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp@latest", "--isolated"]
    }
  }
}
```

`-y` skips the npx install confirmation. By default the server launches Chrome with its own dedicated profile (under `~/.cache/chrome-devtools-mcp/`), separate from your personal browser; `--isolated` goes one step further and uses a temporary profile that is wiped when the browser closes. This is the right setup for most testing.

There is also `--autoConnect` (Chrome 144+, requires enabling remote debugging via `chrome://inspect/#remote-debugging`), which attaches the agent to your **running** Chrome instead. Only use it when the test genuinely needs your logged-in state — see Profile Isolation in `security.md` first.

## Tool Reference

Chrome DevTools MCP exposes these tools (names match the `chrome-devtools_*` MCP namespace):

| Tool                                                   | What It Does                                | When to Use                                                                                    |
| ------------------------------------------------------ | ------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| `navigate_page`                                        | Loads a URL / back / forward / reload       | Reach the target state                                                                         |
| `take_snapshot`                                        | Reads the live a11y tree of the page        | Verify component rendering, check structure                                                    |
| `take_screenshot`                                      | Captures the current page state             | Visual verification, before/after comparisons                                                  |
| `list_console_messages`                                | Retrieves console output (log, warn, error) | Diagnose errors, verify clean console                                                          |
| `get_console_message`                                  | Reads one console message by id             | Inspect a specific error in detail                                                             |
| `list_network_requests`                                | Lists captured network requests             | Verify API calls, check status/payload                                                         |
| `get_network_request`                                  | Reads request/response body of one request  | Inspect payloads and response bodies                                                           |
| `performance_start_trace` / `performance_stop_trace`   | Records performance timing data             | Profile load time, identify bottlenecks                                                        |
| `performance_analyze_insight`                          | Explains a specific performance insight     | Drill into a flagged metric                                                                    |
| `evaluate_script`                                      | Runs JS in the page context                 | Read-only state inspection (see security.md)                                                   |
| `emulate`                                              | Emulates viewport/network/CPU/geolocation   | Responsive testing, throttling                                                                 |
| `lighthouse_audit`                                     | Runs Lighthouse on the current page         | Targeted one-page diagnosis only; site-wide/sampled Lighthouse audits belong to `unlighthouse` |
| `click` / `fill` / `press_key` / `type_text` / `hover` | Drives the page like a user                 | Reproduce interactions                                                                         |
| `wait_for`                                             | Waits for text to appear                    | Synchronize with async rendering                                                               |
| `handle_dialog`                                        | Accepts/dismisses JS dialogs                | Navigate alert/confirm/prompt flows                                                            |
