<script lang="ts">
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

<div class="mx-auto flex max-w-4xl flex-col gap-6 px-4 pb-12 text-slate-900">
	<div
		class="rounded-xl border border-rose-300 bg-rose-50 px-4 py-3 text-sm leading-relaxed font-semibold text-rose-700"
	>
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

	<h3 class="text-lg font-semibold">Karenz Wizard 🪄</h3>

	<div
		class="grid gap-3 rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 md:grid-cols-[220px_1fr] md:items-center"
	>
		<label for="due" class="text-sm font-semibold text-slate-900">Errechneter Geburtstermin</label>
		<input
			id="due"
			type="date"
			bind:value={dueDateStr}
			class="w-full rounded-lg border border-slate-300 px-3 py-2 text-sm text-slate-900 focus:ring-2 focus:ring-indigo-500 focus:outline-none"
		/>
	</div>

	<section
		class="space-y-4 rounded-2xl border border-dashed border-slate-200 bg-white px-5 py-5 shadow-sm"
	>
		<h2 class="text-lg font-semibold text-slate-900">Papamonat Anspruchsprüfung</h2>
		<p class="text-sm text-slate-600">
			Der Papamonat-Rechner ist auf eine eigene Seite umgezogen. Dort kannst du weiterhin prüfen, ob
			Anspruch auf Familienzeitbonus-Geld besteht.
		</p>
		<a
			href="/fzb-anspruch"
			class="inline-flex items-center justify-center rounded-lg bg-indigo-600 px-4 py-2 text-sm font-semibold text-white transition hover:bg-indigo-700 focus:outline-none focus-visible:ring-2 focus-visible:ring-indigo-500"
		>
			Zum Papamonat-Tool
		</a>
	</section>

	<div class="flex flex-col gap-4 md:flex-row">
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
</div>
