# Minipowers — Agent Guidelines

This is a skills plugin repository providing practical utility skills for AI coding agents.

## Skills in this plugin

- `git-conventions` — Git workflow conventions: commit message format (Angular spec), branch naming, tag management, safety guardrails, and common operations
- `reviewing-changes` — Code review with automated document impact analysis; reviews git diffs, produces AI-oriented review reports, identifies affected project docs, and syncs them
- `bootstrapping-docs` — Bootstrap project documentation; evaluates scope, recommends document set (PRD, TDD, ERD, API, SDD, Project Plan), and collaboratively writes each document with user input

### Document Lifecycle

`bootstrapping-docs` and `reviewing-changes` share a document registry at `docs/review-state.json`:

- **bootstrapping-docs** creates the initial document set and registers each document
- **reviewing-changes** keeps registered documents in sync as code changes

## When contributing skills

Each skill is a directory under `skills/` with a `SKILL.md` file. The
SKILL.md format follows the Agent Skills specification:

```yaml
---
name: skill-name
description: What it does and when to use it
---
# Instructions
```

Keep skills concise and focused. One skill = one task. If a skill grows beyond 200 lines, split detailed reference material into `references/` files.

## Multi-platform support

This plugin targets multiple agent platforms via platform-specific config
directories (`.claude-plugin/`, `.cursor-plugin/`, `.codex-plugin/`,
`.kimi-plugin/`). All platforms share the same `skills/` directory.
