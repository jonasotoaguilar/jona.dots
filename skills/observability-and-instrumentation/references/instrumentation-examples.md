# Observability & Instrumentation — Examples (lazy)

Worked code examples for `observability-and-instrumentation`. Upstream content from addyosmani/agent-skills (MIT), preserved for reference; adapt to the target stack.

## On-Call Questions Template

```
FEATURE: checkout payment retry
QUESTIONS ON-CALL WILL ASK:
1. What fraction of payments succeed on first attempt vs after retry?
2. When a payment fails permanently, why? (provider error? timeout? validation?)
3. Is the payment provider slower than usual?
→ Every signal below must help answer one of these.
```

## Structured Logging

```typescript
// BAD: string interpolation — unqueryable, inconsistent
logger.info(`Payment ${id} failed for user ${userId} after ${n} retries`);

// GOOD: stable event name + structured fields
logger.warn({
  event: 'payment_failed',
  paymentId: id,
  provider: 'stripe',
  errorCode: err.code,
  attempt: n,
}, 'payment failed');
```

## Correlation IDs (mandatory)

```typescript
// Express: child logger per request, ID propagated downstream
app.use((req, res, next) => {
  req.id = req.headers['x-request-id'] ?? crypto.randomUUID();
  req.log = logger.child({ requestId: req.id });
  res.setHeader('x-request-id', req.id);
  next();
});
```

## Metrics (RED) — prom-client

```typescript
import { Histogram } from 'prom-client';

const httpDuration = new Histogram({
  name: 'http_request_duration_seconds',
  help: 'HTTP request duration',
  labelNames: ['method', 'route', 'status_class'],  // '2xx', not '200'
  buckets: [0.05, 0.1, 0.25, 0.5, 1, 2.5, 5],
});
```

Cardinality rule:

```
OK as label:    route="/api/tasks/:id"   status_class="5xx"   provider="stripe"
NEVER a label:  user_id, email, request_id, full URL, error message text
```

## Distributed Tracing — OpenTelemetry

```typescript
// tracing.ts — must be imported before anything else
import { NodeSDK } from '@opentelemetry/sdk-node';
import { getNodeAutoInstrumentations } from '@opentelemetry/auto-instrumentations-node';

const sdk = new NodeSDK({
  serviceName: 'checkout-service',
  instrumentations: [getNodeAutoInstrumentations()],
});
sdk.start();
```

## Symptom vs Cause Alerting

```
SYMPTOM (page-worthy):           CAUSE (dashboard, not a page):
error rate > 1% for 5 min        CPU at 85%
p99 latency > 2s                 one pod restarted
queue age > 10 min               disk at 70%
```

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "I'll add logging after it works" | "After" becomes "after the first incident", which is the most expensive moment to discover you're blind. Instrument as you build. |
| "More logs = more observability" | Unstructured noise makes incidents slower, not faster. Three queryable events beat three hundred prose lines. |
| "console.log is fine for now" | Unstructured output can't be filtered, correlated, or alerted on. The structured logger costs five extra minutes once. |
| "We can just look at the dashboards when something breaks" | Dashboards built without defined questions show you everything except the answer. Start from on-call questions. |
| "Alert on everything important, we'll tune later" | A noisy pager trains people to ignore it. The tuning never happens; the missed real page does. |
| "User ID as a metric label makes debugging easier" | It also makes your metrics backend fall over. High-cardinality lookups belong in logs and traces. |
| "Tracing is overkill for our two services" | Two services already means cross-service latency questions logs can't answer. Auto-instrumentation makes the cost trivial. |

## Log Levels

| Level | Meaning | On-call action |
|---|---|---|
| `error` | Invariant broken; someone may need to act | Investigate |
| `warn` | Degraded but handled (retry succeeded, fallback used) | Watch for trends |
| `info` | Significant business event (order placed, job finished) | None |
| `debug` | Diagnostic detail | Off in production by default |
