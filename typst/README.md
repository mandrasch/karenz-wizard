# Typst Guide

PDF guide "Wie man als Vater mehr als 2 Monate Karenz nimmt".
Source: `ratgeber-vaeterkarenz.typ`. Content is fed from
`src/data/steps.ts` and `src/pages/*.astro`.

## Ziele & Stil (für KI-Assistenten)

Leitlinien für jede Bearbeitung von `ratgeber-vaeterkarenz.typ`. Siehe
auch `../MANIFESTO.md` (Projektziele) und `../AGENTS.md` (Website-Regeln).

- **Kurz & knackig.** Lieber 1–2 prägnante Sätze als ein Absatz. Jede
  Option = kurzer Einstieg + ggf. Finanzbox + Link zum interaktiven Tool.
  Für Details auf karenz-wizard.at bzw. AK/ÖGK verweisen, nicht alles
  ausschreiben.
- **Leicht verständlich.** Du-Ansprache, lockerer Ton, Fachbegriffe sofort
  erklären (wie im "Crashkurs"). Inspiriert von den sipgate-Büchern
  (klare Hierarchie, viel Weißraum, freundlich).
- **Umweltfreundlich druckbar.** Keine großen Fotos, sparsam mit
  Farbflächen (Toner/Tinte schonen). Infoboxen bevorzugt mit linkem
  Farbbalken auf weißem Grund statt vollflächiger Füllung. Cover
  typografisch, ohne vollflächige Farbe.
- **Marke.** Akzentfarbe `#F99435` (orange), Schrift Inter. Maskottchen
  (`logo.png`) sparsam und klein einsetzen.
- **Faktische Sorgfalt.** Zahlen/Regeln (Beträge, Fristen, Gesetzeslage)
  sind heikel — bei Unsicherheit als TODO markieren statt raten; "Stand"
  und "ohne Gewähr" sind bereits im Dokument vermerkt.

## Build

```sh
npm install
npm run pdf:ratgeber
```

Produces `typst/ratgeber-vaeterkarenz.pdf` (gitignored).

The npm script runs:

```sh
typst compile --ignore-system-fonts --font-path typst/fonts \
  typst/ratgeber-vaeterkarenz.typ
```

`typst` is provided by the pinned `@flukxr/typst-cli` devDependency
(npm puts `node_modules/.bin` on `PATH` inside npm scripts).
`--font-path typst/fonts` makes the vendored fonts available, and
`--ignore-system-fonts` keeps _installed_ fonts out of the build: without
it Typst also uses fonts from the OS, so a machine with Inter installed
(say, the variable build) silently renders different headings than CI —
narrower text and no real bold face. Always pass both flags so local and
CI output match.

For live rebuilding while editing:

```sh
npm run pdf:ratgeber:watch
```

Open `typst/ratgeber-vaeterkarenz.pdf` in a PDF viewer; it refreshes
after each save.

### Website preview

The Ratgeber page expects the PDF at
`public/pdf-ratgeber/ratgeber-vaeterkarenz.pdf`:

```sh
npm run pdf:ratgeber
mkdir -p public/pdf-ratgeber
cp typst/ratgeber-vaeterkarenz.pdf public/pdf-ratgeber/ratgeber-vaeterkarenz.pdf
npm run dev
```

Open <http://localhost:4321/pdf-ratgeber/>.

(`mkdir -p` / `cp` above are POSIX shell. On native Windows use
`New-Item -ItemType Directory -Force public/pdf-ratgeber` and
`Copy-Item`.)

For a live rebuild directly into `public/` while the site is running:

```sh
npx --no-install typst watch --ignore-system-fonts --font-path typst/fonts \
  typst/ratgeber-vaeterkarenz.typ \
  public/pdf-ratgeber/ratgeber-vaeterkarenz.pdf
```

`npx --no-install` resolves the pinned binary from `node_modules/.bin`
and never downloads the unrelated `typst` package from the registry
(frozen at Typst 0.10).

Run `npm run dev` in a second terminal. The copied PDF is gitignored.

## Externe Pakete (QR-Codes)

Die QR-Codes (Helfer `videoqr` im `.typ`) nutzen das Typst-Universe-Paket
[`tiaoma`](https://typst.app/universe/package/tiaoma/)
(`#import "@preview/tiaoma:0.3.0"`). Beim **ersten** Compile lädt Typst das
Paket einmalig in seinen lokalen Cache (`~/.cache/typst/packages` bzw.
`~/Library/Caches/typst/packages`), danach offline nutzbar. Die CI
hat Netzzugang, also funktioniert es dort automatisch.

Wer komplett offline/reproduzierbar bauen will (analog zum gepinnten
Binary), kann das Paket lokal vendern und als `@local/tiaoma:0.3.0`
importieren — siehe den TinyTapeout-Mirror
(`github.com/TinyTapeout/typst-tiaoma`). QR rendert als reines
Schwarz-Weiß (toner-sparsam, passt zum Eco-Druck-Ziel).

## Typst via npm

The build uses the **official Typst CLI**, installed as a pinned npm
devDependency: [`@flukxr/typst-cli`](https://github.com/flukxr/typst-cli).
This is an unofficial npm distribution of the official Typst release
binaries; npm selects the matching prebuilt package for the current
OS/architecture (macOS, Linux, Windows; x64 and arm64).

- **Pinned version:** Typst **0.15.1** (`0.15.1-npm.0`).
- **Source binary:** the unchanged official asset from the Typst
  `v0.15.1` GitHub release.
- There is no project-local `.typst/` binary and no global install.

### Versioning & updating

`@flukxr/typst-cli` versions follow
`<typst-version>-npm.<packaging-revision>`: `0.15.1-npm.0` is the first
npm packaging of Typst 0.15.1, and `0.15.0-npm.2` is the third packaging
of Typst 0.15.0. The `-npm.N` suffix is a semver prerelease that changes
only when the npm packaging is rebuilt, not when Typst changes. See the
[package versioning docs](https://www.npmjs.com/package/@flukxr/typst-cli#versioning)
for details.

This repo pins the exact npm version (`0.15.1-npm.0`) in `package.json`
and `package-lock.json`. That keeps local builds and CI on the same
official Typst binary. Note that "same compiler" is not the same as
"byte-identical output": two builds of unchanged input still differ in
a few bytes (PDF `/ID` and related metadata), so don't diff PDF hashes
across runs — compare page count and rendering instead.

With an exact pin, `npm update @flukxr/typst-cli` does nothing. Update
deliberately to the latest stable Typst:

```sh
npm install --save-dev --save-exact @flukxr/typst-cli@latest
npm run pdf:ratgeber
```

If you only want packaging-only fixes within the same Typst release, use
a caret prerelease range and `npm update`:

```sh
npm install --save-dev "@flukxr/typst-cli@^0.15.1-npm.0"
npm update @flukxr/typst-cli
```

Because `0.15.1-npm.0` is a prerelease, `^0.15.1` does **not** match it,
and `^0.15.1-npm.0` only matches `0.15.1-npm.N`, not `0.15.2-npm.0`.

### Integrity / verification

The package records the expected binary and archive SHA-256 values in
its platform package metadata. npm provenance/attestations can be
checked with:

```sh
npm audit signatures
```

The binary hash can be compared against the official release asset:

```sh
node -p "require('@flukxr/typst-cli-darwin-arm64/package.json').typst.binarySha256"
shasum -a 256 node_modules/@flukxr/typst-cli-darwin-arm64/vendor/typst
```

(Adjust the platform package name for your OS/architecture.)

Why we accept the third-party packaging: the wrapper is pinned exactly,
installed from the lockfile with a `sha512` integrity hash, published
with registry signatures plus SLSA provenance from the maintainer's
GitHub Actions workflow, and it ships the unmodified official release
binaries (hash above). It has no `install`/`postinstall` scripts — the
only thing that executes is `node_modules/.bin/typst` when you build.
The residual risk is that `@flukxr/typst-cli` is a single-maintainer
project, not the Typst org; if that becomes unacceptable, the fallback
is `typst-community/setup-typst` in CI plus a manually downloaded
binary locally (what this repo did before).

### Why this and not the old npm wrapper?

- **npm `typst`:** an unmaintained community wrapper, frozen at Typst
  **0.10** (December 2023).
- **`typst.ts`:** a compiler toolkit for browser/Node integrations; its
  stable releases bundle their own Typst version and can lag behind
  upstream.
- **`@flukxr/typst-cli`:** redistributes the official CLI binary and
  tracks stable Typst releases, so `npm install` gives you the same
  compiler as the official download.

The `.typ` uses **current Typst features** (`context`, `table.header`
with a repeating header row, `par.spacing`) and therefore requires
**Typst ≥ 0.11** (tested with 0.15.1).

## OS compatibility

The npm package supports macOS, Linux, and Windows on x64 and arm64,
and the `pdf:ratgeber` / `pdf:ratgeber:watch` scripts are portable
(no POSIX-only syntax). Only the manual preview steps above (`mkdir -p`,
`cp`) assume a POSIX shell.

Only the macOS path is currently tested locally; CI runs on
`ubuntu-latest`.

## Fonts

`typst/fonts/` contains the vendored fonts (loaded via
`--font-path typst/fonts`, with `--ignore-system-fonts` so installed
system fonts never take precedence):

- **Inter** (v4.1, OFL) — the website's brand typeface.
- **Noto Emoji** (static, monochrome, OFL) — provides the 💰 / ⚠️
  glyphs. Note: monochrome, so the emojis take the surrounding text
  color. A variable Noto Emoji is _not_ used because Typst does not
  support variable fonts; colored emojis would need a color-emoji
  font.

For the VSCode Tinymist extension the font path is also set in
`.vscode/settings.json` (`tinymist.fontPaths`) so the live preview
uses the same fonts.

## CI

There is a single PR workflow, `.github/workflows/ci.yml`. It runs
`npm ci`, `npm run check`, `npm run pdf:ratgeber`, the Astro build (with
the PDF copied into `public/pdf-ratgeber/`), asserts that the key routes
and the PDF exist in `dist/`, and uploads `ratgeber-vaeterkarenz.pdf` as
the `ratgeber-vaeterkarenz-pdf` artifact so reviewers can check the
rendered PDF without a local Typst setup.

Because the PDF is compiled inside that job, the artifact under review
is the same file the deploy workflow ships. It replaces the separate,
path-filtered `build-pdf-ratgeber-preview.yml`: `npm ci` already
provides the toolchain and the compile takes ~0.3 s, so a second
workflow only duplicated work.

The deploy workflow (`build-and-deploy.yml`) uses the same npm script
and copies the PDF to `public/pdf-ratgeber/` before the Astro build.
It deliberately does **not** cache the compiled PDF: the compile takes
well under a second, while a cache key that misses an input (e.g. an
image in `typst/assets/`) silently ships a stale PDF — and the whole
reason the old cache existed was to skip `setup-typst`, which `npm ci`
now subsumes.

CI runs on a runner without Inter installed, so it always uses the
vendored fonts; `--ignore-system-fonts` in the npm scripts makes local
builds behave the same way.

The Typst-Universe package cache (`~/.cache/typst/packages`, see above)
is not cached in Actions, so a CI run needs network access to fetch
`@preview/tiaoma:0.3.0` if it is not already in the runner cache.
