#!/usr/bin/env node
// One-off asset generator for the OG-image template.
// Run manually whenever the design changes:
//
//     node scripts/gen-og-assets.mjs
//
// Outputs (committed to src/assets/og/):
//   bg.png             — 1200×630 background: orange gradient, inset rounded
//                        navy frame (3 px stroke, 28 px inset, 20 px radius),
//                        "KARENZ-WIZARD.AT" watermark in lower-right.
//   wizard-shadow.png  — wizard-nobg.png composited with a soft drop-shadow
//                        (via an SVG feGaussianBlur+feOffset filter). Includes
//                        ~80 px transparent padding to accommodate the shadow.
//
// NOT part of the build pipeline. The generated PNGs are consumed by
// src/pages/blog/og/[slug].ts via astro-og-canvas.
import sharp from 'sharp';
import { readFile, writeFile } from 'node:fs/promises';
import path from 'node:path';

const OG_DIR = path.resolve('src/assets/og');

// ---------- 1. Background ----------
// Colours match the variant-4-blog.html design:
//   orange gradient #F9B868 → #E88A33, navy accent #1C2F3F.
// Watermark uses Inter in the SVG — librsvg falls back to system fonts when
// the named family isn't available, which is fine for the watermark.
const bgSvg = `<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="630" viewBox="0 0 1200 630">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0%" stop-color="#F9B868"/>
      <stop offset="100%" stop-color="#E88A33"/>
    </linearGradient>
  </defs>
  <rect width="1200" height="630" fill="url(#bg)"/>
  <!-- inset rounded frame -->
  <rect x="28" y="28" width="1144" height="574" rx="20" ry="20"
        fill="none" stroke="#1C2F3F" stroke-width="3" stroke-opacity="0.9"/>
</svg>`;

await sharp(Buffer.from(bgSvg)).png().toFile(path.join(OG_DIR, 'bg.png'));
console.log('✓ bg.png');

// ---------- 2. Wizard with drop-shadow ----------
// Asymmetric padding: astro-og-canvas places the logo at (padding, padding)
// from the card's top-left. The visible wizard must share its LEFT edge with
// the text paragraph below (which starts at exactly `padding`). So we keep
// left+top padding minimal (just enough to avoid clipping the soft shadow
// bleed) and put the bulk of the padding on the right+bottom where the
// offset+blurred shadow actually lands.
const wizardPath = path.join(OG_DIR, 'wizard-nobg.png');
const wizardMeta = await sharp(wizardPath).metadata();
const { width: wW, height: wH } = wizardMeta;
const PAD_LEFT = 6;
const PAD_TOP = 6;
const PAD_RIGHT = 60;
const PAD_BOTTOM = 60;
const canvasW = wW + PAD_LEFT + PAD_RIGHT;
const canvasH = wH + PAD_TOP + PAD_BOTTOM;

// Embed the wizard inside an SVG with an feGaussianBlur+feOffset filter.
// librsvg (sharp's SVG backend) supports this classic filter chain on Linux/CI.
const wizardB64 = (await readFile(wizardPath)).toString('base64');
const shadowSvg = `<svg xmlns="http://www.w3.org/2000/svg" width="${canvasW}" height="${canvasH}">
  <defs>
    <filter id="shadow" x="-20%" y="-20%" width="140%" height="140%">
      <feGaussianBlur in="SourceAlpha" stdDeviation="12"/>
      <feOffset dx="4" dy="18" result="offset"/>
      <feComponentTransfer>
        <feFuncA type="linear" slope="0.42"/>
      </feComponentTransfer>
      <feMerge>
        <feMergeNode/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>
  </defs>
  <image x="${PAD_LEFT}" y="${PAD_TOP}" width="${wW}" height="${wH}"
         href="data:image/png;base64,${wizardB64}"
         filter="url(#shadow)"/>
</svg>`;

await sharp(Buffer.from(shadowSvg)).png().toFile(path.join(OG_DIR, 'wizard-shadow.png'));
console.log('✓ wizard-shadow.png');
console.log('Done. Remember to clear node_modules/.astro-og-canvas before rebuilding.');
