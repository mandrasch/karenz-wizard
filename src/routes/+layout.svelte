<!-- src/routes/+layout.svelte -->
<script lang="ts">
	import '../app.css';
	import favicon from '$lib/assets/favicon.svg';
	import Header from '$lib/components/Header.svelte';
	import Footer from '$lib/components/Footer.svelte';
	import { page } from '$app/state';

	import type { SeoMeta } from '$lib/seo';

	const { data, children } = $props<{
		data: {
			layoutVariant: string;
			seo: SeoMeta;
		};
	}>();

	const layoutVariant = $derived(data.layoutVariant ?? 'subpages');
	const fallbackSeo = data.seo;
	const seo = $derived((page.data?.seo as SeoMeta | undefined) ?? fallbackSeo);
</script>

<svelte:head>
	<title>{seo?.title ?? 'Karenz Wizard'}</title>
	{#if seo?.description}
		<meta name="description" content={seo.description} />
	{/if}
	<link rel="icon" href={favicon} />
	<!-- TODO: add fitting dimensions and more tags -->
	<meta property="og:image" content="https://karenz-wizard.at/hero_karenz_wizard.jpg" />
</svelte:head>

<div
	class="app-shell flex min-h-screen flex-col bg-white text-slate-900"
	data-layout={layoutVariant}
>
	<a class="skip-link" href="#main">Zum Inhalt springen</a>
	<Header />
	<main tabindex="-1" id="main" class="flex-1 pb-16 focus:outline-none" data-layout={layoutVariant}>
		<div class="page-grid">
			{@render children?.()}
		</div>
	</main>
	<Footer />
</div>
