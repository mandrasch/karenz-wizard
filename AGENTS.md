# AGENTS.md — Editing Rules for AI Assistants

## Project One-Liner

Astro + AstroWind static site (German-only, `lang="de-AT"`). Accessibility-first (WCAG 2.2 AA). Tailwind v3. One hydrated Svelte island (`eakbg-planer`) plus two smaller Svelte calculators mounted with `client:load`.

## Non-Negotiable Layout Rules

- Keep **one root layout**: `<header> → <main id="main"> → <footer>`.
- **No DOM shape changes** between routes; style differences only via `data-layout="home|subpages"`.
- No view transitions / `ClientRouter`, no container swaps on navigation — full page loads.
- Use **grid full-bleed pattern**: `.page-grid` + `.content` + `.full-bleed`. Never use `100vw` that causes horizontal scroll.

## Important checks

- Run `npm run check` (astro check) before committing; must show 0 errors / 0 warnings.
- Run `npm run build` and verify page count matches expected (currently 24).
- When editing `astro.config.ts` or `src/config.yaml`, restart `npm run dev` — config is read once at startup, not watched.
- The AstroWind vendor integration (`vendor/integration/index.ts`) silently overrides top-level `site` and `trailingSlash` from `astro.config.ts` with values read from `src/config.yaml`. **Keep both in sync.**

## Accessibility Requirements

- Provide a visible **skip link** to `#main`; keep it first in tab order (`src/layouts/Layout.astro`).
- Constrain reading width (~70–80ch). Verify color contrast (AA), target sizes ≥44×44, respect `prefers-reduced-motion`.
- Exactly one visible `<h1>` per page. Preserve landmark roles.

## Routing & Styling

- Home route = `data-layout="home"`; subpages = `data-layout="subpages"` (set on `<main>` in `Layout.astro`).
- Full-bleed sections are **opt-in**: apply `.full-bleed` to decorative/hero stripes only; keep text inside `.content`.
- Trailing slash: policy is `'always'`. All internal nav/footer links use trailing `/`.
- Blog URLs come from `post.data.slug` (frontmatter), **not** the filename. See `src/pages/blog/[...slug].astro`.

## Performance/CLS

- Avoid layout shift: no height changes to header/footer between routes.
- Fonts use `font-display: swap` via `@fontsource-variable/inter`.
- Don't animate container width/height on route change; animate children.

## Astro Conventions

- Static build only (`output: 'static'`, `build.format: 'directory'`). No server endpoints.
- Page content lives in `src/pages/*.astro`. Shared layout in `src/layouts/Layout.astro`. Header / footer in `src/components/widgets/HeaderKW.astro` + `FooterKW.astro`.
- Blog posts are Astro Content Collections at `src/content/blog/*.md`, schema in `src/content.config.ts`.
- SEO title/description per route live in `src/utils/seo.ts`; `Layout.astro` resolves them from `Astro.url.pathname`.
- Hydration islands: import Svelte components from `src/lib/components/` with `client:load` (only when interactivity is needed — the blog PostCard/PostGrid are plain `.astro`, no hydration).
- Use the `~/` path alias for imports (maps to `src/`).

## Svelte Islands (when touching `src/lib/components/*.svelte`)

- Svelte 5 runes (`$state`, `$derived`, `$effect`, `$props`). Not runes-compatible code breaks dev/build.
- Don't reintroduce SvelteKit APIs (`$app/*`, `+page.*`, `load`) — we're on Astro.
- Font variable `--planner-font` reads from the global `--aw-font-sans`; do not hard-code fonts inside islands.

## Tailwind Tokens

- v3 directives: `@tailwind base; @tailwind components; @tailwind utilities;` in `src/assets/styles/tailwind.css`. **Do not** use v4 `@import "tailwindcss"`.
- Tailwind v3 does **not** accept fractional class names (`h-12.5`, `w-1.75`). Use arbitrary-value syntax instead: `h-[3.125rem]`.
- Layout tokens (CSS custom props) defined inline in `Layout.astro`:
  - `--aw-font-sans/serif/heading` → `'Inter Variable'`
  - `--aw-color-primary`, `--aw-color-text-default/muted/heading`, `--aw-color-bg-page`
- Tailwind utilities mapped to those vars (in `tailwind.config.js` / `tailwind.css`):
  - `font-sans`, `font-heading` → Inter Variable
  - `text-primary`, `text-muted`, `text-default`, `bg-page`
- Grid utilities (in `kw.css`, loaded after `tailwind.css`): `.page-grid`, `.content`, `.full-bleed`, `.skip-link`, plus `:root { --content-w, --content-px, --section-gap }`.

## Safe Edit Checklist (before committing)

- Landmarks unchanged? (one `<header>`, one `<main id="main">`, one `<footer>`)
- No horizontal overflow on pages with full-bleed?
- Skip link visible on focus? Focus lands on `<main>` after nav?
- `npm run check` clean?
- Images referenced with leading `/` resolve in `public/` (no 404s on page load)?
- Nav + footer links all carry trailing `/`?

## Where to Read More

- Migration history: `ASTROWIND_MIGRATION_PLAN.md`.
- Rollback point: tag `pre-astrowind-migration` on the pre-migration tip.
- If unsure: **ask before editing files outside `src/pages/`, `src/layouts/`, `src/components/`, `src/content/`.**
