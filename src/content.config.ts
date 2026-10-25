// Astro 5 Content Collections config.
// Lives at src/content.config.ts (the Astro 5 canonical location),
// NOT src/content/config.ts.
//
// Blog posts live at src/content/blog/*.md with frontmatter:
//   { title: string, pubDate: date, slug: string, description?: string,
//     ogImage?: string }
// The slug field is the SOURCE OF TRUTH for URLs — preserves stability
// across filename refactors (this is why getStaticPaths in
// src/pages/blog/[...slug].astro uses post.data.slug, not post.id).

import { defineCollection, reference, z } from 'astro:content';
import { glob, file } from 'astro/loaders';

const authors = defineCollection({
  loader: file('src/data/authors.json'),
  schema: z.object({
    id: z.string(),
    name: z.string(),
    avatar: z.string(),
    bio: z.string(),
  }),
});

const blog = defineCollection({
  // .md for plain posts, .mdx for posts that embed Astro components
  // (e.g. <PrivacyEmbed> in the SRF/Einsamkeit post).
  loader: glob({ pattern: '**/*.{md,mdx}', base: 'src/content/blog' }),
  schema: z.object({
    title: z.string(),
    pubDate: z.coerce.date(),
    slug: z.string(),
    description: z.string().optional(),
    // Optional: overrides the auto-generated OG/social share image.
    // Absolute path to a file in public/ (NOT src/assets — social scrapers
    // need a stable, untransformed URL).
    // Recommended dimensions: 1200×630 px (1.91:1), PNG or JPEG, < ~1 MB.
    // Example: ogImage: /blog-images/my-custom-share.png
    ogImage: z.string().optional(),
    author: reference('authors').optional(),
    guestPost: z.boolean().optional(),
  }),
});

export const collections = { blog, authors };
