# Docker Security Detection Reference

Signal-triggered checks for the security lens. Load when the change adds/modifies a Dockerfile, `.dockerignore`, or compose file. Report only patterns introduced/activated/worsened by the candidate.

## Dockerfile

- **Root user:** no `USER` directive (runs as root) or `USER root`. Not findings: explicit non-root user or numeric UID (`USER 1000:1000`).
- **Base image:** `FROM ...:latest`, `FROM <personal-or-unverified-image>`, or unpinned tag without digest — the change introduces or keeps an unpinned base. Not findings: pinned tags (`node:18.19.0-alpine`) or digests (`@sha256:...`).
- **Secrets baked in:** `ENV API_KEY=sk-...`/`ENV DB_PASSWORD=...` literals, `ARG` + `RUN echo $SECRET > /config` (visible in history), `COPY .env`/`secrets.json`/`id_rsa` into the image. Not findings: BuildKit `--mount=type=secret`, multi-stage builds that exclude secrets from the final image.
- **`ADD` with URL or auto-extract** where `COPY` + explicit extraction belongs.
- **Unnecessary exposed ports** (`EXPOSE 22`/`3306`), or installs of attack-surface packages (openssh-server, sudo, netcat, nmap) in the final image.
- **No cleanup:** `apt-get install` without `rm -rf /var/lib/apt/lists/*` when the change adds the install.

## Compose / runtime

- **Privileged mode or dangerous capabilities:** `--privileged`, `cap_add: ALL`/`SYS_ADMIN`/`NET_ADMIN` without `cap_drop: ALL` baseline; `security_opt` missing.
- **Docker socket mount:** `/var/run/docker.sock` mounted (root on host) — always a finding when introduced.
- **Host network mode** (`network_mode: host`) or sensitive host-path mounts (`-v /:/host`, `/etc`, `/var/run`).
- **Missing resource limits** on a new service (`mem_limit`/`deploy.resources.limits`, `pids_limit`).
- **Secrets in environment literals** (`DB_PASSWORD=mysecret`, `API_KEY=sk-12345`) instead of `secrets:`/`*_FILE` indirection.
- **Registry credentials in plaintext** (`docker login -u -p` in scripts, auth tokens in compose).

## .dockerignore

- Missing `.dockerignore` (or one that does not exclude `.env`, keys/`.pem`, `credentials/`, `.git`) while the change adds a Dockerfile that `COPY`s the context — the build context carries secrets.

## Evidence gate

- Confirm the Dockerfile/compose/.dockerignore change is part of the candidate and the risk is introduced/worsened by it. Image scanning, registry policy, and runtime isolation policy outside the change are out of scope (CI/ops ownership).
- Final severity comes from the Output Contract in SKILL.md, never from this reference.
