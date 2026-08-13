# Injection Detection Reference

Signal-triggered checks for the security lens. Load only when the change contains an interpreter boundary: SQL/NoSQL queries, shell/command execution, templates, LDAP, or XPath. Report only when attacker-influenced input (or model output) flows into a built query/command with reachable impact; parameterized/mitigated patterns are not findings unless the change removes the mitigation.

## SQL injection

Report when the change builds queries from input via:

- String concatenation or interpolation into the query text: Python `+`/f-strings/`.format()`, JS template literals, any `query = "..." + input`.
- Raw/escape-hatch APIs with interpolated input: Django `raw()`/`extra()` with f-strings, SQLAlchemy `text()` with interpolation, Rails `where(...)` with string fragments, `.query(...)` with concatenation, `execute("...")` with concatenated params.
- Dynamic identifiers (table/column names, sort order) built from input without an allowlist — these cannot be parameterized; require explicit allowlisting.

Not findings: parameterized queries (`?`, `%s`, `$1`, named params), ORM methods (`filter()`, `query()`), stored procedures without dynamic SQL, allowlisted identifiers.

## NoSQL injection

Report when user-controlled values pass into query operators: MongoDB `find()`/`aggregate()` with raw request-body values (`{ username: req.body.username }`) enabling `$gt`/`$ne`/`$in`/`$regex` manipulation, or `$where` (JS execution). Report only when the change does not coerce/validate types first.

## OS command injection

Report when attacker-influenced input reaches:

- `os.system()`, `os.popen()`, `subprocess.run(...)`/`Popen(...)` with `shell=True` and interpolated strings, `eval()`/`exec()`.
- `child_process.exec()` (JS), `exec()`/`shell_exec()`/`system()`/`passthru()`/backticks (PHP), `system()`/`exec()`/backticks/`%x{}` (Ruby), `Runtime.exec()`/`ProcessBuilder` with a shell.

Not findings: `shell=False` with argument lists, built-in equivalents (`os.makedirs` over `mkdir`), allowlisted commands/arguments.

## Template injection (SSTI)

Report when user input is interpolated into template source: Python `Template(f"...")`/`render_template_string()` with concatenation, or equivalents in other engines. Pass input as render variables instead. Detection payloads: Jinja2 `{{7*7}}`, FreeMarker `${7*7}`, Thymeleaf `[[${7*7}]]` — evidence only when the input source is confirmed attacker-influenced.

## LDAP / XPath injection

Report when input is concatenated into LDAP filters/DNs (escape `* ( ) \ NUL` filter context; `\ # + < > ; " = /` DN context) or into XPath expressions (`"//users/user[name='" + input + "']"`). Parameterized XPath/LDAP encoders are not findings.

## Evidence gate

- Confirm the input source within the reviewed scope: attacker-influenced request data, storage that attacker-influenced data reaches, or model output at the transformation boundary. Server-controlled constants/settings are not findings unless the change routes user input into them.
- Confirm the sink is reachable from the changed code path; a pattern without reachable impact is not a finding.
- Final severity comes from the Output Contract in SKILL.md, never from this reference.
