# Official design systems & component libraries

Operational reference for official design-system adoption: when to use each system, what it is, how to install it, and where its canonical docs live. A brief that reads as an official system gets the official package — never a hand-rolled recreation. This is a dependency-selection reference, not design direction. Snapshot: 2026-08. See `../../SKILL.md` for activation and lazy-load rules.

## How to use

- Classify the brief via the quick map below; load this reference (and only this one — plus `watchlist.md` when the candidate is flagged there).
- Check `package.json` first; prefer what's already installed; never churn a dependency without being asked.
- **Existing system wins.** If the project already has a design system or UI library, respect it — do not enumerate alternatives or replace/migrate it by default; change or migrate a library only when explicitly requested.
- Recommend ONE system fit with a one-sentence justification; don't present a menu when the map has a clear answer.
- Install only when the request includes installing.
- One system per project: do not mix systems (Fluent React + Carbon in one tree, shadcn/ui components inside a Material app).
- A system pick is a technical dependency decision. Visual direction is owned by `design-ui`; a package pick never overrides design direction.

## Aesthetic vs system boundary

Glassmorphism, bento, brutalism, editorial, Liquid Glass, and similar are **visual aesthetics, not dependencies** — there is no package to install for them; implement with native CSS + Tailwind (see the direction references). Only the systems below have official packages. An aesthetic trend is not an official system, and an official system is not an aesthetic.

## Quick map: brief/context → system

| Brief reads as…                           | System               |
| ----------------------------------------- | -------------------- |
| Microsoft / enterprise SaaS / dashboards  | Fluent UI            |
| Google-ish UI, Material-flavored product  | Material Web         |
| IBM-style B2B / enterprise analytics      | Carbon               |
| Shopify app surfaces                      | Polaris              |
| Atlassian / Jira-style product            | Atlassian (Atlaskit) |
| GitHub-style devtool / community page     | Primer               |
| Public-sector UK service                  | GOV.UK               |
| US public-sector / trust-first            | USWDS                |
| Fast local-business / agency MVP          | Bootstrap            |
| Modern accessible React foundation        | Radix Themes         |
| Modern SaaS where you own the components  | shadcn/ui            |
| Tailwind-based modern SaaS / AI marketing | Tailwind             |

## Systems

### Material Web (Material 3)

- **When to use:** Google-ish UI, Material-flavored product; official Material 3 web components, theme-able via Material Theming.
- **Caveat:** Material 3 web components are in maintenance mode (see `watchlist.md`); map covers Material-flavored briefs only.
- **Platform/ecosystem:** Web components (framework-free); Material 3 tokens.
- **Install:**
  ```bash
  npm install @material/web
  ```
- **Canonical sources:**
  - https://github.com/material-components/material-web
  - https://material-web.dev/theming/material-theming/
  - https://m3.material.io/develop/web

### Fluent UI

- **When to use:** Microsoft / enterprise SaaS / dashboards; official Fluent UI with Microsoft tokens and accessibility done.
- **Caveat:** Microsoft design language; map covers Microsoft-ecosystem briefs. Two packages: React v9 vs web components (framework-free).
- **Platform/ecosystem:** React (v9) or framework-free web components; `@fluentui/tokens`.
- **Install:**
  ```bash
  npm install @fluentui/react-components
  ```
  ```bash
  npm install @fluentui/web-components @fluentui/tokens
  ```
- **Canonical sources:**
  - https://fluent2.microsoft.design/get-started/develop
  - https://fluent2.microsoft.design/components/web/react/
  - https://github.com/microsoft/fluentui
  - https://learn.microsoft.com/en-us/fluent-ui/web-components/

### Carbon

- **When to use:** IBM-style B2B / enterprise analytics; official Carbon with mature data-density patterns.
- **Caveat:** Enterprise-analytics flavor; not for consumer marketing.
- **Platform/ecosystem:** React (`@carbon/react`) plus styles; web-components tutorial also available.
- **Install:**
  ```bash
  npm install @carbon/react @carbon/styles
  ```
- **Canonical sources:**
  - https://carbondesignsystem.com/
  - https://github.com/carbon-design-system/carbon
  - https://carbondesignsystem.com/developing/react-tutorial/overview/
  - https://carbondesignsystem.com/developing/web-components-tutorial/overview/

### Shopify Polaris

- **When to use:** Shopify app surfaces; required for Shopify admin UI.
- **Caveat:** Shopify apps only. Web components load from the Shopify CDN (no npm package pinned); Polaris React exists for React apps (package not pinned here, see canonical sources).
- **Platform/ecosystem:** Web components via CDN (Shopify admin context) or React (`polaris-react`).
- **Install:** add to the app HTML head:
  ```bash
  # Add this to your app HTML head:
  #   <meta name="shopify-api-key" content="%SHOPIFY_API_KEY%" />
  #   <script src="https://cdn.shopify.com/shopifycloud/polaris.js"></script>
  ```
- **Canonical sources:**
  - https://shopify.dev/docs/api/app-home/web-components
  - https://github.com/Shopify/polaris-react
  - https://polaris-react.shopify.com/components

### Atlassian (Atlaskit)

- **When to use:** Atlassian / Jira-style product; official Atlassian design system.
- **Caveat:** Heavy, Atlassian-branded; not a fit for consumer marketing.
- **Platform/ecosystem:** React; granular `@atlaskit/*` packages plus `@atlaskit/tokens`.
- **Install:**
  ```bash
  yarn add @atlaskit/css-reset @atlaskit/tokens @atlaskit/button @atlaskit/badge @atlaskit/section-message @atlaskit/card
  ```
- **Canonical sources:**
  - https://atlassian.design/get-started/develop
  - https://atlassian.design/components/button/examples
  - https://atlaskit.atlassian.com/packages/design-system/button/example/disabled
  - https://atlassian.design/tokens/design-tokens

### Primer

- **When to use:** GitHub-style devtool / community page. Two products: Primer CSS for product/devtool UI, Primer Brand (React) for GitHub marketing UI.
- **Caveat:** Pick the variant matching the surface: CSS for product UI, Brand for marketing.
- **Platform/ecosystem:** CSS (`@primer/css`) or React (`@primer/react-brand`).
- **Install:**
  ```bash
  npm install --save @primer/css
  ```
  ```bash
  npm install @primer/react-brand
  ```
- **Canonical sources:**
  - https://primer.style/
  - https://github.com/primer/css
  - https://github.com/primer/brand

### GOV.UK

- **When to use:** Public-sector UK service; legally / regulatorily expected.
- **Caveat:** UK government services only; not for generic commercial or non-UK briefs.
- **Platform/ecosystem:** Framework-agnostic frontend (CSS + JS + templates).
- **Install:**
  ```bash
  npm install govuk-frontend
  ```
- **Canonical sources:**
  - https://design-system.service.gov.uk/components/button/
  - https://design-system.service.gov.uk/styles/layout/
  - https://github.com/alphagov/govuk-frontend

### USWDS

- **When to use:** US public-sector / trust-first; same regulatory expectation as GOV.UK for its jurisdiction.
- **Caveat:** US government services only; not for generic commercial briefs.
- **Platform/ecosystem:** Framework-agnostic frontend (CSS + JS).
- **Install:**
  ```bash
  npm install uswds
  ```
- **Canonical sources:**
  - https://designsystem.digital.gov/documentation/developers/
  - https://designsystem.digital.gov/components/button/
  - https://designsystem.digital.gov/components/card/
  - https://github.com/uswds/uswds

### Bootstrap

- **When to use:** Fast local-business / agency MVP; the source frames it as boring, fast, and it works.
- **Caveat:** Pragmatic default; won't carry a premium brand brief.
- **Platform/ecosystem:** Framework-agnostic CSS + JS (5.3).
- **Install:**
  ```bash
  npm install bootstrap
  ```
- **Canonical sources:**
  - https://getbootstrap.com/docs/5.3/layout/grid/
  - https://getbootstrap.com/docs/5.3/components/card/

### Radix Themes

- **When to use:** Modern accessible React foundation; primitives plus a polished theme.
- **Caveat:** React only.
- **Platform/ecosystem:** React; `@radix-ui/themes` theme layer over Radix primitives.
- **Install:**
  ```bash
  npm install @radix-ui/themes
  ```
- **Canonical sources:**
  - https://www.radix-ui.com/themes/docs/components/theme
  - https://www.radix-ui.com/themes/docs/components/card
  - https://github.com/radix-ui/themes

### shadcn/ui

- **When to use:** Modern SaaS where you own the components; open code, easy to customise.
- **Caveat:** You own the code — no runtime package, no vendor support; never ship the default state (reads as unshipped). Not a fit when the org mandates a vendor system.
- **Platform/ecosystem:** React + Tailwind; copy-paste components added into your repo.
- **Install:**
  ```bash
  npx shadcn@latest init
  npx shadcn@latest add button card badge separator input
  ```
- **Canonical sources:**
  - https://ui.shadcn.com/docs
  - https://ui.shadcn.com/docs/components/card
  - https://github.com/shadcn-ui/ui

### Tailwind

- **When to use:** Tailwind-based modern SaaS / AI marketing; default for indie + small team builds (`dark:` variant included).
- **Caveat:** Tailwind is a styling utility layer, not a component system — pair it with a component kit when ready-made components are needed; a mandated system wins.
- **Platform/ecosystem:** Utility-first CSS, any framework.
- **Install:** no command pinned in this reference — follow the official docs (canonical sources below).
- **Canonical sources:**
  - https://tailwindcss.com/docs/dark-mode
  - https://tailwindcss.com/blog/tailwindcss-v4
