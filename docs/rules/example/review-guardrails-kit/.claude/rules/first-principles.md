# First Principles

## Hard Constraints

- Never delete production data without explicit confirmation.
- Never add secrets to version-controlled files.
- Never modify files outside the current task scope without calling it out.

## Quality Thresholds

- Every bug fix requires a regression test.
- New public behavior needs explicit validation.
- No silent error handling.

## Workflow Invariants

- Read before editing.
- Re-test after significant change.
- Stop and report when the current task conflicts with the repository contract.
