# Rule Examples

This companion shows smaller rule patterns that sit alongside the main guide. The main guide contains one complete rule pack. This document highlights focused shapes you can mix into a repository without adopting the whole example unchanged.

<a id="index"></a>
## Index

- [Session Invariant Contract](#session-invariant-contract)
- [Architecture Review Overlay](#architecture-review-overlay)
- [Code Quality Overlay](#code-quality-overlay)
- [Performance Overlay](#performance-overlay)
- [Test Review Overlay](#test-review-overlay)

<a id="session-invariant-contract"></a>
## Session Invariant Contract

A session invariant file is the right place for never-break constraints. It should remain short enough to read at startup and explicit enough to survive context compression.

Typical contents:

- data safety boundaries
- process constraints such as commit discipline
- task-scope limits
- measurable quality thresholds

If a rule has exceptions every day, it does not belong in this layer.

<a id="architecture-review-overlay"></a>
## Architecture Review Overlay

An architecture overlay should help Claude inspect structure rather than restate coding style.

Useful prompts for this overlay:

- Are responsibilities split across clean boundaries?
- Is data ownership explicit?
- Are interfaces stable and narrow?
- Where are the failure points under higher load?

This overlay works best on plans, ADRs, subsystem refactors, and cross-cutting changes.

<a id="code-quality-overlay"></a>
## Code Quality Overlay

A code quality overlay focuses on maintainability rather than raw correctness.

High-value checks include:

- duplicated logic
- weak or silent error handling
- inconsistent naming or module placement
- over-engineering and under-engineering

This overlay is especially effective when paired with a repository that already has style automation, because the rule can focus on structure instead of formatting.

<a id="performance-overlay"></a>
## Performance Overlay

Performance rules should help Claude ask the right questions before optimization starts.

The most useful checks tend to be:

- query shape and N+1 patterns
- data loading granularity
- unnecessary work in hot paths
- placement of caching boundaries

Performance overlays are most valuable when the repository already knows which paths are user-facing or latency-sensitive.

<a id="test-review-overlay"></a>
## Test Review Overlay

Test rules should keep the focus on behavior, coverage gaps, and failure modes.

A good test overlay asks:

- which public behavior remains untested
- whether failure paths are covered
- whether edge cases are explicit
- whether tests are independent and stable

This overlay becomes stronger when the repository contract already states which kinds of changes require regression or integration testing.
