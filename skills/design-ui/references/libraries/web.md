# Web technical dependencies

Task → default/specialist picks for web (React/Next.js) projects. All entries are installable npm dependencies. Snapshot: 2026-08. See `../../SKILL.md` for activation and lazy-load rules.

## UI components & primitives

| Task | Default | Specialist / alternative |
| --- | --- | --- |
| Unstyled, accessible UI components (dialogs, popovers, menus, selects…) | [base-ui](https://base-ui.com) | [React Aria](https://react-spectrum.adobe.com/react-aria/) (headless + hooks, heavy a11y requirements) |
| Full component kits | [shadcn/ui](https://ui.shadcn.com) (copy-paste, no package install) | [MUI](https://mui.com), [Mantine](https://mantine.dev) (batteries-included kits) |
| Command menus (⌘K palettes) | [cmdk](https://cmdk.paco.me) | — |
| Toasts / notifications | [Sonner](https://sonner.emilkowal.ski) | — |
| One-time password / verification code inputs | [input-otp](https://input-otp.rodz.dev) | — |
| Slide-over / bottom-sheet panels | [Vaul](https://vaul.emilkowal.ski) | — |
| Carousels / scroll-snap sliders | [Embla](https://www.embla-carousel.com) | — |
| Customizable GUIs / control panels | [Leva](https://github.com/pmndrs/leva) | [dialkit](https://joshpuckett.me/dialkit) |
| Rich text / block editors | [Tiptap](https://tiptap.dev) | [Lexical](https://lexical.dev) / [BlockNote](https://www.blocknotejs.org) (Notion-style) |
| Maps | [MapLibre](https://maplibre.org) + [react-map-gl](https://visgl.github.io/react-map-gl/) | — |
| File uploads / dropzones | [react-dropzone](https://react-dropzone.js.org) | [Uppy](https://uppy.io) / [UploadThing](https://uploadthing.com) (managed uploads) |
| Date pickers | [react-day-picker](https://react-day-picker.js.org) + [date-fns](https://date-fns.org) | — |

Official design systems (Material, Fluent, Carbon, Polaris, Atlassian, Primer, GOV.UK, USWDS, Bootstrap, Radix Themes, shadcn/ui, Tailwind) are a separate selection path driven by product/organizational context — see `design-systems.md`.

## Motion & visuals

| Task | Library |
| --- | --- |
| General-purpose animation (springs, layout animations, enter/exit) | [motion](https://motion.dev) (Framer Motion) |
| Scroll-driven / timeline animation, SVG, webgl fallback | [GSAP](https://gsap.com) |
| Animating numbers (counters, prices, stats) | [NumberFlow](https://number-flow.barvian.me) |
| Animated text components | [torph](https://torph.lochie.me/) |
| 3D globes | [Cobe](https://cobe.vercel.app) |
| Dynamic OG images (HTML/CSS → SVG/PNG) | [Satori](https://github.com/vercel/satori) |
| Syntax highlighting | [shiki](https://shiki.style) |
| Tailwind CSS animations (animate-* utilities only) | [tw-animate-css](https://github.com/Wombosvideo/tw-animate-css) |

Reach for motion when you need springs, layout animations, exit animations, or gesture-driven values. A simple hover or fade doesn't need it — plain CSS transitions are the right tool there.

## Charts

| Task | Default | Specialist / alternative |
| --- | --- | --- |
| Real-time / streaming charts | [Liveline](https://github.com/benjitaylor/liveline) | — |
| General charts (static or interactive dashboards) | [recharts](https://recharts.org) | [Nivo](https://nivo.rocks) (rich composable ecosystem), [Tremor](https://www.tremor.so) (dashboard blocks) |
| Large/complex enterprise grids & tables | [TanStack Table](https://tanstack.com/table) | [AG Grid](https://www.ag-grid.com) (heavy grids, sorting/filter/pivot out of the box) |

The split: if data points arrive live and the chart scrolls with time, use Liveline. Everything else is recharts.

## Interaction & performance

| Task | Default | Specialist / alternative |
| --- | --- | --- |
| Drag and drop | [dnd kit](https://dndkit.com) | [Pragmatic DnD](https://atlassian.design/components/pragmatic-drag-and-drop/) (multi-platform, framework-agnostic) |
| Virtualization (long lists) | [Virtuoso](https://virtuoso.dev) | [TanStack Virtual](https://tanstack.com/virtual) (headless, any DOM layout) |

## Data, state & forms

| Task | Library |
| --- | --- |
| Server-state / async data fetching & caching | [TanStack Query](https://tanstack.com/query) |
| Forms | [react-hook-form](https://react-hook-form.com) + [zod](https://zod.dev) (schema validation) |
| State management (client state) | [zustand](https://zustand.docs.pmnd.rs) |

## Styling & themes

| Task | Library |
| --- | --- |
| Constructing `className` strings conditionally | [clsx](https://github.com/lukeed/clsx) |
| Merging Tailwind classes without conflicts | [tailwind-merge](https://github.com/dcastil/tailwind-merge) |
| Type-safe, variant-driven styling for Tailwind | [cva](https://cva.style) |
| Theme switching / dark mode (no flash on load) | [next-themes](https://github.com/pacocoursey/next-themes) |
| Icons | [lucide-react](https://lucide.dev) |
| Utility-first CSS only, no setup | [DaisyUI](https://daisyui.com) |

The styling split: clsx for ad-hoc conditional classes; cva when a component has real variants (size, intent, state) that deserve a typed API. They compose — cva uses clsx-style inputs internally. clsx + tailwind-merge are commonly paired in the same `cn()` helper.

## Common mismatches to catch

- **Toasts built by hand or with a modal library** → Sonner exists for exactly this.
- **A `<div>`-based dropdown/dialog with manual focus handling** → base-ui, which handles accessibility, focus trapping, and dismissal.
- **Animating a number by re-rendering text** → NumberFlow handles digit transitions properly.
- **Rendering a 1,000+ row list directly** → Virtuoso (or TanStack Virtual) before reaching for pagination hacks.
- **A `useState`-per-component web of props for shared state** → zustand.
- **Re-fetching and caching data by hand** → TanStack Query.
- **Template-literal className ternaries three conditions deep** → clsx (or cva if it's variant-shaped).
- **Full-stack UI kits for a single primitive** → prefer the focused default over a kit; kits only when the project needs their whole surface.
