---
name: bootstrapping-docs
description: |
  Bootstrap project documentation. Use when the user starts a new project, says "initialize docs", "create project documentation", "set up design docs", "generate project docs", asks what documents a project needs, or mentions they are starting a new project. This skill evaluates the project scope, recommends which documents are needed, then collaboratively writes each one with user input. Output goes to docs/design/. Even if the user just says "I'm starting a new project", ask whether they want to initialize project documentation.
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
Based on your description, here's my recommended document set:

✅ Essential
- PRD (Product Requirements) — clear user-facing feature requirements
- TDD (Architecture Design) — technology choices and system structure

💡 Recommended
- ERD (Database Design) — you mentioned user data and order data

⏭️ Not needed now
- SDD (Detailed Design) — project is small enough; TDD covers it
- Project Plan — solo project, can add later if needed

Does this look right? Feel free to add or remove any documents.
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
  "path": "docs/design/01_PRD_product_requirements.md",
  "type": "PRD",
  "description": "Product requirements with user stories and acceptance criteria",
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
      "path": "docs/design/01_PRD_product_requirements.md",
      "type": "PRD",
      "description": "Product requirements with user stories and acceptance criteria",
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
- README.md is part of the document set — register it in `docs/review-state.json` so the review-and-sync skill tracks it
- `docs/review-state.json` is shared with the review-and-sync skill — always update it when adding documents
