# README Guide

Use with `../assets/readme-template.md`. A README is the project's **front door**: what it is, who it helps, why it exists, and how to reach first success — then routes readers to deeper docs. Technical depth is linked from `docs/`, never duplicated. Apply `cognitive-doc-design` patterns; this guide holds README-specific gates only.

## Invariants (always)

- **Hero as the cover**: centered `<div align="center">` block — banner (optional), `h1`, one-line tagline, badge row (release, license, runtime, platform).
- **Happy path first**: Quick Start delivers first success in under 5 minutes; alternatives collapse into `<details>` after the happy path.
- **License footer is final**: centered badge linking to `LICENSE`, always the last element of the file.
- **Link, don't restate**: deeper docs are linked, never duplicated; the README is not the API reference.

## Adapt to the project and stack

| Project type           | Shape                                                                                                                                                  |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| CLI / ecosystem tool   | What It Does → Quick Start → Core Workflow → Key Features → Documentation                                                                              |
| Library / SDK          | Minimal Quick Start (install + first snippet); short usage example + API reference link; Configuration table when options exist                        |
| Web app / service      | Quick Start covers local setup; Local Development when distinct dev steps exist; deployment/operation in Core Workflow; screenshots or demo link early |
| Small / single-purpose | Hero, What It Does, Quick Start, License footer                                                                                                        |

Reorder sections and rename titles to the project's vocabulary; drop any section that does not earn its place. The invariants above always hold.

## Structure

1. **Hero** — banner, `h1`, tagline, badges.
2. **What It Does** — what the project is, who it is for, a **Before/After** problem framing; `Supported Integrations` table only when multiple integrations exist.
3. **Quick Start** — install (recommended) with per-platform commands, then first-success verification or an initial-config table (`{Command} | What it does | When to re-run`). Alternatives in a `<details>` block. `Local Development` / `Troubleshooting` subsections only when the project has distinct dev steps or recurring high-value failure recovery; otherwise they become Documentation-table rows.
4. **Core Workflow** (optional) — the main end-to-end flow a user repeats, outcome-oriented; add a small `mermaid` diagram only when it clarifies the order.
5. **Key Features** (optional) — differentiating features with depth and a short example, not a catalog dump.
6. **Documentation** — `| Your task | Start here |` table when deeper docs exist; "Report a vulnerability → SECURITY.md" row only when SECURITY.md exists.
7. **Community Highlights** (optional) — community integrations and contributors.
8. **Next Steps** — role-based pointers to deeper docs.
9. **License footer** — centered badge linking to `LICENSE`; nothing follows.

## Decisions

- **License**: represented as a badge linking to `LICENSE` — in the hero (optional but common) and always in the centered footer. Never a prose `## License` section.
- **Admonitions** (`> [!IMPORTANT]`, `[!NOTE]`, `[!WARNING]`): for signposting; critical version/prerelease/prerequisite notes go early and stay short.
- **Security boundary**: `SECURITY.md` owns vulnerability disclosure, supported versions, and response expectations. Stack-specific hardening (package-manager policy, lifecycle-script allowlists, audit/signature checks, lockfile integrity, cooldowns) belongs to the owning stack skill and project config/CI. The README links to SECURITY.md, never duplicates policy.
- **Link/command verification**: every linked path must exist or be explicitly requested; every documented command must run as written (no invented flags). Install/update commands never hardcode a version — use a dynamic resolver or a `<version>` placeholder (release documents exempt).

## Author checklist (never a section)

- [ ] Hero renders; a new user reaches first success from Quick Start alone.
- [ ] Required post-install setup documented (table with "When to re-run" where it recurs).
- [ ] Deep-dive docs linked, not duplicated; Documentation table present when deeper docs exist.
- [ ] Security row in the Documentation table only when SECURITY.md exists.
- [ ] License badge footer is the final element.
- [ ] Links verified to exist; commands verified; no pinned versions.

## Avoid

- Long marketing copy before setup; API-reference or manual depth (link to `docs/`).
- Duplicating CONTRIBUTING, CHANGELOG, or LICENSE content; hiding required config in later sections.
- Restating security policy owned by SECURITY.md or a stack skill; a `## License` prose section.
