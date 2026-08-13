<!--
  Curated release notes template (ecosystem-agnostic). Part of the release
  contract in references/release-notes.md.

  LIFECYCLE — single current release document: the project keeps exactly ONE
  release document at docs/releases/<current-tag>.md. For a new release:
    git mv docs/releases/<old-tag>.md docs/releases/<new-tag>.md
  then REPLACE the content with this template filled in, bump the package,
  commit, and tag. The release preflight must fail the release when the
  release directory has zero or multiple documents, when the document name
  does not match the release tag, or when the body is empty,
  placeholder-filled, malformed, or mismatched to the tag/version; the
  publish hook must create the release from that one file only.

  This template lives ONLY in the skill's asset directory — never install it
  into a project as docs/releases/TEMPLATE.md, and never accumulate one
  document per historical release.

  Replace every token and example below with real content. Delete all
  guidance comments (<!-- -->) before tagging — the file body becomes the
  release body verbatim. Follow the narrative style: prose that explains
  cause and effect and links the PRs/issues that delivered the work, never a
  raw commit list.
-->

# vX.Y.Z — <short narrative title>

<One paragraph in plain language: what this release is for, who benefits, and
why it matters. State the headline outcome, not a list of commits.>

## What changed

<!-- One subsection per meaningful change or theme, written as an outcome
     story. Link the PR(s) that delivered the change:
     ([#N](https://github.com/{owner}/{repo}/pull/N))
     Keep the section list short: 2-5 subsections, not one per commit.
     Delete unused subsections. -->

### <Change or theme>

<What was absent or wrong, what changed, and what the user can now do.>
([#N](https://github.com/{owner}/{repo}/pull/N))

### <Change or theme>

<Outcome story with its PR link(s).>

## Upgrade

<Only when a previous stable release exists: what changes for existing
installs, plus the upgrade command. For the first release, delete this section
and use Install only.>

## Install

<How to obtain and install this release. Use the project's real distribution
channel: package-manager command, download, or registration step.>

## Verification

<What was verified before publishing: the CI gate set, the test suite,
provenance/signature attestation, artifact checks. Concrete numbers only —
never invent results.>

## Known issues

<!-- Only when real limitations exist. Link the tracking issue for each:
     ([#N](https://github.com/{owner}/{repo}/issues/N))
     Delete the whole section when there is nothing honest to report. -->

- <Limitation and its impact, with the tracking issue link.>
