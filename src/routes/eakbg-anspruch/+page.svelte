<script lang="ts">
	import EligibilityCalculatorEaKbg from '$lib/components/EligibilityCalculatorEaKbg.svelte';
	import Header from '$lib/components/Header.svelte';
</script>

<div class="mx-auto prose mt-6 max-w-3xl">
	<section class="content">
		<!-- Kompakter Header -->
		<header class="mt-2">
			<h1 class="text-2xl leading-tight font-semibold text-slate-900">eaKBG – Anspruch prüfen</h1>
		</header>

		<p>
			Um das einkommensabhängige Kinderbetreuungsgeld (eaKBG) beziehen zu können, müssen einige
			Anspruchsvoraussetzungen (Bedingungen) erfüllt werden. <!-- Erfüllt man diese, erhält man während seiner Karenz-Monate
			ungefähr 80% des letzten Einkommens. -->
		</p>

		<!-- TODO: Mehrere Sätze draus machen, Mutter / Vater in Tabelle darstellen mit 2 Spalte -->
		<h3>1. Beide Elternteile müssen die allgemeinen Bedingungen erfüllen</h3>
		<p>
			<b>Beide Elternteile</b> müssen die <b>allgemeinen</b> Anspruchsvoraussetzungen erfüllen:
		</p>
		<p>
			Hierzu zählt u.a. gemeinsamer dauerhafter Haushalt mit dem Kind, Mittelpunkt der
			Lebensinteressen in Österreich, Durchführung und Nachweis der Eltern-Kind-Pass-Untersuchungen,
			Einhalten von Zuverdienst-Grenzen. Siehe <a
				href="https://www.oesterreich.gv.at/de/themen/familie_und_partnerschaft/finanzielle-unterstuetzungen/3/2/1/Seite.080614"
				target="_blank"
				class="underline">Anspruchsvoraussetzungen auf oesterreich.gv.at</a
			>.
		</p>
		<h3>2. Mindestens ein Elternteil muss die 182-Tage Erwerbstätigkeit erfüllen</h3>

		<p>
			Eine besondere Anspruchsvoraussetzung ist die <b
				>Erwerbstätigkeit in den 182 Kalendertagen unmittelbar vor der Geburt bzw. vor
				Mutterschutz-Beginn</b
			>, die sogenannte <b>„Erwerbstätigkeitserfordernis“.</b> Wichtig: AMS-, Notstands- oder Weiterbildungsgeld-Leistungen
			dürfen ebenfalls nicht bezogen worden sein in diesem Zeitraum!
		</p>

		<p>
			Diese Anspruchsvoraussetzung muss allerdings <b>nur von einem Elternteil</b> erfüllt werden:
		</p>

		<blockquote>
			Erfüllt ein Elternteil nicht das Erwerbstätigkeitserfordernis, so gebührt bei Erfüllung
			sämtlicher anderer Anspruchsvoraussetzungen auf Antrag ein einkommensabhängiges
			Kinderbetreuungsgeld in Höhe von 41,14 Euro täglich (Sonderleistung I). - <cite
				><a
					href="https://www.bundeskanzleramt.gv.at/agenda/familie/kinderbetreuungsgeld/basisinformationen-kinderbetreuungsgeld/einkommensabhaengiges-kinderbetreuungsgeld.html"
					>bundeskanzleramt.gv.at</a
				></cite
			>
		</blockquote>
		<!-- <p>
			Einer der größten Fallstricke ist hierbei <b>182-Tage-Regel</b>. Diese besagt, dass man ab ca.
			6 Monaten (= 182 Tage) vor Mutterschutz-Beginn (Mutter) bzw. vor Geburt (Vater) durchgehend
			gearbeitet haben muss:
		</p>-->

		<h4>Wie berechne ich den 182-Tage-Zeitraum?</h4>
		<div class="mt-4 overflow-hidden rounded-lg border border-slate-200">
			<div class="grid grid-cols-2 bg-slate-50 text-sm font-semibold text-slate-800">
				<div class="border-r border-slate-200 px-4 py-2">Mutter</div>
				<div class="px-4 py-2">Vater</div>
			</div>

			<div class="grid grid-cols-2 text-sm text-slate-700">
				<div class="border-t border-r border-slate-200 px-4 py-3">
					Stichtag für den 182-Tage-Zeitraum ist der <strong>Beginn des Mutterschutzes</strong>. Der
					Mutterschutz beginnt in der Regel 8 Wochen (56 Tage) vor dem errechneten Geburtstermin.
					<br /><br /><span class="text-xs"
						>Ein Arzt/Ärztin kann jedoch auch schon einen vorzeitigen / früheren Mutterschutz ggf.
						anordnen bei besonderen Risiken.</span
					>
				</div>
				<div class="border-t border-slate-200 px-4 py-3">
					Stichtag für den 182-Tage-Zeitraum ist die <strong>Geburt des Kindes</strong>. Man also
					erstmal grob mit dem errechneten Geburtstermin den relevanten Zeitraum berechnen.<br /><br
					/><span class="text-xs">
						Bei einer früheren Geburt zählt aber natürlich das tatsächliche Geburtsdatum für den
						eaKBG-Antrag.</span
					>
				</div>
			</div>
		</div>

		<div class="grid gap-8 md:grid-cols-2">
			<article>
				<h4 class="mt-4 mb-4">Zeitraum für Mutter berechnen</h4>
				<EligibilityCalculatorEaKbg type="mother" />
			</article>

			<article>
				<h4 class="mt-4 mb-4">Zeitraum für Vater berechnen</h4>
				<EligibilityCalculatorEaKbg type="father" />
			</article>
		</div>

		<p>
			Unterbrechungen von 14 Tagen im Beobachtungszeitraum (182 Tage) schaden allerdings nicht. Auch
			Krankenstand oder Erholungsurlaub bei aufrechtem Dienstverhältnis mit Lohnfortzahlung gelten
			nicht als Unterbrechung. Siehe <a
				href="https://www.oesterreich.gv.at/de/themen/familie_und_partnerschaft/finanzielle-unterstuetzungen/3/2/1/Seite.080614"
				target="_blank"
				class="underline">Anspruchsvoraussetzungen auf oesterreich.gv.at</a
			>.
		</p>
		<p>
			Wichtig: AMS-, Notstands- oder Weiterbildungsgeld-Leistungen dürfen <b>nicht</b> bezogen
			worden sein in diesem Zeitraum! <!-- Unterbrechungen von 14 Tagen im Beobachtungszeitraum (182
			Tage) schaden allerdings nicht. Auch Krankenstand oder Erholungsurlaub bei aufrechtem
			Dienstverhältnis mit Lohnfortzahlung gelten <b>nicht</b> als Unterbrechung. -->
		</p>

		<h3>Was passiert, wenn nur einer - oder keiner Anspruch hat?</h3>

		<div class="mt-6 overflow-hidden rounded-lg border border-slate-200">
			<div class="grid grid-cols-3 bg-slate-50 text-sm font-semibold text-slate-800">
				<div class="border-r border-slate-200 px-4 py-2 text-center">Beide haben Anspruch</div>
				<div class="border-r border-slate-200 px-4 py-2 text-center">Nur einer hat Anspruch</div>
				<div class="border-r border-slate-200 px-4 py-2 text-center">Wenn keiner Anspruch hat</div>
			</div>

			<div class="grid grid-cols-3 text-sm text-slate-700">
				<div class="border-t border-r border-slate-200 px-4 py-3">
					Super, beide können eaKBG-Förderung für ihre Karenzmonate beantragen und beziehen.<br
					/><br />
					<span class="text-xs"
						>Die Höhe richtet sich nach dem Einkommen (~ 80% des Einkommens), die maximale Höhe ist
						allerdings begrenzt. 2025 war der Tages-Höchssatz bei 80,12 €, das sind rund 2.400 €
						monatlich maximal. Siehe <a
							href="https://www.gesundheitskasse.at/cdscontent/?contentid=10007.880037"
							class="underline">gesundheitskasse.at</a
						> für mehr Infos.</span
					>
				</div>

				<div class="border-t border-r border-slate-200 px-4 py-3">
					Der anspruchsberechtigte Elternteil erhält das eaKBG für seine Karenzmonate.<br /><br />
					Der andere Elternteil bekommt für seine Karenzmonate
					<a
						class="underline"
						href="https://www.bundeskanzleramt.gv.at/agenda/familie/kinderbetreuungsgeld/basisinformationen-kinderbetreuungsgeld/einkommensabhaengiges-kinderbetreuungsgeld.html"
						><strong>Sonderleistung I</strong></a
					>
					ausgezahlt - ein fixer Tagessatz, unabhängig vom Einkommen. 2025 lag dieser bei 41,14 € / Tag,
					was rund 1.200 € pro Monat bedeutet.
					<!-- Link zu Sonderleistung 1 ergänzen -->
				</div>

				<div class="border-t border-r border-slate-200 px-4 py-3">
					Ein Bezug des eaKBG ist <b>nicht möglich</b>. ❌ <br /><br />In diesem Fall kann man aber
					das
					<a
						href="https://www.arbeiterkammer.at/kbg#heading_Kinderbetreuungsgeldkonto"
						class="underline">KBG-Konto (pauschales Kinderbetreuungsgeld)</a
					> als Fördermodell nutzen.
				</div>
			</div>
		</div>

		<section class="mt-10">
			<h3>Wichtig: Fristen für Antrag im Blick haben</h3>
			<p>
				Das Kinderbetreuungsgeld muss beantragt werden, es kommt nicht automatisch auf euer Konto.
				Registriert euch am besten beim <a
					href="https://elternkalender.arbeiterkammer.at/"
					class="underline">interaktiven Elternkalender der Arbeiterkammer</a
				>, mit welchem ihr alle kommenden Fristen im Blick habt.
			</p>
			<h3>Mehr Informationen und Beratung</h3>
			<ul>
				<li>
					Infoseite: <a
						class="underline"
						href="https://www.oesterreich.gv.at/de/themen/familie_und_partnerschaft/finanzielle-unterstuetzungen/3/2/1"
					>
						Einkommensabgängiges Kinderbetreuungsgeld - oesterreich.gv.at</a
					>
				</li>
				<li>
					Infoseite: <a
						href="https://www.gesundheitskasse.at/cdscontent/?contentid=10007.879754&portal=oegkportal"
						class="underline">Einkommensabhängiges Kinderbetreuungsgeld - ÖGK</a
					>
				</li>
				<li>
					Infoseite: <a
						href="https://www.arbeiterkammer.at/beratung/berufundfamilie/kinderbetreungsgeld/Kinderbetreuungsgeld.html#heading_Einkommensabhaengiges_Kinderbetreuungsgeld"
						class="underline"
					>
						Einkommensabhängiges Kinderbetreuungsgeld - arbeiterkammer.at
					</a>
				</li>
			</ul>
			<p>
				Deine Arbeiterkammer vor Ort bietet Beratung und teils auch Webinare / vor Ort
				Infoveranstaltungen an:
			</p>
			<ul>
				<li><a href="/ak-beratung">Beratung bei der Arbeiterkammer</a></li>
			</ul>
			<p>Sie können bei Unklarheiten auch helfen herauszufinden, ob du wirklich Anspruch hast.</p>
		</section>

		<h3>Nächster Schritt: Karenz-Aufteilung planen</h3>
		<p>
			Jetzt geht es ans Eingemachte. Plant die ersten Jahre mit eurem Baby, falls ihr Anspruch auf
			einkommensabhängiges Kinderbetreuungsgeld (eaKBG) habt:
		</p>
		<p class="text-center">&raquo;<a href="/eakbg-planer" class="underline">Zum eaKBG-Planer</a></p>

		<p>Falls ihr keinen Anspruch habt, könnt ihr euch nun zum KBG Konto informieren:</p>
		<p>
			<i
				>„Das pauschale Kinderbetreuungsgeld (KBG) steht Ihnen offen, egal ob Sie vor der Geburt
				Ihres Kindes gearbeitet haben oder nicht.“</i
			>
		</p>
		<ul>
			<li>
				Infoseite:
				<a href="https://www.arbeiterkammer.at/kbg#heading_Kinderbetreuungsgeldkonto"
					>Kinderbetreuungsgeld Konto - arbeiterkammer.at</a
				>
			</li>
			<li>
				Infoseite:
				<a
					href="https://www.arbeiterkammer.at/beratung/berufundfamilie/Karenz/Teilung_der_Karenz.html"
					>Teilung der Karenz - arbeiterkammer.at</a
				>
			</li>
		</ul>
		<!-- TODO: support this in planner as well? -->
	</section>
</div>
