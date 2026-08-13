# Authentication Detection Reference

Signal-triggered checks for the security lens. Load when the change touches login/registration, password storage, session handling, cookies, token issuance, or auth error messages. Report only with confirmed impact within the reviewed scope.

## Password storage (report when the change introduces or keeps weak hashing)

- **Recommended, in preference order:** Argon2id (memory ≥ 19 MiB, iterations ≥ 2, parallelism 1); scrypt (N=2^17, r=8, p=1); bcrypt (work factor ≥ 10, ideally 12+; 72-byte password limit); PBKDF2 (≥ 600,000 iterations HMAC-SHA-256, FIPS environments).
- **Findings:** MD5, SHA-1, unsalted or uniterated SHA-256 for passwords; reversible encryption of passwords; plaintext storage.
- Not findings: password hashing moved to an established library (passlib, bcrypt, argon2-cffi) without weakening parameters.

## Error message discrimination

- **Finding:** the change returns distinguishable errors that reveal account existence: "User not found" vs "Invalid password", "Email not found" in password recovery, "Email already registered" on signup.
- Not findings: identical generic responses ("Invalid user ID or password", "If that email is in our database...").

## Session security

- **Predictable session IDs:** `str(user_id) + str(time.time())`, UUIDv1, or counter-based IDs in the changed code. Not findings: `secrets.token_*`, crypto-random session ids.
- **Session fixation:** authentication sets session state WITHOUT regenerating the session ID. Not findings: `session.regenerate()`/`regenerate_id()` on login and privilege change.
- **Cookie flags weakened by the change:** `Secure`/`HttpOnly`/`SameSite` removed or set to `None` without `Secure` on session/auth cookies.
- **Logout does not invalidate:** server-side session not invalidated, cookie not cleared.

## Brute-force and MFA (report only when the change adds auth entry points)

- New login/reset/verify endpoint with no rate limiting or lockout tracking (track per-account, not per-IP).
- MFA bypass added: optional-MFA path for sensitive operations, or MFA-disable without re-authentication.
- Sensitive changes (password change, email change, MFA change, account deletion, financial actions) without fresh re-authentication.

## Evidence gate

- Confirm the auth code is new or modified in the change and the gap is introduced/activated/worsened by the candidate. Pre-existing gaps outside the change are out of scope.
- Final severity comes from the Output Contract in SKILL.md, never from this reference.
