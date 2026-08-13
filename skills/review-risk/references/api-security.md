# API Security Detection Reference

Signal-triggered checks for the security lens. Load when the change adds/modifies REST/GraphQL/WebSocket endpoints or token handling. Overlapping classes route to their owning references: endpoint authz → `authorization.md`, auth/sessions → `authentication.md`, CORS/headers/cookies → `misconfiguration.md`, verbose errors → `error-handling.md`. This file covers API-specific signals only.

## Reportable patterns

- **JWT mishandling:** decoding with `algorithms=['none']` or without an explicit algorithm allowlist (algorithm confusion); missing `iss`/`aud` validation; secret compared with non-constant-time operations; tokens with no expiry accepted.
- **API key in URL/query** (logged, cached, referrer-leaked) instead of header; or key validation absent on a new keyed endpoint.
- **GraphQL:** introspection enabled in production; unbounded query depth; no query-cost analysis; unlimited batched mutations; resolvers that bypass endpoint-level authorization.
- **WebSocket:** new socket endpoint without origin validation, without authentication (token in query/first message), without message schema validation, or without rate limiting — cross-site WebSocket hijacking surface.
- **Request handling:** no body size limit on a new accepting endpoint; content-type not enforced where JSON is required; missing rate limiting on new auth-sensitive endpoints (see `authentication.md`).

## Not findings

- Absence of generic rate-limiting/observability policies outside the changed surface.
- Framework-provided defaults (express `express.json`, DRF serializers) unless the change disables them.

## Evidence gate

- Confirm the API surface is new or modified in the change and the gap is introduced/activated/worsened by the candidate.
- Final severity comes from the Output Contract in SKILL.md, never from this reference.
