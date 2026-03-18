# Command Examples

This companion collects focused command patterns that complement the main guide. The main guide contains one complete end-to-end workbench. This document shows additional command shapes you can adapt when your repository needs narrower workflows.

<a id="index"></a>
## Index

- [Review and Audit Commands](#review-and-audit-commands)
- [Planning and Execution Commands](#planning-and-execution-commands)
- [Release and Delivery Commands](#release-and-delivery-commands)
- [Learning Commands](#learning-commands)
- [Repository Maintenance Commands](#repository-maintenance-commands)

<a id="review-and-audit-commands"></a>
## Review and Audit Commands

Review commands are the highest-value category because they compress an otherwise repetitive evaluation rubric into a stable interface.

Typical patterns:

- pull request review with structured findings
- plan review before implementation starts
- security audit of repository configuration and code
- targeted validation after a change lands

The strongest review commands define severity levels up front and force an output shape that is easy to scan in a code review or operational handoff.

<a id="planning-and-execution-commands"></a>
## Planning and Execution Commands

Planning commands are useful when the repository uses a formal plan-before-build workflow. They usually parse an existing plan, stage execution into phases, and define checkpoints for quality and drift detection.

Useful subpatterns include:

- create a plan from a request
- validate a plan before execution
- execute a validated plan in a worktree
- diagnose divergence between the plan and implementation

These commands should remain explicit about their stopping conditions. A planning command that never states when to stop usually becomes an unbounded orchestration prompt.

<a id="release-and-delivery-commands"></a>
## Release and Delivery Commands

Release-oriented commands translate Git history and pull request data into artifacts a team actually needs to ship software.

Common outputs:

- changelog sections
- release pull request bodies
- user-facing release announcements
- migration alerts and rollout notes

The key design choice is separating user-facing changes from internal engineering work. Release commands become materially more useful when they can do that transformation consistently.

<a id="learning-commands"></a>
## Learning Commands

Not every repository needs teaching commands, but they are valuable in teams that use Claude Code for onboarding, pair-learning, or recurring explanation flows.

Good learning commands usually do one of three things:

- explain a concept from the current repository
- compare alternatives with trade-offs
- generate short quizzes or checkpoints to verify understanding

These commands should optimize for clarity rather than execution breadth. They are best when they load a narrow set of files and return a clearly structured explanation.

<a id="repository-maintenance-commands"></a>
## Repository Maintenance Commands

Maintenance commands handle repository health, local hygiene, and safe automation around Git or workspace state.

Common examples include:

- worktree creation and cleanup
- repository catch-up summaries
- sandbox or permission status checks
- incremental validation after local changes

These commands should be conservative. Maintenance commands are often closest to destructive actions, so they benefit from tighter tool allowlists and a clear operator confirmation step when the workflow crosses a trust boundary.
