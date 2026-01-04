<script lang="ts">
	let dateStr = $state('');
	let resultDate = $state<string | null>(null);

	const calculateDate = () => {
		if (!dateStr) return;
		const inputDate = new Date(dateStr);
		const calculatedDate = new Date(inputDate);
		calculatedDate.setDate(inputDate.getDate() - 182);

		resultDate = calculatedDate.toLocaleDateString('de-DE', {
			year: 'numeric',
			month: '2-digit',
			day: '2-digit'
		});
	};
</script>

<div class="rounded-xl border border-slate-200 bg-white px-6 shadow-sm">
	<h3 class="mb-4 text-lg font-semibold text-slate-900">
		FZB-Rechner für Erwerbstätigkeitserfordernis (182 Tage Frist)
	</h3>

	<div class="grid gap-4 md:grid-cols-[1fr_auto] md:items-end">
		<div class="space-y-2">
			<label for="calc-date" class="text-sm font-medium text-slate-700">
				Entlassungstermin aus dem Krankenhaus (= Bezugsbeginn des FZB)
			</label>
			<input
				id="calc-date"
				type="date"
				bind:value={dateStr}
				class="w-full rounded-lg border border-slate-300 px-3 py-2 text-sm text-slate-900 focus:ring-2 focus:ring-indigo-500 focus:outline-none"
			/>
		</div>
		<button
			onclick={calculateDate}
			disabled={!dateStr}
			class="rounded-lg bg-indigo-600 px-4 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600 disabled:cursor-not-allowed disabled:opacity-50"
		>
			Berechne Stichtag
		</button>
	</div>
	<small
		><i
			>Du kannst hier auch einfach erstmal den errechneten Geburtstermin + ca. 2-3 Tage eingeben.</i
		></small
	>

	<div class="mt-6 mb-6 rounded-lg border border-indigo-100 bg-indigo-50 px-4">
		<p class="text-indigo-900">
			Du musst ab dem <span class={resultDate ? 'font-bold' : 'text-gray-400'}
				>{resultDate ?? 'TT.MM.JJJJ'}</span
			> durchgehend sozialversicherungspflichtig gearbeitet haben, um den Anspruch auf Familienzeitbonus-Förderung
			während des Papamonats zu haben. Über diese Förderung bist du dann auch krankenversichert.
		</p>
		<p>
			Im genannten Zeitraum darfst du <b>keine Leistungen aus der Arbeitslosenversicherung</b>
			(Arbeitslosengeld, Notstandshilfe, Weiterbildungsgeld, etc.) bezogen haben.
		</p>
		<p>
			Unterbrechungen von 14 Tagen im Beobachtungszeitraum (182 Tage) schaden allerdings nicht. Auch
			Krankenstand oder Erholungsurlaub bei aufrechtem Dienstverhältnis mit Lohnfortzahlung gelten <b
				>nicht</b
			> als Unterbrechung.
		</p>

		<p>
			⚠️ Alle Informationen zu den weiteren <a
				href="https://www.oesterreich.gv.at/de/themen/familie_und_partnerschaft/finanzielle-unterstuetzungen/Seite.080623#Vorauss"
				target="_blank"
				class="underline">Anspruchsvoraussetzungen</a
			>
			(gemeinsamer Haushalt, etc.) findest du auf
			<a
				href="https://www.oesterreich.gv.at/de/themen/familie_und_partnerschaft/finanzielle-unterstuetzungen/Seite.080623#Vorauss"
				target="_blank"
				class="underline">oesterreich.gv.at</a
			> - bitte im Detail prüfen!
		</p>
	</div>
	<p class="text-xs">
		Quelle: <a
			href="https://www.oesterreich.gv.at/de/themen/familie_und_partnerschaft/finanzielle-unterstuetzungen/Seite.080623#Vorauss"
			target="_blank"
			class="underline">oesterreich.gv.at</a
		>, Stand: 04.01.2026; Unverbindliche Berechnung - alle Angaben ohne Gewähr!
	</p>
</div>
