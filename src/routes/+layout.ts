import type { LayoutLoad } from './$types';
import { getSeoMeta } from '$lib/seo';

export const prerender = true;

export const trailingSlash = 'always';

export const load = (({ url }) => {
	const layoutVariant = url.pathname === '/' ? 'home' : 'subpages';
	const seo = getSeoMeta(url.pathname);

	return { layoutVariant, seo };
}) satisfies LayoutLoad;
