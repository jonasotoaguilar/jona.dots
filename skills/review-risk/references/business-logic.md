# Business Logic Detection Reference

Signal-triggered checks for the security lens. Load when the change alters workflows, financial calculations, state transitions, inventory/balance handling, or business-critical actions. Report only with confirmed impact within the reviewed scope.

## Reportable patterns

- **Check-then-use races (TOCTOU):** balance/stock/inventory checked and then mutated non-atomically (no `select_for_update`/row lock/atomic increment), enabling overdraft or oversell on concurrent requests.
- **Workflow bypass:** multi-step flows (registration, checkout, approval) whose steps are not enforced server-side (no state machine / server-side step tracking), letting the client jump steps.
- **Client-trusted values:** price, amount, total, discount, or user identity taken from request bodies or hidden fields instead of server-side state or server recalculation.
- **Unbounded/stackable abuse:** discounts, coupons, or referral rewards applicable repeatedly or without limits; negative/zero quantities or prices accepted; integer overflow/underflow in quantity arithmetic.
- **Floating-point money:** financial totals computed with floats instead of `Decimal`/integer cents.
- **Time-based logic using client/application time** where the server clock is the authority (coupon expiry, rate windows) — when the change introduces the comparison.
- **Missing idempotency on critical actions** (payments, transfers, webhook-triggered mutations) that the change adds; duplicate-submission doubles effects.
- **Missing rate limits on business-critical actions** the change adds (transfers, resets, invites).

## Evidence gate

- Confirm the logic flaw is introduced/activated/worsened by the candidate and exploit has a reachable impact (loss, bypass, or abuse).
- General absence of business-rule hardening (limits, idempotency, rate limiting) is not a finding unless the change adds the vulnerable operation.
- Final severity comes from the Output Contract in SKILL.md, never from this reference.
