---
version: alpha
name: [Design System Name]
description: [Optional one-line description]
# Intentionally absent sections/token families are declared here (official
# design.md `omitted:` list) so validation does not warn about them. Example:
#   omitted:
#     - colors
#     - section: spacing
#       reason: "No spacing scale defined"
colors:
  primary: "#000000"
typography:
  body-md:
    fontFamily: Inter
    fontSize: 1rem
rounded:
  md: 8px
spacing:
  md: 16px
components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "#FFFFFF"
    rounded: "{rounded.md}"
    padding: 12px
---

## Overview

[Describe the design system's personality and intent.]

## Colors

[Explain palette roles and how agents should use them.]

## Typography

[Explain hierarchy, rhythm, and usage.]

## Layout

[Explain spacing, grid, and responsive structure.]

## Elevation & Depth

[Explain shadows, layering, borders, and contrast strategy.]

## Shapes

[Explain corner radii, curvature language, and geometric character.]

## Components

[Explain how the major components should feel and when to use variants.]

## Do's and Don'ts

- Do: [positive instruction]
- Don't: [negative instruction]

<!-- Optional bounded prose sections — add ONLY when a durable, shared UI
     aspect genuinely needs them (global IA/navigation, accessibility contract,
     responsive rules, performance/SEO policy, shared states and copy, motion
     contract, library usage boundaries). Keep them lean and proportional — no
     word quota. Change-specific flows, states, and motion live in the change's
     SDD design.md, not here. Move catalogs and examples to references instead
     of growing this file. -->

## User Flows & Navigation

<!-- Durable global IA/navigation only: product-wide routes and navigation
     structure. Change-specific screen flows and states stay in the change's
     SDD design.md; detailed product flows live in PRD/docs. -->

| Route / Flow | Purpose                | Entry point | Primary action   |
| ------------ | ---------------------- | ----------- | ---------------- |
| `/`          | [what this route does] | [component] | [primary action] |

[Add rows as needed. Keep Mermaid diagrams small and secondary to this table.]

## Accessibility Contract

- [Contrast floor, keyboard contract, focus behavior, screen-reader contract]

## Responsive Behavior

- [Breakpoints, mobile-first behavior, safe areas, touch targets]

## Performance

- [LCP/CLS/INP targets, media strategy, deferral rules]

## SEO

- [One H1 per page, metadata strategy, indexability rules]

## Content & States

- [Loading/empty/error/success states, copy conventions]

## Motion

- [Whether to animate, intensity, reduced-motion behavior; values per the motion contract]

## UI Libraries & Usage Boundaries

- [Approved libraries/components, what is off-limits, one-system rule]
- [Respect the project's existing design system/library; never enumerate alternatives or migrate/replace one unless explicitly requested]
