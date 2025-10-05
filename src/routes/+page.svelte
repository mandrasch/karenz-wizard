<script lang="ts">
	const cards = [
		{
			title: 'Habe ich und meine/e Partner/in Anspruch?',
			subtitle: 'Prüfen Sie Voraussetzungen.',
			description: [
				'Verschaffen Sie sich einen Überblick darüber, welche Leistungen für Sie und Ihre Familie in Frage kommen.',
				'Erfahren Sie, welche Nachweise benötigt werden und wie Sie Ihre Unterlagen fristgerecht einreichen.',
				'Nutzen Sie praxisnahe Tipps, um häufige Stolperfallen in der Antragstellung zu vermeiden.'
			],
			href: '/anspruch',
			cta: 'Anspruch prüfen'
		},
		{
			title: 'EAKBG Karenz-Planer',
			subtitle: 'Planen Sie Ihren Karenzverlauf Schritt für Schritt.',
			description: [
				'Ermitteln Sie, wie lange Sie Karenzgeld beziehen können und welche Optionen sich daraus ergeben.',
				'Passen Sie Zeiträume flexibel an, um Betreuung, Berufseinstieg und finanzielle Planung abzustimmen.',
				'Speichern Sie Ihre wichtigsten Eckpunkte, damit Sie Gespräche mit Arbeitgeber:innen gut vorbereitet führen.'
			],
			href: '/eakbg-planer',
			cta: 'Zum Karenz-Planer'
		},

		{
			title: 'Beratung & Ressourcen',
			subtitle: 'Unterstützung für Ihren individuellen Weg.',
			description: [
				'Finden Sie Beratungsstellen und Online-Angebote, die Sie bei speziellen Fragen begleiten.',
				'Nutzen Sie Checklisten und Vorlagen, um Termine, Deadlines und Aufgaben im Blick zu behalten.',
				'Entdecken Sie weiterführende Links für rechtliche Informationen und finanzielle Planungshilfen.'
			],
			href: '/anspruch#beratung',
			cta: 'Ressourcen entdecken'
		}
	];
</script>

<section
	class="relative w-full bg-gradient-to-br from-sky-500 via-indigo-500 to-purple-600 text-white shadow-xl"
>
	<div
		class="mx-auto flex max-w-6xl flex-col justify-between gap-10 px-6 py-16 sm:px-10 lg:flex-row"
	>
		<div class="max-w-xl space-y-6">
			<!-- <span
				class="inline-flex items-center justify-center rounded-full bg-white/20 px-3 py-1 text-xs font-semibold tracking-wide text-white/90"
			>
				Karenz-Planer Österreich
			</span> -->
			<h1 class="text-3xl leading-tight font-bold text-white sm:text-4xl lg:text-5xl">
				Euch brummt der Kopf von der Karenzplanung?
			</h1>
			<p class="text-base leading-relaxed text-white/90 sm:text-lg">
				Die Karenzplanung ist eine riesige Herausforderung: Warum hat man ein Recht auf zwei Jahre
				Karenz (Freistellung) auf Arbeit, aber es werden nur 14 Monate beim einkommensabhängigen
				Betreuungsgeld (ea KBG) bezahlt? Welches der zwei Modelle soll ich wählen?
			</p>
			<p class="text-base leading-relaxed text-white/90 sm:text-lg">
				Ebenso herausfordernd ist die Frage der Kinderbetreuung nach der Karenz: Wann ist unser Kind
				bereit in eine Kindergarten-Gruppe zu gehen, wie viele Stunde sind anfangs gut? Oder doch
				erst zu einer Tagesmutter, den Großeltern - oder beide Elternteile arbeiten 20h/Woche in
				Eltern-Teilzeit und wechseln sich mittags ab? Oder bleibt einer von uns doch länger in
				Karenz? Wie organisiert man eine längere, unbezahlte Karenz nach 14 Monaten ea KBG? Können
				wir uns das leisten? Und wie schaut es hier mit der Krankenversicherung aus?
			</p>
			<!-- <p class="text-base leading-relaxed text-white/90 sm:text-lg">
				Finden wir es als Eltern gut, wenn unser Kind mit einem Jahr und 2 Monaten Lebensalter (14
				Monate) schon in eine Kindergarten-Gruppe geht?
			</p> -->
			<p class="text-base leading-relaxed text-white/90 sm:text-lg">
				Und wie regeln wir die Gleichberechtigung? Wie kommen wir aus der bisherigen Falle heraus,
				dass der Vater nur die minimalen 2 Monate Karenz nimmt - wie so viele Männer in Österreich
				aktuell. Ganze Männer machen ja eigentlich halbe halbe.
			</p>

			<p>
				Diese private Webseite soll eine kleine Hilfestellung geben. Als Neu-Eltern standen wir vor
				kurzem selber erst vor diesem Berg an Fragen.
			</p>
			<!-- <div class="flex flex-wrap justify-center gap-4">
				<a
					class="inline-flex items-center justify-center rounded-full bg-white px-6 py-3 text-sm font-semibold text-indigo-700 shadow transition hover:bg-slate-50 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-white/70"
					href="/eakbg-planer">Planer starten</a
				>
				<a
					class="inline-flex items-center justify-center rounded-full border border-white/70 bg-white/10 px-6 py-3 text-sm font-semibold text-white transition hover:bg-white/20 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-white/70"
					href="/anspruch">Anspruch prüfen</a
				>
			</div> -->
		</div>
		<div class="flex flex-1 items-center justify-center">
			<div
				class="h-64 w-full max-w-md rounded-2xl border border-white/30 bg-white/10 p-6 backdrop-blur-sm"
			>
				<div
					class="flex h-full w-full items-center justify-center rounded-xl border border-dashed border-white/50 text-center text-sm font-medium text-white/80"
				>
					Geplante Visualisierung<br />wird hier ergänzt
				</div>
			</div>
		</div>
	</div>
</section>

<section class="mx-auto mt-20 max-w-6xl px-6 sm:px-10">
	<div class="max-w-3xl">
		<h2 class="text-2xl font-semibold text-slate-900 sm:text-3xl">Alle Schritte im Blick</h2>
		<!-- <p class="mt-4 text-base leading-relaxed text-slate-600">
			Wählen Sie den Bereich, der Sie gerade weiterbringt – von der Anspruchsprüfung bis zu
			praktischen Hilfestellungen.
		</p> -->
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
					<h3 class="mt-3 text-xl font-semibold text-slate-900">{card.title}</h3>
					{#each card.description as paragraph}
						<p class="mt-3 text-sm leading-relaxed text-slate-600">{paragraph}</p>
					{/each}
				</div>
				<div class="px-6 pb-6">
					<a
						class="inline-flex items-center justify-center rounded-full bg-indigo-600 px-5 py-2.5 text-sm font-semibold text-white transition hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
						href={card.href}>{card.cta}</a
					>
				</div>
			</article>
		{/each}
	</div>
</section>
