# Code Review Report Template

> Format specification for `docs/code-review.md`. Designed for AI consumption — every issue includes exact location and fix code for direct application.

---

## Template

```markdown
# Code Review Report

**Scope**: <commit_start> → <commit_end>
**Date**: YYYY-MM-DD
**Files Changed**: N

---

## Issue Overview

| # | Priority | File | Location | Summary | Status |
|---|----------|------|----------|---------|--------|
| 1 | 🔴 Must Fix | `path/to/file.js` | L42 | One-line description | ⏳ Pending |
| 2 | 🔴 Must Fix | `path/to/file.js` | L88 | One-line description | ⏳ Pending |
| 3 | 🟡 Should Improve | `path/to/file.js` | L120 | One-line description | ⏳ Pending |
| 4 | 🟢 Nice to Have | `path/to/file.js` | L200 | One-line description | ⏳ Pending |

---

## Issue Details

### 🔴 Must Fix

#### 1. <One-line issue summary>

- **File**: `path/to/file.js`
- **Location**: Line XX–XX
- **Problem**: What's wrong with the current code and why it causes errors or risk
- **Current Code**:
  ```js
  // The problematic code (keep enough context — 2-3 lines around)
  ```
- **Fix To**:
  ```js
  // The corrected code
  ```
- **Fix Notes**: Why this fix works; things to watch for (other callers affected, tests to update, etc.)

#### 2. <One-line issue summary>

(Same format)

---

### 🟡 Should Improve

#### 3. <One-line suggestion>

(Same format)

---

### 🟢 Nice to Have

#### 4. <One-line optimization>

(Same format)
```

---

## Writing Rules

### Issue Overview Table

- Sort by priority: 🔴 Must Fix → 🟡 Should Improve → 🟢 Nice to Have
- Within each priority, sort by severity (most severe first)
- `Location` uses `L<line>` format: `L42` or `L88-95`
- `Summary` is one line, max 10 words

### Issue Details

- Each issue number matches the overview table `#` exactly
- **Current Code**: keep enough context (2-3 lines around the issue); use `// ...` for omitted sections
- **Fix To**: provide complete, copy-paste-ready replacement code
- **Fix Notes**: explain why this change, and whether other files need updating (tests, config, callers)
- If multiple issues in the same file are related, cross-reference the issue numbers in fix notes

### File Maintenance

`docs/code-review.md` tracks issue progress via the Status column:

**On review create/update**:
- If the file exists, first check existing issue statuses
- Remove old issues marked `✅ Fixed` or `⏭️ Skipped`
- Keep old issues marked `⏳ Pending`
- Append new issues with sequential numbering

**On --fix apply**:
- After fixing, update the overview table status from `⏳ Pending` to `✅ Fixed`
- **Also delete the issue detail section** (details kept only for pending issues)
- The overview table always stays complete as a processing record
