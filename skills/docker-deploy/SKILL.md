---
name: docker-deploy
description: "Trigger: deploy docker, docker compose production, container rollout, rollback, registry push, backup volume. Deploy and operate Docker Compose stacks in production: compose.yaml, buildx images, healthchecks, secrets, rollback."
license: Apache-2.0
metadata:
  author: "jonasotoaguilar"
  version: "1.0"
---

# Docker Deploy

## Activation Contract

Load when deploying, updating, rolling back, or operating a Docker Compose stack in production (single host, non-Swarm): production compose files, multi-arch pushes, healthcheck-gated updates, secrets, backups, log rotation. Not for local dev compose, Kubernetes/ECS, or installer-harness isolation.

## Hard Rules

- Use `compose.yaml` (never `docker-compose.yml`); never add a top-level `version:` key — obsolete, emits a warning.
- Pin image tags in production; never `:latest`. Pin digests when reproducibility matters: `docker compose config --resolve-image-digests`.
- Never bake secrets into images. Deliver via `env_file` (gitignored `.env`) or compose `secrets:` file sources (mounted at `/run/secrets/<name>`).
- `deploy:` (resources, replicas) is ignored by plain `docker compose up` — Swarm-only. Scale with `--scale SERVICE=N`.
- Isolate stateful services: db/cache on an `internal: true` network, no host ports; expose only what clients need (`127.0.0.1:PORT` host-only).
- Keep `.dockerignore` at the repo root before building: exclude `.git`, `.env*`, `node_modules`, `dist` — never send secrets in the build context.
- Harden images at build time: pinned base tags, non-root `USER`, `HEALTHCHECK`, no secrets in layers.
- State lives in named volumes; the container writable layer is ephemeral — never store data there.
- Validate with `docker compose config` before any `up`; never run `down -v` or `prune` unless the user explicitly asked.

## Decision Gates

| Situation                          | Choice                                            |
| ---------------------------------- | ------------------------------------------------- |
| Single host, compose-managed stack | Plain `docker compose up -d --wait`               |
| Multi-node or cross-host replicas  | Out of scope — Kubernetes/ECS                     |
| Secret delivery                    | `env_file` for config; `secrets:` for credentials |
| Mixed amd64/arm64 hosts            | Multi-arch `buildx` build with `--push`           |
| Bad release                        | Rollback: redeploy the previous pinned tag/digest |

## Execution Steps

1. Inspect: `docker compose config` (validate) and `docker compose ps`; record current image tags.
2. Production overlay: base `compose.yaml` + `compose.production.yaml` (restart, healthchecks, hardening, log rotation, secrets, internal networks — see template). Start from `assets/compose.production.yaml`.
3. Build and push (with `.dockerignore` present): `docker buildx build --platform linux/amd64,linux/arm64 --push -t <repo>/<img>:<pinned-tag> .` (`--load` for single-platform local run).
4. Deploy or update: `docker compose -f compose.yaml -f compose.production.yaml up -d --wait --wait-timeout 120` — recreates only changed services, preserves volumes; `--no-deps` for single-service updates.
5. Verify: `docker compose ps` (all healthy), then `docker compose logs --tail=50 <svc>`; deeper inspection (`top`, `exec`, `stats`, network) in `references/operations.md`.
6. Rollback: redeploy the previous pinned tag with step 4; keep old tags in the registry until the release is stable.
7. Backup volumes: tar via `--volumes-from` into a dated archive; restore with `--strip 1` — exact commands in `references/operations.md`.
8. Logs: rotation via `logging: json-file` with `max-size`/`max-file` (`max-file` requires `max-size`); inspect with `docker compose logs`.

## Output Contract

Return: image tags/digests before and after, service health state, files touched, commands executed, rollback plan (previous tag), destructive-operation warnings.

## References

- `assets/compose.production.yaml` — production overlay template: healthchecks, restart, hardening, log rotation, secrets, networking.
- `assets/.dockerignore` — minimal build-context exclusions for production images.
- `references/operations.md` — inspection, debugging, backup, and restore commands.
