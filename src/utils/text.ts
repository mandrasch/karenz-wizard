// Small text-normalization helpers.
//
// Frontmatter is data, not HTML: Astro escapes `&` when interpolating it, so
// an HTML entity like `&shy;` would show up literally (`&amp;shy;`). These
// helpers let authors keep the readable entity in YAML while the build turns
// it into the actual soft hyphen character (U+00AD).

export const SOFT_HYPHEN = '\u00ad';

/** `Heraus&shy;forderung` -> `Heraus\u00ADforderung` */
export const decodeShy = (value: string): string => value.replace(/&shy;/gi, SOFT_HYPHEN);

/** Remove soft hyphens entirely (e.g. for the OG image canvas). */
export const stripShy = (value: string): string => value.replace(/&shy;|\u00ad/gi, '');
