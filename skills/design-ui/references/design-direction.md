# Design Direction

> Load when the request needs a **direction decision**: brief inference, dial configuration, system-vs-aesthetic routing, typography / color / layout / materiality, anti-template, or content honesty. Landing pages, portfolios, and redesigns — not dashboards, not data tables, not multi-step product UI. Every rule is **contextual**; none fires automatically. First read the brief, then pull only what fits.

Opinionated where the principle is universal (avoid category reflex, semantic tokens, motion with intent); permissive where the right answer is contextual (color, typography, layout).

## 0. Brief inference

Before touching code, infer what the user actually wants. Most LLM design output is bad because the model jumps to a default aesthetic instead of reading the room.

1. **Page kind** — landing (SaaS / consumer / agency / event), portfolio (dev / designer / creative studio), redesign (preserve vs overhaul), editorial / blog.
2. **Vibe words** the user used — "minimalist", "Linear-style", "Awwwards", "brutalist", "premium consumer", "Apple-y", "editorial", "dark tech".
3. **Reference signals** — URLs, screenshots, named products, competitor brands.
4. **Audience** — B2B procurement panel vs design-conscious consumer vs recruiter. The audience picks the aesthetic, not your taste.
5. **Existing brand assets** — logo, color, type, photography. For redesigns these are starting material (see `redesign-protocol.md`).
6. **Quiet constraints** — accessibility-first audiences, public-sector, regulated industries, trust-first commerce, kids' products. These OVERRIDE aesthetic preference.

**Output a one-line "Design Read" before any code**: `"Reading this as: <page kind> for <audience>, with a <vibe> language, leaning toward <design system or aesthetic family>."`

- If the brief is ambiguous, ask exactly **one** clarifying question — never a multi-question dump — and only when the read genuinely diverges. If you can confidently infer, do not ask.
- **Anti-default discipline.** Do not default to: AI-purple gradients, centered hero over dark mesh, three equal feature cards, generic glassmorphism on everything, infinite-loop micro-animations, Inter + slate-900. Reach past them deliberately based on the read.

## 1. The three dials

Set after the design read; every layout, motion, and density decision is gated by these:

- **`DESIGN_VARIANCE: 8`** — 1 = Perfect Symmetry, 10 = Artsy Chaos
- **`MOTION_INTENSITY: 6`** — 1 = Static, 10 = Cinematic / Physics
- **`VISUAL_DENSITY: 4`** — 1 = Art Gallery / Airy, 10 = Cockpit / Packed Data

Baseline `8 / 6 / 4` unless the read overrides them; overrides happen conversationally, never by editing this file. Cross-references use these exact names — never invent aliases like `LAYOUT_VARIANCE`.

### Dial inference (read → values)

| Signal                                                           | VARIANCE       | MOTION | DENSITY        |
| ---------------------------------------------------------------- | -------------- | ------ | -------------- |
| minimalist / clean / calm / editorial / Linear-style             | 5-6            | 3-4    | 2-3            |
| premium consumer / Apple-y / luxury / brand                      | 7-8            | 5-7    | 3-4            |
| playful / wild / Awwwards / experimental / agency                | 9-10           | 8-10   | 3-4            |
| landing / portfolio / marketing (default)                        | 7-9            | 6-8    | 3-5            |
| trust-first / public-sector / regulated / accessibility-critical | 3-4            | 2-3    | 4-5            |
| redesign - preserve                                              | match existing | +1     | match existing |
| redesign - overhaul                                              | +2             | +2     | match existing |

### Use-case presets

| Use case                       | VARIANCE   | MOTION  | DENSITY |
| ------------------------------ | ---------- | ------- | ------- |
| Landing (SaaS mainstream)      | 7          | 6       | 4       |
| Landing (Agency / creative)    | 9          | 8       | 3       |
| Landing (Premium consumer)     | 7          | 6       | 3       |
| Portfolio (Designer / studio)  | 8          | 7       | 3       |
| Portfolio (Developer)          | 6          | 5       | 4       |
| Editorial / Blog               | 6          | 4       | 3       |
| Public-sector service          | 3          | 2       | 5       |
| Redesign - preserve / overhaul | match / +2 | +1 / +2 | match   |

## 2. Brief → design system map

- **Official system** (Fluent, Material, Carbon, Polaris, Atlassian, Primer, GOV.UK, USWDS, Bootstrap, Radix, shadcn, Tailwind): the package decision — which system, when, install command, canonical docs — is a library pick from `libraries/design-systems.md`. Do not install or recreate the system here.
- **Do not recreate an official system by hand**; one system per project (no Fluent + Carbon in one tree, no shadcn inside Material); do not import a system's tokens and override 90% of them.
- **An aesthetic trend is not an official system** — and an official system is not an aesthetic.

### Aesthetic (no official package): build with native CSS + Tailwind + a maintained component library; label borrowed inspiration honestly in comments

| Aesthetic                                                       | Honest implementation                                                                                                                                                                                                                                   |
| --------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Glassmorphism / "frosted glass"                                 | `backdrop-filter`, layered borders, highlight overlays; solid-fill fallback for `prefers-reduced-transparency`                                                                                                                                          |
| Bento (Apple-style tile grids)                                  | CSS Grid with mixed cell sizes. No library owns this                                                                                                                                                                                                    |
| Brutalism / Dark tech / Editorial / Aurora / Kinetic typography | Native CSS (mono, raw borders; serif + asymmetric grid; SVG/layered radial gradients; CSS + scroll-driven animations, GSAP for hijacks)                                                                                                                 |
| **Apple Liquid Glass**                                          | Apple documents it for Apple platforms only; no official `liquid-glass.css`. Web = approximation with `backdrop-filter` + layered borders + highlights, labeled as such. CSS skeleton lives in `frontend-ui-engineering` (`../../frontend-ui-engineering/references/liquid-glass.md`) |

W3C anchors for the native implementations: MDN `backdrop-filter`, `@media prefers-color-scheme`, `@media prefers-reduced-motion`, CSS Grid, scroll-driven animations.

## 3. Atmosphere and color strategy

Name the atmosphere before picking tokens. One sentence of physical scene: who uses this, where, under what ambient light, in what mood. If the sentence doesn't force a clear answer, add detail until it does. Commit the three axes (density, variance, motion) through the dials in § 1 — default only when intent isn't expressed.

Pick the color strategy before picking colors. Four steps:

- **Restrained** — tinted neutrals + one accent ≤10%. Product default; brand minimalism.
- **Committed** — one saturated color carries 30–60% of the surface. Brand default for identity-driven pages.
- **Full palette** — 3–4 named roles, each deliberate. Campaigns, data viz.
- **Drenched** — the surface IS the color. Brand heroes, campaign pages.

For every color, define a **functional role** (surface, on-surface, primary, accent, danger, focus, border, muted) before the value. Semantic tokens, not raw hex in components. Tinted neutrals add 0.005–0.015 chroma toward the brand's hue — never default-tint warm or cool. Pure black/white aren't banned; near-black/near-white is usually the better answer for softer contrast.

### Color calibration

- **Max 1 accent by default; saturation < 80%.** If `DESIGN.md` commits a full-palette strategy (3–4 named roles), the contract wins.
- **The Lila rule.** "AI purple/blue glow" is discouraged as default: no automatic purple glows, no random neon gradients. Neutral bases (Zinc/Slate/Stone) + high-contrast singular accents (Emerald, Electric Blue, Deep Rose, Burnt Orange). Override only when the brand/brief asks for purple — then execute with intent: consistent palette, harmonised neutrals, restrained gradients.
- **One palette per project.** No fluctuating between warm and cool grays within the same project.
- **COLOR CONSISTENCY LOCK:** once chosen (single accent or full-palette roles), applied consistently on the WHOLE page. A warm-grey site does not get a blue CTA in section 7.
- **PREMIUM-CONSUMER PALETTE BAN (second most-recurring AI tell):** for cookware/wellness/artisan/luxury briefs the LLM default is warm beige/cream + brass/clay/oxblood/ochre + espresso text. Banned as default reach: `#f5f1ea`-family backgrounds, `#b08947`-family accents, `#1a1714`-family text. Default alternatives (rotate, do not reuse): Cold Luxury (silver-grey + chrome + smoke); Forest (deep green + bone + amber); Black and Tan (off-black + warm tan); Cobalt + Cream; Terracotta + Slate; Olive + Brick + Paper; pure monochrome + one saturated pop. If the previous premium-consumer project used the beige+brass family, this one MUST use a different family. Override only when the brief explicitly names those colors or the brand is genuinely vintage/artisan AND you can justify it.

## 4. Typography

Architecture (universal):

- **Display** — track-tight, controlled scale. Hierarchy through weight and color, not novelty.
- **Body** — relaxed leading, line length 60–75ch (cap at 65 for editorial density).
- **Mono / numerics** — code, metadata, timestamps, high-density numbers. `font-variant-numeric: tabular-nums` for data columns.

Don't pair similar-but-not-identical fonts (two geometric sans-serifs, two humanist sans-serifs). Pair on a contrast axis (serif + sans, geometric + humanist) or use one family in multiple weights.

**Font selection is contextual.** "No Inter" isn't universal — Inter is fine for software/dashboard UI and rapid iteration. For premium/editorial/brand work, choose distinctive character. Document the choice and reason in `DESIGN.md`. Generic serifs (`Times`, `Georgia`, `Garamond`, `Palatino`) are off-key in software UIs; for editorial, pick a distinctive modern one.

Landing / marketing specifics:

- **Display / Headlines:** `text-4xl md:text-6xl tracking-tighter leading-none`. **Body:** `text-base text-gray-600 leading-relaxed max-w-[65ch]`. No more than five type sizes per page — use weight and color for further hierarchy.
- **Sans choice (Inter is contextual, not banned).** Avoid Inter as the brand/premium default for marketing, portfolio, premium-consumer surfaces (reads as LLM default); pick Geist, Outfit, Cabinet Grotesk, Satoshi, or a brand-appropriate serif first. Inter is valid for software/dashboard UI, rapid iteration, explicitly-requested neutral/Linear-style briefs, and public-sector sites.
- **SERIF DISCIPLINE (very discouraged as default).** "Creative / premium / editorial" is NOT a reason to reach for serif — it is the most-tested AI tell. Acceptable only when the brief names a serif font, or the family is genuinely editorial / luxury / publication / heritage AND you can articulate why this specific serif fits this brand. Banned as defaults: `Fraunces` and `Instrument_Serif` (LLM favorites). Rotate the chosen serif across projects; never reuse the same one consecutively. Emphasis uses italic/bold of the SAME font — never a random serif word inside a sans headline.
- **ITALIC DESCENDER CLEARANCE (mandatory):** italic display words with `y g j p q` need `leading-[1.1]` minimum plus `pb-1`/`mb-1` reserve; audit every italic display word.
- **Hero headline sizing heuristic:** ≤20 chars full display scale; 21–50 chars default sweet spot (step down if it wraps past 2 lines); 51–90 chars step down one rung, consider eyebrow + shorter headline; >90 chars rewrite shorter. Authoring headlines yourself: ≤7 words / ≤50 chars, imperative or nominal phrase, never a gerund opener. A 4-line hero headline is always a font-size error, never a copy-length error.

## 5. Component states, layout, and materiality

For every interactive component, define every state explicitly: default, hover, active, focus-visible, disabled, loading, selected, invalid, empty. Use data attributes (`data-state`, `data-disabled`, `data-invalid`, `data-loading`). Single source of state ownership; small APIs; composition/slots over polymorphism; document keyboard behavior.

Every element occupies its own clear spatial zone — no absolute-positioned stacking. Grid for 2D, Flex for 1D. Semantic z-index scale (dropdown → sticky → modal-backdrop → modal → toast → tooltip); never arbitrary `999`. Contain layouts with `max-width`; `repeat(auto-fit, minmax(280px, 1fr))` for responsive grids without breakpoints. Full-height sections use `min-h-[100dvh]`, never `h-screen`. Vary spacing for rhythm. Cards are the lazy answer; nested cards are always wrong.

Mobile-first, single-column below 768px, no horizontal scroll on mobile, touch targets ≥44×44pt, headlines scale via `clamp()`, body minimum `1rem`/`14px`, landscape must remain readable.

### Layout diversification

- **ANTI-CENTER BIAS:** centered hero/H1 avoided when `DESIGN_VARIANCE > 4`; force split-screen (50/50), left-aligned content / right-aligned asset, asymmetric whitespace, or scroll-pinned structures. Override: centered hero is OK for editorial / manifesto / launch-announcement briefs where the message IS the design.

### Materiality, shadows, cards

- Cards only when elevation communicates real hierarchy; otherwise group with `border-t`, `divide-y`, or negative space.
- Tint shadows to the background hue; no pure-black drop shadows on light backgrounds.
- For `VISUAL_DENSITY > 7`: generic card containers are banned; data metrics breathe in plain layout.
- **SHAPE CONSISTENCY LOCK:** ONE corner-radius scale per page — all-sharp, all-soft (12–16px), or all-pill — or a documented rule (e.g. "buttons full-pill, cards 16px, inputs 8px") followed everywhere.

### Page theme lock

- The page has ONE theme (light, dark, or auto); sections do not invert. Section-level tints within the same family are fine (`bg-zinc-950` next to `bg-zinc-900`); flipping to `bg-amber-50` mid-page is broken. One deliberate "Color Block Story" / "Theme Switch on Scroll" device is allowed once per page.
- With system theming (Radix Themes, shadcn `<Theme>`), set the theme ONCE at the page root; sections never override.

## 6. Motion intent

Motion is part of the build, not an afterthought. Each animation has intent: state-change, spatial-continuity, focus-attention, or feedback. Decorative-only animation is rarely right.

**`ui-motion` is the motion authority.** This section states intent only; for values (easing, durations, springs, stagger, interruptibility, reduced-motion fallbacks, audit checklists) load `ui-motion` — never duplicate its tables here.

Intensity bands (`MOTION_INTENSITY`): 1-3 static (CSS hover/active only; reduced-motion is the default mode anyway); 4-7 fluid CSS (`transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1)`, `animation-delay` cascades, transform/opacity); 8-10 advanced choreography (scroll-triggered reveals, parallax, scroll-driven animation via CSS `animation-timeline` or GSAP ScrollTrigger, Motion hooks). **NEVER `window.addEventListener('scroll')`** — a hard ban; see `frontend-ui-engineering` implementation-guardrails for allowed alternatives.

## 7. Anti-template / AI tells

The strongest test for "looks AI-generated": would someone guess the theme + palette from the category alone? Run at two altitudes:

- **First-order reflex** — if the domain alone predicts the aesthetic (e.g. "AI workflow tool → SaaS cream"), rework the scene sentence and strategy until the answer isn't obvious.
- **Second-order reflex** — if the answer is "the alternative to the AI reflex" (e.g. "fintech that's not navy-and-gold → terminal dark"), that's the trap one tier deeper. Rework until neither answer is obvious.

This is the universal principle. It outlives any specific aesthetic preference, palette, or font ban.

### Template structure (repeated, templated layout)

Avoid these signatures unless the brief explicitly asks for them. Each is an observable product/design defect, not a taste preference:

- **NO 3-column equal feature cards.** The generic "three identical cards" feature row is banned — use 2-column zig-zag, asymmetric grid, scroll-pinned, or horizontal-scroll alternatives.
- **Section-layout repetition ban.** Each layout family at most ONCE per page; an 8-section landing uses ≥ 4 different families.
- **ZIGZAG ALTERNATION CAP.** Max 2 consecutive image+text splits; the 3rd is a Pre-Flight Fail — break with a full-width, vertical-stack, bento, or marquee section.
- **SPLIT-HEADER BAN.** "left big headline + right small explainer" as a section header is banned as default — stack headline + body vertically (max 65ch); the split is acceptable only when the right column carries a visual or interactive element.
- **BENTO CELL COUNT RULE.** Exactly as many cells as content — 3 items → 3 cells (1+2, 2+1, asymmetric trio); no empty middle/end cells; re-shape the grid, never paste a blank tile.
- **Bento background diversity.** At least 2-3 cells in any multi-cell grid carry real visual variation (image, gradient, pattern, tint); never all-white cards.
- **EYEBROW RESTRAINT.** Max 1 eyebrow per 3 sections (hero counts as 1); count `uppercase tracking` micro-labels above headlines; count > ceil(sectionCount / 3) fails. Labels are an ordinal device, valid only for genuine numbering/chaptering or explicit user request.
- **Split/duplicate intents.** No two CTAs with the same intent ("Get in touch" + "Let's talk"); one primary CTA per decision area.
- **Marquee max-one-per-page.** No two horizontal marquees on the same page.
- **Hero stack discipline.** Max 4 text elements in hero (eyebrow OR brand strip, headline, subtext, CTAs); no tiny tagline below CTAs, no trust micro-strip, no pricing teaser, no feature bullets, no avatar row in the hero — all move to dedicated sections below.
- **"Used by" / "Trusted by" logo wall belongs UNDER the hero**, never inside it.
- **Universal AI tells.** Side-stripe accent borders; gradient text; glassmorphism as decoration; identical card grids; tracked uppercase eyebrow on every section; numbered section markers as scaffolding; generic names; fake round numbers; AI copywriting clichés ("Elevate", "Seamless", "Unleash", "Next-Gen"); filler UI text ("Scroll to explore", scroll arrows, bouncing chevrons); broken image links or generic stock imagery as default.

### Content honesty (fabricated or placeholder content)

- **NO generic names** ("John Doe", "Sarah Chan") and NO generic avatars — use creative, realistic, locale-appropriate names and believable photos or specific styling.
- **NO fake-perfect numbers** (`99.99%`, `1234567`) — organic, messy data (`47.2%`, `+1 (312) 847-1928`) from real sources, or a labelled placeholder.
- **NO fake-precise specs** — AI-invented spec aesthetics (`92%`, `4.1×`, `5.8 mm`) are banned unless the values come from real data or are explicitly labeled as mock.
- **Honest proof.** No fabricated metrics, testimonials, logos, or case-study counts; use supplied facts, an explicitly labelled pending placeholder, or a different structure without the proof slot. Fix in order: replace the number with a labelled placeholder ("metric to confirm"); ask the user for the real number; rebuild the section without the proof slot — a stat-led layout with no real stats is the wrong layout.

### Dishonest assets

- **NO div-based fake screenshots / fake product UI** (fake task list, fake terminal, fake dashboard built from styled divs) — the #1 LLM-design tell. Real screenshot, generated image, real component preview, or none.
- **NO re-drawn chrome.** Never redraw browser bars (URL pill + traffic-light dots), phone frames (rounded rectangle + notch), code-window chrome (mock title bar + dots around a `<pre>`), or IDE chrome in HTML/CSS/SVG. Real screenshot in a `<figure>` with at most a hairline border; transparent-PNG device frame or real product photograph for phones; the system `<pre>` with a typographic frame for code.
- **NO plain-text logo wordmarks** in "Trusted by" walls — real SVG logos (Simple Icons `https://cdn.simpleicons.org/{slug}/ffffff`, devicon) or a generated monogram SVG, rendered in light and dark mode.
- **NO broken image links** — `https://picsum.photos/seed/{descriptive-string}/{w}/{h}` or generated/actual assets.
- **NO hand-rolled SVG icons** — Phosphor / HugeIcons / Radix / Tabler (Lucide on explicit request only).

### Emoji policy

As content (celebratory 🎉 in a toast, category emoji in editorial copy) — valid, intentional. As a functional icon (navigation, settings, system controls, status indicators) — use a vector icon (SVG / Lucide / Heroicons / native set). Emojis are font-dependent, inconsistent across platforms, not themable. Encode the project policy in `DESIGN.md`.

## 8. Content density

Landing pages live on the first impression, not the full read. Cut ruthlessly.

- **Default content shape per section:** headline (≤ 8 words) + sub-paragraph (≤ 25 words) + one visual asset OR one CTA.
- **No data-dump sections:** a 20-row publication table or 30-row award list is the wrong layout — top 3-5 highlights + "View full list", marquee/carousel for breadth, or a different page if the data is the product.
- **Long lists need a different UI component, not a longer list:** for >5 items use a 2-column split, card grid, tabs/accordion, horizontal scroll-snap pills, carousel, or marquee.
- **Spec sheets:** banned as the default for cookware/hardware/apparel/artisan briefs. Alternatives: 2-col card grid (spec name, large display value, one-line "why it matters"), scroll-snap pills, grouped chunks with one divider per cluster, or featured-vs-rest with a "View full specifications" disclosure.
- **COPY SELF-AUDIT (mandatory before ship):** re-read every visible string; flag and rewrite anything grammatically broken, with unclear referents, or containing obviously wrong claims. Plain functional copy beats broken copy.

### Quotes & testimonials

- Max 3 lines of quote body; a landing-page quote is a snippet, not the full review.
- Attribution: name + role + (optionally) company. Never name only ("- Sarah").
- Quote marks: real typographic quotes (`" "`) or none at all — never straight ASCII.

## 9. Image & visual asset strategy

Landing pages and portfolios are visual products. Text-only pages with fake-screenshot divs are slop.

**Priority order:**

1. **Image-generation tool first** if any exists in the environment — hero photography, product shots, texture backgrounds, mood images at the right aspect ratio.
2. **Real web images second:** `https://picsum.photos/seed/{descriptive-seed}/{w}/{h}` placeholders (seed describes the section), provided stock/brand URLs, or open-license sources if explicitly allowed.
3. **Last resort — tell the user:** leave clearly-labeled placeholder slots (`<!-- TODO: hero product photo, 1600x1200 -->`) and say "This page needs real images at: [placements]. Please generate or provide them."

- **Even minimalist sites need real images.** A pure-text page is not minimalism, it's incomplete work.
- **LOGO-ONLY rule:** logo wall = logos and nothing else — no industry/category labels below each logo. Alt text and optional brand links only.
- **Hero needs a real visual.** Text + gradient blob is not a hero, it's a placeholder.

## 10. Dial definitions

- **DESIGN_VARIANCE:** 1-3 predictable (symmetrical 12-col grid, equal paddings, centered); 4-7 offset (negative-margin overlaps, varied aspect ratios, left-aligned headers over centered data); 8-10 asymmetric (masonry, fractional units like `2fr 1fr 1fr`, massive empty zones). **MOBILE OVERRIDE:** levels 4-10 collapse to strict single-column (`w-full`, `px-4`, `py-8`) below 768px.
- **MOTION_INTENSITY:** see § 6.
- **VISUAL_DENSITY:** 1-3 art gallery (`py-32`–`py-48`); 4-7 daily app (`py-16`–`py-24`); 8-10 cockpit (tight paddings, no card boxes, 1px separators, `font-mono` for all numbers).

## 11. Pattern vocabulary

Names to reason with; implementations live in `component-guidelines.md` (block schema). Use the term when the design read calls for the pattern:

- **Heroes:** Asymmetric Split, Editorial Manifesto, Video/Media Mask, Kinetic-Type, Curtain-Reveal, Scroll-Pinned.
- **Nav & menus:** Mac Dock Magnification, Magnetic Button, Gooey Menu, Dynamic Island, Contextual Radial, Floating Speed Dial, Mega Menu Reveal.
- **Layout & grids:** Bento Grid, Masonry, Chroma Grid, Split-Screen Scroll, Sticky-Stack Sections.
- **Cards:** Parallax Tilt, Spotlight Border, Glassmorphism Panel, Holographic Foil, Morphing Modal.
- **Scroll:** Sticky Scroll Stack, Horizontal Scroll Hijack, Zoom Parallax, Scroll Progress Path, Liquid Swipe Transition.
- **Media:** Dome Gallery, Coverflow, Drag-to-Pan Grid, Hover Image Trail, Glitch Effect.
- **Type & text:** Kinetic Marquee, Text Mask Reveal, Text Scramble, Circular Text Path, Gradient Stroke Animation.
- **Micro-interactions:** Particle Explosion, Liquid Pull-to-Refresh, Skeleton Shimmer, Directional Hover-Aware Button, Ripple, SVG Line Drawing, Mesh Gradient, Lens Blur.
- **Library choice:** Motion (`motion/react`) default for UI/Bento/state-change; GSAP + ScrollTrigger for full-page scrolltelling (isolated leaf components with `useEffect` cleanup); Three.js for canvas/3D (same isolation). **Never mix GSAP/Three.js with Motion in the same component tree** — they fight over the same frames.
