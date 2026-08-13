# PRD: {Feature/Product Name}

{One paragraph — the product summary: what problem is being solved, who it helps, and why it matters now. State it once; later sections do not repeat it.}

## 1. Problem Statement

- **Problem**: {The pain point, in 1-2 sentences}
- **Why now**: {What makes this the right time to solve it}

## 2. Users & Personas

- **{Persona Name}**: {who they are, what they need}
- **{Persona Name}**: {who they are, what they need}

## 3. Outcomes & KPIs

- **Outcome**: {The desired user/business result}
- **KPI 1**: {measurable metric}
- **KPI 2**: {measurable metric}
- **KPI 3**: {measurable metric}

## 4. Requirements

### User Stories

- As a **{user}**, I want to **{action}** so that **{benefit}**.

### Acceptance Criteria

- [ ] {Concrete "done" condition for each story}

### AI/ML Output Quality (if applicable)

- {How output quality and accuracy are measured — thresholds, not tools}

> Requirement-level constraints belong here (compliance, cost envelope, user-visible thresholds). Architecture mechanisms and technology choices never do — they live in `ARCHITECTURE.md`/ADRs; link, don't duplicate.

## 5. Non-Goals

- {What we are explicitly NOT building in this phase}

## 6. Roadmap (as appropriate)

- **Phase 1 (MVP)**: {scope}
- **Phase 2**: {scope}
- **Phase 3**: {scope}

## 7. Product & Delivery Risks

- {Adoption, cost, dependency, or timeline risks}

## 8. Open Questions

- {Unresolved product questions — surface them instead of guessing}

## Checklist

- [ ] Problem is clear before solution detail.
- [ ] Outcomes/KPIs are measurable.
- [ ] Non-goals are explicit.
- [ ] Acceptance criteria are reviewable.
- [ ] No architecture mechanism or technology choice is stated here.

## Next Step

Link to the follow-up spec, design, or implementation plan.

---

## Keeping this PRD alive

- **Update trigger**: update this file when scope, users, outcomes, non-goals, or delivery risks change. A product release/version bump alone is never a reason to edit it — the PRD is living authority, not a per-release document.
- **Boundary**: technical thresholds and NFRs are owned by `ARCHITECTURE.md` (and per-change design docs). Link to them, never duplicate them here.
- **No version keying**: do not embed or key content to release versions (e.g. `v1.0.0`); use dates/status for history.
