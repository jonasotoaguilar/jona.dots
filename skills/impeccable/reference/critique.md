### Purpose

Resolve one stable target, run two independent assessments, synthesize a design critique, persist a snapshot, and ask the user what to improve next. The chat response is the primary deliverable; the snapshot is an archive/backlog for future commands.

### Hard Invariants

- Assessment A (design review) and Assessment B (detector/browser evidence) are both required.
- A and B MUST run as two isolated sub-agents whenever a sub-agent/Task tool is exposed; running them inline is a degraded run. Inline is allowed ONLY when no sub-agent tool exists (or the user declined, on harnesses that ask).
- If you degrade, the report's first line MUST be a banner: `⚠️ DEGRADED: single-context (<reason>)`. A silent degraded critique is a failed critique.
- Assessment A must finish before detector findings enter the parent synthesis context.
- A skipped detector is a failed critique run unless `detect.mjs` is missing or crashes after a real attempt.
- Viewable targets require browser inspection when available.
- Any local server started only for critique visualization must run in the background, have a recorded stop method, and be stopped before final reporting unless the user asks to keep it.
- Do not claim a user-visible overlay exists unless script injection succeeded and the detector ran in the page.

### Setup

1. **Resolve the target** to a concrete file path or URL. Prefer a source path over a dev-server URL when both identify the same surface; ports drift, paths do not. ("the homepage" → `site/pages/index.astro`; "the settings modal" → the primary component file.)
2. **Confirm the target slugs cleanly**:
   ```bash
   node .opencode/skills/impeccable/scripts/critique-storage.mjs slug "<resolved-path-or-url>"
   ```
   Every later command also accepts the resolved target directly and derives the same slug internally; never hand-write a slug. If this exits non-zero, skip persistence and trend for this run, but continue the critique.
3. **Read `.impeccable/critique/ignore.md`** if it exists. Drop matching findings silently; it is the only prior-run input critique consumes.

### Assessment Orchestration

Delegate Assessment A and Assessment B to separate sub-agents. They must not see each other's output. Do not show findings to the user until synthesis.

- Unless a harness-specific gate overrides this, spawn A and B as two isolated, parallel sub-agents whenever a sub-agent/Task tool is exposed. This is the default and is mandatory; do not run them inline because it is faster.
- "Unavailable" means exactly one thing: no sub-agent/Task tool is exposed in this session (or, on harnesses that ask, the user declined).
- If and only if sub-agents are unavailable, fall back sequentially: finish and record Assessment A, then run Assessment B, then synthesize, and emit the degraded banner.
- Whichever path you take, declare it in the report header (see Report header provenance).

If browser automation is available, each assessment creates its own new tab. Never reuse an existing tab, even if it is already at the right URL.

### Assessment A: Design Review

Read relevant source files and visually inspect the live page when browser automation is available. Think like a design director. Evaluate:

- **Design specificity**: Is the composition, interaction, and visual language grounded in this product, or could an unrelated product use it unchanged? Make this judgment before seeing detector output.
- **Holistic design**: hierarchy, IA, emotional fit, discoverability, composition, typography, color, accessibility, states, copy, edge cases.
- **Cognitive load**: consult the [Cognitive Load Assessment](#cognitive-load-assessment) below; report checklist failures and decision points with >4 visible options.
- **Emotional journey**: peak-end rule, emotional valleys, reassurance at high-stakes moments.
- **Nielsen heuristics**: consult the [Heuristics Scoring Guide](#heuristics-scoring-guide) below; score all 10 heuristics 0-4, marking any heuristic the mode-applicability rule allows as `n/a` instead of forcing a number.

Return: design-specificity verdict, heuristic scores, cognitive load, emotional journey, 2-3 strengths, 3-5 priority issues, persona red flags, minor observations, provocative questions.

### Assessment B: Detector + Browser Evidence

Run the bundled detector and browser visualization evidence. Assessment B is mandatory and must remain isolated from Assessment A until both are complete.

CLI scan:

```bash
node .opencode/skills/impeccable/scripts/detect.mjs --json [target]
```

- Pass markup files/directories as `[target]`; do not pass CSS-only files.
- For URLs, skip CLI scan and use browser visualization.
- For very large trees (500+ scannable files), narrow scope or ask.
- Exit code 0 = clean; 2 = findings.
- If the detector entrypoint is missing or fails to load, report deterministic scan unavailable and continue with browser/manual review.

Browser visualization is required for a viewable target when browser automation is available. Use a localhost dev/static URL for local files; avoid `file://` unless the available browser explicitly supports this workflow. Overlay flow:

1. Create a fresh tab and navigate. Prefer the harness's native/browser-canvas screenshot path before hand-rolling a Playwright/Puppeteer script; only fall back to a custom script when no native browser tool is exposed.
2. Preflight mutable injection by setting `document.title` and appending a `<script>` tag. Read-only evaluate APIs do not count.
3. If mutation is unavailable, skip live server, browser presentation, and injection; report fallback signal.
4. If mutation is available, start `node .opencode/skills/impeccable/scripts/live-server.mjs --background`, present the browser if supported, label `[Human]`, scroll top, inject `http://localhost:PORT/detect.js`, wait 2-3 seconds, read `impeccable` console messages, then stop the live server.
5. For multi-view targets, inject on 3-5 representative pages.

Return: CLI findings JSON/counts, browser console findings if applicable, false positives, and skipped/failed browser steps with concrete reasons.

After Assessment B returns usable CLI findings, reuse them. Do not rerun `detect.mjs` in the parent unless Assessment B failed, was truncated, or omitted count, rule names, or file locations.

### Generate Combined Critique Report

Synthesize both assessments into a single report. Do NOT simply concatenate: weave the findings together, noting where the LLM review and detector agree, where the detector caught issues the LLM missed, and where detector findings are false positives.

The chat response is the primary user-facing deliverable. Present the full structured critique below in chat; do not replace it with a summary and a link. The persisted snapshot is only an archive/backlog for later commands.

#### Report header provenance

The report's first line MUST declare how the assessments were run, so a degraded run is never silent:

- Dual-agent: `Method: dual-agent (A: <agent-id> · B: <agent-id>)`
- Degraded: `⚠️ DEGRADED: single-context (<reason, e.g. no sub-agent tool exposed>)`

#### Design Health Score

Present the Nielsen 10 heuristics scores as a table:

| #         | Heuristic                       | Score                   | Key Issue                            |
| --------- | ------------------------------- | ----------------------- | ------------------------------------ |
| 1         | Visibility of System Status     | ?                       | [specific finding or "n/a" if solid] |
| 2         | Match System / Real World       | ?                       |                                      |
| 3         | User Control and Freedom        | ?                       |                                      |
| 4         | Consistency and Standards       | ?                       |                                      |
| 5         | Error Prevention                | ?                       |                                      |
| 6         | Recognition Rather Than Recall  | ?                       |                                      |
| 7         | Flexibility and Efficiency      | ?                       |                                      |
| 8         | Aesthetic and Minimalist Design | ?                       |                                      |
| 9         | Error Recovery                  | ?                       |                                      |
| 10        | Help and Documentation          | ?                       |                                      |
| **Total** |                                 | **??/[applicable max]** | **[Rating band]**                    |

The applicable maximum is 4 times the number of heuristics you actually scored: **/40** when all ten apply, **/32** when two are `n/a`. Never print `/40` over a partial set. Be honest with scores: a 4 means genuinely excellent; most real interfaces score 20-32 out of 40.

**Mode applicability**: heuristics 7 (Flexibility and Efficiency) and 10 (Help and Documentation) may be scored `n/a` on Persuade and Experience surfaces (landing pages, campaigns, portfolios, bodies of work), as may any other heuristic that genuinely cannot apply to the surface under review. Write `n/a` in the Score cell with a one-line reason, and renormalize the total to the applicable maximum so the rating band stays proportional. The persisted snapshot must record the applicable maximum and which heuristics were scored n/a.

#### Design Specificity Verdict

**Start here.** Does the result feel authored for this product, or category-interchangeable?

- **LLM assessment**: your unanchored evaluation — overall coherence, structural sameness, category-interchangeable choices, missed opportunities for product character.
- **Deterministic scan**: what the automated detector found, with counts and file locations; note issues the detector caught that you missed, and flag false positives.
- **Visual overlays** (if injection succeeded): tell the user overlays are visible in the **[Human]** tab; summarize the console output. If injection failed, say no reliable user-visible overlay is available and report the fallback signal.

#### Overall Impression

A brief gut reaction: what works, what doesn't, and the single biggest opportunity.

#### What's Working

Highlight 2-3 things done well; be specific about why they work.

#### Priority Issues

The 3-5 most impactful design problems, ordered by importance, each tagged **P0-P3** (see [Issue Severity](#issue-severity-p0p3)):

- **[P?] What**: name the problem clearly
- **Why it matters**: how this hurts users or undermines goals
- **Fix**: what to do about it (be concrete)
- **Suggested command**: which command could address this (from the command index in `routing.md`)

#### Persona Red Flags

Consult [Persona-Based Design Testing](#persona-based-design-testing) below. Auto-select 2-3 personas most relevant to this interface type (selection table in the reference). If `AGENTS.md` contains a `## Design Context` section from `impeccable init`, also generate 1-2 project-specific personas from the audience/brand info.

For each selected persona, walk through the primary user action and list specific red flags found:

**Alex (Power User)**: No keyboard shortcuts detected. Form requires 8 clicks for primary action. Forced modal onboarding. High abandonment risk.

**Jordan (First-Timer)**: Icon-only nav in sidebar. Technical jargon in error messages ("404 Not Found"). No visible help. Will abandon at step 2.

Be specific. Name the exact elements and interactions that fail each persona; write what broke for them, not generic descriptions.

#### Minor Observations

Quick notes on smaller issues worth addressing.

#### Questions to Consider

Provocative questions that might unlock better solutions: "What if the primary action were more prominent?" · "Does this need to feel this complex?" · "What would a confident version of this look like?"

**Remember**: be direct; be specific ("the submit button", not "some elements"); say what's wrong AND why it matters; give concrete suggestions; prioritize ruthlessly; don't soften criticism.

### Persist the Snapshot

Once the report is finalized, write it to `.impeccable/critique/` so the user can refer back, and so `/impeccable polish` can pick up the priority issues without a copy-paste. Skip this step if the Setup slug was null (vague or root-level target).

1. **Write the body to a temp file** so you can pipe it to the helper: the full critique report (heuristic table, design-specificity verdict, priority issues, persona red flags, minor observations, questions), stopping before "Ask the User" / "Recommended Actions".
2. **Pass structured metadata** through `IMPECCABLE_CRITIQUE_META` (JSON), then run:
   ```bash
   IMPECCABLE_CRITIQUE_META='{"target":"<user phrasing>","total_score":<n>,"max_score":<n>,"na_heuristics":"<comma-separated numbers, or empty>","p0_count":<n>,"p1_count":<n>}' \
     node .opencode/skills/impeccable/scripts/critique-storage.mjs write "<resolved target>" <body-file>
   ```
   `max_score` is the applicable maximum (40 when every heuristic applied), so a later run can tell a renormalized total from a full one. The helper prints the absolute path it wrote.
3. **Delete the temp body file** after the write attempt, whether it succeeded or failed. If deletion fails, mention `temp-file cleanup failed: <reason>` briefly; do not block the critique.
4. **Read the trend** for context: `node .opencode/skills/impeccable/scripts/critique-storage.mjs trend "<resolved target>" 5` — JSON array of the last 5 frontmatter entries (including the one just written).
5. **Append a single line** to the user-visible output, after the report and before the questions:

   > **Trend for `<slug>` (last 5 runs): 24 → 28 → 32 → 29 → 32 (out of 40)** Wrote `.impeccable/critique/<filename>`.

   Read `max_score` on each trend entry. When every entry shares one maximum, state it once as above; when they differ, print each score with its own denominator (`24/32 → 30/40`) and note the runs scored different heuristic sets. Treat a missing `max_score` on an older entry as 40. First run for the slug: "First run for this target, no trend yet."

This is fire-and-forget: do not show the helper's JSON output; only the trend line and the written path. Failures here should not block the flow; print the error and move on.

### Ask the User

**After presenting findings**, use targeted questions based on what was actually found. STOP and call the `question` tool to clarify; these answers shape the action plan. Adapt to the findings; do NOT ask generic questions:

1. **Priority direction**: which issue category matters most right now ("I found problems with visual hierarchy, color usage, and information overload. Which area should we tackle first?") — offer the top 2-3 categories.
2. **Design intent**: if the critique found a tonal mismatch, ask whether it was intentional; offer 2-3 tonal directions.
3. **Scope**: everything, top 3 only, or critical issues only.
4. **Constraints** (only if relevant): "Should any sections stay as-is?"

**Rules**: every question must reference specific findings; keep it to 2-4 questions; offer concrete options. If findings are straightforward (1-2 clear issues), skip questions and go directly to Recommended Actions.

### Recommended Actions

**After receiving the user's answers**, present a prioritized action summary reflecting their priorities and scope.

#### Action Summary

List recommended commands in priority order, each with a brief description carrying enough context that the command knows what to focus on (from the command index in `routing.md`). Order by the user's stated priorities first, then by impact; map each Priority Issue to the appropriate command; skip commands that address zero issues; respect limited scope and off-limits areas; end with `/impeccable polish` as the final step if any fixes were recommended.

After presenting the summary, tell the user:

> You can ask me to run these one at a time, all at once, or in any order you prefer.
>
> Re-run `/impeccable critique` after fixes to see your score improve.

---

## Reference Material

### Cognitive Load Assessment

Cognitive load is the total mental effort required to use an interface. Overloaded users make mistakes, get frustrated, and leave.

**Three types of load**:

- **Intrinsic** (the task itself — structure it, don't eliminate it): break complex tasks into discrete steps; provide scaffolding (templates, defaults, examples); progressive disclosure; group related decisions.
- **Extraneous** (bad design — eliminate ruthlessly): confusing navigation, unclear labels, visual clutter, inconsistent patterns, unnecessary steps.
- **Germane** (learning effort — support it): progressive disclosure, consistent patterns that reward learning, feedback that confirms understanding, onboarding that teaches through action.

**Checklist** (report failures; decision points with >4 visible options):

- [ ] **Single focus**: primary task completable without competing distraction
- [ ] **Chunking**: info in digestible groups (≤4 items per group)
- [ ] **Grouping**: related items visually grouped (proximity, borders, shared background)
- [ ] **Visual hierarchy**: what's most important is immediately clear
- [ ] **One thing at a time**: single decision before the next
- [ ] **Minimal choices**: ≤4 visible options at any decision point
- [ ] **Working memory**: nothing from a previous screen needed to act on the current one
- [ ] **Progressive disclosure**: complexity revealed only when needed

**Scoring**: 0-1 failures = low load (good); 2-3 = moderate (address soon); 4+ = high (critical fix needed).

**Working memory rule** (Miller/Cowan): humans hold ≤4 items at once. ≤4 = manageable; 5-7 = consider grouping/progressive disclosure; 8+ = overloaded — users skip, misclick, or abandon. Applications: 1 primary + 1-2 secondary action buttons, group the rest; ≤5 top-level nav items; one reading path in long-form; ≤4 sibling choices per level in doc sidebars; one decision per screen in portfolio indexes.

**Common violations** (spot and fix): Wall of Options (10+ choices, no hierarchy → group, highlight recommended, disclose progressively); Memory Bridge (remember step 1 at step 3 → keep context visible); Hidden Navigation (mental map required → breadcrumbs, active states, progress); Jargon Barrier (→ plain language, define terms inline); Visual Noise Floor (no hierarchy → one primary, 2-3 secondary, rest muted); Inconsistent Pattern (→ standardize); Multi-Task Demand (→ sequence the steps); Context Switch (→ co-locate decision info).

### Heuristics Scoring Guide

Score each of Nielsen's 10 heuristics on a 0-4 scale. Be honest: a 4 means genuinely excellent, not "good enough." For each: check for the listed signals, then score per the rubric (0 = fails badly, 1 = rarely met, 2 = partial, 3 = good with minor gaps, 4 = excellent).

1. **Visibility of System Status** — loading indicators; action confirmations; progress for multi-step; current location (breadcrumbs, active states); inline form validation. 0: no feedback; 2: some states communicated, major gaps; 4: every action confirms, progress always visible.
2. **Match System / Real World** — familiar terminology; logical order; recognizable icons/metaphors; domain-appropriate language; natural reading flow. 0: pure tech jargon; 2: mixed, jargon leaks; 4: speaks the user's language fluently.
3. **User Control and Freedom** — undo/redo; cancel on forms/modals; path back to safety; clear filters/search/selection; escape from long processes. 0: users get trapped; 2: main flows escape, edge cases don't; 4: undo, cancel, back, escape everywhere.
4. **Consistency and Standards** — consistent terminology; same action → same result; platform conventions; visual consistency (colors, type, spacing, components); consistent interaction patterns. 0: feels like different products stitched together; 2: main flows match, details diverge; 4: cohesive system, predictable.
5. **Error Prevention** — confirmation before destructive actions; constraints against invalid input; smart defaults; clear labels; autosave/draft recovery. 0: errors easy, no guardrails; 2: common errors caught, edge cases slip; 4: errors nearly impossible.
6. **Recognition Rather Than Recall** — visible options; contextual help; recent items/history; autocomplete; labeled icons. 0: heavy memorization; 2: main actions visible, secondary hidden; 4: everything discoverable.
7. **Flexibility and Efficiency of Use** (may be `n/a` on Persuade/Experience) — keyboard shortcuts; customization; recent items/favorites; bulk/batch actions; power features that don't complicate basics. 0: one rigid path; 2: basic keyboard support, limited bulk; 4: multiple paths, power features.
8. **Aesthetic and Minimalist Design** — only necessary info visible; clear hierarchy; purposeful color/emphasis; no decorative clutter. 0: everything competes equally; 2: main content clear, periphery noisy; 4: every element earns its pixel.
9. **Help Users Recognize, Diagnose, Recover from Errors** — plain-language messages (no user-facing codes); specific problem identification; actionable recovery; errors near the source; non-blocking handling. 0: cryptic or absent; 2: names the problem but not the fix; 4: pinpoints, suggests fix, preserves work.
10. **Help and Documentation** (may be `n/a` on Persuade/Experience) — searchable help; contextual help; task-focused organization; concise content; accessible without leaving context. 0: no help anywhere; 2: FAQ/docs exist, not contextual; 4: right info at the right moment.

#### Score Summary

| Score Range | Rating     | What It Means                        |
| ----------- | ---------- | ------------------------------------ |
| 36–40       | Excellent  | Minor polish only; ship it           |
| 28–35       | Good       | Address weak areas, solid foundation |
| 20–27       | Acceptable | Significant improvements needed      |
| 12–19       | Poor       | Major UX overhaul required           |
| 0–11        | Critical   | Redesign needed; unusable            |

With `n/a` heuristics the maximum is lower; read the band off the percentage instead (90%+ Excellent, 70%+ Good, 50%+ Acceptable, 30%+ Poor, below that Critical). 24/32 is 75%, so Good.

#### Issue Severity (P0–P3)

| Priority | Name     | Description                         | Action                       |
| -------- | -------- | ----------------------------------- | ---------------------------- |
| **P0**   | Blocking | Prevents task completion entirely   | Fix immediately; showstopper |
| **P1**   | Major    | Significant difficulty or confusion | Fix before release           |
| **P2**   | Minor    | Annoyance, workaround exists        | Fix in next pass             |
| **P3**   | Polish   | Nice-to-fix, no real user impact    | Fix if time permits          |

If unsure between two levels, ask: "Would a user contact support about this?" If yes, it's at least P1.

### Persona-Based Design Testing

Test the interface through the eyes of distinct user archetypes; each exposes failure modes a single perspective would miss. Select 2-3 personas most relevant to the interface, walk through the primary user action as each, and report specific red flags.

1. **Alex — Impatient Power User**: expert, expects efficiency. Skips onboarding, wants shortcuts, batch actions, no patronizing steps. **Red flags**: forced/unskippable onboarding; no keyboard nav for primary actions; unsplashable slow animations; one-item-at-a-time where batch is natural; redundant confirmations for low-risk actions.
2. **Jordan — Confused First-Timer**: needs guidance, abandons rather than figures it out. **Red flags**: icon-only nav with no labels; jargon without explanation; no visible help; ambiguous next steps; no action confirmation.
3. **Sam — Accessibility-Dependent**: screen reader (VoiceOver/NVDA), keyboard-only, possibly low vision; needs contrast ≥4.5:1 and up to 200% zoom. **Red flags**: click-only interactions; missing/invisible focus indicators; color-only meaning; unlabeled fields/buttons; time-limited actions without extension; custom components breaking screen-reader flow.
4. **Riley — Deliberate Stress Tester**: probes edge cases, unexpected inputs, mid-flow refresh, multi-tab. **Red flags**: features that appear to work but silently fail; error handling exposing internals or leaving broken states; useless empty states; workflows losing data on refresh/navigation; inconsistent behavior across similar interactions.
5. **Casey — Distracted Mobile User**: thumb-only, interrupted, slow connection, low patience. **Red flags**: primary actions out of thumb reach (top of screen); no state persistence across interruptions; long text inputs where selection would work; heavy per-page assets; tiny/tight tap targets.

**Selecting personas** by interface type: landing/marketing → Jordan, Riley, Casey; dashboard/admin → Alex, Sam; e-commerce/checkout → Casey, Riley, Jordan; onboarding → Jordan, Casey; data-heavy/analytics → Alex, Sam; form-heavy/wizard → Jordan, Sam, Casey.

**Project-specific personas**: only when `AGENTS.md` has a `## Design Context` section (from `impeccable init`). Read the audience description, identify the primary archetype not covered by the 5 predefined personas, and create one per this template:

```
##### [Role]: "[Name]"

**Profile**: [2-3 key characteristics derived from Design Context]

**Behaviors**: [3-4 specific behaviors based on the described audience]

**Red Flags**: [3-4 things that would alienate this specific user type]
```

Don't invent audience details; use the 5 predefined personas when no context exists.
