<script>
	// TODO: check links
	// TODO: add Burgenland https://bgld.arbeiterkammer.at/vaeterkarenz
	const akList = [
		{
			name: 'Burgenland',
			links: [
				{ title: 'Startseite', url: 'https://bgld.arbeiterkammer.at' },
				{ title: 'Kontakt', url: 'https://www.arbeiterkammer.at/kontakt/akburgenland.html' }
			]
		},
		{
			name: 'Kärnten',
			links: [
				{ title: 'Startseite', url: 'https://kaernten.arbeiterkammer.at' },
				{ title: 'Kontakt', url: 'https://kaernten.arbeiterkammer.at/kontakt' }
			]
		},
		{
			name: 'Niederösterreich',
			links: [
				{ title: 'Startseite', url: 'https://noe.arbeiterkammer.at' },
				{ title: 'Kontakt', url: 'https://www.arbeiterkammer.at/kontakt/aknoe.html' }
			]
		},
		{
			name: 'Oberösterreich',
			links: [
				{ title: 'Startseite', url: 'https://ooe.arbeiterkammer.at' },
				{ title: 'Kontakt', url: 'https://www.arbeiterkammer.at/kontakt/akooe.html' }
			]
		},
		{
			name: 'Salzburg',
			links: [
				{ title: 'Startseite', url: 'https://sbg.arbeiterkammer.at' },
				{ title: 'Kontakt', url: 'https://www.arbeiterkammer.at/kontakt/aksbg.html' }
			]
		},
		{
			name: 'Steiermark',
			links: [
				{ title: 'Startseite', url: 'https://stmk.arbeiterkammer.at' },
				{ title: 'Kontakt', url: 'https://www.arbeiterkammer.at/kontakt/akstmk.html' }
			]
		},
		{
			name: 'Tirol',
			links: [
				{ title: 'Startseite', url: 'https://tirol.arbeiterkammer.at' },
				{ title: 'Kontakt', url: 'https://www.arbeiterkammer.at/kontakt/AK_Tirol.html' }
			]
		},
		{
			name: 'Vorarlberg',
			links: [
				{ title: 'Startseite', url: 'https://vbg.arbeiterkammer.at' },
				{ title: 'Kontakt', url: 'https://www.arbeiterkammer.at/kontakt/akvbg.html' }
			]
		},
		{
			name: 'Wien',
			links: [
				{
					title: 'Beratung Elternkarenz',
					url: 'https://wien.arbeiterkammer.at/ueberuns/kontakt/elternkarenz/Elternkarenz.html'
				}
			]
		}
	];
</script>

<div class="layout mx-auto w-full max-w-[1200px]">
	<div class="page-header mt-10">
		<h2 class="text-2xl font-semibold text-slate-900">
			Kostenfreie Beratung bei der Arbeiterkammer
		</h2>

		<!-- 🖼️ Bilder -->
		<div class="mt-4 grid grid-cols-1 gap-4 sm:grid-cols-2">
			<img
				src="/ak_wien_ottakring_außengebauede.jpg"
				alt=""
				class="w-full rounded-2xl object-cover shadow-md"
			/>
			<img
				src="/ak_wien_ottakring_wartebereich.jpg"
				alt=""
				class="w-full rounded-2xl object-cover shadow-md"
			/>
		</div>
	</div>

	<div class="content prose mt-6">
		<p class="font-bold">🚧 Inhalt in Arbeit 🚧</p>
		<p>
			Die Arbeiterkammer deines Bundeslandes berät dich kostenfrei zu Elternkarenz sowie
			Sozialversicherungsfragen.
		</p>

		<ul>
			{#each akList as ak}
				<li class="my-3">
					<strong>{ak.name}</strong>

					{#if ak.links.length > 0}
						<ul class="ml-4">
							{#each ak.links as link}
								<li>
									<a href={link.url} target="_blank" rel="noopener">{link.title}</a>
								</li>
							{/each}
						</ul>
					{:else}
						<ul class="ml-4">
							<li class="text-slate-500 italic">Links folgen</li>
						</ul>
					{/if}
				</li>
			{/each}
		</ul>
	</div>
</div>
