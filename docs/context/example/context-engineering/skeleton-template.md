# CLAUDE.md - [Project Name]

## Project Overview

[PROJECT DESCRIPTION]

## Architecture

### Stack

| Layer | Technology | Version |
|---|---|---|
| Language | TypeScript | 5.x |
| Runtime | Node.js | 20.x |
| Framework | [Framework] | x.x |
| Database | [Database] | x.x |
| Testing | [Testing] | x.x |

### Folder Structure

```text
src/
  api/        route handlers only
  services/   business logic
  db/         persistence and queries
```

### Key Decisions

- [DECISION 1]
- [DECISION 2]

## Code Standards

### TypeScript

- Strict mode is enabled.
- Never use `any`.
- Public functions must declare return types.

### Naming

- Files: `kebab-case.ts`
- Classes: `PascalCase`
- Functions and variables: `camelCase`
- Constants: `SCREAMING_SNAKE_CASE`

### Error Handling

- [ERROR HANDLING RULES]

### Comments

- [COMMENT RULES]

## Development Workflow

### Git Conventions

- Branches: `[type]/[short-description]`
- Commits: Conventional Commits
- Commits should be atomic

### PR Requirements

- [PR RULES]

### Local Setup

```bash
[INSTALL COMMAND]
[SETUP COMMAND]
[DEV COMMAND]
```

## Testing

### Framework and Location

- Framework: [Framework]
- Test files: colocated with source or in `__tests__/`
- Run tests: [TEST COMMAND]

### What Requires Tests

- [TEST REQUIREMENTS]

### Mocking

- [MOCKING CONVENTIONS]

## Deployment

### Environments

| Environment | Branch | URL | Notes |
|---|---|---|---|
| Local | any | localhost:[PORT] | |
| Staging | main | [STAGING URL] | Auto-deploys |
| Production | [TAG/BRANCH] | [PROD URL] | Manual trigger |

### Deploy

```bash
[DEPLOY COMMAND]
```

### Post-Deploy Checks

- [POST-DEPLOY CHECKS]

## What Claude Should Not Do

### Technologies Not in Use

- Do not suggest GraphQL if REST is the project standard.
- Do not use libraries that were explicitly replaced.

### Patterns to Avoid

- [ANTI-PATTERN 1]
- [ANTI-PATTERN 2]
- [ANTI-PATTERN 3]

### Known Problem Areas

- [KNOWN PROBLEM AREA 1]
- [KNOWN PROBLEM AREA 2]

