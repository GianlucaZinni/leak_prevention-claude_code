#!/usr/bin/env bash
set -euo pipefail

payload=$(cat)

if echo "$payload" | grep -qiE 'rm -rf /|chmod -R 777|curl .*\|[[:space:]]*sh|ignore previous instructions'; then
  echo "Blocked by security-guardrails plugin." >&2
  exit 2
fi

exit 0
