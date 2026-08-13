# Docstrings Guide

Per-symbol documentation for public APIs and library interfaces: docstrings, JSDoc/TSDoc, GoDoc, Rustdoc. Complements `authoring-guidance.md` (why-not-what policy) and the OpenAPI guide (REST contracts).

## When a docstring is owed

- Every exported symbol of a library or shared module — the public API surface.
- Non-obvious contracts: ordering requirements, side effects, error behavior, concurrency constraints, invariants.
- Known gotchas, with a link to the ADR or design note that explains the rationale.

No docstring for self-explanatory implementation details or restatements of the code — that is `authoring-guidance.md` territory.

## What to document

1. **Purpose** — what the symbol does and why it exists.
2. **Contract** — parameters (meaning, constraints), return value, errors.
3. **Non-obvious behavior** — side effects, ordering, performance traps.
4. **Example** — only when usage is non-trivial; keep it copy-pasteable.

## JSDoc / TSDoc

```typescript
/**
 * Creates a new task.
 *
 * @param input - Task creation data (title required, description optional)
 * @returns The created task with server-generated ID and timestamps
 * @throws {ValidationError} If title is empty or exceeds 200 characters
 * @throws {AuthenticationError} If the user is not authenticated
 *
 * @example
 * const task = await createTask({ title: 'Buy groceries' });
 * console.log(task.id); // "task_abc123"
 */
export async function createTask(input: CreateTaskInput): Promise<Task> {
  // ...
}
```

- Prefer the docstring inline with the symbol over a separate docs file; the doc travels with the code.
- Match the project's existing tag style (JSDoc vs TSDoc) before introducing a new one.

## GoDoc

- Every exported symbol gets a comment that starts with its name: `// CreateTask creates a new task.`
- Package comments document the package's purpose at the top of one file.
- GoDoc is the documentation: keep it readable via `go doc` and pkg.go.dev.

```go
// CreateTask creates a new task from the given input and returns it with
// server-generated ID and timestamps. It returns ErrValidation when the
// title is empty or exceeds 200 characters.
func CreateTask(input CreateTaskInput) (*Task, error) {
```

## Rustdoc

- `///` for items, `//!` for module and crate docs.
- Fenced `rust` code blocks in doc comments are run as doctests by `cargo test` — keep them truthful.

```rust
/// Creates a new task from the given input and returns it with
/// server-generated ID and timestamps.
///
/// # Errors
///
/// Returns [`ValidationError`] when the title is empty or exceeds 200
/// characters.
pub fn create_task(input: CreateTaskInput) -> Result<Task, Error> {
```

## Keeping them honest

- A stale docstring is worse than none: it is a lie next to the code it documents. Update the docstring in the same change that changes the contract.
- Language convention wins: match the existing project's doc style before inventing a new one.
- Authoring lives here; the review lens is `review-readability` (misleading or restating comments).
