---
name: bootstrapping-docs
description: |
  Bootstrap project documentation. Use when the user starts a new project, says "initialize docs", "create project documentation", "set up design docs", "generate project docs", asks what documents a project needs, or mentions they are starting a new project. Also triggers on Chinese keywords: 初始化文档, 创建项目文档, 生成设计文档, 新建项目, 新项目, 我要开始一个新项目, 帮我写文档, 项目需要哪些文档. This skill evaluates the project scope, recommends which documents are needed, then collaboratively writes each one with user input. Output goes to docs/design/. Even if the user just says "I'm starting a new project", ask whether they want to initialize project documentation.
---

# Bootstrapping Docs

## Core Principles

**Confirm document scope before writing anything.** Never skip scope confirmation.

Document content comes from user discussion — do not fabricate details. Each document is written iteratively with user feedback.

---

## Workflow

### Phase 1: Understand the Project

Ask the user to describe the project in 2-3 sentences. Key questions:

- What is the core functionality?
- Expected scale (solo / small team / multi-team)?
- Any database, external API integrations, or complex business logic?

### Phase 2: Recommend Document Scope

Based on the user's description, evaluate the project scale and recommend documents. **Always include the reason for each recommendation**:

| Scale indicators | Recommended docs |
|-----------------|-----------------|
| Solo / single feature / no complex data | PRD + TDD |
| Multi-module / has database / has integrations | + ERD + API |
| Multi-person / complex business / needs scheduling | + SDD + Project Plan |
| Microservices / multi-team / compliance | + 00 Overview + expand as needed |

Recommendation format:

```
根据您的描述，建议创建以下文档：

✅ 必要
- PRD（产品需求规格）—— 项目有明确的用户功能需求
- TDD（架构设计）—— 需要明确技术选型和系统结构

💡 建议
- ERD（数据库设计）—— 您提到有用户数据和订单数据

⏭️ 暂不需要
- SDD（详细设计）—— 当前规模较小，TDD 足够
- 项目计划 —— 单人项目可按需添加

是否按此清单进行？您可以要求添加或移除某些文档。
```

**Wait for explicit user confirmation before proceeding to Phase 3.**

### Phase 3: Check Existing Documents

After confirmation, check for existing docs:

```bash
ls docs/design/ 2>/dev/null || echo "Directory does not exist"
```

If the directory exists with same-named documents, ask whether to overwrite.

Create directory if needed:
```bash
mkdir -p docs/design
```

### Phase 4: Write Documents Collaboratively

For each confirmed document, in order:

1. **Ask key questions** — per document type (see template questions below)
2. **Output a draft** — based on user answers
3. **Wait for feedback** — ask if adjustments are needed
4. **Write to file** — once user approves
5. **Update registry** — immediately append the document to `docs/review-state.json` `documents` list

Output path: `docs/design/<NN>_<TYPE>_<中文名>.md`

### Phase 5: Generate README.md

After all design documents are written, auto-generate project `README.md` from the document content:

- Project name and one-line description (from PRD)
- Tech stack overview (from TDD)
- Document index table (links to all docs under `docs/design/`)
- Quick start (env setup, startup commands — confirm with user)

**README.md is registered in the document registry** with `type: "README"`.

### Phase 6: Write Document Registry

Ensure `docs/review-state.json` has all newly created documents in its `documents` field.

Registry rules:
- If `docs/review-state.json` doesn't exist, create it with the full structure (see format below)
- If it exists, only update `documents` — **do not overwrite** `last_reviewed_commit` or other review fields

**Registry entry format**:
```json
{
  "path": "docs/design/01_PRD_产品需求规格说明书.md",
  "type": "PRD",
  "description": "产品需求规格，包含用户故事和验收标准",
  "created_at": "YYYY-MM-DD"
}
```

**Full file structure** (first-time creation):
```json
{
  "last_reviewed_commit": null,
  "last_reviewed_commit_short": null,
  "last_review_date": null,
  "last_review_summary": null,
  "documents_updated": [],
  "documents": [
    {
      "path": "docs/design/01_PRD_产品需求规格说明书.md",
      "type": "PRD",
      "description": "产品需求规格，包含用户故事和验收标准",
      "created_at": "YYYY-MM-DD"
    }
  ]
}
```

---

## Document Templates & Key Questions

Full templates available in `references/doc-templates.md`.

Core questions to ask the user before writing each document:

**PRD**: Who are the target users? What are the core features? What is explicitly out of scope?

**TDD**: What's the tech stack? What are the main system modules? Deployment model (local / cloud / Docker)?

**ERD**: What are the core entities (e.g., User, Order, Product)? How do they relate?

**API**: REST or GraphQL? What are the main endpoints? Is authentication needed?

**SDD**: Which modules have the most complex logic? Any special algorithms or state machines?

**Project Plan**: Target launch date? Key milestones? Current team size?

---

## Document Naming Convention

- Sequence number from `01`, zero-padded to two digits
- Type in uppercase English abbreviation (PRD / TDD / ERD / API / SDD)
- Descriptive name in Chinese
- Example: `01_PRD_产品需求规格说明书.md`, `04_API_接口文档.md`

If a project overview document is needed, use `00_project_overview.md`.

---

## Notes

- Write documents in Chinese — all output documents use Chinese headings, labels, and content
- Document content comes from user input — do not invent business details
- After each document: ask "Continue to the next document?"
- If the user wants to revise a completed document mid-flow, respond immediately, then resume
- After all documents are done, output the document index for confirmation
- README.md is part of the document set — register it in `docs/review-state.json` so the syncing-docs skill tracks it
- `docs/review-state.json` is shared with the syncing-docs skill — always update it when adding documents
