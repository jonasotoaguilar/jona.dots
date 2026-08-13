# Redesign Protocol

> Load this reference when the request is a **redesign** of an existing site or app. Read the index first.

## 11.A Detect the Mode (first action)

This skill handles **greenfield builds AND redesigns**. Misclassifying the mode is the single biggest source of bad redesign output.

- **Greenfield** - no existing site, or full overhaul approved. Dial baseline from `design-direction.md` § 1.
- **Redesign - Preserve** - modernise without breaking the brand. Audit first, extract brand tokens, evolve gradually.
- **Redesign - Overhaul** - new visual language on top of existing content. Treat as greenfield for visuals; preserve content and IA.

If ambiguous, ask **once**: _"Should this redesign preserve the existing brand, or are we starting visually from scratch?"_

### Scope detection (single-page vs multi-page)

Decide scope before anything else - the behaviour diverges hard. **Multi-page signals (any one fires):**

- The target is a directory (e.g. `./app/`, `./pages/`, `./src/routes/`).
- The target is a glob (`**/*.tsx`, `app/*/page.tsx`).
- The user names more than one file in the brief (`./hero.tsx and ./pricing.tsx`).
- The user says "the whole site", "every page", "the app", "all the pages", "the marketing site".
- The codebase has multiple route files and the user pointed at the project root.

If none fires → single-page redesign (the protocol below applies to one page).

## 11.B Audit Before Touching

Document the current state before proposing changes:

- **Brand tokens** - primary / accent colors, type stack, logo treatment, radii.
- **Information architecture** - page tree, primary nav, key conversion paths.
- **Content blocks** - what exists, what's doing work, what's filler.
- **Patterns to preserve** - signature interactions, recognisable hero, copy voice.
- **Patterns to retire** - AI-slop tells, broken layouts, dead links, generic stock imagery, perf traps.
- **Dial reading of the existing site** - infer current `DESIGN_VARIANCE` / `MOTION_INTENSITY` / `VISUAL_DENSITY`. That's your starting point, not the baseline.
- **SEO baseline** - current ranking pages, meta titles, structured data, OG cards. **SEO migration is the #1 redesign risk.**

For the audit pass, run the generic AI-pattern checklist in `design-direction.md` § 9 and the final gate in `preflight-check.md` against the redesigned output. For the project pre-flight scan of existing code (tokens, fonts, stack), load `preflight-and-preservation.md` in this skill.

## 11.C Preservation Rules

- **Do not change information architecture** unless asked. Keep page slugs, anchor IDs, primary nav labels stable for SEO and muscle memory.
- **Extract brand colors before applying the color direction** (`design-direction.md` § 4.2). A brand that is already purple stays purple - apply the LILA RULE's override.
- **Preserve copy voice** unless asked for a rewrite. Visual modernisation ≠ content rewrite.
- **Honor existing accessibility wins.** Do not regress focus states, alt text, keyboard nav, contrast.
- **Respect existing analytics events.** Do not rename buttons, form fields, section IDs that downstream tracking depends on.

## 11.D Modernisation Levers (priority order)

Apply in order - stop when the brief is satisfied:

1. **Typography refresh** - biggest visual lift per unit of risk.
2. **Spacing & rhythm** - increase section padding, fix vertical rhythm.
3. **Color recalibration** - desaturate, unify neutrals, keep brand accent.
4. **Motion layer** - add `MOTION_INTENSITY`-appropriate micro-interactions to existing components.
5. **Hero & key-section recomposition** - restructure top-of-funnel using the vocabulary in `design-direction.md` § 10.
6. **Full block replacement** - only when the existing block is unsalvageable.

## 11.E Decision Tree: Targeted Evolution vs Full Redesign

- IA, content, and SEO sound → **targeted evolution** (Levers 1-4). ~70% of value at ~40% of risk.
- Visual debt is structural (broken IA, no design system, broken mobile) → **full redesign** with strict content preservation.
- Brand itself is changing → **greenfield**.

## 11.F What Never Changes Silently

Never modify without explicit user approval:

- URL structure / route slugs.
- Primary nav labels.
- Form field names or order (breaks analytics + autofill).
- Brand logo or wordmark.
- Existing legal / consent / cookie copy.

## Non-Destructive Implementation Rule

A redesign touches the visual and interaction layer; it does not bulldoze the codebase. Follow the pre-flight scan and preservation rules in `preflight-and-preservation.md` (report what exists, preserve established palette/type, in-place edits by default, file-level deletion plan with explicit user approval, reference material never pasted verbatim). The preserve/replace split for a single-page flow:

**Preserve:**

- The copy intent, factual claims, product names, and primary message. Preserve exact wording only when it already lives in the target UI or the user explicitly asks for verbatim copy.
- The information architecture (which sections exist, in roughly what order).
- The brand (colours and fonts they've named, if any).
- The primary action.
- The existing route/component ownership boundaries, unless the user has approved a full rebuild.

**Replace (the visual layer):**

- The structural fingerprint - a different section rhythm, different heading placement, different component voice.
- The component voice - different button style, different divider language, different image treatment.
- The reveal pattern - if the original faded everything in on scroll, the new one might have no reveals at all.
- The visual rhythm - different sections having different padding, different alignments, deliberate breaks.

**Do not replace without confirmation:**

- Route trees, production component directories, or the old website's file structure.
- Working app logic, data fetching, auth, forms, analytics, or integration code.

## Amend the Contract Instead of Overriding

If a page genuinely needs something the project's `DESIGN.md` doesn't allow (e.g. a marketing landing for a new sub-product wants a different theme), the rule is **amend `DESIGN.md` first**, not override locally. Add an explicit per-page allowance or a variants section. The contract evolves; per-page overrides do not. (`design-ui` owns DESIGN.md mutations.)
