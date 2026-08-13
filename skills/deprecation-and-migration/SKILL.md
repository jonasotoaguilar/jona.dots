---
name: deprecation-and-migration
description: "Trigger: remove old systems, sunset features, migrate users, consolidate duplicates, replace libraries or APIs. Owned, bounded deprecation and safe migration."
license: Apache-2.0
metadata:
  author: jonasotoaguilar
  version: "1.1"
---

## Activation Contract

Use when replacing or sunsetting a system, API, library, or feature; consolidating duplicate implementations; removing code nobody owns but depends on; planning a lifecycle at design time; or deciding whether to maintain or remove existing code.

## Hard Rules

- **Inventory consumers and usage first.** Quantify who and what depends on the target (code references, metrics, logs, dependency analysis) before any removal or announcement.
- **A replacement must be ready.** Do not deprecate without a working, production-proven alternative covering the critical use cases.
- **Bound the migration.** Every deprecation has a removal date and an owner. Advisory without a deadline is not a deprecation; indefinite compatibility or parallel operation is not a default.
- **Bridges are temporary and time-boxed.** Strangler, adapter, or feature-flag bridges are allowed only when explicitly required; each gets an owner, a removal date, and a decommission path. No bridge becomes the permanent state.
- **Migrate, then prove removal.** Consumers move one at a time; verify zero active usage before deleting code, tests, documentation, and configuration.
- **Never change a schema in place.** Use expand/contract: additive phases first, destructive steps alone in a later deploy, and a tested down path for every migration.

## Decision Gates

| Situation                                  | Action                                                                      |
| ------------------------------------------ | --------------------------------------------------------------------------- |
| System still provides unique value         | Maintain it                                                                 |
| No replacement exists                      | Build the replacement first; do not announce removal                        |
| Migration optional, old system stable      | Advisory deprecation with a deadline and documentation                      |
| Security risk or unsustainable cost        | Compulsory deprecation with tooling, docs, and support                      |
| Bridge (strangler/adapter/flag) considered | Only if required; assign owner, time-box, decommission path                 |
| Schema change                              | Expand → dual-write/backfill → switch reads → contract in a separate deploy |

## Execution Steps

1. **Inventory:** enumerate consumers and current usage; record the baseline.
2. **Confirm replacement readiness** against critical use cases and production evidence.
3. **Announce and document:** status, replacement, removal date, and a concrete migration guide.
4. **Migrate incrementally:** one consumer at a time; verify behavior parity and no regressions before removing old references.
5. **Remove with proof:** verify zero active usage via metrics, logs, or dependency analysis, then delete code, tests, docs, config, and notices.
6. **For schema migrations:** expand additively, backfill in throttled batches off the hot path, switch reads, then drop old columns in a separate deploy — each step independently deployable and reversible, with a tested down path.

## Output Contract

Return: consumer/usage inventory with baseline; replacement status and evidence; migration guide delivered or linked; per-consumer migration status; removal proof (zero active usage, no remaining references); schema migration phases and down-path verification; owner and removal date for any temporary bridge; unresolved risks.

## References

None. Self-contained; no supporting files.
