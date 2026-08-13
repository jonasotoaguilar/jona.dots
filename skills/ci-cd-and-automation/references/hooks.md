# Hook Defaults

Always configure hooks.

- If `.pre-commit-config.yaml` exists, use pre-commit.
- Otherwise prefer Lefthook for polyglot/JS projects.
- Hook set must run lint + format + type-check on staged/changed files.
- Repository-local hooks only (never global git config).
- Pre-commit: fast staged/changed-file lint+format and targeted unit/type checks where supported.
- Full integration, E2E, and full coverage runs belong in CI/pre-push, not every commit.
- Include a safe fallback if targeted tests are unsupported.
