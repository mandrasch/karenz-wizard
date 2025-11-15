<script lang="ts">
	let toolAvailable = false;

	let dueDateStr = $state();
	let fatherJobStart = $state();
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
	<header class="mt-10 text-center">
		<h1 class="text-3xl font-semibold text-slate-900">Anspruch auf Familienzeitbonus prüfen</h1>
	</header>
	<div class="prose mx-auto mt-6 max-w-3xl">
		{#if toolAvailable}
			<div
				class="mt-8 grid gap-3 rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 md:grid-cols-[220px_1fr] md:items-center"
			>
				<label for="due" class="text-sm font-semibold text-slate-900"
					>Errechneter Geburtstermin</label
				>
				<input
					id="due"
					type="date"
					bind:value={dueDateStr}
					class="w-full rounded-lg border border-slate-300 px-3 py-2 text-sm text-slate-900 focus:ring-2 focus:ring-indigo-500 focus:outline-none"
				/>
			</div>

			<section
				class="mt-6 space-y-4 rounded-2xl border border-slate-200 bg-white px-5 py-5 shadow-sm"
			>
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
		{:else}
			<p class="mt-8 font-semibold">
				🚧 Tool ist noch in Entwicklung, du kannst aber beim ea KBG Anspruch vorbeischauen. Die
				Vorraussetzungen beim Familienzeitbonus sind diesselben wie beim ea KBG für den Vater. 🚧
			</p>
		{/if}
		<p class="my-6">
			Wichtig: <u><b>Anspruch auf Papamonat hast du immer</b></u>! Das bedeutet: Du hast Recht auf
			Freistellung von der Arbeit ab Entlassung aus dem Krankenhaus nach der Geburt.
			<br /><br />
			Bei diesem Check geht es nur um den Anspruch auf finanzielle Förderung in dem Monat. Solltest du
			nicht gefördert werden, musst du deine Krankenversicherung abklären. Hier gibt es aber die Option
			Mitversicherung bei der Partnerin - ansonsten gilt aber in der Regel auch die 6-wöchige Schutzfrist
			der ÖGK sobald dich dein Arbeitgeber für den Papamonat abmeldet.
		</p>
		<p>
			Achtung bei Jobwechsel & Co: 182-Tagesfrist beachten, in dieser darf kein Arbeitslosengeld
			o.ä. bezogen worden sein bevor man den Papamonat in Anspruch nimmt!
		</p>
		<blockquote>
			182 Tage Erwerbstätigkeit muss vorliegen: Der Vater muss durchgehend 182 Tage (ca. 6 Monate)
			vor Bezugsbeginn des Familienzeitbonus kranken- und pensionsversicherungspflichtig
			erwerbstätig sein. Unterbrechungen von 14 Tagen im Beobachtungszeitraum (182 Tage) schaden
			allerdings nicht. Er darf im genannten Beobachtungszeitraum keine Leistungen aus der
			Arbeitslosenversicherung (z.B. Arbeitslosengeld) bezogen haben.
			<cite>https://www.arbeiterkammer.at/papamonat</cite>
		</blockquote>
		<ul>
			<li>
				<a
					href="https://www.oesterreich.gv.at/de/themen/familie_und_partnerschaft/finanzielle-unterstuetzungen/Seite.080623"
					>Familienzeitbonus für Väter - oesterreich.gv.at</a
				>
			</li>
			<li>
				<a href="https://www.arbeiterkammer.at/papamonat"
					>Papamonat & Familienzeitbonus - arbeiterkammer.at</a
				>
			</li>
		</ul>
		<p>
			Für den Tag der Geburt bis Entlassung ist Sonderurlaub nehmen nötig, je nach Kollektivvertrag
			hat man ggf. auch garantierten Anspruch darauf. Der Papamonat kann erst genommen werden,
			sobald ihr euch gemeinsam in einem Haushalt befindet.
		</p>
		<!-- TODO: move to comp? -->
		<p>
			Für verbindliche Auskünfte wende dich an <a href="/ak-beratung">deine Arbeiterkammer</a>,
			Gewerkschaft oder zuständige Sozialversicherung – Gesetze können sich ändern.
		</p>
	</div>
</section>
