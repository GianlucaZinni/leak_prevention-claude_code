# Context Engineering Example Bundle

This folder contains the concrete example referenced by the main guide. It is a small, reproducible toolkit for building and maintaining project context.

Spanish companions are included for the human-facing markdown files so the bundle can be reviewed in either language.

## Contents

- `context-engineering/README.md` explains the workflow end to end.
- `context-engineering/profile-template.yaml` defines the per-developer input.
- `context-engineering/skeleton-template.md` provides the project context outline.
- `context-engineering/assembler.ts` generates the final context file.
- `context-engineering/eval-questions.yaml` supports manual audits.
- `context-engineering/canary-check.sh` validates structure and drift.
- `context-engineering/ci-drift-check.yml` runs automated drift detection.
- `context-engineering/context-budget-calculator.sh` estimates always-on context cost.
- `context-engineering/rules/knowledge-feeding.md` captures session learnings.
- `context-engineering/rules/update-loop-retro.md` provides a retrospective prompt.

## Recommended Order

1. Read the toolkit README.
2. Fill in a profile.
3. Adjust the skeleton to match the project.
4. Generate the final context file.
5. Run the budget calculator and canary checks.
6. Add the drift workflow to CI.
7. Use the retro and knowledge feed prompts after meaningful sessions.
