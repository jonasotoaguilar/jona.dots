---
name: documentation
description: "Trigger: write, restructure, or validate documentation: README, PRD, DESIGN.md, CODEBASE-GUIDE, AGENTS.md, OpenAPI, API docs, setup docs, diagrams. Owns doc writing/structure/validation, not domain decisions."
license: MIT
metadata:
  author: jonasotoaguilar
  version: "2.10.1"
---

## Activation Contract

Generic create/maintain guidance for project documentation: README, PRD, DESIGN.md, `docs/CODEBASE-GUIDE`, AGENTS.md, API docs, OpenAPI YAML, inline code documentation (comments, docstrings), setup/onboarding, community docs, and templates/writing guidance for ARCHITECTURE.md, ADRs, diagrams. This skill owns doc structure/accuracy/cognitive load, link/diagram validation, DESIGN.md mechanics, and validation commands. Update existing docs by default; create new docs only on explicit request. Guidance only — not a delegated subagent or SDD phase; apply inline.

## Hard Rules

- Lazy reading. Load only the reference/asset a Decision Gate names.
- Cognitive design. Apply `cognitive-doc-design` patterns.
- Stay grounded. Never invent behavior, architecture, or features unsupported by source.
- **Documentation boundary.** Do NOT choose API style, resource boundaries, gateway, auth, or versioning; document decisions, report unresolved ones. UI design decisions → `design-ui`; architecture/API decisions → `design-architecture`.
- **DESIGN.md mechanics owned here.** Owns template, structure/rules, drafting/reviewing/editing structure and prose, validation (scripts/validate-design-md.sh), token retrieval only to document existing source. Never chooses tokens, visual identity, layouts, interactions, states, responsive rules, motion, or accessibility decisions; route missing or new design decisions to `design-ui` and record what it approves.
- No reverse UI dependency. Reads an existing DESIGN.md only to know what is documented.
- Grounding. Intent in PRD.md; technical architecture in ARCHITECTURE.md; codebase guide an index; templates canonical in `assets/`; community docs resolve `PLACEHOLDER_*`/`@OWNER` before writing, never overwriting.
- **Codebase guide stays current.** After setup or documentation changes that move paths, change packages or boundaries, or add/remove docs, refresh `docs/CODEBASE-GUIDE.md` and its `docs/codebase/` detail pages; keep `docs/codebase/mental-model.md` current; never leave stale links and never create a competing index.
- **README security boundary.** SECURITY.md owns vulnerability disclosure, supported versions, and response expectations. Stack-specific hardening belongs to the owning stack skill (e.g. `npm-secure-config`); the README links to SECURITY.md, never duplicates policy.
- **Copy-paste code blocks.** User-facing bash blocks are for copy-paste: no comments inside the block — explain in prose before/after it. One command per block when each is a separate action; group only truly sequential one-shot pipelines.
- **No pinned versions in documented commands.** Update/install commands in docs must never hardcode a version (e.g. `pkg@1.0.1`) — use a dynamic resolver (`pkg@"$(npm view pkg version)"`) or a `<version>` placeholder. Only release documents (e.g. `docs/releases/`) pin a version, by design.
- **No release-version keying in living authority docs.** General living authority docs — `PRD.md`, `ARCHITECTURE.md`, `DESIGN.md`, ADR bodies and indexes, README/setup docs (unless explicitly release-scoped) — must never embed or key their identity/content to the current product release version (e.g. `v1.0.0`). Version bumps must never require doc-wide edits. Only release-specific artifacts (release notes/changelogs), compatibility matrices, migration guides, and genuinely version-dependent API/schema facts may pin versions. When history is needed, use dates/status/ADR lifecycle or links — never current-release labels.
- **User ≠ repo owner.** Commands documented for users must not assume a repository checkout (`scripts/...`, `./...` paths) or a global npm install of the package; prefer registry/network commands users can run without the repo.

## Decision Gates

- README: readme-guide + assets/readme-template.md — centered hero with badge row (release, license, runtime, platform); license as a badge in the hero and in a centered footer that is always the final element of the file. PRD: prd-guide + template; write ./PRD.md.
- DESIGN.md: draft/update via assets/DESIGN.md + structure-and-rules (record only already-approved decisions; merge, never blind-overwrite); retrieve tokens from existing source / validate via scripts/validate-design-md.sh.
- Codebase Guide: codebase-guide.md + assets/CODEBASE-GUIDE.md. `docs/CODEBASE-GUIDE.md` is a concise navigational index; for non-trivial repos also generate grounded `docs/codebase/` detail pages, with `docs/codebase/mental-model.md` as the foundational page.
- AGENTS.md: agents-index.md; only when repo-root `skills/` exists.
- API Docs / OpenAPI: api-docs guide + template; OpenAPI guide + assets/openapi-template.yaml, validate scripts/validate_openapi.py.
- Code documentation (comments, docstrings): authoring-guidance.md + docstrings-guide.md; review lens is review-readability.
- ARCHITECTURE.md / ADR: assets/ARCHITECTURE.md (validate scripts/validate-architecture-md.sh); ADR template, match convention; decisions owned by design-architecture. Never delete superseded ADRs: mark the old one `Deprecated` or `Superseded by ADR-XXX` and write a new ADR that links it.
- Diagrams: diagram-examples.md + embedded-views.md.
- Community docs: community-docs guide + assets/CODE_OF_CONDUCT.md, CODEOWNERS, CONTRIBUTING.md, SECURITY.md.
- API style / boundaries undecided: do not decide; record unresolved decision and continue on grounded sections.

## DESIGN.md Gate

- Create only on explicit request or orchestrator assignment.
- Update an existing ./DESIGN.md only to record missing durable UI aspects that are already approved; merge, never blind-overwrite; keep canonical YAML tokens and the 8 linted sections, with bounded optional prose after the core (durable shared UI authority only — change-specific flows/states/motion stay in the change SDD design.md). Declare intentionally absent sections via the official `omitted:` front-matter list; never fabricate tokens to fill gaps.
- Retrieve tokens only to document existing source; never choose tokens, visual identity, layouts, interactions, states, responsive rules, motion, or accessibility — route missing or new design decisions to `design-ui` before recording.
- Validate after every mutation: scripts/validate-design-md.sh. Errors → fix before complete; warnings → address real gaps; CLI blocked → report blocker + manual schema/section-order review.
- No design decisions here. `design-ui` owns what to design and why; this skill records and validates.

## Execution Steps

1. Identify the document type (a typo or one-section README fix is NOT a PRD trigger).
2. Match an existing project convention (ADR dir, doc location/format, community-doc placement); never introduce a second scheme.
3. Load only the references/assets the Decision Gate names; for DESIGN.md, use only the structure, validation, and existing-source retrieval references that apply. If content requires a missing or new UI decision, stop and route it to `design-ui` before writing; otherwise draft per `cognitive-doc-design`.
4. Confirm every linked path exists or was requested; flag placeholders.
5. Resolve every `PLACEHOLDER_*`/`@OWNER` token before writing; never overwrite existing content.
6. Validate OpenAPI, ARCHITECTURE.md, and DESIGN.md via their scripts.

## Output Contract

Return: updated/generated file(s) with exact paths; template/reference used and any validation output; blocking list (unresolved placeholders, links to non-existent files, unadapted template sections); unresolved architecture or product decisions that prevented grounded documentation.

## References

- references/\*.md — per-document-type guidance; load lazily per Decision Gate.
- `references/design-md-structure-and-rules.md` — DESIGN.md structure/rules; `references/design-md-validation-workflow.md` — validation; `references/design-md-retrieval-workflow.md` — token retrieval from existing source.
- assets/DESIGN.md — canonical template; scripts/validate-design-md.sh — validation command.
- `assets/*`, `scripts/` — other templates; OpenAPI + ARCHITECTURE.md validators/scaffolds.
- `cognitive-doc-design` — cognitive patterns. `design-ui` — owns UI/design decisions. `design-architecture` — owns architecture/API decisions.
