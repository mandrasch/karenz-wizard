import type { PageServerLoad } from './$types';
import { getBlogSummaries } from '$lib/server/blog';

const blogSources = import.meta.glob<string>('/src/content/blog/*.md', {
	eager: true,
	as: 'raw'
});

const stripFrontmatter = (content: string) => {
	const match = content.match(/^---[\s\S]*?---\s*/);
	return match ? content.slice(match[0].length) : content;
};

const toTeaser = (source: string, length = 100) => {
	const raw = blogSources[source];
	if (!raw) return '';

	const clean = stripFrontmatter(raw).replace(/\s+/g, ' ').trim();
	if (clean.length <= length) return clean;
	return `${clean.slice(0, length).trim()}…`;
};

export const prerender = true;

export const load = (() => {
	const posts = getBlogSummaries()
		.slice(0, 9)
		.map((post) => ({
			...post,
			teaser: toTeaser(post.source)
		}));

	return { posts };
}) satisfies PageServerLoad;
