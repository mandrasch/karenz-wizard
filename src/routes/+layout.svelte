<!-- src/routes/+layout.svelte -->
<script lang="ts">
	import '../app.css';
	import favicon from '$lib/assets/favicon.svg';
	import Header from '$lib/components/Header.svelte';
	import Footer from '$lib/components/Footer.svelte';
	import { page } from '$app/state';

	let { children } = $props();

	const layoutVariant = $derived(page.data.layoutVariant ?? 'subpages');
</script>

<!-- TODO: include page title here on individual pages -->
<svelte:head>
	<title>Karenz Wizard 🪄 - der Karenzplaner für Österreich</title>
	<meta
		name="description"
		content="Euch brummt der Kopf von der Karenzplanung? Die Karenzplanung ist eine riesige Herausforderung: Warum hat man ein Recht auf zwei Jahre Karenz (Freistellung) auf Arbeit, aber es werden nur 14 Monate beim einkommensabhängigen Betreuungsgeld (ea KBG) bezahlt? Ebenso herausfordernd ist die Frage der Kinderbetreuung nach der Karenz:"
	/>
	<link rel="icon" href={favicon} />
	<!-- TODO: add fitting dimensions and more tags -->
	<meta property="og:image" content="/hero_karenz_wizard.jpg" />
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
