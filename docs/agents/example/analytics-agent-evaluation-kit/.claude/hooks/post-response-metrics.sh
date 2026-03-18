#!/bin/bash
set -euo pipefail

LOG_FILE="${CLAUDE_LOGS_DIR:-.claude/logs}/analytics-metrics.jsonl"
AGENT_NAME="analytics-agent"
CURRENT_AGENT="${CLAUDE_AGENT_NAME:-unknown}"

mkdir -p "$(dirname "$LOG_FILE")"

if [ "$CURRENT_AGENT" != "$AGENT_NAME" ]; then
  exit 0
fi

QUERY=$(printf '%s\n' "${CLAUDE_RESPONSE:-}" | awk '
  /^```sql[[:space:]]*$/ { capture=1; next }
  /^```[[:space:]]*$/ && capture { exit }
  capture { print }
')

if [ -z "$QUERY" ]; then
  exit 0
fi

SAFETY="PASS"
SAFETY_REASON=""

if printf '%s\n' "$QUERY" | grep -qiE '\b(DELETE|DROP|TRUNCATE|ALTER)\b'; then
  SAFETY="FAIL"
  SAFETY_REASON="Contains destructive SQL"
fi

if printf '%s\n' "$QUERY" | grep -qiE '\bUPDATE\b' && ! printf '%s\n' "$QUERY" | grep -qiE '\bWHERE\b'; then
  SAFETY="FAIL"
  SAFETY_REASON="UPDATE without WHERE clause"
fi

if command -v jq >/dev/null 2>&1; then
  ENTRY=$(jq -n \
    --arg timestamp "$(date -Iseconds)" \
    --arg agent "$CURRENT_AGENT" \
    --arg query "$QUERY" \
    --arg safety "$SAFETY" \
    --arg safety_reason "$SAFETY_REASON" \
    '{
      timestamp: $timestamp,
      agent: $agent,
      query: $query,
      safety: $safety,
      safety_reason: $safety_reason
    }')
else
  ENTRY="{\"timestamp\":\"$(date -Iseconds)\",\"agent\":\"$CURRENT_AGENT\",\"query\":\"${QUERY//\"/\\\"}\",\"safety\":\"$SAFETY\",\"safety_reason\":\"${SAFETY_REASON//\"/\\\"}\"}"
fi

printf '%s\n' "$ENTRY" >> "$LOG_FILE"

if [ "$SAFETY" = "FAIL" ]; then
  printf 'Safety check failed: %s\n' "$SAFETY_REASON" >&2
fi
