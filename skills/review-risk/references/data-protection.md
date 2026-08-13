# Data Protection Detection Reference

Signal-triggered checks for the security lens. Load when the change touches sensitive data (PII, credentials, financial/health data): new collection, storage, transmission, serialization, response shaping, caching, or disposal. Report only with confirmed impact within the reviewed scope.

## Reportable patterns

- **Sensitive data in API/response payloads:** endpoint returning full objects or `__dict__`/whole-model serialization that now includes fields the consumer does not need (password hashes, tokens, internal IDs, PII), or a serializer that newly exposes such fields.
- **Sensitive data collected/retained unnecessarily:** the change adds collection or storage of data (SSN, payment PAN, full credentials) with no handling for it downstream.
- **Sensitive data cached or logged:** the change caches responses containing sensitive fields, or adds log lines with raw credentials/PII — see `logging.md` for log-specific rules.
- **Insecure transmission introduced:** new HTTP (non-TLS) endpoint or websocket carrying sensitive data, or TLS downgrade (`ssl_version`/min version weakened).
- **Debug/verbose exposure:** the change enables debug mode (`app.run(debug=True)`, `DEBUG=1`), returns stack traces (`traceback`, `exc_info`, `str(e)`) or internal error detail to clients — see `error-handling.md` for error-specific rules.
- **Cache-control removed:** the change drops `no-cache, no-store` on responses serving sensitive data.
- **Disposal regressions:** the change keeps sensitive data past its retention point or introduces plaintext copies.

## Not findings

- TLS termination at a proxy/infra layer outside the change; general absence of encryption-at-rest policies; classification/retention policy gaps not caused by the candidate.

## Evidence gate

- Confirm the exposure is introduced/activated/worsened by the candidate and reachable within the reviewed scope.
- Final severity comes from the Output Contract in SKILL.md, never from this reference.
