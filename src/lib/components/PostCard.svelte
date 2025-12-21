<script lang="ts">
	type Post = {
		title: string;
		slug: string;
		pubDate: string;
		teaser: string;
	};

	let { post } = $props<{ post: Post }>();

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

<article
	class="flex h-full flex-col overflow-hidden rounded-3xl border border-slate-200/60 bg-white shadow-sm transition-shadow duration-200 focus-within:shadow-lg hover:shadow-lg focus:outline-none"
>
	<div class="flex flex-1 flex-col px-6 py-6">
		<p class="text-xs font-semibold tracking-wide text-slate-500 uppercase">
			{formatDate(post.pubDate)}
		</p>
		<h3 class="mt-2 text-lg font-semibold text-slate-900">
			<a
				href={`/blog/${post.slug}`}
				class="transition hover:text-slate-600 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
			>
				{post.title}
			</a>
		</h3>
		<p class="mt-3 text-sm leading-relaxed text-slate-600">{post.teaser}</p>
	</div>

	<div class="px-6 pb-6">
		<a
			class="inline-flex items-center justify-center rounded-full bg-[#C94D54] px-6 py-3.5 text-base font-semibold text-white transition hover:bg-[#b64048] focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[#C94D54]"
			href={`/blog/${post.slug}`}
		>
			Weiterlesen
		</a>
	</div>
</article>
