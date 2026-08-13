# Shared Quality Gates (all roles)

Anti-slop, typography, density, palette, consistency, legibility, and provenance gates that apply to every asset and reference comp, and to image-to-code analysis. Role-specific rules live in web-direction.md, mobile-direction.md, and image-to-code.md.

## Anti-AI-Slop

Ban these unless explicitly requested.

- **Layout slop**: endless centered sections; identical card rows; cloned left-text/right-image blocks; perfect-but-lifeless symmetry; cards-inside-cards; giant rounded wrappers; one compressed multi-section board instead of per-brief images; decorative empty space.
- **Visual slop**: default purple/blue AI gradients; pink-orange "creator" defaults; rainbow/mesh blobs; glowing edges and neon halos; floating spheres; unmotivated glassmorphism; noise that hides the layout.
- **Typography slop**: giant heading + weak tiny subcopy; too many font moods per page; awkward line breaks; lazy all-caps; gradient headline as "premium"; tiny unreadable text.
- **Copy slop**: generic filler (unleash, elevate, revolutionize, next-gen, seamless, unlock your potential); fake brand names (Acme, Nexus, Flowbit, Quantumly); fake complexity labels ("00 orchestration layer"-style).
- **Density slop**: over-packed sections; card overload; cramped spacing; visually exhausting wall-of-content layouts.
- **KPI slop (web)**: three identical stat columns (99% satisfaction, $10 saved, ∞ scale) unless asked; fake dashboards with pointless charts; marquee logo strips of unreadable logos.

## Typography-First Discipline

Typography is a primary design material, not filler: clear size contrast, obvious reading order, strong display moments, brief readable supporting text. Labels, captions, and section headings reinforce structure. Never sacrifice legibility for style — readable beats clever.

## Density & Spacing Discipline

Designs must breathe: even vertical spacing between major sections; separate dense sections with calmer ones; open, composed, balanced, confident, breathable — never cramped, noisy, uneven, overfilled.

## Color & Material Rules

- One controlled palette per project: 1 primary, 1 secondary, 1 accent (sparingly), 1 neutral scale. No theme swap per section/screen.
- Gradients allowed when low-chroma, palette-matched, professional; banned when rainbow/AI-default.
- Full-bleed images must tonally match the palette, with overlays keeping text readable.
- Avoid generic startup palettes; keep saturation controlled; match accent to theme paradigm.
- Materials (paper, glass, matte, soft blur) only where they improve readability.

## Multi-Image Consistency Gate

Across any image set, enforce one brand world: same palette/accent logic, type scale, spacing, CTA family, icon/illustration mood, image treatment, and mockup/device framing. Variation is allowed in composition anchor, background mode, section size/density, and one second-read moment — never in product identity, design system, or mockup quality. A viewer flipping through frames must recognize one brand.

## Provenance Gate (conditional regeneration)

Never settle for the first mediocre render: regenerate when text is too small, spacing unclear, navigation feels fake, layout too crowded, screens cloned, framing inconsistent, palette generic/muddy, first screen noisy, imagery weak, or consistency is lost. Regenerate as a FRESH standalone image (same design language) when cropping or zooming an existing render would destroy fidelity — otherwise re-render the same composition with fixes.

## Clarity Check (run before delivery)

1. Hierarchy obvious? 2. First view clean? 3. Free of AI tells? 4. Premium, not template-like? 5. Imagery used strongly and intentionally? 6. Does it breathe? 7. Multi-image sets clearly one brand? 8. Palette consistent everywhere? 9. Text readable at normal size? 10. Composition varied (not reflexively left-text/right-image or box-in-box)? 11. Flow logical screen-to-screen (mobile)? 12. Can someone build from this?
