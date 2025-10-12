<script lang="ts">
	type Link = { label: string; href: string; underline?: boolean };
	type NoteItem = {
		id: string;
		sup: number | string;
		title: string;
		body: string; // one paragraph (no <p> in data)
		more?: Link[]; // “Mehr: …” links
		references?: Link[]; // “Quellen: …” links (official refs)
	};

	const items: NoteItem[] = [
		{
			id: 'mutterschutz-vor',
			sup: 1,
			title: 'Mutterschutz vor Geburt',
			body: `
        Acht Wochen vor dem errechneten Geburtstermin gilt ein Beschäftigungsverbot („Schutzfrist“).
        Währenddessen ersetzt das Wochengeld den entfallenden Verdienst (Bemessung durch die ÖGK auf Basis der letzten Entgeltzeiträume inkl. Sonderzahlungen).
        Kommt das Kind früher, wird die zu kurze Vorfrist nach der Geburt angehängt (insgesamt max. 16 Wochen Schutzfrist).
        Schwangerschaft rechtzeitig melden und Wochengeld beantragen.
      `,
			more: [
				{
					label: 'AK: Mutterschutz',
					href: 'https://www.arbeiterkammer.at/mutterschutzregelung',
					underline: true
				}
			],
			references: [
				{ label: 'AK: Mutterschutz', href: 'https://www.arbeiterkammer.at/mutterschutzregelung' },
				{
					label: 'Arbeitsinspektion: FAQ Mutterschutz',
					href: 'https://www.arbeitsinspektion.gv.at/Personengruppen/Werdende_und_stillende_Muetter/FAQ_zum_Mutterschutz.html'
				}
			]
		},
		{
			id: 'mutterschutz-nach',
			sup: 2,
			title: 'Mutterschutz nach Geburt',
			body: `
        Nach der Entbindung besteht grundsätzlich 8 Wochen Schutzfrist; bei Frühgeburten, Mehrlingen oder Kaiserschnitt mindestens 12 Wochen.
        Verkürzte Vorfristen werden nach der Geburt angehängt (Gesamtgrenze i. d. R. 16 Wochen).
        Während der Schutzfrist gebührt weiterhin Wochengeld; erst danach beginnt die Karenz-/KBG-Phase.
      `,
			more: [
				{
					label: 'AK: Mutterschutz',
					href: 'https://www.arbeiterkammer.at/mutterschutzregelung',
					underline: true
				}
			],
			references: [
				{ label: 'AK: Mutterschutz', href: 'https://www.arbeiterkammer.at/mutterschutzregelung' },
				{
					label: 'oesterreich.gv.at: Mutterschutz',
					href: 'https://www.oesterreich.gv.at/themen/arbeit_und_pension/arbeitsrecht/Seite.1660200.html'
				}
			]
		},
		{
			id: 'eakbg',
			sup: 3,
			title: 'Einkommensabhängiges Kinderbetreuungsgeld (ea KBG)',
			body: `
        Das ea KBG beträgt 80 % eines fiktiven Wochengeldes (mit Deckelung; jährliche Valorisierung).
        Anspruch setzt u. a. 182 Kalendertage ununterbrochene, vollversicherungspflichtige Erwerbstätigkeit in Österreich in den 182 Tagen vor der Geburt voraus; in diesem Zeitraum dürfen keine Leistungen aus der Arbeitslosenversicherung bezogen worden sein.
        Der Bezug ruht während des Mutterschutzes und wird danach ausbezahlt.
        Maximal 365 Tage ab Geburt pro Elternteil; bei Inanspruchnahme durch beide insgesamt bis zu 426 Tage ab Geburt. Jeder Bezugsblock muss mindestens 61 Tage dauern.
      `,
			more: [
				{
					label: 'BKA: ea KBG – Voraussetzungen',
					href: 'https://www.bundeskanzleramt.gv.at/agenda/familie/kinderbetreuungsgeld/basisinformationen-kinderbetreuungsgeld/einkommensabhaengiges-kinderbetreuungsgeld.html',
					underline: true
				},
				{
					label: 'AK: Kinderbetreuungsgeld (Überblick & Regeln)',
					href: 'https://www.arbeiterkammer.at/kbg',
					underline: true
				}
			],
			references: [
				{
					label: 'BKA: ea KBG – Voraussetzungen & Dauer',
					href: 'https://www.bundeskanzleramt.gv.at/agenda/familie/kinderbetreuungsgeld/basisinformationen-kinderbetreuungsgeld/einkommensabhaengiges-kinderbetreuungsgeld.html'
				},
				{ label: 'AK: KBG – Varianten & Mindestblöcke', href: 'https://www.arbeiterkammer.at/kbg' },
				{
					label: 'ÖGK: KBG allgemein',
					href: 'https://www.gesundheitskasse.at/cdscontent/?contentid=10007.880037'
				}
			]
		},
		{
			id: 'sonderleistung-1',
			sup: 4,
			title: 'Sonderleistung I',
			body: `
        Erfüllt ein Elternteil die Erwerbstätigkeitsvoraussetzung nicht oder liegt dessen errechneter Tagesbetrag unter dem Mindestwert,
        kann für diesen Elternteil eine „Sonderleistung I“ (fixer Tagesbetrag, z. B. 2025: 41,14 €) beantragt werden.
        So bleibt das ea-KBG-Modell nutzbar, während der andere Elternteil regulär ea KBG bezieht.
        Höhe und Werte werden regelmäßig valorisiert – aktuelle Beträge prüfen.
      `,
			more: [
				{
					label: 'BKA: ea KBG – Sonderleistung I',
					href: 'https://www.bundeskanzleramt.gv.at/agenda/familie/kinderbetreuungsgeld/basisinformationen-kinderbetreuungsgeld/einkommensabhaengiges-kinderbetreuungsgeld.html',
					underline: true
				},
				{
					label: 'AK: KBG – Sonderleistung (Werte)',
					href: 'https://www.arbeiterkammer.at/kbg',
					underline: true
				}
			],
			references: [
				{
					label: 'BKA: Sonderleistung I – Details',
					href: 'https://www.bundeskanzleramt.gv.at/agenda/familie/kinderbetreuungsgeld/basisinformationen-kinderbetreuungsgeld/einkommensabhaengiges-kinderbetreuungsgeld.html'
				},
				{ label: 'AK: KBG – Werte & Index', href: 'https://www.arbeiterkammer.at/kbg' }
			]
		},
		{
			id: 'gemeinsamer-monat',
			sup: 5,
			title: 'Gemeinsamer Monat',
			body: `
        Beim ersten Wechsel dürfen beide Eltern bis zu 31 Tage gleichzeitig KBG beziehen; die Gesamtanspruchsdauer verkürzt sich um die überlappenden Tage.
        Jeder Bezugsblock muss durchgehend mindestens 61 Tage umfassen.
        Die gemeinsame Phase eignet sich z. B. für Übergabe oder Eingewöhnung – die Verkürzung unbedingt im Zeitplan berücksichtigen.
      `,
			more: [
				{
					label: 'AK: KBG – Aufteilung & gleichzeitiger Bezug',
					href: 'https://www.arbeiterkammer.at/kbg',
					underline: true
				}
			],
			references: [
				{ label: 'AK: KBG – Teilung & Überlappung', href: 'https://www.arbeiterkammer.at/kbg' }
			]
		},
		{
			id: 'papamonat-fzb',
			sup: 6,
			title: 'Papamonat (und Familienzeitbonus)',
			body: `
        Der Papamonat ist eine Freistellung des anderen Elternteils ab Entlassung von Mutter/Kind aus dem Krankenhaus bis längstens zum Ende der Schutzfrist.
        Einkommen gibt es dabei keines; finanziell unterstützt der Familienzeitbonus (28–31 Tage, innerhalb einer Frist ab Geburt zu beziehen).
        Voraussetzung u. a.: durchgehende vollversicherungspflichtige Erwerbstätigkeit 182 Tage vor Beginn des Bonus; kein AMS-Bezug im Beobachtungszeitraum. Antragsfristen unbedingt beachten.
      `,
			more: [
				{
					label: 'AK: Papamonat & Familienzeitbonus',
					href: 'https://www.arbeiterkammer.at/papamonat',
					underline: true
				},
				{
					label: 'ÖGK: Familienzeitbonus – Fristen/Unterlagen',
					href: 'https://www.gesundheitskasse.at/cdscontent/?contentid=10007.879676&portal=oegkportal',
					underline: true
				}
			],
			references: [
				{
					label: 'AK: Papamonat – Recht & Ablauf',
					href: 'https://www.arbeiterkammer.at/papamonat'
				},
				{
					label: 'ÖGK: Familienzeitbonus',
					href: 'https://www.gesundheitskasse.at/cdscontent/?contentid=10007.879676&portal=oegkportal'
				}
			]
		},
		{
			id: 'unbezahlte-karenz',
			sup: 7,
			title: 'Unbezahlte Karenz',
			body: `
        Arbeitsrechtlich besteht ein Anspruch auf Karenz bis zum vollendeten 2. Lebensjahr des Kindes (Freistellung ohne Entgelt).
        Das ist vom Kinderbetreuungsgeld zu trennen; die staatliche Leistung kann früher enden.
        Meldefristen gegenüber dem Arbeitgeber beachten (Meldung spätestens am letzten Tag der Schutzfrist, wenn die Mutter zuerst in Karenz geht).
        Bei Verlängerungen ohne KBG unbedingt Kranken-/Pensionsversicherung klären (z. B. Mitversicherung, freiwillige Versicherung).
      `,
			more: [
				{
					label: 'oesterreich.gv.at: Elternkarenz – Rechtsanspruch',
					href: 'https://www.oesterreich.gv.at/de/themen/arbeit_beruf_und_pension/Karenz-und-Mutterschutz/elternkarenz_und_elternteilzeit/Seite.3590007',
					underline: true
				},
				{
					label: 'AK: Meldefristen Karenz',
					href: 'https://www.arbeiterkammer.at/beratung/berufundfamilie/Karenz/Meldefristen.html',
					underline: true
				}
			],
			references: [
				{
					label: 'oesterreich.gv.at: Elternkarenz',
					href: 'https://www.oesterreich.gv.at/de/themen/arbeit_beruf_und_pension/Karenz-und-Mutterschutz/elternkarenz_und_elternteilzeit/Seite.3590007'
				},
				{
					label: 'AK: Meldefristen',
					href: 'https://www.arbeiterkammer.at/beratung/berufundfamilie/Karenz/Meldefristen.html'
				}
			]
		},
		{
			id: 'elternteilzeit',
			sup: 8,
			title: 'Eltern-Teilzeit',
			body: `
        Rechtsanspruch besteht, wenn der Betrieb mehr als 20 Beschäftigte hat und das Arbeitsverhältnis bereits 3 Jahre ununterbrochen gedauert hat (Mutterschutz/Karenz zählen mit).
        Ohne Rechtsanspruch ist eine „vereinbarte Elternteilzeit“ möglich, wenn der Arbeitgeber zustimmt.
        Elternteilzeit kann sowohl Reduktion der Stunden als auch eine Änderung der Lage der Arbeitszeit bedeuten.
      `,
			more: [
				{
					label: 'AK: Elternteilzeit – Anspruch & Optionen',
					href: 'https://www.arbeiterkammer.at/elternteilzeit',
					underline: true
				},
				{
					label: 'oesterreich.gv.at: Vereinbarte Teilzeit',
					href: 'https://www.oesterreich.gv.at/de/themen/arbeit_beruf_und_pension/Karenz-und-Mutterschutz/elternkarenz_und_elternteilzeit/Seite.3590004',
					underline: true
				}
			],
			references: [
				{
					label: 'AK: Elternteilzeit – Voraussetzungen',
					href: 'https://www.arbeiterkammer.at/elternteilzeit'
				},
				{
					label: 'oesterreich.gv.at: Elternteilzeit',
					href: 'https://www.oesterreich.gv.at/de/themen/arbeit_beruf_und_pension/Karenz-und-Mutterschutz/elternkarenz_und_elternteilzeit/Seite.3590004'
				}
			]
		}
	];

	// collapsed by default
	let open = $state(false);
</script>

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
				> hilft beim Fristen im Blick halten.
			</p>

			<div class="grid gap-6 md:grid-cols-2">
				{#each items as it (it.id)}
					<section class="space-y-1.5">
						<h4 id={it.id}><sup>{it.sup}</sup> {it.title}</h4>

						<p>{@html it.body}</p>

						{#if it.more?.length}
							<div class="mt-2 text-xs text-slate-700">
								<span class="mr-1 font-semibold">Mehr:</span>
								{#each it.more as link, i (link.href)}
									<a href={link.href} class={link.underline ? 'underline' : ''}>{link.label}</a
									>{#if i < it.more.length - 1}
										<span aria-hidden="true"> · </span>{/if}
								{/each}
							</div>
						{/if}

						{#if it.references?.length}
							<div class="mt-1 text-[11px] text-slate-600">
								<span class="mr-1 font-semibold">Quellen:</span>
								{#each it.references as ref, i (ref.href)}
									<a href={ref.href} class="underline">{ref.label}</a
									>{#if i < it.references.length - 1}
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
	:global(details > summary::-webkit-details-marker) {
		display: none;
	}
	:global(details > summary) {
		list-style: none;
	}
</style>
