# Review Workflow and Advanced Patterns

Background knowledge on review process, advanced patterns, best practices, and pitfalls. This is reference context, not a workflow to execute: the reviewer inspects only the reviewed scope through read-only commands.

## Review Phases

### Phase 1: Context Gathering

Before diving into code, understand:

1. Read PR description and linked issue
2. Check PR size (>400 lines? Ask to split)
3. Review CI/CD status (tests passing?)
4. Understand the business requirement
5. Note any relevant architectural decisions

### Phase 2: High-Level Review

1. **Architecture & Design**
   - Does the solution fit the problem?
   - Are there simpler approaches?
   - Is it consistent with existing patterns?
   - Will it scale?

2. **File Organization**
   - Are new files in the right places?
   - Is code grouped logically?
   - Are there duplicate files?

3. **Testing Strategy** — belongs to the reliability lens; check only whether missing tests leave changed behavior unproved.

### Phase 3: Line-by-Line Review

For each file:

1. **Maintainability**
   - Clear variable names?
   - Functions doing one thing?
   - Complex code commented?
   - Magic numbers extracted?

2. **Security** — belongs to the risk lens; mention only if it obscures the change's behavior.

3. **Performance** — belongs to the resilience lens; mention only if it obscures the change's behavior.

### Phase 4: Summary & Decision

1. Summarize key concerns
2. Highlight what you liked
3. Make clear decision: Approve / Comment (minor suggestions) / Request Changes (must address)
4. Offer to pair if complex

## Advanced Review Patterns

### Pattern 1: Architectural Review

1. **Design Document First**
   - For large features, request design doc before code
   - Review design with team before implementation
   - Agree on approach to avoid rework

2. **Review in Stages**
   - First PR: Core abstractions and interfaces
   - Second PR: Implementation
   - Third PR: Integration and tests
   - Easier to review, faster to iterate

3. **Consider Alternatives**
   - "Have we considered using [pattern/library]?"
   - "What's the tradeoff vs. the simpler approach?"
   - "How will this evolve as requirements change?"

### Pattern 2: Test Quality Review

Belongs to the reliability lens. In this lens, check only whether missing tests leave changed behavior unproved.

### Pattern 3: Security Review Checklist

Belongs to the risk lens. In this lens, mention security concerns only when they obscure the change's behavior.

## Best Practices

1. **Review Promptly**: Within 24 hours, ideally same day
2. **Limit PR Size**: 200-400 lines max for effective review
3. **Review in Time Blocks**: 60 minutes max, take breaks
4. **Use Review Tools**: GitHub, GitLab, or dedicated tools
5. **Automate What You Can**: Linters, formatters, security scans
6. **Build Rapport**: Emoji, praise, and empathy matter
7. **Be Available**: Offer to pair on complex issues
8. **Learn from Others**: Review others' review comments

## Common Pitfalls

- **Perfectionism**: Blocking PRs for minor style preferences
- **Scope Creep**: "While you're at it, can you also..."
- **Inconsistency**: Different standards for different people
- **Delayed Reviews**: Letting PRs sit for days
- **Ghosting**: Requesting changes then disappearing
- **Rubber Stamping**: Approving without actually reviewing
- **Bike Shedding**: Debating trivial details extensively
