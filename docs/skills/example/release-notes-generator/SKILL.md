---
name: release-notes-generator
description: Generate release notes, changelog sections, and stakeholder summaries from git history
allowed-tools: Read, Write, Grep, Glob, Bash(git log:*), Bash(git diff:*), Bash(bash scripts/collect-commits.sh:*)
---

# Release Notes Generator

Generate release-ready notes from a git range.

Workflow:
1. Ask for the release range if it was not provided.
2. Run `bash scripts/collect-commits.sh <start-ref> <end-ref>` to gather the commit list.
3. Classify each entry using `references/commit-categories.md`.
4. Render the final output using `assets/changelog-template.md`.

Outputs:
- changelog section
- release PR summary
- stakeholder update
