# {project-name} Codebase Guide

<!--
  A concise navigational index for maintainers, contributors, and reviewers.
  NOT an API reference, NOT a README replacement, NOT an architecture doc.
  Every link below must point to a file that exists or one the user explicitly asked to create.

  Structure for non-trivial repos (multiple packages, layers, or integrations):
  - This file is the index; grounded detail pages live under docs/codebase/ and expand one concern each.
  - docs/codebase/mental-model.md is the foundational page and is always present.
  - Every detail page links back to this guide.
-->

## Audience

| Role | What this guide gives them |
|------|---------------------------|
| **New contributor** | Where to start and which files to read first |
| **Maintainer** | Where each concern lives and the boundary rules |
| **Reviewer** | What belongs where and how to verify intent |

## Mental Model

<!-- One paragraph describing the system in ~90 seconds. -->
<!-- Example: "This is a layered service: HTTP handlers in cmd/, business logic in internal/, storage in internal/store/." -->

{project-name} is: {one-sentence description}.

- `docs/codebase/mental-model.md` — {what-this-foundational-page-covers; write it first and keep it current}

## Golden Rule

<!-- Every file or directory belongs to exactly one concern. If a change touches more than two layers, reconsider the design. -->

{placement-boundary-rule}

## Guide Pages

<!-- For small / single-package repos, point rows directly at existing files.
     For non-trivial repos, point each row at a detail page under docs/codebase/ with a summary line here;
     the page itself owns the details and links back to this guide. -->

| Page | What it covers | Key files |
|------|---------------|-----------|
| `docs/codebase/mental-model.md` | {foundational mental model of the system} | `{key-file1}`, `{key-file2}` |
| `{path-to-page}` | {what-this-page-covers} | `{key-file1}`, `{key-file2}` |

## Recommended Reading Path

1. {first-thing-to-read}
2. {second-thing-to-read}
3. {third-thing-to-read}

## Existing References

<!-- Link to related docs that already exist or were requested under docs/*. Never invent links. -->

- `README.md` — {one-line scope}
- `ARCHITECTURE.md` — {one-line scope if exists, otherwise omit}
- `docs/{reference}` — {one-line scope}

## Next Step

{what-to-do-with-this-guide — e.g. "Explore the guide pages above, then open a PR."}
