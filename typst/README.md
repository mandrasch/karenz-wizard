# Typst Guide

PDF guide "Wie man als Vater mehr als 2 Monate Karenz nimmt".
Source: `ratgeber-vaeterkarenz.typ`. Content is fed from
`src/data/steps.ts` and `src/pages/*.astro`.

## Build

```sh
npm run pdf:ratgeber
```

Produces `typst/ratgeber-vaeterkarenz.pdf` (gitignored).

The npm script is:

```sh
PATH="$PWD/.typst:$PATH" typst compile --root . --font-path typst/fonts \
  typst/ratgeber-vaeterkarenz.typ
```

It prepends the project-local `.typst/` directory to `PATH`, so the
pinned local Typst binary is used (a globally installed `typst` would
act as a fallback only). `--root .` is required because the `.typ`
file lives in `typst/` but references the logo outside that folder
(`../src/lib/assets/logo.png`). `--font-path typst/fonts` makes the
vendored fonts available.

## Typst binary (`.typst/`)

The build uses a **prebuilt official Typst binary**, not npm and not
Homebrew. It lives at `.typst/typst` and is **gitignored** (it is
platform-specific and must not be committed).

### Where it comes from

It is the official prebuilt release binary from the Typst project:

- **Source:** `github.com/typst/typst`, release tag **`v0.14.2`**.
- **Asset:** `typst-aarch64-apple-darwin.tar.xz` (Apple Silicon /
  arm64). For Intel Macs use `typst-x86_64-apple-darwin.tar.xz`.
- It is compiled by the Typst team's CI, so no local llvm/rust build
  is needed and it runs on older macOS too.

Install/refresh it like this (Apple Silicon example):

```sh
curl -sL -o /tmp/typst.tar.xz \
  "https://github.com/typst/typst/releases/download/v0.14.2/typst-aarch64-apple-darwin.tar.xz"
tar -xJf /tmp/typst.tar.xz -C /tmp
mkdir -p .typst
cp /tmp/typst-aarch64-apple-darwin/typst .typst/typst
chmod +x .typst/typst
./.typst/typst --version   # -> typst 0.14.2 (b33de9de)
```

### Integrity / verification

The v0.14.2 GitHub release does **not** ship `.sha256` checksum files,
so there is no official published hash to diff against. The binary was
verified as follows:

- **Provenance (strongest available check):** the binary reports
  `typst 0.14.2 (b33de9de)`, and the official `v0.14.2` git tag points
  to commit `b33de9de113c91c184214b299bd7a8eb3070c3ab` — exact match,
  i.e. it was built from the official tagged source commit.
- **Transport integrity:** a fresh re-download of the asset produced a
  byte-identical binary (same SHA-256), ruling out download
  corruption.

Recorded SHA-256 values (Apple Silicon, v0.14.2):

```
binary  (.typst/typst)                  6ea59cf02d3cdfcc0e6fecb856fee3242807b6869a691d823d3ca213c6a941da
tarball (typst-aarch64-apple-darwin)    470aa49a2298d20b65c119a10e4ff8808550453e0cb4d85625b89caf0cedf048
```

Re-verify any time with:

```sh
shasum -a 256 .typst/typst   # expect 6ea59cf0...941da
./.typst/typst --version     # expect typst 0.14.2 (b33de9de)
```

### Why not Homebrew / npm?

- **Homebrew:** on macOS 13 (and other non-tier-1 configs) there is no
  prebuilt bottle, so `brew install typst` compiles `llvm` (~167 MB)
  and `rust` **from source** — hours of build time. Not viable here.
  On a current macOS with a bottle, `brew install typst` is fine and
  the npm script's PATH fallback would pick it up.
- **npm `typst`:** an unmaintained community wrapper, frozen at Typst
  **0.10** (December 2023). The official Typst project does not
  publish to npm.

The `.typ` uses **current Typst features** (`context`, `table.header`
with a repeating header row, `par.spacing`) and therefore requires
**Typst ≥ 0.11** (tested with 0.14.2). It will **not** build with the
old 0.10 npm wrapper.

## OS compatibility

Only the **macOS / prebuilt-binary** path is documented and tested.
The npm script uses POSIX shell syntax (`PATH="..." cmd`), which does
not work in native Windows `cmd`. For full cross-OS reproducibility
some adjustments would still be needed, e.g.:

- **mise/asdf:** pin the Typst version in `mise.toml` /
  `.tool-versions` → identical version on all platforms + CI.
- **Per-OS prebuilt binary:** download the matching official asset
  into `.typst/` (no global install), as done here for macOS arm64.
- Linux: `cargo install --locked typst-cli` or a distro package;
  Windows: `winget install Typst.Typst` / `scoop install typst`.

## Fonts

`typst/fonts/` contains the vendored fonts (loaded via
`--font-path typst/fonts`):

- **Inter** (v4.1, OFL) — the website's brand typeface.
- **Noto Emoji** (static, monochrome, OFL) — provides the 💰 / ⚠️
  glyphs. Note: monochrome, so the emojis take the surrounding text
  color. A variable Noto Emoji is *not* used because Typst does not
  support variable fonts; colored emojis would need a color-emoji
  font.

For the VSCode Tinymist extension the font path is also set in
`.vscode/settings.json` (`tinymist.fontPaths`) so the live preview
uses the same fonts.

## CI

No CI build at the moment. If wanted later: the
`typst-community/setup-typst` action (pinned version) →
`npm run pdf:ratgeber`.
