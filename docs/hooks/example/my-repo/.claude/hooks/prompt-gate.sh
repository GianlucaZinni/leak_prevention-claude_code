#!/usr/bin/env bash
set -euo pipefail

input=$(cat)
prompt=$(echo "$input" | jq -r '.prompt // empty')

if echo "$prompt" | grep -qiE '(password|secret|token)[[:space:]]*[:=]'; then
  echo "Blocked: remove secrets from the prompt" >&2
  exit 2
fi

project_name=$(basename "${CLAUDE_PROJECT_DIR:-$(pwd)}")
branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")

printf 'Project: %s\nBranch: %s\n---\n' "$project_name" "$branch"
exit 0
