import type { PageServerLoad } from './$types';
import { getBlogSummaries } from '$lib/server/blog';

export const prerender = true;

export const load = (() => {
	return { posts: getBlogSummaries() };
}) satisfies PageServerLoad;
