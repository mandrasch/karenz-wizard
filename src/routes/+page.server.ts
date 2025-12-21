import type { PageServerLoad } from './$types';
import { getBlogSummaries } from '$lib/server/blog';

export const prerender = true;

export const load = (() => {
	const posts = getBlogSummaries().slice(0, 9);

	return { posts };
}) satisfies PageServerLoad;
