---
description: Generate release notes from commits and pull requests.
argument-hint: [version-or-range]
allowed-tools: Bash(git tag:*), Bash(git log:*), Bash(gh api:*), Read
model: sonnet
---

# Release Notes

Create three outputs for the release range identified by `$ARGUMENTS` or, if omitted, from the latest stable tag to `HEAD`.

## Context

- Latest stable tag: !`git tag --sort=-v:refname | head -n 1`
- Commit log: !`git log --oneline --no-merges -20`

## Task

Produce:

1. A changelog section
2. A release pull request body
3. A user-facing announcement

Separate user-facing changes from internal engineering work.
