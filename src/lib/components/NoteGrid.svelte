<script lang="ts">
	type MoreLink = { label: string; href: string; underline?: boolean };
	type NoteItem = {
		id: string;
		sup: number | string;
		title: string;
		body: string; // plain HTML inline (no <p>)
		more?: MoreLink[]; // links for the “Mehr:” line
	};

	const items: NoteItem[] = [
		{
			id: 'mutterschutz-vor',
			sup: 1,
			title: 'Mutterschutz vor Geburt',
			body: `
        Acht Wochen vor dem errechneten Geburtstermin gilt ein gesetzliches Beschäftigungsverbot für werdende Mütter.
        Statt Lohn zahlt die ÖGK das sogenannte <em>Wochengeld</em>, berechnet aus den letzten drei Monatsgehältern inklusive Sonderzahlungen;
        es entspricht meist dem Netto oder liegt leicht darüber. Frühgeburten verschieben die Frist – fällt der Zeitraum vor der Geburt kürzer aus,
        verlängert sich der Mutterschutz danach entsprechend. Wichtig: Schwangerschaft rechtzeitig dem Arbeitgeber melden und den Antrag bei der ÖGK stellen.
      `,
			more: [
				{
					label: 'AK Mutterschutz',
					href: 'https://www.arbeiterkammer.at/mutterschutzregelung',
					underline: true
				},
				{ label: 'FAQ', href: '#faq', underline: true }
			]
		},
		{
			id: 'mutterschutz-nach',
			sup: 2,
			title: 'Mutterschutz nach Geburt',
			body: `
        Nach der Entbindung besteht ein Beschäftigungsverbot von acht Wochen; bei Frühgeburten, Mehrlingen oder Kaiserschnitt sind es mindestens zwölf Wochen.
        Das Wochengeld läuft während dieser Zeit weiter, sodass Mütter auch nach der Geburt finanziell abgesichert sind.
        Wird das Kind früher geboren, wird die zu kurze Zeit vor der Geburt hinten drangehängt – insgesamt meist 16 Wochen Schutzfrist.
        Erst danach beginnt die Karenz- und KBG-Phase.
      `,
			more: [
				{
					label: 'AK Mutterschutz',
					href: 'https://www.arbeiterkammer.at/mutterschutzregelung',
					underline: true
				},
				{ label: 'FAQ', href: '#faq', underline: true }
			]
		},
		{
			id: 'eakbg',
			sup: 3,
			title: 'Einkommensabhängiges Kinderbetreuungsgeld (ea KBG)',
			body: `
        Das einkommensabhängige Kinderbetreuungsgeld ersetzt rund 80 % des letzten Nettoeinkommens (bis zum Höchstsatz)
        und beginnt <em>nach</em> dem Mutterschutz. Insgesamt sind – bei Aufteilung – maximal 14 Monate möglich (typisch 12 + 2),
        pro Elternteil höchstens 12 Monate, jede/r braucht mindestens 61 Tage eigenen Bezug.
        Voraussetzung: 182 Tage durchgehende Erwerbstätigkeit vor Bezug, kein AMS-Bezug, Modellwahl ist für beide bindend.
      `,
			more: [
				{
					label: 'AK Kinderbetreuungsgeld',
					href: 'https://www.arbeiterkammer.at/beratung/berufundfamilie/kinderbetreungsgeld/Kinderbetreuungsgeld.html',
					underline: true
				},
				{ label: 'FAQ', href: '#faq', underline: true }
			]
		},
		{
			id: 'sonderleistung-1',
			sup: 4,
			title: 'Sonderleistung I',
			body: `
        Wenn ein Elternteil die 182-Tage-Erwerbstätigkeitsvoraussetzung fürs ea KBG nicht erfüllt, kann die
        „Sonderleistung I“ (rund 41 €/Tag) beantragt werden. So bleibt das Modell nutzbar, auch wenn der zweite Elternteil
        die Bedingung nicht erfüllt. Antrag rechtzeitig bei der ÖGK stellen und Nachweise bereithalten.
      `,
			more: [
				{ label: 'Anspruch prüfen', href: '/eakbg-anspruch', underline: true },
				{ label: 'FAQ: Sonderleistung I', href: '/faq#sonderleistung-1', underline: true },
				{
					label: 'AK KBG',
					href: 'https://www.arbeiterkammer.at/beratung/berufundfamilie/kinderbetreungsgeld/Kinderbetreuungsgeld.html',
					underline: true
				},
				{ label: 'Allgemeines FAQ', href: '#faq', underline: true }
			]
		},
		{
			id: 'gemeinsamer-monat',
			sup: 5,
			title: 'Gemeinsamer Monat',
			body: `
        Eltern können bis zu 31 Tage gleichzeitig KBG beziehen – die Gesamtdauer verkürzt sich um diese Tage.
        Beide müssen mindestens 61 Tage eigenen Bezug haben. Der gemeinsame Monat eignet sich gut für Übergabe oder
        gemeinsame Eingewöhnung. Wichtig: Verkürzung im Zeitplan berücksichtigen und Wechsel rechtzeitig bei der ÖGK anmelden.
      `,
			more: [
				{
					label: 'AK KBG',
					href: 'https://www.arbeiterkammer.at/beratung/berufundfamilie/kinderbetreungsgeld/Kinderbetreuungsgeld.html',
					underline: true
				},
				{ label: 'FAQ', href: '#faq', underline: true }
			]
		},
		{
			id: 'papamonat-fzb',
			sup: 6,
			title: 'Papamonat (und Familienzeitbonus)',
			body: `
        Der Papamonat ist ein Monat Freistellung ab Entlassung von Mutter und Kind aus dem Krankenhaus bis zum Ende des Mutterschutzes.
        Der Arbeitgeber zahlt kein Gehalt, aber es gibt den Familienzeitbonus (ca. 28–31 Tage, eigener Antrag).
        Voraussetzung: 182 Tage Erwerbstätigkeit vor Beginn, kein AMS-Bezug im Beobachtungszeitraum, Antrag fristgerecht stellen.
        Das Recht auf Freistellung gilt unabhängig vom Bonus.
      `,
			more: [
				{ label: 'AK Papamonat', href: 'https://www.arbeiterkammer.at/papamonat', underline: true },
				{ label: 'FAQ', href: '#faq', underline: true }
			]
		},
		{
			id: 'unbezahlte-karenz',
			sup: 7,
			title: 'Unbezahlte Karenz',
			body: `
        Nach Ende des KBG-Bezugs kann die Karenz ohne Zahlung verlängert werden – der Arbeitsplatz bleibt gesichert.
        Prüft Kranken- und Pensionsversicherung (z. B. Mitversicherung beim Partner; bei unverheirateten Paaren „10 unbezahlte Monate Haushaltsführung“).
        Arbeitgeber rechtzeitig informieren. Alternativen: Eltern-Teilzeit, Tagesmutter, Großeltern.
      `,
			more: [
				{
					label: 'FAQ: Unbezahlte Karenz organisieren',
					href: '/faq/#unbezahlte-karenz-organisieren',
					underline: true
				},
				{
					label: 'AK Karenz',
					href: 'https://www.arbeiterkammer.at/beratung/berufundfamilie/karenz',
					underline: true
				}
			]
		},
		{
			id: 'elternteilzeit',
			sup: 8,
			title: 'Eltern-Teilzeit',
			body: `
        Anspruch besteht in Betrieben mit mehr als 20 Beschäftigten und nach drei Jahren Betriebszugehörigkeit,
        möglich bis zum 8. Geburtstag des Kindes. Ohne Anspruch ist eine „vereinbarte Elternteilzeit“ möglich, wenn der Arbeitgeber zustimmt.
        Wichtig: rechtzeitig melden und Lage/Umfang der Arbeitszeit fixieren; beide Eltern können gleichzeitig Teilzeit arbeiten.
      `,
			more: [
				{
					label: 'AK Elternteilzeit',
					href: 'https://www.arbeiterkammer.at/elternteilzeit',
					underline: true
				},
				{ label: 'FAQ', href: '#faq', underline: true }
			]
		}
	];

	// collapsed by default
	let open = $state(false);
</script>

<!-- Accessible, native collapsible wrapper -->
<details class="group rounded-2xl border border-neutral-200/70 bg-white shadow-sm" bind:open>
	<summary
		class="flex w-full cursor-pointer items-center justify-between gap-3 rounded-2xl px-4 py-3 text-slate-800/90 outline-none select-none
             focus-visible:ring-2 focus-visible:ring-indigo-600/60 focus-visible:ring-offset-2 focus-visible:ring-offset-white md:px-5 md:py-4"
		aria-label="Glossar zur Elternkarenz ein- und ausklappen"
	>
		<div class="flex items-center gap-3">
			<div class="flex flex-col">
				<span class="text-base font-semibold text-slate-900 sm:text-lg"
					>Die Begriffe kurz erklärt</span
				>
			</div>
		</div>
		<svg
			class="h-5 w-5 shrink-0 transition-transform duration-200 group-open:rotate-180"
			viewBox="0 0 24 24"
			fill="none"
			aria-hidden="true"
		>
			<path
				d="M6 9l6 6 6-6"
				stroke="currentColor"
				stroke-width="2"
				stroke-linecap="round"
				stroke-linejoin="round"
			/>
		</svg>
	</summary>

	<!-- Collapsible content -->
	<aside
		class="note-box rounded-b-2xl border-t border-neutral-200/70 bg-neutral-50 p-4 shadow-sm md:p-6"
	>
		<div class="prose prose-sm max-w-none leading-tight">
			<h3 class="mb-2">🚧 Die Begriffe kurz erklärt – in Arbeit 🚧</h3>
			<p class="mb-1 text-xs">
				Viele Begriffe &amp; Fristen – keine Sorge, man blickt am Ende durch.
			</p>
			<p class="mb-1 text-xs">
				<span class="font-medium text-red-600"
					>Wichtig: Anspruchsvoraussetzungen und Fristen prüfen!</span
				>
				Der
				<a href="https://elternkalender.arbeiterkammer.at/index.html" class="underline"
					>AK-Elternkalender</a
				>
				hilft beim Fristen im Blick halten.
			</p>

			<!-- Two-column responsive layout → 1–2, 3–4, 5–6 … -->
			<div class="grid gap-6 md:grid-cols-2">
				{#each items as it (it.id)}
					<section class="space-y-1.5">
						<h4 id={it.id}><sup>{it.sup}</sup> {it.title}</h4>

						<!-- body is 1 paragraph (no <p> in data) -->
						<p>{@html it.body}</p>

						{#if it.more?.length}
							<div class="mt-2 text-xs text-slate-700">
								<span class="mr-1 font-semibold">Mehr:</span>
								<!-- dot-separated links -->
								{#each it.more as link, i (link.href)}
									<a href={link.href} class={link.underline ? 'underline' : ''}>{link.label}</a
									>{#if i < it.more.length - 1}
										<span aria-hidden="true"> · </span>{/if}
								{/each}
							</div>
						{/if}
					</section>
				{/each}
			</div>

			<p class="mt-4 mb-0 text-xs">
				Hinweis: Auch der Vater kann den ersten Karenzteil übernehmen.
			</p>
		</div>
	</aside>
</details>

<style>
	/* Hide default marker but keep native semantics */
	:global(details > summary::-webkit-details-marker) {
		display: none;
	}
	:global(details > summary) {
		list-style: none;
	}
</style>
