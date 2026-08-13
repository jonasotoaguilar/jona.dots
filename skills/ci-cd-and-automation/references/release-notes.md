# Curated Release Notes Contract

Every release publishes a **curated, narrative release body** — never a raw commit list, never an auto-generated changelog as the only body. This mirrors the gentle-ai pattern: meaningful sections, outcome-first prose, and PR/issue links, authored by the maintainer and reviewed in git before the release is authorized.

## Why curated

- A raw `git log` dump duplicates squash-merged commits, carries no context, and says nothing about *why* a release matters to its users.
- A narrative body (`## What changed` subsections, upgrade/install steps, verification, known issues) is readable by humans and links the work back to PRs and issues.

## The lifecycle (single current release document)

The project keeps **exactly ONE release document** at `docs/releases/<current-tag>.md` — never a template file, never one document per historical release. This matches gentle-ai's `docs/releases/`, which holds one current document at any time.

For a new release:

1. `git mv docs/releases/<old-tag>.md docs/releases/<new-tag>.md` (history preserved).
2. Replace the content with the filled-in template (skill asset `assets/release-notes-template.md` — the template lives in the skill's assets only and is **never** installed into a project as `docs/releases/TEMPLATE.md`).
3. Bump the package version, commit (review happens in git), then push the tag — the tag commit itself carries the reviewed notes.

## The contract (must hold in every release pipeline)

1. **Exactly one document.** The release preflight hook must fail the release when the release-notes directory has zero or multiple markdown documents.
2. **Name matches the tag.** The document must be `docs/releases/<RELEASE_TAG>.md`. A wrong filename (including a leftover template file) fails the release.
3. **Curated body.** The preflight hook must also fail the release when the document is empty, placeholder-filled, malformed (missing required sections), or mismatched to the tag/version (the H1 does not title the tag).
4. **Publication passes the file.** The publish hook creates the release from the curated notes file (`--notes-file`). Remove raw git-log generators and the auto-notes fallback (`--generate-notes`).

## Required structure

| Element | Requirement |
| --- | --- |
| H1 | `# vX.Y.Z — <short narrative title>` — must title the exact tag |
| Summary | One plain-language paragraph: what the release is for and who benefits |
| `## What changed` | Narrative subsections, one per meaningful change or theme (2–5), each with its PR link(s) |
| `## Upgrade` and/or `## Install` | Actionable install/upgrade steps for the project's real distribution channel |
| `## Verification` (optional) | What was verified before publishing; concrete numbers only |
| `## Known issues` (optional) | Honest limitations, each linked to its tracking issue; delete when nothing to report |

## PR/issue link guidance

- Every PR that delivered a change gets a link in its subsection: `[#N](https://github.com/{owner}/{repo}/pull/N)`.
- Every known issue gets a link: `[#N](https://github.com/{owner}/{repo}/issues/N)`.
- Prefer outcome sentences ("Deleting a session now records its usage exactly once") over commit subjects.

## Preflight validation checklist (implement in the preflight hook)

```bash
NOTES_DIR="docs/releases"
shopt -s nullglob
NOTES_CANDIDATES=("$NOTES_DIR"/*.md)
(( ${#NOTES_CANDIDATES[@]} == 1 )) || fail "expected exactly one release document in $NOTES_DIR"
NOTES_FILE="${NOTES_CANDIDATES[0]}"
[[ "$(basename "$NOTES_FILE")" == "${RELEASE_TAG}.md" ]] || fail "release document must be docs/releases/${RELEASE_TAG}.md (git mv the previous document)"
[[ -s "$NOTES_FILE" ]] || fail "release document is empty"
H1=$(grep -m1 -E '^# ' "$NOTES_FILE" || true)
[[ "$H1" == "# v${VERSION}" || "$H1" == "# v${VERSION} "* ]] || fail "notes H1 must title '# v${VERSION} ...'"
grep -qE '^## What changed' "$NOTES_FILE" || fail "notes must include a '## What changed' section"
grep -qE '^## (Upgrade|Install)' "$NOTES_FILE" || fail "notes must include an '## Upgrade' or '## Install' section"
grep -nE 'PLACEHOLDER|TODO|FIXME|TBD|Lorem ipsum|\{\{|\}\}' "$NOTES_FILE" && fail "notes contain unfilled placeholder markers"
shopt -u nullglob
```

Placeholder tokens are a denylist — extend it with the project template's own distinctive markers (e.g. `<short narrative title>`, `<Change or theme>`). Never match generic angle-bracket patterns: prose legitimately contains `<...>` (e.g. `R<read>|W<write>`), and template version tokens like `vX.Y.Z` can legitimately appear in prose that describes the tagging policy — the H1 check is the template-copy detector, not a string match.

## Anti-patterns

- The release body is a `git log --pretty=format` dump between tags.
- `--generate-notes` as the body (auto-changelog is a fallback tool, not the curated body).
- Notes authored after tagging (review must happen in git, before the tag).
- More than one document in `docs/releases/` (one per historical release) or a `TEMPLATE.md` installed alongside the current document.
- Template copied verbatim into the tag-named file (the H1 check catches it: `vX.Y.Z` ≠ `v1.2.3`).

## Assets

- `assets/release-notes-template.md` — reusable narrative template; lives only in the skill's assets. Fill it into the one tag-named release document and adapt the install/upgrade sections to the project's real channel.
- `shipping-and-launch/assets/github-release-template.md` — example-rich authoring variant (stable/prerelease/patch examples, asset and integrity conventions, workflow vs manual cuts) owned by `shipping-and-launch`. This skill owns the mechanics contract; that skill owns notes quality and authoring examples. Do not duplicate the lifecycle here.
