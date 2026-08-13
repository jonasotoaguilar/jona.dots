# Error Handling Detection Reference

Signal-triggered checks for the security lens. Load when the change adds/modifies exception handling, error responses, or failure paths on security-relevant operations. Report only with confirmed impact within the reviewed scope.

## Reportable patterns

- **Verbose error disclosure:** stack traces, `traceback.format_exc()`, `str(e)`, exception type/args, SQL error text, or internal paths returned to clients by the changed error handler.
- **Fail-open on security checks:** auth/permission/validation wrapped so an exception (or `except: pass`) allows the operation to continue; `return True`/default-to-authorized in `except` of a permission check; validation skipped in a bare except.
- **Exception swallowing in security-critical code:** bare `except: pass` around validation, decryption, signature checks, or token verification.
- **Differential messages enabling enumeration:** the change introduces distinct errors that reveal account existence (login "User not found" vs "Wrong password"; reset "Email not found"; signup "Email already registered"). Timing-differentiable paths (fast return when user missing vs slow hash check) count when introduced by the change.
- **Unhandled async failures:** changed async handlers without rejection handling that crash the request path or leave it in a broken state.
- **Resource leaks on error:** files/connections acquired without context managers or try/finally in the changed path.
- **Error-logged payloads:** the change logs full request bodies/user input in error paths (log injection and log-volume vectors; see `logging.md` for log rules).

## Mitigations (not findings unless removed)

- Generic client-facing messages with detailed server-side logging; fail-closed (`abort(500)`/deny on service failure); specific exception types with re-raise of security exceptions; constant-time auth with dummy-hash comparison; context-managed resources.

## Evidence gate

- Confirm the exposure or fail-open is introduced/activated/worsened by the candidate and reachable within the reviewed scope.
- Final severity comes from the Output Contract in SKILL.md, never from this reference.
