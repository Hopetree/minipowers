# WXT Configuration Guide

## wxt.config.ts Reference

```typescript
import { defineConfig } from 'wxt';

export default defineConfig({
  // Extension modules
  modules: ['@wxt-dev/module-react'],

  // Output directory
  outDir: 'dist',
  outDirTemplate: '<package-name>',      // build subdirectory, matches package.json name

  // Manifest configuration
  manifest: {
    name: 'Extension Name',               // max 45 chars
    description: 'Extension description', // max 132 chars
    version: '0.0.1',                     // managed by git tag — do not edit manually

    // Permissions — follow principle of least privilege
    permissions: [
      // 'storage',          // Local storage
      // 'activeTab',        // Access current tab
      // 'tabs',             // Tabs API
      // 'scripting',        // Script injection
      // 'contextMenus',     // Context menu
      // 'sidePanel',        // Side panel
      // 'alarms',           // Scheduled tasks
      // 'notifications',    // System notifications
      // 'webRequest',       // Intercept/modify network requests
      // 'cookies',          // Cookie operations
    ],

    // Host permissions — follow principle of least privilege
    host_permissions: [
      // 'https://example.com/*',
      // '<all_urls>',       // Avoid unless absolutely necessary
    ],

    // Background script config
    background: {
      // Defaults to service_worker (MV3)
    },

    // Browser compatibility
    browser_specific_settings: {
      gecko: {
        id: 'your-extension@example.com',  // Required for Firefox
      },
    },

    // Icons (in public/icons/ directory)
    icons: {
      16: 'icons/icon-16.png',
      48: 'icons/icon-48.png',
      128: 'icons/icon-128.png',
    },

    // Default locale
    default_locale: 'zh_CN',

    // Web-accessible resources
    // web_accessible_resources: [
    //   {
    //     resources: ['injected.js'],
    //     matches: ['<all_urls>'],
    //   },
    // ],
  },

  // Build configuration
  // Reference: https://wxt.dev/api/config.html
});
```

## Entry Point Types

| Entry | Directory | Description |
|-------|-----------|-------------|
| Popup | `src/entrypoints/popup/` | Toolbar popup on icon click |
| Options | `src/entrypoints/options/` | Full-tab settings page |
| Content Script | `src/entrypoints/content/` | Scripts injected into web pages |
| Background | `src/entrypoints/background.ts` | Service worker background script |
| Side Panel | `src/entrypoints/sidepanel/` | Side panel |
| DevTools | `src/entrypoints/devtools/` | Developer tools panel |
| New Tab | `src/entrypoints/newtab/` | New tab override |

## Key Notes

### Permissions
- **Least privilege**: only declare permissions actually used
- Chrome Web Store rejects or delays extensions with unnecessary permissions
- `activeTab` is preferred over `<all_urls>` (only active when user clicks the extension)
- Add permissions as needed during development; clean up before store submission

### Version Management
- **Do not manually edit the version field**
- Release via `git tag v1.2.3 && git push --follow-tags`
- The Release workflow auto-syncs version to package.json

### Icons
- PNG format required
- 16×16, 48×48, 128×128 sizes included as placeholders in the template
- Replace with actual icons before development
