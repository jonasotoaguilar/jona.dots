# Communication and Feedback Patterns

Patterns for wording feedback neutrally and handling disagreement. Use to keep claims specific, actionable, and focused on the code rather than the person. Labels such as `[nit]`, `[blocking]`, or 🔴 markers are illustrative human-review wording; use them only to order your own attention, never in the report output, whose severities come solely from the Output Contract.

## Effective Feedback

**Good Feedback is:**

- Specific and actionable
- Educational, not judgmental
- Focused on the code, not the person
- Balanced (praise good work too)
- Prioritized (critical vs nice-to-have)

```markdown
❌ Bad: "This is wrong."
✅ Good: "This could cause a race condition when multiple users
access simultaneously. Consider using a mutex here."

❌ Bad: "Why didn't you use X pattern?"
✅ Good: "Have you considered the Repository pattern? It would
make this easier to test. Here's an example: [link]"

❌ Bad: "Rename this variable."
✅ Good: "[nit] Consider `userCount` instead of `uc` for
clarity. Not blocking if you prefer to keep it."
```

## The Question Approach

Instead of stating problems, ask questions to encourage thinking:

```markdown
❌ "This will fail if the list is empty."
✅ "What happens if `items` is an empty array?"

❌ "You need error handling here."
✅ "How should this behave if the API call fails?"

❌ "This is inefficient."
✅ "I see this loops through all users. Have we considered
the performance impact with 100k users?"
```

## Suggest, Don't Command

```markdown
❌ "You must change this to use async/await"
✅ "Suggestion: async/await might make this more readable:
async function fetchUser(id: string) {
const user = await db.query('SELECT * FROM users WHERE id = ?', id);
return user;
}
What do you think?"

❌ "Extract this into a function"
✅ "This logic appears in 3 places. Would it make sense to
extract it into a shared utility function?"
```

## Giving Difficult Feedback

### The Sandwich Method (Modified)

Traditional: Praise + Criticism + Praise (feels fake).

Better: Context + Specific Issue + Helpful Solution

```markdown
Example:
"I noticed the payment processing logic is inline in the
controller. This makes it harder to test and reuse.

[Specific Issue]
The calculateTotal() function mixes tax calculation,
discount logic, and database queries, making it difficult
to unit test and reason about.

[Helpful Solution]
Could we extract this into a PaymentService class? That
would make it testable and reusable. I can pair with you
on this if helpful."
```

### Handling Disagreements

When the author disagrees with your feedback:

1. **Seek to Understand**
   "Help me understand your approach. What led you to choose this pattern?"

2. **Acknowledge Valid Points**
   "That's a good point about X. I hadn't considered that."

3. **Provide Data**
   "I'm concerned about performance. Can we add a benchmark to validate the approach?"

4. **Escalate if Needed**
   "Let's get [architect/senior dev] to weigh in on this."

5. **Know When to Let Go**
   If it's working and not a critical issue, approve it. Perfection is the enemy of progress.

## PR Review Comment Template

```markdown
## Summary

[Brief overview of what was reviewed]

## Strengths

- [What was done well]
- [Good patterns or approaches]

## Required Changes

🔴 [Blocking issue 1]
🔴 [Blocking issue 2]

## Suggestions

💡 [Improvement 1]
💡 [Improvement 2]

## Questions

❓ [Clarification needed on X]
❓ [Alternative approach consideration]

## Verdict

✅ Approve after addressing required changes
```
