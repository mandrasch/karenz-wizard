<script lang="ts">
	import EligibiltyDateCalculator from '$lib/components/EligibiltyDateCalculator.svelte';
</script>

<section class="content">
	<header class="mt-10 text-center">
		<h1 class="text-3xl font-semibold text-slate-900">
			Anspruch auf Familienzeitbonus für Papamonat prüfen
		</h1>
	</header>
	<div class="mx-auto prose mt-6 max-w-3xl">
		<p>
			In Österreich haben Väter tollerweise das Recht darauf, den ersten Lebensmonat ihres Kindes
			daheim zu erleben und die Partnerin während des Wochenbetts, den Herausforderungen des
			Stillens (falls möglich / gewünscht) und allen weiteren, neuen und aufregenden Tätigkeiten
			intensiv unterstützen zu können. 💪
		</p>
		<p>
			Die finanzielle Förderung vom Staat, der Familienzeitbonus (FZB), ist jedoch an Bedingungen
			geknüpft.
		</p>
		<p class="my-6 text-sm">
			Wichtig: <b>Anspruch auf den Papamonat (= unbezahlte Freistellung) hast du <u>immer</u></b>!
			Das bedeutet: Du hast ein gesetzliches Recht auf unbezahlte Freistellung von der Arbeit ab dem
			Tag, an dem deine Partnerin und Baby aus dem Krankenhaus entlassen werden. Ankündigen musst es
			dem Arbeitgeber spätestens drei Monate vor dem errechneten Geburtstermin (siehe
			<a href="https://www.arbeiterkammer.at/papamonat">arbeiterkammer.at/papamonat</a>).
		</p>

		<h3>
			Die 6 Monate (182 Tage) vor der Entlassung aus dem Krankenhaus sind für den Familienzeitbonus
			entscheidend
		</h3>
		<p>
			Um während des Papamonats finanziell gefördert zu werden, musst du eine sogenannte
			"Erwerbstätigkeitserfordernis" erfüllen. Das klingt kompliziert, bedeutet aber eigentlich nur:
			Du musst im Zeitraum der 6 Monate (182 Tage) vor der Entlassung aus dem Krankenhaus
			durchgehend gearbeitet haben und du darfst keine AMS-Leistungen bezogen haben. Rechne hier den
			relevanten Zeitraum aus:
		</p>

		<EligibiltyDateCalculator />

		<h3>Was ist, wenn ich keinen Anspruch auf Familienzeitbonus habe?</h3>
		<p>
			Solltest du nicht gefördert werden können, musst du deine Krankenversicherung abklären im
			Papamonat.
		</p>
		<p>
			Hier gibt es bspw. die Option Mitversicherung bei der Partnerin - ansonsten greift aber in der
			Regel auch einfach die 6-wöchige Schutzfrist der ÖGK, sobald dich dein Arbeitgeber für den
			Papamonat von der Sozialversicherungabmeldet (was normalerweise der Fall ist). Sprich hier am
			besten vorab mit deinem Arbeitgeber und/oder lass dich bei der ÖGK oder Arbeiterkammer
			beraten.
		</p>
		<h4>Erfahrungsbericht: Jobwechsel / arbeitssuchend vor Geburt - keine Förderung</h4>
		<p>
			Bei mir persönlich ergab sich wegen eines Jobwechsels und AMS-Bezug vor der Geburt genau
			dieser Fall, dass ich keinen Anspruch auf Familienzeitbonus-Förderung hatte. Ich konnte den
			Papamonat beim neuen Arbeitgeber aber problemlos warnehmen als unbezahlte Freistellung, mein
			Arbeitgeber hat mich während dieser Zeit von der Sozialversicherung abgemeldet. Für die
			Krankenversicherung habe ich die 6-wöchige Schutzfrist der ÖGK genutzt (weil die
			Mitversicherung als unverheirates Paar wg. der <a
				href="/blog/antwort-presseanfrage-oegk-unbezahlte-karenz-mitversicherung/"
				class="underline">Haushaltsführungs-Klausel</a
			> nicht ganz verständlich war damals für mich, hätte aber vermutlich auch funktioniert). Den Papamonat
			musste ich natürlich von Ersparnissen finanzieren, Gehalt gab es ja nicht.
		</p>
		<p>
			Ob die 182-Tage-Frist wirklich noch zeitgemäß ist heutzutage - das wage ich sehr stark zu
			bezweifeln!
		</p>

		<h3>Mehr Informationen, Mustertext und Fristen zur Beantragung</h3>
		<ul>
			<li>
				<a href="https://www.arbeiterkammer.at/papamonat"
					>Papamonat & Familienzeitbonus - arbeiterkammer.at</a
				>
			</li>
			<li>
				YouTube-Video: Papamonat in Österreich | Meldung, Antrag & Geld<a
					href="https://www.youtube.com/watch?v=IMUBAZGAER8"
					aria-label="YouTube-Video: Papamonat in Österreich | Meldung, Antrag & Geld"
				>
					<img src="/ak_video_thumbnail_papamonat.jpg" alt="" class="mt-1" />
				</a>
			</li>
			<li>
				<a
					href="https://www.oesterreich.gv.at/de/themen/familie_und_partnerschaft/finanzielle-unterstuetzungen/Seite.080623"
					>Familienzeitbonus für Väter - oesterreich.gv.at</a
				>
			</li>
		</ul>
		<h3>Pro-Tipp: Urlaubstage aufheben / Sonderurlaub abklären für KH-Aufenthalt</h3>
		<p>Ich dachte zuerst, der Papamonat gilt ab Geburt.</p>
		<p>
			Stattdessen gilt das Recht auf Freistellung aber erst, sobald ihr euch gemeinsam in einem
			Haushalt befindet. Sprich mit der Entlassung der Partnerin sowie eures Babies aus dem
			Krankenhaus.
		</p>
		<p>
			Für den Tag der Geburt sowie die Tage bis zur Entlassung kannst du abklären, ob dir ggf.
			Sonderurlaub im Kollektivertrag zusteht (falls für dich ein Kollektivvertrag gilt).
		</p>
		<p>
			Ansonsten solltest du dir ein paar Urlaubstage aufheben, um deine Partnerin auch im
			Krankenhaus unterstützen zu können nach der Geburt.
		</p>
	</div>
</section>
