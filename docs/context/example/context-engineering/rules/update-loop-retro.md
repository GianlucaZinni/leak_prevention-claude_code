# Session Retrospective Template

A structured prompt to run at the end of a Claude Code session. The goal is to capture knowledge while it is still fresh and turn it into durable rules.

## Prompt

```text
Session complete. Before we close, run a quick retrospective:

1. What patterns did we establish that should be permanent rules in CLAUDE.md?
2. What did I correct that Claude got wrong? Should a rule prevent that?
3. What worked well that we should replicate in future sessions?
4. Were any architectural decisions made that CLAUDE.md should record?
5. Is there anything currently in CLAUDE.md that this session proved wrong or outdated?

Output a knowledge feed - 3 to 5 bullets max, high-signal items only.
Skip anything obvious, generic, or already in CLAUDE.md.
Format each item as an actionable rule ready to copy in.
```

## When To Run It

| Trigger | Run retro? |
|---|---|
| Feature or major refactor completed | Yes |
| Debugging session that uncovered a systemic gap | Yes |
| Architectural decision made | Yes |
| Onboarding session that exposed missing context | Yes |
| Monthly, even if nothing major happened | Yes |
| Trivial session | No |

## What Good Output Looks Like

The output should be concrete enough to paste back into the relevant section with minimal rewriting. Good items are project-specific, actionable, and easy to verify later.

## After The Retro

1. Review the output.
2. Add the useful rules to `CLAUDE.md`.
3. Remove anything stale.
4. Commit with a traceable message.

