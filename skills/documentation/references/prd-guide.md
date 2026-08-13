# PRD Guide

Use this guide together with `../assets/prd-template.md`.

## Purpose

PRDs align stakeholders on the problem, scope, success criteria, and non-goals before or during delivery planning. The project-root `PRD.md` is the **product source of truth** for `design-architecture`; do not invent architecture here, and do not let a design sketch replace this file.

## Reader's Quick Path

1. Read the opening product summary — problem, who it helps, why now.
2. Check Outcomes & KPIs: are they measurable?
3. Skim Requirements (stories + acceptance criteria).
4. Review Non-Goals and Open Questions before approving scope.

## Core Practices (Cognitive Design)

- **Lead with the answer:** Open with ONE concise product summary (problem, outcome, who it helps). Do not restate it — no separate executive summary, quick-path table, or details table.
- **Signposting & Chunking:** Use short, grouped sections to avoid cognitive overload.
- **Recognition over recall:** Use checklists for acceptance criteria and tables for KPIs.
- Use measurable success criteria. Replace vague words like "fast" or "easy" with thresholds.
- Include explicit non-goals to prevent scope creep.
- Write user stories in the form: `As a [user], I want to [action] so that [benefit]`.
- If requirements are unclear, surface open questions instead of guessing.

## Requirements vs Architecture Boundary

A PRD states capabilities and requirement-level constraints — never architecture mechanisms or technology choices.

- ✅ Capability: "Users can export their order history as CSV."
- ✅ User-visible threshold: "Export must complete within 10s for 10k orders."
- ✅ Compliance: "All stored data must comply with GDPR."
- ✅ Cost envelope: "Hosting cost must stay under $200/month."
- ❌ Architecture mechanism: "The system uses a Postgres database with a Redis cache."
- ❌ Technology choice: "Built with React and a Node.js API."
- ❌ Integration mechanism: "Export is served by a REST endpoint behind the API gateway."

Technical thresholds and NFRs are owned by `ARCHITECTURE.md` and per-change design docs: when a requirement implies a technical threshold, link to the owning doc instead of duplicating the number.

## Good vs Bad

- ❌ "Search should be fast."
- ✅ "Search must return results within 200ms for a 10k record dataset."

## Minimum Coverage

- Opening product summary — one paragraph: problem, who it helps, why now
- Problem statement
- Users / personas
- Outcomes / KPIs
- Requirements (user stories + acceptance criteria)
- Non-goals
- Roadmap (as appropriate)
- Product & delivery risks
- Open questions

Include sections as appropriate; the opening summary is never duplicated in later sections.

## Update Trigger & Boundary

- Update `PRD.md` when scope, users, outcomes, non-goals, or delivery risks change.
- A product release/version bump is never a reason to edit the PRD — it is living authority, not a per-release document. Do not key content to release versions (e.g. "in v1.0.0"); use dates/status for history.
- Technical thresholds/NFRs live in `ARCHITECTURE.md` (and per-change design docs): link, don't duplicate.

## Handoff to `design-architecture`

Once a PRD is written or updated, architecture decisions that follow may require `design-architecture` for system/API decisions, `ARCHITECTURE.md`, and ADRs — route that work to it from this skill's boundary. Architecture consumes this file; it does not duplicate it, and this skill neither invokes nor produces architecture outputs. If a downstream ask tries to author a parallel product spec, redirect to this skill.
