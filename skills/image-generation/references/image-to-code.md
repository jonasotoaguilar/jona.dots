# Image-to-Code: Analysis & Handoff (Implementation Role)

Contract for implementation requests from images. This skill NEVER writes code: it generates or collects reference images, analyzes them deeply, and returns a typed handoff to the implementation owner (`frontend-ui-engineering`; `impeccable` only when explicitly selected for refinement implementation).

## Mandatory Flow

Reference images first → deep analysis second → typed handoff third. Never start with freeform coding, never skip straight to implementation, never rely on memory of "good frontend taste" instead of the actual reference. The image is the design source; the code is the implementation owner's translation layer.

Trigger image-first whenever the request is mainly visual: hero, premium landing, redesign, polished marketing page, portfolio, multi-section concept. Direct-code-first belongs to the implementation owner when the task is mostly technical.

## Section Image Rules

- One section = one primary image; one complex section = primary + optional detail images.
- Never compress many sections into one image if text/spacing/buttons/layout details become too small to analyze.
- Never crop/zoom/slice a section out of a previously generated larger image — cropping destroys spacing accuracy, type scale relationships, margins, proportions, button clarity, and implementation fidelity. Regenerate a FRESH standalone image (same palette, typography mood, button style, radius logic, brand world — but larger text, clearer spacing, more inspectable buttons) when detail is unclear.
- Optional detail/extraction images: closer hero render; detail renders for pricing cards, testimonials, navbar, feature cards, footer/CTA; typography/spacing-focused images. Use them whenever detail is unclear.

## Clean Analysis Standard

No vague vibe analysis; do not jump from image to handoff. For every section image inspect: what the section is, visual priority, readable text, typography relationships, spacing relationships, buttons/controls, card/block logic, dominant colors, structural rhythm, unclear details.

Deep extraction (treat images like a design spec): exact visible text (headlines, subheads, CTAs, section titles); typography character + scale relationships + weight + line count/wrapping + tracking; alignment logic; section/internal spacing, padding/gutters; card dimensions/rhythm; radius logic; strokes/dividers; button shapes/hierarchy/padding; hover-implied styling; palette + accents; background/image/icon treatment; shadows/depth; grid logic; layout structure; section ordering/density/rhythm; repeated motifs.

If something is unclear, generate another image before handing off. Analysis should be calm, structured, exact, faithful, implementation-aware.

## Layout Rules for Generated References

- **Responsive first view**: the above-the-fold area must stay clean on a small laptop — clear headline, readable support text, clean spacing, visible CTA, balanced visual focal point.
- **Anti-nested-box**: no giant rounded wrappers around everything, cards inside cards, "prison of containers". Prefer open layouts, clearer whitespace, fewer stronger containers, one primary framing move.
- **Reduce micro-UI clutter**: no unnecessary pills, pseudo-system markers, fake control labels, decorative code-like tags, filler chips, fake dashboard jargon.
- **Fixed media frames**: fixed-aspect media blocks, clearly framed areas, repeatable modules, consistent radius logic, stable proportions.

## Handoff Contract

Return a typed handoff containing:

- **Owner**: `frontend-ui-engineering` (or `impeccable` when explicitly selected for refinement implementation).
- **Scope**: surfaces/sections covered by the references.
- **Extracted tokens**: palette, type scale/character, spacing, radius, shadows, component family, layout structure, section order.
- **Fidelity constraints**: anti-drift rules (do not simplify into default templates, do not compress generous spacing, do not flatten strong typography).
- **Missing-detail resolution order**: preserve visible design language → preserve layout/spacing logic → preserve component family → generate an extra detail image → regenerate the section fresh → only then the most implementation-friendly faithful version.
- **Paths**: reference image paths the owner must read.

Never: write code, make design decisions beyond the brief, or invent missing details silently.
