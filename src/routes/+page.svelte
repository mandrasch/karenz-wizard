<script lang="ts">
	const cards = [
		{
			title: 'Habe ich und meine/e Partner/in Anspruch?',
			subtitle: 'Prüfen Sie Voraussetzungen.',
			description: [
				'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.'
			],
			href: '/eakbg-anspruch',
			cta: 'Anspruch prüfen'
		},
		{
			title: 'ea KBG Karenz-Planer',
			subtitle: 'Planen Sie Ihren Karenzverlauf Schritt für Schritt.',
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
			href: '/eakbg-anspruch',
			cta: 'Ressourcen entdecken'
		}
	];
</script>

<!-- ======================= -->
<!-- HERO SECTION -->
<!-- ======================= -->
<section
	class="relative w-full bg-gradient-to-br from-sky-500 via-indigo-500 to-purple-600 text-white shadow-xl"
>
	<div
		class="mx-auto flex max-w-6xl flex-col justify-between gap-12 px-6 py-20 sm:px-10 lg:flex-row lg:items-center"
	>
		<!-- TEXT -->
		<div class="max-w-lg space-y-5 text-white/90 lg:w-[45%]">
			<h1 class="text-3xl leading-snug font-bold text-white sm:text-4xl lg:text-5xl">
				Euch brummt der Kopf von der Karenzplanung?
			</h1>

			<p class="text-sm leading-relaxed sm:text-base">
				Die Karenzplanung ist eine riesige Herausforderung: Warum hat man ein Recht auf zwei Jahre
				Karenz (Freistellung) auf Arbeit, aber es werden nur 14 Monate beim einkommensabhängigen
				Betreuungsgeld (ea KBG) bezahlt? <!-- Welches der zwei Modelle soll ich wählen? -->
			</p>

			<p class="text-sm leading-relaxed sm:text-base">
				Ebenso herausfordernd ist die Frage der Kinderbetreuung nach der Karenz: Wann ist unser Kind
				bereit in eine Kindergarten-Gruppe zu gehen, wie viele Stunde sind anfangs gut? Wollen wir
				es schon mit 14 Monaten fremdbetreuen lassen? Oder doch erst zu einer Tagesmutter, den
				Großeltern - oder beide Elternteile arbeiten 20h/Woche in Eltern-Teilzeit und teilen den Tag
				auf? <br /><br />Oder bleibt einer von uns doch länger in Karenz? Wie organisiert man eine
				längere, unbezahlte Karenz nach 14 Monaten ea KBG überhaupt? Können wir uns das leisten? Und
				wie schaut es hier mit der Krankenversicherung aus?
			</p>

			<p class="text-sm leading-relaxed sm:text-base">
				Und wie regeln wir die Gleichberechtigung: Wie kommen wir aus der bisherigen Falle heraus,
				dass der Vater nur die minimalen 2 Monate Karenz nimmt - wie so viele Männer in Österreich
				aktuell. <!-- Ganze Männer machen ja eigentlich halbe halbe. -->
			</p>

			<p class="text-sm leading-relaxed sm:text-base">
				Diese private Webseite soll eine kleine Hilfestellung geben. Als Neu-Eltern standen wir vor
				kurzem selber erst vor diesem Berg an Fragen.
			</p>
		</div>

		<!-- IMAGE -->
		<div class="flex flex-1 items-center justify-center lg:w-[55%]">
			<div
				class="w-full rounded-2xl border border-white/30 bg-white/10 p-4 backdrop-blur-sm sm:p-6 lg:p-8"
			>
				<div
					class="flex aspect-[4/3] items-center justify-center rounded-xl border border-dashed border-white/50 bg-white/5 sm:aspect-[3/2] lg:aspect-[16/10]"
				>
					<img
						src="/hero.png"
						alt="Illustration zum Thema Karenzplanung"
						class="max-h-full max-w-full object-contain"
					/>
				</div>
			</div>
		</div>
	</div>
</section>

<!-- ======================= -->
<!-- CARDS SECTION -->
<!-- ======================= -->
<section class="mx-auto mt-20 max-w-6xl px-6 sm:px-10">
	<div class="max-w-3xl">
		<h2 class="text-2xl font-semibold text-slate-900 sm:text-3xl">Alle Schritte im Blick</h2>
	</div>

	<div class="mt-10 grid grid-cols-1 gap-10 md:grid-cols-2 xl:grid-cols-3">
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
					<p class="text-sm font-medium tracking-wide text-indigo-500 uppercase">{card.subtitle}</p>
					<h3 class="mt-3 text-lg font-semibold text-slate-900">{card.title}</h3>

					{#each card.description as paragraph}
						<p class="mt-2 text-sm leading-relaxed text-slate-500">{paragraph}</p>
					{/each}
				</div>

				<div class="px-6 pb-6">
					<a
						class="inline-flex items-center justify-center rounded-full bg-indigo-600 px-5 py-2.5 text-sm font-semibold text-white transition hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
						href={card.href}
					>
						{card.cta}
					</a>
				</div>
			</article>
		{/each}
	</div>
</section>
