# Knowledge Feeding Protocol

Context engineering is not a one-time setup. It improves when the project learns from real sessions and turns that learning into durable rules.

## When To Run It

Run this protocol at the end of any session that:

- completed a meaningful change,
- discovered a new pattern that should become standard,
- exposed a repeated mistake that needed correction,
- or made an architectural decision that should be documented.

Skip it for trivial work.

## Prompt

Use this prompt at the end of a qualifying session:

```text
Before we close this session, run a knowledge feed:

1. What patterns did we establish that should become permanent rules?
2. What did I correct or redirect that should be a rule to prevent recurrence?
3. Were any architectural decisions made that CLAUDE.md should record?
4. Is there anything in CLAUDE.md that this session proved wrong or outdated?

Output only high-signal items. Use the knowledge feed format below.
Skip anything obvious or already covered.
```

## Output Format

```markdown
## Knowledge Feed - YYYY-MM-DD

### New Pattern
**What**: One sentence describing the pattern
**Why**: Why this is the right approach for this project
**Rule to add**:
> Exact text to paste into CLAUDE.md

### Anti-Pattern Found
**What happened**: What Claude did wrong or what was corrected
**Why it's wrong here**: Project-specific reason
**Rule to add**:
> Never: specific behavior to avoid and why

### Architecture Decision
**Decision**: What was decided
**Rationale**: Why, especially if it goes against common practice
**Rule to add**:
> Exact text to paste into CLAUDE.md

### Stale Rule to Remove
**Rule**: Current rule in CLAUDE.md
**Why remove**: What changed that makes this obsolete
```

## Integration Workflow

After receiving the knowledge feed:

1. Review whether the item is specific to the project.
2. Copy relevant rules into the right section of `CLAUDE.md`.
3. Remove stale rules the session exposed.
4. Commit the update with a meaningful message.

## Quality Filter

Before adding a rule, check whether it is:

- specific to this project,
- actionable,
- already covered,
- and still likely to be true in six months.

