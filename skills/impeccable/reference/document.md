# Document: extract grounded visual evidence for DESIGN.md

`document` inspects existing UI/code and extracts grounded visual evidence about the incumbent visual system. It never writes DESIGN.md and never makes design decisions.

Ownership:

- `design-ui` owns visual/UI design decisions (what to design and why).
- `documentation` owns the DESIGN.md template, schema/structure, writing/merging, and validation.
- This workflow produces the evidence and the handoff: if decisions are missing, hand off to `design-ui`; if decisions are approved/existing, emit a clearly typed payload for `documentation`.

## Hard rules

- **Never write DESIGN.md.** This workflow never generates, writes, or regenerates DESIGN.md and never maintains a competing schema. DESIGN.md writing/merging and validation belong to `documentation`; the canonical structure and token schema are `documentation`'s contract (`../../documentation/references/design-md-structure-and-rules.md`), not this one.
- **Decisions are not made here.** If design decisions are missing, hand off to `design-ui` with the extracted evidence. Never invent tokens, roles, color names, or rules.
- **Evidence only.** Every payload entry cites the inspected source (file, element, computed value). Nothing is asserted from memory or taste.
- **Sidecar is derived.** `.impeccable/design.json` is a private derived sidecar, generated only from an already integrated DESIGN.md; it is never an authority and never written in place of DESIGN.md.

## When to run

- New-work found a coherent incumbent visual system but no `DESIGN.md`.
- An existing `DESIGN.md` is stale (the design has drifted) and its decisions are already approved.
- Before a large redesign, to capture the current state as reference evidence.

If a `DESIGN.md` already exists, read it as the approved decision source and map evidence to it; do not overwrite or merge it yourself. If decisions are missing or not yet approved, stop and hand off to `design-ui`.

## Step 1: Inspect the design assets

Search the codebase in priority order:

1. **CSS custom properties**: grep for `--color-`, `--font-`, `--spacing-`, `--radius-`, `--shadow-`, `--ease-`, `--duration-` declarations in CSS files (usually `src/styles/`, `public/css/`, `app/globals.css`). Record name, value, and defining file.
2. **Tailwind config**: if `tailwind.config.{js,ts,mjs}` exists, read `theme.extend` for colors, fontFamily, spacing, borderRadius, boxShadow.
3. **CSS-in-JS theme files**: styled-components, emotion, vanilla-extract, stitches; look for `theme.ts`, `tokens.ts`, or equivalent.
4. **Design token files**: `tokens.json`, `design-tokens.json`, Style Dictionary output, W3C token format.
5. **Component library**: scan the main button, card, input, navigation, dialog components; note variant APIs and default styles.
6. **Global stylesheet**: the root CSS file usually holds base typography and color assignments.
7. **Visible rendered output**: if browser automation tools are available, load the live site and sample computed styles from key elements (body, h1, a, button, .card). This catches values tokens miss.

## Step 2: Extract grounded evidence

- **Colors**: group into Primary / Secondary / Tertiary / Neutral. If the project has only one accent, express it as Primary + Neutral; omit Secondary and Tertiary rather than inventing them.
- **Typography**: map observed sizes/weights to the hierarchy (display / headline / title / body / label); note font stacks and scale ratio.
- **Elevation**: catalogue the shadow vocabulary. If the project is flat and uses tonal layering instead, that's a valid answer; state it explicitly.
- **Components**: for each common component (button, card, input, chip, list item, tooltip, nav), extract shape (radius), color assignment, hover/focus treatment, internal padding.
- **Layout + spacing**: grid, container, breakpoint, rhythm, and density behavior.
- **Shapes**: radius, corner, border, clipping, recurring form behavior.

Skip anything the project doesn't have. Every entry carries its source.

## Step 3: Determine the decision state

- **Approved/existing:** DESIGN.md (or an approved design contract) covers the surface. Map the extracted evidence to the approved decisions.
- **Missing:** no DESIGN.md, or gaps in tokens/decisions. Hand the evidence to `design-ui` with the named gaps; do not fill them yourself.
- **Qualitative language** (creative north star, overview voice, color character, named rules) is a design decision: route to `design-ui`, never invent it.

## Step 4: Emit the typed payload for `documentation`

The payload is the deliverable. `documentation` writes or merges DESIGN.md from it. Fields:

- `scope` — surfaces inspected.
- `evidence` — extracted tokens/values with source paths (Steps 1-2).
- `decision-state` — `approved` | `missing`.
- `mapping` — evidence → approved DESIGN.md entries, when decisions exist.
- `gaps` — named missing decisions handed to `design-ui`.
- `sidecar` — whether `.impeccable/design.json` was derived from the integrated DESIGN.md.

## Step 5: `.impeccable/design.json` sidecar (private, derived)

The sidecar carries what the DESIGN.md schema can't hold (tonal ramps, canonical OKLCH when the hex is an approximation, shadows, motion, component HTML/CSS snippets, narrative). It is generated ONLY from an already integrated DESIGN.md — a file `documentation` wrote or merged — and is never an authority.

- Refresh it when the integrated DESIGN.md changes; preserve DESIGN.md when the user only asks to refresh the sidecar.
- Never generate it in place of DESIGN.md, and never before DESIGN.md exists.
- Its schema is Impeccable's private concern: `schemaVersion` 2, `extensions` keyed by frontmatter token names (`colorMeta.<token-name>`, `typographyMeta`, `shadows`, `motion`, `breakpoints`), `components` (self-contained drop-in HTML/CSS snippets prefixed `ds-`, tokens resolved to literal values or `var(--...)`, icons inlined as SVG, `:hover`/`:focus-visible`/`:active` included), and `narrative` pulled verbatim from the integrated DESIGN.md (north star, overview, key characteristics, rules, dos/donts).

## Step 6: Confirm

1. Show the user the payload and the handoff: `documentation` writes/merges DESIGN.md from it; `design-ui` approves decisions when missing.
2. Mention the sidecar only if it was derived from an integrated DESIGN.md.

## Seed mode

No implementation to inspect, so there is nothing to extract. The visual-world direction is a design decision: route it to `design-ui` (new-work's workshop provides the direction input; load [new-work.md](new-work.md) for it). `documentation` writes the seed DESIGN.md once decisions are approved. Re-run this workflow in scan mode once there's code.

## Pitfalls

- Don't write, regenerate, or "seed" DESIGN.md — that is `documentation`'s write, and schema ownership is its contract.
- Don't invent tokens, color roles, names, or rules; route gaps to `design-ui`.
- Don't paste raw CSS class names; translate to descriptive evidence.
- Don't extract every token — stop at what's actually reused.
- Don't generate the sidecar before an integrated DESIGN.md exists, and never treat it as authority over the file.
