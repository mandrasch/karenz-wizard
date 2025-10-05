<!-- src/routes/+layout.svelte -->
<script lang="ts">
	import '../app.css';
	import favicon from '$lib/assets/favicon.svg';

	import Header from '$lib/components/Header.svelte';
	import Footer from '$lib/components/Footer.svelte';

	let { children } = $props();
	import { page } from '$app/stores';
</script>

<svelte:head>
	<link rel="icon" href={favicon} />
</svelte:head>

<div class="flex min-h-screen flex-col bg-white text-slate-900">
	<Header />

	<main
		class="mx-auto flex w-full flex-1 flex-col"
		class:max-w-[1200px]={$page.url.pathname !== '/'}
		class:px-6={$page.url.pathname !== '/'}
		class:pb-12={$page.url.pathname !== '/'}
	>
		{@render children?.()}
	</main>

	<Footer />
</div>
