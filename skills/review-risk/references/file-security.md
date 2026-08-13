# File Security Detection Reference

Signal-triggered checks for the security lens. Load when the change handles files: uploads, downloads, serving user paths, XML parsing, archive extraction, or temp files. Report only with confirmed attacker-influenced input and reachable impact.

## Reportable patterns

- **Path traversal:** user-controlled filename/path joined to a base directory and passed to `send_file`/`open`/`readFile`/`writeFile` without canonicalization + containment (`realpath(...).startswith(base)`), allowlist, or indirect reference. Watch encoded variants (`%2e%2e`, double-encoding, `..\`).
- **Unsafe uploads:** the change accepts uploads without: size limit, extension allowlist, content sniffing (never trust the client `Content-Type`), stored outside the webroot, server-generated storage name. Danger types accepted: executables/scripts (`php`, `py`, `sh`...), `html`/`svg` (stored XSS), macro-enabled Office files.
- **XXE:** XML parsed from attacker-influenced data with entity resolution enabled — `lxml.etree.parse` defaults, Java `DocumentBuilderFactory` without disabling `DOCTYPE`/external entities, .NET pre-4.5.2 `XmlReader` with `DtdProcessing` not prohibited. Not findings: `defusedxml`, `resolve_entities=False`/`no_network=True`, `disallow-doctype-decl`, `DtdProcessing.Prohibit`, `XmlResolver = null`.
- **Zip slip:** archive extraction joining member names into the destination without containment check or symlink handling.
- **Zip bomb:** extraction without limits on total uncompressed size or compression ratio.
- **Insecure temp files:** predictable temp paths (`/tmp/app_{user}.txt`) or world-writable permissions for sensitive data; not findings: `tempfile.NamedTemporaryFile`/`TemporaryDirectory`.
- **World-writable permissions introduced** (`chmod 777`/`666`) on files the change creates.

## Evidence gate

- Confirm the file path/content originates from attacker-influenced input within the reviewed scope and the sink is reachable from the changed path.
- Final severity comes from the Output Contract in SKILL.md, never from this reference.
