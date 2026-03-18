#!/usr/bin/env bash
set -euo pipefail

required_vars=("CONTEXT7_API_KEY")

for var_name in "${required_vars[@]}"; do
  if [ -z "${!var_name:-}" ]; then
    echo "Missing required environment variable: ${var_name}" >&2
    exit 1
  fi
done

echo "MCP environment looks ready."
