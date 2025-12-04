<script lang="ts">
	import type { Component } from 'svelte';
	import type { BlogArticle } from '$lib/server/blog';

	// receive load() data from SvelteKit
	export let data: {
		article: Omit<BlogArticle, 'component'>;
		seo?: { title?: string; description?: string };
	};

	// TODO: use Svelte v5 syntax, only quick bugfix
	// make article reactive so it updates on client-side navigation
	let article = data.article;
	$: article = data.article;

	// eager-import all blog md Svelte components (adjust glob if your files are elsewhere)
	const articleModules = import.meta.glob<{ default: Component }>('/src/content/blog/*.md', {
		eager: true
	});

	// reactive: recompute when article.source changes
	let ArticleContent: Component | undefined;
	$: {
		ArticleContent = articleModules[article.source]?.default;
		// debug: log when ArticleContent is recomputed
		console.log(
			'[blog] article.source:',
			article.source,
			'-> ArticleContent:',
			Boolean(ArticleContent)
		);
	}

	// debug: list available module keys once (helps confirm keys match article.source)
	$: {
		// show once on first run
		if (typeof window !== 'undefined') {
			console.log('[blog] available articleModules keys:', Object.keys(articleModules));
		}
	}

	if (!ArticleContent) {
		console.warn('Blog: Missing module for slug', article.slug, 'at', article.source);
	}

	const dateFormatter = new Intl.DateTimeFormat('de-AT', {
		day: '2-digit',
		month: 'long',
		year: 'numeric'
	});

	const formatDate = (date: string) => {
		const parsed = new Date(date);
		return Number.isNaN(parsed.valueOf()) ? date : dateFormatter.format(parsed);
	};
</script>

<svelte:head>
	{#if data.seo?.title}
		<title>{data.seo.title}</title>
	{/if}
	{#if data.seo?.description}
		<meta name="description" content={data.seo.description} />
	{/if}
</svelte:head>

<section class="content">
	<header class="mt-10 space-y-4">
		<a
			href="/blog"
			class="inline-flex items-center gap-2 text-sm font-semibold text-slate-600 underline decoration-dotted underline-offset-4 transition hover:text-slate-900"
		>
			<span aria-hidden="true">←</span> Zurück zur Übersicht
		</a>

		<div class="space-y-2">
			<p class="text-sm font-semibold tracking-wide text-slate-500 uppercase">Blog</p>
			<p class="text-sm text-slate-500">{formatDate(article.pubDate)}</p>
		</div>

		<div class="space-y-4">
			<h1 class="text-3xl font-semibold text-slate-900 sm:text-4xl">{article.title}</h1>
			{#if article.description}
				<p class="max-w-2xl text-base leading-relaxed text-slate-600">{article.description}</p>
			{/if}
		</div>
	</header>
</section>

<section class="content">
	{#if ArticleContent}
		{@const ContentComponent = ArticleContent}
		{#key article.slug}
			<div class="prose max-w-none prose-slate">
				<svelte:component this={ContentComponent} />
			</div>
		{/key}
	{:else}
		<p class="rounded-2xl bg-rose-50 px-6 py-4 text-sm text-rose-700">
			Der Beitrag konnte nicht geladen werden. Prüfe bitte {article.source}.
		</p>
	{/if}
</section>
