# Minipowers

> Small skills, big impact. A collection of practical utility skills for AI coding agents.

Minipowers is a skills plugin that adds handy capabilities to your AI coding agent. Each skill is small, focused, and designed to solve one common development task well.

## Skills

### git-conventions

Git workflow conventions — commit message format (Angular spec), branch naming, tag management, safety guardrails, and common operations. Triggers on any git command (commit, push, branch, merge, tag, etc.) and executes directly without asking for confirmation.

### reviewing-changes

Code review with automated document impact analysis. Reviews git diffs, produces a structured AI-oriented review report, identifies which project documents need updating based on the changed files, and syncs them with user confirmation. Also supports `--fix` mode to apply review findings item by item.

### bootstrapping-docs

Bootstrap project documentation. Evaluates project scope, recommends which design documents are needed (PRD, TDD, ERD, API, SDD, Project Plan), then collaboratively writes each one with user input. Integrates with `docs/review-state.json` document registry for ongoing sync.

## Installation

### Claude Code

```
/plugin install github.com/Hopetree/minipowers
```

### Cursor

Add `github.com/Hopetree/minipowers` as a plugin repository in Cursor settings.

### Codex (OpenAI)

Install via the Codex plugin marketplace, or add the repository URL in Codex settings.

### Kimi Code

Install via the Kimi Code plugin system with the repository URL `github.com/Hopetree/minipowers`.

### Manual

```bash
git clone https://github.com/Hopetree/minipowers.git
# Then configure your agent platform to load skills from the skills/ directory
```

## Project Structure

```
minipowers/
├── .claude-plugin/              # Claude Code plugin config
├── .cursor-plugin/              # Cursor plugin config
├── .codex-plugin/               # Codex (OpenAI) plugin config
├── .kimi-plugin/                # Kimi Code plugin config
└── skills/
    ├── git-conventions/         # Git workflow conventions
    ├── reviewing-changes/       # Code review + doc impact sync
    └── bootstrapping-docs/      # Project documentation bootstrap
```

## Document Lifecycle

`reviewing-changes` and `bootstrapping-docs` work together:

1. **bootstrapping-docs** — creates the initial document set and registers them in `docs/review-state.json`
2. **reviewing-changes** — reviews code changes and keeps registered documents in sync as the project evolves

## Contributing

Contributions are welcome! Feel free to submit PRs for new skills or improvements to existing ones.

Each skill follows the [Agent Skills specification](https://agentskills.io/specification). Skills are platform-agnostic — write once, work everywhere.

## License

MIT — see [LICENSE](LICENSE) for details.
