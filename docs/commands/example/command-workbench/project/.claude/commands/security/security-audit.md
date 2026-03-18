---
description: Audit repository and Claude Code configuration for high-risk security issues.
allowed-tools: Bash(rg:*), Bash(grep:*), Bash(find:*), Read, Grep, Glob
model: sonnet
---

# Security Audit

Run a structured audit across repository contents and Claude Code configuration.

## Task

Check for:

- exposed credentials
- unsafe shell patterns
- weak configuration boundaries
- missing validation around critical entry points

## Output

Return findings grouped as:

1. Critical
2. High
3. Medium
4. Recommended next actions
