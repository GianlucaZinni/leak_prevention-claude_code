---
description: Review a pull request and return structured findings.
argument-hint: [pr-number-or-url]
allowed-tools: Bash(gh pr view:*), Bash(git diff:*), Read, Grep, Glob
model: sonnet
---

# Review Pull Request

Use the pull request reference in `$ARGUMENTS`. If no argument is supplied, review the current branch diff against the default branch.

## Context

- Pull request metadata: !`gh pr view $ARGUMENTS --json title,body,files,additions,deletions`
- Current diff: !`git diff --stat`

## Task

Review the changes with emphasis on correctness, regressions, security, and missing tests.

## Output

Return:

1. Summary
2. Approval status
3. Critical findings
4. Important suggestions
5. Positive highlights
