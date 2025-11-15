<script lang="ts">
	import type { Component } from 'svelte';
	import type { BlogSummary } from '$lib/server/blog';

	type BlogListItem = BlogSummary & { component?: Component };
	const AUTHOR_NAME = 'Matthias Andrasch';

	const { data } = $props<{ data: { posts: BlogSummary[] } }>();
	const blogPosts = data.posts;

	const articleModules = import.meta.glob<{ default: Component }>('/src/content/blog/*.md', {
		eager: true
	});

	const articles: BlogListItem[] = blogPosts.map((post) => {
		const module = articleModules[post.source];
		if (!module) {
			console.error(`Blog: Missing module for slug "${post.slug}"`, post.source);
		}

		return { ...post, component: module?.default };
	});

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
	<header class="mt-10 space-y-4 text-center">
		<h1 class="text-3xl font-semibold text-slate-900">Blog</h1>
		<p class="text-base leading-relaxed text-slate-600">
			Aktuelle Infos rund um Kinderbetreuungsgeld, Karenzplanung und diese Webseite.
		</p>
	</header>

	<div class="mx-auto mt-6 max-w-4xl">
		{#if articles.length === 0}
			<p
				class="rounded-3xl border border-dashed border-slate-300/80 bg-slate-50 px-6 py-10 text-base text-slate-600"
			>
				Noch gibt es keine veröffentlichten Beiträge. Schau bald wieder vorbei.
			</p>
		{:else}
			<div class="space-y-10">
				{#each articles as item}
					<article class="space-y-4 border-b border-slate-200 pb-10 last:border-none">
						<div class="space-y-3">
							<p class="flex flex-wrap items-center gap-2 text-sm text-slate-500">
								<a
									href={`/blog/${item.slug}`}
									class="inline-flex min-h-[44px] items-center font-semibold tracking-wide text-slate-500 uppercase transition hover:text-slate-900 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
								>
									<time datetime={item.pubDate}>{formatDate(item.pubDate)}</time>
								</a>
								<span aria-hidden="true" class="text-slate-300">•</span>
								<span class="font-medium text-slate-600">{AUTHOR_NAME}</span>
							</p>
							<h2 class="text-2xl font-semibold text-slate-900">
								<a
									href={`/blog/${item.slug}`}
									class="transition hover:text-slate-600 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
								>
									{item.title}
								</a>
							</h2>
						</div>
						{#if item.component}
							{@const EntryComponent = item.component}
							<div class="prose max-w-none prose-slate">
								<EntryComponent />
							</div>
						{:else}
							<p class="rounded-2xl bg-rose-50 px-6 py-4 text-sm text-rose-700">
								Der Beitrag konnte nicht geladen werden. Prüfe bitte {item.source}.
							</p>
						{/if}
					</article>
				{/each}
			</div>
		{/if}
	</div>
</section>
