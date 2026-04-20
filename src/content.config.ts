// Astro 5 Content Collections config.
// Lives at src/content.config.ts (the Astro 5 canonical location),
// NOT src/content/config.ts.
//
// Blog posts live at src/content/blog/*.md with frontmatter:
//   { title: string, pubDate: date, slug: string, description?: string }
// The slug field is the SOURCE OF TRUTH for URLs — preserves stability
// across filename refactors (this is why getStaticPaths in
// src/pages/blog/[...slug].astro uses post.data.slug, not post.id).

import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const blog = defineCollection({
  loader: glob({ pattern: '**/*.md', base: 'src/content/blog' }),
  schema: z.object({
    title: z.string(),
    pubDate: z.coerce.date(),
    slug: z.string(),
    description: z.string().optional(),
  }),
});

export const collections = { blog };
