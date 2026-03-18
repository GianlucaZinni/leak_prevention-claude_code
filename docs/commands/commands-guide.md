# Commands Guide

Commands are the fastest way to turn repeated prompts into stable operational tools. In Claude Code, the command surface is broader than slash prompts alone: built-in commands shape the interactive session, custom command files package repeatable workflows, MCP prompts can appear as commands, keybindings reduce friction, and a status line can expose runtime context continuously.

<a id="index"></a>
## Index

- [Command Surface](#command-surface)
- [Built-In and Custom Commands](#built-in-and-custom-commands)
- [Authoring Model](#authoring-model)
- [Keybindings and Status Line](#keybindings-and-status-line)
- [Complete Example: Command Workbench](#complete-example-command-workbench)
- [Validation and Troubleshooting](#validation-and-troubleshooting)
- [Operational Checklist](#operational-checklist)

<a id="command-surface"></a>
## Command Surface

The command system has five practical layers:

| Layer | Purpose | Typical location |
| --- | --- | --- |
| Built-in slash commands | Session control, memory, permissions, model selection, diagnostics | Claude Code runtime |
| Project commands | Shared prompts versioned with a repository | `.claude/commands/` |
| User commands | Personal commands available across projects | `~/.claude/commands/` |
| MCP prompt commands | Commands exposed dynamically by connected MCP servers | Connected MCP servers |
| Supporting ergonomics | Faster invocation and better context visibility | `~/.claude/keybindings.json`, `.claude/settings.json`, helper scripts |

Built-in commands are for operating Claude Code itself. Custom commands are for operating your workflow. That distinction matters because it keeps project intent in files you can review and evolve instead of burying it in repeated chat messages.

<a id="built-in-and-custom-commands"></a>
## Built-In and Custom Commands

Built-in slash commands handle concerns such as session lifecycle, help, model changes, permissions, memory, MCP management, and diagnostics. They are part of the runtime and should be treated as control primitives rather than workflow definition files.

Custom commands are markdown files whose filename becomes the command name. They are the right tool when a team repeats the same review, release, or diagnostic flow often enough that the workflow deserves a stable interface. Project commands live with the repository so they can be reviewed and shared. User commands live in the home directory so they can remain personal without changing the repository.

MCP prompt commands extend the surface further. When an MCP server publishes prompts, Claude Code can expose them as slash commands. That makes MCP useful not only for tools but also for reusable operational prompts.

<a id="authoring-model"></a>
## Authoring Model

A command file is a markdown document with optional frontmatter plus the prompt body that Claude should execute. In practice, four features matter most.

| Feature | Why it matters | Typical use |
| --- | --- | --- |
| Frontmatter | Declares metadata, model choice, tool permissions, and argument hints | Keep command behavior explicit |
| `$ARGUMENTS` | Injects user-supplied values | PR numbers, version names, ticket IDs |
| `!` command execution | Pulls runtime context into the prompt before execution | `git status`, `git log`, `gh pr view` |
| `@` file references | Imports files or directories into command context | Review prompts, plans, specs, templates |

The authoring rule is simple: commands should narrow the task, not widen it. A good command clearly states its inputs, the context it loads, the tools it needs, and the shape of the result it should produce.

This pattern is especially important for commands that call shell tools. Shell execution is useful, but a command should request only the commands it actually needs. Overly broad `allowed-tools` turns a reusable prompt into an unbounded automation surface.

<a id="keybindings-and-status-line"></a>
## Keybindings and Status Line

Keybindings and status lines do not create new commands, but they make commands materially easier to use.

Keybindings reduce friction in the interactive loop. They are best used for actions that happen constantly: opening an external editor, searching history, switching modes, or showing transcript and todo state. The key principle is predictability. Use a small set of bindings that fit the team's operating rhythm rather than mirroring every editor shortcut.

Status lines provide passive context. A useful status line answers questions that otherwise force a context switch: which model is active, which directory is in focus, whether the current directory is a Git repository, and how much context window remains. A poor status line tries to display everything and becomes visual noise.

<a id="complete-example-command-workbench"></a>
## Complete Example: Command Workbench

This example builds a reusable command workbench for a repository that relies on structured review, release coordination, and security verification. It also adds a project status line and a user-level keybindings file so the command system is practical to use rather than merely defined on disk.

The same artifact is materialized under `docs/commands/example/command-workbench/`.

### What is being built

The workbench has two scopes:

- `project/` contains repository-scoped commands and status line configuration that every contributor can share.
- `user-home/` contains personal keybindings that make the interactive experience faster without polluting the repository.

The design keeps shared workflow in version control and personal ergonomics out of it.

### Directory structure

```text
command-workbench/
|-- README.md
|-- README.es.md
|-- project/
|   `-- .claude/
|       |-- commands/
|       |   |-- review-pr.md
|       |   |-- release/
|       |   |   `-- release-notes.md
|       |   `-- security/
|       |       `-- security-audit.md
|       |-- settings.json
|       `-- statusline.sh
`-- user-home/
    `-- .claude/
        `-- keybindings.json
```

### Creation order

1. Create `project/.claude/commands/` and its subdirectories.
2. Add the shared command files.
3. Add `project/.claude/statusline.sh`.
4. Register the status line in `project/.claude/settings.json`.
5. Add `user-home/.claude/keybindings.json`.
6. Add `README.md` so the bundle documents how to copy the files into a real environment.

### File-by-file guide

`README.md` explains the two scopes and the copy targets:

```md
# Command Workbench

This example separates shared repository commands from personal ergonomics.

- Copy `project/.claude/commands/` into your repository root.
- Copy `project/.claude/settings.json` and `project/.claude/statusline.sh` into the same repository-level `.claude/`.
- Copy `user-home/.claude/keybindings.json` into `~/.claude/keybindings.json`.

After copying, reopen Claude Code or trigger the relevant settings workflow so the runtime picks up the changes.
```

`project/.claude/commands/review-pr.md` creates a repository-scoped PR review command:

```md
---
description: Review a pull request and return structured findings.
argument-hint: [pr-number-or-url]
allowed-tools: Bash(gh pr view:*), Bash(git diff:*), Read, Grep, Glob
model: sonnet
---

# Review Pull Request

Use the pull request reference in `$ARGUMENTS`. If no argument is supplied, review the current branch diff against the default branch.

## Context

- Pull request metadata: !`gh pr view $ARGUMENTS --json title,body,files,additions,deletions`
- Current diff: !`git diff --stat`

## Task

Review the changes with emphasis on correctness, regressions, security, and missing tests.

## Output

Return:

1. Summary
2. Approval status
3. Critical findings
4. Important suggestions
5. Positive highlights
```

`project/.claude/commands/release/release-notes.md` generates release outputs from Git history:

```md
---
description: Generate release notes from commits and pull requests.
argument-hint: [version-or-range]
allowed-tools: Bash(git tag:*), Bash(git log:*), Bash(gh api:*), Read
model: sonnet
---

# Release Notes

Create three outputs for the release range identified by `$ARGUMENTS` or, if omitted, from the latest stable tag to `HEAD`.

## Context

- Latest stable tag: !`git tag --sort=-v:refname | head -n 1`
- Commit log: !`git log --oneline --no-merges -20`

## Task

Produce:

1. A changelog section
2. A release pull request body
3. A user-facing announcement

Separate user-facing changes from internal engineering work.
```

`project/.claude/commands/security/security-audit.md` packages a repeatable security review:

```md
---
description: Audit repository and Claude Code configuration for high-risk security issues.
allowed-tools: Bash(rg:*), Bash(grep:*), Bash(find:*), Read, Grep, Glob
model: sonnet
---

# Security Audit

Run a structured audit across repository contents and Claude Code configuration.

## Task

Check for:

- exposed credentials
- unsafe shell patterns
- weak configuration boundaries
- missing validation around critical entry points

## Output

Return findings grouped as:

1. Critical
2. High
3. Medium
4. Recommended next actions
```

`project/.claude/statusline.sh` surfaces the active model, current directory, Git branch, and context usage:

```bash
#!/bin/bash
set -euo pipefail

input="$(cat)"

model="$(printf '%s' "$input" | jq -r '.model.display_name')"
dir="$(printf '%s' "$input" | jq -r '.workspace.current_dir' | xargs basename)"
used="$(printf '%s' "$input" | jq -r '.context_window.used_percentage // 0')"

branch=""
if git rev-parse --git-dir >/dev/null 2>&1; then
  current_branch="$(git branch --show-current 2>/dev/null || true)"
  if [ -n "$current_branch" ]; then
    branch=" | ${current_branch}"
  fi
fi

printf '[%s] %s%s | ctx %s%%\n' "$model" "$dir" "$branch" "$used"
```

`project/.claude/settings.json` registers the status line:

```json
{
  "statusLine": {
    "type": "command",
    "command": ".claude/statusline.sh",
    "padding": 1
  }
}
```

`user-home/.claude/keybindings.json` adds practical shortcuts without changing repository state:

```json
{
  "$schema": "https://www.schemastore.org/claude-code-keybindings.json",
  "$docs": "https://code.claude.com/docs/en/keybindings",
  "bindings": [
    {
      "context": "Global",
      "bindings": {
        "ctrl+t": "app:toggleTodos",
        "ctrl+o": "app:toggleTranscript"
      }
    },
    {
      "context": "Chat",
      "bindings": {
        "ctrl+g": "chat:externalEditor",
        "ctrl+s": "chat:stash"
      }
    }
  ]
}
```

### Integration notes

- Repository-scoped files go under the target repository's `.claude/`.
- User-level keybindings go under the operator's home directory at `~/.claude/`.
- The status line script expects `jq` to be available.
- Command files should keep their directory structure if you want namespacing in help output.

### Execution notes

After copying the files into place:

1. Open Claude Code inside the repository.
2. Run `/help` and verify the custom commands appear.
3. Trigger the status line by changing conversation state or sending a message.
4. Press the configured shortcuts in the chat context.
5. Run one command such as `/review-pr 123` or `/release-notes`.

### Expected outcome

The repository gains stable workflow commands, the session shows useful passive context in the footer, and the operator has lightweight shortcuts for common interaction patterns.

<a id="validation-and-troubleshooting"></a>
## Validation and Troubleshooting

Validate the setup in this order:

1. Confirm command files live in the correct scope.
2. Open `/help` and verify the command names appear as expected.
3. Check that commands using shell context only request the tools they actually need.
4. Confirm the status line script prints exactly one line.
5. Verify the keybindings file uses valid contexts and actions.

If a command does not appear, the most common causes are a wrong directory, an invalid markdown filename, or malformed frontmatter. If the status line does not update, check the command path and make sure the script is executable in the target environment. If a keybinding is ignored, verify that the binding is assigned in the correct context.

<a id="operational-checklist"></a>
## Operational Checklist

- Keep command names short and outcome-oriented.
- Scope shell access tightly in frontmatter.
- Use commands for repeatable workflows, not one-off prompts.
- Keep repository commands in version control and personal bindings outside it.
- Make status lines informative, not noisy.
- Review command output shapes the same way you review any other interface contract.
