# Cryptography Detection Reference

Signal-triggered checks for the security lens. Load when the change introduces or modifies cryptographic operations: encryption, hashing, signing, key derivation, random generation, or key handling. Report only with confirmed impact within the reviewed scope.

## Reportable patterns

- **Weak/broken algorithms:** DES, 3DES, RC4, MD5 or SHA-1 for security purposes (signatures, integrity of security data, checksums on secrets), AES-ECB (pattern leakage), AES-CBC without authentication (padding oracle / bit-flipping), RSA < 2048 bits, DSA, weak ECC curves.
- **Unauthenticated encryption:** encrypt-then-MAC missing (CBC/CTR without a MAC/tag). GCM/CCM/ChaCha20-Poly1305 are not findings.
- **Predictable security randomness:** `random` module / `Math.random()` / `rand()` / `mt_rand()` / `java.util.Random` / `math/rand` used for tokens, keys, IVs, nonces, session IDs, password resets. Not findings: `secrets`, `os.urandom()`, `crypto.randomBytes()`, `SecureRandom`, `random_bytes()`, `crypto/rand`, `RandomNumberGenerator`, UUIDv4 from a CSPRNG-backed implementation. UUIDv1 (timestamp+MAC) as a security token is a finding.
- **Static/reused IV or nonce:** constant, zeroed, or counter-reset nonce reused with the same key.
- **Hardcoded keys/secrets:** literal key/secret bytes in source (`KEY = b'...'`, base64-decoded literals, key derived directly from a password without a KDF). Keys from secrets managers, KMS, or env-supplied references are not findings unless the value itself is a literal.
- **Hand-rolled crypto:** reimplemented algorithms, custom MAC/signature schemes, or homegrown key-derivation. Established libraries are not findings.

## Evidence gate

- Confirm the weak operation is in the changed code path and serves a security purpose (not, e.g., MD5 for non-security content addressing).
- Key-rotation and envelope-encryption absence are design guidance, not candidate-caused findings; report only if the change actively regresses an existing scheme.
- Final severity comes from the Output Contract in SKILL.md, never from this reference.
