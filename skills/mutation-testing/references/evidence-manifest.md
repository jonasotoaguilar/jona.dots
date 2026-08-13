# Evidence Manifest (Mutation Testing)

Canonical contract for the machine-readable evidence block returned inside `### Mutation Testing Evidence`. The parent `sdd-verify` phase embeds the block into the exact complete report bytes BEFORE running `gentle-ai sdd-verify-validate`, then persists only the admitted bytes. This support layer never persists, never searches Engram, and never writes OpenSpec or any separate artifact.

Manifest status is EVIDENCE-LEVEL ONLY: never emit or prescribe phase severity (CRITICAL/WARNING/SUGGESTION) or phase verdicts (PASS/PASS WITH WARNINGS/FAIL); `sdd-verify` exclusively maps findings to severity and chooses the verdict. Internal triage labels (survivor buckets) are NOT severity.

Prior evidence is recovered ONLY from the parent-delivered `contextFiles.verifyReport` (its `### Mutation Testing Evidence` block). There is no separate artifact, Engram, or cache authority.

## Schema

Fenced `json` block labeled with the fixed schema name `gentle-ai.mutation-evidence/v1`:

```json
{
  "schema": "gentle-ai.mutation-evidence/v1",
  "change_name": "auth-login-refactor",
  "campaign_id": "cam-20260812T093000Z-3f9a21",
  "campaign_type": "full",
  "generated_at": "2026-08-12T09:30:00Z",
  "candidate_fingerprint": "sha256:9f2c...64-hex",
  "candidate_binding_strength": "strong",
  "scope_fingerprint": "sha256:4be1...64-hex",
  "baseline_suite_hash": "sha256:parent-test-output-hash-verbatim",
  "baseline_hash_kind": "opaque",
  "tool": { "name": "mewt", "version": "0.7.1" },
  "config_fingerprint": "sha256:c7d9...64-hex",
  "harness_disposition": "reused",
  "repro": {
    "cwd": "src/auth",
    "command": "mewt run src/auth",
    "seed": null,
    "timeout_seconds": 45
  },
  "counts": {
    "total": 120,
    "killed": 105,
    "survived": 12,
    "timeout": 2,
    "error": 1
  },
  "counts_source": "executed",
  "survivors": [
    {
      "stable_id": "sha256:1a2b...64-hex",
      "framework_id": "42",
      "file_path": "src/auth/login.rs",
      "line": 42,
      "symbol": "validate_credentials",
      "mutation_type": "comparison_operator",
      "original": ">=",
      "replacement": ">",
      "triage_bucket": "missing_test",
      "action": "add boundary test for < and == at this comparison",
      "remediation_required": true
    }
  ],
  "selected_mutant_ids": ["42"],
  "incremental_eligible": true,
  "prior_evidence_revision": "sha256:prior-manifest-digest",
  "cache_manifest": [],
  "invalidation_reasons": [],
  "status": "fail"
}
```

Teaching case: `status: fail` with actionable survivors carrying exact location/mutation/action and `remediation_required: true`. `pass` → empty `survivors[]`, zero actionable findings; `not_applicable`/`unavailable`/`blocked` → zero counts, no survivors.

## Field Semantics

| Field                      | Required         | Semantics                                                                                                                                                                           |
| -------------------------- | ---------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| schema                     | yes              | fixed `gentle-ai.mutation-evidence/v1`                                                                                                                                              |
| change_name                | yes              | parent `changeName`; may be null                                                                                                                                                    |
| campaign_id                | yes              | unique per bounded campaign (`cam-<UTC YYYYMMDDTHHMMSSZ>-<8 hex>`); informational, never authority                                                                                  |
| campaign_type              | yes              | what ACTUALLY ran: `full`/`incremental`/`reused`; `invalidated` is never a campaign_type (audit event in `invalidation_reasons`)                                                    |
| generated_at               | yes              | UTC RFC3339; informational only — timestamps are never authority                                                                                                                    |
| candidate_fingerprint      | yes              | content-binding hash of the change under verification                                                                                                                               |
| candidate_binding_strength | yes              | `strong`/`weak`; weak forces full for reuse/incremental                                                                                                                             |
| scope_fingerprint          | yes              | canonical ordered production targets + impacted functions/symbols → sha256                                                                                                          |
| baseline_suite_hash        | yes              | parent `test_output_hash` reused VERBATIM; never invented or recomputed                                                                                                             |
| baseline_hash_kind         | yes              | `semantic`/`deterministic`/`opaque`; parent attests; never inferred from hash bytes; absent attestation → `opaque` → no reuse/incremental                                           |
| tool                       | yes              | `{name, version}`; version REQUIRED for reuse decisions                                                                                                                             |
| config_fingerprint         | yes              | effective config + mutation-type set + severity semantics → canonical sha256                                                                                                        |
| harness_disposition        | no               | `reused`/`invalidated` when parent/ledger delivers it; `invalidated` changes the decision                                                                                           |
| repro                      | no               | `cwd` (POSIX project-relative non-sensitive or basename — never absolute/home/tmp), `command` (exact), `seed` (or null), `timeout_seconds` (bounded); omit what cannot be sanitized |
| counts                     | yes              | `total`/`killed`/`survived`/`timeout`/`error`; zeroed for not_applicable/unavailable/blocked                                                                                        |
| counts_source              | yes              | `executed`/`inherited`/`mixed`                                                                                                                                                      |
| survivors                  | yes              | one entry per survivor; stable identity first                                                                                                                                       |
| selected_mutant_ids        | incremental only | framework IDs rerun; empty for full/reused                                                                                                                                          |
| incremental_eligible       | yes              | `true` only when EVERY prior survivor ID is present and resolvable in THIS manifest; `false` forces full in future campaigns                                                        |
| prior_evidence_revision    | yes              | digest of the prior manifest delivered AND parsed — including when invalidated; null when none delivered/unparseable                                                                |
| cache_manifest             | yes              | regenerable artifacts only: `authoritative` always false, `regenerable` always true; POSIX project-relative paths only                                                              |
| invalidation_reasons       | yes              | audit events when a delivered prior manifest was rejected                                                                                                                           |
| status                     | yes              | evidence-level: `pass`/`fail`/`not_applicable`/`unavailable`/`blocked`                                                                                                              |

Survivor entries: `stable_id` (required), `framework_id` (optional), exact location (`file_path`, `line`), `symbol`, `mutation_type`, `original`/`replacement` when safely available, `triage_bucket`, `action`, `remediation_required`. A survivor WITHOUT `framework_id` cannot be resolved for targeted rerun: if ANY survivor lacks it, incremental is impossible → full.

## Status Vocabulary (evidence-level)

| Status           | Meaning for the parent                                                                               |
| ---------------- | ---------------------------------------------------------------------------------------------------- |
| `pass`           | campaign ran; zero survivors and zero actionable findings. Evidence only                             |
| `fail`           | campaign ran; actionable survivors exist. Never a phase FAIL by itself                               |
| `not_applicable` | no changed/impacted executable production target (or unchanged-candidate reuse applied); zero counts |
| `unavailable`    | framework/analyzer unavailable; preserved error; zero counts                                         |
| `blocked`        | parent baseline precondition failed; preserved evidence; zero counts                                 |

## Counts Source

- `executed`: full campaign ran; all counts fresh from this run.
- `inherited`: reused; ZERO execution; counts copied verbatim from the prior manifest.
- `mixed`: incremental; `total` unchanged from prior; rerun-subset outcomes REPLACE their prior rows; `survivors[]` = rerun-subset survivors (full detail) + inherited prior survivors outside the rerun set (minimal identity entries). Unchanged evidence is never silently dropped (`prior_evidence_revision` preserves it).

## Reuse Identity

Reuse/incremental decisions compare ONLY: `candidate_fingerprint` + `candidate_binding_strength` (strong AND identical required), `scope_fingerprint`, `config_fingerprint`, `tool.version`, `baseline_hash_kind` (non-opaque required), `prior_evidence_revision`, `harness_disposition`. Cross-run survivor identity is `stable_id`: sha256 over deterministic UTF-8 JSON array `["<path>","<symbol>","<mutation_type>","<original>","<replacement>"]` (fixed positions; `unavailable` marker for unsafe snippets). `framework_id` is single-campaign acceleration only — never compare framework IDs across campaigns. Canonicalization: POSIX relative paths, sorted lists, symbols trimmed with whitespace collapsed. `baseline_suite_hash` is the parent's value, never computed here.

## Deterministic Reuse Matrix

Decide BEFORE running; the decision produces exactly ONE bounded campaign. Rows evaluated top-to-bottom; FIRST matching row wins. `campaign-scoping.md` mirrors this matrix; the primary skill gates summarize it.

| # | Condition                                                                                                                                                                                                                                                               | Decision                                                                                                                                                                                                                                                                                                                  |
| - | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1 | No relevant change (production/test/config/tool/dependency/harness) AND strong identical bindings AND prior status `pass` with no survivors                                                                                                                             | **reused** — ZERO execution; counts inherited verbatim (`counts_source: inherited`)                                                                                                                                                                                                                                       |
| 2 | Production unchanged (strong identical candidate binding) AND delta limited to added/strengthened tests AND prior survivors ALL carry resolvable `framework_id` AND framework supports targeted rerun AND every prior ID resolves AND prior `incremental_eligible` true | **incremental** — rerun only prior survivors (`selected_mutant_ids`); `counts_source: mixed`                                                                                                                                                                                                                              |
| 3 | Production changed AND impacted targets/functions PROVABLE from changed files/functions + dependency/call graph (transitive impacted functions count) AND framework can target the associated mutants                                                                   | **incremental** — rerun only invalidated/impacted mutant IDs; unchanged prior evidence preserved; else **full**                                                                                                                                                                                                           |
| 4 | Mutation config/tool/version/dependency drift                                                                                                                                                                                                                           | **full** (`config_drift`/`tool_drift`/`dependency_drift`)                                                                                                                                                                                                                                                                 |
| 5 | Tests deleted/weakened OR `harness-disposition: invalidated` without proof of additive/strengthening test-only change                                                                                                                                                   | **full** (`test_suite_weakened`/`harness_invalidated`)                                                                                                                                                                                                                                                                    |
| 6 | Prior manifest missing/weak/malformed/schema unsupported                                                                                                                                                                                                                | **full** (`prior_malformed`/`prior_schema_unsupported`; `prior_evidence_revision` null when none delivered)                                                                                                                                                                                                               |
| 7 | Prior status unavailable/blocked/interrupted                                                                                                                                                                                                                            | **full** (`prior_unavailable`) — never inherit a pass                                                                                                                                                                                                                                                                     |
| 8 | Baseline kind `opaque`/missing                                                                                                                                                                                                                                          | **full** (`baseline_opaque`) — no reuse/incremental                                                                                                                                                                                                                                                                       |
| 9 | No changed/impacted executable target                                                                                                                                                                                                                                   | **not_applicable** — EXCEPT the unchanged-candidate rule: parent re-delivers a prior `pass` manifest whose strong bindings still match the UNCHANGED candidate (identical candidate/scope/config/tool fingerprints, non-opaque baseline, no survivors) → **reused** (zero execution, inherited counts); never incremental |

Procedure: extract the prior manifest (or record prior unavailable); unparseable or unsupported → full with a typed invalidation. Verify non-full preconditions (rows 1–3): strong candidate binding, non-opaque baseline attestation, complete fingerprints, tool version present. Apply harness disposition: `invalidated` blocks row 1, and row 2 unless the invalidation is PROVEN an additive/strengthening test-only change with all other bindings holding; otherwise row 5 → full. Incremental (rows 2–3): resolve every prior `framework_id` at runtime; any unresolvable/unprovable ID → full. Execute exactly ONE bounded campaign of the decided type; rejected priors recorded in `invalidation_reasons`.

## Invalidation Events

Rejected priors are recorded as audit events inside `invalidation_reasons`:

```json
{
  "kind": "invalidated",
  "reason": "harness_invalidated",
  "prior_evidence_revision": "sha256:prior-manifest-digest"
}
```

Typed reasons: `scope_drift`, `config_drift`, `tool_drift`, `dependency_drift`, `test_suite_weakened`, `test_suite_changed`, `harness_invalidated`, `cache_missing`, `fingerprint_missing`, `binding_weak`, `baseline_opaque`, `prior_malformed`, `prior_schema_unsupported`, `prior_unavailable`. `harness_invalidated` is emitted when the parent-provided/ledger `harness-disposition: invalidated` forces full without test-only proof. The executed campaign is `campaign_type: full` — one run, no second campaign; `invalidated` is never a campaign_type value.

## Test-Only Change Rules

- Added/strengthened tests: production fingerprint must remain identical; allowed decision is incremental over the survivor/failed set only — never `reused` (the test delta may have killed some).
- Deleted/weakened tests → full (`test_suite_weakened`); the suite binding is no longer trustworthy.
- Any test change + prior PASS with no survivors → conservative full (`test_suite_changed`) UNLESS strong proof the test semantics do not affect the mutation campaign.
- Reused never approves after a relevant content change: strong AND identical candidate fingerprint required, plus identical scope/config/tool fingerprints and baseline binding.

## Determinism and Reverify Continuity

Given identical inputs, the block is byte-deterministic EXCEPT the informational `generated_at`/`campaign_id`. Authority is fingerprints, digests, and `prior_evidence_revision` only. Never fabricate commands or flags that are not documented and runtime-proven.

EVERY reverify is a NEW parent-acquired attempt; the parent MUST re-deliver the prior verify-report via `contextFiles.verifyReport` on every reverify; absent re-delivery → prior unavailable → full. Prior report present but with NO mutation block, an unparseable block, or an unsupported schema → full with a typed event (`prior_malformed`/`prior_schema_unsupported`); never guess fields from a broken block. No implicit continuity from tmp/, caches, or tool databases.

## Size Policy

Manifest ≤ 256 KiB (report well under 1 MiB). `survivors[]` full-detail cap: `survivor_cap: 512`; overflow degrades to minimal identity entries (`stable_id`, `framework_id`, `file_path`, `line`) so IDs stay available for targeted rerun. If even minimal entries cannot fit: `incremental_eligible: false`, keep full `counts`, keep up to `survivor_cap` full-detail entries as bounded representatives. Counts are always preserved in full.
