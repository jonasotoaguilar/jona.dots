# Security Misconfiguration Detection Reference

Signal-triggered checks for the security lens. Load when the change touches app config, middleware, headers, CORS, TLS, cookies, endpoints, or dependency/config files. Report only when the change introduces or worsens the misconfiguration.

## Reportable patterns

- **Security headers removed or weakened by the change:** `X-Content-Type-Options: nosniff`, `X-Frame-Options: DENY/SAMEORIGIN`, `Strict-Transport-Security`, `Content-Security-Policy` (watch `*`, `'unsafe-inline'`, `'unsafe-eval'` in `script-src`), `Referrer-Policy`, `Permissions-Policy` dropped or set permissively.
- **CORS:** wildcard `Access-Control-Allow-Origin: *` or unvalidated origin reflection combined with credentials; `Access-Control-Allow-Origin: null`; credentials allowed with wildcard.
- **Debug mode / verbose config in production:** `debug=True`, `DEBUG=True`, `FLASK_ENV=development`, `app.set('env', 'development')`, `spring.devtools.restart.enabled=true`, or actuator exposure (`management.endpoints.web.exposure.include=*`) introduced by the change.
- **Default/weak credentials introduced:** `password = 'admin'/'root'/'postgres'/'123456'/'changeme'`, `SECRET_KEY = 'development-secret-key'`, base64-encoded default secrets in compose/secret manifests.
- **Exposed sensitive endpoints without auth:** `/debug`, `/env`, `/config`, `/admin`, `/metrics` (when it leaks internal state), actuator env/heapdump/configprops, `.git`/`.env` serving — added by the change without protection.
- **TLS verification disabled:** `requests.get(url, verify=False)`, `urllib3.disable_warnings()`, `rejectUnauthorized: false`, `NODE_TLS_REJECT_UNAUTHORIZED=0`, minimum TLS below 1.2, `set_ciphers('ALL')` — introduced by the change.
- **Insecure cookie flags:** session/auth cookie set without `Secure`/`HttpOnly`/`SameSite`, or explicitly `secure=False`/`samesite='None'` without Secure — introduced or weakened by the change.
- **Directory listing enabled** or overly permissive file permissions (see `file-security.md`) introduced by the change.
- **Overly broad HTTP methods on changed endpoints** (TRACE enabled, all methods on a sensitive route).

## Evidence gate

- Confirm the misconfiguration is introduced/activated/worsened by the candidate; absence of headers in pre-existing code is out of scope.
- Final severity comes from the Output Contract in SKILL.md, never from this reference.
