# Pre-flight and Non-Destructive Redesign

Load when proposing design changes into a project that already has UI, or when redesigning an existing page/site/app. Run the pre-flight scan before proposing anything; apply the preservation rules before restructuring.

## Pre-flight scan

Inspect the existing design evidence before proposing changes, and report findings with file:line citations:

- **`DESIGN.md`** — the locked design system. Read it first; proposals defer to it.
- **Design tokens** — `:root` custom properties, `tailwind.config.*` theme values, `tokens.json` / DTCG files.
- **Fonts** — `next/font`, `@fontsource/*`, Google Fonts links, `theme.extend.fontFamily`.
- **Palette** — colour values in `:root`, `theme.extend.colors`, token files.
- **Spacing** — `--space-*` scale, Tailwind spacing extension, 4/8-pt scale presence.
- **Framework** — Next.js, Astro, Vue, SvelteKit, Remix, vanilla.
- **Motion stance** — motion libraries installed (framer-motion, motion, gsap, lenis, lottie): "motion-on" vs "motion-cut".

Emit the findings as an accountability block before proposing: what exists, what you will preserve, what you will introduce. Flag conflicts explicitly (e.g. `next/font` Geist plus a hard-coded `font-family: Inter`) and ask before overriding any preserved item. Preserve existing evidence — never silently replace an established palette or font stack.

## Non-destructive redesign

Redesign replaces the visual/interaction layer within the existing boundaries. It does not bulldoze the codebase:

- **Preserve:** routes, information architecture (sections and rough order), product truth (factual claims, copy intent, product names), working logic (data fetching, auth, forms, analytics, integrations), and route/component ownership boundaries.
- Default to in-place edits of the named files, or additive components/tokens wired through existing routes.
- **Deletions and restructures** (removing multiple components, replacing a route tree, collapsing pages into one) require explicit user approval of a file-level plan first.
- State the files you expect to modify/create/delete before editing; any deletion needs confirmation.
- Treat docs, READMEs, PDFs, and transcripts as reference material — summarize and adapt; never paste them verbatim as page copy unless the user asks for verbatim text.
