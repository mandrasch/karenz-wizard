# AstroWind Migration Plan

**Source:** SvelteKit v5 + adapter-static + Paraglide i18n + mdsvex + Playwright
**Target:** Fresh AstroWind (Astro 5.12 + Tailwind 3.4) + Astro Content Collections for blog
**Branch:** `refactor/astrowind-migration`
**Safety tag:** `git tag pre-astrowind-migration` on pre-migration tip for rollback

## Progress tracking

Each phase below has a **Status:** line. Checkbox items (`- [ ]` → `- [x]`) inside a phase track substeps.

_Status legend:_ ☐ not started · 🟡 in progress · ✅ done (commit `sha`, YYYY-MM-DD) · ⏭️ skipped

## Confirmed decisions

- **Tailwind 3** (downgrade from repo's current v4; AstroWind still ships v3). Revisit v4 later.
- **Remove i18n (Paraglide)** entirely — site becomes German-only (`lang="de-AT"`).
- **Remove Playwright** entirely (`e2e/`, `playwright.config.ts`, deps).
- **`eakbg-planer` stays as Svelte island** via `@astrojs/svelte` (zero rewrite of 2270 LOC runes).
- **Fix date typo** `2028-01-28` → `2026-01-28` in `src/content/blog/2026-01-28-mutter-startet-volksbegehren.md`.

## Key findings from repo survey

- `wx-svelte-gantt` is **dead code** — only imported by `src/lib/components/GanttMinimalDemo.svelte`, which is not referenced by any route. Drop the dep.
- Blog `.md` files use plain markdown + inline HTML (`<a>`, `<img>`, `<details>`, `<cite>`, `<p>`), **no Svelte components** — plain `.md` in Content Collections works, no `.mdx` needed.
- Blog frontmatter: `title`, `pubDate` (date), `slug`. **Slug comes from frontmatter, not filename** — must be preserved in `getStaticPaths`.
- Paraglide has no actual `m()` translation calls in components — only wired in `hooks.ts`, `hooks.server.ts`, `app.html` (`%paraglide.lang%`), `vite.config.ts`. Clean removal.
- Interactive pages using Svelte 5 runes: `eakbg-planer` (heavy), home `+page.svelte` (accordion), `+layout`, `Header` (mobile menu). Others appear static.
- `buecher-broschueren`, `tools`, `videos` are just 308 redirects → `/infothek#…`. Use static `redirects:` in `astro.config.mjs`.
- `@fontsource/ibm-plex-sans-condensed` used in `eakbg-planer` — must survive.
- umami analytics script in `src/app.html` — preserve into Astro layout head.
- `.htaccess` in `static/` sets Apache cache headers — copy into `public/`.
- Cross-post link: `2025-11-01-presseanfrage-oegk.md` links to `/blog/antwort-presseanfrage-oegk-unbezahlte-karenz-mitversicherung/` — confirm that slug exists in `2025-12-03-presseanfrage-oegk-antwort.md` frontmatter.
- Current trailing-slash policy: `'always'` → Astro equivalent: `trailingSlash: 'always'` + `build.format: 'directory'`.
- AstroWind uses Astro 5 Content Collections with `glob()` loader (posts at `src/data/post/`). Keep `src/content/blog/` for clarity; override the loader's base path.
- AstroWind schema uses `publishDate`; repo uses `pubDate` — either align frontmatter or customize the schema. Aligning frontmatter is cleaner.

---

## Phase 0 — Branch sanity check + safety tag

**Status:** ✅ done (tag-only, no commit, 2026-04-19) — branch `refactor/astrowind-migration` now tracks `origin/refactor/astrowind-migration`; tag `pre-astrowind-migration` created locally on `230bfca`.

```bash
git fetch && git status -sb
git tag pre-astrowind-migration   # rollback point
```

**Verify:**

- [x] Branch tracks remote (`origin/refactor/astrowind-migration`)
- [x] Tree clean (only untracked: `.claude/`, `ASTROWIND_MIGRATION_PLAN.md` — both intentional)

---

## Phase 1 — Stage fresh AstroWind outside the repo

**Status:** ✅ done (no commit, 2026-04-19) — clone at `/tmp/astrowind-template` (HEAD `59b7e37` "Fix format").

Do **not** `npm create astro` inside the non-empty repo. Instead:

```bash
git clone --depth 1 https://github.com/onwidget/astrowind /tmp/astrowind-template
```

Inspect `/tmp/astrowind-template/package.json` to lock versions:

- [x] `astro@^5.12.9` ✓ matches
- [x] `tailwindcss@^3.4.17` + `@astrojs/tailwind@^5.1.5` ✓ matches
- [x] `@astrojs/sitemap@^3.4.2`, `@astrojs/mdx@^4.3.3`, `astro-icon@^1.1.5`, `astro-compress@2.3.8`, `astrowind` vendor integration at `vendor/integration/` (imported in `astro.config.ts:14`) ✓ all present

**Additional deps observed (decide in Phase 3):**

- Drop: `@astrolib/analytics`, `@astrolib/seo`, `@fontsource-variable/inter` (we have our own seo.ts, umami, and use IBM Plex)
- Keep baseline: `astro-embed`, `limax`, `lodash.merge`, `unpic`, `sharp`, `reading-time`, `mdast-util-to-string`, `@astrojs/partytown`
- Reconsider later: `@astrojs/rss` (blog RSS feed — not in current plan)

**Conflict map (resolve explicitly):**

| Path                   | Current                   | AstroWind       | Resolution                  |
| ---------------------- | ------------------------- | --------------- | --------------------------- |
| `package.json`         | SvelteKit                 | AstroWind       | Replace wholesale (Phase 3) |
| `tsconfig.json`        | `extends .svelte-kit/...` | AstroWind's     | Replace                     |
| `vite.config.ts`       | paraglide+sveltekit       | N/A             | Delete                      |
| `svelte.config.js`     | mdsvex+kit                | N/A             | Delete                      |
| `eslint.config.js`     | svelte-flavoured          | AstroWind's     | Replace (or drop)           |
| `src/`                 | SvelteKit routes          | AstroWind pages | Handled Phase 3             |
| `static/` vs `public/` | static/                   | public/         | Phase 7                     |
| `.prettierrc`          | custom                    | AstroWind's     | Keep current                |

---

## Phase 2 — Remove SvelteKit / Paraglide / Playwright / mdsvex

**Status:** ✅ done (commit `92fc613`, 2026-04-19) — 43 files / 5300 deletions. umami snippet and `app.css` tokens recoverable via `git show pre-astrowind-migration:src/app.html` and `git show pre-astrowind-migration:src/app.css` when needed in Phase 4.

**Delete top-level dirs:**

- [x] `e2e/`
- [x] `messages/`
- [x] `project.inlang/` (incl. `cache/`)
- [x] `.svelte-kit/` (generated)

**Delete top-level files:**

- [x] `svelte.config.js`
- [x] `vite.config.ts`
- [x] `playwright.config.ts`
- [x] `tsconfig.json` (replaced Phase 3)
- [x] `eslint.config.js`

**Delete inside `src/` BEFORE copying AstroWind src on top:**

- [x] `src/routes/` (all routes — content ported manually in Phase 5/6; reference via `git show pre-astrowind-migration:…`)
- [x] `src/hooks.ts`, `src/hooks.server.ts`
- [x] `src/app.html` (replaced by Astro Layout; **preserve umami snippet** for Phase 4 — recover via `git show pre-astrowind-migration:src/app.html`)
- [x] `src/app.css` (parts preserved as `src/assets/styles/kw.css` in Phase 4 — recover via `git show pre-astrowind-migration:src/app.css`)
- [x] `src/app.d.ts`
- [x] `src/lib/paraglide/` (gitignored but may exist locally)

**Keep temporarily** (ported in later phases) — confirmed still present:

- [x] `src/lib/assets/` (logo, favicon)
- [x] `src/lib/components/*.svelte` — kept for Svelte island port of `eakbg-planer`
- [x] `src/lib/seo.ts` → port to `src/utils/seo.ts`
- [x] `src/lib/types.ts` (referenced by EligibilityPanel)
- [x] `src/content/blog/` (ported to collection in Phase 6)

**Delete unconditionally (dead code):**

- [x] `src/lib/components/GanttMinimalDemo.svelte` (only consumer of `wx-svelte-gantt`)
- [x] `src/lib/components/demo.svelte`
- [x] `src/lib/server/blog.ts` (replaced by Content Collection query)
- [x] `src/routes/eakbg-anspruch/page.backup.svelte`

**Commit:** `chore: remove sveltekit, paraglide, playwright, mdsvex scaffolding`

---

## Phase 3 — Land AstroWind + new `package.json`

**Status:** ✅ done (commit `d56c54d`, 2026-04-19) — 129 files / +21,015 / −5,915. `npm run build` succeeds: 36 pages + sitemap. Unplanned additions noted below under "Temporary deps" and "Image domains".

Copy from `/tmp/astrowind-template/` into repo root (excluding `.git`, `node_modules`, `package-lock.json`, template `README.md`/`LICENSE.md`):

- [x] `src/` (merged with preserved `src/lib/` + `src/content/blog/`), `public/`, `vendor/`, `astro.config.ts`, `tailwind.config.js`, `tsconfig.json`, `.vscode/`, `.editorconfig`

**Rewrite `package.json`:**

- [x] Keep: `name: "karenz-wizard"`, `version: "0.0.1"`, `private: true`, `type: "module"`
- [x] Base deps: AstroWind's baseline
- [x] **Add:** `@fontsource/ibm-plex-sans-condensed`, `@astrojs/svelte`, `svelte@^5` (for eakbg-planer island)
- [x] **Drop:** `@sveltejs/*`, `@inlang/*`, `@playwright/*`, `mdsvex`, `svelte-check`, `svelte-sitemap`, `wx-svelte-gantt`, `eslint-plugin-svelte`, `prettier-plugin-svelte`, `sass-embedded`, `vite`, `@tailwindcss/vite` (v4)
- [x] **Scripts:** AstroWind defaults (`dev`, `build`, `preview`, `check` → `astro check`)
- [x] **Drop:** `postbuild` calling `svelte-sitemap` (replaced by `@astrojs/sitemap` in Phase 8)

- [x] **Update `.gitignore`:** dropped `.svelte-kit`, `src/lib/paraglide`; added `.astro`, `/dist`, `.claude/settings.local.json`.
- [x] **Add `@astrojs/svelte` to `astro.config.ts` integrations** for the eakbg-planer island.

**Temporary deps kept until Phase 4/5** (AstroWind demo components import them; drop when those components are replaced):

- `@astrolib/analytics` — used by `src/components/common/Analytics.astro`
- `@astrolib/seo` — used by `src/components/common/Metadata.astro` + `src/utils/images.ts`
- `@fontsource-variable/inter` — used by `src/components/CustomStyles.astro`
- `@astrojs/rss` — used by `src/pages/rss.xml.ts` (keep if blog RSS wanted)

**Image domains extended** in `astro.config.ts` for the AstroWind demo posts (prune in Phase 7):

- `images.unsplash.com`, `plus.unsplash.com`

**Commit:** `chore: scaffold AstroWind base` (d56c54d)

**Verify:**

- [x] `npm install && npm run build` succeeds — 36 pages built, sitemap generated. Dev server not separately tested; build is the stronger check.

---

## Phase 4 — Port global layout + a11y contract from AGENTS.md

**Status:** ✅ done (commit `b788966`, 2026-04-19) — 6 files / +706 / −32. Build green; built HTML shows `<html lang="de-AT">`, skip link, `<main data-layout="home">` on `/`, `data-layout="subpages"` elsewhere, and umami. Full verify (single-h1, nav click-through) deferred to Phase 5 pages.

**Problem:** AstroWind's default `Layout.astro` / `Header.astro` / `Footer.astro` conflict with `AGENTS.md` rules (no `data-layout`, own dark-mode toggle, own skip-link wording).

**Steps:**

- [x] **Edit `src/layouts/Layout.astro`:**
  - [x] Add `<a class="skip-link" href="#main">Zum Inhalt springen</a>` first in tab order.
  - [x] Wrap children in `<main id="main" tabindex="-1" data-layout={layoutVariant}><div class="page-grid">…</div></main>`.
  - [x] Compute `layoutVariant` from `Astro.url.pathname` (`/` → `home`, else `subpages`).
  - [x] Inject umami analytics snippet (from pre-migration `src/app.html`) in `<head>`.
  - [x] Set `<html lang="de-AT">`.
  - [x] Dropped `ClientRouter` (view transitions) — violates AGENTS.md "no container swaps on navigation".
  - [x] Dropped imports of `Metadata`/`Analytics`/`CustomStyles` (AstroWind helpers using `@astrolib/*` + `@fontsource-variable/inter`). Title/description now from `seo.ts`, font from `@fontsource/ibm-plex-sans-condensed` global import.

- [x] **Create `src/components/widgets/HeaderKW.astro`** — port DOM from `src/lib/components/Header.svelte`. Hamburger menu uses vanilla module `<script>` toggling `aria-expanded`; Escape closes; body scroll lock via `html.overflow-hidden`. Preview-banner close same vanilla treatment.

- [x] **Create `src/components/widgets/FooterKW.astro`** — port `Footer.svelte` 1:1 (pure markup). "Made with SvelteKit" → "Made with Astro / AstroWind".

- [x] **Unused:** `src/components/widgets/Header.astro` / `Footer.astro` (AstroWind defaults) left on disk but not imported from our `Layout.astro`. Still referenced by AstroWind demo pages via `PageLayout.astro` — removed alongside demo pages in Phase 5.

- [x] **Global CSS:** created `src/assets/styles/kw.css` with `:root { --content-w, --content-px, --section-gap }` + `.page-grid`, `.content`, `.full-bleed`, `.skip-link`. Plain CSS (no `@layer` directives) — Vite processes each CSS import through Tailwind independently, so `@layer base` there crashes the build. Imported from `Layout.astro` after `tailwind.css`.

- [x] **SEO:** ported `src/lib/seo.ts` → `src/utils/seo.ts` as-is. `Layout.astro` calls `getSeoMeta(Astro.url.pathname)`; page-supplied `metadata.title`/`.description` override. Our slug-based matches only kick in once Phase 5 replaces demo pages.

**Verify checklist:**

- [ ] Nav works desktop + mobile
- [ ] Skip link visible on focus, lands on `<main>`
- [ ] `data-layout="home"` on `/`, `"subpages"` elsewhere
- [ ] No horizontal scroll on full-bleed sections
- [ ] One visible `<h1>` per page
- [ ] DOM shape identical between routes

**Commit:** `feat: port layout/header/footer with a11y contract`

---

## Phase 5 — Port static pages (Svelte routes → `.astro`)

**Status:** ✅ done (commits `3afb505`, `b78dd95`, `d5c7136`, `65834a7`, `5438f54`, `70b28f2`; 2026-04-19) — all 12 routes + 3 redirects + cleanup + eakbg-planer island. Build green (13 pages), `astro check` clean (0/0/0).

Per-route checklist — tick each route as its `.astro` port is committed:

- [x] `/` → `src/pages/index.astro` (commit `65834a7`; overwrites AstroWind demo; blog latest-posts section deferred to Phase 6)
- [x] `/ak-beratung` → `src/pages/ak-beratung.astro` (commit `d5c7136`; akList in frontmatter)
- [x] `/eakbg-anspruch` → `src/pages/eakbg-anspruch.astro` (commit `d5c7136`; 2× EligibilityCalculatorEaKbg islands)
- [x] `/eakbg-planer` → `src/pages/eakbg-planer.astro` + `src/lib/components/EaKbgPlaner.svelte` (commit `70b28f2`; mounted with `client:load`, verbatim port of 2270-LOC Svelte 5 runes page)
- [x] `/faq` → `src/pages/faq.astro` (commit `b78dd95`; faqs array in frontmatter, `{@html}` → `<Fragment set:html>`)
- [x] `/fzb-anspruch` → `src/pages/fzb-anspruch.astro` (commit `3afb505`; uses `EligibiltyDateCalculator.svelte` as client:load island)
- [x] `/impressum-datenschutz` → `src/pages/impressum-datenschutz.astro` (commit `3afb505`)
- [x] `/infothek` → `src/pages/infothek.astro` (commit `d5c7136`; section ids preserved for redirects)
- [x] `/pauschales-kbg` → `src/pages/pauschales-kbg.astro` (commit `d5c7136`)
- [x] `/reaktionen-und-feedback` → `src/pages/reaktionen-und-feedback.astro` (commit `3afb505`)
- [x] `/ueber` → `src/pages/ueber.astro` (commit `b78dd95`)
- [x] `/unbezahlte-karenz` → `src/pages/unbezahlte-karenz.astro` (commit `3afb505`)
- [x] `/buecher-broschueren`, `/tools`, `/videos` → `redirects:` in `astro.config.ts` (commit `65834a7`, emits meta-refresh to `/infothek/#...`; `trailingSlash: 'always'` + `build.format: 'directory'` already set in commit `3afb505`)

| URL                        | Svelte source              | New Astro file                                            | Complexity                                                                   |
| -------------------------- | -------------------------- | --------------------------------------------------------- | ---------------------------------------------------------------------------- |
| `/`                        | `src/routes/+page.svelte`  | `src/pages/index.astro`                                   | Home accordion uses `$state` (mostly commented) — vanilla `<script>` or drop |
| `/ak-beratung`             | `ak-beratung/+page.svelte` | `src/pages/ak-beratung.astro`                             | Static                                                                       |
| `/blog`                    | _see Phase 6_              | `src/pages/blog/index.astro`                              | Collection                                                                   |
| `/blog/[slug]`             | _see Phase 6_              | `src/pages/blog/[...slug].astro`                          | Collection                                                                   |
| `/buecher-broschueren`     | `+page.ts` redirect        | `redirects:` in `astro.config.ts` → `/infothek#literatur` |
| `/eakbg-anspruch`          | `+page.svelte`             | `src/pages/eakbg-anspruch.astro`                          | Static                                                                       |
| `/eakbg-planer`            | `+page.svelte` (2270 LOC)  | `src/pages/eakbg-planer.astro` + Svelte island            | **Island** — see below                                                       |
| `/faq`                     | `+page.svelte`             | `src/pages/faq.astro`                                     | Mostly static; `<details>` stays inline                                      |
| `/fzb-anspruch`            | `+page.svelte`             | `src/pages/fzb-anspruch.astro`                            | Static                                                                       |
| `/impressum-datenschutz`   | `+page.svelte`             | `src/pages/impressum-datenschutz.astro`                   | Static                                                                       |
| `/infothek`                | `+page.svelte`             | `src/pages/infothek.astro`                                | Static (anchor sections)                                                     |
| `/pauschales-kbg`          | `+page.svelte`             | `src/pages/pauschales-kbg.astro`                          | Static                                                                       |
| `/reaktionen-und-feedback` | `+page.svelte`             | `src/pages/reaktionen-und-feedback.astro`                 | Static                                                                       |
| `/tools`                   | redirect                   | `redirects:` → `/infothek#tools`                          |
| `/ueber`                   | `+page.svelte`             | `src/pages/ueber.astro`                                   | Static                                                                       |
| `/unbezahlte-karenz`       | `+page.svelte`             | `src/pages/unbezahlte-karenz.astro`                       | Static                                                                       |
| `/videos`                  | redirect                   | `redirects:` → `/infothek#videos`                         |

**`eakbg-planer` island:**

- [x] Copy `src/routes/eakbg-planer/+page.svelte` → `src/lib/components/EaKbgPlaner.svelte` (landed in `src/lib/components/` instead of `src/components/eakbg/` — kept alongside other preserved Svelte components)
- [x] `NoteGrid.svelte`, `TimelineSummary.svelte`, `EligibilityPanel.svelte`, `EligibilityCalculatorEaKbg.svelte`, `EligibiltyDateCalculator.svelte` — already in `src/lib/components/` from Phase 2 preservation
- [x] `src/pages/eakbg-planer.astro` renders `<EaKbgPlaner client:load />`
- [x] `@fontsource/ibm-plex-sans-condensed` loaded globally from `Layout.astro`

**Mechanical conversion rules:**

- `$props()` / `export let data` → `Astro.props` or inline constants
- `{#each}` → `{items.map(...)}`
- `{#if}` → `{cond && (...)}` or ternary
- `onclick={}` / `bind:` → inline `<script>` islands or `client:*` directives
- `<svelte:head>` → pass `title`/`description` as props to `<Layout>`
- `class:foo={bar}` → template literal in `class=`
- `$lib/...` → `~/...` (AstroWind alias) or relative

**Trailing slash:** set `trailingSlash: 'always'` + `build.format: 'directory'` in `astro.config.ts` so URLs like `/blog/` still emit `blog/index.html`.

**Commit suggestion:** one commit per 2–3 pages (`feat: port static info pages`, `feat: port home and planer`).

---

## Phase 6 — Migrate blog to Astro Content Collections

**Status:** ☐ not started

- [ ] **`src/content.config.ts`** (Astro 5):

   ```ts
   import { defineCollection, z } from 'astro:content';
   import { glob } from 'astro/loaders';

   const blog = defineCollection({
     loader: glob({ pattern: '**/*.md', base: 'src/content/blog' }),
     schema: z.object({
       title: z.string(),
       pubDate: z.coerce.date(),
       slug: z.string(),            // frontmatter slug preserved for URL stability
       description: z.string().optional(),
     }),
   });

   export const collections = { blog };
   ```

- [ ] **Keep** `src/content/blog/*.md` in place — no body edits needed (plain markdown + HTML).
  - [ ] **Fix date typo** in `2026-01-28-mutter-startet-volksbegehren.md`: `pubDate: 2028-01-28` → `2026-01-28`.

- [ ] **Dynamic route** `src/pages/blog/[...slug].astro` — slug must come from frontmatter, not filename:

   ```astro
   ---
   import { getCollection, render } from 'astro:content';
   import Layout from '~/layouts/Layout.astro';  // PageLayout.astro was deleted in Phase 5 cleanup

   export async function getStaticPaths() {
     const posts = await getCollection('blog');
     return posts.map((post) => ({
       params: { slug: post.data.slug },
       props: { post },
     }));
   }
   const { post } = Astro.props;
   const { Content } = await render(post);
   ---
   <Layout metadata={{ title: post.data.title, description: post.data.description }}>
     <article class="prose prose-slate mx-auto max-w-3xl">
       <h1>{post.data.title}</h1>
       <time datetime={post.data.pubDate.toISOString()}>
         {post.data.pubDate.toLocaleDateString('de-AT')}
       </time>
       <Content />
     </article>
   </Layout>
   ```

- [ ] **Index** `src/pages/blog/index.astro` — port markup from `src/routes/blog/+page.svelte`:

   ```ts
   const posts = (await getCollection('blog'))
     .sort((a, b) => b.data.pubDate.getTime() - a.data.pubDate.getTime());
   ```

- [ ] **Port `PostCard` + `PostGrid`** as `.astro` components in `src/components/blog/`.
- [ ] **Teaser generation:** replace SvelteKit's `toTeaser()` with `post.body.slice(0, 100)` helper, or use a remark excerpt plugin. Document the choice.
- [ ] **Home page latest posts:** mirror `.slice(0, 9)` logic in `index.astro` frontmatter.

**URL preservation check:**

- [ ] Render all 9 posts' URLs (`/blog/<slug>/`) resolve
- [ ] Cross-post link `/blog/antwort-presseanfrage-oegk-unbezahlte-karenz-mitversicherung/` resolves

**Trailing-slash verification (added 2026-04-19):**

Dev server showed a `trailingSlash` overlay for `/ak-beratung/` — cause was a stale dev process still holding pre-Phase-5 config (default `'ignore'`, which Astro's dev overlay surfaces as "never" when mismatched). Our `astro.config.ts` has had `trailingSlash: 'always'` + `build.format: 'directory'` since commit `3afb505`. Validate end-to-end now that more URL-emitting code (blog) exists:

- [ ] Restart dev server (`npm run dev`) after any `astro.config.ts` change — config is read once at startup, not watched.
- [ ] Dev: `http://localhost:PORT/blog/` and `http://localhost:PORT/blog/<slug>/` resolve without the trailingSlash overlay.
- [ ] Build: every `dist/<route>/index.html` exists (no bare `dist/<route>.html`).
- [ ] Internal links in ported pages all include the trailing `/` (spot-checked during Phase 5; re-verify after blog is wired).
- [ ] Sitemap entries end with `/`.
- [ ] The 3 redirects (`/buecher-broschueren`, `/tools`, `/videos`) still resolve to `/infothek/#…` anchors.

**Commit:** `feat: migrate blog to Astro Content Collections`

---

## Phase 7 — Assets, styles, Tailwind reconciliation

**Status:** ☐ not started

**Assets:**

- [ ] Move `static/*` → `public/`: keep `.htaccess`, `robots.txt`, `.nojekyll`, `hero_karenz_wizard.jpg`, `blog-images/`, `infothek/`, `ak_*.jpg`, `meme_*.jpg`.
- [ ] Delete unused AstroWind placeholder images in `public/`.
- [ ] Move `src/lib/assets/logo.png` + `favicon.ico` → `public/` (or `src/assets/` for Astro image optimization).

**Tailwind 3 downgrade:**

- [ ] Convert `@import "tailwindcss"` in CSS → `@tailwind base; @tailwind components; @tailwind utilities;`
- [ ] Convert `@plugin '@tailwindcss/forms'` / `@plugin '@tailwindcss/typography'` → `plugins: [require('@tailwindcss/forms'), require('@tailwindcss/typography')]` in `tailwind.config.js`
- [ ] `:root` custom props stay as plain CSS (fine with Tailwind 3).

**Font:**

- [ ] `@fontsource/ibm-plex-sans-condensed` — move `@import` lines from `eakbg-planer/+page.svelte:4-5` to global CSS.

**Commit:** `chore: port assets and reconcile tailwind to v3`

---

## Phase 8 — Sitemap + redirects + build config

**Status:** ☐ not started

- [ ] Add `@astrojs/sitemap` integration
- [ ] Set `trailingSlash: 'always'` + `build.format: 'directory'`
- [ ] Declare `redirects:` for `/buecher-broschueren`, `/tools`, `/videos`

```ts
// astro.config.ts
import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

export default defineConfig({
  site: 'https://karenz-wizard.at',
  trailingSlash: 'always',
  build: { format: 'directory' },
  integrations: [sitemap(), /* ...AstroWind existing */],
  redirects: {
    '/buecher-broschueren': '/infothek#literatur',
    '/tools': '/infothek#tools',
    '/videos': '/infothek#videos',
  },
});
```

**Commit:** `chore: replace svelte-sitemap with @astrojs/sitemap integration`

**Verify:**

- [ ] `dist/sitemap-index.xml` + `dist/sitemap-0.xml` exist after build.

---

## Phase 9 — Cleanup, typecheck, smoke test

**Status:** ☐ not started

- [ ] Delete Svelte-specific config leftovers (`.prettierrc` svelte plugin entry, `.prettierignore` svelte paths, stale `.vscode/` Svelte extension recs).
- [ ] **Update `AGENTS.md`:**
  - [ ] "Svelte v5 + adapter-static site" → "Astro + AstroWind static site (German-only)"
  - [ ] Replace "Svelte 5 Conventions" → Astro equivalents
  - [ ] **Keep all a11y + layout rules** (still binding)
- [ ] Update `README.md` with new dev commands + Astro/AstroWind references.
- [ ] `.htaccess` comment mentions SvelteKit hashing — update to mention Astro.
- [ ] Run: `npm install && npx astro check && npm run build && npm run preview`

**Manual smoke checklist:**

- [ ] `/` renders, hero image loads, CTA cards link correctly
- [ ] All 14 top-level routes reachable, each 200 and shows one `<h1>`
- [ ] Blog index lists 9 posts in desc date order
- [ ] Each blog post renders at its preserved slug
- [ ] `/buecher-broschueren/`, `/tools/`, `/videos/` redirect to `/infothek#…`
- [ ] Skip link visible on tab, focus lands on `<main>`
- [ ] Mobile menu open/close + body scroll lock
- [ ] Umami script present in `<head>`
- [ ] `/sitemap-index.xml` valid
- [ ] No horizontal overflow on pages with full-bleed sections
- [ ] `data-layout="home"` only on `/`, `"subpages"` elsewhere
- [ ] `<html lang="de-AT">` everywhere
- [ ] `eakbg-planer` island hydrates and works (date calculations, timeline)

**Commit:** `chore: finalize astrowind migration, update docs`

---

## Critical files for reference during implementation

- `/home/user/karenz-wizard/package.json`
- `/home/user/karenz-wizard/astro.config.ts` (new, from AstroWind)
- `/home/user/karenz-wizard/src/layouts/Layout.astro` (edit for `data-layout`/skip link/umami)
- `/home/user/karenz-wizard/src/content.config.ts` (new — collection schema)
- `/home/user/karenz-wizard/src/pages/blog/[...slug].astro` (new — uses frontmatter slug)
- `/home/user/karenz-wizard/AGENTS.md` (update in Phase 9 but **keep a11y rules**)

## Risks recap

- **Tailwind v4 → v3 downgrade** = confirmed trade-off
- **`eakbg-planer` island** adds a Svelte runtime to one page (~30KB gzipped) — acceptable
- **Static redirects** use `<meta http-equiv="refresh">` — SEO-friendly but not 308; hash fragments pass through
- **URL preservation** hinges on `trailingSlash: 'always'` + `build.format: 'directory'` + frontmatter-slug in `getStaticPaths`
- **Dead code confirmed:** `wx-svelte-gantt`, `GanttMinimalDemo.svelte`, `demo.svelte`, `eakbg-anspruch/page.backup.svelte`, `src/lib/server/blog.ts`
