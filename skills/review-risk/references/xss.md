# XSS Detection Reference

Signal-triggered checks for the security lens. Load when the change renders attacker-influenced data (request-derived, stored data attacker-influenced data can reach, or model output) into HTML/JS/CSS/URL contexts, or introduces a dangerous DOM sink. Report only with confirmed input source and reachable impact within the reviewed scope.

## Dangerous sinks (report when attacker-influenced data reaches them)

- DOM HTML sinks: `innerHTML`, `outerHTML`, `document.write()`/`writeln()`, `insertAdjacentHTML()`, `elem.onevent = value`.
- JS execution sinks: `eval()`, `new Function()`, `setTimeout`/`setInterval` with string arguments.
- Framework escape-hatches: React `dangerouslySetInnerHTML`, Vue `v-html`, Angular `bypassSecurityTrust*`, Django/Jinja `|safe`, `{% autoescape off %}` (when disabled scoped wider than needed), `mark_safe`/`SafeString` on attacker-influenced data.
- URL context: raw input in `href`/`src` without scheme validation (`javascript:` scheme), unquoted attribute values, input in event-handler attributes (`onclick="..."`).
- CSS context: user input in style URLs/expressions.

Not findings: framework auto-escaping paths (`{userInput}`, `{{ }}`, `textContent`, `createTextNode`, `setAttribute`, quoted + encoded attributes, `encodeURIComponent` for URL parameters) — unless the change disables or bypasses the mitigation.

## Attacker-influenced sources (client-side / DOM-based)

- `location.hash`, `location.search`, `document.referrer`, `window.name`, `postMessage` data, and model output flowing into a sink without validation. Validate with an allowlist before use.

## Mitigation checks (not findings unless removed)

- HTML sanitization via an up-to-date library (DOMPurify) with an explicit allowed tag/attribute set; sanitize on output, not only input.
- CSP as defense-in-depth: `default-src 'self'`, nonce/hash-based `script-src`, `object-src 'none'`, `base-uri 'none'`. CSP alone is not a primary defense.

## Evidence gate

- Confirm the input is attacker-influenced within the reviewed scope (request data, storage attacker-influenced data reaches, or model output at the transformation boundary). Server-controlled constants are not findings unless the change routes user input into them.
- Confirm the sink is reachable from the changed code path.
- Final severity comes from the Output Contract in SKILL.md, never from this reference.
