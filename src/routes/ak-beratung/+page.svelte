<script>
	// TODO: check links
	// TODO: add Burgenland https://bgld.arbeiterkammer.at/vaeterkarenz
	const akList = [
		{
			name: 'Burgenland',
			links: [
				/*{ title: 'Startseite', url: 'https://bgld.arbeiterkammer.at' },
				{ title: 'Väterkarenz', url: 'https://bgld.arbeiterkammer.at/vaeterkarenz' },
				{
					title: 'Kontakt: Arbeitsrecht',
					url: 'https://bgld.arbeiterkammer.at/ueberuns/kontakt/index.html'
				}*/
			]
		},
		{
			name: 'Kärnten',
			links: [
				/*{ title: 'Startseite', url: 'https://kaernten.arbeiterkammer.at' },
				{
					title: 'Kontakt: Mutterschutz und Elternkarenz',
					url: 'https://kaernten.arbeiterkammer.at/ueberuns/kontakt/karenz/Mutterschutz___Karenz.html'
				}*/
			]
		},
		{
			name: 'Niederösterreich',
			links: [
				/*
				{ title: 'Startseite', url: 'https://noe.arbeiterkammer.at' },
				{ title: 'Kontakt', url: 'https://www.arbeiterkammer.at/kontakt/aknoe.html' }
			*/
			]
		},
		{
			name: 'Oberösterreich',
			links: [
				/*
				{ title: 'Startseite', url: 'https://ooe.arbeiterkammer.at' },
				{ title: 'Kontakt', url: 'https://www.arbeiterkammer.at/kontakt/akooe.html' }
			*/
			]
		},
		{
			name: 'Salzburg',
			links: [
				/*
				{ title: 'Startseite', url: 'https://sbg.arbeiterkammer.at' },
				{ title: 'Kontakt', url: 'https://www.arbeiterkammer.at/kontakt/aksbg.html' }
			*/
			]
		},
		{
			name: 'Steiermark',
			links: [
				/*
				{ title: 'Startseite', url: 'https://stmk.arbeiterkammer.at' },
				{ title: 'Kontakt', url: 'https://www.arbeiterkammer.at/kontakt/akstmk.html' }
			*/
			]
		},
		{
			name: 'Tirol',
			links: [
				/*
				{ title: 'Startseite', url: 'https://tirol.arbeiterkammer.at' },
				{ title: 'Kontakt', url: 'https://www.arbeiterkammer.at/kontakt/AK_Tirol.html' }
			*/
			]
		},
		{
			name: 'Vorarlberg',
			links: [
				/*
				{ title: 'Startseite', url: 'https://vbg.arbeiterkammer.at' },
				{ title: 'Kontakt', url: 'https://www.arbeiterkammer.at/kontakt/akvbg.html' }
			*/
			]
		},
		{
			name: 'Wien',
			links: [
				{
					title: 'Beratung Elternkarenz (Telefon & Formular)',
					url: 'https://wien.arbeiterkammer.at/ueberuns/kontakt/elternkarenz/Elternkarenz.html'
				}
			]
		}
	];
</script>

<section class="content">
	<header class="mt-10 space-y-6">
		<h1 class="text-3xl font-semibold text-slate-900">
			Kostenfreie Beratung bei der Arbeiterkammer
		</h1>
	</header>

	<div class="prose mt-6">
		<p class="font-bold">🚧 Inhalte und Links in Arbeit 🚧</p>
		<p>
			Die Arbeiterkammer deines Bundeslandes berät dich kostenfrei zu Elternkarenz sowie
			Sozialversicherungsfragen. Sie ist als Arbeitnehmer:innen-Vertretung <b>auf deiner Seite</b>.
		</p>
		<p class="font-semibold">
			Tipp: Direkt einen Termin für die erste Beratung bei deiner AK vereinbaren. Je früher, desto
			besser. 💪
		</p>
		<p>
			Die Mitarbeiter:innen kennen alle gesetzlichen Regeln und können deine Planung überprüfen. So
			bist du auf der sicheren Seite, dass dir kein Geld verloren geht oder du etwas übersiehst. Sie
			beantworten auch Fragen dazu, wie du den KBG-Antrag (<a
				href="https://www.sozialversicherung.at/cdscontent/load?contentid=10008.638102&version=1577958680"
				>PDF</a
			>,
			<a href="https://www.gesundheitskasse.at/cdscontent/?contentid=10007.879630&portal=oegkportal"
				>ÖGK-Onlineformular</a
			>) dann im Detail korrekt ausfüllst.
		</p>
		<p>
			Hier ein Foto aus dem Wartebereich der Arbeiterkammer in Wien Ottakring. Du meldest dich bei
			dem / der freundlichen Mitarbeiter:in am Eingang an wenn du deinen Termin hast und erhältst
			deine Wartenummer:
		</p>
		<div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
			<img
				src="/ak_wien_ottakring_außengebauede.jpg"
				alt="Außenansicht der Arbeiterkammer Wien in Ottakring"
				class="w-full rounded-2xl object-cover shadow-md"
			/>
			<img
				src="/ak_wien_ottakring_wartebereich.jpg"
				alt="Wartebereich in der Arbeiterkammer Wien"
				class="w-full rounded-2xl object-cover shadow-md"
			/>
		</div>

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

		<h3>ÖGK</h3>
		<ul>
			<li>
				<a
					href="https://www.gesundheitskasse.at/cdscontent/?contentid=10007.882921&portal=oegkportal"
					>Kunden­service Wien Kinder­betreuungs­geld</a
				>
			</li>
		</ul>

		<h3>Feministische Beratung / Einführungskurs?</h3>

		<p>
			Was die AK (leider) bisher nicht leistet soweit ich weiß: Eine feministische Beratung, wie man
			die Karenzteile gleichberechtigt zwischen den Elternteilen aufteilt. Hier solltest du dich bei
			anderen Stellen, Freunden und Bekannten oder im Netz zusätzlich informieren. Denn "ganze
			Männer machen halbe halbe". Siehe auch <a href="/infothek">Infothek</a> auf dieser Webseite.
		</p>
	</div>
</section>
