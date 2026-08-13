# Codebase Guide — Reference

## When to create `CODEBASE-GUIDE.md`

- Repos with multiple packages, layers, or integrations where a single README no longer covers the structure.
- Repos where new contributors regularly ask "where do I start?" or reviewers need boundary rules to verify intent.
- Projects with existing `ARCHITECTURE.md` or `DESIGN.md` that need a navigational index on top.

## When NOT to create it

- Small / single-package repos where `README.md` + directory listing is enough.
- Prototypes or throwaway code.
- Projects where every concern fits in one directory.

## Evidence to inspect before writing

- Directory tree (top 3 levels).
- `README.md` — does it already serve as a navigational index?
- `ARCHITECTURE.md` — if it exists, the Codebase Guide links to it instead of duplicating.
- Package managers / lockfiles — number of packages indicates complexity.
- Number of CI pipeline stages or deploy targets.

## Structure: index + detail pages

`docs/CODEBASE-GUIDE.md` is a concise navigational index, not a replacement for the docs it points to.

- For non-trivial repos (multiple packages, layers, or integrations), generate grounded detail pages under `docs/codebase/` — one page per concern, written from source, never generic filler.
- `docs/codebase/mental-model.md` is the foundational page: how the system fits together, entry points, and the primary flow, in reading order. Write it first; the guide's Mental Model section links to it and keeps a one-paragraph summary on the index itself.
- The guide links to the related docs it references throughout `docs/*` (PRD.md, ARCHITECTURE.md, DESIGN.md, README.md, guides). Never invent links: only link files that exist or that the user explicitly asked to create.
- Every `docs/codebase/` detail page links back to `docs/CODEBASE-GUIDE.md` so readers can always return to the index.

## Use CodeGraph when available

- Map entry points, core types, and call paths between layers.
- Verify the boundary rule by checking real cross-layer dependencies.
- Extract key file paths for the Guide Pages table and the mental-model page.

## Grounding and link validation

- Every path in the guide must exist at time of writing or be explicitly requested by the user.
- Do not invent `docs/codebase/*.md` pages. Generate a detail page only when the repo needs it; index only pages that exist or that the user asked to create.
- If a linked file is renamed or deleted after writing, update the guide or flag it stale.

## Upkeep

An existing codebase guide stays current:

- After setup or documentation changes that move paths, change packages, redraw boundaries, or add/remove docs, refresh the guide and its `docs/codebase/` detail pages instead of leaving stale links.
- Preserve valid existing content; merge the delta into the guide rather than regenerating it blindly.
- Never create a competing index: if `docs/CODEBASE-GUIDE.md` exists, it is the single navigational index for the repo.
