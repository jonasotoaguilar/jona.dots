# Secrets Recognition Aid

Compact recognition aid for changed-file evidence only. It classifies only whether a credential-shaped value is present; final severity comes exclusively from the Output Contract in SKILL.md.

## Scope

- Inspect only the reviewed scope evidence (the diff or the audited tree).
- Never execute regexes, scanners, entropy scans, repo-wide tracked-file checks, `.gitignore` checks, or external tools.
- Never read the live worktree, index, HEAD, or another revision.

## Reportability Gate

Report only a real credential-shaped value introduced by the candidate (added, behavior-activated, or worsened by the change). Secret names, env/config references, secret-manager lookups, and placeholders are not findings.

## Credential-Shaped Value Cues (non-exhaustive)

Provider/key prefixes:

| Provider  | Cue                                                                 |
| --------- | ------------------------------------------------------------------- |
| OpenAI    | `sk-`-prefixed long token                                           |
| Anthropic | `sk-ant-`-prefixed token                                            |
| AWS       | `AKIA`-prefixed access key or secret assignment                     |
| GitHub    | `ghp_`, `gho_`, `ghu_`, `ghs_`, `ghr_`, or `github_pat_` token      |
| Stripe    | `sk_live_`/`rk_live_`-prefixed key                                  |
| Twilio    | `AC` account SID or `SK` API key                                    |
| Slack     | `xoxb-`, `xoxp-`, or `xapp-` token                                  |
| Google    | `AIza`-prefixed API key, `.apps.googleusercontent.com` OAuth client |

Other shapes:

- Private-key/certificate blocks: `-----BEGIN ... PRIVATE KEY-----`, `-----BEGIN CERTIFICATE-----`.
- Credentialed DB/Redis URLs: `postgres(ql)://user:pass@`, `mysql://user:pass@`, `mongodb(+srv)://user:pass@`, `redis://:pass@`.
- Secret-like assignments: `password = "literal"`, `api_key = "literal"`, `token = "literal"` with a non-placeholder value.

## Secret-Bearing Changed File Cues

- `.env*` files committed as part of the change.
- Key/cert files: `*.pem`, `*.key`, `*.p12`, `*.pfx`, `id_rsa`, `id_ed25519`.
- Credential JSON/YAML: `credentials.json`, `service-account.json`, `secrets.yaml`.
- CI env literals: `env:` block values that are not `${{ secrets.X }}`.
- Docker `ENV`/`ARG` with literal values.
- Terraform literals: `password = "hardcoded"` instead of `var` or a data source.

## Safe Placeholders (not findings)

`${VAR}`, `${process.env.X}`, `os.environ.get('X')`, `<YOUR_KEY>`, `REPLACE_WITH_YOUR_KEY`, `sk-...` in docs/comments.

## High-Entropy Long String

Supporting cue only: roughly >20 characters and visibly varied (mixed case/digits/symbols). Never sole proof; never requires an entropy calculation.

## Reporting

- Final severity comes from the Output Contract in SKILL.md; this reference never assigns it.
- Without a real credential-shaped value introduced by the candidate, report no findings for this reference's surface.
