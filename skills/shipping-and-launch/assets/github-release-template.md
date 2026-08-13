# GitHub Release Notes — Example Structure (Adaptable)

An example of release-note structure, not a rigid contract. Adapt it to the project's own
conventions and to what actually changed in this release: a small patch gets fewer sections,
a big release gets more. Omit what does not apply; keep what the project needs. Fill in the
placeholders (`<version>`, `<owner>`, `<binary>`, ...) and use the project's own names, URLs,
and install paths.

## Where the notes live — single current release document

Release notes live in exactly ONE current narrative document, `docs/releases/<tag>.md`.
The lifecycle mechanics — `git mv` rename, never install a template as
`docs/releases/TEMPLATE.md`, preflight validation, `--notes-file` publication — are the
`ci-cd-and-automation` contract (`ci-cd-and-automation/references/release-notes.md`); do not
repeat them here. This template provides only the structure and examples: fill it into the
one tag-named document and adapt it to the project and the exact bytes released.

## Typical structure

- H1 title carries the version plus a short thematic title: `# v<version> — <Title>` (stable) or
  `# <Product> v<version>: <Narrative>` (prerelease). A plain `# v<version>` is fine too.
- The opening paragraph states in one sentence what changed and why; add provenance when the
  release promotes an exact candidate (tag/SHA, those bytes only).
- Sections follow the release's shape — commonly: what changed, fixes, known issues, install.
- Known issues deserve an honest section with issue links when there are any
  (`[#NNNN](https://github.com/<owner>/<repo>/issues/NNNN)`).
- Install sections cover every supported path with exact commands and integrity verification
  (checksums, signatures) when the release ships assets.
- Prereleases often end with a "What we want you to try" section, ordered by priority of the
  testing ask.

## Example A — Stable release

```markdown
# v<version> — <Short thematic title>

<One sentence: what this release is and why it exists.>

<Optional provenance: exact candidate/tag/SHA the release peels to; these bytes only.>

## Upgrade now

```bash
<upgrade command for the package manager path>
```

<Note when replacing the binary does not refresh managed runtime assets — run sync or equivalent.>

## <What's New / What the <evidence> proved>

<One paragraph per change area; ### subsections and bullets as needed. Link issues or commits.>

## Known issues in these exact <version> bytes

- <Open, real limitation with issue link, when applicable.>

## Install and integrity

<Every supported path: package manager, module install, archives. Name the attached assets,
checksums manifest, signature. State verification steps and any platform policy.>

<Optional closing section: community evidence / call to action.>
```

## Example B — Prerelease candidate (e.g., `-rc.N`)

```markdown
# <Product> v<version>: <Narrative title>

<Opening narrative: what the previous candidate taught, what this build is, and
"It is a prerelease for community testing.">

## If you are upgrading, run this

```bash
<sync or asset-refresh command>
```

<Why: binary replacement does not refresh managed assets; name the skew incident if relevant.>

## Fixed since <previous candidate>

### <Defect area>

<Root-cause narrative: what failed, why, and the fix. Link issues.>

### Reported by you, fixed here

- <Bullet list of community-reported fixes with issue links, when applicable.>

## Known issues going in

- <Open, real limitations, when applicable.>

## What we want you to try

Ordered by how much the answer is wanted.

**1. <Highest-priority test ask.>**
**2. <Next.>**

## Installing it

<State that prereleases do not update the package manager and binaries are unsigned; integrity
comes from the checksums manifest.>

**Linux and macOS**

```bash
# pick your platform
PLATFORM=<platform>
VERSION=<version>

curl -fsSLO "https://github.com/<owner>/<repo>/releases/download/v${VERSION}/<binary>_${VERSION}_${PLATFORM}"
curl -fsSLO "https://github.com/<owner>/<repo>/releases/download/v${VERSION}/<checksums-file>"

# verify before running it
sha256sum --ignore-missing -c <checksums-file>

chmod +x "<binary>_${VERSION}_${PLATFORM}"
sudo mv "<binary>_${VERSION}_${PLATFORM}" /usr/local/bin/<binary>
<binary> --version   # expect: <binary> <version>
<binary> sync        # refresh managed assets
```

<Platform notes as needed, e.g. macOS Gatekeeper quarantine clearing.>

**Windows (PowerShell)**

```powershell
$Version = "<version>"
Invoke-WebRequest -Uri "https://github.com/<owner>/<repo>/releases/download/v$Version/<binary>_${Version}_windows_amd64.exe" -OutFile <binary>.exe
Invoke-WebRequest -Uri "https://github.com/<owner>/<repo>/releases/download/v$Version/<checksums-file>" -OutFile <checksums-file>

# compare this against the windows line in the checksums file
Get-FileHash <binary>.exe -Algorithm SHA256 | Format-List

.\<binary>.exe --version
.\<binary>.exe sync
```

**Going back**

<Keep the current binary or reinstall stable; note identity-format caveats if any.>
```

## Example C — Compact patch release

For small patches, a short changelog may be all the notes need:

```markdown
## Changelog
* <commit-sha> <conventional commit message>
```

## Asset and integrity conventions

- **Stable:** one archive per platform (`<binary>_<ver>_<os>_<arch>.<ext>`), plus a checksums
  manifest and its detached signature when the project signs. State any platform policy (for
  example, intentionally omitted binaries) in the notes.
- **Prerelease:** plain binaries per platform plus the checksums manifest; binaries unsigned,
  verify before running.
- Install commands must match the assets actually attached; never write commands for an asset
  that is not in the release.

## Workflow vs manual cuts

- **Workflow:** tags/drafts owned by the pipeline flow through unchanged; the notes body and the
  prerelease flag still follow the project's conventions. Never rewrite or re-draft a
  workflow-owned release. Workflow publication consumes the single current document
  (`docs/releases/<tag>.md`) via `--notes-file`.
- **Manual:** `gh release create <tag> --title "<version> — <Title>" --notes-file docs/releases/<tag>.md
  [--prerelease] <assets...>`; set `--prerelease` exactly when the tag is a candidate (e.g.,
  `-rc.N`), never for stable.
