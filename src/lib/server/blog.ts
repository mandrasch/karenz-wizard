import type { Component } from 'svelte';

export type BlogFrontmatter = {
	title: string;
	pubDate: string;
	slug: string;
	description?: string;
};

export type BlogSummary = BlogFrontmatter & {
	source: string;
	teaser: string;
};

type BlogModule = {
	default: Component;
	metadata?: Partial<BlogFrontmatter>;
};

type BlogRecord = {
	path: string;
	module: BlogModule;
	metadata: BlogFrontmatter;
};

export type BlogArticle = BlogSummary & {
	component: Component;
};

const blogModules = import.meta.glob<BlogModule>('/src/content/blog/*.md', { eager: true });
const blogSources = import.meta.glob<string>('/src/content/blog/*.md', {
	eager: true,
	as: 'raw'
});

const isFrontmatterComplete = (
	metadata?: Partial<BlogFrontmatter>
): metadata is BlogFrontmatter => {
	return Boolean(metadata?.title && metadata?.pubDate && metadata?.slug);
};

const collectRecords = (): BlogRecord[] => {
	const records: BlogRecord[] = [];

	for (const [path, module] of Object.entries(blogModules)) {
		if (!isFrontmatterComplete(module?.metadata)) continue;
		records.push({ path, module, metadata: module.metadata });
	}

	return records;
};

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

export const getBlogSummaries = (): BlogSummary[] => {
	return collectRecords()
		.map(({ path, metadata }) => ({
			...metadata,
			source: path,
			teaser: toTeaser(path)
		}))
		.sort((a, b) => new Date(b.pubDate).getTime() - new Date(a.pubDate).getTime());
};

export const getBlogEntries = (): string[] => {
	return collectRecords().map(({ metadata }) => metadata.slug);
};

export const getBlogArticle = (slug: string): BlogArticle | null => {
	for (const { path, module, metadata } of collectRecords()) {
		if (metadata.slug !== slug) continue;
		return {
			...metadata,
			source: path,
			component: module.default,
			teaser: toTeaser(path)
		};
	}

	return null;
};
