<script lang="ts">
	let toolAvailable = false;

	let dueDateStr = $state('2026-01-01');
	let motherJobStart = $state('2024-01-01');
	let fatherJobStart = $state('2024-01-01');
	let motherEarlyLeaveStr = $state('');
	let motherNoBenefits = $state(false);
	let fatherNoBenefits = $state(false);

	const addDays = (date: Date, days: number) => {
		const next = new Date(date);
		next.setDate(next.getDate() + days);
		return next;
	};
	const daysBetween = (a: Date, b: Date) => Math.floor((a.getTime() - b.getTime()) / 86_400_000);

	const dueDate = $derived(() => (dueDateStr ? new Date(`${dueDateStr}T00:00:00`) : null));
	const mutterschutzStart = $derived(() => (dueDate ? addDays(dueDate, -56) : null));
	const motherReferenceDate = $derived(() => {
		if (motherEarlyLeaveStr) {
			return new Date(`${motherEarlyLeaveStr}T00:00:00`);
		}
		return mutterschutzStart;
	});
	const motherJobStartDate = $derived(() =>
		motherJobStart ? new Date(`${motherJobStart}T00:00:00`) : null
	);
	const fatherJobStartDate = $derived(() =>
		fatherJobStart ? new Date(`${fatherJobStart}T00:00:00`) : null
	);

	const motherEligible = $derived(() => {
		if (!dueDate || !motherJobStartDate || !motherReferenceDate) return false;
		if (!motherNoBenefits) return false;
		return daysBetween(motherReferenceDate, motherJobStartDate) >= 182;
	});
	const fatherEligible = $derived(() => {
		if (!dueDate || !fatherJobStartDate) return false;
		if (!fatherNoBenefits) return false;
		return daysBetween(dueDate, fatherJobStartDate) >= 182;
	});

	const badgeClass = (ok: boolean) =>
		ok
			? 'inline-flex items-center rounded-full border border-emerald-300 bg-emerald-50 px-3 py-1 text-xs font-semibold text-emerald-700'
			: 'inline-flex items-center rounded-full border border-rose-300 bg-rose-50 px-3 py-1 text-xs font-semibold text-rose-700';
	const badgeLabel = (ok: boolean) =>
		ok ? 'Ja – vorauss. Anspruch' : 'Nein – vorauss. kein Anspruch';
</script>

<section class="content">
	<header class="mt-10">
		<h1 class="text-3xl font-semibold text-slate-900">
			Anspruch auf einkommensabhängiges KBG prüfen
		</h1>
	</header>

	<div class="prose mt-6">
		<p>
			<strong>Achtung bei Jobwechsel / AMS-Bezug o.ä.: </strong><em
				>Um <a
					href="https://www.gesundheitskasse.at/cdscontent/?contentid=10007.880037&amp;portal=oegkportal"
					>Anspruch auf ea KBG</a
				>
				zu haben, muss mindestens einer 6 Monate (182 Kalendertage) durchgehend gearbeitet haben –
				der Vater vor Geburt 6 Monate (182 Kalendertage) oder die Mutter vor dem Mutterschutz 6
				Monate (182 Kalendertage). Arbeitslosengeld, Notstandshilfe, Weiterbildungsgeld darf nicht
				bezogen worden sein (Quelle:
				<a href="https://www.gesundheitskasse.at/cdscontent/?contentid=10007.880037">ÖGK</a>). Hat
				nur einer von euch Anspruch, kann der andere
				<a
					href="https://www.bundeskanzleramt.gv.at/agenda/familie/kinderbetreuungsgeld/basisinformationen-kinderbetreuungsgeld/einkommensabhaengiges-kinderbetreuungsgeld.html"
					>Sonderleistung I (41,14 € täglich)</a
				> beziehen, siehe Beispiel unten. Wenn beide keinen Anspruch haben, ist nur Pauschales
				Kinderbetreuungsgeld möglich.</em
			>
		</p>
	</div>

	{#if toolAvailable}
		<div
			class="mt-8 grid gap-3 rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 md:grid-cols-[220px_1fr] md:items-center"
		>
			<label for="due" class="text-sm font-semibold text-slate-900">Errechneter Geburtstermin</label>
			<input
				id="due"
				type="date"
				bind:value={dueDateStr}
				class="w-full rounded-lg border border-slate-300 px-3 py-2 text-sm text-slate-900 focus:ring-2 focus:ring-indigo-500 focus:outline-none"
			/>
		</div>

		<div class="mt-6 flex flex-col gap-4 md:flex-row">
			<section
				class="flex-1 space-y-4 rounded-2xl border border-slate-200 bg-white px-5 py-5 shadow-sm"
			>
				<h2 class="text-lg font-semibold text-slate-900">
					Hat die Mutter Anspruch auf einkommensabhängiges KBG?
				</h2>
				<div class="space-y-4 text-sm text-slate-600">
					<p class="text-sm text-slate-500">
						Hier erscheint die Detailprüfung zum einkommensabhängigen KBG (Mutter).
					</p>
					<div>
						<h3 class="text-sm font-semibold text-slate-900">Arbeitssituation – Mutter</h3>
						<div class="mt-3 grid gap-3">
							<label class="text-sm font-medium text-slate-900">Beschäftigungsbeginn</label>
							<input
								type="date"
								bind:value={motherJobStart}
								class="w-full rounded-lg border border-slate-300 px-3 py-2 text-sm text-slate-900 focus:ring-2 focus:ring-indigo-500 focus:outline-none"
							/>

							<label class="text-sm font-medium text-slate-900"
								>Früherer Mutterschutz-Beginn (ärztlich)</label
							>
							<input
								type="date"
								bind:value={motherEarlyLeaveStr}
								class="w-full rounded-lg border border-slate-300 px-3 py-2 text-sm text-slate-900 focus:ring-2 focus:ring-indigo-500 focus:outline-none"
							/>

							<label class="flex items-center gap-2 text-sm text-slate-700">
								<input
									type="checkbox"
									bind:checked={motherNoBenefits}
									class="h-4 w-4 rounded border-slate-300 text-indigo-600 focus:ring-indigo-500"
								/>
								In den letzten 182 Tagen keine Leistungen (AMS/Notstand/Weiterbildungsgeld)
							</label>
						</div>
					</div>
					<div class={badgeClass(motherEligible)}>{badgeLabel(motherEligible)}</div>
				</div>
			</section>

			<section
				class="flex-1 space-y-4 rounded-2xl border border-slate-200 bg-white px-5 py-5 shadow-sm"
			>
				<h2 class="text-lg font-semibold text-slate-900">
					Hat der Vater Anspruch auf einkommensabhängiges KBG?
				</h2>
				<div class="space-y-4 text-sm text-slate-600">
					<p class="text-sm text-slate-500">
						Hier erscheint die Detailprüfung zum einkommensabhängigen KBG (Vater).
					</p>
					<div>
						<h3 class="text-sm font-semibold text-slate-900">Arbeitssituation – Vater</h3>
						<div class="mt-3 grid gap-3">
							<label class="text-sm font-medium text-slate-900">Beschäftigungsbeginn</label>
							<input
								type="date"
								bind:value={fatherJobStart}
								class="w-full rounded-lg border border-slate-300 px-3 py-2 text-sm text-slate-900 focus:ring-2 focus:ring-indigo-500 focus:outline-none"
							/>

							<label class="flex items-center gap-2 text-sm text-slate-700">
								<input
									type="checkbox"
									bind:checked={fatherNoBenefits}
									class="h-4 w-4 rounded border-slate-300 text-indigo-600 focus:ring-indigo-500"
								/>
								In den letzten 182 Tagen keine Leistungen (AMS/Notstand/Weiterbildungsgeld)
							</label>
						</div>
					</div>
					<div class={badgeClass(fatherEligible)}>{badgeLabel(fatherEligible)}</div>
				</div>
			</section>
		</div>
	{:else}
		<p class="mt-8 font-semibold">🚧 Tool ist noch in Entwicklung 🚧</p>
	{/if}
</section>
