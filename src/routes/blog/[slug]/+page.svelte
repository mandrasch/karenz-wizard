<script lang="ts">
	import type { Component } from 'svelte';
	import type { BlogArticle } from '$lib/server/blog';

	type ArticleMeta = Omit<BlogArticle, 'component'>;

	const { data } = $props<{ data: { article: ArticleMeta } }>();
	const article = data.article;

	const articleModules = import.meta.glob<{ default: Component }>(
		'/src/content/blog/*.md',
		{ eager: true }
	);

	const ArticleContent = articleModules[article.source]?.default;

	if (!ArticleContent) {
		console.error('Blog: Missing module for slug', article.slug, 'at', article.source);
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

<section class="content">
	<header class="mt-10 space-y-4">
		<a
			href="/blog"
			class="inline-flex items-center gap-2 text-sm font-semibold text-slate-600 underline decoration-dotted underline-offset-4 transition hover:text-slate-900"
		>
			<span aria-hidden="true">←</span> Zurück zur Übersicht
		</a>

		<div class="space-y-2">
			<p class="text-sm font-semibold uppercase tracking-wide text-slate-500">Blog</p>
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
		<div class="prose max-w-none prose-slate">
			<ContentComponent />
		</div>
	{:else}
		<p class="rounded-2xl bg-rose-50 px-6 py-4 text-sm text-rose-700">
			Der Beitrag konnte nicht geladen werden. Prüfe bitte {article.source}.
		</p>
	{/if}
</section>
