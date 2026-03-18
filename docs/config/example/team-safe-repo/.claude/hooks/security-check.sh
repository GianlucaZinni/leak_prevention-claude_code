#!/usr/bin/env sh
set -eu

tool_name="${CLAUDE_TOOL_NAME:-}"
tool_input="${CLAUDE_TOOL_INPUT:-}"

case "$tool_name" in
  Bash)
    if printf '%s\n' "$tool_input" | grep -Eq '(^|[[:space:]])(rm[[:space:]]+-rf|sudo|dd|mkfs\.)'; then
      printf '%s\n' "Blocked by project policy: dangerous shell command." >&2
      exit 2
    fi
    ;;
esac

exit 0
