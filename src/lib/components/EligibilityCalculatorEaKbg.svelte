<script lang="ts">
	let { type } = $props<{ type: 'mother' | 'father' }>();

	let calculationMode = $state<'direct' | 'et'>('et'); // 'direct' = Mutterschutzbeginn/Geburt direkt, 'et' = via ET (nur Mutter)
	let dateStr = $state('');
	let resultDate = $state<string | null>(null);
	let calculatedRefDate = $state<string | null>(null); // Für Mutter via ET: Der berechnete Mutterschutzbeginn

	const calculateDate = () => {
		if (!dateStr) return;
		let refDate = new Date(dateStr);

		// Special logic for mother via ET
		if (type === 'mother' && calculationMode === 'et') {
			// Mutterschutz usually starts 56 days before ET
			refDate.setDate(refDate.getDate() - 56);
			calculatedRefDate = refDate.toLocaleDateString('de-DE', {
				year: 'numeric',
				month: '2-digit',
				day: '2-digit'
			});
		} else {
			calculatedRefDate = null;
		}

		// 182 days before report date
		const startOfPeriod = new Date(refDate);
		startOfPeriod.setDate(refDate.getDate() - 182);

		resultDate = startOfPeriod.toLocaleDateString('de-DE', {
			year: 'numeric',
			month: '2-digit',
			day: '2-digit'
		});
	};
</script>

<div class="rounded-xl border border-slate-200 bg-white px-6 shadow-sm">
	<p class="w-full text-center text-sm">⚠️ Tool noch in Arbeit, nicht durchgeprüft! ⚠️</p>
	<!-- <h3 class="mb-4 text-lg font-semibold text-slate-900">182 Tage Zeitraum berechnen</h3> -->

	<div class="space-y-4">
		{#if type === 'mother'}
			<div class="flex flex-col gap-2 text-sm text-slate-700">
				<label class="inline-flex items-center gap-2">
					<input
						type="radio"
						name="mode-{type}"
						value="et"
						bind:group={calculationMode}
						class="h-4 w-4 border-slate-300 text-indigo-600 focus:ring-indigo-500"
					/>
					Ich möchte vom errechneten Geburtstermin (ET) ausgehen
				</label>
				<label class="inline-flex items-center gap-2">
					<input
						type="radio"
						name="mode-{type}"
						value="direct"
						bind:group={calculationMode}
						class="h-4 w-4 border-slate-300 text-indigo-600 focus:ring-indigo-500"
					/>
					Ich kenne meinen Mutterschutzbeginn bereits
				</label>
			</div>
		{/if}

		<div class="grid gap-4 md:grid-cols-[1fr_auto] md:items-end">
			<div class="space-y-2">
				<label for="calc-date-{type}" class="text-sm font-medium text-slate-700">
					{#if type === 'mother'}
						{#if calculationMode === 'et'}
							Errechneter Geburtstermin (ET)
						{:else}
							Beginn des Mutterschutzes
						{/if}
					{:else}
						(Errechneter) Geburtstermin
					{/if}
				</label>
				<input
					id="calc-date-{type}"
					type="date"
					bind:value={dateStr}
					class="w-full rounded-lg border border-slate-300 px-3 py-2 text-sm text-slate-900 focus:ring-2 focus:ring-indigo-500 focus:outline-none"
				/>
			</div>
		</div>
		<button
			onclick={calculateDate}
			disabled={!dateStr}
			class="rounded-lg bg-indigo-600 px-4 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600 disabled:cursor-not-allowed disabled:opacity-50"
		>
			Berechne Stichtag
		</button>
	</div>

	<div class="mt-6 mb-6 rounded-lg border border-indigo-100 bg-indigo-50 px-4 text-sm">
		{#if type === 'mother' && calculatedRefDate}
			<p class="mb-2 text-sm text-indigo-800">
				Dein Mutterschutz beginnt voraussichtlich am <b>{calculatedRefDate}</b> (ET minus 56 Tage).
			</p>
		{/if}

		<p class="font-bold text-indigo-900">
			Du musst ab dem <span class={resultDate ? 'font-bold' : 'text-gray-400'}
				>{resultDate ?? 'TT.MM.JJJJ'}</span
			>
			sozialversicherungspflichtig gearbeitet haben, um Anspruch auf eaKBG zu haben.
		</p>
		<!-- <p class="text-xs">
			Unterbrechungen von 14 Tagen im Beobachtungszeitraum (182 Tage) schaden allerdings nicht. Auch
			Krankenstand oder Erholungsurlaub bei aufrechtem Dienstverhältnis mit Lohnfortzahlung gelten <b
				>nicht</b
			> als Unterbrechung.
		</p>
		<p class="text-xs">
			Im genannten Zeitraum darfst du allerdings <b>keine</b> Leistungen aus der Arbeitslosenversicherung
			(Arbeitslosengeld, Notstandshilfe, Weiterbildungsgeld, etc.) bezogen haben.
		</p>-->

		<p class="text-xs">
			⚠️ Alle Informationen zu den weiteren <a
				href="https://www.oesterreich.gv.at/de/themen/familie_und_partnerschaft/finanzielle-unterstuetzungen/3/2/1/Seite.080614"
				target="_blank"
				class="underline">Anspruchsvoraussetzungen</a
			>
			(gemeinsamer Haushalt, etc.) findest du auf
			<a
				href="https://www.oesterreich.gv.at/de/themen/familie_und_partnerschaft/finanzielle-unterstuetzungen/3/2/1/Seite.080614"
				target="_blank"
				class="underline">oesterreich.gv.at</a
			> - bitte im Detail prüfen!
		</p>
	</div>
	<p class="text-xs">Unverbindliche Berechnung - Angaben ohne Gewähr.</p>
</div>
