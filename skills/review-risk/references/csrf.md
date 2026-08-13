# CSRF Detection Reference

Signal-triggered checks for the security lens. Load when the change adds or modifies state-changing endpoints (POST/PUT/PATCH/DELETE), session/auth cookie handling, CORS config, or client-side code that issues state-changing requests. Report only with confirmed impact within the reviewed scope.

## Reportable patterns

- **State-changing endpoint without CSRF protection**: new POST/PUT/PATCH/DELETE route (or handler) that mutates state and lacks a CSRF token check or framework middleware protection.
- **Protection removed or weakened by the change**: `csrf_exempt`, `WTF_CSRF_ENABLED=False`, `@csrf.exempt`, middleware removal, `csurf`/`csrf` library removal, `X-CSRF-Token` validation dropped, `SameSite=None` added without `Secure`.
- **State change via GET**: route/handler mutating state on `GET`/`HEAD` (attacker triggers via `<img src>`); new forms posting via GET semantics.
- **CORS wildcard with credentials**: `Access-Control-Allow-Origin: *` (or echo of arbitrary `Origin`) combined with `Access-Control-Allow-Credentials: true`; or `Access-Control-Allow-Origin` echoing `request.headers.get('Origin')` without an allowlist.
- **Token in URL**: CSRF token passed as a query parameter (leaks via referrer/logs/caches).
- **Client-side CSRF**: client code building state-changing requests from `location.hash`/`location.search` fragments or `postMessage` data without allowlist validation.

## Mitigations (not findings unless removed)

- Synchronizer token pattern with constant-time comparison (`secrets.compare_digest`); double-submit cookie with HMAC-signed token; `SameSite=Lax`/`Strict` on session cookies; custom-header requirement for API calls; Origin/Referer validation (prefer `Origin`); Fetch Metadata (`Sec-Fetch-Site`) checks; framework defaults (Django `CsrfViewMiddleware`, Flask-WTF `CSRFProtect`).

## Evidence gate

- Confirm the endpoint is state-changing and reachable, and the change is what removed/omitted the protection. Pre-existing gaps outside the change are out of scope.
- Final severity comes from the Output Contract in SKILL.md, never from this reference.
