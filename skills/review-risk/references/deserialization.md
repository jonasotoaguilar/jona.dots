# Insecure Deserialization Detection Reference

Signal-triggered checks for the security lens. Load when the change deserializes data from any untrusted boundary (requests, storage attacker-influenced data reaches, message queues, model output). Report only with confirmed attacker-influenced source and reachable impact.

## Reportable patterns (language → dangerous sink)

- **Python:** `pickle.loads()`/`load()` (and `cPickle`, `shelve`), `yaml.load()` without `SafeLoader` (pre-5.1 default loads arbitrary objects), `marshal.loads()`.
- **Java:** `ObjectInputStream.readObject()` without class allowlist, `XMLDecoder`, XStream ≤ 1.4.6 / without `allowTypes`, SnakeYAML `load()` on untrusted input.
- **.NET:** `BinaryFormatter` (never secure), `NetDataContractSerializer`, `ObjectStateFormatter`, JSON.NET `TypeNameHandling` other than `None`.
- **PHP:** `unserialize()` on user input without `allowed_classes` (object injection via `__wakeup`/`__destruct`).
- **Ruby:** `Marshal.load()`, `YAML.load()` (unsafe by default), `JSON.parse(..., create_additions: true)`.
- **Node.js:** `node-serialize`/`unserialize()`, older `js-yaml` `load()` without `SAFE_SCHEMA`, eval-based parsing.

## Not findings

- `json.loads`/`JSON.parse`/`System.Text.Json`/`JsonSerializer` with typed targets, `yaml.safe_load`, `YAML.safe_load`, `js-yaml` safe schema, `unserialize(..., allowed_classes)`, ObjectInputStream with an explicit class allowlist, signed serialized data verified with constant-time comparison, schema-validated parsing (Joi/Zod/jsonschema/pydantic).

## Evidence gate

- Confirm the untrusted source reaches the sink within the reviewed scope and the sink is reachable from the changed path. Do not report deserialization of server-generated data.
- Final severity comes from the Output Contract in SKILL.md, never from this reference.
