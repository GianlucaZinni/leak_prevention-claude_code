#!/bin/bash
set -euo pipefail

input="$(cat)"

model="$(printf '%s' "$input" | jq -r '.model.display_name')"
dir="$(printf '%s' "$input" | jq -r '.workspace.current_dir' | xargs basename)"
used="$(printf '%s' "$input" | jq -r '.context_window.used_percentage // 0')"

branch=""
if git rev-parse --git-dir >/dev/null 2>&1; then
  current_branch="$(git branch --show-current 2>/dev/null || true)"
  if [ -n "$current_branch" ]; then
    branch=" | ${current_branch}"
  fi
fi

printf '[%s] %s%s | ctx %s%%\n' "$model" "$dir" "$branch" "$used"
