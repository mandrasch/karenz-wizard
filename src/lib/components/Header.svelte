<script lang="ts">
	import { page } from '$app/stores';

	type NavItem = {
		label: string;
		href: string;
		matchPath?: string;
	};

	// Mobile nav state
	let navOpen = $state(false);

	// Banner visibility (session-only; not persisted)
	let showPreviewBanner = $state(true);

	const navItems: NavItem[] = [
		{ label: 'eaKBG-Planer', href: '/eakbg-planer', matchPath: '/eakbg-planer' },
		{ label: 'ea KBG Anspruch?', href: '/anspruch', matchPath: '/anspruch' },
		{ label: 'FZB Anspruch? (Papamonat)', href: '/fzb-anspruch', matchPath: '/fzb-anspruch' },
		{ label: 'Pauschales KBG', href: '/pauschales-kbg', matchPath: '/pauschales-kbg' },
		{ label: 'Videos', href: '/videos' },
		{ label: 'Tools', href: '/tools' },
		{ label: 'Bücher & Broschüren', href: '/buecher-broschueren' },
		{ label: 'FAQ', href: '/faq' },
		{ label: 'Über', href: '/ueber' }
	];

	const toggleNav = () => (navOpen = !navOpen);
	const closeNav = () => (navOpen = false);

	const isActive = (item: NavItem) => {
		if (item.href === '#') return false;
		const currentPath = $page.url.pathname;
		const target = item.matchPath ?? item.href;
		return currentPath === target || (target !== '/' && currentPath.startsWith(target));
	};

	const navLinkClasses = (item: NavItem) =>
		`text-sm font-semibold transition-colors ${
			isActive(item)
				? 'text-slate-900 underline decoration-2 underline-offset-4'
				: 'text-slate-600 hover:text-slate-900'
		}`;

	const onKeydown = (e: KeyboardEvent) => {
		if (e.key === 'Escape') closeNav();
	};
</script>

<!-- TODO: re-add "sticky top-0 " after launch and without disclaimer-->
<header
	class="z-50 border-b border-slate-200 bg-white/95 shadow-sm backdrop-blur supports-[backdrop-filter]:bg-white/80"
	style="border:1px solid blue"
	onkeydown={onKeydown}
	role="banner"
>
	{#if showPreviewBanner}
		<!-- Preview / feedback banner (amber) -->
		<div class="prose-body relative border-b border-amber-200 bg-red-100 text-red-700">
			<p
				class=" mx-auto max-w-prose px-12 py-10 text-center text-xs font-medium sm:text-sm"
				aria-live="polite"
				id="preview-banner"
			>
				Frühe Vorschau-Version: Diese Webseite ist ein privates Hobby-Projekt und wird noch
				entwickelt, alle Angaben ohne Gewähr! ⚠️ Bitte unbedingt
				<a class="underline" href="/ak-beratung/">kostenfrei bei der Arbeiterkammer</a>
				beraten lassen!
			</p>
			<!-- <button
				type="button"
				class="absolute top-1/2 right-2 -translate-y-1/2 rounded-md p-2 text-amber-900/80 hover:bg-amber-200 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-500"
				aria-label="Hinweis schließen"
				aria-controls="preview-banner"
				onclick={() => (showPreviewBanner = false)}
			>
				<span aria-hidden="true" class="block text-base leading-none">×</span>
			</button>-->
		</div>
	{/if}

	<div
		class="mx-auto flex w-full max-w-[1200px] flex-wrap items-center gap-4 px-4 py-4 sm:px-6"
		style="border:1px solid green"
	>
		<a class="text-lg font-bold tracking-tight text-slate-950" href="/">Karenz Wizard 🪄</a>

		<!-- Mobile menu button -->
		<button
			type="button"
			class="inline-flex h-10 w-10 shrink-0 flex-col items-center justify-center gap-1.5 rounded-md border border-slate-200 text-slate-700 transition hover:bg-slate-100 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-500 md:hidden"
			aria-expanded={navOpen}
			aria-controls="main-nav"
			onclick={toggleNav}
			title="Menü {navOpen ? 'schließen' : 'öffnen'}"
		>
			<span class="sr-only">Hauptnavigation {navOpen ? 'schließen' : 'öffnen'}</span>

			<!-- top bar -->
			<span
				aria-hidden="true"
				class={`block h-[2px] w-6 rounded-full bg-slate-800 transition-transform duration-200 ${
					navOpen ? 'translate-y-[6px] rotate-45' : ''
				}`}
			/>

			<!-- middle bar -->
			<span
				aria-hidden="true"
				class={`block h-[2px] w-6 rounded-full bg-slate-800 transition-opacity duration-200 ${
					navOpen ? 'opacity-0' : 'opacity-100'
				}`}
			/>

			<!-- bottom bar -->
			<span
				aria-hidden="true"
				class={`block h-[2px] w-6 rounded-full bg-slate-800 transition-transform duration-200 ${
					navOpen ? '-translate-y-[6px] -rotate-45' : ''
				}`}
			/>
		</button>

		<!-- Nav: hidden on mobile by default, shown when navOpen; always flex on md+ -->
		<nav
			id="main-nav"
			aria-label="Hauptnavigation"
			class={`${navOpen ? 'block' : 'hidden'} absolute top-full right-0 left-0 origin-top border-b border-slate-200  px-6 pt-4 pb-6 shadow-lg transition md:static md:flex md:items-center md:gap-6 md:border-0 md:px-0 md:py-0 md:shadow-none`}
		>
			<ul class="flex flex-col gap-3 md:flex-row md:items-center md:gap-6">
				{#each navItems as item}
					<li>
						<a href={item.href} class={navLinkClasses(item)} onclick={closeNav}>
							{item.label}
						</a>
					</li>
				{/each}
			</ul>
		</nav>
	</div>
</header>

{#if navOpen}
	<!-- Click-away overlay on mobile when menu is open -->
	<div class="fixed inset-0 z-40 bg-black/20 md:hidden" onclick={closeNav} />
{/if}
