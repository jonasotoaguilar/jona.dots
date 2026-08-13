# Non-Functional Requirements Checklist

**Load only the categories affected by the change.** Cover applicable categories with measurable targets; do not force all sections when only a subset applies. "Fast", "scalable", "secure" are NOT NFRs — every covered NFR needs a measurable target.

Architecture captures targets, trust boundaries, and constraints only. Operational mechanics (SLO burn-rate alerting, runbooks, capacity plans, chaos runs) → typed handoff to `sre-engineer`; telemetry implementation → `observability-and-instrumentation`; security implementation/review → elsewhere (e.g. `review-risk`). This reference never prescribes implementations.

## Category Coverage

| Category                | Key Questions                                                       | Default Target                               |
| ----------------------- | ------------------------------------------------------------------- | -------------------------------------------- |
| **Performance**         | API p95 latency? Page load time? DB query p95?                      | < 100ms / < 2s / < 50ms                      |
| **Scalability**         | Concurrent users? RPS? Data volume? Growth rate? Peak vs avg?       | 1K / 100 / GB / 50% / 5x                     |
| **Availability**        | Uptime target? RPO? RTO?                                            | 99.9% (8.76h/yr) / 1h / 4h                   |
| **Reliability**         | Backup frequency? DR strategy?                                      | Daily / multi-region                         |
| **Security**            | Trust boundaries? AuthN/AuthZ? Secrets? Encryption? Compliance?     | See Security rules below                     |
| **Privacy / PII**       | Data classification? Residency? Retention? Subject rights?          | See Privacy rules below                      |
| **Audit Logging**       | Who/what/when logged? Tamper-evidence? Retention? Access?           | See Audit rules below                        |
| **Observability**       | Which signals must each service expose?                             | See Observability rules below                |
| **Supply Chain / SBOM** | Dependency provenance? Vulnerability scan? Signed builds? Lockfile? | See Supply Chain rules below                 |
| **Maintainability**     | Deploy frequency? CI/CD? IaC? Rollback?                             | Weekly / blue-green / GH Actions / Terraform |
| **Cost**                | Monthly budget? Cost per user/request? Quotas? Alert thresholds?    | $1K / estimate / quotas / alert at 80%       |

## Capacity Estimation

State **average load**, **peak load** (with its driver — launch, seasonality, batch), **growth rate** over the horizon, and the **headroom** above peak you commit to. Estimates are reviewed when measured load approaches the peak, not when it exceeds it. Decisions that depend on the estimate (instances, pools, queue sizes) inherit its uncertainty — record it with its assumptions.

## SLO Targets

Availability/latency NFRs become enforceable contracts only through the SLO chain: SLI (measured ratio), SLO (target + window, e.g. 99.9% over 30 days), error budget (1 − target). Every SLO needs justification from user impact — a target nobody notices is not an NFR. Burn-rate alerting, error-budget operations, and runbooks are `sre-engineer` territory (typed handoff), not designed here.

## Observability Targets

The architecture decides which signals each service must expose (golden signals: latency, traffic, errors, saturation; RED for request-driven, USE for resources) and names the instrumentation seams — request entry points, external dependency calls, async hops, transaction boundaries — so traces and metrics can reconstruct any request. Signal implementation/verification → `observability-and-instrumentation`. "Alerted before users report" is the acceptance criterion for observability NFRs.

## RTO/RPO Validation

State RTO and RPO per data set, then **validate the strategy against them** (failover/restore/replication rehearsal, chaos/game-day). An unvalidated DR target is a number, not a requirement. Recovery validation is part of the design (see `resilience-patterns.md`); execution → `sre-engineer`.

## Security Rules (architecture surface only)

- **Trust boundaries**: identify every cross-trust seam (public ingress, internal service, admin plane, third-party API); each MUST have an explicit authN/authZ decision (model per surface: OAuth2, mTLS, API key, RBAC/ABAC).
- **Secrets**: no secrets in env files, code, or logs; secret manager; rotation cadence documented (including scheduled rotation for long-lived credentials).
- **Data lifecycle**: every data class has a retention/deletion/access decision; data without a lifecycle is accumulating liability.
- **Abuse**: rate limit, throttle, lock out at trust boundaries; define the abuse model per surface (credential stuffing, scraping, expensive query abuse).
- **Encryption**: at rest and in transit (TLS 1.2+); state cipher/key-management approach.
- **Compliance**: name the regime (SOC2, PCI-DSS, HIPAA, GDPR) only if it actually applies; do not invent.

This is a reminder of applicable surfaces, not a security review — implementation/testing defer to a security-review skill.

## Privacy / PII Rules

- **Classification**: tag every data store (public, internal, confidential, PII, sensitive-PII) at design time.
- **Residency**: state region/locale requirement per PII store.
- **Retention & deletion**: TTL and deletion trigger per data class.
- **Subject rights**: how access, export, and deletion requests are honored.

## Audit Logging Rules

- **Who/what/when**: every state-changing action and auth/authZ decision logged with actor, target, timestamp, outcome.
- **Tamper-evidence**: append-only or write-once; never reuse the application log pipeline.
- **Retention**: align with compliance regime; default 1 year.
- **Access**: who can read audit logs; production access itself audited.

## Supply Chain / SBOM Rules

- **Provenance**: declare the source (registry, internal artifact, vendor) for every runtime dependency.
- **Vulnerability scanning**: scan on every build; block on critical/high.
- **Lockfile**: commit the lockfile; builds must be reproducible.
- **Signed builds**: sign release artifacts when distribution crosses a trust boundary.
- **SBOM**: generate (CycloneDX or SPDX) for release artifacts when compliance requires it.

## Hard Rules

- Every covered NFR MUST have a measurable target; only affected categories are covered.
- Availability without RPO and RTO is meaningless — state both; unvalidated RTO/RPO is a number, not a requirement.
- Systems handling PII, secrets, or state changes MUST cover Security, Privacy, and Audit Logging.
- Public or partner-facing systems MUST cover Supply Chain / SBOM.
- SLO targets require user-impact justification; capacity estimates require explicit peak/growth/headroom assumptions.
