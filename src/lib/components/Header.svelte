<script lang="ts">
	import { page } from '$app/state';

	type NavItem = {
		label: string;
		href: string;
		matchPath?: string;
	};

	let navOpen = $state(false);
	let showPreviewBanner = $state(true);

	const navItems: NavItem[] = [
		{ label: 'Start', href: '/', matchPath: '/' },
		{ label: 'ea KBG Planer 🪄', href: '/eakbg-planer', matchPath: '/eakbg-planer' },
		{ label: 'ea KBG Anspruch?', href: '/eakbg-anspruch', matchPath: '/eakbg-anspruch' },
		{ label: 'FZB Anspruch? (Papamonat)', href: '/fzb-anspruch', matchPath: '/fzb-anspruch' },
		{ label: 'Pauschales KBG', href: '/pauschales-kbg', matchPath: '/pauschales-kbg' },
		{ label: 'Infothek', href: '/infothek' },
		{ label: 'FAQ', href: '/faq' },
		{ label: 'Über', href: '/ueber' }
	];

	const pathname = $derived(page.url.pathname);
	const toggleNav = () => (navOpen = !navOpen);
	const closeNav = () => (navOpen = false);

	const isActive = (item: NavItem) => {
		if (item.href === '#') return false;
		const target = item.matchPath ?? item.href;
		return pathname === target || (target !== '/' && pathname.startsWith(target));
	};

	const navLinkClasses = (item: NavItem) =>
		`text-lg md:text-sm font-semibold transition-colors ${
			isActive(item)
				? 'text-slate-900 underline decoration-2 underline-offset-4'
				: 'text-slate-600 hover:text-slate-900'
		}`;

	const onKeydown = (e: KeyboardEvent) => {
		if (e.key === 'Escape') closeNav();
	};

	// Lock page scroll when mobile menu is open
	$effect(() => {
		if (typeof document === 'undefined') return;
		const el = document.documentElement;
		if (navOpen) el.classList.add('overflow-hidden');
		else el.classList.remove('overflow-hidden');
	});
</script>

<!-- HEADER -->
<header
	class="z-50 border-b border-slate-200 bg-white/95 shadow-sm backdrop-blur supports-[backdrop-filter]:bg-white/80"
	on:keydown={onKeydown}
	role="banner"
>
	{#if showPreviewBanner}
		<!-- Preview banner -->
		<div class="prose-body relative border-b border-amber-200 bg-red-100 text-red-700">
			<p
				class="mx-auto max-w-prose px-12 py-6 text-center text-xs font-medium sm:text-sm"
				aria-live="polite"
				id="preview-banner"
			>
				Frühe Vorschau-Version: Das ist ein Hobby-Projekt und wird noch entwickelt, alle Angaben
				ohne Gewähr! Inhalte wurden nicht von Expert:innen geprüft. Die Seite ist noch nicht
				mobil-optimiert.<br /><br />
				⚠️ Bitte unbedingt
				<a class="underline" href="/ak-beratung/">kostenfrei bei der Arbeiterkammer</a>
				beraten lassen! ⚠️
			</p>
		</div>
	{/if}

	<!-- MAIN NAV WRAPPER -->
	<div class="mx-auto flex w-full max-w-[1200px] flex-wrap items-center gap-4 px-4 py-4 sm:px-6">
		<a class="text-lg font-bold tracking-tight text-slate-950" href="/">Karenz Wizard 🪄</a>

		<!-- Mobile menu button -->
		<button
			type="button"
			class="inline-flex h-10 w-10 shrink-0 items-center justify-center rounded-md border border-slate-200 text-slate-700 transition hover:bg-slate-100 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-500 md:hidden"
			aria-expanded={navOpen}
			aria-controls="mobile-menu"
			on:click={toggleNav}
			title={`Menü ${navOpen ? 'schließen' : 'öffnen'}`}
		>
			<span class="sr-only">Hauptnavigation {navOpen ? 'schließen' : 'öffnen'}</span>

			<!-- Bars wrapper -->
			<span class="relative block h-5 w-6" aria-hidden="true">
				<!-- top -->
				<span
					class={`absolute top-1/2 left-0 block h-0.5 w-6 -translate-y-1/2 rounded-full bg-slate-800 transition-transform duration-200 ${
						navOpen ? 'rotate-45' : '-translate-y-2'
					}`}
				/>
				<!-- middle -->
				<span
					class={`absolute top-1/2 left-0 block h-0.5 w-6 -translate-y-1/2 rounded-full bg-slate-800 transition-opacity duration-200 ${
						navOpen ? 'opacity-0' : 'opacity-100'
					}`}
				/>
				<!-- bottom -->
				<span
					class={`absolute top-1/2 left-0 block h-0.5 w-6 -translate-y-1/2 rounded-full bg-slate-800 transition-transform duration-200 ${
						navOpen ? '-rotate-45' : 'translate-y-2'
					}`}
				/>
			</span>
		</button>

		<!-- DESKTOP NAV -->
		<nav aria-label="Hauptnavigation" class="hidden md:flex md:items-center md:gap-6">
			<ul class="flex flex-col gap-3 md:flex-row md:items-center md:gap-6">
				{#each navItems as item}
					<li>
						<a href={item.href} class={navLinkClasses(item)} on:click={closeNav}>
							{item.label}
						</a>
					</li>
				{/each}
			</ul>
		</nav>
	</div>
</header>

<!-- MOBILE FULLSCREEN MENU -->
{#if navOpen}
	<div
		id="mobile-menu"
		role="dialog"
		aria-modal="true"
		class="fixed inset-0 z-[60] flex h-dvh w-dvw flex-col bg-white md:hidden"
	>
		<!-- top bar within panel (keeps close button reachable) -->
		<div class="flex items-center justify-between border-b border-slate-200 px-4 py-4 sm:px-6">
			<a class="text-lg font-bold tracking-tight text-slate-950" href="/" on:click={closeNav}
				>Karenz Wizard 🪄</a
			>
			<button
				type="button"
				class="inline-flex h-10 w-10 items-center justify-center rounded-md border border-slate-200 text-slate-700 transition hover:bg-slate-100 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-500"
				aria-label="Menü schließen"
				on:click={closeNav}
			>
				<span class="relative block h-5 w-5" aria-hidden="true">
					<span
						class="absolute top-1/2 left-0 block h-0.5 w-5 -translate-y-1/2 rotate-45 rounded-full bg-slate-800"
					/>
					<span
						class="absolute top-1/2 left-0 block h-0.5 w-5 -translate-y-1/2 -rotate-45 rounded-full bg-slate-800"
					/>
				</span>
			</button>
		</div>

		<!-- scrollable menu content -->
		<nav aria-label="Hauptnavigation" class="flex-1 overflow-y-auto px-6 py-6">
			<ul class="grid gap-4">
				{#each navItems as item}
					<li>
						<a
							href={item.href}
							class={`block rounded-lg px-3 py-3 ${navLinkClasses(item)} hover:bg-slate-50`}
							on:click={closeNav}
						>
							{item.label}
						</a>
					</li>
				{/each}
			</ul>
		</nav>
	</div>
{/if}
