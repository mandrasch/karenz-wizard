<script lang="ts">
	import '../app.css';
	import favicon from '$lib/assets/favicon.svg';

	import Header from '$lib/components/Header.svelte';
	import Footer from '$lib/components/Footer.svelte';

	// default slot in Svelte 5
	let { children } = $props();
</script>

<svelte:head>
	<link rel="icon" href={favicon} />
</svelte:head>

<div class="flex min-h-screen flex-col bg-white text-slate-900">
	<Header />

	<main class="mx-auto flex w-full max-w-[1200px] flex-1 flex-col px-6 pb-12">
		{@render children?.()}
	</main>

	<Footer />
</div>
