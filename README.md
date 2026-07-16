# Minipowers

> 小而美的 Agent Skills 插件集合。

Minipowers 是一个为 AI 编程助手提供实用技能的插件。每个技能聚焦解决一个常见的开发任务，小而精。

## 技能

### git-conventions

Git 操作规范技能。自动遵循 Angular commit message 格式、分支命名规范和安全操作流程。当用户说"提交代码"、"推送"、"创建分支"等时自动触发，直接执行无需反复确认。

## 安装

### Claude Code

```
/plugin install github.com/Hopetree/minipowers
```

### Cursor

在 Cursor 设置中添加插件仓库 `github.com/Hopetree/minipowers`。

### Codex (OpenAI)

通过 Codex 插件市场安装，或在设置中添加仓库地址。

### Kimi Code

通过 Kimi Code 插件系统安装，仓库地址 `github.com/Hopetree/minipowers`。

### 手动安装

```bash
git clone https://github.com/Hopetree/minipowers.git
# 然后在你的 agent 平台中配置 skills 路径指向 skills/ 目录
```

## 项目结构

```
minipowers/
├── .claude-plugin/          # Claude Code 插件配置
├── .cursor-plugin/          # Cursor 插件配置
├── .codex-plugin/           # Codex (OpenAI) 插件配置
├── .kimi-plugin/            # Kimi Code 插件配置
└── skills/
    └── git-conventions/     # Git 操作规范
```

## 参与贡献

欢迎提交 PR 贡献新技能或改进现有技能。

每个技能遵循 [Agent Skills specification](https://agentskills.io/specification) 规范，跨平台通用。

## License

MIT — 详见 [LICENSE](LICENSE)。
