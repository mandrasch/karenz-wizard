// Ported from src/lib/server/blog.ts (pre-migration tag).
// Produces a short plain-text teaser from raw markdown body.
// Strips frontmatter, collapses whitespace, slices to `length` chars.

export const toTeaser = (body: string, length = 100): string => {
  const stripped = body.replace(/^---[\s\S]*?---\s*/, '');
  const clean = stripped.replace(/\s+/g, ' ').trim();
  if (clean.length <= length) return clean;
  return `${clean.slice(0, length).trim()}…`;
};
