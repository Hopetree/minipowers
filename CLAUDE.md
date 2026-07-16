# Minipowers — Agent Guidelines

This is a skills plugin repository providing practical utility skills for AI coding agents.

## Skills in this plugin

- `git-conventions` — Git 操作规范：Angular commit message 格式、分支命名、安全操作流程

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

Keep skills concise and focused. One skill = one task.

## Multi-platform support

This plugin targets multiple agent platforms via platform-specific config
directories (`.claude-plugin/`, `.cursor-plugin/`, `.codex-plugin/`,
`.kimi-plugin/`). All platforms share the same `skills/` directory.
