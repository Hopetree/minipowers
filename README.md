# Minipowers

> 小而精的 Agent Skills 插件合集，面向中文开发者。

Minipowers 是一个 AI 编程助手技能插件，每个技能聚焦一个常见开发任务。Skill 指令使用英文（方便 AI 理解），输出内容使用中文（面向中文用户）。

## 技能列表

### git-conventions

Git 操作规范技能。遵循 Angular commit message 格式、分支命名规范、标签管理及安全操作流程。用户说"提交"、"推送"、"创建分支"、"打标签"等时自动触发，直接执行无需反复确认。

### review-and-sync

代码审查 + 文档同步技能。审查 git 变更，生成面向 AI 的结构化 review 报告，分析哪些项目文档受影响，经用户确认后自动同步更新。支持 `--fix` 模式逐项修复 review 问题。

### bootstrapping-docs

项目文档初始化技能。评估项目规模，推荐需要创建的设计文档（PRD、TDD、ERD、API、SDD、项目计划），与用户协作逐一撰写。通过 `docs/review-state.json` 文档注册表与 review-and-sync 联动。

### bootstrapping-extension

浏览器插件项目初始化技能。基于 WXT + React + Tailwind CSS 标准技术栈，自动判断复杂度并选择图标方案（Emoji / Lucide），生成包含 CI/CD、Git Hooks、自动图标生成的完整项目模板。

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
cd minipowers

# 安装全部技能
make install-all

# 或安装指定技能
make install SKILL=git-conventions
make install SKILL=review-and-sync

# 查看可用技能
make list
```

技能将被复制到 `~/.claude/skills/` 目录，Claude Code 自动识别。

## 项目结构

```
minipowers/
├── .claude-plugin/              # Claude Code 插件配置
├── .cursor-plugin/              # Cursor 插件配置
├── .codex-plugin/               # Codex (OpenAI) 插件配置
├── .kimi-plugin/                # Kimi Code 插件配置
└── skills/
    ├── git-conventions/         # Git 操作规范
    ├── review-and-sync/         # 代码审查 + 文档同步
    ├── bootstrapping-docs/      # 项目文档初始化
    └── bootstrapping-extension/ # 浏览器插件初始化
```

## 文档生命周期

`bootstrapping-docs` 和 `review-and-sync` 协同工作，覆盖文档全生命周期：

1. **bootstrapping-docs** — 创建初始文档体系，注册到 `docs/review-state.json`
2. **review-and-sync** — 代码变更时审查差异，自动识别受影响的文档并同步更新

## 参与贡献

欢迎提交 PR 贡献新技能或改进现有技能。每个技能遵循 [Agent Skills specification](https://agentskills.io/specification)，跨平台通用。

## License

MIT — 详见 [LICENSE](LICENSE)。
