# Releases

> When to read: Read when the user asks to list, view, or download GitHub releases and their assets, or to diagnose release workflow runs.

## Ownership boundary

- Read-only release inspection (list/view/download) and workflow diagnosis stay here.
- Manual release creation happens only when explicitly authorized by `shipping-and-launch` and must consume its curated notes contract (single current release document `docs/releases/<tag>.md` via `--notes-file`); never run an autonomous git-pull / version-bump / commit / push / tag / generated-notes pipeline.
- Workflow-driven release mechanics (tag-only triggers, preflight hooks, publication) belong to `ci-cd-and-automation`; go/no-go and release content quality belong to `shipping-and-launch`.

## Creating Releases (authorized only)

```bash
# Create release from the curated release document
gh release create v1.0.0 --notes-file docs/releases/v1.0.0.md

# Create draft or prerelease
gh release create v1.0.0 --draft
gh release create v1.0.0-rc.1 --prerelease

# Attach files
gh release create v1.0.0 dist/*.tar.gz
```

Never use `--generate-notes`: release content follows the curated notes contract owned by `shipping-and-launch`.

## Managing Releases (read-only inspection)

```bash
# List releases
gh release list

# View release
gh release view v1.0.0

# Download release assets
gh release download v1.0.0

# Download from a public repo without authentication
gh release download v1.0.0 --repo owner/repo
```

`gh release download` works against public repositories without authentication (a token is still used when present), matching `gh extension install`.
