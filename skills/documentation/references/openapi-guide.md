# OpenAPI Guide

Use this guide together with `../assets/openapi-template.yaml`.

## Purpose

OpenAPI is the machine-readable documentation contract for an already-designed REST API surface. Use `design-architecture` first when API style, boundaries, resources, gateway use, or versioning strategy are still undecided.

## Required Sections

- `openapi: 3.0.3`
- `info` with title, version, description
- `servers`
- `paths`
- `components.schemas`
- `components.securitySchemes` when auth exists

## Boundary With Architecture Design

- Do not invent endpoints, resources, schemas, auth rules, rate limits, or error semantics.
- Derive OpenAPI from existing implementation, `ARCHITECTURE.md`, ADRs, PRD, or API contract sketches.
- If the source material conflicts, stop and ask for the architecture decision instead of smoothing over the conflict.
- Preserve the project OpenAPI version if one exists; otherwise the local template uses `3.0.3` for broad tooling compatibility.

## Endpoint Practices

For each path and operation, include:

- `summary`
- `operationId`
- `description`
- `tags`
- `parameters`
- `requestBody` when applicable
- `responses` for success and failure cases

## Schema Practices

- Use `$ref` for shared schemas
- Add `description` to important properties
- Use `format` for strings like `email`, `uuid`, `date-time`, `uri`
- Add examples for complex payloads
- Mark required fields explicitly
- Use enums when values are constrained

## Validation

- If needed, scaffold with `../scripts/generate_openapi.py`
- Validate with `../scripts/validate_openapi.py`
