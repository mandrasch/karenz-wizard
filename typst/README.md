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
typst compile --font-path typst/fonts typst/ratgeber-vaeterkarenz.typ
```

`typst` is provided by the pinned `@flukxr/typst-cli` devDependency
(npm puts `node_modules/.bin` on `PATH` inside npm scripts).
`--font-path typst/fonts` makes the vendored fonts available.

For live rebuilding while editing:

```sh
npm run pdf:ratgeber:watch
```

Open `typst/ratgeber-vaeterkarenz.pdf` in a PDF viewer; it refreshes
after each save.

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

Update to the latest stable Typst:

```sh
npm install --save-dev --save-exact @flukxr/typst-cli@latest
npm run pdf:ratgeber
```

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

The npm package supports macOS, Linux, and Windows on x64 and arm64.
The npm script uses no POSIX-specific shell syntax, so it also works in
native Windows `cmd`/PowerShell.

Only the macOS path is currently tested locally; CI runs on
`ubuntu-latest`.

## Fonts

`typst/fonts/` contains the vendored fonts (loaded via
`--font-path typst/fonts`):

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

`.github/workflows/build-pdf-ratgeber-preview.yml` builds the PDF on
every pull request that touches `typst/**` or the npm manifest/lockfile
(and can be run manually via `workflow_dispatch`). It runs `npm ci` and
`npm run pdf:ratgeber`, using the same pinned `@flukxr/typst-cli`
version as local development. The resulting
`ratgeber-vaeterkarenz.pdf` is uploaded as a build artifact
(`ratgeber-vaeterkarenz-pdf`), so reviewers can download and check the
rendered PDF without a local Typst setup.

The deploy workflow (`build-and-deploy.yml`) uses the same npm script
and copies the PDF to `public/pdf-ratgeber/` before the Astro build.
