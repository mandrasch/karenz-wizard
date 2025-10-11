# AGENTS.md — Editing Rules for AI Assistants

## Project One-Liner

Svelte v5 + adapter-static site. Accessibility-first (WCAG 2.2 AA).

## Non-Negotiable Layout Rules

- Keep **one root layout**: `<header> → <main id="main"> → <footer>`.
- **No DOM shape changes** between routes; style differences only via `data-layout="home|subpages"`.
- **No `{#key}` or conditional `<main>`**, no container swaps on navigation.
- Use **grid full-bleed pattern**: `.page-grid` + `.content` + `.full-bleed`. Never use `100vw` that causes horizontal scroll.

## Accessibility Requirements

- Provide a visible **skip link** to `#main`; keep it first in tab order.
- On client navigation, **focus `<main>`** if the body has focus (`afterNavigate`).
- Constrain reading width (~70–80ch). Verify color contrast (AA), target sizes ≥44×44, respect `prefers-reduced-motion`.
- Exactly one visible `<h1>` per page. Preserve landmark roles.

## Routing & Styling

- Home route = `data-layout="home"`; subpages = `data-layout="subpages"`.
- Full-bleed sections are **opt-in**: apply `.full-bleed` to decorative/hero stripes only; keep text inside `.content`.

## Performance/CLS

- Avoid layout shift: no height changes to header/footer between routes.
- Preload fonts or use `font-display: swap`.
- Don’t animate container width/height on route change; animate children.

## Svelte 5 Conventions

- Use `$state` sparingly; prefer page/local state over global where possible.
- No event handlers on non-interactive landmarks (e.g., `<header>`).
- Static build: `export const prerender = true;` and consistent trailing-slash policy.

## Tailwind Tokens (assumed)

- `--content-w: 72rem` (adjust as needed), `--content-px` responsive.
- Add utilities in `@layer components`: `.page-grid`, `.content`, `.full-bleed`.

## Safe Edit Checklist (before committing)

- Landmarks unchanged?
- No `{#key}` around layout or page containers?
- No horizontal overflow on pages with full-bleed?
- Skip link visible on focus? Focus lands on `<main>` after nav?

## Where to Read More

- Human docs: `README.md`, `CONTRIBUTING.md`, `/docs/a11y.md`, `/docs/css.md`.
- If unsure: **ask before editing files outside `src/routes/**` or global layout.\*\*
