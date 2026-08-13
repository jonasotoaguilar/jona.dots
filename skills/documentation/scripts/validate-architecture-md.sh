#!/usr/bin/env bash
# validate-architecture-md.sh
# Applicability-aware validator for ARCHITECTURE.md.
#
# Hard fails (core contract, always required):
#   - System Overview, Architecture Pattern (section must exist, and declare
#     "Chosen pattern" OR an explicit "None required"/"Not applicable"
#     statement when no pattern genuinely applies), Component Details,
#     Key Decisions, ADRs section
#   - System Architecture Diagram: a Mermaid block, or an explicit
#     "None required"/"Not applicable" statement in the Architecture
#     Views & Diagrams section when no diagram genuinely applies
#   - Unfilled placeholders (___, TODO, TBD) OUTSIDE code fences / inline spans
#   - Unclosed Mermaid fences
#
# Conditional sections are validated for basic coherence ONLY when present:
#   - Data Architecture present -> Database Selection expected, or an explicit
#     "None required"/"Not applicable" statement when no database is in scope
#     (cache-only/file-based/data-less systems must not fabricate a DB row)
#   - Non-Functional Requirements present -> at least one measurable target
#     (a line with a digit followed by a unit — ms, s, min, hour, day, %, GB,
#     TB, $, RPS, etc. — or a p9x percentile; bare unit words like min/max do
#     NOT count without a number). Sections with nothing measurable to state
#     are omitted entirely, per the template.
#   - Mermaid blocks present -> checked for declared type; absence of
#     erDiagram/sequenceDiagram is a warning, NOT a failure (scope-conditional)
#
# Usage: ./validate-architecture-md.sh [path-to-ARCHITECTURE.md]
# Defaults to ./ARCHITECTURE.md in current directory.

set -euo pipefail

ARCHITECTURE_FILE="${1:-ARCHITECTURE.md}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASS=0
FAIL=0
WARN=0

check_section() {
	local pattern="$1"
	local label="$2"
	local required="${3:-true}" # true = required, false = optional

	if grep -q "$pattern" "$ARCHITECTURE_FILE" 2>/dev/null; then
		echo -e "  ${GREEN}\xe2\x9c\x93${NC} $label"
		PASS=$((PASS + 1))
	else
		if [ "$required" = "true" ]; then
			echo -e "  ${RED}\xe2\x9c\x97${NC} $label \xe2\x80\x94 MISSING"
			FAIL=$((FAIL + 1))
		else
			echo -e "  ${YELLOW}\xe2\x97\x8b${NC} $label \xe2\x80\x94 not found (optional)"
			WARN=$((WARN + 1))
		fi
	fi
}

# Extract a section body: the lines after the heading matching $1, up to the
# next top-level (^## ) heading. Subsection (###) headings are included.
section_body() {
	local start="$1"
	awk -v start="$start" '
        $0 ~ start && !in_sec { in_sec = 1; next }
        /^## / && in_sec { exit }
        in_sec { print }
    ' "$ARCHITECTURE_FILE"
}

# True when a section body carries an explicit "nothing applies" statement.
has_escape() {
	printf '%s\n' "$1" | grep -qiE 'None required|not applicable|no database|no pattern|no system diagram'
}

echo "============================================"
echo " Validating: $ARCHITECTURE_FILE"
echo "============================================"
echo ""

# File existence
if [ ! -f "$ARCHITECTURE_FILE" ]; then
	echo -e "${RED}ERROR:${NC} $ARCHITECTURE_FILE does not exist."
	exit 1
fi

echo "Core Contract (always required):"
echo "-------------------------------"

# System Overview
check_section "## System Overview" "System Overview"

# Architecture Pattern: section must exist; either "Chosen pattern" is
# declared or an explicit None-required statement is present (no invented
# patterns).
check_section "## Architecture Pattern" "Architecture Pattern"
PATTERN_BODY=$(section_body "^## Architecture Pattern")
if grep -q "Chosen pattern" <<<"$PATTERN_BODY"; then
	echo -e "  ${GREEN}\xe2\x9c\x93${NC} Architecture Pattern \xe2\x80\x94 chosen pattern declared"
	PASS=$((PASS + 1))
elif has_escape "$PATTERN_BODY"; then
	echo -e "  ${GREEN}\xe2\x9c\x93${NC} Architecture Pattern \xe2\x80\x94 explicit \`None required\` accepted"
	PASS=$((PASS + 1))
else
	echo -e "  ${RED}\xe2\x9c\x97${NC} Architecture Pattern \xe2\x80\x94 neither \`Chosen pattern\` nor explicit \`None required\`"
	FAIL=$((FAIL + 1))
fi

# System Architecture Diagram: a Mermaid block, or an explicit None-required
# statement in the Architecture Views & Diagrams section.
if grep -q '```mermaid' "$ARCHITECTURE_FILE" 2>/dev/null; then
	echo -e "  ${GREEN}\xe2\x9c\x93${NC} System Architecture Diagram (Mermaid)"
	PASS=$((PASS + 1))
elif has_escape "$(section_body "^## Architecture Views & Diagrams")"; then
	echo -e "  ${GREEN}\xe2\x9c\x93${NC} System Architecture Diagram \xe2\x80\x94 explicit \`None required\` accepted"
	PASS=$((PASS + 1))
else
	echo -e "  ${RED}\xe2\x9c\x97${NC} System Architecture Diagram \xe2\x80\x94 no Mermaid block and no explicit \`None required\`"
	FAIL=$((FAIL + 1))
fi

# Component Details
check_section "## Component Details" "Component Details"

# Key Decisions
check_section "## Key Decisions" "Key Decisions"

# ADRs (section must exist; content can say "None required")
check_section "## ADRs" "ADRs section"

echo ""
echo "Conditional Sections (coherence when present):"
echo "---------------------------------------------"

# Data Architecture: if present, Database Selection expected, or an explicit
# None-required statement when no database is in scope.
if grep -q "## Data Architecture" "$ARCHITECTURE_FILE" 2>/dev/null; then
	DATA_BODY=$(section_body "^## Data Architecture")
	if grep -q "### Database Selection" <<<"$DATA_BODY"; then
		echo -e "  ${GREEN}\xe2\x9c\x93${NC} Data Architecture \xe2\x80\x94 Database Selection present"
		PASS=$((PASS + 1))
	elif has_escape "$DATA_BODY"; then
		echo -e "  ${GREEN}\xe2\x9c\x93${NC} Data Architecture \xe2\x80\x94 explicit \`None required\` accepted (no database in scope)"
		PASS=$((PASS + 1))
	else
		echo -e "  ${RED}\xe2\x9c\x97${NC} Data Architecture present but Database Selection missing (and no explicit \`None required\`)"
		FAIL=$((FAIL + 1))
	fi
else
	echo -e "  ${YELLOW}\xe2\x97\x8b${NC} Data Architecture \xe2\x80\x94 absent (OK when no data model in scope)"
	WARN=$((WARN + 1))
fi

# NFRs: if present, at least one measurable target expected
if grep -q "## Non-Functional Requirements" "$ARCHITECTURE_FILE" 2>/dev/null; then
	if grep -Eq "## Non-Functional Requirements" "$ARCHITECTURE_FILE" &&
		awk '
            /^## Non-Functional Requirements/ { in_nfr = 1; next }
            /^## / && in_nfr && $0 !~ /Non-Functional Requirements/ { exit }
            in_nfr && /([0-9]+(\.[0-9]+)?\s*(minute|minutes|hour|hours|day|days|year|years|ms|min|s|%|GB|TB|MB|KB|RPS|\$|€|£)([^A-Za-z0-9]|$))|p9[0-9]/ { found = 1 }
            END { exit !found }
        ' "$ARCHITECTURE_FILE"; then
		echo -e "  ${GREEN}\xe2\x9c\x93${NC} NFRs \xe2\x80\x94 measurable target(s) present"
		PASS=$((PASS + 1))
	else
		echo -e "  ${RED}\xe2\x9c\x97${NC} NFRs present but no measurable target found"
		FAIL=$((FAIL + 1))
	fi
else
	echo -e "  ${YELLOW}\xe2\x97\x8b${NC} Non-Functional Requirements \xe2\x80\x94 absent (OK when not applicable)"
	WARN=$((WARN + 1))
fi

echo ""
echo "Embedded Mermaid Views (coherence when present):"
echo "-----------------------------------------------"

# Extract fenced Mermaid blocks into a temp file
MERMAID_BLOCKS=$(mktemp)
trap 'rm -f "$MERMAID_BLOCKS"' EXIT
awk '
    /^```mermaid/ { in_fence = 1; print "\n---FENCE-START---"; next }
    /^```$/ && in_fence { in_fence = 0; print "---FENCE-END---\n"; next }
    in_fence { print }
' "$ARCHITECTURE_FILE" >"$MERMAID_BLOCKS"

# ERD: if a fenced block declares erDiagram/classDiagram, coherent; absence = warning
if grep -qE '^(erDiagram|classDiagram)' "$MERMAID_BLOCKS"; then
	echo -e "  ${GREEN}\xe2\x9c\x93${NC} Embedded Mermaid data-model block present (erDiagram/classDiagram)"
	PASS=$((PASS + 1))
else
	echo -e "  ${YELLOW}\xe2\x97\x8b${NC} No embedded data-model block \xe2\x80\x94 OK when no data model is in scope"
	WARN=$((WARN + 1))
fi

# Runtime flow: if present, coherent; absence = warning
if grep -qE '^(sequenceDiagram|flowchart([[:space:]]+[A-Za-z]+)?)' "$MERMAID_BLOCKS"; then
	echo -e "  ${GREEN}\xe2\x9c\x93${NC} Embedded runtime flow block present (sequenceDiagram or flowchart)"
	PASS=$((PASS + 1))
else
	echo -e "  ${YELLOW}\xe2\x97\x8b${NC} No runtime flow block \xe2\x80\x94 OK when no runtime flow is in scope"
	WARN=$((WARN + 1))
fi

rm -f "$MERMAID_BLOCKS"

echo ""
echo "Quality Checks:"
echo "---------------"

# Placeholders OUTSIDE fenced code blocks AND inline code spans fail.
PLACEHOLDER_OUTSIDE=$(awk '
    BEGIN { in_fence = 0 }
    /^```/ { in_fence = !in_fence; next }
    !in_fence {
        gsub(/`[^`]*`/, "")
        print NR": "$0
    }
' "$ARCHITECTURE_FILE" | grep -cE "(^|[^a-zA-Z])___([[:space:]]|[[:punct:]]|$)|\\bTODO\\b|\\bTBD\\b" 2>/dev/null || true)
if [ "$PLACEHOLDER_OUTSIDE" -gt 0 ]; then
	echo -e "  ${RED}\xe2\x9c\x97${NC} Found $PLACEHOLDER_OUTSIDE unfilled placeholders outside code fences \xe2\x80\x94 fill them in"
	FAIL=$((FAIL + 1))
else
	echo -e "  ${GREEN}\xe2\x9c\x93${NC} No unfilled placeholders outside code fences"
	PASS=$((PASS + 1))
fi

# Mermaid blocks properly closed
MERMAID_START=$(grep -c '```mermaid' "$ARCHITECTURE_FILE" 2>/dev/null || true)
MERMAID_END=$(grep -c '^```$' "$ARCHITECTURE_FILE" 2>/dev/null || true)
if [ "$MERMAID_START" -gt "$MERMAID_END" ]; then
	echo -e "  ${RED}\xe2\x9c\x97${NC} Unclosed Mermaid diagram block \xe2\x80\x94 add closing \`\`\`"
	FAIL=$((FAIL + 1))
else
	echo -e "  ${GREEN}\xe2\x9c\x93${NC} Mermaid diagram blocks properly closed"
	PASS=$((PASS + 1))
fi

echo ""
echo "============================================"
echo -e " Results: ${GREEN}$PASS passed${NC}, ${YELLOW}$WARN warnings${NC}, ${RED}$FAIL failed${NC}"
echo "============================================"

if [ "$FAIL" -gt 0 ]; then
	echo ""
	echo -e "${RED}VALIDATION FAILED${NC} \xe2\x80\x94 $FAIL core-contract/coherence checks are missing or incomplete."
	echo "Fix the issues above before considering ARCHITECTURE.md complete."
	exit 1
fi
echo ""
echo -e "${GREEN}VALIDATION PASSED${NC} \xe2\x80\x94 core contract present; conditional sections coherent."
if [ "$WARN" -gt 0 ]; then
	echo "$WARN warnings (absent conditional sections are expected when not applicable)."
fi
exit 0
