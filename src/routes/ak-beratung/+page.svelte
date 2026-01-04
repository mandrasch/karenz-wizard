<script>
	const akList = [
		{
			name: 'Burgenland',
			links: [
				{ title: 'Startseite', url: 'https://bgld.arbeiterkammer.at' },
				{
					title: 'Beruf & Familie',
					url: 'https://bgld.arbeiterkammer.at/beratung/berufundfamilie/index.html'
				},
				{
					title: 'Elternberatungs-Termine vor Ort',
					url: 'https://bgld.arbeiterkammer.at/elternberatung'
				},
				{ title: 'Kontakt', url: 'https://bgld.arbeiterkammer.at/ueberuns/kontakt/index.html' }
			]
		},
		{
			name: 'Kärnten',
			links: [
				{ title: 'Startseite', url: 'https://kaernten.arbeiterkammer.at' },
				{
					title: 'Beruf & Familie',
					url: 'https://kaernten.arbeiterkammer.at/beratung/berufundfamilie/index.html'
				},
				{
					title: 'AK Kärnten lädt zum Elternfrühstück',
					url: 'https://kaernten.arbeiterkammer.at/beratung/berufundfamilie/kinderbetreuungsgeld/AK_laedt_zum_Elternfruehstueck.html'
				},
				{
					title: 'Kontakt: Mutterschutz und Elternkarenz',
					url: 'https://kaernten.arbeiterkammer.at/ueberuns/kontakt/karenz/Mutterschutz___Karenz.html'
				}
			]
		},
		{
			name: 'Niederösterreich',
			links: [
				{ title: 'Startseite', url: 'https://noe.arbeiterkammer.at' },
				{
					title: 'Beruf & Familie',
					url: 'https://noe.arbeiterkammer.at/beratung/berufundfamilie/index.html'
				},
				{
					title: 'Quiz - Karenz',
					url: 'https://noe.arbeiterkammer.at/beratung/berufundfamilie/karenz/Quiz-_Karenz.html'
				},
				{
					title: 'Quiz - Papamonat',
					url: 'https://noe.arbeiterkammer.at/beratung/berufundfamilie/karenz/Quiz-_Papamonat.html'
				},
				{
					title: 'Quiz - Kinderbetreuungsgeld',
					url: 'https://noe.arbeiterkammer.at/beratung/berufundfamilie/kinderbetreuungsgeld/index.html'
				},
				{ title: 'Kontakt', url: 'https://www.arbeiterkammer.at/kontakt/aknoe.html' }
			]
		},
		{
			name: 'Oberösterreich',
			links: [
				{ title: 'Startseite', url: 'https://ooe.arbeiterkammer.at' },
				{
					title: 'Beruf & Familie',
					url: 'https://ooe.arbeiterkammer.at/beratung/berufundfamilie/index.html'
				},
				{
					title: 'Webinar - Ein Baby kommt - was Eltern wissen sollten',
					url: 'https://ooe.arbeiterkammer.at/service/veranstaltungen/allgemeinetermine/online/Ein_Baby_kommt_-_was_Eltern_wissen_sollten.html'
				},

				{
					title: 'Webinar - Nach der Karenz - was Eltern wissen sollten',
					url: 'https://ooe.arbeiterkammer.at/service/veranstaltungen/allgemeinetermine/online/Nach-der-Karenz---was-Eltern-wissen-sollten.html'
				},
				{
					title: 'Kontakt / persönliche Beratung: Ein Baby kommt: Infos zu Job, Versicherung, Geld',
					url: 'https://ooe.arbeiterkammer.at/ueberuns/kontakte/beratung/Elternschaft.html'
				}
			]
		},
		{
			name: 'Salzburg',
			links: [
				{ title: 'Startseite', url: 'https://sbg.arbeiterkammer.at' },
				{
					title: 'Beruf & Familie',
					url: 'https://sbg.arbeiterkammer.at/beratung/berufundfamilie/index.html'
				},
				{
					title: 'Kontakt - Arbeitsrecht',
					url: 'https://sbg.arbeiterkammer.at/ueberuns/kontakt/arbeitsrecht/Arbeitsrecht.html'
				}
			]
		},
		{
			name: 'Steiermark',
			links: [
				{ title: 'Startseite', url: 'https://stmk.arbeiterkammer.at' },
				{
					title: 'Beruf & Familie',
					url: 'https://stmk.arbeiterkammer.at/beratung/berufundfamilie/Beruf_und_Familie_Uebersichtsseite.html'
				},
				{
					title: 'Infofrühstück für WiedereinsteigerInnen',
					url: 'https://stmk.arbeiterkammer.at/beratung/berufundfamilie/wiedereinstieg/Infofruehstueck.html'
				},
				{
					title: 'Kontakt - Frau, Beruf & Familie',
					url: 'https://stmk.arbeiterkammer.at/ueberuns/kontakt/Kontakt_Frauen_und_Gleichstellung.html'
				}
			]
		},
		{
			name: 'Tirol',
			links: [
				{ title: 'Startseite', url: 'https://tirol.arbeiterkammer.at' },
				{
					title: 'Beruf & Familie',
					url: 'https://tirol.arbeiterkammer.at/beratung/berufundfamilie/index.html'
				},
				{
					title: 'Webinar: Ein Baby kommt - Das müssen Sie rund um die Geburt Ihres Kindes wissen!',
					url: 'https://tirol.arbeiterkammer.at/beratung/berufundfamilie/Webinar-Ein-Baby-kommt.html'
				},
				{
					title: 'Kontakt - Arbeitsrecht',
					url: 'https://tirol.arbeiterkammer.at/ueberuns/kontakt/Arbeitsrecht/Arbeitsrecht.html'
				}
			]
		},
		{
			name: 'Vorarlberg',
			links: [
				{ title: 'Startseite', url: 'https://vbg.arbeiterkammer.at' },
				{
					title: 'Familie & Beruf',
					url: 'https://vbg.arbeiterkammer.at/beratung/berufundfamilie/index.html'
				},
				{
					title: 'Karenz-Service: Termin vereinbaren',
					url: 'https://vbg.arbeiterkammer.at/beratung/berufundfamilie/Beratungstermin.html'
				}
			]
		},
		{
			name: 'Wien',
			links: [
				{
					title: 'Startseite',
					url: 'https://wien.arbeiterkammer.at'
				},
				{
					title: 'Beruf & Familie',
					url: 'https://wien.arbeiterkammer.at/beratung/berufundfamilie/index.html'
				},
				{
					title: 'Veranstaltungen: Kind und Job',
					url: 'https://wien.arbeiterkammer.at/beratung/berufundfamilie/kinderbetreuungsgeld/Veranstaltungen_zu_Kindergeld_und_Elternteilzeit.html'
				},
				{
					title: 'Kontakt: Beratungstermin Elternkarenz',
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
			Einige Arbeiterkammern bieten auch Inforveranstaltungen vor Ort oder Webinare an. Hier eine
			schnelle Liste - bitte prüfe die Webseite der Arbeiterkammer deines Bundeslandes, die
			Informationen hier können ggf. veraltet sein / neue Angebote dazugekommen sein.
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
			Männer machen Halbe-Halbe". Siehe auch <a href="/infothek">Infothek</a> auf dieser Webseite.
		</p>

		<h3>Wie schaut es bei der Arbeiterkammer vor Ort aus?</h3>
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
	</div>
</section>
