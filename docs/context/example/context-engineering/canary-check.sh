#!/usr/bin/env bash
# Context engineering canary check
#
# Run this against a project to verify the structural health of its CLAUDE.md.

set -euo pipefail

PROJECT_DIR="${1:-.}"
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"

PASS=0
FAIL=0
WARN=0
RESULTS=()

log_pass() {
  RESULTS+=("PASS  $1${2:+: $2}")
  PASS=$((PASS + 1))
}

log_fail() {
  RESULTS+=("FAIL  $1${2:+: $2}")
  FAIL=$((FAIL + 1))
}

log_warn() {
  RESULTS+=("WARN  $1${2:+: $2}")
  WARN=$((WARN + 1))
}

check_claude_md_exists() {
  local file="$PROJECT_DIR/CLAUDE.md"
  if [ ! -f "$file" ]; then
    log_fail "CLAUDE.md exists" "not found at $file"
    return 1
  fi
  log_pass "CLAUDE.md exists" "$file"
}

check_claude_md_size() {
  local file="$PROJECT_DIR/CLAUDE.md"
  [ ! -f "$file" ] && return

  local lines
  lines=$(wc -l < "$file" | tr -d ' ')

  if [ "$lines" -lt 10 ]; then
    log_fail "CLAUDE.md has content" "only $lines lines"
  elif [ "$lines" -gt 500 ]; then
    log_warn "CLAUDE.md size" "$lines lines exceeds the healthy range"
  else
    log_pass "CLAUDE.md size" "$lines lines"
  fi
}

check_imports() {
  local file="$PROJECT_DIR/CLAUDE.md"
  [ ! -f "$file" ] && return

  local broken=0
  local resolved=0

  while IFS= read -r line; do
    if [[ "$line" =~ ^@([^[:space:]].+)$ ]]; then
      local import_path="${BASH_REMATCH[1]}"
      local full_path="$PROJECT_DIR/$import_path"
      if [ ! -f "$full_path" ]; then
        log_fail "Broken @import" "@$import_path"
        broken=$((broken + 1))
      else
        resolved=$((resolved + 1))
      fi
    fi
  done < "$file"

  if [ "$broken" -eq 0 ]; then
    if [ "$resolved" -gt 0 ]; then
      log_pass "@import resolution" "all $resolved imports resolve"
    else
      log_pass "@import resolution" "no imports found"
    fi
  fi
}

check_rule_count() {
  local file="$PROJECT_DIR/CLAUDE.md"
  [ ! -f "$file" ] && return

  local rules
  rules=$(grep -cE "^[[:space:]]*[-*] |^[[:space:]]*[0-9]+\. " "$file" 2>/dev/null || echo "0")

  if [ "$rules" -gt 150 ]; then
    log_warn "Rule count" "$rules rules"
  else
    log_pass "Rule count" "$rules rules"
  fi
}

check_conflicts() {
  local file="$PROJECT_DIR/CLAUDE.md"
  [ ! -f "$file" ] && return

  local conflicts=0
  local topics=("comments" "tests" "types" "imports" "exports" "logging" "errors")

  for topic in "${topics[@]}"; do
    local always_count never_count
    always_count=$(grep -ciE "always[[:space:]]+[a-z ]*$topic|$topic[a-z ]*[[:space:]]+always" "$file" 2>/dev/null || echo "0")
    never_count=$(grep -ciE "never[[:space:]]+[a-z ]*$topic|$topic[a-z ]*[[:space:]]+never" "$file" 2>/dev/null || echo "0")

    if [ "$always_count" -gt 0 ] && [ "$never_count" -gt 0 ]; then
      log_warn "Potential conflict: $topic" "both always and never rules found"
      conflicts=$((conflicts + 1))
    fi
  done

  if [ "$conflicts" -eq 0 ]; then
    log_pass "Conflict check" "no obvious contradictions detected"
  fi
}

check_git_tracking() {
  local file="$PROJECT_DIR/CLAUDE.md"
  [ ! -f "$file" ] && return

  if ! command -v git &>/dev/null; then
    log_warn "Git tracking" "git not available"
    return
  fi

  if ! git -C "$PROJECT_DIR" rev-parse --git-dir &>/dev/null 2>&1; then
    log_warn "Git tracking" "not a git repo"
    return
  fi

  if ! git -C "$PROJECT_DIR" ls-files --error-unmatch CLAUDE.md &>/dev/null 2>&1; then
    log_fail "CLAUDE.md in git" "file exists but is not tracked"
    return
  fi

  local last_updated
  last_updated=$(git -C "$PROJECT_DIR" log --format="%ar" -- CLAUDE.md 2>/dev/null | head -1)

  if [ -z "$last_updated" ]; then
    log_warn "CLAUDE.md freshness" "no git history for this file"
  else
    log_pass "CLAUDE.md freshness" "last updated: $last_updated"
  fi
}

check_required_sections() {
  local file="$PROJECT_DIR/CLAUDE.md"
  [ ! -f "$file" ] && return

  local missing=0
  local -a required_sections=("Overview|Purpose|Description" "Architecture|Stack|Tech" "Standards|Conventions|Style")

  for pattern in "${required_sections[@]}"; do
    if ! grep -qiE "^#+ ($pattern)" "$file" 2>/dev/null; then
      log_warn "Missing section" "no heading matching: $pattern"
      missing=$((missing + 1))
    fi
  done

  if [ "$missing" -eq 0 ]; then
    log_pass "Required sections" "overview, architecture, and standards found"
  fi
}

check_token_budget() {
  local file="$PROJECT_DIR/CLAUDE.md"
  [ ! -f "$file" ] && return

  local chars
  chars=$(wc -c < "$file" | tr -d ' ')
  local tokens=$((chars / 4))

  local import_tokens=0
  while IFS= read -r line; do
    if [[ "$line" =~ ^@([^[:space:]].+)$ ]]; then
      local import_path="${BASH_REMATCH[1]}"
      local full_path="$PROJECT_DIR/$import_path"
      if [ -f "$full_path" ]; then
        local import_chars
        import_chars=$(wc -c < "$full_path" | tr -d ' ')
        import_tokens=$((import_tokens + import_chars / 4))
      fi
    fi
  done < "$file"

  local total=$((tokens + import_tokens))

  if [ "$total" -lt 2000 ]; then
    log_pass "Token budget" "~$total tokens"
  elif [ "$total" -lt 10000 ]; then
    log_pass "Token budget" "~$total tokens"
  elif [ "$total" -lt 25000 ]; then
    log_warn "Token budget" "~$total tokens"
  else
    log_fail "Token budget" "~$total tokens"
  fi
}

echo "Context engineering canary check"
echo "Project: $PROJECT_DIR"
echo ""

check_claude_md_exists || true
check_claude_md_size
check_imports
check_rule_count
check_conflicts
check_git_tracking
check_required_sections
check_token_budget

echo ""
echo "Results:"
for result in "${RESULTS[@]}"; do
  echo "  $result"
done

echo ""
echo "Score: $PASS passed, $WARN warnings, $FAIL failed"

if [ "$FAIL" -gt 0 ]; then
  echo "Status: issues found"
  exit "$FAIL"
fi

if [ "$WARN" -gt 0 ]; then
  echo "Status: passed with warnings"
  exit 0
fi

echo "Status: all checks passed"

