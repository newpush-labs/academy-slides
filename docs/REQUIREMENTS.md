# academy-slides — Requirements

## 1. Project Overview

**academy-slides** is a Slidev-based presentation repository for [NewPush Academy](https://www.newpush.com). It contains training materials and educational slide decks for instructor-led courses, built with Markdown slides, Vue 3 components, and a custom NewPush theme. The repository is deployed as a static site to GitHub Pages via CI.

### Goals

- Provide a single source of truth for all NewPush Academy course slide decks.
- Enable instructors and contributors to author and update slides using Markdown and Git-based workflows.
- Maintain a consistent visual identity across all decks through a shared custom theme (`np-slides-theme`).
- Automate build and deployment so that merged changes are immediately available online.
- Support PDF export for offline distribution and archival.

## 2. Core Functional Requirements

### FR-1: Course Slide Decks

The repository must host Markdown-based slide decks for each course session. Each deck is a standalone Slidev presentation.

**Current courses:**

| Course | Sessions | Location |
|--------|----------|----------|
| Building Task-Specific AI Agents | 6 decks (3 core sessions + 1 hands-on + 2 extras) | `courses/Building-Task-Specific-AI-Agents/` |
| Building on the Bitcoin Blockchain | 3 decks (3 sessions) | `courses/Building-on-the-Bitcoin-Blockchain/` |
| Course Overview / Home | 1 deck | `courses/home.md` |

**Acceptance criteria:**

- Each session is a single `.md` file using Slidev YAML frontmatter and `---` slide separators.
- Decks are organised under `courses/<CourseName>/` directories.
- Every deck listed in the README must build successfully with the `build-slides.sh` script.
- New courses follow the same directory and naming conventions.

### FR-2: Custom Theme (`np-slides-theme`)

All slide decks must use the NewPush Academy custom theme for consistent branding.

**Theme components:**

| Component | Purpose |
|-----------|---------|
| `layouts/cover.vue` | Title/cover slide layout |
| `layouts/intro.vue` | Introduction slide layout |
| `layouts/section.vue` | Section divider layout |
| `layouts/fact.vue` | Fact/statistic highlight layout |
| `layouts/quote.vue` | Quote slide layout |
| `layouts/statement.vue` | Statement slide layout |
| `layouts/roadmap.vue` | Roadmap/timeline layout |
| `styles/index.ts` | Theme style entry point |
| `styles/layouts.css` | Layout-specific CSS |
| `styles/prism.css` | Code syntax highlighting |
| `images/np_logo_labs.png` | NewPush Labs logo |
| `images/np_logo_white.png` | NewPush white logo |

**Acceptance criteria:**

- The theme is located in `themes/np-slides-theme/` and extends `@slidev/theme-seriph`.
- All decks render with NewPush branding (logos, fonts, colour scheme).
- Theme changes must be tested across all existing decks before merging.
- Custom layouts must be documented in the theme's README.

### FR-3: Interactive Vue Components

The repository supports custom Vue 3 Single File Components (SFCs) for interactive slide content.

**Current components:**

| Component | Location | Purpose |
|-----------|----------|---------|
| `Counter.vue` | `components/` | Generic counter demo component |
| `neural-tokens.vue` | `courses/Building-Task-Specific-AI-Agents/components/` | Neural token visualisation |
| `tokens.vue` | `courses/Building-Task-Specific-AI-Agents/components/` | Token visualisation |

**Acceptance criteria:**

- Global components live in `components/` and are auto-imported by Slidev.
- Course-specific components live in `courses/<CourseName>/components/`.
- All components use Vue 3 Composition API (`<script setup>`).
- Components must not break the build or PDF export.

### FR-4: Build and Export

The repository must support building all decks into static HTML and exporting them as PDFs.

**Build commands:**

| Command | Purpose |
|---------|---------|
| `npm run dev` | Local development server (single deck) |
| `npm run build` | Production build (single deck) |
| `npm run export` | PDF export (single deck) |
| `scripts/build-slides.sh` | Batch build of all decks for deployment |

**Acceptance criteria:**

- `scripts/build-slides.sh` builds every `.md` file under `courses/` into separate output directories under `/tmp/dist/courses/`.
- Each deck has its own base path (`/academy-slides/courses/<course>/<session>/`) for correct asset resolution on GitHub Pages.
- The theme demo (`themes/np-slides-theme/example.md`) is built to `/tmp/dist/theme-demo/`.
- `npm run export` produces a valid PDF with all slides rendered.

### FR-5: Course Home Page

A course overview/index page must exist at `courses/home.md` that links to all available course sessions.

**Acceptance criteria:**

- The home page is accessible at `https://newpush-labs.github.io/academy-slides/courses/home/`.
- It lists all courses and their sessions with working links.
- It is updated whenever a new course or session is added.

### FR-6: Course Assignments

Courses may include hands-on assignments distributed alongside the slides.

**Acceptance criteria:**

- Assignments are stored in `courses/<CourseName>/assigments/` (note: existing typo in directory name — maintain for backward compatibility).
- Both source files and PDF exports of assignments may be present.
- Assignment references in slides use relative paths.

## 3. Non-Functional Requirements

### NFR-1: Content Quality

- Slides must be concise and suitable for instructor-led presentation (not documentation).
- Code examples must use fenced code blocks with language tags for syntax highlighting.
- Speaker notes (Slidev `<!-- notes -->` blocks) should accompany complex slides to guide instructors.

### NFR-2: Consistency

- All decks must use the `np-slides-theme` custom theme.
- YAML frontmatter conventions (layout names, class names) must be consistent across all decks.
- Image assets must use descriptive filenames and be stored near the referencing Markdown file or in a shared directory.

### NFR-3: Performance

- The batch build (`build-slides.sh`) must complete within a reasonable time on CI runners (GitHub Actions with Node.js LTS).
- Individual deck builds should succeed independently; a failure in one deck must not prevent other decks from building.

### NFR-4: Accessibility

- Slides should use sufficient colour contrast (enforced by the theme).
- Images should have descriptive alt text where Slidev supports it.
- Code blocks should use readable font sizes.

### NFR-5: Maintainability

- Markdown linting via ESLint with `eslint-plugin-markdown` must pass (`npm run lint` when configured).
- Dependencies should be pinned or use semver ranges in `package.json` and locked in `pnpm-lock.yaml`.
- The `.npmrc` registry configuration must be respected.
- Node.js LTS (currently 20) is the target runtime.

## 4. Integration Requirements

### GitHub Pages Deployment

- The `deploy.yml` GitHub Actions workflow triggers on pushes to `main`.
- It runs `scripts/build-slides.sh` and deploys the output to GitHub Pages.
- The site is available at `https://newpush-labs.github.io/academy-slides/`.

### Branch Protection

- PRs to `main` must originate from the `develop` branch (enforced by `require-develop-source.yml`).
- Feature work is done on `feature/*` branches off `develop`.
- The workflow: `feature/*` → `develop` → `main`.

### Tooling

- **Slidev** `^51.1.1` with `@slidev/cli` as the presentation framework.
- **Vue 3** `^3.5.13` for custom components.
- **pnpm** as the package manager (lock file: `pnpm-lock.yaml`).
- **@antfu/ni** used in CI for package manager-agnostic commands (`nci`, `nr`).
- **ESLint** `^9.20.1` with `eslint-plugin-markdown` for linting.

## 5. Current Status and Implementation Gaps

### Implemented

- 10 Markdown slide decks across 2 courses plus a home page.
- Custom `np-slides-theme` with 7 layout components and NewPush branding.
- 3 interactive Vue components (1 global, 2 course-specific).
- Batch build script (`scripts/build-slides.sh`) for all decks.
- GitHub Actions CI/CD pipeline for GitHub Pages deployment.
- Branch protection workflow (`require-develop-source.yml`).
- ESLint configuration with Markdown processor.
- Assignment distribution for the AI Agents course.
- Theme demo page.

### Gaps / Future Work

| Priority | Gap | Description |
|----------|-----|-------------|
| High | **No automated build verification in PRs** | The `deploy.yml` workflow only runs on `main`. There is no CI job that validates `build-slides.sh` succeeds on PRs to `develop`, meaning broken decks can be merged without detection. |
| High | **Missing `npm run lint` script** | The `package.json` does not define a `lint` script despite ESLint being configured and `DEV_AGENT_PROMPT.md` referencing `npm run lint`. |
| Medium | **No PDF export verification** | There is no CI step or test that validates `npm run export` produces valid PDFs. Export failures would only be discovered manually. |
| Medium | **Incomplete home page** | The `courses/home.md` may not list all sessions and extras; it should be kept in sync automatically or verified by CI. |
| Medium | **No link validation** | Internal links between slides, to images, and to external URLs are not validated. Broken links would only be discovered manually. |
| Low | **Theme documentation** | The `np-slides-theme` has a generic README inherited from `@slidev/theme-seriph`. It should document the custom layouts, branding, and usage conventions specific to NewPush Academy. |
| Low | **Assignment directory typo** | The directory is named `assigments` (missing 'n'). Renaming it would require updating all references but would improve discoverability. |
| Low | **No component tests** | Vue components have no unit tests. At minimum, they should be verified to render without errors during the build. |
