# SSRF Detection Reference

Signal-triggered checks for the security lens. Load when the change makes server-side HTTP requests to a URL derived from attacker-influenced input (request params, storage attacker-influenced data reaches, webhook URLs, model output). Report only with confirmed source and reachable impact.

## Reportable patterns

- **User-controlled URL fetched without validation:** `requests.get(url)`/`fetch(url)`/`axios`/`urllib`/`file_get_contents`/`curl_exec`/`openConnection` where the URL comes from request data or attacker-influenced storage and no scheme/allowlist check precedes it.
- **Weak scheme check only:** validation covers `http`/`https` but not the host; attacker reaches internal services via `localhost`, `127.0.0.0/8`, private ranges (`10/8`, `172.16/12`, `192.168/16`), link-local `169.254.0.0/16` (cloud metadata), IPv6 equivalents (`::1`, `fc00::/7`, IPv4-mapped), or alternate representations (decimal/hex/octal IPs, encoded dots).
- **Redirects followed blindly:** `allow_redirects=True`/`redirect: 'follow'` after an IP check — a redirect to `169.254.169.254` bypasses it. Validate each hop or disable redirects.
- **DNS rebinding gap:** validate-then-fetch where DNS is re-resolved between check and request (TOCTOU); short-TTL records can rebind to internal IPs. Pin the resolved IP and request with a `Host` header for high-risk surfaces, or acknowledge the limitation.

## Mitigations (not findings unless removed)

- Host allowlist (preferred when targets are known); deny internal ranges with resolution of ALL DNS answers (a single public answer is not safety); scheme allowlist; disabled/validated redirects; timeouts; AWS IMDSv2 (`--http-tokens required`).

## Evidence gate

- Confirm the URL source is attacker-influenced within the reviewed scope and the fetch is reachable from the changed path.
- Final severity comes from the Output Contract in SKILL.md, never from this reference.
