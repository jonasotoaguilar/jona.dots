# Modern Threats Detection Reference

Signal-triggered checks for the security lens: prototype pollution, DOM clobbering, WebSocket security, and LLM prompt injection. Load the applicable section only; report only with confirmed attacker-influenced input and reachable impact.

## Prototype pollution (JavaScript)

Report when the change merges attacker-influenced data into objects without guarding `__proto__`/`constructor`/`prototype` keys: recursive merge/`Object.assign`-style patterns over `JSON.parse(userInput)`, or dynamic key assignment from request data. Attack payload shape: `{"__proto__": {"isAdmin": true}}` — pollutes all objects.

Not findings: merges that skip dangerous keys, `Object.create(null)` targets, `Map` usage, or merging only server-side data.

## DOM clobbering

Report when the change renders attacker-influenced HTML that can define named elements (`id`/`name`) colliding with `document`/`window` properties, AND the change's code reads those properties (`document.location.href`-style) or passes untrusted HTML into `innerHTML` without sanitizing `id`/`name` attributes.

Not findings: reads via `window.location` explicitly, sanitized HTML, type-checked document property access.

## WebSocket security

Report when the change adds a socket endpoint without: origin allowlist validation, authentication (token in query/first message), message schema validation, or rate limiting — enabling cross-site WebSocket hijacking or unauthenticated message injection.

## LLM prompt injection (model boundary)

**Reporting signal (security lens):** treat model output as attacker-influenced when the change routes it into code, SQL, shell, markup, tool arguments, file paths, or authorization decisions; literal attacker-controlled provenance is not required because the model is the transformation boundary. Report when the change lacks code-enforced permissions, output validation/encoding, or scoped tools at that boundary. Do not report prompt-text hygiene alone. Distinct from the reliability lens's AI-regression review (parallel paths and shape consistency).

**What does NOT protect you:** regex escaping/blocklist sanitization of input (bypassable), and the system prompt as a security boundary (permissions are enforced in code, not in the prompt).

**Defenses in order of leverage:**

1. Permissions enforced in code — the model may only reach allowlisted, validated actions; defensive parse of structured output before use.
2. Output handling — model output is untrusted data: parse defensively, validate, encode at every sink (never direct `eval`, `db.query`, `subprocess`, `innerHTML`, `open(path)`).
3. Constrain agency — minimal tool scope, confirmation for destructive actions, validate every tool argument.
4. Bound consumption — token/rate/loop-depth caps so crafted input cannot run up cost or hang.
5. Keep secrets and other users' data out of the context window (anything in context can be echoed).
6. Tenant/RAG isolation — vector store is a trust boundary: partition embeddings per tenant; validate documents before indexing.

**OWASP LLM Top 10 — security lens scope map (routing only, never a universal checklist):** static boundary signals in changed code: LLM01 prompt injection, LLM05 improper output handling, LLM06 excessive agency, LLM07 system prompt leakage (secrets/auth in the prompt), LLM08 vector/embedding weaknesses (cross-tenant retrieval), LLM10 unbounded consumption. Outside this static lens scope: LLM02 (sensitive info disclosure), LLM03 (supply chain), LLM04 (data/model poisoning), LLM09 (misinformation) — they require product/runtime testing; taxonomy alone is never a finding.

## Evidence gate

- Confirm the attacker-influenced source and reachable sink within the reviewed scope for the specific section activated.
- Final severity comes from the Output Contract in SKILL.md, never from this reference.
