import { defineConfig } from 'wxt';

// See https://wxt.dev/api/config.html
export default defineConfig({
  outDir: 'dist',
  outDirTemplate: '{{PACKAGE_NAME}}',
  modules: ['@wxt-dev/module-react'],
  manifest: {
    name: '{{EXTENSION_NAME}}',
    description: '{{EXTENSION_DESCRIPTION}}',
    permissions: [],
    host_permissions: [],
    icons: {
      16: 'icons/icon-16.png',
      48: 'icons/icon-48.png',
      128: 'icons/icon-128.png',
    },
    // 根据实际需求添加权限，按最小权限原则
    // 常用权限示例：
    //   storage — 本地存储
    //   activeTab — 访问当前标签页
    //   tabs — 访问标签页信息
    //   scripting — 注入脚本
    //   contextMenus — 右键菜单
    //   sidePanel — 侧边栏
    // 文档: https://developer.chrome.com/docs/extensions/reference/manifest/permissions
  },
});
