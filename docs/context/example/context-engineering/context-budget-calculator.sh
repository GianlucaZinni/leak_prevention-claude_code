#!/usr/bin/env bash
# Context budget calculator
#
# Estimates always-on context cost for a CLAUDE.md-based configuration.

set -euo pipefail

PROJECT_DIR="${1:-.}"
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"
GLOBAL_CLAUDE="$HOME/.claude/CLAUDE.md"
PROJECT_CLAUDE="$PROJECT_DIR/CLAUDE.md"

estimate_tokens() {
  local file="$1"
  if [ ! -f "$file" ]; then
    echo "0"
    return
  fi
  local chars
  chars=$(wc -c < "$file" | tr -d ' ')
  echo $((chars / 4))
}

count_lines() {
  local file="$1"
  if [ ! -f "$file" ]; then
    echo "0"
    return
  fi
  wc -l < "$file" | tr -d ' '
}

count_rules() {
  local file="$1"
  if [ ! -f "$file" ]; then
    echo "0"
    return
  fi
  grep -cE "^[[:space:]]*[-*] |^[[:space:]]*[0-9]+\. " "$file" 2>/dev/null || echo "0"
}

format_assessment() {
  local tokens="$1"
  if [ "$tokens" -lt 2000 ]; then
    echo "LEAN"
  elif [ "$tokens" -lt 10000 ]; then
    echo "HEALTHY"
  elif [ "$tokens" -lt 25000 ]; then
    echo "HEAVY"
  else
    echo "OVERLOADED"
  fi
}

collect_imports() {
  local file="$1"
  local base_dir="$2"
  local -n imports_ref="$3"

  [ ! -f "$file" ] && return

  while IFS= read -r line; do
    if [[ "$line" =~ ^@([^[:space:]].+)$ ]]; then
      local import_path="${BASH_REMATCH[1]}"
      local full_path="$base_dir/$import_path"
      imports_ref+=("$import_path|$full_path")
    fi
  done < "$file"
}

echo "Context budget calculator"
echo "Project: $PROJECT_DIR"
echo ""

GRAND_TOTAL_TOKENS=0
GRAND_TOTAL_RULES=0

echo "Global CLAUDE.md ($GLOBAL_CLAUDE)"
if [ -f "$GLOBAL_CLAUDE" ]; then
  G_TOKENS=$(estimate_tokens "$GLOBAL_CLAUDE")
  G_LINES=$(count_lines "$GLOBAL_CLAUDE")
  G_RULES=$(count_rules "$GLOBAL_CLAUDE")
  echo "  Lines:  $G_LINES"
  echo "  Rules:  $G_RULES"
  echo "  Tokens: ~$G_TOKENS"
  GRAND_TOTAL_TOKENS=$((GRAND_TOTAL_TOKENS + G_TOKENS))
  GRAND_TOTAL_RULES=$((GRAND_TOTAL_RULES + G_RULES))
else
  echo "  (not found)"
fi
echo ""

echo "Project CLAUDE.md ($PROJECT_CLAUDE)"
if [ -f "$PROJECT_CLAUDE" ]; then
  P_TOKENS=$(estimate_tokens "$PROJECT_CLAUDE")
  P_LINES=$(count_lines "$PROJECT_CLAUDE")
  P_RULES=$(count_rules "$PROJECT_CLAUDE")
  echo "  Lines:  $P_LINES"
  echo "  Rules:  $P_RULES"
  echo "  Tokens: ~$P_TOKENS"
  GRAND_TOTAL_TOKENS=$((GRAND_TOTAL_TOKENS + P_TOKENS))
  GRAND_TOTAL_RULES=$((GRAND_TOTAL_RULES + P_RULES))
else
  echo "  (not found)"
fi
echo ""

declare -a IMPORTS=()
collect_imports "$PROJECT_CLAUDE" "$PROJECT_DIR" IMPORTS

IMPORT_TOTAL_TOKENS=0
if [ "${#IMPORTS[@]}" -gt 0 ]; then
  echo "@imports"
  for entry in "${IMPORTS[@]}"; do
    local_path="${entry%%|*}"
    full_path="${entry##*|}"
    if [ -f "$full_path" ]; then
      I_TOKENS=$(estimate_tokens "$full_path")
      I_LINES=$(count_lines "$full_path")
      IMPORT_TOTAL_TOKENS=$((IMPORT_TOTAL_TOKENS + I_TOKENS))
      printf "  %-40s %5d lines  ~%d tokens\n" "@$local_path" "$I_LINES" "$I_TOKENS"
    else
      printf "  %-40s %s\n" "@$local_path" "NOT FOUND"
    fi
  done
  echo "  Import total: ~$IMPORT_TOTAL_TOKENS tokens"
  GRAND_TOTAL_TOKENS=$((GRAND_TOTAL_TOKENS + IMPORT_TOTAL_TOKENS))
  echo ""
fi

echo "Summary"
echo "  Total always-on tokens:  ~$GRAND_TOTAL_TOKENS"
echo "  Total rules/instructions: $GRAND_TOTAL_RULES"
echo "  Budget assessment: $(format_assessment "$GRAND_TOTAL_TOKENS")"

if [ "$GRAND_TOTAL_RULES" -gt 150 ]; then
  echo ""
  echo "Rule count warning: $GRAND_TOTAL_RULES rules exceeds the usual attention ceiling."
fi

echo ""
echo "Optimization tips"
if [ "$GRAND_TOTAL_TOKENS" -gt 10000 ]; then
  echo "  - Move reference material into loaded-on-demand artifacts"
  echo "  - Compress verbose rules"
  echo "  - Remove deprecated patterns"
  echo "  - Deduplicate overlapping rules"
else
  echo "  Budget is healthy."
fi

