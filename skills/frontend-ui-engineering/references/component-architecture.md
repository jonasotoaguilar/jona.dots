# Component Architecture

Decision gates for component structure and state placement; the SKILL.md holds the runtime contract.

## Composition Seams

- **Compose, don't configure.** Favor composed children (`<Card><CardHeader>…`) over configuration props (`<Card title headerVariant bodyPadding>`); a configuration surface grows with every variant, composition does not.
- **One thing per component.** A component has a single responsibility; extract when two concerns share a file.
- **Separate data from presentation.** Container/presentational split only where it earns its place: the container owns data + states, the presentation owns rendering. Skip it when a component does not fetch.
- **Colocate.** Component, tests, stories, hooks, and types live together.

## State Placement (decision gate, not a ladder)

Place state by **lifecycle, shareability, URL derivability, and server authority** — not by prop-depth convenience:

| State kind                                             | Where it belongs                                               |
| ------------------------------------------------------ | -------------------------------------------------------------- |
| Component-specific UI state                            | Local (`useState`/`useReducer`)                                |
| Shared between a few siblings                          | Lifted to the closest common parent                            |
| Read-heavy, write-rare, app-wide (theme, auth, locale) | Context                                                        |
| Filters, pagination, shareable UI state                | URL (searchParams)                                             |
| Remote data with caching                               | Server state (React Query, SWR, or the framework's data layer) |
| Complex client state shared app-wide                   | Global store — last resort, only after the above are exhausted |

Prop drilling through components that do not use the props is a signal to lift or restructure — not to tunnel more props.

## Gate

- Component structure/composition/state questions → this reference.
- Design-system adherence, spacing/type/color, responsive, loading → `design-system-adherence.md`.
- Accessibility → `accessibility-checklist.md`.
- Motion mechanics → `ui-motion`.
