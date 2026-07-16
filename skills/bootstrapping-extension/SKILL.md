---
name: bootstrapping-extension
description: |
  Bootstrap a browser extension project with WXT + React + Tailwind CSS. Use when the user says "create a browser extension", "build a Chrome extension", "initialize an extension project", "set up a WXT project", or mentions browser extension development. Also triggers on Chinese keywords: 创建浏览器插件, 新建浏览器扩展, 初始化插件项目, 写一个 Chrome 扩展, 浏览器插件开发, WXT 项目初始化, 浏览器插件脚手架.
license: MIT
metadata:
  author: Hopetree
  version: "26.07.17"
---

# Bootstrapping a Browser Extension

## Core Principles

- **Standardized stack**: all generated extension projects use a unified tech stack and engineering conventions — consistent code style, CI/CD, and icon approach
- **Unified icons**: simple extensions use emoji icons; complex extensions use Lucide icon library. **The two must not be mixed**
- **Single source of truth for version**: Git tag = extension version = package.json version = manifest version. Tags drive automatic sync

---

## Workflow

### Phase 1: Understand Requirements

Ask the user one question at a time:

1. **Extension name**: name for package.json and manifest
2. **Feature description**: 2-3 sentences describing what the extension does
3. **Feature modules** (multi-select):
   - Popup (toolbar popup on icon click)
   - Options (settings page, right-click icon → Options)
   - Content Script (scripts injected into pages)
   - Context Menu (right-click menu items)
   - Side Panel (side panel, Chrome 114+)
   - DevTools (developer tools panel)

### Phase 2: Determine Complexity & Icon Strategy

Based on the number of feature modules:

| Condition | Complexity | Icon Strategy |
|-----------|-----------|---------------|
| Popup only + minimal interaction (text display, single button) | Simple | **Emoji** |
| 2+ pages, or multiple components/states | Complex | **Lucide + Lucide React** |

**Confirm with the user before proceeding**:

```
根据您的描述，这个插件属于 [简单/复杂] 类型：
- 原因：xxx
- 图标方案建议：使用 [Emoji / Lucide 图标库]

是否同意？如需调整请说明。
```

### Phase 3: Confirm and Generate

Summarize all confirmed details:

```
即将创建插件项目，确认以下信息：

| 项目 | 内容 |
|------|------|
| 插件名称 | xxx |
| 复杂度 | 简单 / 复杂 |
| 图标方案 | Emoji / Lucide |
| 功能模块 | Popup, Options, Content Script |

确认后开始生成？
```

### Phase 4: Generate Project Files

Copy the standard template from `assets/template/` and perform variable substitution.

#### 4.1 Copy Template

```bash
cp -r <skill-dir>/assets/template/ <target-project-dir>/
```

#### 4.2 Variable Substitution

Replace these placeholders in the copied files:

| Placeholder | Replace with | Example |
|-------------|-------------|---------|
| `{{EXTENSION_NAME}}` | Extension display name | "My Tool" |
| `{{EXTENSION_DESCRIPTION}}` | Extension description | "A productivity browser tool" |
| `{{PACKAGE_NAME}}` | Lowercase hyphenated package name | "my-tool" |
| `{{EXTENSION_VERSION}}` | Initial version | "0.0.1" |
| `{{ICON_MODE}}` | `emoji` or `lucide` (for conditional logic) | "emoji" |
| `{{ICON_MODE_CN}}` | Chinese display name for icon strategy | "Emoji" or "Lucide 图标库" |

**Template conditional syntax**: The `App.tsx` file uses `{{#if emoji}}` / `{{else}}` / `{{/if}}` blocks to mark which code to keep per icon strategy. Read the file, identify the block matching `{{ICON_MODE}}`, keep that block and delete the other.

**Files to substitute**:
- `package.json` — `{{PACKAGE_NAME}}`, `{{EXTENSION_VERSION}}`, `{{EXTENSION_DESCRIPTION}}`
- `wxt.config.ts` — `{{EXTENSION_NAME}}`, `{{EXTENSION_DESCRIPTION}}`, `{{PACKAGE_NAME}}`
- `README.md` — `{{EXTENSION_NAME}}`, `{{EXTENSION_DESCRIPTION}}`, `{{PACKAGE_NAME}}`, `{{ICON_MODE_CN}}`
- `src/entrypoints/popup/App.tsx` — `{{EXTENSION_NAME}}`, `{{EXTENSION_DESCRIPTION}}`; use `{{ICON_MODE}}` to select the correct conditional block via `{{#if emoji}}`/`{{else}}`/`{{/if}}`
- `.github/workflows/ci.yml` — no substitution needed
- `.github/workflows/release.yml` — no substitution needed

#### 4.3 Icon Strategy

Apply based on Phase 2 decision:

**Emoji mode**:
- Remove `lucide-react` from `package.json` dependencies
- Keep emoji code block in `App.tsx` (delete Lucide block)

**Lucide mode**:
- Keep `lucide-react` dependency
- Keep Lucide code block in `App.tsx` (delete emoji block)

#### 4.4 Install Dependencies

```bash
cd <target-project-dir>
npm install
```

#### 4.5 Auto-Generate Extension Icons

**This step is performed automatically by the skill.**

Design and generate extension icons based on the feature description:

1. **Design `icon.svg`**: create a simple SVG icon at `public/icons/icon.svg`
   - Solid background + high-contrast foreground
   - Must be recognizable at 16×16
   - Avoid excessive detail
   - 128×128 SVG with rounded-rect background

2. **Generate PNGs**: run the `generate-icons` script to produce 16/48/128 sizes

   ```bash
   cd <target-project-dir>
   node scripts/generate-icons.mjs
   ```

#### 4.6 Initialize Git

```bash
cd <target-project-dir>
git init
git add -A
git commit -m "chore(init): initialize browser extension {{EXTENSION_NAME}}

WXT + React + Tailwind CSS
Icon strategy: {{ICON_MODE}}"
```

#### 4.7 Initialize Husky

```bash
cd <target-project-dir>
npx husky init
```

---

### Phase 5: GitHub Setup

After generation, guide the user:

1. **Create a GitHub repo** (if not already done)
2. **Push code**:
   ```bash
   git remote add origin <repo-url>
   git push -u origin main
   ```
3. **Configure Actions permissions**: ensure repo Settings → Actions → General → "Read and write permissions" is enabled
4. **Configure Workflow permissions**: ensure "Allow GitHub Actions to create and approve pull requests" is enabled (required for Release workflow auto-PR)

---

### Phase 6: Usage Instructions

After project generation:

```
✅ 项目已生成！

## 日常开发
npm run dev            # 启动开发模式（热重载）
npm run build          # 生产构建
npm run zip            # 打包为 .zip

## 代码检查
npm run type-check     # TypeScript 类型检查
npm run lint           # ESLint 检查
npm run format         # Prettier 自动格式化
npm run test           # 运行测试

## 更新图标
npm run generate-icons # 修改 public/icons/icon.svg 后重新生成 PNG

## 发布新版本
1. git checkout main && git pull
2. npm version patch/minor/major   # 或手动打 tag
3. git push --follow-tags
4. GitHub Actions 自动构建并发布到 Release

## 加载到浏览器
1. 打开 chrome://extensions/
2. 开启「开发者模式」
3. 点击「加载已解压的扩展程序」
4. 选择项目的 dist/<扩展包名> 目录
```

---

## Icon Strategy Switching

If the user wants to switch icon strategies after project creation:

**From Emoji to Lucide**:
1. `npm install lucide-react`
2. Replace emoji characters with corresponding `<Icon>` components
3. Ensure no mixed emoji + Lucide usage

**From Lucide to Emoji**:
1. `npm uninstall lucide-react`
2. Remove `import { X } from 'lucide-react'` references
3. Replace `<XIcon />` with corresponding emoji characters
4. Clean up imports

---

## Notes

- **No mixed icons**: a single extension must use either emoji OR Lucide, never both
- **Don't manually edit version numbers**: versions are managed automatically via git tags
- **Check GitHub Actions after first push**: ensure CI and Release workflows run correctly
- **WXT version**: the template uses the latest stable WXT; confirm with user if a specific version is needed
- All generated config files can be adjusted later — the skill only initializes the standard template

---

## References

- Tech stack details: `references/tech-stack.md`
- WXT configuration guide: `references/wxt-config-guide.md`
