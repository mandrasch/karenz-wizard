<!-- src/routes/+layout.svelte -->
<script lang="ts">
	import '../app.css';
	import favicon from '$lib/assets/favicon.svg';
	import Header from '$lib/components/Header.svelte';
	import Footer from '$lib/components/Footer.svelte';

	// Svelte 5 import
	import { page } from '$app/state';

	let { children } = $props();

	// rune-derived flag for homepage
	const isHome = $derived(page.url.pathname === '/');
</script>

<svelte:head>
	<link rel="icon" href={favicon} />
</svelte:head>

<div class="mb-10 flex min-h-screen flex-col bg-white text-slate-900">
	<Header />

	{#key isHome}
		{#if isHome}
			<main class="mx-auto mb-12 w-full">
				{@render children?.()}
			</main>
		{:else}
			<main class="mx-auto flex w-full max-w-[1200px] flex-1 flex-col px-6 pb-12">
				{@render children?.()}
			</main>
		{/if}
	{/key}

	<Footer />
</div>
