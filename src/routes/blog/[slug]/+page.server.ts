import { error } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';
import { getBlogArticle, getBlogEntries } from '$lib/server/blog';

export const prerender = true;

export const entries = () => getBlogEntries().map((slug) => ({ slug }));

export const load = (({ params }) => {
	const article = getBlogArticle(params.slug);

	if (!article) {
		throw error(404, { message: 'Beitrag nicht gefunden' });
	}

	const { component: _component, ...safeArticle } = article;

	return {
		article: safeArticle,
		seo: {
			title: `${article.title} – Karenz Wizard Blog`,
			description: article.description ?? 'Aktueller Beitrag auf dem Karenz Wizard Blog.'
		}
	};
}) satisfies PageServerLoad;
