---
name: sre-engineer
description: "Trigger: SLO/error-budget policy, capacity planning, runbooks, chaos/game-day runs, toil automation, alerting/monitoring platforms. Platform SRE policy, not feature telemetry implementation."
license: MIT
metadata:
  author: jonasotoaguilar
  version: "1.3.0"
---

## Activation Contract

Self-contained SRE knowledge base for SLO/error-budget policies, monitoring/alerting config, chaos/game-day runs, capacity plans, toil automation, and runbooks. Load when the task covers SRE work for design, implementation, or verification. **Signal-gated, not universal**: each practice applies only when the task and system make it relevant.

## Hard Rules

- **Respect decided targets.** Apply the SLO targets, error budgets, RTO/RPO, and capacity numbers the task carries; never invent or silently change them.
- **In-task output.** Configs/scripts/runbooks for the work unit only.
- **Signal-gated runbooks.** Author runbooks only for operationally actionable systems and alerts — systems with on-call/alerting surfaces, or alerts that need remediation steps. Not every work unit gets a runbook.
- **Signal-gated chaos.** Chaos/game-day runs happen only when explicitly in scope AND the environment is safe to perturb (non-production or approved production window). Never run chaos by default.
- **Signal-gated toil.** The toil <50% threshold applies only when toil is measured and an existing target governs it; otherwise report measured toil without inventing a threshold.
- **Signal-gated capacity.** Capacity plans only for load/release-relevant work (deploys, scale events, releases); not for routine changes.
- **Observability boundary.** When the work implements an approved signal contract, hand the implementation/verification to `observability-and-instrumentation`; this skill owns SLO/error-budget/alert-platform policy, runbooks, capacity, toil, and incident/chaos practice.
- **MUST:** quantitative SLOs with user-impact justification; budgets from targets; golden signals; blameless postmortems.
- **MUST NOT:** set SLOs without user-impact justification; alert on symptoms without actionable runbooks; skip postmortems or assign blame; deploy without capacity planning for load-relevant changes; ignore error-budget exhaustion; non-degradable systems.

## Decision Gates

| Topic                                    | Reference                                                     |
| ---------------------------------------- | ------------------------------------------------------------- |
| SLO/SLI, error budgets, burn rates       | `references/slo-sli-management.md`                            |
| Budget policies, freezes                 | `references/error-budget-policy.md`                           |
| Golden signals, alert design, dashboards | `references/monitoring-alerting.md`                           |
| Toil reduction, automation patterns      | `references/automation-toil.md`                               |
| Incident response, chaos engineering     | `references/incident-chaos.md`                                |
| Runbook authoring                        | `references/runbook-guide.md`                                 |
| Approved signal contract implementation  | hand to `observability-and-instrumentation` (never duplicate) |

## Execution Steps

1. Confirm the task includes SRE implementation; read the task's decided targets (SLO/budget/RTO/RPO/capacity) first.
2. Load the matching reference(s) above.
3. Implement within the work unit, signal-gated: configs, automation, chaos/game-day runs (only when in scope and safe), runbooks (only for operationally actionable systems/alerts), capacity (only for load/release-relevant work).
4. For an approved signal contract, hand implementation/verification to `observability-and-instrumentation`; keep policy/runbook/platform ownership here.
5. Verify recovery vs RTO/RPO; report to the task owner.

## Output Contract

Return: SLO/error-budget policies + monitoring/alerting configs; automation scripts; runbooks with remediation steps (only where signal-gated); chaos/game-day results vs decided RTO/RPO (only when run); capacity notes (only for load-relevant work); reliability note; references consulted; any skipped practice with its reason.

## References

- `references/slo-sli-management.md` · `references/error-budget-policy.md` · `references/monitoring-alerting.md` · `references/automation-toil.md` · `references/incident-chaos.md` · `references/runbook-guide.md`.
