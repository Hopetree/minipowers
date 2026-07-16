---
name: review-and-sync
description: |
  Review code changes from git diffs and sync affected project documentation. Use when the user says "review my code", "review recent commits", "check my changes and update docs", "review the PR", "code review", or mentions checking a commit range. This skill reads git diffs, produces a structured review report, analyzes which project documents are affected by the changes, and updates them with user confirmation. Also supports `--fix` mode to read an existing review report and apply fixes item by item.
---

# Reviewing Changes

## Core Principles

- **Review output only — do not modify code files** (except in `--fix` mode)
- Document updates require user confirmation before writing
- Cross-session state tracked via `docs/review-state.json`

---

## Workflow

### Step 1: Determine Review Scope

**Read the state file** (tracks last review position):
```bash
cat docs/review-state.json 2>/dev/null || echo "First review"
```

**Get recent commits**:
```bash
git log --oneline -20
```

Determine scope based on these rules:

| Scenario | Default behavior |
|----------|-----------------|
| State file exists | From `last_reviewed_commit` to HEAD |
| No state file (first review) | Ask user; default to last 1 commit |
| User specifies range | Use user's specification (e.g., "last 3 commits", "from abc123") |

Confirm the scope with the user before proceeding.

**Get the diff**:
```bash
# Specific commit range
git diff <start_commit> <end_commit>

# From last review to now
git diff <last_reviewed_commit> HEAD

# Last N commits
git diff HEAD~N HEAD

# Changed file list
git diff --name-status <start> <end>
```

---

### Step 2: Code Review

Perform a standard review against the diff. **Output findings only — do not modify code.**

Review dimensions:

**Code Quality**
- Correctness: logic errors, missing edge cases
- Readability: naming clarity, single-responsibility functions
- Duplication: extractable/reusable logic
- Error handling: exceptions and errors properly handled

**Code Standards**
- Naming consistency with project conventions
- Adequate comments on complex logic
- Reasonable function/class length
- No leftover debug code or temporary comments

**Potential Risks**
- Security: SQL injection, XSS, hardcoded secrets
- Performance: N+1 queries, unnecessary loops, large data handling
- Concurrency: shared state, race conditions

**Write review report to `docs/code-review.md`**:

Report format is AI-oriented — every issue includes exact file location and fix code. Ask user to confirm the output path (defaults to `docs/code-review.md`).

See `references/review-template.md` for the detailed format. Core structure:

1. **Issue overview table** — all issues sorted by priority (🔴 Must Fix → 🟡 Should Improve → 🟢 Nice to Have) with number, priority, file, line, summary
2. **Issue details** — one section per issue: current code, fix code, fix notes

**Output rules**:
- Only list issues — no highlights, overall assessments, or praise
- Overview table sorted by priority, then severity within each priority
- Every issue must include **Current Code** and **Fix To** code blocks for direct AI comparison
- Location must be precise (e.g., `L42` or `L88-95`)
- If the report file already exists, remove old issues marked `✅` or `⏭️`, keep `⏳` issues, append new issues with sequential numbering
- After output, ask: "Review report written to docs/code-review.md. Continue with document impact analysis?"

---

### Step 3: Load Document Registry

Read the document registry from the state file (already loaded in Step 1; use the `documents` field directly).

**Three scenarios:**

#### Scenario A: Registry exists with documents
Use the registered document list directly. Show the user:

```
Current project documents (from registry):
- docs/design/01_PRD_product_requirements.md — Product requirements
- docs/design/03_ERD_database_design.md — Database design
- README.md — Project overview
```

Verify each registered file still exists:
```bash
ls <path> 2>/dev/null || echo "NOT_FOUND: <path>"
```

If any are missing, alert the user and offer to remove from registry.

#### Scenario B: Registry missing or `documents` field is empty
Ask the user how to proceed:

```
No document registry found (or registry has no documents).

Options:
1. Scan the project for all .md files and build a registry
2. Manually specify document paths to register

Which would you prefer?
```

**Option 1 — Full scan and register**:
```bash
find . -name "*.md" \
  -not -path "*/node_modules/*" \
  -not -path "*/.git/*" \
  -not -path "*/vendor/*" \
  -not -path "*/dist/*" \
  -not -path "*/build/*" \
  | sort
```

List results, let user confirm which to register, collect `type` and `description` for each, write to `docs/review-state.json`.

**Option 2 — Manual specification**:
User provides paths; confirm `type` and `description` for each; write to registry.

#### Scenario C: User requests rescan or add documents
Trigger words: "rescan docs", "update doc list", "add document <path>", "register doc".

- **Rescan**: Run Scenario B Option 1; merge results with existing registry (keep existing, ask about new)
- **Add specific doc**: Append user-provided path to `documents` array with `type` and `description`

---

### Step 4: Analyze Document Impact

Compare changed files against the registry using each document's `type`:

| Code change | Detection | Likely affected docs |
|------------|-----------|---------------------|
| New/modified API routes, controllers | Path contains `route`, `controller`, `handler`, `api` | API docs |
| Modified DB models, migrations, schemas | Path contains `model`, `migration`, `schema`, `entity` | ERD |
| New modules, restructured directories | New directories, large file moves | Architecture, detailed design |
| Modified core business logic, services | Path contains `service`, `logic`, `domain` | Detailed design |
| Modified config, deployment files | `Dockerfile`, `docker-compose`, `nginx.conf`, `.env.example` | Architecture |
| Feature milestone complete | Commit message contains `feat` | Project plan |
| Modified auth/permission logic | Path contains `auth`, `permission`, `middleware` | API docs (auth section) |

**Output format**:

```
## Document Impact Analysis

Based on this change set, the following documents need updates:

### Documents Requiring Updates

📄 **docs/design/04_API_reference.md**
- Reason: new /users/profile endpoint added
- Suggested update: add request/response spec for this endpoint

📄 **docs/design/03_ERD_database_design.md**
- Reason: users table gained an avatar_url column
- Suggested update: add avatar_url to the users table field spec

### Documents NOT Affected
- docs/design/01_PRD_product_requirements.md — no feature changes
- README.md — no relevant changes
```

If a change relates to a document type that doesn't exist, flag it:
```
⚠️ API changes detected but no API document found in the project.
Consider running the bootstrapping-docs skill to create one.
```

---

### Step 5: Confirm and Update Documents

For each document needing updates:

1. Show the proposed update (diff or description of what to add/change)
2. Ask the user to confirm
3. Write the update on approval
4. Append a changelog entry at the end of the document:

```markdown
| v1.x | YYYY-MM-DD | Updated per commit <hash>: summary of change |
```

---

### Step 6: Update State File

Update `docs/review-state.json` — **preserve the `documents` field intact**, only update review fields:

```json
{
  "last_reviewed_commit": "<full commit hash>",
  "last_reviewed_commit_short": "<short hash>",
  "last_review_date": "YYYY-MM-DD",
  "last_review_summary": "Brief summary of changes reviewed",
  "documents_updated": ["docs/design/04_API_reference.md"],
  "documents": [
    {
      "path": "docs/design/01_PRD_product_requirements.md",
      "type": "PRD",
      "description": "Product requirements with user stories and acceptance criteria",
      "created_at": "YYYY-MM-DD"
    }
  ]
}
```

Get full commit hash:
```bash
git rev-parse HEAD
```

**Always read the existing file before writing — merge updates, never overwrite the `documents` field.**

---

## --fix Mode: Apply Fixes from Report

When the user passes `--fix`, skip the review flow and apply fixes from an existing review report.

Triggers: `--fix`, `--fix <path>`, "fix review issues", "apply review fixes"

### fix Step 1: Read Report

```bash
cat docs/code-review.md
```

Use the user-specified path if provided. If the file doesn't exist:
```
No review report found. Run a review first, or specify a report file path.
```

### fix Step 2: Parse Overview

Parse the **issue overview table**, filter for `⏳ Pending` issues:

```
Pending issues from code-review.md:

| # | Priority | File | Summary |
|---|----------|------|---------|
| 1 | 🔴 Must Fix | path/to/file.js | ... |
| 2 | 🟡 Should Improve | path/to/file.js | ... |

Fixing in priority order (🔴 → 🟡 → 🟢). Proceed?
```

### fix Step 3: Fix Issues One by One

Process in priority order:

1. **Read issue details** — current code, fix target, fix notes
2. **Read target file** — verify it exists, locate the exact lines
3. **Verify code match** — compare reported "current code" against actual file content. If mismatch, alert user, show diff, ask to proceed
4. **Apply the fix** — modify code per the "Fix To" block
5. **Update report** — change status from `⏳ Pending` to `✅ Fixed` in the overview table; **remove** the issue detail section (details kept only for pending issues)
6. **Report to user** — brief summary of what was fixed, continue to next

Two modes:
- **Confirm each** (default): pause after each fix for user confirmation
- **Batch mode**: user says "fix all" — fix all pending issues continuously, report at the end

### fix Step 4: Summary

Output after all fixes:

```
This session:
- ✅ Fixed: N items
- ⏭️ Skipped: N items
- ⏳ Remaining: N items

docs/code-review.md updated.
```

---

## Notes

- **Review output only — do not modify code files** (except in `--fix` mode)
- Document updates are **additive/modifying** — never delete existing content without explicit user request
- Always read `docs/review-state.json` before writing — merge updates, **never overwrite `documents`**
- If `docs/` directory doesn't exist, create it first: `mkdir -p docs`
- Review report defaults to `docs/code-review.md`, formatted for AI consumption
- `docs/code-review.md` is itself registered in the document registry with `type: "CODE_REVIEW"`
- When unsure about doc impact, conservatively list potentially affected docs and let the user decide
- "Rescan", "update doc list", "add document" jump directly to Step 3 Scenario C

---

## Reference: Commit-to-Doc Mapping

See `references/commit-doc-mapping.md` for detailed mapping tables.
