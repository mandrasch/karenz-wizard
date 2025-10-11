<script lang="ts">
	const faqs = [
		{
			id: 'papamonat-direkt-nach-geburt',
			question: 'Kann man den Papamonat direkt ab Geburt nehmen?',
			answer: []
		},
		{
			id: 'familienzeitbonus-und-ams',
			question: 'AMS-Bezug vorher = kein Familienzeitbonus im Papamonat?',
			answer: []
		},
		{
			id: 'kombination-kbg-modelle',
			question:
				'Kann man Einkommensabhängiges KBG und Pauschales KBG nutzen, wenn einer vorher nicht 6 Monate (182 Tage) gearbeitet hat?',
			answer: []
		},
		{
			id: 'unbezahlte-karenz-organisieren',
			question: 'Wie organisiert man eine unbezahlte Karenz?',
			answer: []
		},
		{
			id: 'empfohlene-fremdbetreuung',
			question: 'Ab wann wird Fremdbetreuung im Kindergarten offiziell frühestens empfohlen?',
			answer: []
		},
		{
			id: 'spaeterer-kindergartenstart-wien',
			question: 'Kann mein Kind später in das Kindergartenjahr einsteigen in Wien?',
			answer: []
		},
		{
			id: 'recht-auf-elternteilzeit',
			question: 'Ab wann gilt das Recht auf Eltern-Teilzeit?',
			answer: []
		},
		{
			id: 'unterstuetzung-nach-karenz',
			question: 'Wie unterstützt der Sozialstaat Österreich nach der Karenz?',
			answer: []
		},
		{
			id: 'regenbogenfamilien',
			question: 'Wie ist die Lage für Regenbogen-Familien? 🌈',
			answer: []
		}
	];

	// Füge Inhalte hinzu, indem du faq.answer mit HTML-Strings (z. B. `<p>...</p>`) befüllst.
</script>


<section class="content">
	<header class="mt-10 space-y-2">
		<h1 class="text-3xl font-semibold text-slate-900">FAQ</h1>
		<p class="text-base text-slate-600">
			Antworten auf häufige Fragen rund um Papamonat, Karenz und Kinderbetreuung in Österreich.
		</p>
	</header>
	<div class="prose mt-8 max-w-none">
		<nav
			aria-label="FAQ Inhaltsverzeichnis"
			class="not-prose rounded-lg border border-slate-200 bg-slate-50 p-4"
		>
			<h2 class="text-lg font-semibold text-slate-900">Inhaltsübersicht</h2>
			<ul class="mt-3 space-y-2">
				{#each faqs as faq}
					<li>
						<a
							class="inline-flex items-center gap-1 text-slate-700 underline decoration-slate-400 underline-offset-4 hover:text-slate-900 hover:decoration-slate-600 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-slate-500"
							href={`#${faq.id}`}
						>
							{faq.question}
						</a>
					</li>
				{/each}
			</ul>
		</nav>

		<div class="mt-10 space-y-12">
			{#each faqs as faq}
				<section
					id={faq.id}
					class="scroll-mt-24 rounded-lg border border-slate-200 bg-white p-6 shadow-sm"
					aria-labelledby={`${faq.id}-heading`}
				>
					<h2
						id={`${faq.id}-heading`}
						class="group flex items-center gap-2 text-2xl font-semibold text-slate-900"
					>
						<span>{faq.question}</span>
						<a
							href={`#${faq.id}`}
							class="text-slate-400 transition-colors hover:text-slate-600 focus-visible:text-slate-600 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-slate-500"
							aria-label={`Direktlink zu ${faq.question}`}
						>
							<svg
								aria-hidden="true"
								class="h-5 w-5"
								fill="currentColor"
								viewBox="0 0 20 20"
								xmlns="http://www.w3.org/2000/svg"
							>
								<path
									fill-rule="evenodd"
									d="M12.586 3.172a4 4 0 0 1 5.657 5.656l-2.828 2.829a4 4 0 0 1-5.657 0 1 1 0 0 1 1.414-1.415 2 2 0 0 0 2.829 0l2.828-2.828a2 2 0 1 0-2.829-2.829l-1.06 1.06a1 1 0 1 1-1.415-1.414l1.06-1.06Zm-5.172 5.172a1 1 0 0 1 0 1.414l-1.06 1.06a2 2 0 1 0 2.828 2.829l1.061-1.061a1 1 0 0 1 1.414 1.414l-1.06 1.061a4 4 0 1 1-5.657-5.657l1.06-1.06a1 1 0 0 1 1.414 0Z"
									clip-rule="evenodd"
								/>
							</svg>
							<span class="sr-only">Link kopieren</span>
						</a>
					</h2>
					{#if faq.answer.length}
						<div class="mt-4 space-y-4 text-slate-700">
							{#each faq.answer as paragraph}
								{@html paragraph}
							{/each}
						</div>
					{/if}
					<p class="mt-6 text-sm text-slate-500">
						Für verbindliche Auskünfte wende dich an Arbeiterkammer, Gewerkschaft oder deine
						zuständige Sozialversicherung – Gesetze können sich ändern.
					</p>
				</section>
			{/each}
		</div>
	</div>
</section>
