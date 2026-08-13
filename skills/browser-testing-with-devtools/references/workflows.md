# Detailed Workflows

## Workflow A: UI Bugs

1. **REPRODUCE** — Navigate to the page, trigger the bug; take a screenshot to confirm visual state.
2. **INSPECT** — Check console for errors/warnings; inspect the DOM element in question; read computed styles; check the accessibility tree.
3. **DIAGNOSE** — Compare actual DOM vs expected structure; compare actual styles vs expected; check if the right data is reaching the component; identify root cause (HTML? CSS? JS? Data?).
4. **FIX** — Implement the fix in source code.
5. **VERIFY** — Reload the page; take a screenshot (compare with step 1); compare console/network against the recorded baseline; run automated tests.

## Workflow B: Network Issues

1. **CAPTURE** — Open the network monitor, trigger the action.
2. **ANALYZE** — Check request URL, method, and headers; verify the request payload matches expectations; check response status code; inspect the response body; check timing (slow? timing out?).
3. **DIAGNOSE** — Compare actual statuses against the expected statuses from the product/test contract (what the flow under test should return), not against a universal 4xx/5xx classification:
   - Unexpected error status → inspect the payload sent, the response body, and server logs; 4xx/5xx are starting points, not diagnoses.
   - CORS → check origin headers and server config only when the evidence (preflight/blocked origin) points there.
   - Timeout → check server response time / payload size.
   - Missing request → check if the code is actually sending it.
4. **FIX & VERIFY** — Fix the issue, replay the action, confirm the response.

## Workflow C: Performance Issues

1. **BASELINE** — Record a performance trace of the current behavior.
2. **IDENTIFY** — Check Largest Contentful Paint (LCP), Cumulative Layout Shift (CLS), Interaction to Next Paint (INP); identify long tasks (>50ms); check for unnecessary re-renders.
3. **FIX** — Address the specific bottleneck.
4. **MEASURE** — Record another trace, compare with baseline.

## Test Plans for Complex UI Bugs

For complex UI issues, write a structured test plan the agent can follow in the browser:

```markdown
## Test Plan: Task completion animation bug

### Setup

1. Navigate to http://localhost:3000/tasks
2. Ensure at least 3 tasks exist

### Steps

1. Click the checkbox on the first task
   - Expected: Task shows strikethrough animation, moves to "completed" section
   - Check: No candidate-caused console errors beyond the recorded baseline
   - Check: Network should show PATCH /api/tasks/:id with { status: "completed" }

2. Click undo within 3 seconds
   - Expected: Task returns to active list with reverse animation
   - Check: No candidate-caused console errors beyond the recorded baseline
   - Check: Network should show PATCH /api/tasks/:id with { status: "pending" }

3. Rapidly toggle the same task 5 times
   - Expected: No visual glitches, final state is consistent
   - Check: No candidate-caused console errors, no duplicate network requests
   - Check: DOM should show exactly one instance of the task

### Verification

- [ ] All steps completed without candidate-caused console errors beyond the recorded baseline
- [ ] Network requests are correct and not duplicated
- [ ] Visual state matches expected behavior
- [ ] Accessibility: task status changes are announced to screen readers
```

## Screenshot-Based Verification

1. Take a "before" screenshot.
2. Make the code change.
3. Reload the page.
4. Take an "after" screenshot.
5. Compare: does the change look correct?

Especially valuable for: CSS changes (layout, spacing, colors); responsive design at different viewport sizes (use `emulate`); loading states and transitions; empty states and error states.

## Console Analysis Patterns

### What to Look For

```
ERROR level:
  ├── Uncaught exceptions → Bug in code
  ├── Failed network requests → API issue; compare status against the expected contract
  ├── React/Vue warnings → Component issues
  └── Security warnings → CSP, mixed content

WARN level:
  ├── Deprecation warnings → Future compatibility issues
  ├── Performance warnings → Potential bottleneck
  └── Accessibility warnings → a11y issues

LOG level:
  └── Debug output → Verify application state and flow
```

### Clean Console Standard

Baseline-aware, not zero-warning absolutism: record the console/network baseline and any exclusions before asserting. New candidate-caused errors or scenario-relevant warnings block verification; known baseline items are reported distinctly and do not become candidate failures unless they worsened.

## Accessibility Verification with DevTools

Accessibility checks follow the project's declared WCAG/accessibility contract; do not hardcode a universal level or contrast requirement. The common WCAG 2.1 AA example (4.5:1 for normal text) is illustrative only — verify against the project's declared target.

1. Read the accessibility tree — confirm all interactive elements have accessible names.
2. Check heading hierarchy — no skipped levels.
3. Check focus order — tab through the page, verify logical sequence.
4. Check color contrast — verify text meets the project's declared contrast requirement (example only: WCAG 2.1 AA is 4.5:1 for normal text).
5. Check dynamic content — verify ARIA live regions announce changes.
