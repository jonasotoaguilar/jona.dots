# Authorization Detection Reference

Signal-triggered checks for the security lens. Load when the change adds or modifies endpoints/handlers, object lookups by identifier, file serving, or permission checks. Report only with confirmed impact within the reviewed scope.

## Reportable patterns

- **Missing per-request authorization:** new or changed endpoint/handler performing a state-changing or sensitive read without any permission/role/ownership check, while sibling endpoints enforce one. UI hiding or client-side checks are not authorization.
- **IDOR / horizontal escalation:** object fetched or mutated by user-controlled identifier (`/api/orders/<id>`, `User.query.get(user_id)`) without scoping the query to the current principal (e.g. `.filter_by(id=id, user_id=current_user.id)`), when the resource can belong to other principals.
- **Vertical escalation:** admin/privileged action (route under `/admin`, `is_admin`-gated UI) added or changed without a server-side role/privilege check; or a check removed.
- **Mass assignment:** `update(**request.json)` / `create(**request.data)` / bulk-assign patterns where the changed model has protected fields (role, is_admin, owner) not allowlisted.
- **Path traversal in file serving:** `send_file`/`open`/`readFile` on a user-controlled path joined to a base dir without `realpath` containment check (`path.startswith(base_dir)`).
- **Check bypass by change:** authorization moved from the endpoint to middleware that the new route bypasses; `@permission_classes`/decorators removed; allowlist widened.

## Mitigations (not findings unless removed)

- Deny-by-default with explicit grants; object-level checks (ownership/relationship) not just type-level; middleware/policy-object enforcement applied consistently; indirect references for user-scoped resources.

## Evidence gate

- Confirm the endpoint is reachable and the missing check is introduced/activated/worsened by the candidate. Pre-existing gaps outside the change are out of scope.
- Final severity comes from the Output Contract in SKILL.md, never from this reference.
