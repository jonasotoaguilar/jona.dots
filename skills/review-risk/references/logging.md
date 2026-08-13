# Security Logging Detection Reference

Signal-triggered checks for the security lens. Load when the change adds log statements or modifies auth/authorization paths that log events. Log-storage, rotation, alerting rules, and retention policy belong to `observability-and-instrumentation`/`sre-engineer`, not this lens.

## Reportable patterns

- **Sensitive data in logs introduced by the change:** passwords, tokens/API keys, session cookies, JWTs, full request bodies, credit card numbers, or raw PII in `logger.info`/`print`/`console.log` calls.
- **Log injection:** attacker-influenced input interpolated into log lines without newline/control-character sanitization (forged entries, log-viewer XSS) — when the change adds the log statement.
- **Missing security-event logging on a changed auth path:** login success/failure, lockout, password change/reset, role change, or privilege escalation implemented by the change without any audit logging, when the repo's surrounding code logs comparable events.

## Not findings

- Absence of alerting thresholds, immutable audit chains, retention schedules, centralized log shipping, or world-readable log file config — platform/ops policy, not candidate-caused defects, unless the change actively regresses an existing setup.
- Logging the full request in an already-sanitized structured format (correlation IDs, masked tokens).

## Evidence gate

- Confirm the log line is in the changed code path and the sensitive value or injection source is confirmed within the reviewed scope.
- Final severity comes from the Output Contract in SKILL.md, never from this reference.
