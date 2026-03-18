#!/bin/bash
set -euo pipefail

LOG_FILE="${1:-.claude/logs/analytics-metrics.jsonl}"

if ! command -v jq >/dev/null 2>&1; then
  echo "Error: jq is required but not installed." >&2
  exit 1
fi

if [ ! -f "$LOG_FILE" ]; then
  echo "Error: log file not found: $LOG_FILE" >&2
  exit 1
fi

TOTAL=$(jq -s 'length' "$LOG_FILE")
PASS=$(jq -s '[.[] | select(.safety == "PASS")] | length' "$LOG_FILE")
FAIL=$(jq -s '[.[] | select(.safety == "FAIL")] | length' "$LOG_FILE")

PASS_PCT=0
FAIL_PCT=0
if [ "$TOTAL" -gt 0 ]; then
  PASS_PCT=$((PASS * 100 / TOTAL))
  FAIL_PCT=$((FAIL * 100 / TOTAL))
fi

echo "=== Analytics Agent Metrics Report ==="
echo "Log file: $LOG_FILE"
echo "Total runs: $TOTAL"
echo "Safety pass: $PASS ($PASS_PCT%)"
echo "Safety fail: $FAIL ($FAIL_PCT%)"
echo

if [ "$FAIL" -gt 0 ]; then
  echo "Common failure reasons:"
  jq -r -s '
    [ .[] | select(.safety == "FAIL") | .safety_reason ]
    | group_by(.)
    | map({reason: .[0], count: length})
    | sort_by(-.count)
    | .[]
    | "- \(.reason) (\(.count))"
  ' "$LOG_FILE"
else
  echo "No safety failures recorded."
fi

echo
echo "Next steps:"
echo "1. Review failed SQL patterns."
echo "2. Update the subagent instructions if a recurring issue appears."
echo "3. Fill out eval/report-template.md with the summary."
