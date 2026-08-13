#!/usr/bin/env bash
# validate-design-md.sh
# DESIGN.md validation command for the documentation skill.
#
# Primary check: official Google DESIGN.md linter
#   npx @google/design.md lint <file>
# Fallback when the CLI is unavailable (offline / no network): local schema
# and section-order checks so validation never silently blocks.
#
# Official `omitted:` front-matter support: sections declared in the
# `omitted:` list (plain names or `{ section, reason }` entries) are
# intentionally absent; the local fallback suppresses their corresponding
# warnings (at minimum `colors`), matching the official CLI behavior.
#
# Usage: ./validate-design-md.sh [path-to-DESIGN.md]
# Defaults to ./DESIGN.md in current directory.

set -euo pipefail

DESIGN_FILE="${1:-DESIGN.md}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [[ ! -f "$DESIGN_FILE" ]]; then
	echo -e "${RED}FAIL${NC}: $DESIGN_FILE not found"
	exit 1
fi

# Section order: canonical 8 sections must appear in this order when present.
CANONICAL_SECTIONS=(
	"## Overview"
	"## Colors"
	"## Typography"
	"## Layout"
	"## Elevation & Depth"
	"## Shapes"
	"## Components"
	"## Do's and Don'ts"
)
# Bounded optional prose sections allowed AFTER the canonical core.
OPTIONAL_SECTIONS=(
	"## User Flows & Navigation"
	"## Accessibility Contract"
	"## Responsive Behavior"
	"## Performance"
	"## SEO"
	"## Content & States"
	"## Motion"
	"## UI Libraries & Usage Boundaries"
)

# Parse the official `omitted:` front-matter list. Entries may be plain
# section names (`- colors`) or block-form objects (`- section: spacing`).
omitted_sections() {
	awk '
    /^---$/ { fm++; next }
    fm == 1 && /^omitted:/ { in_om = 1; next }
    fm == 1 && in_om && /^[^[:space:]-]/ && $0 !~ /^#/ { exit }
    fm == 1 && in_om {
      line = $0
      sub(/^[[:space:]]*-?[[:space:]]*/, "", line)
      if (line ~ /^#/) next
      gsub(/[{},]/, "", line)
      if (line ~ /^section:[[:space:]]*/) {
        sub(/^section:[[:space:]]*/, "", line)
        sub(/[[:space:]]+[A-Za-z0-9_-]+:.*$/, "", line)
      } else if (line ~ /^[A-Za-z0-9_-]+:/) {
        next
      }
      gsub(/["'"'"']/, "", line)
      if (line != "") print tolower(line)
    }
  ' "$DESIGN_FILE"
}

omitted_list=$(omitted_sections | sort -u | tr '\n' ' ')

is_omitted() {
	[[ " $omitted_list " == *" $1 "* ]]
}

run_lint() {
	if command -v npx >/dev/null 2>&1 && npx --no-install @google/design.md --version >/dev/null 2>&1; then
		npx @google/design.md lint "$DESIGN_FILE"
		return $?
	fi
	return 127
}

if run_lint; then
	echo -e "${GREEN}LINT OK${NC}: $DESIGN_FILE"
else
	code=$?
	if [[ $code -eq 127 ]]; then
		echo -e "${YELLOW}LINT UNAVAILABLE${NC}: @google/design.md not installed (try \`npx @google/design.md\`) — running local schema checks."
		echo "---"
	else
		echo -e "${RED}LINT FAILED${NC}: fix lint errors before reporting DESIGN.md complete."
		exit 1
	fi
fi

# Local fallback checks (always run): front matter + section order.
local_ok=1
line=$(grep -n '^---$' "$DESIGN_FILE" | head -1 | cut -d: -f1) || true
if [[ -z "$line" ]]; then
	echo -e "${RED}FAIL${NC}: no YAML front matter (--- fences) found"
	local_ok=0
fi

if [[ $local_ok -eq 1 ]]; then
	if ! grep -q '^name:' "$DESIGN_FILE"; then
		echo -e "${RED}FAIL${NC}: front matter missing required \`name\`"
		local_ok=0
	fi
	if ! grep -q '^colors:' "$DESIGN_FILE"; then
		if is_omitted colors; then
			echo -e "${GREEN}OK${NC}: \`colors\` intentionally omitted via frontmatter \`omitted:\`"
		else
			echo -e "${YELLOW}WARN${NC}: front matter missing \`colors\` (required when colors are committed; declare \`omitted:\` when intentionally absent)"
		fi
	fi
fi

# Canonical section order check.
prev=0
for sec in "${CANONICAL_SECTIONS[@]}"; do
	found=$(grep -n "^${sec}$" "$DESIGN_FILE" | head -1 | cut -d: -f1) || true
	if [[ -n "$found" ]]; then
		if ((found < prev)); then
			echo -e "${RED}FAIL${NC}: canonical section out of order — \"$sec\" after an earlier section"
			local_ok=0
		fi
		prev=$found
	fi
done

# Optional sections must come AFTER the last canonical section (Do's and Don'ts).
last_canonical=$(grep -n "^## Do's and Don'ts$" "$DESIGN_FILE" | head -1 | cut -d: -f1) || true
last_canonical=${last_canonical:-0}
for sec in "${OPTIONAL_SECTIONS[@]}"; do
	found=$(grep -n "^${sec}$" "$DESIGN_FILE" | head -1 | cut -d: -f1) || true
	if [[ -n "$found" ]] && ((found < last_canonical)); then
		echo -e "${YELLOW}WARN${NC}: optional section \"$sec\" appears before the canonical core (should follow it)"
	fi
done

if [[ $local_ok -eq 1 ]]; then
	echo -e "${GREEN}SCHEMA OK${NC}: front matter present, canonical section order respected"
	exit 0
fi
exit 1
