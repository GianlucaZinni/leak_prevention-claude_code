---
name: security-review
description: Review the current change set for secrets exposure, unsafe shell usage, dependency risk, and auth or data-flow regressions
allowed-tools: Read, Grep, Glob, Bash(git diff:*), Bash(git status:*), Bash(git log:*)
---

# Security Review

Inspect the current changes with a security-first mindset.

Always check:
- secrets handling
- unsafe command execution
- auth and authorization changes
- dependency additions
- data exfiltration paths

Report concrete findings first, ordered by severity.
