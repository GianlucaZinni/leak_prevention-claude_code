# Analytics Agent Evaluation Kit

This bundle shows a complete subagent setup with a measurable feedback loop. It includes the subagent definition, a project-scoped hook, the project settings that attach the hook, and the scripts used to aggregate and review metrics.

## File Layout

```text
analytics-agent-evaluation-kit/
|-- README.md
|-- .claude/
|   |-- agents/
|   |   `-- analytics-agent.md
|   |-- hooks/
|   |   `-- post-response-metrics.sh
|   `-- settings.json
`-- eval/
    |-- metrics.sh
    `-- report-template.md
```

## What It Does

The analytics subagent handles SQL-oriented analysis. After each response, the hook logs a JSON line to `.claude/logs/analytics-metrics.jsonl`. The evaluation scripts then summarize pass rate and common failure reasons, and the report template turns that summary into a monthly review artifact.

## Creation Order

1. Create the directory skeleton.
2. Add the subagent definition.
3. Add the logging hook.
4. Wire the hook in `.claude/settings.json`.
5. Add the evaluation scripts.
6. Run the subagent once and confirm the log file is created.

## Runtime Notes

- The hook expects `jq` to be available for clean JSON logging.
- The metrics script fails fast if the log file is missing or malformed.
- The report template is meant to be filled from the script output, not by guesswork.

## Validation

- The subagent should answer SQL analysis requests without broadening into general-purpose assistance.
- The hook should append one log entry per response.
- The metrics script should produce a readable summary from the JSONL log.
- The report template should accept the script output without changing the structure.
