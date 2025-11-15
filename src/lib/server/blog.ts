import type { Component } from 'svelte';

export type BlogFrontmatter = {
	title: string;
	pubDate: string;
	slug: string;
	description?: string;
};

export type BlogSummary = BlogFrontmatter & {
	source: string;
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

export const getBlogSummaries = (): BlogSummary[] => {
	return collectRecords()
		.map(({ path, metadata }) => ({ ...metadata, source: path }))
		.sort((a, b) => new Date(b.pubDate).getTime() - new Date(a.pubDate).getTime());
};

export const getBlogEntries = (): string[] => {
	return collectRecords().map(({ metadata }) => metadata.slug);
};

export const getBlogArticle = (slug: string): BlogArticle | null => {
	for (const { path, module, metadata } of collectRecords()) {
		if (metadata.slug !== slug) continue;
		return { ...metadata, source: path, component: module.default };
	}

	return null;
};
