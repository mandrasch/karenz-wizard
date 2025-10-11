import type { LayoutLoad } from './$types';

export const prerender = true;

export const trailingSlash = 'always';

export const load = (({ url }) => {
	const layoutVariant = url.pathname === '/' ? 'home' : 'subpages';

	return { layoutVariant };
}) satisfies LayoutLoad;
