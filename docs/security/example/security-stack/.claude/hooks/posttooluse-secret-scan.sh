#!/usr/bin/env bash
set -euo pipefail

payload=$(cat)

if echo "$payload" | grep -qiE 'AKIA[0-9A-Z]{16}|-----BEGIN (RSA|OPENSSH|EC) PRIVATE KEY-----|postgres://[^[:space:]]+:[^[:space:]]+@'; then
  echo "Warning: output may contain secrets. Review before continuing." >&2
fi

exit 0
