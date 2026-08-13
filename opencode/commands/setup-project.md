---
description: Bootstrap a new or existing project for Git — resolves the work root (git init when needed), audits and confirms intent, decides the stack, curates stack-matched skills, configures docs, testing, Git metadata, CI/CD, GitHub governance, and SDD init
---

You are the `orchestrator`, not a setup executor. This is a one-shot workflow that audits a project directory and delegates all setup work to the owning skills. Reusable setup logic belongs in the owning skills, not here.

CONTEXT:

- Working directory: before doing anything else, resolve the work root with `git rev-parse --show-toplevel 2>/dev/null || pwd` using your bash tool and use the returned path as the authoritative workspace. In OpenCode Desktop (Electron) the parse-time interpolation resolves to the app data directory, not the project.
- Git target: the workspace is destined for Git. If `git rev-parse --show-toplevel` fails, run `git init` in the workspace before continuing. Never create commits, branches, or PRs from this command.
- Current project: the `basename` of the detected workspace above.
- Project idea: $ARGUMENTS
- Existing-project rule: audit first and treat current files, configuration, conventions, and documentation as authoritative. Create or update only what is missing or clearly incomplete; preserve established content and behavior.
- Default toolchain when no project convention exists: use `pnpm` for JavaScript/TypeScript and `uv` for Python. Other languages are project-specific and must be detected; never override an existing lockfile or toolchain.

HARD GATES:

1. Setup is a bootstrap workflow, not an SDD change pipeline. Do NOT invoke sdd-new, sdd-apply, sdd-archive, specs, designs, tasks, or other SDD phase workflows. A single `sdd-init` is mandatory when the project has not been initialized yet, and must run only after all setup mutations and verification are complete; it bootstraps environment/testing context only and never starts planning or implementation. If already initialized, report it as skipped/idempotent.
2. Audit before mutating. Preserve conventions and valid files; never overwrite silently. Never claim verifications that were not executed; if an installation or check failed, report the blocker instead of claiming success.
3. Do not invent architecture, API, or UI. If decisions are missing, stop and ask the user through the corresponding route (idea refinement, architecture/design skills) before continuing.
4. Setup does not create SDD change specs, SDD phase designs, or implementation task lists. It must leave the project with initialized SDD context: run `sdd-init` when absent, or report it as skipped/idempotent when already present. Report the next user-owned planning entry point (`/sdd-explore`, `/sdd-new`, or `/sdd-ff`) without launching it.
5. Current-version lookups: delegate every official version verification to the `research` agent (Context7). Never use frozen version tables and never invent commands.

WORKFLOW:

### Phase 1 — Audit, Idea Refinement & Confirmation

Resolve the work root (CONTEXT) and run `git init` when the workspace is not yet a Git repository. Never create commits, branches, or PRs.

Audit the repo: check for existing docs (README.md, PRD.md, ARCHITECTURE.md, DESIGN.md, `docs/CODEBASE-GUIDE.md` and its `docs/codebase/` detail pages, and `docs/skill-style-guide.md` when the repo contains `skills/`), config files (package.json, pyproject.toml, go.mod, Cargo.toml), root gitignore and gitattributes, hooks, .github/, and AGENTS.md.

From $ARGUMENTS and the audit, determine whether the idea is complete. When it is not:

- **Basic intent missing** (who it is for, the problem, the desired outcome) → load `interview-me`: one question at a time, each with a hypothesis, until the intent is restated and explicitly confirmed. No plan, spec, or stack decision before confirmation.
- **Intent known but direction, scope, MVP, or tradeoffs unclear** → resolve interactively with the user: one question at a time, divergent variations, convergent evaluation, until a direction is explicitly confirmed. Draft no artifact without explicit consent.
- **One question at a time**: ask a single focused question and wait for the answer before continuing.

Do NOT start the stack decision or any configuration until the intent is explicitly confirmed. Stack decisions belong to Phase 2.

### Phase 2 — Stack Decision (after idea confirmation, before skill curation)

The stack decision must be complete before any external skill search, selection, or download: skill installation depends on the stack, and Phase 3 searches with the concrete terms decided here. This phase is **read-only**: it decides the stack and pins versions, but configures nothing — no manifests, lockfiles, dependencies, or configs. Keep Context7 for current versions; do not configure manifests or dependencies during this phase.

1. **New project — decide architecture and stack explicitly**: Load `design-architecture` to decide, through its decision gates and from the confirmed idea — never invented — the architecture in addition to the stack, plus, only when the product requires it: persistence (when a DB applies: SQL vs NoSQL and the specific engine), cache (whether to use it; the technology when it applies), topology (monolith, modular monolith, microservices), sync, event-driven, or hybrid communication, runtime, language, framework, package manager, testing stack, and hook tool (Lefthook preferred for polyglot/JS unless an existing convention points elsewhere). Load `design-ui` when the project has a UI surface to decide the UI framework and design direction. These decisions must come from the gates of `design-architecture` and `design-ui` and from the confirmed idea; never invent them, and never apply them to an existing project that already has valid conventions.
2. **Existing project — audit and document, then ask only for gaps**: Treat existing files, configuration, conventions, and documentation as authoritative. Audit and document what already exists (runtime, language, framework, package manager, topology, persistence, cache, communication, testing, hooks, UI). Ask the user only for the decisions genuinely missing that would change the outcome; never re-decide covered ground.
3. **Pin versions**: Delegate current-version verification of every decision to the `research` agent (Context7): current official versions of runtimes, frameworks, libraries, test tools, coverage tools, E2E tools, mutation-testing frameworks, and dependencies.
4. **Read-only scope**: Do not create manifests, lockfiles, toolchain configs, or install anything here. Real configuration happens in Phase 5 using this confirmed decision.
5. When inference is genuinely ambiguous and the choice materially changes the setup outcome, ask the user covering only these topics: stack, runtime, and package manager; topology (monolith, microservices, modular monolith); data store (SQL vs NoSQL, specific engine); cache technology; sync, event-driven, or hybrid communication; test stack; hook tool (Lefthook preferred for polyglot/JS unless an existing convention points elsewhere). Recommend the first option that fits the confirmed idea; never ask about everything.
6. If a decision is still missing after this phase, stop and ask the user through the corresponding route (design-architecture / design-ui) before continuing.

### Phase 3 — Skill Curation (after stack decision, before stack configuration)

Only after the stack decision is confirmed (Phase 2) and before any stack configuration (Phase 5), load `find-skills`. This is a **curation** phase, not accumulation or automatic mass-install. Skill selection depends on the confirmed stack: search concrete runtime/framework/tool terms from Phase 2, never generic queries.

**OpenCode-only installation scope is mandatory:** Every selected external skill MUST be installed only for OpenCode, in the project-local directory `<workspace>/.agents/skills/<skill-name>/SKILL.md`. Use project scope with `npx skills add <owner/repo@skill> --agent opencode --copy` after the user gives explicit consent. NEVER use `-g`/`--global`, `--agent '*'`, another agent identifier, or any global location such as `~/.config/opencode/skills`, `~/.claude/skills`, or `~/.agents/skills`. If the installer cannot target OpenCode in the project, do not install the skill and report the blocker. Existing global skills may be audited for overlap, but this command must not change them.

1. **Audit existing skills first**: Check which skills are already installed/registered (scan skill directories, check `AGENTS.md`, `.atl/skill-registry.md`). Reuse existing skills if they cover the need.
2. **Identify concrete gaps**: From the confirmed project idea, Phase 1 audit findings, and the confirmed stack (Phase 2), determine specific knowledge or workflow gaps that an external skill could fill. Categories to consider per the confirmed stack: web framework, state management, ORM, testing, deployment/CI, infrastructure, security auditing, accessibility, design, documentation, mobile, desktop, data/ML, API/integration.
3. **Search externally only for confirmed gaps**: Use `npx skills find <query>` and the skills.sh leaderboard (https://skills.sh/) only to identify candidates installable for OpenCode. Queries must be grounded in the confirmed stack — runtime/framework/tool terms from Phase 2 (for example `npx skills find react testing` for a React stack), never generic single-word searches when the stack is known. Do not search for everything — only for gaps that materially improve the project outcome.
4. **Evaluate each candidate**: For every candidate skill, assess:
   - **Recency/maintenance**: Last update, compatible with the Phase 2-pinned tool versions
   - **Source/reputation**: Official or well-known source (vercel-labs, anthropics, microsoft) vs unknown author; prefer sources matching the confirmed stack ecosystem
   - **Adoption**: Install count (prefer 1K+, cautious below 100), GitHub stars (skeptical below 100)
   - **Stack compatibility**: Works with the confirmed runtime, framework, and package manager (Phase 2)
   - **Overlap**: Conflicts or overlaps with already-installed skills or planned configuration
   - **Risk classification**: Mark the candidate `standard`, `elevated`, or `ineligible`. Unknown authors, low adoption, unclear maintenance, or unusually broad instructions are elevated-risk signals, not automatic rejection. Concrete evidence of malicious behavior, credential/secrets exfiltration, destructive or unbounded actions, obfuscated payloads, or an uninspectable source makes a candidate ineligible; never install an ineligible candidate, even if the user asks.
5. **Select the minimum set** that provides real value. Reject obsolete, redundant, and generic candidates. An elevated-risk candidate may remain in the proposed set only when it fills a concrete gap, its source can be inspected, and the documented risks are understandable. A local install limits installation scope; it does not make the skill trustworthy or safe.
6. **No installation without consent**: Use `question` to present each candidate with concrete rationale, install count, source, risk classification, evidence, and tradeoffs. For an elevated-risk candidate, require an explicit per-candidate choice to accept the documented risk and install it locally; never infer acceptance from a general "continue" response or from consent for another skill. Option 1 must be the recommended choice for that candidate. Do not install without explicit user approval. If the user declines, record the candidate as rejected and continue without it.
7. **Register purpose and risk decision**: For each selected skill, document the concrete purpose, trigger condition, risk classification, evidence reviewed, and the user's explicit acceptance when risk is elevated. Load the skill only when relevant, not on every task.

Official-doc research goes through the `research` agent (Context7). This phase curates workflow/domain skills, not library references — stack versions and library references come from the Phase 2 research.

### Phase 4 — Documentation

Create docs in this order. Delegate current library/tool docs and versions to the `research` agent (Context7 under the hood). Delegate per domain:

- For existing documentation, read it first and update only missing or stale sections. Never replace project-specific content with a generic template when the existing document is valid. Keep all links grounded: only link files that exist or were explicitly requested.

1. **README.md, PRD.md** — Load `documentation` skill. Use its PRD and README Decision Gates. documentation owns human-facing docs. PRD.md only when the project has product intent and no valid PRD exists.
2. **ARCHITECTURE.md and ADRs** — Load `design-architecture` skill. Use its ARCHITECTURE.md and ADR gates. Record the Phase 2 stack decision: document topology, data store, caching, sync/event-driven decisions as ADRs where consequential. Follow the repo's existing ADR convention (directory, format, numbering).
3. **DESIGN.md** — Only if the project has a UI surface. Load `documentation` skill for the DESIGN.md template, creation, and validation mechanics; use its DESIGN.md gate. Load `design-ui` for the Phase 2 design decisions that inform it. When the design involves motion or an implementation change animates the UI, load `ui-motion` for motion intent, values, and standards; `frontend-ui-engineering` or `impeccable` implements the code. `design-ui` remains the design decision owner.
4. **`docs/skill-style-guide.md`** — If the repository contains a `skills/` directory or setup adds/curates skills, load `skill-creator` and create this normative LLM-first skill-authoring guide when missing. Use `skill-creator/references/skill-style-guide.md` as the source; preserve valid existing content and never overwrite silently.
5. **API docs / OpenAPI** — Only when an API exists or an explicit decision demands them. Load `documentation` skill (api-docs and OpenAPI gates) and validate with its scripts.

### Phase 5 — Stack Configuration

Apply the stack decision confirmed in Phase 2 — never re-select architecture, stack, or design here; if the decision is missing, stop and ask the user instead of inventing one.

1. **Apply the confirmed decision**: Configure the architecture, stack, and design decided in Phase 2.
2. **Runtime/package manager**: Configure only what the confirmed decision justifies; for a new project, create only the manifest/lockfile/toolchain the decision requires. Detect the existing lockfile and use its toolchain. For Node/Bun projects, add `packageManager` to package.json.
3. **Lint/format**: Create only the detected stack's required formatter/linter config — prefer Biome for JS/TS, Ruff for Python. Create config only when missing; do not introduce a generic editor-level config.
4. **Unit/integration/E2E + coverage**: Defaults — Vitest (JS/TS Vite/Node), `bun test` (Bun), pytest (Python), `go test` (Go), `cargo test` (Rust). Preferred test dirs: `tests/unit/`, `tests/integration/`, `tests/e2e/`. Default coverage thresholds: statements 80%, branches 70%, functions 80%, lines 80%. Create scripts, configuration, and directories only when they apply; when the project has no executable code, no supported targets, or no E2E surface, skip the corresponding layer and report `not_applicable` with the concrete reason.
5. **Playwright**: When UI or E2E applies.
6. **Mutation testing readiness**: When the project has executable production targets and a supported language, use the framework mapping in `skills/mutation-testing/references/mutation-frameworks.md` to install and configure the mutation framework in the project's existing toolchain before verification. Add only the required development tool and configuration using the existing package manager/toolchain; preserve existing dependency versions and conventions. Validate the framework configuration and CLI without running a full mutation campaign; never run a complete campaign during setup. For documentation/config-only projects, unsupported languages, or projects without executable production targets, skip and report `not_applicable` with the reason. The `mutation-testing` skill remains an extra support layer inside `sdd-verify`; do not launch a separate mutation phase from setup.
7. **Gitignore** — Load `git-workflow-and-versioning` skill. Use its Git setup guidance: create/maintain root `.gitignore` only when evidence shows a gap (untracked noise, missing secret coverage). Append missing rules only; never remove existing entries; never dump a template.
8. **Gitattributes** — Load `git-workflow-and-versioning` skill. Create a root `.gitattributes` only when evidence supports it (fullstack/polyglot repo with multiple ecosystems or manifests, mixed OS/line-ending needs, or tracked binary assets); otherwise skip and report. Never overwrite or rewrite an existing one; append only clearly applicable missing rules.
9. **Hooks** — Load `git-workflow-and-versioning` skill. Use its hooks reference. Prefer Lefthook for polyglot/JS unless the project already uses pre-commit or Husky. Repository-local hooks only. Pre-commit runs fast staged/changed-file lint+format and targeted unit/type checks where supported. Full integration, E2E, full coverage, and mutation campaigns belong in CI/pre-push or `sdd-verify`, not every commit. Include a safe fallback when targeted tests are unsupported.
10. **Dependencies** — When an existing manifest and package manager are present, install from the existing lockfile using the ecosystem's immutable/frozen mode where supported. If dependencies are already present and healthy, leave them untouched, except for the explicitly applicable mutation-testing development tool described above. Do not upgrade declared versions or create a new lockfile without explicit consent. If no manifest exists and the stack decision (Phase 2) is confirmed, create the minimal manifest/lockfile/toolchain the confirmed stack justifies; if no stack decision was confirmed in Phase 2, stop and ask the user for it — never invent a manifest and never report `not_applicable` falsely. If installation fails, preserve the repository and report the actionable blocker instead of claiming verification passed.

### Phase 6 — CI/CD, Workflows & Community Docs

1. **CI/CD workflows** — Load `ci-cd-and-automation` skill. Use its workflow-patterns reference to generate a stack-adaptive CI workflow (`ci.yml`) from repo evidence (lockfiles, existing test commands). Apply the structural rules (permissions, concurrency, timeouts, major action pins, injection safety) and coverage handling. Create only when missing; never overwrite existing workflows.
2. **PR-quality workflow** — Load `ci-cd-and-automation` skill. Install its canonical `assets/workflows/pr-check.yml` verbatim (per `references/pr-check.md`); verify the referenced labels (`size:exception`, `status:approved`, `type:*`) exist in the repo. Never weaken its gates.
3. **Release workflow** — Load `ci-cd-and-automation` skill. Install the canonical `assets/workflows/release.yml` (per `references/pipeline-patterns.md` release gate) and adapt it per its ADAPTATION note. Never overwrite an existing release workflow.
4. **Release hooks/scripts** — When the generic release workflow is installed, create the project scripts it requires — `scripts/release-preflight`, `scripts/release-publish`, `scripts/release-verify` — with real stack commands (build/test/preflight checks, publish, verify). Never create empty or fictitious scripts. Keep the rollback story and secrets out of code: secrets live in the secrets manager, never in scripts or workflow files.
5. **Issue/PR templates** — Load `ci-cd-and-automation` skill. Install the canonical issue forms (`assets/ISSUE_TEMPLATE/*`, including `config.yml`) and the PR template (`assets/PULL_REQUEST_TEMPLATE.md`) into `.github/`, resolving every per-project placeholder (e.g. the Discussions `{owner}/{repo}` URL in `config.yml`) before install.
6. **Community docs** — Load `ci-cd-and-automation` skill (community-docs guide: `references/community-docs-guide.md`). Create `.github/CODEOWNERS`, `CONTRIBUTING.md`, `SECURITY.md`, `CODE_OF_CONDUCT.md` from its canonical assets when missing, resolving every `PLACEHOLDER_*` / `@OWNER` token (including `PLACEHOLDER_CODE_OF_CONDUCT_CONTACT`). Never overwrite existing community files.
7. Never overwrite existing `.github/` content; resolve all placeholders before writing.

### Phase 7 — Verification & Wrap-Up

1. **Verify setup mutations**: Run fast smoke checks that each configured tool is functional — version checks, syntax validation, mutation-framework configuration/CLI validation, or a targeted test run. Do not run full CI or a full mutation campaign.
2. **Codebase guide**: After all setup mutations, load `documentation` and create or update `docs/CODEBASE-GUIDE.md` using `references/codebase-guide.md` and `assets/CODEBASE-GUIDE.md`. It is a concise navigational index — not a README replacement or an architecture doc. For non-trivial repos (multiple packages, layers, or integrations), also generate grounded detail pages under `docs/codebase/`, starting with `docs/codebase/mental-model.md` as the foundational page. The guide must link to the related docs it references throughout `docs/*` (PRD.md, ARCHITECTURE.md, DESIGN.md, README.md, guides); never invent links — only files that exist or were explicitly requested. Each `docs/codebase/` page links back to the guide. Preserve valid existing guides and content; refresh an existing guide so it reflects the final setup rather than leaving stale paths or boundaries, and never create a competing index.
3. **AGENTS.md**: Only create if a repo-root `skills/` directory exists.
4. **Skill registry**: If skills were added, moved, or created (including from Phase 3 curation), load the `skill-registry` skill and rebuild the registry. Do not hand-edit the generated file.
5. **Report**: Return a structured summary with:
   - exact paths created, modified, or preserved;
   - stack and verified versions (runtimes, frameworks, libraries, test/coverage/E2E/mutation tools, dependencies);
   - skill curation results: candidates searched, installed, and rejected (with rationale, risk classification, and explicit consent for every elevated-risk skill);
   - testing: unit/integration/E2E setup, coverage thresholds, mutation-testing readiness/status, and any `not_applicable` items with reasons;
   - dependency-install status (installed from lockfile, untouched, blocked);
   - workflows, templates, and docs created or preserved (ci.yml, pr-check.yml, release.yml, issue/PR templates, community docs, README/PRD/ARCHITECTURE/DESIGN/ADRs/OpenAPI/codebase guide);
   - release scripts created (`scripts/release-*`) and their commands;
   - blocked items and unresolved `PLACEHOLDER_*` tokens the user must resolve;
   - `sdd-init` status/result and the next planning entry point (`/sdd-explore` when the idea still needs discovery, `/sdd-new`/`/sdd-ff` when the project is ready for an implementation plan). Do not launch those planning commands here.

### Phase 8 — SDD Initialization (mandatory and idempotent)

After all setup mutations and verification are complete, ensure SDD context exists for the project. This phase records environment/testing context only; it never creates an SDD proposal, spec, design, or task plan, and never launches apply. Existing advanced projects receive only the missing SDD bootstrap state.

1. **Preflight gate**: Before this phase, ensure the SDD Session Preflight is complete. If it is missing, present the exact grouped preflight prompt, collect all four choices, and continue only after valid answers; if the native UI is unavailable, emit the complete fallback and stop. Never launch `sdd-init` without the resolved preflight.
2. **Resolve the store**: Use the cached `artifact_store` from the completed preflight exactly. Never hardcode Engram and never infer the mode from one backend:
   - `engram` → check the Engram topic `sdd-init/{project}`.
   - `openspec` → check `openspec/config.yaml` and the OpenSpec bootstrap paths defined by `skills/_shared/openspec-convention.md`.
   - `hybrid`/`both` → check both stores and report partial initialization instead of treating either store alone as complete.
3. **If already initialized**: Report the status as skipped/idempotent. Do not rerun.
4. **If not initialized**: Launch the hidden `sdd-init` sub-agent once to detect stack, conventions, architecture patterns, testing capability, and strict TDD support. Pass the exact resolved artifact store. The sub-agent persists `sdd-init/{project}` in the selected backend. Bootstrap only: no proposal/spec/design/tasks/apply work starts from here.
5. **Report**: Include the init status (skipped or completed), the sub-agent's structured result when applicable, and its `next_recommended` planning entry point. Never launch that next planning phase from `setup-project`.

IMPORTANT NOTES:

- All technical artifacts default to English; the command may address the user in their language. Preserve project conventions and author identity.
- Never overwrite existing configuration. Only suggest changes when they are critical.
- Preserve author identity (jonasotoaguilar) in metadata.

DELEGATION MAP:

| Phase                                     | Skill / Tool                                                                                                         | Purpose                                                                                                                                                                                                                                                                                                                                        |
| ----------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1 — Audit, Idea Refinement & Confirmation | (audit) + `interview-me` + `question`                                                                                | Resolve work root, `git init` when needed; audit repo; confirm intent one question at a time before any stack decision                                                                                                                                                                                                                         |
| 2 — Stack Decision                        | `design-architecture`, `design-ui`, `research` (Context7)                                                            | New project: decide architecture and stack explicitly from the decision gates and the confirmed idea. Existing project: audit and document existing conventions, ask only for genuinely missing decisions that change the outcome. Pin current versions, read-only, before any skill search or download; ask the user when genuinely ambiguous |
| 3 — Skill Curation                        | `find-skills`                                                                                                        | After the confirmed stack decision, before stack config: curate OpenCode-only external skills for concrete stack-grounded gaps; install selected skills in project-local `.agents/skills/`; audit existing first                                                                                                                               |
| 4 — Documentation                         | `documentation`, `design-architecture`, `design-ui`, `ui-motion`, `skill-creator`                                    | README/PRD, ARCHITECTURE.md/ADRs (Phase 2 decisions), DESIGN.md, `docs/skill-style-guide.md`, API docs/OpenAPI (template/creation/validation: `documentation`; design decisions: `design-ui`; motion intent/values/standards: `ui-motion`; skill authoring: `skill-creator`; implementation: `frontend-ui-engineering`/`impeccable`)           |
| 5 — Stack Configuration                   | `design-architecture`, `design-ui`, `git-workflow-and-versioning`, `research` (Context7), mutation-testing reference | Apply the Phase 2 stack decision: runtime, lint/format, test/coverage, mutation-testing readiness, dependencies, root gitignore and gitattributes, hooks                                                                                                                                                                                       |
| 6 — CI/CD, Workflows & Community Docs     | `ci-cd-and-automation`, `git-workflow-and-versioning`                                                                | Stack-adaptive CI workflow, canonical PR-check, canonical release workflow + `scripts/release-*` hooks, issue/PR templates, community docs (.github/CODEOWNERS, CONTRIBUTING, SECURITY, CODE_OF_CONDUCT)                                                                                                                                       |
| 7 — Verification & Wrap-Up                | `documentation`, `skill-registry`                                                                                    | Smoke verification, codebase guide (`docs/CODEBASE-GUIDE.md` index + `docs/codebase/` detail pages with `mental-model.md`), AGENTS.md, skill registry rebuild, structured report                                                                                                                                                               |
| 8 — SDD Initialization (mandatory)        | `sdd-init` sub-agent                                                                                                 | Ensure idempotent initialization from the selected artifact store; require preflight; bootstrap context/testing only; report the next planning entry point                                                                                                                                                                                     |
