<script lang="ts">
	const cards = [
		{
			title: 'Habe ich und meine/e Partner/in Anspruch?',
			subtitle: 'Prüft eure Voraussetzungen.',
			description: [
				'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.'
			],
			href: '/eakbg-anspruch',
			cta: 'Anspruch prüfen'
		},
		{
			title: 'ea KBG Karenz-Planer',
			subtitle: 'Plant euren Karenzverlauf Schritt für Schritt.',
			description: [
				'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.'
			],
			href: '/eakbg-planer',
			cta: 'Zum Karenz-Planer'
		},
		{
			title: 'Beratung & Ressourcen',
			subtitle: 'Unterstützung für Ihren individuellen Weg.',
			description: [
				'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.'
			],
			href: '/infothek',
			cta: 'Ressourcen entdecken'
		}
	];

	let expanded = $state(false);
	const ctrlId = 'teaser-more';
</script>

<section class="full-bleed">
	<div
		class="relative w-full bg-gradient-to-br from-sky-500 via-indigo-500 to-purple-600 text-white shadow-xl"
	>
		<div class="content py-16 sm:py-20">
			<div class="mx-auto flex max-w-5xl flex-col gap-12">
				<div class="flex h-56 items-center justify-center sm:h-64 lg:h-72 xl:h-80">
					<img
						src="/hero_karenz_wizard.jpg"
						alt="Illustration eines Zauberers, der Eltern beim Planen unterstützt"
						class="h-full max-h-full w-auto max-w-full rounded-2xl border border-white/40 object-contain"
					/>
				</div>

				<div class="space-y-6 px-6 text-white/90">
					<h1 class="text-center text-3xl leading-snug font-bold text-white sm:text-4xl">
						Euch brummt der Kopf von der Karenzplanung?
					</h1>

					<p class="text-base leading-relaxed">
						Die Karenzplanung ist eine riesige Herausforderung: Warum hat man ein Recht auf zwei
						Jahre Karenz (Freistellung) auf Arbeit, aber es werden nur 14 Monate beim
						einkommensabhängigen Betreuungsgeld (ea KBG) bezahlt? Ebenso herausfordernd ist die
						Frage der Kinderbetreuung nach der Karenz:
					</p>

					{#if expanded}
						<div id={ctrlId} class="space-y-5">
							<p class="text-base leading-relaxed">
								Wann ist unser Kind bereit in eine Kindergarten-Gruppe zu gehen, wie viele Stunde
								sind anfangs gut? Wollen wir es schon mit 14 Monaten fremdbetreuen lassen? Oder doch
								erst zu einer Tagesmutter, den Großeltern - oder beide Elternteile arbeiten
								20h/Woche in Eltern-Teilzeit und teilen den Tag auf? <br /><br />Oder bleibt einer
								von uns doch länger in Karenz? Wie organisiert man eine längere, unbezahlte Karenz
								nach 14 Monaten ea KBG überhaupt? Können wir uns das leisten? Und wie schaut es hier
								mit der Krankenversicherung aus?
							</p>

							<p class="text-base leading-relaxed">
								Und wie regeln wir die Gleichberechtigung: Wie kommen wir aus der bisherigen Falle
								heraus, dass der Vater nur die minimalen 2 Monate Karenz nimmt - wie so viele Männer
								in Österreich aktuell.
							</p>

							<p class="text-base leading-relaxed">
								Diese private Webseite soll eine kleine Hilfestellung geben. Als Neu-Eltern standen
								wir vor kurzem selber erst vor diesem Berg an Fragen. Die gute Nachricht: Hat man
								erstmal einen groben Überblick über alle Begriffe und ob man die Ansprüche erfüllt,
								wie die Fristen sind, was möglich ist - dann kann man sich bewusster entscheiden.
								Alles Gute für dein/euer Abenteuer!
							</p>

							<p class="text-base leading-relaxed">
								Lasst uns - vor allem als Väter - (endlich) gemeinsam Verantwortung übernehmen!
							</p>
						</div>
					{/if}

					<div class="text-center">
						<button
							type="button"
							class="mt-2 inline-flex items-center gap-2 rounded-full bg-white/15 px-6 py-3.5 text-base font-semibold text-white backdrop-blur-sm transition hover:bg-white/25 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-white/70"
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
					</div>
				</div>
			</div>
		</div>
	</div>
</section>

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
					<div class="aspect-[4/3] w-full overflow-hidden">
						<div
							class="h-full w-full bg-gradient-to-br from-indigo-100 via-purple-100 to-sky-100"
						></div>
					</div>

					<div class="flex flex-1 flex-col px-6 py-6">
						<p class="text-sm font-medium tracking-wide text-indigo-500 uppercase">
							{card.subtitle}
						</p>
						<h3 class="mt-3 text-lg font-semibold text-slate-900">{card.title}</h3>

						{#each card.description as paragraph}
							<p class="mt-2 text-sm leading-relaxed text-slate-500">{paragraph}</p>
						{/each}
					</div>

					<div class="px-6 pb-6">
						<a
							class="inline-flex items-center justify-center rounded-full bg-indigo-600 px-6 py-3.5 text-base font-semibold text-white transition hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
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
