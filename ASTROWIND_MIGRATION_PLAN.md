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

**Status:** ✅ done (commit `eaa79d7`, 2026-04-19) — 23 pages total (was 13); all 9 blog slugs preserved; home latest-posts section wired; `astro check` clean (0/0/0).

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

**URL preservation note:** trailing-slash verification moved to Phase 7 (see below) — user still sees the dev overlay after dev-server restart, so it's a real bug not just stale state, and deserves its own investigation.

**Commit:** `feat: migrate blog to Astro Content Collections`

---

## Phase 7 — Assets, styles, Tailwind reconciliation

**Status:** ✅ done (commits `a665fde`, `adb9439`, 2026-04-19) — 24 pages built, `astro check` clean (0/0/0), in-browser verification via Chrome MCP at desktop + mobile widths.

**Known-broken at entry:** `http://localhost:*/hero_karenz_wizard.jpg` 404s (home hero image). Ported pages also reference `/ak_*.jpg`, `/ak_wien_ottakring_*.jpg`, `/ak_video_thumbnail_*.jpg`, `/infothek/*.jpg`, `/meme_*.jpg` from the old `static/` dir. All fixed once `static/*` → `public/` move below completes.

**Assets:**

- [x] Move `static/*` → `public/`: `.htaccess`, `robots.txt`, `.nojekyll`, `hero_karenz_wizard.jpg`, `blog-images/`, `infothek/`, `ak_*.jpg`, `meme_*.jpg`. Deleted conflicting AstroWind leftovers `public/_headers` (Netlify-specific) and `public/decapcms/` (AstroWind demo CMS).
- [x] Delete unused AstroWind placeholder images — done in Phase 5 cleanup (`5438f54`); no placeholders left in `public/` after the move.
- [ ] Move `src/lib/assets/logo.png` + `favicon.ico` → `public/` — **skipped**: `src/lib/assets/logo.png` works fine via Astro's import system with hash-suffixed output. Not worth breaking the import chain just for cosmetic relocation.
- [x] Verify each image reference in ported `.astro` pages resolves — all 12 paths under `public/` confirmed.

**Trailing-slash bug investigation (carried over from Phase 6):**

Root cause: AstroWind's vendor integration at `vendor/integration/index.ts:35` calls `updateConfig({ trailingSlash: SITE.trailingSlash ? 'always' : 'never' })`, silently overriding our top-level `trailingSlash: 'always'` from `astro.config.ts`. The `SITE.trailingSlash` value came from `src/config.yaml` which shipped with `trailingSlash: false`.

Fix (commit `a665fde`): flipped `src/config.yaml` `trailingSlash: false` → `true` so both layers agree on `'always'`. Added inline comment at the YAML line explaining the coupling.

- [x] Confirmed no shadowing config files (only `astro.config.ts`, no `.mjs` / `.js`).
- [x] Identified vendor integration as the override source (grep in vendor/).
- [x] Verified via browser: `/ak-beratung/` now loads without the overlay.
- [x] Verified via build: `dist/ak-beratung/index.html` exists (directory format preserved).
- [x] Internal links spot-checked: nav + footer use trailing `/`.
- [x] The 3 redirects still resolve to `/infothek/#…`.

**Tailwind 3 downgrade:** already done as side-effect of Phase 3 scaffold.

- [x] `@tailwind base; @tailwind components; @tailwind utilities;` directives present in `src/assets/styles/tailwind.css` (no v4 `@import "tailwindcss"` anywhere).
- [x] `plugins: [typographyPlugin, …]` declared via JS import in `tailwind.config.js` (no v4 `@plugin` directives).
- [x] `:root` custom props in `kw.css` are plain CSS.
- `@tailwindcss/forms` listed in deps but **not** wired into the plugin list; all form elements live in Svelte islands that style their own inputs, so no forms-plugin reset is needed. Leaving unwired to avoid a visual regression.

**Font:**

- [x] `@fontsource/ibm-plex-sans-condensed` loaded once globally from `Layout.astro` (done in Phase 4, covers the eakbg-planer island — the 400/600 weight imports inside the old Svelte source were dropped when the component was copied in Phase 5).

**Commit:** `chore: port assets and reconcile tailwind to v3`

---

**Header/nav redesign (added 2026-04-19, user request):**

Our ported HeaderKW.astro is functional but flat (single-level nav). User wants AstroWind-demo-style dropdowns + CTA button, plus a structural regrouping of the menu. Reference: AstroWind's deleted `src/components/widgets/Header.astro` had multi-level nav with dropdowns + a right-side CTA button — we can recover that structure from the pre-migration `/tmp/astrowind-template/` clone OR from git via `git show d56c54d:src/components/widgets/Header.astro`.

Scope for this sub-phase:

- [x] **A. Dropdown "Karenz Schritt für Schritt planen"** (commit `adb9439`). Final children are `eaKBG Anspruch?` + `eaKBG Planer` only — `AK-Beratung` moved into the "Beratungen" dropdown per Task D. Click-to-open on desktop (aria-expanded + outside-click + Escape close), `<details>`/`<summary>` on mobile.
- [x] **B. Fix header layout bug** (commit `a665fde`). Root cause was `h-12.5 w-12.5` — Tailwind v3 doesn't accept fractional class names, so no CSS applied and the `<img>` fell back to its intrinsic 1024+px size. Replaced with arbitrary value `h-[3.125rem] w-[3.125rem]` to preserve original intent.
- [x] **C. Right-side CTA "Planer starten"** → `/eakbg-planer/` (commit `adb9439`). `rounded-full`, brand `#C94D54`, visible md+ in header row, also rendered at the bottom of the mobile overlay.
- [x] **D. `/oegk-beratung/` + "Beratungen" dropdown** (commit `adb9439`). New page at `src/pages/oegk-beratung.astro` (placeholder "Inhalt in Arbeit"), `seo.ts` entry added, Footer `Menü` list updated, top-level dropdown with `AK-Beratung` + `ÖGK-Beratung`.

**Incidental bugs fixed along the way:**

- [x] Dropdown panel empty on desktop: static-position `<header>` meant `z-50` had no effect; `<main>`'s descendants painted above the absolutely-positioned dropdown panel. Fixed by promoting header to `position: relative`.
- [x] Mobile menu visible by default: had both the `hidden` HTML attribute and the `flex` Tailwind class — `.flex` won on source-order tie. Switched to `hidden`/`flex` class swap via JS.
  - [ ] Update Footer "Menü" list too.

**Implementation notes:**

- Port AstroWind's dropdown JS/CSS — it's in the deleted `src/components/widgets/Header.astro` + `src/components/common/ToggleMenu.astro`. Recover via `git show d56c54d:...`. These work with Tailwind utility classes (`group-hover:` etc.), no extra JS needed for the hover state.
- Mobile menu currently renders as fullscreen dialog — dropdowns nest inside that; use `<details>`/`<summary>` for the expandable groups on small screens so everything stays keyboard-accessible without custom JS.
- Keep the `aria-expanded` state on dropdown triggers + `aria-controls` pointing at the submenu list. AGENTS.md a11y rules still apply.
- Update `seo.ts` with the new route, update the Footer's "Menü" list to match.

**Commit suggestion:** one commit per task (`feat: group planner steps under dropdown`, `fix: restore logo alignment`, `feat: add planner CTA button to header`, `feat: add oegk-beratung page and Beratungen dropdown`).

---

## Phase 8 — Sitemap + redirects + build config

**Status:** ✅ done (partially via Phases 3/5, completed commit `8cb85ce`, 2026-04-19) — `@astrojs/sitemap` already wired in Phase 3, `trailingSlash` + `build.format` landed Phase 5, redirects landed Phase 5. Only the `site:` URL + config.yaml vendor sync remained.

- [x] `@astrojs/sitemap` integration (shipped with AstroWind scaffold in Phase 3).
- [x] `trailingSlash: 'always'` + `build.format: 'directory'` (Phase 5 commit `3afb505`; config.yaml sync in Phase 7 commit `a665fde`).
- [x] `redirects:` for `/buecher-broschueren`, `/tools`, `/videos` (Phase 5 commit `65834a7`).
- [x] `site: 'https://karenz-wizard.at'` in both `astro.config.ts` and `src/config.yaml` (vendor override pattern — same as trailingSlash).

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

**Status:** ✅ done (commit `60fe3e6`, 2026-04-19) — AGENTS.md, README.md, .prettierrc, .prettierignore updated. Build + check clean.

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

## Phase 10 — Quality assurance (added 2026-04-19, user request)

**Status:** ✅ done (commit `fc5f340`, 2026-04-19) — audit clean, logo wrapped in home link, favicon restored to pre-migration wizard baby, sitemap diff against live confirms all URLs accounted for.

Post-migration QA sweep. Surfaces lingering compatibility gaps and URL-preservation regressions that might be lurking after Phases 2–9.

### 1. Tailwind v3 vs v4 syntax audit

Our pre-migration site ran Tailwind v4, which accepts class syntax v3 doesn't. One example already caught: `h-12.5 w-12.5` in HeaderKW (commit `a665fde`). Systematically scan for other cases:

- [ ] Search `src/` + `src/lib/components/*.svelte` + ported pages for fractional class names (regex: `\b[hwmpgxy]-\d+\.\d+`). These are Tailwind v4 native — in v3 they need arbitrary-value form `h-[…]`.
- [ ] Search for v4-only modifiers/variants: `starting:`, `not-*`, `nth-*`, advanced color-mix utilities (`bg-red-500/25`-style works in both, but `color-mix(...)` as a utility does not).
- [ ] Search for `@layer` / `@apply` used inside component `<style>` blocks imported as modules — Phase 4 already hit this crash, but Svelte island styles may still use it.
- [ ] Spot-check a built HTML for each route: any visible class that renders with no CSS is a v3 miss. Candidate regex on `dist/*.html`: `class="([^"]*(\b[hwmpgxy]-\d+\.\d+)[^"]*)"`.
- [ ] Inspect the eakbg-planer Svelte island's computed styles in Chrome DevTools after hydration — that's the largest LOC surface and most likely to carry v4 patterns.

### 2. Header logo → home link

Task: wrap the header logo `<img>` in an `<a href="/">` so clicking it navigates home. Currently only the "Karenz Wizard" text is a link; the logo sits beside it as a bare image.

- [ ] Edit `src/components/widgets/HeaderKW.astro`: combine the logo + text into a single `<a href="/">` wrapping both, or give the logo its own `<a href="/" aria-label="Startseite">`. Keep the existing alt text on the `<img>`.
- [ ] Verify: click logo from any subpage → lands on `/`.

### 3. Favicon check

- [ ] Inspect which favicon the site actually serves at `/favicon.ico` + `<link rel="icon">` tags. Repo has at least three candidates on disk:
      - `public/` (no explicit favicon we moved there; would 404)
      - `src/assets/favicons/favicon.{ico,svg}` + `apple-touch-icon.png` (from AstroWind scaffold; referenced by `src/components/Favicons.astro`)
      - `src/lib/assets/favicon.ico` (preserved from pre-migration SvelteKit site — our actual brand favicon with the wizard baby logo)
- [ ] Goal: the pre-migration `src/lib/assets/favicon.ico` (wizard baby) is what should render in the browser tab, not AstroWind's default favicon.
- [ ] Either move the preserved favicon to `public/favicon.ico` + `public/apple-touch-icon.png` (derived from `logo.png`), or update `src/components/Favicons.astro` to import from `~/lib/assets/favicon.ico`.
- [ ] Delete the AstroWind placeholder favicons at `src/assets/favicons/` once the replacement is live.
- [ ] Verify in browser: devtools → Network tab → check the 200 on favicon.ico matches the wizard baby graphic.

### 4. Sitemap URL audit against legacy

Task: fetch the pre-migration canonical sitemap from the live site and diff its URL list against what Astro generates now, so we catch any dropped routes before DNS cutover.

- [ ] `curl https://karenz-wizard.at/sitemap.xml` (or `sitemap-index.xml`) → extract all `<loc>` URLs.
- [ ] Run `npm run build` locally, extract `<loc>`s from `dist/sitemap-*.xml`.
- [ ] Diff the two lists. For any URL in the live sitemap but not ours: either add the route, add a redirect in `astro.config.ts`, or explicitly mark as intentionally removed.
- [ ] Common suspects to check: `/blog/feed.xml` (RSS — we dropped `@astrojs/rss` in Phase 5 cleanup), older blog-post slugs, any tag/category routes the SvelteKit blog loader may have emitted.

**Commit suggestion:** one commit per numbered section (`fix: arbitrary Tailwind values for v3 compatibility`, `feat: home link on header logo`, `chore: reconcile sitemap with legacy URL list`).

---

## Phase 11 — Menu re-structure (added 2026-04-19, user request)

**Status:** ✅ done (commit `7d1c513`, 2026-04-19) — nav renamed + 3 new dropdowns, Eltern-Teilzeit page created, footer Menü synced. Build: 25 pages. Check: 0/0/0.

Second nav refactor on top of Phase 7's dropdowns. Regroups two more top-level items into new dropdown categories so the desktop nav stays compact as more content lands.

### 1. Rename + extend "Karenz Schritt für Schritt planen"

- [ ] Rename the dropdown label from `Karenz Schritt für Schritt planen` to `Erste Jahre nach Geburt planen` (shorter + clearer).
- [ ] Add a third child: `Eltern-Teilzeit 20h/20h Woche`, linking to a new page `/elternteilzeit-20-20/`.
- [ ] Create `src/pages/elternteilzeit-20-20.astro` (placeholder minimum: 3-sentence intro explaining how both parents going to 20h/week works as a split-parenting option after the 14-month eaKBG window, followed by embedded `https://www.youtube.com/watch?v=sepdrZagF98`). Skeleton copy OK, user can flesh out later.
- [ ] Add `/elternteilzeit-20-20/` entry to `src/utils/seo.ts`.
- [ ] Resulting children of the group: `eaKBG Anspruch?`, `eaKBG Planer`, `Eltern-Teilzeit 20h/20h Woche`.

### 2. "Papamonat" group

- [ ] New top-level dropdown `Papamonat` containing: `FZB Anspruch? (Papamonat)` (move out of top-level).
- [ ] Note: currently a single-child dropdown. If more Papamonat content lands later (a dedicated FAQ, info page, etc.), it goes here. Alternatively, keep as flat top-level link and revisit when there's 2+ children.

### 3. "Weitere Infos" group

- [ ] New top-level dropdown `Weitere Infos` containing: `Infothek` + `Pauschales KBG` (move both out of top-level).

**Resulting top-level nav** (after all regroupings from Phase 7 + 11):

1. `Erste Jahre nach Geburt planen` ▾ (eaKBG Anspruch? / eaKBG Planer / Eltern-Teilzeit 20h/20h Woche)
2. `Papamonat` ▾ (FZB Anspruch?)
3. `Beratungen` ▾ (AK-Beratung / ÖGK-Beratung)
4. `Weitere Infos` ▾ (Infothek / Pauschales KBG)
5. `Blog`
6. CTA button: `Planer starten` → `/eakbg-planer/`

Mobile-only items stay the same (FAQ, Über, Reaktionen & Feedback, Impressum & Datenschutz).

- [ ] Update `src/components/widgets/HeaderKW.astro` `navItems` array.
- [ ] Update `src/components/widgets/FooterKW.astro` "Menü" list if changed.
- [ ] Build + verify active-state propagation (`groupIsActive` still underlines the correct group when visiting a child page).

**Commit:** `feat: regroup nav with Papamonat and Weitere Infos dropdowns`

---

## Phase 12 — Visual re-design toward AstroWind demo (added 2026-04-19, user request)

**Status:** ✅ done (commits `ac47876`, `f63a3da`, `9f33f4d`, 2026-04-19) — user moved this phase up and started with it; all three subsections shipped. Build green (24 pages), `astro check` clean.

Explore a visual refresh using AstroWind's default typography + blog layout + footer styling. AstroWind demo: https://astrowind.vercel.app.

### 1. Typography (drop IBM Plex Sans Condensed)

- [x] Removed `@fontsource/ibm-plex-sans-condensed` import from `Layout.astro`; uninstalled the dep.
- [x] Installed `@fontsource-variable/inter` (re-added — was dropped in Phase 5 cleanup); imported globally in `Layout.astro`.
- [x] Inline `<style is:inline>` in `Layout.astro` restores AstroWind's CSS vars (`--aw-font-sans/serif/heading` = `'Inter Variable'`, plus the color tokens `--aw-color-primary/secondary/accent` and `--aw-color-text-default/muted/bg-page`). Ported from `git show d56c54d:src/components/CustomStyles.astro`.
- [x] `tailwind.config.js` already had `fontFamily.sans/serif/heading` reading from those vars + `theme.extend.colors` mapping `primary`/`muted`/etc. to the CSS vars — no config change needed.
- [x] `src/lib/components/EaKbgPlaner.svelte`: `--planner-font` now reads from `var(--aw-font-sans, 'Inter Variable')`; dropped the separate `--planner-font-condensed`.
- [x] `HeaderKW.astro`: added `whitespace-nowrap` on nav labels + title + CTA — Inter is wider than the condensed font and was forcing two-line wrap. Tactical; Phase 11 regroup removes the need.

### 2. Blog post layout

Reference: https://astrowind.vercel.app/get-started-website-with-astro-tailwind-css

- [x] `src/pages/blog/[...slug].astro` re-styled after `git show d56c54d:src/components/blog/SinglePost.astro`:
  - Wrapper `<section class="mx-auto py-8 sm:py-16 lg:py-20">`.
  - Meta row: back link "Zurück zur Übersicht" left, date with inline clock SVG right.
  - H1: `font-heading text-4xl md:text-5xl font-bold leading-tight tracking-tight`.
  - Description: `text-xl md:text-2xl text-muted`.
  - Horizontal rule divider between header and body.
  - Prose stack: `prose prose-slate prose-lg prose-headings:font-heading prose-headings:font-bold prose-headings:leading-tight prose-headings:tracking-tight prose-a:text-primary prose-img:rounded-md prose-img:shadow-lg prose-headings:scroll-mt-[80px] prose-li:my-0`.
- [x] Dropped AstroWind features not in our schema: tags, social share, hero image, reading time, author, category. Dark-mode variants skipped (we're light-only).
- Hero image on posts stays out of scope — schema has no image field yet; add later if/when a post actually needs one.

### 3. Footer styling

- [x] `src/components/widgets/FooterKW.astro` re-styled after `git show d56c54d:src/components/widgets/Footer.astro`. Content preserved (Social Media / Über das Projekt / Open Source, Menü, Diversity + Barrierefreiheit + Solidarität, Kontakt & Feedback + Disclaimer, plus the pre-grid ⚠️ disclaimer card).
- [x] Container `max-w-7xl mx-auto` + 12-col grid; brand column `col-span-4/lg`, content columns `col-span-3` or `col-span-2/3`. Single column on narrow screens.
- [x] Adopted `not-prose` wrapper + `border-t border-gray-200` top border; vertical `py-8 md:py-12`.
- [x] Column titles: `font-medium mb-2` (was `text-sm font-semibold text-slate-900`).
- [x] Body text: `text-sm text-muted` for paragraphs, `text-xs text-muted` for the smaller disclaimers; `text-sm` for link lists.
- [x] Link hover chain: `text-muted transition duration-150 ease-in-out hover:text-gray-700 hover:underline`; primary links switched from `text-indigo-700` to `text-primary` (picks up `--aw-color-primary`).
- [x] Added "Karenz Wizard" brand link at the top of the left column (AstroWind convention).
- [x] Merged "Impressum" + "Datenschutz" footer menu items into one entry (same target).

**Risks to flag before starting:**

- Blog prose styles cascade through ALL blog posts — changing the prose variant may shift long-form content unexpectedly. Preview each post.
- Swapping fonts changes line-length and vertical rhythm across every route. Expect regressions on the `eakbg-planer` page where dates + timeline are laid out at specific widths — may need per-component overrides.
- The `AGENTS.md` typography/CLS rules (preload fonts or `font-display: swap`, no animations on route change) still apply. Re-read before committing.

**Commit suggestion:** one per section (`chore: swap IBM Plex for Inter variable`, `feat: AstroWind-style blog post layout`, `feat: AstroWind-style footer`).

---

## Phase 13 — Svelte 5 runes-syntax cleanup (mini follow-up, added 2026-04-19)

**Status:** ✅ done (commit `b5868ba`, 2026-04-19) — 22 Svelte compile warnings → 0. Planner interactivity verified (preset `8 + 6` → mother=8, father=6).

Surface: the Svelte compiler emits 11+ warnings when compiling `src/lib/components/EaKbgPlaner.svelte`. All non-blocking, all carried over from the verbatim copy of the pre-migration `src/routes/eakbg-planer/+page.svelte`. Cleaning them up gets the dev-server log quiet and modernizes the syntax to pure Svelte 5.

Already fixed by commit `2b09111` as part of the hydration bug fix:
- `state_referenced_locally` on line 67 — the `$state(jointMonth)` pattern was causing the runtime `effect_orphan` error.

### 1. `on:click` → `onclick` (14 instances)

Svelte 4 event-directive syntax. Still works in Svelte 5 but deprecated. Compiler error ref: https://svelte.dev/e/event_directive_deprecated

Occurrences (line numbers from current source):
- `EaKbgPlaner.svelte:940, 942, 946, 948, 952, 967, 981, 993, 1007, 1019, 1033, 1371, 1380, 1386`

- [ ] Replace each `on:click={handler}` with `onclick={handler}`.
- [ ] Spot-check event modifiers (`on:click|preventDefault={...}`) if any — those need conversion to `onclick={(e) => { e.preventDefault(); handler(e); }}` since Svelte 5 dropped the `|modifier` syntax.

### 2. Unused CSS selectors (7 instances)

Compiler removes orphan CSS rules and warns. Usually harmless but signals stale styles.

Occurrences:
- `.note-box .footnote` (line 1901)
- `.note-box a` (line 1905)
- `.planner-panel > .warning-banner` (line 1953)
- `.timeline-summary__birthdate label` (line 2237)
- `.timeline-summary__birthdate span` (line 2241)
- `.timeline-summary__table th` (line 2253)
- `.timeline-summary__table td` (line 2257)
- `.timeline-summary__table th[scope='row']` (line 2261)

- [ ] Either delete each unused rule, or adjust the markup if the rule was intended to apply (some may have been class-renamed during the Svelte 4→5 conversion before our Phase 5 copy).
- [ ] Verify no visual regression after removal.

### 3. Final verification

- [ ] Dev-server log after restart shows 0 Svelte warnings for `EaKbgPlaner.svelte`.
- [ ] `npm run check` still 0/0/0.
- [ ] Planner interactivity intact (preset `10 + 4` → mother=10, father=4; `+` / `-` mutate state; warning banners toggle).

**Commit:** `chore(phase 13): modernize EaKbgPlaner Svelte 5 syntax (on:click + stale CSS)`

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
