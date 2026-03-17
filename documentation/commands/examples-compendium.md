# Command Examples Compendium

This compendium reorganizes the entire `documentation/commands/examples/` folder into a smaller set of reusable patterns.

Instead of repeating thirty separate prompt files with similar section names, this document groups them into command families, explains what each family teaches, and shows how to reuse the best parts.

## Executive Summary

| Family | Main goal | Source files merged |
|---|---|---|
| 1. Audits and scorecards | Turn broad analysis into structured findings and priorities | `audit-agents-skills`, `audit-codebase` |
| 2. Context recovery and diagnostics | Rebuild context or inspect a broken environment fast | `catchup`, `diagnose`, `sandbox-status` |
| 3. Explanation and learning | Teach code, patterns, or trade-offs at the right depth | `explain`, `learn/teach`, `learn/quiz`, `learn/alternatives` |
| 4. Quality improvement | Generate tests and identify refactors or bottlenecks | `generate-tests`, `optimize`, `refactor` |
| 5. Commit and validation gates | Validate changes before they become history | `commit`, `validate-changes` |
| 6. Git worktree lifecycle | Create, inspect, and clean isolated worktrees safely | `git-worktree`, `git-worktree-status`, `git-worktree-clean`, `git-worktree-remove` |
| 7. Planning pipeline | Challenge a request, lock architecture, validate, then execute | `review-plan`, `plan-ceo-review`, `plan-eng-review`, `plan-start`, `plan-validate`, `plan-execute` |
| 8. PR and review workflow | Prepare pull requests and review them consistently | `pr`, `review-pr` |
| 9. Release and deployment | Summarize changes, verify readiness, inspect SonarCloud | `release-notes`, `ship`, `sonarqube` |
| 10. Security operations | Scan configs, projects, and threat intelligence inputs | `security`, `security-check`, `security-audit`, `update-threat-db`, `resources/threat-db.yaml` |

## Index

1. [Audits and scorecards](#1-audits-and-scorecards)
2. [Context recovery and diagnostics](#2-context-recovery-and-diagnostics)
3. [Explanation and learning](#3-explanation-and-learning)
4. [Quality improvement](#4-quality-improvement)
5. [Commit and validation gates](#5-commit-and-validation-gates)
6. [Git worktree lifecycle](#6-git-worktree-lifecycle)
7. [Planning pipeline](#7-planning-pipeline)
8. [PR and review workflow](#8-pr-and-review-workflow)
9. [Release and deployment](#9-release-and-deployment)
10. [Security operations](#10-security-operations)
11. [Coverage map](#11-coverage-map)

## 1. Audits and scorecards

Summary: these commands are good models when you need a repeatable assessment instead of a one-off opinion.

What they have in common:

- explicit categories
- weighted scoring
- severity buckets
- remediation plans
- fixed report formats

What to reuse:

| Reusable idea | Why it works |
|---|---|
| Weighted categories | Prevents one weak area from dominating the whole result |
| Grade thresholds | Makes the result actionable, not just descriptive |
| Structured findings | Easier to compare across runs |
| Fix mode or progression plan | Converts a report into next steps |

Best source patterns:

- `audit-agents-skills.md` for rubric design and production-readiness grading
- `audit-codebase.md` for category-based project health scoring and tiered progression plans

Use this pattern when:

- the same review should be repeatable over time
- several people need to interpret the same result consistently
- the output should feed a backlog or milestone plan

## 2. Context recovery and diagnostics

Summary: these commands rebuild state after context loss or inspect the execution environment before deeper work.

Core pattern:

1. discover the local state
2. classify the problem
3. ask targeted follow-up questions only if needed
4. return the shortest useful prescription

What each source adds:

| Source | Contribution |
|---|---|
| `catchup.md` | Reconstructs recent git activity and likely next steps |
| `diagnose.md` | Adds troubleshooting categories, environment scans, and a diagnosis/prescription format |
| `sandbox-status.md` | Shows how to expose environment capabilities and active config cleanly |

Why this family is useful:

- it front-loads context gathering
- it avoids generic advice
- it keeps operational debugging grounded in actual local state

Adaptation tips:

- use it for onboarding commands
- use it for "what changed?" commands
- use it for environment sanity checks before risky workflows

## 3. Explanation and learning

Summary: these commands teach rather than execute.

Core pattern:

| Skill | Source files | Best use |
|---|---|---|
| Explain a target | `explain.md` | Code walkthroughs, architecture explanations, concept breakdowns |
| Teach progressively | `learn/teach.md` | Step-by-step concept teaching with beginner/intermediate/advanced adaptation |
| Quiz for retention | `learn/quiz.md` | Verify understanding after implementation or review |
| Compare alternatives | `learn/alternatives.md` | Show trade-offs and recommend the best fit |

What makes them effective:

- depth modes such as quick, default, and deep
- explicit response formats
- examples plus line-by-line or criteria-based explanations
- emphasis on trade-offs instead of one "correct" answer

How to reuse the pattern:

- if your command explains behavior, define levels of depth
- if your command compares approaches, force a recommendation at the end
- if your command quizzes, ask one question at a time and explain the answer

## 4. Quality improvement

Summary: these commands help improve existing code without jumping straight into large rewrites.

Source roles:

| Source | Main focus |
|---|---|
| `generate-tests.md` | Test generation and coverage categories |
| `optimize.md` | Performance bottlenecks, impact/effort/risk triage |
| `refactor.md` | SOLID violations, code smells, refactoring priorities |

Shared pattern:

1. identify a target scope
2. inspect the current state
3. classify findings by type
4. rank improvements by impact and risk
5. return concrete next actions

What to borrow:

- test categories from `generate-tests`
- impact/effort/risk columns from `optimize`
- safety checklist from `refactor`

This family works best when:

- the user already has working code
- the problem is quality, maintainability, or speed
- the output should guide the next edit, not replace the edit itself

## 5. Commit and validation gates

Summary: these commands reduce bad commits by forcing a small decision gate before history changes.

Sources:

- `commit.md`
- `validate-changes.md`

What they teach:

| Pattern | Why it matters |
|---|---|
| Analyze staged changes first | Prevents message generation detached from actual code |
| Use a conventional output format | Keeps history searchable and predictable |
| Introduce an approve/review/reject gate | Adds a last checkpoint before commit |
| Ask for confirmation before side effects | Preserves human control |

Recommended merged pattern:

1. inspect staged diff
2. evaluate risk and completeness
3. generate the commit message
4. ask for confirmation
5. commit only if explicitly approved

Use this as a template for any command that ends in a destructive or irreversible action.

## 6. Git worktree lifecycle

Summary: this is the clearest command suite in the example set because it covers an entire lifecycle instead of one isolated prompt.

Suite members:

| Command | Role |
|---|---|
| `git-worktree.md` | Create and prepare an isolated worktree |
| `git-worktree-status.md` | Inspect background checks and health |
| `git-worktree-clean.md` | Batch-clean stale worktrees |
| `git-worktree-remove.md` | Remove a single worktree safely |

Why this suite stands out:

- every command has a bounded purpose
- the files reference each other clearly
- safety checks are explicit
- there are dry-run and force trade-offs
- the workflow keeps state visible through logs and reports

Best ideas to reuse:

- define companion commands when a workflow spans several states
- protect dangerous targets such as `main` or `develop`
- show quick-reference tables for decision-heavy flows
- separate safe defaults from force modes

This suite is the best template for multi-command operational workflows.

## 7. Planning pipeline

Summary: these files model a layered planning system where direction, architecture, validation, and execution are separate steps.

Source files:

- `review-plan.md`
- `plan-ceo-review.md`
- `plan-eng-review.md`
- `plan-start.md`
- `plan-validate.md`
- `plan-execute.md`

How the family fits together:

```text
Challenge the brief
-> lock the product direction
-> lock the architecture
-> build the implementation plan
-> validate the plan independently
-> execute in layers
```

What each stage contributes:

| Stage | Main value |
|---|---|
| `review-plan` | Interactive critical review before coding |
| `plan-ceo-review` | Product framing and scope discipline |
| `plan-eng-review` | Diagrams, failure modes, trust boundaries, test matrix |
| `plan-start` | Structured plan generation with ADR capture |
| `plan-validate` | Independent validation and issue triage |
| `plan-execute` | Layered implementation with quality gates and cleanup |

Why this family is important:

- it separates thinking modes
- it records decisions instead of letting them stay implicit
- it turns large work into explicit gates

Reuse this family when:

- the change is expensive to undo
- there are architecture decisions hiding inside a "simple" feature
- you need validation to be independent from planning

## 8. PR and review workflow

Summary: these commands move from "changes exist" to "changes are reviewable".

Sources:

- `pr.md`
- `review-pr.md`

Important patterns:

| Pattern | Source | Why it is useful |
|---|---|---|
| Complexity scoring before PR creation | `pr.md` | Flags oversized or mixed-scope PRs early |
| Split recommendations | `pr.md` | Keeps reviewable units smaller |
| Review checklist | `review-pr.md` | Makes code review systematic |
| Severity classification | `review-pr.md` | Separates blockers from suggestions |
| Anti-hallucination review rules | `review-pr.md` | Forces claims to be verified against the codebase |

Best reuse idea:

Pair PR creation with a pre-review quality gate so the command can warn about scope and also prepare a better review surface.

## 9. Release and deployment

Summary: these commands help package, verify, and communicate a release.

Sources:

- `release-notes.md`
- `ship.md`
- `sonarqube.md`

What each one teaches:

| Source | Contribution |
|---|---|
| `release-notes.md` | Transform commit history into changelog, PR body, and user-facing announcement |
| `ship.md` | Convert deploy readiness into blockers, warnings, and post-deploy checks |
| `sonarqube.md` | Pull external quality signals into a structured report |

Shared pattern:

1. collect release evidence
2. classify what is blocking vs informational
3. define the final report structure
4. tie technical results back to operational decisions

This family is especially good when the command must bridge engineering output and stakeholder communication.

## 10. Security operations

Summary: these files form the largest domain-specific command family in the folder.

Sources:

- `security.md`
- `security-check.md`
- `security-audit.md`
- `update-threat-db.md`
- `resources/threat-db.yaml`

How the family layers:

| Layer | Purpose |
|---|---|
| Quick heuristic scan | `security.md` |
| Config-focused threat check | `security-check.md` |
| Full scored posture review | `security-audit.md` |
| Threat intelligence maintenance | `update-threat-db.md` + `threat-db.yaml` |

What the threat database contributes:

The YAML file is not just reference data. It defines the knowledge model behind the security commands:

- malicious authors
- malicious skills
- malicious skill patterns
- CVE database
- minimum safe versions
- indicators of compromise
- suspicious patterns
- campaigns
- attack techniques
- scanning tools
- defensive resources

Best reuse ideas from this family:

- combine heuristic scans with a curated knowledge base
- distinguish configuration risk from project risk
- make the report scored, prioritized, and actionable
- keep the threat intel source explicit and updateable

## 11. Coverage map

This map shows where every original example file ended up in the compendium.

| Original file | Consolidated section |
|---|---|
| `audit-agents-skills.md` | Audits and scorecards |
| `audit-codebase.md` | Audits and scorecards |
| `catchup.md` | Context recovery and diagnostics |
| `commit.md` | Commit and validation gates |
| `diagnose.md` | Context recovery and diagnostics |
| `explain.md` | Explanation and learning |
| `generate-tests.md` | Quality improvement |
| `git-worktree.md` | Git worktree lifecycle |
| `git-worktree-status.md` | Git worktree lifecycle |
| `git-worktree-clean.md` | Git worktree lifecycle |
| `git-worktree-remove.md` | Git worktree lifecycle |
| `learn/teach.md` | Explanation and learning |
| `learn/quiz.md` | Explanation and learning |
| `learn/alternatives.md` | Explanation and learning |
| `optimize.md` | Quality improvement |
| `plan-ceo-review.md` | Planning pipeline |
| `plan-eng-review.md` | Planning pipeline |
| `plan-start.md` | Planning pipeline |
| `plan-validate.md` | Planning pipeline |
| `plan-execute.md` | Planning pipeline |
| `pr.md` | PR and review workflow |
| `refactor.md` | Quality improvement |
| `release-notes.md` | Release and deployment |
| `review-plan.md` | Planning pipeline |
| `review-pr.md` | PR and review workflow |
| `sandbox-status.md` | Context recovery and diagnostics |
| `security.md` | Security operations |
| `security-audit.md` | Security operations |
| `security-check.md` | Security operations |
| `ship.md` | Release and deployment |
| `sonarqube.md` | Release and deployment |
| `update-threat-db.md` | Security operations |
| `validate-changes.md` | Commit and validation gates |
| `resources/threat-db.yaml` | Security operations |

Use this compendium as the high-level reference, and open the original file only when you need a domain-specific detail that was intentionally compressed here.
