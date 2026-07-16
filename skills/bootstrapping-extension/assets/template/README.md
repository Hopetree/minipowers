# {{EXTENSION_NAME}}

{{EXTENSION_DESCRIPTION}}

## 技术栈

- **框架**: [WXT](https://wxt.dev) — 下一代浏览器扩展开发框架
- **前端**: React 18 + TypeScript
- **样式**: Tailwind CSS 4
- **图标**: {{ICON_MODE_CN}}
- **测试**: Vitest
- **CI/CD**: GitHub Actions

## 快速开始

### 环境要求

- Node.js >= 20

### 开发

```bash
# 安装依赖
npm install

# 启动开发模式（Chrome）
npm run dev

# 启动开发模式（Firefox）
npm run dev:firefox
```

### 加载扩展

1. 打开 `chrome://extensions/`
2. 开启「开发者模式」
3. 点击「加载已解压的扩展程序」
4. 选择 `dist/{{PACKAGE_NAME}}` 目录

### 构建

```bash
# 生产构建
npm run build

# 打包为 .zip
npm run zip
```

### 图标

项目已包含根据插件功能自动生成的图标，无需额外配置。

如需修改图标，编辑 `public/icons/icon.svg` 后运行：

```bash
npm run generate-icons
```

该脚本会自动生成 16×16、48×48、128×128 三种 PNG。

### 代码质量

```bash
npm run type-check   # TypeScript 类型检查
npm run lint         # ESLint 检查
npm run format       # Prettier 格式化
npm run test         # 运行测试
```

### 发布新版本

1. 切换到 main 分支并拉取最新代码
2. 打 tag：`git tag v1.0.0`
3. 推送 tag：`git push --follow-tags`
4. GitHub Actions 自动构建并发布到 Release

> Tag 版本即为扩展版本号，无需手动修改 `package.json` 或 `wxt.config.ts`。

## 项目结构

```
public/
│   └── icons/           # 插件图标
│       ├── icon.svg     # 图标源文件（修改后运行 generate-icons）
│       ├── icon-16.png
│       ├── icon-48.png
│       └── icon-128.png
scripts/
│   └── generate-icons.mjs  # SVG → PNG 图标生成脚本
src/
├── entrypoints/       # WXT 入口
│   ├── popup/         # Popup 页面
│   │   ├── App.tsx
│   │   ├── main.tsx
│   │   └── index.html
│   └── background.ts  # Background Script
├── components/        # React 组件
├── assets/            # 静态资源
├── lib/               # 工具函数
└── styles/            # 全局样式
    └── globals.css
```
