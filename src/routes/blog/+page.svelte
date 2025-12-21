<script lang="ts">
	import type { BlogSummary } from '$lib/server/blog';
	import PostCard from '$lib/components/PostCard.svelte';
	import PostGrid from '$lib/components/PostGrid.svelte';

	const { data } = $props<{ data: { posts: BlogSummary[] } }>();
	const blogPosts = data.posts;
</script>

<section class="content">
	<header class="mt-10 space-y-4 text-center">
		<h1 class="text-3xl font-semibold text-slate-900">Blog</h1>
		<p class="text-base leading-relaxed text-slate-600">
			Aktuelle Infos zu dieser Webseite sowie ausgewählte Links rund um Kinderbetreuungsgeld und
			Karenzplanung.
		</p>
	</header>

	<div class="mt-10">
		{#if blogPosts.length === 0}
			<p
				class="rounded-3xl border border-dashed border-slate-300/80 bg-slate-50 px-6 py-10 text-base text-slate-600"
			>
				Noch gibt es keine veröffentlichten Beiträge. Schau bald wieder vorbei.
			</p>
		{:else}
			<PostGrid>
				{#each blogPosts as post}
					<PostCard {post} />
				{/each}
			</PostGrid>
		{/if}
	</div>
</section>
