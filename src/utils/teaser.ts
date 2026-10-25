// Ported from src/lib/server/blog.ts (pre-migration tag).
// Produces a short plain-text teaser from raw markdown/MDX body.
// Strips frontmatter and markup (including MDX imports/components, which
// would otherwise show up at the start of the body), collapses whitespace,
// and slices to `length` chars.

export const toTeaser = (body: string, length = 100): string => {
  const clean = body
    .replace(/^---[\s\S]*?---\s*/, '') // frontmatter
    .replace(/^\s*(?:import|export)\s+.*$/gm, ' ') // MDX ESM (component imports)
    .replace(/<[^>]+>/g, ' ') // JSX/HTML tags, incl. multi-line components
    .replace(/!\[[^\]]*\]\([^)]*\)/g, ' ') // images
    .replace(/\[([^\]]+)\]\([^)]*\)/g, '$1') // links -> link text
    .replace(/^#+\s*/gm, '') // heading markers
    .replace(/^>\s?/gm, '') // blockquote markers
    .replace(/[`*_~]/g, '') // inline emphasis/code markers
    .replace(/\s+/g, ' ')
    .trim();
  if (clean.length <= length) return clean;
  return `${clean.slice(0, length).trim()}…`;
};
