# Context Engineering Toolkit

This example shows a complete workflow for assembling and maintaining project context. The bundle is intentionally small so the relationship between inputs, generation, and validation stays obvious.

Spanish companions are included for the human-facing markdown files in this bundle.

## What It Does

The toolkit assembles a project-specific context file from a profile plus a reusable template set. It also provides checks for budget, drift, and session learnings so the configuration stays maintainable.

## File Map

| File | Purpose |
|---|---|
| `profile-template.yaml` | Developer profile and module selection |
| `skeleton-template.md` | Starting structure for `CLAUDE.md` |
| `assembler.ts` | Generates the final output from the profile and modules |
| `eval-questions.yaml` | Manual quality audit |
| `canary-check.sh` | Structural validation |
| `ci-drift-check.yml` | Weekly automated drift detection |
| `context-budget-calculator.sh` | Budget estimate for always-on context |
| `rules/knowledge-feeding.md` | Captures useful session learnings |
| `rules/update-loop-retro.md` | Retrospective prompt for a closed loop |

## How To Use It

1. Start from the profile template and create a real profile.
2. Adjust the skeleton template to match the project.
3. Run the assembler to generate the final context file.
4. Check the budget before adding more rules.
5. Run the canary check to catch obvious problems.
6. Add the drift workflow to CI if the context file should stay synchronized.
7. Use the rule templates after sessions that produced useful learning.

## Expected Result

The result is a durable context workflow with clear inputs, a generated output, and validation around it. It is easy to inspect, easy to rerun, and easy to evolve.
