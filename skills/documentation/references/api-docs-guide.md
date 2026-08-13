# API Documentation Guide

Use this guide together with `../assets/api-docs-template.md`. API style, resource boundaries, auth, and versioning are design decisions — when they are undecided, route to `design-architecture` (its `references/api-design.md`) rather than inventing them here.

## Purpose

API docs are reference-first documents that help integrators use endpoints correctly and recover from failures.

## Core Practices (Cognitive Design)

- **Progressive disclosure:** Start with the primary integration path (Quick Path) before the exhaustive reference.
- **Recognition over recall:** Use tables for parameters and headers, and checklists for requirements.
- Every endpoint should document:
  - HTTP method and path
  - Brief purpose
  - Authentication requirements
  - Path parameters, Query parameters, and Headers
  - Request body with types and rules
  - Success response and Error responses
  - Code examples in at least 2 languages

## Global Coverage

The overall API docs should also cover:

- Base URL
- Authentication setup
- Rate limiting
- Pagination behavior
- Error format
- Versioning or changelog notes when relevant

## Avoid

- Documenting only the happy path
- Omitting error codes
- Showing examples without explaining auth or required headers
- Inventing endpoint behavior not confirmed by the source material
