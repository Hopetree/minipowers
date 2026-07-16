# Tech Stack Reference

## Version Constraints

| Package | Version | Notes |
|---------|---------|-------|
| wxt | ^0.19.0 | Browser extension framework |
| react | ^18.3.0 | UI framework |
| typescript | ^5.5.0 | Type system |
| tailwindcss | ^3.4.0 | CSS framework |
| lucide-react | ^0.400.0 | Icon library (complex extensions only) |
| vitest | ^2.0.0 | Test framework |
| eslint | ^9.0.0 | Linter |
| prettier | ^3.3.0 | Formatter |
| husky | ^9.0.0 | Git hooks manager |
| npm | >= 10 | Package manager |

## Why WXT

| Dimension | WXT | Plasmo | Vanilla MV3 |
|-----------|-----|--------|-------------|
| Learning curve | Medium | Medium | High |
| Dev experience | Excellent (HMR) | Excellent | Average |
| Framework support | React/Vue/Svelte/Vanilla | React | Any |
| Community | Active | Active | N/A |
| Bundler | Vite | Parcel | Custom |
| Multi-browser | Built-in | Built-in | Manual |

Reasons for choosing WXT:
1. Vite-based — ecosystem aligned with Vitest test framework
2. Multi-framework support, not locked into a specific UI library
3. Good HMR dev experience
4. Built-in `.zip` packaging for CI/CD

## Why Tailwind CSS v3

- v3 ecosystem is mature; more WXT community examples and tutorials
- PostCSS config approach consistent with most projects
- v4 has many breaking changes; community configs still catching up

## Why Lucide

- 1000+ icons, covers most use cases
- Tree-shakeable — no bundle bloat
- Modern, consistent style
- Mature React support

## Icon Strategy Criteria

**Use Emoji (simple extensions)**:
- Single Popup page only
- Minimal UI (plain text, single toggle button)
- No lists, tables, menus, or complex components
- Total components < 5

**Use Lucide (complex extensions)**:
- 2+ pages (Popup + Options, etc.)
- Content Script injection
- Needs lists, tables, menus, navigation components
- Total components >= 5

> When ambiguous, default to Emoji (keep it simple). User can override.
