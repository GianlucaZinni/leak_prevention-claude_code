#!/usr/bin/env sh
set -eu

tool_name="${CLAUDE_TOOL_NAME:-}"
tool_input="${CLAUDE_TOOL_INPUT:-}"

case "$tool_name" in
  Write|Edit)
    if [ -n "$tool_input" ] && command -v prettier >/dev/null 2>&1; then
      prettier --write "$tool_input" >/dev/null 2>&1 || true
    fi
    ;;
esac

exit 0
