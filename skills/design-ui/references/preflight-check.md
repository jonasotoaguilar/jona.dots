# Final Pre-Flight Check

> Run this matrix before outputting code. This is the last filter. Load this reference whenever a deliverable is ready. Read the index first.

**THIS IS NOT OPTIONAL. Run every box. If any box fails, the output is not done.**

Note: this is the **final-output gate** for direction deliverables. The upstream project pre-flight scan (reading existing tokens, fonts, stack before touching code) is `preflight-and-preservation.md` in this skill.

- [ ] **Brief inference** declared (one-line Design Read from `design-direction.md` § 0)?
- [ ] **Dial values** explicit and reasoned from the brief, not silently baseline?
- [ ] **Design system** chosen from `design-direction.md` § 2 if applicable, or aesthetic labeled honestly?
- [ ] **Redesign mode** detected and audit performed (if applicable, `redesign-protocol.md`)?
- [ ] **Page Theme Lock**: ONE theme (light, dark, or auto) for the whole page, no mid-page flips (§ 4.11)?
- [ ] **Color Consistency Lock**: chosen color strategy applied identically across all sections (§ 4.2)?
- [ ] **Shape Consistency Lock**: one corner-radius system applied consistently (§ 4.4)?
- [ ] **Button Contrast Check**: every CTA text passes WCAG AA 4.5:1 against its background?
- [ ] **CTA Button Wrap**: no CTA label wraps to 2+ lines at desktop?
- [ ] **Form Contrast Check**: inputs, placeholders, focus rings, labels pass WCAG AA against the section background?
- [ ] **Italic descender clearance**: every italic word with `y g j p q` has `leading-[1.1]` min + `pb-1` reserve?
- [ ] **Hero fits the viewport**: headline ≤ 2 lines, subtext ≤ 20 words AND ≤ 4 lines, CTA visible without scroll, font scale planned around the image?
- [ ] **Hero top padding**: max `pt-24` at desktop, hero content does not float halfway down the viewport?
- [ ] **Hero stack discipline**: max 4 text elements in hero (eyebrow OR brand strip, headline, subtext, CTAs)? No tiny tagline below CTAs, no trust micro-strip in hero?
- [ ] **EYEBROW COUNT (mechanical)**: instances of `uppercase tracking` micro-labels above section headlines ≤ ceil(sectionCount / 3)? Hero counts as 1.
- [ ] **Split-Header Ban**: no "left big headline + right small explainer" section headers (vertical stack instead)?
- [ ] **Zigzag Alternation Cap**: no 3+ consecutive image+text-split sections?
- [ ] **Section-Layout-Repetition**: no two sections share a layout family (at least 4 different families across 8 sections)?
- [ ] **No Duplicate CTA Intent**: no two CTAs with the same intent ("Get in touch" + "Let's talk")?
- [ ] **Bento Background Diversity**: at least 2-3 bento cells with real visual variation, not all white text cards?
- [ ] **Bento cell count**: N items → N cells, no empty cells in the middle or at the end?
- [ ] **Marquee max-one-per-page**: no two horizontal marquees on the same page?
- [ ] **Navigation on ONE line** at desktop, height ≤ 80px?
- [ ] **"Used by / Trusted by" logo wall** lives UNDER the hero, uses REAL SVG logos (Simple Icons / devicon) or generated marks, never plain-text wordmarks; logo wall = logos only, no category labels?
- [ ] **Real images used** (gen-tool first, then Picsum-seed, then explicit placeholder slots)? NO div-based fake screenshots, NO re-drawn browser/phone/IDE chrome, NO hand-rolled decorative SVGs as defaults, NO pure-text minimalism?
- [ ] **Honest proof**: no fabricated metrics, testimonials, logos, or case-study counts; unsupported facts labelled pending or the slot removed; no fake-precise specs?
- [ ] **Copy Self-Audit**: every visible string re-read, no grammatically-broken or AI-hallucinated phrases shipped?
- [ ] **Content density sane**: no 20-row data tables, ≤ 25-word sub-paragraphs by default, long lists (>5 items) use a non-`<ul>` component?
- [ ] **Quotes ≤ 3 lines**, clean attribution, real typographic quotes?
- [ ] **Empty / loading / error** states provided?
- [ ] **Cards omitted** in favor of spacing where possible?
- [ ] **Icons** from an allowed library only (Phosphor / HugeIcons / Radix / Tabler), no hand-rolled SVG paths?
- [ ] **Dark mode** tokens defined and tested in both modes?
- [ ] **Mobile collapse** explicit for high-variance layouts; no horizontal scroll at 320px?
- [ ] **Viewport stability**: `min-h-[100dvh]`, never `h-screen`?
- [ ] **Reduced motion** handled for everything above baseline (`ui-motion` authority)?
- [ ] **Motion claimed = motion shown**: if `MOTION_INTENSITY > 4`, the page actually animates?
- [ ] **Motion motivated**: every animation justifiable in one sentence; no show-only animation?
- [ ] **Motion** isolated in client-leaf components with `'use client'` at the top?
- [ ] **No `window.addEventListener('scroll')`** — Motion `useScroll()` / ScrollTrigger / IntersectionObserver / CSS scroll-driven animations only?
- [ ] **GSAP sticky-stack / horizontal-pan** implemented per `frontend-ui-engineering` implementation-guardrails canonical skeletons (`start: "top top"`, `pin: true`, correct scrub)?
- [ ] **No AI Tells** from `design-direction.md` § 9 (three equal cards, section repetition, fake product UI, Jane Doe, Acme)?
- [ ] **Core Web Vitals** plausibly hit (LCP < 2.5s, INP < 200ms, CLS < 0.1)?
- [ ] **One design system** per project (no Material + shadcn mixed)?

If a single checkbox cannot be honestly ticked, the page is not done. Fix it before delivering.
