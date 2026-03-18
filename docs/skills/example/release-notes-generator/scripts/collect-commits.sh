#!/usr/bin/env bash
set -euo pipefail

start_ref="${1:?missing start ref}"
end_ref="${2:?missing end ref}"

git log --no-merges --pretty=format:'%h|%s' "${start_ref}..${end_ref}"
