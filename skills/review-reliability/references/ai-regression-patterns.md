# AI Regression Patterns

The predictable failure pattern of AI-assisted development: when the same model writes code and then reviews it, it carries the same assumptions into both steps. This skill's original context observed:

```
AI writes fix → AI reviews fix → AI says "looks correct" → Bug still exists
```

**Activation**: apply a pattern only when the diff shows its signal (diverged parallel paths, extended shape, error path without cleanup/rollback, optimistic update without rollback, type cast masking null). Boundary/edge-case and concurrency signals have their own sections below. This lens never runs tests or builds and never writes tests; test snippets below are illustrative — they show the evidence to look for when judging whether the change already guards the behavior.

**Real-world example** (observed in production):

```
Fix 1: Added notification_settings to API response
  → Forgot to add it to the SELECT query
  → AI reviewed and missed it (same blind spot)

Fix 2: Added it to SELECT query
  → TypeScript build error (column not in generated types)
  → AI reviewed Fix 1 but didn't catch the SELECT issue

Fix 3: Changed to SELECT *
  → Fixed production path, forgot sandbox path
  → AI reviewed and missed it AGAIN (4th occurrence)

Fix 4: Test caught it instantly on first run PASS:
```

The pattern: **sandbox/production path inconsistency** is the #1 AI-introduced regression.

## Pattern 1: Sandbox/Production Path Mismatch

**Frequency**: Most common (observed in 3 out of 4 regressions)

```typescript
// FAIL: AI adds field to production path only
if (isSandboxMode()) {
  return { data: { id, email, name } };  // Missing new field
}
// Production path
return { data: { id, email, name, notification_settings } };

// PASS: Both paths must return the same shape
if (isSandboxMode()) {
  return { data: { id, email, name, notification_settings: null } };
}
return { data: { id, email, name, notification_settings } };
```

**Signal to check in the diff** — both paths return the same shape:

```typescript
it("sandbox and production return same fields", async () => {
  // In test env, sandbox mode is forced ON
  const res = await GET(createTestRequest("/api/user/profile"));
  const { json } = await parseResponse(res);

  for (const field of REQUIRED_FIELDS) {
    expect(json.data).toHaveProperty(field);
  }
});
```

Report the mismatch only when the change touches both paths and they diverge; a guard already present in the change is evidence the behavior is covered.

## Pattern 2: SELECT Clause Omission

**Frequency**: Common with Supabase/Prisma when adding new columns

```typescript
// FAIL: New column added to response but not to SELECT
const { data } = await supabase
  .from("users")
  .select("id, email, name")  // notification_settings not here
  .single();

return { data: { ...data, notification_settings: data.notification_settings } };
// → notification_settings is always undefined

// PASS: Use SELECT * or explicitly include new columns
const { data } = await supabase
  .from("users")
  .select("*")
  .single();
```

## Pattern 3: Error State Leakage

**Frequency**: Moderate — when adding error handling to existing components

```typescript
// FAIL: Error state set but old data not cleared
catch (err) {
  setError("Failed to load");
  // reservations still shows data from previous tab!
}

// PASS: Clear related state on error
catch (err) {
  setReservations([]);  // Clear stale data
  setError("Failed to load");
}
```

## Pattern 4: Optimistic Update Without Proper Rollback

```typescript
// FAIL: No rollback on failure
const handleRemove = async (id: string) => {
  setItems(prev => prev.filter(i => i.id !== id));
  await fetch(`/api/items/${id}`, { method: "DELETE" });
  // If API fails, item is gone from UI but still in DB
};

// PASS: Capture previous state and rollback on failure
const handleRemove = async (id: string) => {
  const prevItems = [...items];
  setItems(prev => prev.filter(i => i.id !== id));
  try {
    const res = await fetch(`/api/items/${id}`, { method: "DELETE" });
    if (!res.ok) throw new Error("API error");
  } catch {
    setItems(prevItems);  // Rollback
    alert("Delete failed");
  }
};
```

## Pattern 5: Type Cast Masking Null

**Frequency**: Moderate — when a cast, non-null assertion, or newly-narrowed type papers over a value that can be null.

```typescript
// FAIL: Assertion hides a field that can be null in this path
const settings: Settings = raw as Settings;   // raw.settings may be null
const email = user.email!;                    // email may be missing

// PASS: The null case is handled or the type models it
if (!user.email) throw new Error("email missing");
const settings = raw.settings ?? defaultSettings;
```

**Signal to check in the diff** — a cast (`as`), non-null assertion (`!`), `any`/`unknown` escape, or narrowed type added over a field the same change shows can be null or undefined. Report only when a consumer can observably hit the resulting `undefined` or throw; a null that is impossible at runtime is not a finding.

## Input Contract and Boundary Changes

Signal-gated: apply only when the change alters how input is parsed, defaulted, indexed, or bounded.

**Signals in the diff:**

- Parsing changed (formats, delimiters, encodings, type coercion)
- Defaults changed (fallback values, empty-string vs null handling)
- Null/empty inputs newly accepted or newly rejected
- Indexing changed (off-by-one, start/end bounds, inclusive/exclusive)
- Arithmetic changed (precision, overflow, rounding, division)
- Any other input contract callers rely on

**Requirement:** a changed boundary is a finding only when observable behavior can break — a consumer that receives a different shape, an index out of range, a silently wrong value. Confirm with the changed hunks as proof. A test already present in the change that pins the boundary is evidence the behavior is covered; this lens never mandates running or writing tests.

## Concurrency and Stale State

Signal-gated: apply only when the changed flow shows a race or shared-state signal — shared mutable state read or written across an async boundary, check-then-act (read a value, then decide on a stale copy), optimistic updates on shared collections, or cached reads that can go stale.

**Signals in the diff:**

- Shared state mutated in a callback, handler, or `await` continuation
- Check-then-act sequences over a value that can change between the two reads
- Optimistic update or delete over shared state without revalidation on failure
- Cached value read without invalidation after the same change writes it

**Requirement:** report a race only when the changed flow can observably act on stale or torn state (an outdated list, a double-submit, an overridden write). No universal concurrency checklist: flows without shared state or async interleaving are out of scope.

## Strategy: Where Bugs Cluster

Don't apply all five patterns to every change. Instead, prioritize triage where AI-introduced regressions cluster:

```
Change touches parallel paths (sandbox/production, feature flags) → check Pattern 1
Change extends a response shape or query          → check Patterns 1 and 2
Change adds error handling                        → check Pattern 3
Change adds optimistic updates or deletes         → check Pattern 4
Change adds a cast, assertion, or narrowed type over a nullable value → check Pattern 5
Change alters parsing, defaults, null/empty input, indexing, arithmetic, or off-by-one → check Input Contract
Change shows shared mutable state across an async boundary or check-then-act → check Concurrency
No matching signal                                → no pattern applies
```

**Why this works with AI development:**

1. AI tends to make the **same category of mistake** repeatedly
2. Bugs cluster in complex areas (auth, multi-path logic, state management)
3. Reporting only signal-activated patterns keeps findings causal to the change

## Quick Reference

| AI Regression Pattern | Diff signal to check | Priority |
|---|---|---|
| Sandbox/production mismatch | Both parallel paths changed but shapes diverge | High |
| SELECT clause omission | Response references a field the query in the same change never selects | High |
| Error state leakage | Error path added without clearing the state it overwrites | Medium |
| Missing rollback | Optimistic update or delete without restore on failure | Medium |
| Type cast masking null | Cast or non-null assertion added over a field that can be null | Medium |
| Input contract change | Parsing, defaults, null/empty input, indexing, arithmetic, or off-by-one changed with no guard | Medium |
| Race/stale state | Shared state read/written across an async boundary or check-then-act in the change | Medium |

## DO / DON'T

**DO:**
- Activate a pattern only when the diff shows its signal; skip patterns the change does not exhibit
- Check both sides of a parallel path (sandbox/production, client/server, feature flag) within manifest evidence
- Verify shape extensions update every consumer and query the change touches
- Report a missing guard only when the changed behavior is observably unproved
- Base every finding on hunk, created-path, or before/after evidence

**DON'T:**
- Run tests, builds, or scanners; this lens inspects statically
- Write, suggest writing, or demand tests as output
- Apply the five patterns, or the boundary/concurrency signals, as a universal checklist
- Flag missing coverage for behavior the change does not touch
- Treat a test file's presence as proof of correctness without reading it
