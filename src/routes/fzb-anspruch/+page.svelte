<script lang="ts">
	let dueDateStr = $state('2026-01-01');
	let fatherJobStart = $state('2024-01-01');
	let fatherNoBenefits = $state(false);

	const addDays = (date: Date, days: number) => {
		const next = new Date(date);
		next.setDate(next.getDate() + days);
		return next;
	};

	const daysBetween = (a: Date, b: Date) => Math.floor((a.getTime() - b.getTime()) / 86_400_000);

	const dueDate = $derived(() => (dueDateStr ? new Date(`${dueDateStr}T00:00:00`) : null));
	const fatherJobStartDate = $derived(() =>
		fatherJobStart ? new Date(`${fatherJobStart}T00:00:00`) : null
	);

	const mutterschutzStart = $derived(() => (dueDate ? addDays(dueDate, -56) : null));
	const mutterschutzStartLabel = $derived(() => {
		if (!mutterschutzStart) return 'noch offen';
		const asDate = mutterschutzStart instanceof Date ? mutterschutzStart : new Date(mutterschutzStart);
		return Number.isNaN(asDate.getTime()) ? 'noch offen' : asDate.toLocaleDateString('de-AT');
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
	const badgeLabel = (ok: boolean) => (ok ? 'Ja – vorauss. Anspruch' : 'Nein – vorauss. kein Anspruch');
</script>

<div class="mx-auto flex max-w-4xl flex-col gap-6 px-4 pb-12 text-slate-900">
	<div class="rounded-xl border border-rose-300 bg-rose-50 px-4 py-3 text-sm font-semibold leading-relaxed text-rose-700">
		+++ Alle Angaben ohne Gewähr – dieser Artikel wurde noch nicht von Expert:innen geprüft!<br />
		Bitte unbedingt bei AK kostenfrei zu Elternkarenz beraten lassen. +++
		<a
			href="https://wien.arbeiterkammer.at/ueberuns/kontakt/elternkarenz/Elternkarenz.html"
			target="_blank"
			rel="noreferrer"
			class="ml-1 font-semibold underline"
		>
			AK Wien: Elternkarenz-Beratung
		</a>
	</div>

	<h1 class="text-xl font-semibold">Papamonat: Anspruch auf Familienzeitbonus</h1>

	<div class="grid gap-3 rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 md:grid-cols-[220px_1fr] md:items-center">
		<label for="due" class="text-sm font-semibold text-slate-900">Errechneter Geburtstermin</label>
		<input
			id="due"
			type="date"
			bind:value={dueDateStr}
			class="w-full rounded-lg border border-slate-300 px-3 py-2 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-indigo-500"
		/>
	</div>

	<section class="space-y-4 rounded-2xl border border-slate-200 bg-white px-5 py-5 shadow-sm">
		<h2 class="text-lg font-semibold text-slate-900">
			Hat der Vater Anspruch auf Familienzeitbonus-Geld während Papamonat?
		</h2>
		<div class="space-y-4 text-sm text-slate-600">
			<p class="text-sm text-slate-500">
				Hier erscheint die Detailprüfung zum Familienzeitbonus (Papamonat).
			</p>
			<div>
				<h3 class="text-sm font-semibold text-slate-900">Arbeitssituation – Vater</h3>
				<div class="mt-3 grid gap-3">
					<label class="text-sm font-medium text-slate-900">Beschäftigungsbeginn</label>
					<input
						type="date"
						bind:value={fatherJobStart}
						class="w-full rounded-lg border border-slate-300 px-3 py-2 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-indigo-500"
					/>

					<label class="flex items-center gap-2 text-sm text-slate-700">
						<input type="checkbox" bind:checked={fatherNoBenefits} class="h-4 w-4 rounded border-slate-300 text-indigo-600 focus:ring-indigo-500" />
						In den letzten 182 Tagen keine Leistungen (AMS/Notstand/Weiterbildungsgeld)
					</label>
				</div>
			</div>
			<div class={badgeClass(fatherEligible)}>{badgeLabel(fatherEligible)}</div>
		</div>
	</section>

	<p class="text-sm text-slate-500">
		Hinweis: Der Mutterschutz-Beginn wird für künftige Auswertungen mit gespeichert ({mutterschutzStartLabel}).
	</p>
</div>
