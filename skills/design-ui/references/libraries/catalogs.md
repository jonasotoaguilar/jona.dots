# Copy-paste UI, effect libraries & inspiration catalogs

**NOT dependencies.** Entries here are copy-paste blocks, design references, or effect components — you copy code into the project; you do NOT `npm install` them. If a task maps to a real dependency, use `web.md` or `native.md` instead. Snapshot: 2026-08. See `../../SKILL.md` for activation and lazy-load rules.

## Default / core catalogs

| Catalog | Classification | Notes |
| --- | --- | --- |
| [Magic UI](https://magicui.design) | Default animated copy-paste catalog | MIT; the default for animated component blocks |
| [shadcn blocks](https://ui.shadcn.com/blocks) | Official shadcn/ui blocks | Copy-paste, consistent with shadcn/ui conventions |

## Reference-only effect catalogs

| Catalog | Classification | Notes |
| --- | --- | --- |
| [Aceternity UI](https://ui.aceternity.com) | Reference-only effect catalog | Licensing ambiguity — inspect per-component before copying |
| [Animate UI](https://www.animate-ui.com) | Reference-only accessible animated registry | MIT; accessibility-first |
| [React Bits](https://www.reactbits.dev) | Reference-only broad animated catalog | MIT + Commons Clause nuance — verify terms before copying |
| [Motion UI / Motion+](https://www.npmjs.com/package/motion-plus) | Commercial motion component library | Paid; old motion-ui.com domain is parked — link via npm package |
| [Tailwind UI](https://tailwindui.com) | Commercial component library | Paid, MIT-licensed once purchased |

## Specialist / niche

| Catalog | Classification | Notes |
| --- | --- | --- |
| [21st.dev](https://21st.dev) | Registry marketplace for shadcn-style components | Community registry; per-component quality varies |
| [Shadcnblocks](https://shadcnblocks.com) | shadcn/ui section/block library | Copy-paste marketing/section blocks |
| [Reicon](https://reicon.dev) | Specialist/reference icon option | Multi-framework + React Native/Flutter; **Lucide remains the default** |
| [Boneyard](https://boneyard.dev) | Specialist automatic skeleton generator | Young project — verify maturity before relying on it |

## Inspiration only

| Catalog | Classification | Notes |
| --- | --- | --- |
| [Uiverse](https://uiverse.io) | Inspiration/copy-paste CSS/Tailwind snippets | Community library, free to copy; variable quality and licensing — treat as reference, never a dependency |
| [Supahero](https://supahero.io) | Inspiration only | Merged into ScreensDesign; do not recommend as a dependency |

## Rules

- Never install any catalog as a package unless it is explicitly listed in `web.md` / `native.md`.
- When copying from a reference-only catalog, check the component's license before shipping it.
- Prefer Magic UI (default) and shadcn blocks before reference-only catalogs.
