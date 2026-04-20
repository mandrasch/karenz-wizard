# Karenz Wizard 🪄

Planning tool for parental leave in Austria.

![](public/hero_karenz_wizard.jpg)

Quick proof of concept with some help by [ChatGPT Codex (VSCode)](https://marketplace.visualstudio.com/items?itemName=openai.chatgpt), regular ChatGPT 5 and [Antigravity](https://antigravity.google/), done in my leisure time. Needs improvements in regards to accessibility & diversity.

https://karenz-wizard.at

## Stack

- [Astro 5](https://astro.build) (static build, `output: 'static'`, trailing-slash `'always'`)
- [AstroWind](https://github.com/onwidget/astrowind) template + vendor integration
- [Tailwind CSS v3](https://v3.tailwindcss.com) via `@astrojs/tailwind`
- [Svelte 5](https://svelte.dev) for the `eakbg-planer` island and two smaller calculators, mounted via `@astrojs/svelte` with `client:load`
- Astro Content Collections for the blog at `src/content/blog/*.md`
- [@fontsource-variable/inter](https://fontsource.org/fonts/inter) for typography
- [umami.is](https://umami.is) for privacy-friendly analytics
- Apache `.htaccess` for static hosting cache headers (see `public/.htaccess`)

## Developing

Install dependencies, then start the dev server:

```sh
npm install
npm run dev
```

Astro picks an open port; it usually lands at `http://localhost:4321/` (or 4322/4323 if the previous is in use).

> Note: changes to `astro.config.ts` or `src/config.yaml` require a dev-server restart — Astro reads config once at startup, not on file change.

## Building

```sh
npm run build     # emits to dist/
npm run preview   # serves dist/ locally
```

Upload `dist/` to any static host. The included `public/.htaccess` sets cache headers for Apache hosts.

## Type-checking

```sh
npm run check  # astro check — must be 0 errors / 0 warnings before committing
```

## Project layout

```
src/
  pages/          Astro pages (one file per route)
  layouts/        Layout.astro — root <html>/<head>/<body> shell
  components/
    widgets/      HeaderKW.astro, FooterKW.astro
    blog/         PostCard.astro, PostGrid.astro
    common/       CommonMeta, SiteVerification
  lib/            Preserved Svelte 5 components (islands)
  content/blog/   Markdown blog posts
  assets/styles/  tailwind.css + kw.css (layout tokens)
  utils/          seo.ts, teaser.ts, permalinks.ts
  content.config.ts   Astro Content Collection schema
public/           Static assets served at the site root
vendor/           AstroWind vendor integration
```

See `AGENTS.md` for editing conventions (accessibility contract, layout rules, Tailwind v3 notes).
See `ASTROWIND_MIGRATION_PLAN.md` for the full SvelteKit → Astro migration history.

## License

Open Source / MIT
