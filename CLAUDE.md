# Minipowers — Project Conventions

This is a skills plugin repository targeting Chinese-speaking developers. Skills are designed for AI coding agents (Claude Code, Cursor, Codex, Kimi Code, etc.).

---

## Language Policy

| Layer | Language | Rationale |
|-------|----------|-----------|
| SKILL.md instruction body | **English** | AI models comprehend English instructions more accurately |
| `references/` files | **English** (prose) + **Chinese** (templates/output) | AI reads prose; templates are what gets written to user projects |
| Skill description (frontmatter) | **English + Chinese keywords** | Both languages for trigger coverage |
| User-facing output (dialogs, generated docs) | **Chinese** | Target users are Chinese-speaking developers |
| README.md | **Chinese** | User-facing project documentation |

---

## Skill Naming Rules

- Use **gerund-based kebab-case** (e.g., `review-and-sync`, `bootstrapping-docs`), consistent with superpowers conventions
- **Must not conflict** with superpowers skill names: `brainstorming`, `dispatching-parallel-agents`, `executing-plans`, `finishing-a-development-branch`, `receiving-code-review`, `requesting-code-review`, `subagent-driven-development`, `systematic-debugging`, `test-driven-development`, `using-git-worktrees`, `using-superpowers`, `verification-before-completion`, `writing-plans`, `writing-skills`
- One skill = one task. Don't merge unrelated capabilities into one skill

---

## Skill Structure

```
skills/<skill-name>/
├── SKILL.md              # Required: YAML frontmatter + English instructions
└── references/           # Optional: templates, detailed guides, lookup tables
```

**SKILL.md frontmatter** follows the [agentskills.io specification](https://agentskills.io/specification):

| Field | Required | Constraint | Usage |
|-------|----------|------------|-------|
| `name` | ✅ | kebab-case | Unique skill identifier |
| `description` | ✅ | — | What it does + trigger keywords (English + Chinese) |
| `license` | Optional | — | License name (this project: `MIT`) |
| `compatibility` | Optional | ≤ 500 chars | Environment requirements |
| `metadata` | Optional | key-value map | Arbitrary properties per spec (see below) |
| `allowed-tools` | Optional | space-separated | Experimental — pre-approved tools |

**Our frontmatter convention**:
```yaml
---
name: skill-name
description: |
  English description with trigger keywords. Also triggers on Chinese
  keywords: 中文触发词1, 中文触发词2, ...
license: MIT
metadata:
  author: Hopetree
  version: "YY.MM.DD"
---
```

- `license: MIT` — always included; this project is MIT-licensed
- `metadata.author` — always `Hopetree`
- `metadata.version` — calver-style date (`YY.MM.DD`), updated when the skill changes
- `compatibility` — omit unless the skill has non-obvious system dependencies
- `allowed-tools` — omit unless the skill genuinely needs pre-authorized tools

**SKILL.md body guidelines**:
- Keep under 200 lines; move detailed content to `references/`
- Include both English and Chinese trigger examples in description
- User-facing output examples must be in Chinese

---

## Skills in this Plugin

- `git-conventions` — Git workflow conventions: commit message format (Angular spec), branch naming, tag management, safety guardrails, and common operations
- `review-and-sync` — Code review with automated document impact analysis; reviews git diffs, produces AI-oriented review reports, identifies affected project docs, and syncs them. Supports `--fix` mode
- `bootstrapping-docs` — Bootstrap project documentation; evaluates scope, recommends document set (PRD, TDD, ERD, API, SDD, Project Plan), and collaboratively writes each document with user input
- `bootstrapping-extension` — Bootstrap a browser extension project with WXT + React + Tailwind CSS; auto-determines complexity level and icon strategy (Emoji vs Lucide), generates complete project with CI/CD, Git Hooks, and icon generation

### Document Lifecycle

`bootstrapping-docs` and `review-and-sync` share `docs/review-state.json`:
1. **bootstrapping-docs** — creates the initial document set and registers them
2. **review-and-sync** — reviews code changes and keeps registered documents in sync

---

## Multi-Platform Support

Platform config directories:
- `.claude-plugin/plugin.json` + `marketplace.json` — Claude Code
- `.cursor-plugin/plugin.json` — Cursor
- `.codex-plugin/plugin.json` — Codex (OpenAI)
- `.kimi-plugin/plugin.json` — Kimi Code

All platforms share the same `skills/` directory. When adding a new platform, create the config directory and point `skills` to `./skills/`.

---

## Git Conventions

This project follows its own `git-conventions` skill.

**🚫 CRITICAL: Never commit, push, or create a PR without an explicit user instruction.**
After making changes, stop and wait. No automatic git operations. Ever.

When explicitly instructed to commit:
- Commit messages follow Angular format: `<type>(<scope>): <subject>`
- Branch naming: `<type>/<description>` (e.g., `feat/new-skill`)
- No AI attribution in commit messages
- Push to `main` via SSH: `git@github.com:Hopetree/minipowers.git`
