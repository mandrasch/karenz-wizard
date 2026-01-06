<script lang="ts">
	import type { PageData } from './$types';
	import PostCard from '$lib/components/PostCard.svelte';
	import PostGrid from '$lib/components/PostGrid.svelte';

	// TODO: descriptions are just quick examples, re-work them
	const cards = [
		{
			title: 'Hat mindestens einer von euch Anspruch auf eaKBG?',
			subtitle: '1. Prüft euren Anspruch',
			description: [
				'Um das einkommensabhängige Kinderbetreuungsgeld (eaKBG) zu beziehen, muss mindestens ein Elternteil die 182-Tage-Regel erfüllen und vor Geburt bzw. Mutterschutz ca. 6 Monate durchgehend gearbeitet haben. Arbeitslosengeld o.ä. darf bspw. nicht bezogen worden sein in dieser Zeit. ',
				'Prüft hier euren Anspruch:'
			],
			href: '/eakbg-anspruch',
			cta: 'eaKBG-Anspruch prüfen'
		},
		// TODO: explain eakbg here briefly
		{
			title: 'Plant gemeinsam eure Karenzaufteilung',
			subtitle: '2. eaKBG-Planer nutzen ',
			description: [
				'Wenn ihr euren Anspruch geklärt habt, könnt ihr die Aufteilung der 14 Monate eaKBG planen. Außerdem könnt ihr - falls leistbar - eine unbezahlte Karenz anhängen oder sehen, ab wann ihr in Eltern-Teilzeit gehen könntet (falls ihr darauf Anspruch habt).',
				'Schaut euch mit dem interaktiven Planungstool eure Möglichkeiten an und diskutiert sie gemeinsam, Infos für Neu-Eltern finden sich hier ebenfalls:'
			],
			href: '/eakbg-planer',
			cta: 'Eure Karenz interaktiv planen'
		},
		{
			title: 'Lasst eure Planung bei der Arbeiterkammer prüfen',
			subtitle: '3. Lasst euch beraten',
			description: [
				'Im Dschungel der Fristen und Vorgaben übersieht man schnell etwas. Lasst eure Karenzplanung bei der Beratung eurer AK kostenfrei prüfen - bevor (!) ihr den Antrag auf Kinderbetreuungsgeld stellt.',
				'Manche Bundesländer-Arbeiterkammern bieten auch Vor-Ort-Veranstaltungen, Webinare oder Willkommenspakete an.',
				'Fragt euch am besten heute noch einen Termin zur ersten Beratung an:'
			],
			href: '/ak-beratung',
			cta: 'AK-Beratung und Angebote'
		}
	];

	const { data } = $props<{ data: PageData }>();
	const latestPosts = data.posts ?? [];

	let expanded = $state(false);
	const ctrlId = 'teaser-more';
</script>

<section class="full-bleed">
	<div class="relative w-full bg-white text-slate-900">
		<div class="content py-12 sm:py-12">
			<div class="mx-auto flex max-w-5xl flex-col gap-12">
				<div class="flex h-56 items-center justify-center sm:h-64 lg:h-72 xl:h-80">
					<img
						src="/hero_karenz_wizard.jpg"
						alt="Illustration eines Zauberers, der Eltern beim Planen unterstützt"
						class="h-full max-h-full w-auto max-w-full rounded-2xl border border-slate-200 object-contain"
					/>
				</div>

				<div class="space-y-6 px-6 pb-4 text-slate-600">
					<h1 class="text-center text-3xl leading-snug font-bold text-slate-900 sm:text-4xl">
						Euch brummt der Kopf von der Karenzplanung?
					</h1>

					<p class="text-base leading-relaxed text-slate-600">
						Warum hat man ein Recht auf zwei Jahre Karenz-Freistellung auf Arbeit, es werden aber
						nur 14 Monate beim einkommensabhängigen Betreuungsgeld gut vom Staat gefördert (~ 80%
						des Einkommens)? Was passiert danach, wie teilt man alles möglichst gleichberechtigt
						auf, wie kommt man finanziell dabei aus, etc. etc.?
					</p>
					<p class="text-base leading-relaxed text-slate-600">
						Als Neu-Eltern standen wir vor kurzem selber erst vor diesem Berg an Fragen. Die gute
						Nachricht: Hat man erstmal einen groben Überblick, kann man sich bewusster entscheiden
						und die Planung fällt immer leichter. Alles Gute für dein / euer Abenteuer mit Baby! 🍀
					</p>

					<!-- <p class="text-base leading-relaxed text-slate-600">
						Als Neu-Eltern standen wir vor kurzem selber erst vor diesem Berg an Fragen - mit dem
						Anspruch, alles möglichst 50:50 fair aufteilen.
					</p>-->
					<!-- <p class="text-base leading-relaxed text-slate-600">
						Die schlechte Nachricht: Eine 50:50-Aufteilung beim eaKBG ist kompliziert. Die gute
						Nachricht: Hat man erstmal einen groben Überblick, kann man sich bewusster entscheiden.
						Allein ist man auch nicht dabei, die Arbeiterkammer steht dir bspw. zur Seite. Alles
						Gute für dein/euer Abenteuer mit Baby! 🍀
					</p> -->
					<p class="text-center text-base leading-relaxed text-slate-600">
						Diese Webseite soll helfen, schnell einen Überblick zu bekommen:
					</p>
					<p class="text-center text-base leading-relaxed text-slate-600"></p>
					<!-- {#if expanded}
						<div id={ctrlId} class="space-y-5">
							<p class="text-base leading-relaxed text-slate-600">
								Wann ist unser Kind bereit in eine Kindergarten-Gruppe zu gehen, wie viele Stunde
								sind anfangs gut? Wollen wir es schon mit 14 Monaten fremdbetreuen lassen? Oder doch
								erst zu einer Tagesmutter, den Großeltern - oder beide Elternteile arbeiten
								20h/Woche in Eltern-Teilzeit und teilen den Tag auf? <br /><br />Oder bleibt einer
								von uns doch länger in Karenz? Wie organisiert man eine längere, unbezahlte Karenz
								nach 14 Monaten eaKBG überhaupt? Können wir uns das leisten? Und wie schaut es hier
								mit der Krankenversicherung aus?
							</p>

							<p class="text-base leading-relaxed text-slate-600">
								Und wie regeln wir die Gleichberechtigung: Wie kommen wir aus der bisherigen Falle
								heraus, dass der Vater nur die minimalen 2 Monate Karenz nimmt - wie so viele Männer
								in Österreich aktuell.
							</p>

							<p class="text-base leading-relaxed text-slate-600">
								Diese private Webseite soll eine kleine Hilfestellung geben. Als Neu-Eltern standen
								wir vor kurzem selber erst vor diesem Berg an Fragen. Die gute Nachricht: Hat man
								erstmal einen groben Überblick über alle Begriffe und ob man die Ansprüche erfüllt,
								wie die Fristen sind, was möglich ist - dann kann man sich bewusster entscheiden.
								Alles Gute für dein/euer Abenteuer!
							</p>

							<p class="text-base leading-relaxed text-slate-600">
								Lasst uns - vor allem als Väter - (endlich) gemeinsam Verantwortung übernehmen!
							</p>
						</div>
					{/if}

					<div class="text-center">
						<button
							type="button"
							class="mt-2 inline-flex items-center gap-2 rounded-full bg-[#C94D54] px-6 py-3.5 text-base font-semibold text-white transition hover:bg-[#b64048] focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[#C94D54]"
							aria-expanded={expanded}
							aria-controls={ctrlId}
							on:click={() => (expanded = !expanded)}
						>
							{expanded ? 'Weniger anzeigen' : 'Mehr lesen'}
							<svg
								xmlns="http://www.w3.org/2000/svg"
								class="h-5 w-5"
								viewBox="0 0 24 24"
								fill="currentColor"
								aria-hidden="true"
							>
								{#if expanded}
									<path d="M6 15l6-6 6 6" />
								{:else}
									<path d="M6 9l6 6 6-6" />
								{/if}
							</svg>
						</button>
					</div>-->
				</div>
			</div>
		</div>
	</div>
</section>

<!-- TODO: decrease space ? -->
<section class="content">
	<div class="space-y-10">
		<div class="max-w-3xl">
			<h2 class="text-2xl font-semibold text-slate-900 sm:text-3xl">Alle Schritte im Blick</h2>
		</div>

		<div class="grid grid-cols-1 gap-10 md:grid-cols-2 xl:grid-cols-3">
			{#each cards as card}
				<article
					class="flex h-full flex-col overflow-hidden rounded-3xl border border-slate-200/60 bg-white shadow-sm transition-shadow duration-200 focus-within:shadow-lg hover:shadow-lg focus:outline-none"
				>
					<div class="flex flex-1 flex-col px-6 py-6">
						<p class="text-sm font-medium tracking-wide text-slate-500 uppercase">
							{card.subtitle}
						</p>
						<h3 class="mt-3 text-lg font-semibold text-slate-900">{card.title}</h3>

						{#each card.description as paragraph}
							<p class="mt-2 text-sm leading-relaxed text-slate-500">{paragraph}</p>
						{/each}
					</div>

					<div class="px-6 pb-6">
						<a
							class="inline-flex items-center justify-center rounded-full bg-[#C94D54] px-6 py-3.5 text-base font-semibold text-white transition hover:bg-[#b64048] focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[#C94D54]"
							href={card.href}
						>
							{card.cta}
						</a>
					</div>
				</article>
			{/each}
		</div>
	</div>
</section>

{#if latestPosts.length > 0}
	<section class="content">
		<div class="space-y-8">
			<div class="max-w-3xl">
				<p class="text-sm font-semibold tracking-wide text-slate-500 uppercase">Blog</p>
				<h2 class="text-2xl font-semibold text-slate-900 sm:text-3xl">Aktuelle Beiträge</h2>
				<!-- <p class="mt-2 text-base text-slate-600">
					Kurz notiert, damit du nichts verpasst: frische Hinweise aus dem Karenz-Alltag.
				</p> -->
			</div>

			<PostGrid>
				{#each latestPosts as post}
					<PostCard {post} />
				{/each}
			</PostGrid>

			<div class="text-center">
				<a
					class="inline-flex items-center justify-center rounded-full border border-[#C94D54] px-6 py-3.5 text-base font-semibold text-[#C94D54] transition hover:bg-[#C94D54]/10 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-[#C94D54]"
					href="/blog"
				>
					Alle Beiträge anzeigen
				</a>
			</div>
		</div>
	</section>
{/if}
