# Commit-to-Document Impact Mapping

## By Conventional Commits Type

| Commit Type | Meaning | High-probability doc impact | Lower-probability doc impact |
|------------|---------|---------------------------|---------------------------|
| `feat` | New feature | PRD (acceptance criteria), API, SDD | Project plan |
| `fix` | Bug fix | SDD (if process change) | API (if behavior change) |
| `refactor` | Refactoring | TDD (architecture changes), SDD | ERD |
| `perf` | Performance | SDD | TDD |
| `chore` | Build/tooling | TDD (dependencies, deployment) | — |
| `docs` | Documentation | Already a doc change — no sync needed | — |
| `test` | Test code | Usually no design doc updates needed | — |
| `ci` | CI/CD | TDD (deployment architecture) | — |
| `build` | Build system | TDD | — |
| `migration` | Data migration | ERD | SDD |

---

## By File Path Pattern

### Backend

| Path pattern | Example | Affected docs |
|-------------|---------|---------------|
| `routes/`, `router/` | `routes/user.js` | API |
| `controllers/`, `handlers/` | `controllers/AuthController.php` | API |
| `models/`, `entities/` | `models/User.py` | ERD |
| `migrations/`, `schema/` | `migrations/001_add_avatar.sql` | ERD |
| `services/`, `domain/` | `services/PaymentService.java` | SDD |
| `middleware/` | `middleware/auth.go` | API (auth), SDD |
| `config/`, `configs/` | `config/database.yaml` | TDD |
| `Dockerfile`, `docker-compose*` | `docker-compose.yml` | TDD |
| `nginx*`, `*.conf` | `nginx.conf` | TDD |

### Frontend

| Path pattern | Example | Affected docs |
|-------------|---------|---------------|
| `pages/`, `views/` | `pages/Dashboard.tsx` | PRD, SDD |
| `components/` | `components/UserCard.vue` | SDD |
| `api/`, `services/` | `api/userApi.ts` | API |
| `store/`, `redux/`, `vuex/` | `store/authSlice.ts` | SDD |
| `router/` | `router/index.ts` | SDD |

### General

| Path pattern | Example | Affected docs |
|-------------|---------|---------------|
| `README.md` | — | Usually user-maintained |
| `.env.example` | — | TDD (env var docs) |
| `package.json`, `go.mod`, `pom.xml` | Dependency changes | TDD (tech stack) |

---

## Changes That Skip Document Sync

These changes typically don't affect design docs:

- Pure style changes (CSS, SCSS)
- Test file changes (`*.test.*`, `*.spec.*`, `__tests__/`)
- Formatting-only changes (whitespace, line breaks)
- Patch/minor dependency version bumps
- Editor config files (`.gitignore`, `.editorconfig`)

---

## Document Update Granularity

| Document | Minimum update unit | Example |
|----------|-------------------|---------|
| API | Endpoint level | Add one endpoint entry / modify a field description |
| ERD | Table/column level | Add a table / add a column to existing table |
| TDD | Module/section level | Update tech stack section / add module description |
| SDD | Process/module level | Update a flow diagram / add module interface spec |
| PRD | Feature item level | Add a user story / update acceptance criteria |
| Project Plan | Task/milestone level | Mark task complete / adjust dates |
