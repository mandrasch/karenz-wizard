<script lang="ts">
	const faqs = [
		{
			id: 'papamonat-direkt-nach-geburt',
			question: 'Kann man den Papamonat direkt ab Geburt nehmen?',
			answer: [
				`Nein, der <a href="https://www.arbeiterkammer.at/papamonat">Papamonat</a> kann erst ab Entlassung aus dem Krankenhaus von Mutter und Kind in Anspruch genommen werden. (Und er kann bis spätestens zum Ende des Mutterschutzes genommen werden.)`,
				`Für den Tag bzw. die Tage der Geburt steht dir aber ggf. Sonderurlaub zu, je nach Kollektivvertrag. Sonst kann natürlich einfach Urlaub genommen werden, sprich am besten mit deinem Arbeitgeber. Pro-Tipp: Die tatsächliche Geburt kann vom errechneten Geburtstermin natürlich etwas spontan abweichen ;)`,
				`Der Papamonat ist quasi das (schöne und großartige!) "Recht auf unbezahlten Urlaub", um den ersten Monat mit Baby mitzubekommen und gemeinsam zu bewältigen.`,
				`Du musst den Papamonat aktiv vorankündigen und dann nach der Geburt den genauen Antrittstermin melden (siehe <a href="https://www.arbeiterkammer.at/papamonat">Musterschreiben Arbeiterkammer</a>). "Nein sagen" darf dein Arbeitgeber nicht, der Papamonat ist dein gesetzliches Recht.`
			]
		},
		{
			id: 'familienzeitbonus-und-ams',
			question: 'AMS-Bezug vorher = kein Familienzeitbonus im Papamonat?',
			answer: [
				`⚠️ Den Papamonat kannst du immer in Anspruch nehmen, egal seit wann du im Unternehmen tätig bist. Nur die optionale staatliche Förderung, den Familienzeitbonus, musst du prüfen:`,
				`Finanziell unterstützt der Staat dich mit Familienzeitbonus (FZB), weil du als Vater kein Einkommen erhältst vom Arbeitgeber im Papamonat. Aber: Wer vorher AMS-Leistungen o.ä. bezogen hat, bekommt unter Umständen keinen Familienzeitbonus. Siehe <a href="https://www.arbeiterkammer.at/papamonat">https://www.arbeiterkammer.at/papamonat</a>, vor Geburt sind für den Vater 6,5 Monate durchgehende Arbeit nötig:`,
				`<blockquote><p><strong>182 Tage Erwerbstätigkeit muss vorliegen</strong>: Der Vater muss durchgehend 182 Tage (ca. 6 Monate) vor Bezugsbeginn des Familienzeitbonus kranken- und pensionsversicherungspflichtig erwerbstätig sein. Unterbrechungen von 14 Tagen im Beobachtungszeitraum (182 Tage) schaden allerdings nicht. Er darf im genannten Beobachtungszeitraum keine Leistungen aus der Arbeitslosenversicherung (z.B. Arbeitslosengeld) bezogen haben.</p></blockquote>`,
				`Diskussion, wie man das bzgl. Krankenversicherung regelt, wenn man keinen Anspruch auf Familienzeitbonus hat: <a href="https://www.reddit.com/r/Austria/comments/1k15gyb/papamonat_kein_anspruch_auf_familienzeitbonus/">Papamonat - kein Anspruch auf Familienzeitbonus - Krankenversicherung? (Reddit)</a>. An sich sollte die 6 Wochen Schutzfrist der ÖGK greifen, wenn der Arbeitgeber dich für den Papamonat abmeldet. (Angaben ohne Gewähr - ich habe diese Option für mich selbst gewählt). Ist man verheiratet, kann man sich ggf. <a href="https://www.gesundheitskasse.at/cdscontent/?contentid=10007.870665&amp;portal=oegkportal">beim Partner:in mitversichern</a>. Im Zweifel bei AK und/oder ÖGK nachfragen.`
			]
		},
		{
			id: 'ea-und-pauschal-kbg-kombinieren',
			question:
				'Kann man Einkommensabhängiges KBG und Pauschales KBG nutzen, wenn ein Elternteil nicht 6 Monate (182 Tage) gearbeitet hat?',
			answer: [
				`Kurz: <strong>Nein</strong> – „ein Kind, ein System“. Das Mischen von <em>einkommensabhängigem</em> KBG und <em>pauschalem</em> KBG für dasselbe Kind ist nicht vorgesehen.`,
				`Wenn ein Elternteil die Voraussetzungen für das <em>ea KBG</em> (u. a. 182 Tage durchgehende vollversicherungspflichtige Erwerbstätigkeit vor Geburt) <strong>nicht</strong> erfüllt, gibt es im <em>ea-KBG-Modell</em> eine Alternative: die <a href="#sonderleistung-1">Sonderleistung&nbsp;I</a> mit fixem Tagsatz. Der andere Elternteil kann weiterhin regulär <em>ea KBG</em> beziehen.`
			]
		},
		{
			id: 'sonderleistung-1',
			question: 'Was ist Sonderleistung 1 beim ea KBG?',
			answer: [
				`<blockquote><p>Erfüllt ein Elternteil nicht das Erwerbstätigkeitserfordernis, so gebührt bei Erfüllung sämtlicher anderer Anspruchsvoraussetzungen auf Antrag ein einkommensabhängiges Kinderbetreuungsgeld in Höhe von 41,14 Euro täglich (Sonderleistung I).</p><cite><a href="https://www.bundeskanzleramt.gv.at/agenda/familie/kinderbetreuungsgeld/basisinformationen-kinderbetreuungsgeld/einkommensabhaengiges-kinderbetreuungsgeld.html">Bundeskanzleramt</a></cite></blockquote>`,
				`<blockquote><p>Was ist, wenn nur ein Elternteil die Voraussetzungen für das ea KBG erfüllt?
Sie wollen das ea KBG nutzen, aber einer der beiden Elternteile erfüllt die Anspruchsvoraussetzungen nicht? Oder liegt der Tagsatz eines Elternteiles unter 41,14€ (2025)? Dann kann dieser Elternteil auf eine Sonderleistung umsteigen, die der Dauer des KBG entspricht. Der Tagsatz dafür beträgt 41,14€ (2025). Der andere Elternteil, der die Anspruchsvoraussetzungen erfüllt, kann trotzdem das ea KBG beziehen.</p><cite><a href="https://www.arbeiterkammer.at/beratung/berufundfamilie/kinderbetreungsgeld/Kinderbetreuungsgeld.html">arbeiterkammer.at</a></cite></blockquote>`
			]
		},
		{
			id: 'unbezahlte-karenz-organisieren',
			question: 'Wie organisiert man eine unbezahlte Karenz?',
			answer: [
				`Bei einer unbezahlten Karenz stellen sich primär die Frage: Wie bin ich krankenversichert? Die aktuelle Lage ist leider unübersichtlich. Unverheiratete Paare müssen bei der ÖGK inzwischen eine "unbezahlte Haushaltsführung seit mindestens 10 Monaten" nachweisen wenn ein Partner:in während der unbezahlten Karenz mitversichert werden soll. Dieser Nachweis kann wohl ggf. problematisch sein in der Praxis, zumindest laut kurzer Info der AK-Beratung. 🤯 Die unbezahlte Karenz ist für unverheiratete Paare somit leider kein Selbstläufer, sondern bietet ein Restrisiko. 😐 Alternativen zur unbezahlten Karenz weiter unten.`,
				`<strong>Die Krankenversicherung in der unbezahlten Karenz: Sich im besten Fall beim Partner/in in der KV mitversichern lassen</strong>`,
				`<p class="has-vivid-red-color has-text-color has-link-color">⚠️ Ich selbst habe bisher keine unbezahlte Karenz in Anspruch genommen. Alle Angaben ohne Gewähr, bitte bei der Arbeiterkammer und/oder ÖGK vorher beraten lassen! Sollte die Mitversicherung abgelehnt werden, können schlimmstenfalls bis zu 526,79€ / Monat für <a href="https://www.gesundheitskasse.at/cdscontent/?contentid=10007.867315&amp;portal=oegkportal">freiwillige Selbstversicherung</a> nötig sein - falls die Herabsetzung am Ende auch nicht gewährt wird von der ÖGK, siehe unten. Das ist das Risiko. ⚠️</p>`,
				`<strong>Bei verheirateten Paaren:</strong> Hier reicht es anscheinend (!) laut ÖGK-Webseite, die normalen Anforderungen zu erfüllen. Kein Nachweis der Haushaltsführung.`,
				`<figure><img src="https://workwhileclimate.at/wp-content/uploads/2025/08/image-2-1024x675.jpg" alt="Screenshot" /><figcaption>Screenshot ÖGK-Webseite, <a href="https://www.gesundheitskasse.at/cdscontent/?contentid=10007.870665&amp;portal=oegkportal">Mitversicherung Partner*in - Vorraussetzungen</a> (Stand: 13.08.2025), Rechte: ÖGK</figcaption></figure>`,
				`<strong>Bei unverheirateten Paaren:</strong> EIne Mitversicherung beim Lebensgefährten/in ist nur möglich ist, wenn man seit mindestens 10 Monaten zusammenwohnt. Es darf außerdem kein Ehegatte oder eingetragener Partner im Haushalt leben. <strong>⚠️ UND: Der/die Partner:in, die mitversichert werden will, muss seit mindestens 10 Monaten unbezahlt den Haushalt führen. Die Haushaltsführung nachzuweisen kann in der Praxis wohl schwierig / problematisch sein</strong> (auch laut kurzer Arbeiterkammer-Auskunft). Bei der ÖGK kann man wohl mit einem Online-Formular vorab prüfen, ob man Anspruch hätte: <a href="https://www.gesundheitskasse.at/cdscontent/?contentid=10007.870665&amp;portal=oegkportal">Mitversicherung Partner*in - Prüfung der Anspruchs­be­rech­ti­gung für Angehörige</a>. Formular hat vorab bei mir nichts gebracht, siehe Reddit-Diskussion:`,
				`<ul><li><a href="https://www.reddit.com/r/Austria/comments/1mqnclb/%C3%B6gk_mitversicherung_partnerin_unverheiratet_was/">ÖGK Mitversicherung Partner*in (unverheiratet): Was bedeutet "10 Monate Haushalt der versicherten Person ohne Bezahlung führen?" und welcher Nachweis wird ggf. verlangt?</a> 🤔 (Reddit-Diskussion)</li></ul>`,
				`Sollte eine Mitversicherung nicht möglich sein, kann man sich selbst bei der ÖGK die freiwillige Selbstversicherung (526,79€ / Monat) nutzen, aber direkt die Herabsetzung der Beiträge beantragen: <a href="https://www.gesundheitskasse.at/cdscontent/?contentid=10007.867315&amp;portal=oegkportal">Selbstversicherung in der Krankenversicherung - Herabsetzung des Beitrages beantragen</a> (<em>🚧 Wie viel wäre das dann am Ende? 🚧</em>)`,
				`Kostet die Mitversicherung etwas? 🚧 In Arbeit, mehr Infos ergänzen - gilt das unten stehende für unverheiratete/verheiratete Paare? 🚧`,
				`<blockquote><p>Ich nehme zur Kenntnis, dass gemäß § 51d ASVG für bestimmte Angehörige monatlich ein Krankenversicherungsbeitrag von 3,4 % meiner Beitragsgrundlage zu entrichten ist (gegebenenfalls rückwirkend bis zu fünf Jahre).</p></blockquote>`,
				`Siehe auch Reddit Frage: <a href="https://www.reddit.com/r/FinanzenAT/comments/1mkydzk/ea_kinderbetreuungsgeld_und_danach_unbezahlte/">ea Kinderbetreuungsgeld und danach unbezahlte Karenz - Kranken- &amp; Pensionsversicherung?</a>`,
				`<strong>Bzgl. Pensions-Ansprüchen:</strong> <strong>Aufsplitten möglich</strong>`,
				`🚧 In Arbeit, mehr Infos ergänzen 🚧`,
				`<ul><li>Grundsätzlich 48 Kalendermonate ab der Geburt des Kindes Kindererziehungszeiten in der Pensionsversicherung<ul><li>für fiktive Beitragsgrundlage von 2.163,78 € (2025) werden Beiträge ins Pensionskonto desjenigen Elternteiles geleistet werden, der das Kind tatsächlich und überwiegend erzogen hat</li><li>Die Kindererziehungszeiten stehen nur einem Elternteil zu, wobei eine Aufteilung möglich ist. --&gt; 🚧 Wie? In Arbeit, mehr Infos ergänzen 🚧</li><li>Wenn bspw. Lebensgefährtin/Lebensgefährte während deiner Karenz in der Pensionsversicherung pflichtversichert ist (zB wegen Erwerbstätigkeit), dann gilt die gesetzliche Vermutung, dass du das Kind erzogen hast</li><li>Informationen zu Zuordnung der Kindererziehungszeiten: <a href="https://www.pv.at/web/pension/pension-und-kinder/anrechnung-von-kindererziehungszeiten">Kindererziehungszeiten – Wie sie Ihre Pension beeinflussen | PV</a></li></ul></li></ul>`,
				`Siehe auch Reddit Frage: <a href="https://www.reddit.com/r/FinanzenAT/comments/1mkydzk/ea_kinderbetreuungsgeld_und_danach_unbezahlte/">ea Kinderbetreuungsgeld und danach unbezahlte Karenz - Kranken- &amp; Pensionsversicherung?</a>`,
				`<strong>Was sind Alternativen zur unbezahlten Karenz?</strong>`,
				`<ol><li>Wer lieber komplett auf Nummer sicher gehen will, kann das Pauschale Kinderbetreuungsgeld-Konto nutzen. Dieses ermöglicht eine längere Karenz-Zeit als nur 14 Monate (ab Geburt) beim einkommensabhängigen Kinderbetreuungsgeld. Beim Pauschalen KBG ist also keine unbezahlte Karenz nötig, man ist krankenversichert — aber es kommt eben meist weniger finanzielle Förderung dabei heraus im Vergleich. Ein bisschen den Verlust auffangen kann man hier ggf. noch durch den einmaligen 1.000€-Partnerschaftsbonus bei 50:50 bis zu 60:40 Aufteilung.</li><li>Beide Elternteile gehen in <a href="https://www.arbeiterkammer.at/elternteilzeit">Eltern-Teilzeit</a> im Anschluss an die 14 Monate einkommensabhängigem Kinderbetreuungsgeld (gezählt ab Geburt). Beispielsweise beide arbeiten 20h die Woche, einer vormittags und einer nachmittags — dies kann sich ggf. auch steuerlich lohnen (?). <ul><li>Good to know: Bei einer Eltern-Teilzeit kann entweder die Arbeitszeit um mindestens 20% reduziert werden — oder Eltern können nur die "die Lage Ihrer Arbeitszeiten so verschieben, dass Sie Beruf und Familie leichter unter einen Hut bekommen." (<a href="https://www.arbeiterkammer.at/elternteilzeit">AK - Elternteilzeit</a>, Anspruch vorab prüfen!)</li></ul></li><li>Tagesmutter/Vater mit kleinerer Gruppen-Größe statt Kindergarten</li><li>Support von Großeltern o.ä.</li><li>Kindergarten-Eingewöhnung, Obacht: nicht in jedem Bundesland unter 2 Jahren wie in Wien möglich <ul><li>Privater Erfahrungsbericht Wien: „Wien ist mit 12 oder 14 Monaten kein Problem. Kleinkinder Gruppen haben einen Betreuungsschlüssel von 15:3 wobei bei uns selten tatsächlich mehr wie 10 Kinder gleichzeitig anwesend sind, das ist im Vergleich zu den normalen Kindergartengruppen (25:2) wesentlich besser und (außer Essen) kostenlos. Wir waren damit völlig zufrieden und machen es bei K2 wieder so. Allerdings könnte ich es mir in dem Alter nicht von 8 bis 17 Uhr vorstellen, aber 8 bis 12 Uhr in Kombination mit Teilzeit (insbesondere wenn man den Job mag) eben schon.“ (<a href="https://www.reddit.com/r/FinanzenAT/comments/1mkydzk/comment/n8iaxyk/">Reddit</a>)</li></ul></li></ol>`
			]
		},
		{
			id: 'empfohlene-fremdbetreuung',
			question: 'Ab wann wird Fremdbetreuung im Kindergarten offiziell frühestens empfohlen?',
			answer: [
				`🚧 In Arbeit, mehr Infos ergänzen 🚧`,
				`Das Thema "Ab wann Kleinkinder in die Fremdbetreuung eingewöhnen / geben" ist — so scheint es mir zumindest nach kurzer Recherche — höchst umstritten. Da das einkommensabhängige Kinderbetreuungsgeld bspw. 14 Monate nach Geburt endet, stellt sich die Frage wie das Kind im Alter von 1 Jahr und 2 Monaten nun betreut wird wenn die Eltern wieder arbeiten gehen.`,
				`<em>Die Alternativen zur Fremdbetreuung in der Kindergarten-Gruppen sind die <a href="https://www.arbeiterkammer.at/elternteilzeit">Eltern-Teilzeit</a> (bspw. beide 20h/Woche arbeiten — abwechselnd vormittags und nachmittags), Großeltern, Betreuung mit einer Tagesmutter/vater in kleineren Gruppen, o.ä. Good to know: Eltern-Teilzeit kann auch "Lage der Arbeitszeiten" ändern heißen, nicht zwangsläufig Reduzieren der Arbeitsstunden um mindestens 20%. Beides geht auch.</em>`,
				`Deutschlands bekannteste Psychologin, Stefanie Stahl äußerte hierzu drastisch:`,
				`<blockquote><p>"Für die Gehirnentwicklung eines Kindes ist es nicht gut, wenn es mit unter zwei Jahren in die Kita gegeben wird."</p></blockquote>`,
				`Der Stern befragt in einem Faktencheck u.a. Entwicklungspsycholog:innen:`,
				`<blockquote><p>Die richtige Entscheidung – da sind sich die Kleinkindpädagogin Susanne Mierau, der Kinderarzt Herbert Renz-Polster sowie die Entwicklungspsychologen Moritz Daum und Stephanie Wermelinger einig – gibt es nicht. Eines ist jedoch klar: Pauschal zu sagen, es würde Kindern schaden, in den ersten beiden Lebensjahren eine Kita zu besuchen, ist falsch.</p><cite><a href="https://www.psychologie.uzh.ch/dam/jcr:6b8c6370-f44c-4655-9a3e-b3e06f45ddf7/231124_Stefanie%20Stahls%20Aussagen%20im%20Faktencheck_%20Schadet%20die%20Kita%20einem%20Kind_%20_%20STERN.de.pdf">PDF (UZH)</a> / <a href="https://www.stern.de/gesellschaft/kita-eingewoehnung-unter-zwei-jahren--schaedlich-fuer-das-kind--34225320.html">Original-Artikel</a></cite></blockquote>`,
				`Bzgl. Kindergarten: Große Gruppen können für kleine Kinder Stress bedeuten, klare Empfehlungen finden sich kaum online. Außer: Das Risiko für Stress ist hoch, je kleiner die Kinder sind und je schlechter die Betreuung / der Betreuungsschlüssel.`,
				`<blockquote><p>Eingewöhnung bedeutet für die Kinder Stress... "In den ersten Wochen der Eingewöhnung erhöht sich das Stresshormon Cortisol"... Mit welchem Alter Kinder am besten eingewöhnt werden sollten? Dazu kann weder die Pädagogin noch die Entwicklungspsychologin eine Empfehlung abgeben... Mehr Personal ist wichtig.</p><cite><a href="https://www.derstandard.at/story/2000144233864/mama-geht-arbeiten-aber-was-macht-es-mit-den-kleinen">derStandard</a></cite></blockquote>`,
				`Es finden sich allerdings auch Stimmen, die Vorteile einer Fremdbetreuung unterstreichen — wenn die Rahmenbedingungen stimmen (<a href="https://www.derstandard.at/story/2000145323610/geht-es-fremdbetreuten-kindern-wirklich-schlechter">derStandard</a>).`,
				`In Niederösterreich ist es bspw. aber erst möglich, das Kind ab dem 2. Lebensjahr in den Kindergarten zu schicken:`,
				`<blockquote><p>Frühestens ab dem vollendeten 2,5. Lebensjahr. Ab September 2024 ist eine Aufnahme von Kinder ab Vollendung des 2. Lebensjahres möglich.</p><cite><a href="https://www.noe.gv.at/noe/Kindergaerten-Schulen/Elternfragen_zum_Thema_Kindergarten.html">noe.gv.at</a></cite></blockquote>`,
				`Die Stadt Wien hat so eine minimale Alters-Grenze nicht:`,
				`<blockquote><p>Laut Statistik Austria befindet sich jedes dritte Kind (29,1 Prozent) zwischen null und zwei Jahren in Fremdbetreuung, der Großteil davon in Wien (44,3 Prozent)...</p><cite><a href="https://www.derstandard.at/story/2000144233864/mama-geht-arbeiten-aber-was-macht-es-mit-den-kleinen">derStandard</a></cite></blockquote>`,
				`Hier liegt eine weitere Krux: Diese Entscheidung (und aufwändige Recherche) ist keine leichte für Neu-Eltern, wenn sie eigentlich nur mal kurz ihre Karenzzeit planen wollen. Denn es geht ja ganz stark um das Wohlbefinden des zukünftigen Nachwuchses.`
			]
		},
		{
			id: 'spaeterer-kindergartenstart-wien',
			question: 'Kann mein Kind später in das Kindergartenjahr einsteigen in Wien?',
			answer: [
				`🚧 In Arbeit 🚧`,
				`Ja (?), ein Einstieg / Eingewöhnung ist ggf. zum Jänner/Februar ebenso möglich (?).`,
				`Das Kindergartenjahr in Wien startet immer zum 1. September, Eingewöhnung aber auch im Jänner/Februar ggf. möglich (?). Siehe auch Frage zur Platzgarantie unten.`
			]
		},
		{
			id: 'recht-auf-elternteilzeit',
			question: 'Ab wann gilt das Recht auf Eltern-Teilzeit?',
			answer: [
				`🚧 In Arbeit, Anspruch prüfen - mit AG selber was abklären geht aber auch 🚧`,
				`Infos & Anspruchsprüfung: <a href="https://wien.arbeiterkammer.at/elternteilzeit">https://wien.arbeiterkammer.at/elternteilzeit</a>`
			]
		},
		{
			id: 'unterstuetzung-nach-karenz',
			question: 'Wie unterstützt der Sozialstaat Österreich nach der Karenz?',
			answer: [`🚧 In Arbeit 🚧`]
		},
		{
			id: 'regenbogenfamilien',
			question: 'Wie ist die Lage für Regenbogen-Familien? 🌈',
			answer: [
				`🚧 In Arbeit, mehr Infos ergänzen 🚧`,
				`Ich konnte auf die Schnelle leider keine eindeutigen Quellen zu Karenz &amp; Regenbogenfamilien finden, werde ich in Zukunft noch ergänzen.`
			]
		}
	];
</script>

<section class="content">
	<header class="mt-10 space-y-2 text-center">
		<h1 class="text-3xl font-semibold text-slate-900">FAQ</h1>
		<p class="text-base text-slate-600">
			Antworten auf häufige Fragen rund um Papamonat, Karenz und Kinderbetreuung in Österreich.
		</p>
	</header>
	<div class="prose mx-auto mt-8 max-w-4xl">
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
						class="group mt-2 flex items-center gap-2 text-2xl font-semibold text-slate-900"
					>
						<span>{faq.question}</span>
						<a
							href={`#${faq.id}`}
							class="text-slate-400 transition-colors hover:text-slate-600 focus-visible:text-slate-600 focus-visible:outline focus-visible:outline-offset-2 focus-visible:outline-slate-500"
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
						Für verbindliche Auskünfte wende dich <a href="/ak-beratung" class="text-slate-500"
							>an deine Arbeiterkammer</a
						>, Gewerkschaft oder deine zuständige Sozialversicherung – Gesetze können sich ändern.
					</p>
				</section>
			{/each}
		</div>
	</div>
</section>
