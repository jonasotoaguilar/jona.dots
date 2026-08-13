# Reporting Criteria — Confidence, Input Classification, Impact, Quick Patterns

Use this reference when deciding whether a candidate pattern is reportable. It classifies confidence and technical impact only; final severities come exclusively from the Output Contract severity rules (BLOCKER/CRITICAL/WARNING/SUGGESTION). Reference material derived from the OWASP Cheat Sheet Series (see `LICENSE` in this skill).

## Confidence Levels

| Level      | Criteria                                                 | Action                                               |
| ---------- | -------------------------------------------------------- | ---------------------------------------------------- |
| **HIGH**   | Vulnerable pattern + attacker-controlled input confirmed | **Report** through the Output Contract               |
| **MEDIUM** | Vulnerable pattern, input source unclear                 | **Do not report**; unverified input is not a finding |
| **LOW**    | Theoretical, best practice, defense-in-depth             | **Do not report**                                    |

## Do Not Flag

### General Rules

- Test files (unless explicitly reviewing test security)
- Dead code, commented code, documentation strings
- Patterns using **constants** or **server-controlled configuration**
- Code paths that require prior authentication to reach (note the auth requirement instead)

### Server-Controlled Values (NOT Attacker-Controlled)

These are configured by operators, not controlled by attackers:

| Source                | Example                                      | Why It's Safe                    |
| --------------------- | -------------------------------------------- | -------------------------------- |
| Django settings       | `settings.API_URL`, `settings.ALLOWED_HOSTS` | Set via config/env at deployment |
| Environment variables | `os.environ.get('DATABASE_URL')`             | Deployment configuration         |
| Config files          | `config.yaml`, `app.config['KEY']`           | Server-side files                |
| Framework constants   | `django.conf.settings.*`                     | Not user-modifiable              |
| Hardcoded values      | `BASE_URL = "https://api.internal"`          | Compile-time constants           |

**SSRF Example - NOT a vulnerability:**

```python
# SAFE: URL comes from Django settings (server-controlled)
response = requests.get(f"{settings.SEER_AUTOFIX_URL}{path}")
```

**SSRF Example - IS a vulnerability:**

```python
# VULNERABLE: URL comes from request (attacker-controlled)
response = requests.get(request.GET.get('url'))
```

### Framework-Mitigated Patterns

Check language guides before flagging. Common false positives:

| Pattern                             | Why It's Usually Safe          |
| ----------------------------------- | ------------------------------ |
| Django `{{ variable }}`             | Auto-escaped by default        |
| React `{variable}`                  | Auto-escaped by default        |
| Vue `{{ variable }}`                | Auto-escaped by default        |
| `User.objects.filter(id=input)`     | ORM parameterizes queries      |
| `cursor.execute("...%s", (input,))` | Parameterized query            |
| `innerHTML = "<b>Loading...</b>"`   | Constant string, no user input |

**Only flag these when:**

- Django: `{{ var|safe }}`, `{% autoescape off %}`, `mark_safe(user_input)`
- React: `dangerouslySetInnerHTML={{__html: userInput}}`
- Vue: `v-html="userInput"`
- ORM: `.raw()`, `.extra()`, `RawSQL()` with string interpolation

## Verify Exploitability

For each potential finding, confirm:

**Is the input attacker-controlled?**

| Attacker-Controlled (Investigate)              | Server-Controlled (Usually Safe)   |
| ---------------------------------------------- | ---------------------------------- |
| `request.GET`, `request.POST`, `request.args`  | `settings.X`, `app.config['X']`    |
| `request.json`, `request.data`, `request.body` | `os.environ.get('X')`              |
| `request.headers` (most headers)               | Hardcoded constants                |
| `request.cookies` (unsigned)                   | Internal service URLs from config  |
| URL path segments: `/users/<id>/`              | Database content from admin/system |
| File uploads (content and names)               | Signed session data                |
| Database content from other users              | Framework settings                 |
| WebSocket messages                             |                                    |

**Does the framework mitigate this?**

- Check the language guide for auto-escaping, parameterization
- Check for middleware/decorators that sanitize

**Is there validation upstream?**

- Input validation before this code
- Sanitization libraries (DOMPurify, bleach, etc.)

## Impact Classification

Technical impact only — never an output severity. After confirming attacker-controlled input and reachability, report through the Output Contract and let its severity rules map the impact.

| Impact           | What it means                                   | Examples                                                                 |
| ---------------- | ----------------------------------------------- | ------------------------------------------------------------------------ |
| **Catastrophic** | Direct exploit, severe impact, no auth required | RCE, SQL injection to data, auth bypass, hardcoded secrets               |
| **Major**        | Exploitable with conditions, significant impact | Stored XSS, SSRF to metadata, IDOR to sensitive data                     |
| **Moderate**     | Specific conditions required, moderate impact   | Reflected XSS, CSRF on state-changing actions, path traversal            |
| **Minor**        | Defense-in-depth, minimal direct impact         | Missing headers, verbose errors, weak algorithms in non-critical context |

## Quick Patterns Reference

### Potential Catastrophic/Major Impact (verify attacker control and reachability before reporting)

```
eval(user_input)           # Any language
exec(user_input)           # Any language
pickle.loads(user_data)    # Python
yaml.load(user_data)       # Python (not safe_load)
unserialize($user_data)    # PHP
deserialize(user_data)     # Java ObjectInputStream
shell=True + user_input    # Python subprocess
child_process.exec(user)   # Node.js
```

### Potential Major Impact (verify attacker control and reachability before reporting)

```
innerHTML = userInput              # DOM XSS
dangerouslySetInnerHTML={user}     # React XSS
v-html="userInput"                 # Vue XSS
f"SELECT * FROM x WHERE {user}"    # SQL injection
`SELECT * FROM x WHERE ${user}`    # SQL injection
os.system(f"cmd {user_input}")     # Command injection
```

### Secrets (report when the change introduces them)

```
password = "hardcoded"
api_key = "sk-..."
AWS_SECRET_ACCESS_KEY = "..."
private_key = "-----BEGIN"
```

### Check Context First (MUST Investigate Before Flagging)

```
# SSRF - ONLY if URL is from user input, NOT from settings/config
requests.get(request.GET['url'])     # FLAG: User-controlled URL
requests.get(settings.API_URL)       # SAFE: Server-controlled config
requests.get(f"{settings.BASE}/{x}") # CHECK: Is 'x' user input?

# Path traversal - ONLY if path is from user input
open(request.GET['file'])            # FLAG: User-controlled path
open(settings.LOG_PATH)              # SAFE: Server-controlled config
open(f"{BASE_DIR}/{filename}")       # CHECK: Is 'filename' user input?

# Open redirect - ONLY if URL is from user input
redirect(request.GET['next'])        # FLAG: User-controlled redirect
redirect(settings.LOGIN_URL)         # SAFE: Server-controlled config

# Weak crypto - ONLY if used for security purposes
hashlib.md5(file_content)            # SAFE: File checksums, caching
hashlib.md5(password)                # FLAG: Password hashing
random.random()                      # SAFE: Non-security uses (UI, sampling)
random.random() for token            # FLAG: Security tokens need secrets module
```

## Signal-Activated Adversarial Triage

Run this only when triage already activated a security surface. It is a signal-driven question set, not a universal checklist, and it uses only the reviewed scope evidence — never runtime, logs, or external probes. Work each bullet as a question, not a rule; most changes activate none.

- **Sad/error/fallback paths:** catch, timeout, retry, cleanup, and default branches — fail-open or differently-authorized behavior on failure.
- **Input boundaries/coercion/expiry:** empty/null/zero, max-length, coercion, the moment a token, limit, or lease lapses.
- **Implicit trust between components:** one layer assuming another validated, authorized, or sanitized; unjustified cross-layer trust.
- **Wrong ordering/replay of security-sensitive flows:** reordered, replayed, or out-of-sequence steps (confirm before create, callback before request).
- **Concurrent operations affecting authorization/state:** parallel requests mutating shared auth or state; modify-while-read, delete-while-iterate, duplicate resource claims.
- **Parser/validator/content-type/MIME disagreement:** content-type vs body, router vs code URL parsing, extension vs MIME vs magic bytes, schema-vs-store acceptance.
- **Round-trip encoding/escaping/serialization/path changes:** data read back differing after storage; double escaping; path resolved differently on write vs read.
- **Configuration/default/feature-flag changes to security posture:** a flag, default, or env value that alters validation or fail-closed behavior.
- **Authorization on every state-changing and parallel path:** right permission and right resource checked on each; no unchecked parallel route.
- **Leaked context:** errors, headers, response-size or timing differences, debug routes, version disclosure that aid an attacker.
- **Parameters overriding security-relevant defaults:** user-supplied input flipping a safe default without permission gating.
- **Unverified identity/capability/metadata driving trust decisions:** self-declared claims influencing an access or trust decision without independent verification.

Before reporting any candidate, prove attacker control, reachability, meaningful impact, absent mitigation, and candidate causality (introduced, behavior-activated, or worsened). Triage is advisory; do not expand into another lens or category.
