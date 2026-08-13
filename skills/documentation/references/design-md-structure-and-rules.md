# Structure and Rules

## Official Structure Requirements

### 1. YAML Front Matter is mandatory

Use `---` fences at the top of the file. Supported top-level token keys:

```yaml
version: alpha # optional
name: <string> # required
description: <string> # optional
omitted: # optional — sections intentionally absent; suppresses linter warnings
  - <section-name> # e.g. colors, typography, spacing, rounded, components
  # or object form with a documented reason:
  - section: <section-name>
    reason: <string>
colors:
  <token-name>: <hex>
typography:
  <token-name>:
    fontFamily: <string>
    fontSize: <dimension>
    fontWeight: <string|number>
    lineHeight: <dimension|number>
    letterSpacing: <dimension>
    fontFeature: <string>
    fontVariation: <string>
rounded:
  <scale-level>: <dimension>
spacing:
  <scale-level>: <dimension|number>
components:
  <component-name>:
    backgroundColor: <string|token-reference>
    textColor: <string|token-reference>
    typography: <string|token-reference>
    rounded: <string|token-reference>
    padding: <dimension|number>
    size: <dimension|number>
    height: <dimension|number>
    width: <dimension|number>
```

`omitted:` is the official design.md mechanism for intentionally absent sections/token families. Only omit what is genuinely absent — omission is not a tool to dodge documentation.

### 2. Token Types

- **Color**: `"#1A1C1E"`
- **Dimension**: `4px`, `1rem`, `-0.02em`
- **Token reference**: `{colors.primary}`
- **Typography object**: structured object with font properties

### 3. Markdown section order

If sections are present, they must appear in this order:

1. `## Overview` (or alias `## Brand & Style`)
2. `## Colors`
3. `## Typography`
4. `## Layout` (or alias `## Layout & Spacing`)
5. `## Elevation & Depth` (or alias `## Elevation`)
6. `## Shapes`
7. `## Components`
8. `## Do's and Don'ts`

Unknown extra sections may be preserved, but **duplicate headings are invalid**.

### 4. Optional prose sections (after the canonical core)

After the 8 canonical sections, the following bounded optional prose sections MAY be added — but ONLY when a **durable, shared UI aspect** genuinely needs them, and kept lean:

1. `## User Flows & Navigation` — durable **global IA/navigation only**: product-wide routes and navigation structure (route/flow table as the source of truth; small Mermaid diagrams secondary). Change-specific screen flows and states stay in the change's SDD `design.md`; detailed product flows stay in PRD/docs.
2. `## Accessibility Contract`
3. `## Responsive Behavior`
4. `## Performance`
5. `## SEO`
6. `## Content & States`
7. `## Motion`
8. `## UI Libraries & Usage Boundaries`

Rules:

- No new YAML front-matter keys beyond the supported top-level token keys (plus `omitted:`).
- No large change log inside `DESIGN.md`; changelogs live in version control.
- No universal word limit: proportionality and omission decide. Generic rules, catalogs, and examples live in references, not in `DESIGN.md`.
- Change-specific flows, states, and motion NEVER go here — they belong in the change SDD `design.md`.
- Optional sections appear only after `## Do's and Don'ts`.
- Use `omitted:` to declare intentionally absent sections/token families (e.g. `colors`); validation then suppresses the corresponding warnings.

## Writing Rules

### Front matter rules

- `name` is required
- prefer `version: alpha` when authoring a fresh file
- tokens must be evidence-based
- token names should be semantic and stable
- include `components` whenever component behavior can be confidently mapped
- use token references like `{colors.primary}` instead of repeating literal values when relationships matter
- declare genuinely absent token families via `omitted:` rather than fabricating values

### Prose rules

- prose should explain intent, tradeoffs, and usage
- do not dump raw CSS without interpretation
- connect each major token family to actual UI behavior
- use natural design language, but stay grounded in observed evidence

### Component modeling rules

Valid component properties: `backgroundColor`, `textColor`, `typography`, `rounded`, `padding`, `size`, `height`, `width`.
Variants such as hover/active/pressed should be represented as separate component entries. Naming convention: `<component>-<state-or-variant>` (lowercase-hyphenated). Example: `button-primary`, `button-primary-hover`, `button-primary-active`.

## Common Failure Modes

- Writing prose only, with no YAML front matter.
- Creating a pretty style guide instead of a spec-compliant `DESIGN.md`.
- Using non-canonical section order.
- Inventing token values not supported by evidence.
- Duplicating component state inside prose but not tokens.
- Repeating literal values instead of referencing tokens when relationships are important.
- Mixing backend/system architecture concerns into `DESIGN.md`.
- Documenting change-specific flows/states/motion in the shared `DESIGN.md` instead of the change SDD `design.md`.
- Leaving a section empty instead of omitting it or declaring it via `omitted:`.
