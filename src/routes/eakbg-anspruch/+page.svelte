<script lang="ts">
	import { tick } from 'svelte';

	let toolAvailable = false;

	// Shared
	let dueDateStr = $state('');
	let motherEarlyLeaveStr = $state('');

	// Mother
	type YesNo = '' | 'yes' | 'no';
	let motherWorkedChoice: YesNo = $state('');
	let motherJobStart = $state('');
	let motherNoBenefits = $state(false);

	// Father
	let fatherWorkedChoice: YesNo = $state('');
	let fatherJobStart = $state('');
	let fatherNoBenefits = $state(false);

	// Submit state
	let hasSubmittedMother = $state(false);
	let hasSubmittedFather = $state(false);
	let hasSubmittedAll = $state(false);

	// DOM refs
	let motherResultEl: HTMLElement | null = null;
	let fatherResultEl: HTMLElement | null = null;
	let summaryEl: HTMLElement | null = null;
	let motherFirstInputEl: HTMLInputElement | null = null;
	let fatherFirstInputEl: HTMLInputElement | null = null;

	const addDays = (date: Date, days: number) => {
		const next = new Date(date);
		next.setDate(next.getDate() + days);
		return next;
	};
	const daysBetween = (a: Date, b: Date) => Math.floor((a.getTime() - b.getTime()) / 86_400_000);

	const dueDate = $derived(() => (dueDateStr ? new Date(`${dueDateStr}T00:00:00`) : null));
	const mutterschutzStart = $derived(() => {
		const due = dueDate();
		return due ? addDays(due, -56) : null;
	});
	const motherReferenceDate = $derived(() => {
		if (motherEarlyLeaveStr) return new Date(`${motherEarlyLeaveStr}T00:00:00`);
		return mutterschutzStart();
	});
	const motherJobStartDate = $derived(() =>
		motherJobStart ? new Date(`${motherJobStart}T00:00:00`) : null
	);
	const fatherJobStartDate = $derived(() =>
		fatherJobStart ? new Date(`${fatherJobStart}T00:00:00`) : null
	);

	const dateFormatter = new Intl.DateTimeFormat('de-AT', {
		day: '2-digit',
		month: '2-digit',
		year: 'numeric'
	});
	const isValidDate = (value: Date | null): value is Date =>
		value instanceof Date && !Number.isNaN(value.getTime());

	const benefitsRangeLabel = (endDate: Date | null) => {
		if (!isValidDate(endDate)) return null;
		const start = addDays(endDate, -182);
		const end = addDays(endDate, -1);
		return `${dateFormatter.format(start)} - ${dateFormatter.format(end)}`;
	};

	const motherBenefitsRange = $derived(() => benefitsRangeLabel(motherReferenceDate()));
	const fatherBenefitsRange = $derived(() => benefitsRangeLabel(dueDate()));

	// Labels for Stichtag
	const motherStichtagLabel = $derived<string>(() => {
		const ref = motherReferenceDate();
		return isValidDate(ref) ? dateFormatter.format(ref) : '—';
	});
	const fatherStichtagLabel = $derived<string>(() => {
		const due = dueDate();
		return isValidDate(due) ? dateFormatter.format(due) : '—';
	});

	// Convenience booleans for form state
	const motherWorkedAndContinues = $derived(() => motherWorkedChoice === 'yes');
	const fatherWorkedAndContinues = $derived(() => fatherWorkedChoice === 'yes');
	const motherInputsDisabled = $derived(() => !motherWorkedAndContinues());
	const fatherInputsDisabled = $derived(() => !fatherWorkedAndContinues());
	const motherHasInputs = $derived(() => Boolean(motherJobStart));
	const fatherHasInputs = $derived(() => Boolean(fatherJobStart));
	const dueDateProvided = $derived(() => Boolean(dueDateStr));

	// Eligibility (requires "yes" to worked+continuing)
	const motherEligible = $derived(() => {
		if (!motherWorkedAndContinues()) return false;
		const due = dueDate();
		const job = motherJobStartDate();
		const reference = motherReferenceDate();
		if (!due || !reference || !job) return false;
		if (!motherNoBenefits) return false;
		return daysBetween(reference, job) >= 182;
	});
	const fatherEligible = $derived(() => {
		if (!fatherWorkedAndContinues()) return false;
		const due = dueDate();
		const job = fatherJobStartDate();
		if (!due || !job) return false;
		if (!fatherNoBenefits) return false;
		return daysBetween(due, job) >= 182;
	});

	const badgeClass = (ok: boolean) =>
		ok
			? 'inline-flex items-center rounded-full border border-emerald-300 bg-emerald-50 px-3 py-1 text-xs font-semibold text-emerald-700'
			: 'inline-flex items-center rounded-full border border-rose-300 bg-rose-50 px-3 py-1 text-xs font-semibold text-rose-700';
	const badgeLabel = (ok: boolean) =>
		ok ? 'Ja – vorauss. Anspruch' : 'Nein – vorauss. kein Anspruch';

	// Shared check
	const handleCheckBoth = async () => {
		hasSubmittedMother = true;
		hasSubmittedFather = true;
		hasSubmittedAll = true;
		await tick();
		summaryEl?.scrollIntoView({ behavior: 'smooth', block: 'start' });
	};

	// Resets (per section; keep shared due/early-leave)
	const resetMother = () => {
		motherWorkedChoice = '';
		motherJobStart = '';
		motherNoBenefits = false;
		hasSubmittedMother = false;
		motherFirstInputEl?.focus();
	};
	const resetFather = () => {
		fatherWorkedChoice = '';
		fatherJobStart = '';
		fatherNoBenefits = false;
		hasSubmittedFather = false;
		fatherFirstInputEl?.focus();
	};
</script>

<section class="content">
	<header class="mt-10">
		<h1 class="text-3xl font-semibold text-slate-900">
			Anspruch auf einkommensabhängiges KBG prüfen
		</h1>
	</header>

	<p class="mt-8 font-semibold">🚧 Tool ist noch in Entwicklung 🚧</p>

	<div class="prose mt-6">
		<p>
			Mit diesem Check findet ihr heraus, ob Mutter oder Vater die 182 Kalendertage Beschäftigung
			für das einkommensabhängige Kinderbetreuungsgeld erfüllen. Gebt den errechneten Geburtstermin
			sowie eure Beschäftigungsdaten ein und startet die Prüfung mit „Check“.
		</p>
		<p class="text-sm text-slate-500">
			<span class="text-rose-600" aria-hidden="true">*</span> Pflichtfelder
		</p>
	</div>

	{#if toolAvailable}
		<!-- Geburtstermin + früherer Mutterschutz (gemeinsam) -->
		<fieldset
			class="mt-8 grid gap-3 rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 md:grid-cols-[220px_1fr] md:items-center"
		>
			<legend class="sr-only">Geburts- und Mutterschutzdaten</legend>

			<label for="due" class="text-sm font-semibold text-slate-900">
				Errechneter Geburtstermin <span class="text-rose-600" aria-hidden="true">*</span>
			</label>
			<input
				id="due"
				type="date"
				bind:value={dueDateStr}
				required
				aria-required="true"
				class="w-full rounded-lg border border-slate-300 px-3 py-2 text-sm text-slate-900 focus:ring-2 focus:ring-indigo-500 focus:outline-none"
			/>

			<label
				for="mother-early-leave"
				class="text-sm font-semibold text-slate-900 md:col-start-1 md:row-start-2"
			>
				Früherer Mutterschutz-Beginn (ärztlich)
			</label>
			<input
				id="mother-early-leave"
				type="date"
				bind:value={motherEarlyLeaveStr}
				class="w-full rounded-lg border border-slate-300 px-3 py-2 text-sm text-slate-900 focus:ring-2 focus:ring-indigo-500 focus:outline-none md:col-start-2 md:row-start-2"
			/>
		</fieldset>

		{#if !dueDateProvided() && hasSubmittedAll}
			<p class="mt-2 text-sm font-semibold text-rose-600">
				Bitte gib den errechneten Geburtstermin an.
			</p>
		{/if}

		<div class="mt-6 flex flex-col gap-4 md:flex-row">
			<!-- Mutter -->
			<section
				class="flex-1 space-y-4 rounded-2xl border border-slate-200 bg-white px-5 py-5 shadow-sm"
				aria-labelledby="mother-heading"
			>
				<div class="flex items-start justify-between gap-4">
					<div>
						<h2 id="mother-heading" class="text-lg font-semibold text-slate-900">
							Hat die Mutter Anspruch auf einkommensabhängiges KBG?
						</h2>
						<p class="mt-1 text-xs text-slate-600">
							<strong>Stichtag (Mutter):</strong> früherer Mutterschutz (falls angegeben), sonst
							<strong>ET − 56</strong>.
						</p>
					</div>
					<button
						type="button"
						onclick={resetMother}
						class="rounded-lg border border-slate-300 px-3 py-1.5 text-xs font-medium text-slate-700 hover:bg-slate-50 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-500"
						aria-label="Eingaben für Mutter zurücksetzen"
					>
						Zurücksetzen
					</button>
				</div>

				<!-- Arbeitssituation – Mutter -->
				<div class="space-y-4 text-sm text-slate-600">
					<div>
						<h3 class="text-sm font-semibold text-slate-900">Arbeitssituation – Mutter</h3>

						<!-- NEW: Ja/Nein radios; grey-out rest when "Nein" -->
						<fieldset class="mt-3">
							<legend class="text-sm font-medium text-slate-900">
								Mutter hat in den letzten 182 Tagen vor Stichtag gearbeitet
								<strong>und hat weiterhin eine Beschäftigung?</strong>
								<span class="text-rose-600" aria-hidden="true">*</span>
							</legend>
							<div
								class="mt-2 flex gap-6"
								role="radiogroup"
								aria-label="Mutter gearbeitet & weiterhin beschäftigt"
							>
								<label class="inline-flex items-center gap-2">
									<input
										type="radio"
										name="mother-worked"
										bind:group={motherWorkedChoice}
										value="yes"
										class="h-4 w-4 border-slate-300 text-indigo-600 focus:ring-indigo-500"
									/>
									<span class="text-sm text-slate-700">Ja</span>
								</label>
								<label class="inline-flex items-center gap-2">
									<input
										type="radio"
										name="mother-worked"
										bind:group={motherWorkedChoice}
										value="no"
										class="h-4 w-4 border-slate-300 text-indigo-600 focus:ring-indigo-500"
									/>
									<span class="text-sm text-slate-700">Nein</span>
								</label>
							</div>
						</fieldset>

						<div
							class={motherInputsDisabled() ? 'pointer-events-none opacity-50' : ''}
							aria-disabled={motherInputsDisabled()}
						>
							<div class="mt-4 grid gap-3">
								<label class="text-sm font-medium text-slate-900" for="mother-job-start">
									Beschäftigungsbeginn <span class="text-rose-600" aria-hidden="true">*</span>
								</label>
								<input
									type="date"
									bind:value={motherJobStart}
									id="mother-job-start"
									bind:this={motherFirstInputEl}
									required
									aria-required="true"
									disabled={motherInputsDisabled()}
									class="w-full rounded-lg border border-slate-300 px-3 py-2 text-sm text-slate-900 focus:ring-2 focus:ring-indigo-500 focus:outline-none disabled:bg-slate-100"
								/>

								<fieldset class="rounded-xl border border-slate-200 bg-slate-50 px-3 py-3">
									<legend class="text-sm font-semibold text-slate-900">
										In den letzten 182 Tagen <strong>vor Beginn des Mutterschutzes</strong> keine
										Leistungen (AMS/Notstand/Weiterbildungsgeld) bezogen?
										{#if motherBenefitsRange()}
											<span class="font-normal text-slate-600">
												(Zeitraum: {motherBenefitsRange()})</span
											>
										{/if}
									</legend>
									<p class="mt-1 text-xs text-slate-500">
										Die Mutter braucht vor dem Mutterschutz 6 Monate (182 Kalendertage).
									</p>
									<label class="mt-2 flex items-center gap-2 text-sm text-slate-700">
										<input
											type="checkbox"
											bind:checked={motherNoBenefits}
											disabled={motherInputsDisabled()}
											class="h-4 w-4 rounded border-slate-300 text-indigo-600 focus:ring-indigo-500 disabled:bg-slate-100"
										/>
										Ja, keine Leistungen in diesem Zeitraum erhalten
									</label>
								</fieldset>
							</div>
						</div>
					</div>
				</div>

				<!-- Regel & Stichtag (Mutter) — stacked -->
				<div class="rounded-xl border border-slate-200 bg-slate-50 px-4 py-3">
					<p class="text-sm text-slate-900">
						<strong>Regel (Mutter):</strong> 182 Kalendertage vor
						<strong>Beginn des Mutterschutzes</strong> ohne AMS-, Notstands- oder Weiterbildungsgeld.
					</p>
					<dl class="mt-2 grid grid-cols-1 gap-2">
						<div>
							<dt class="text-xs font-medium text-slate-500">Stichtag</dt>
							<dd
								class="mt-1 inline-flex items-center rounded-full border border-slate-300 bg-white px-2 py-0.5 text-xs font-medium text-slate-800"
							>
								{motherStichtagLabel()}
							</dd>
						</div>
						<div>
							<dt class="text-xs font-medium text-slate-500">Zeitraum (182 Tage)</dt>
							<dd
								class="mt-1 inline-flex items-center rounded-full border border-slate-300 bg-white px-2 py-0.5 text-xs font-medium text-slate-800"
							>
								{motherBenefitsRange() ?? '—'}
							</dd>
						</div>
						<div>
							<dt class="text-xs font-medium text-slate-500">Berechnung</dt>
							<dd class="mt-1 text-xs text-slate-700">
								<strong>Früherer Mutterschutz</strong> (falls angegeben), sonst
								<strong>ET − 56</strong>.
							</dd>
						</div>
					</dl>
				</div>

				{#if hasSubmittedMother}
					<div
						bind:this={motherResultEl}
						class="rounded-xl border border-slate-200 bg-slate-50 px-4 py-3"
						aria-live="polite"
					>
						{#if motherWorkedChoice !== 'yes' || !motherHasInputs() || !dueDateProvided()}
							<p class="rounded-lg bg-amber-50 px-3 py-2 text-sm font-medium text-amber-700">
								Bitte wähle „Ja“ bei „gearbeitet & weiterhin beschäftigt“ und gib den
								{!dueDateProvided() ? ' errechneten Geburtstermin' : ' Beschäftigungsbeginn'} an.
							</p>
						{:else}
							<div class={badgeClass(motherEligible())}>{badgeLabel(motherEligible())}</div>
							<div class="mt-2 space-y-2 text-sm text-slate-700">
								{#if motherEligible()}
									<p>Die Mutter erfüllt die 182 Kalendertage.</p>
								{:else}
									<p>Derzeit reichen die Angaben nicht für 182 Kalendertage.</p>
								{/if}
							</div>
						{/if}
					</div>
				{/if}
			</section>

			<!-- Vater -->
			<section
				class="flex-1 space-y-4 rounded-2xl border border-slate-200 bg-white px-5 py-5 shadow-sm"
				aria-labelledby="father-heading"
			>
				<div class="flex items-start justify-between gap-4">
					<div>
						<h2 id="father-heading" class="text-lg font-semibold text-slate-900">
							Hat der Vater Anspruch auf einkommensabhängiges KBG?
						</h2>
						<p class="mt-1 text-xs text-slate-600">
							<strong>Stichtag (Vater):</strong> <strong>ET</strong> (errechneter Geburtstermin).
						</p>
					</div>
					<button
						type="button"
						onclick={resetFather}
						class="rounded-lg border border-slate-300 px-3 py-1.5 text-xs font-medium text-slate-700 hover:bg-slate-50 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-500"
						aria-label="Eingaben für Vater zurücksetzen"
					>
						Zurücksetzen
					</button>
				</div>

				<!-- Arbeitssituation – Vater -->
				<div class="space-y-4 text-sm text-slate-600">
					<div>
						<h3 class="text-sm font-semibold text-slate-900">Arbeitssituation – Vater</h3>

						<!-- NEW: Ja/Nein radios; grey-out rest when "Nein" -->
						<fieldset class="mt-3">
							<legend class="text-sm font-medium text-slate-900">
								Vater hat in den letzten 182 Tagen vor Stichtag gearbeitet
								<strong>und hat weiterhin eine Beschäftigung?</strong>
								<span class="text-rose-600" aria-hidden="true">*</span>
							</legend>
							<div
								class="mt-2 flex gap-6"
								role="radiogroup"
								aria-label="Vater gearbeitet & weiterhin beschäftigt"
							>
								<label class="inline-flex items-center gap-2">
									<input
										type="radio"
										name="father-worked"
										bind:group={fatherWorkedChoice}
										value="yes"
										class="h-4 w-4 border-slate-300 text-indigo-600 focus:ring-indigo-500"
									/>
									<span class="text-sm text-slate-700">Ja</span>
								</label>
								<label class="inline-flex items-center gap-2">
									<input
										type="radio"
										name="father-worked"
										bind:group={fatherWorkedChoice}
										value="no"
										class="h-4 w-4 border-slate-300 text-indigo-600 focus:ring-indigo-500"
									/>
									<span class="text-sm text-slate-700">Nein</span>
								</label>
							</div>
						</fieldset>

						<div
							class={fatherInputsDisabled() ? 'pointer-events-none opacity-50' : ''}
							aria-disabled={fatherInputsDisabled()}
						>
							<div class="mt-4 grid gap-3">
								<label class="text-sm font-medium text-slate-900" for="father-job-start">
									Beschäftigungsbeginn <span class="text-rose-600" aria-hidden="true">*</span>
								</label>
								<input
									type="date"
									bind:value={fatherJobStart}
									id="father-job-start"
									bind:this={fatherFirstInputEl}
									required
									aria-required="true"
									disabled={fatherInputsDisabled()}
									class="w-full rounded-lg border border-slate-300 px-3 py-2 text-sm text-slate-900 focus:ring-2 focus:ring-indigo-500 focus:outline-none disabled:bg-slate-100"
								/>

								<fieldset class="rounded-xl border border-slate-200 bg-slate-50 px-3 py-3">
									<legend class="text-sm font-semibold text-slate-900">
										In den letzten 182 Tagen <strong>vor der Geburt</strong> keine Leistungen
										(AMS/Notstand/Weiterbildungsgeld) bezogen?
										{#if fatherBenefitsRange()}
											<span class="font-normal text-slate-600">
												(Zeitraum: {fatherBenefitsRange()})</span
											>
										{/if}
									</legend>
									<p class="mt-1 text-xs text-slate-500">
										– der Vater vor Geburt 6 Monate (182 Kalendertage).
									</p>
									<label class="mt-2 flex items-center gap-2 text-sm text-slate-700">
										<input
											type="checkbox"
											bind:checked={fatherNoBenefits}
											disabled={fatherInputsDisabled()}
											class="h-4 w-4 rounded border-slate-300 text-indigo-600 focus:ring-indigo-500 disabled:bg-slate-100"
										/>
										Ja, keine Leistungen in diesem Zeitraum erhalten
									</label>
								</fieldset>
							</div>
						</div>
					</div>
				</div>

				<!-- Regel & Stichtag (Vater) — stacked -->
				<div class="rounded-xl border border-slate-200 bg-slate-50 px-4 py-3">
					<p class="text-sm text-slate-900">
						<strong>Regel (Vater):</strong> 182 Kalendertage <strong>vor der Geburt</strong> ohne AMS-,
						Notstands- oder Weiterbildungsgeld.
					</p>
					<dl class="mt-2 grid grid-cols-1 gap-2">
						<div>
							<dt class="text-xs font-medium text-slate-500">Stichtag</dt>
							<dd
								class="mt-1 inline-flex items-center rounded-full border border-slate-300 bg-white px-2 py-0.5 text-xs font-medium text-slate-800"
							>
								{fatherStichtagLabel()}
							</dd>
						</div>
						<div>
							<dt class="text-xs font-medium text-slate-500">Zeitraum (182 Tage)</dt>
							<dd
								class="mt-1 inline-flex items-center rounded-full border border-slate-300 bg-white px-2 py-0.5 text-xs font-medium text-slate-800"
							>
								{fatherBenefitsRange() ?? '—'}
							</dd>
						</div>
						<div>
							<dt class="text-xs font-medium text-slate-500">Berechnung</dt>
							<dd class="mt-1 text-xs text-slate-700"><strong>ET</strong> ist der Stichtag.</dd>
						</div>
					</dl>
				</div>

				{#if hasSubmittedFather}
					<div
						bind:this={fatherResultEl}
						class="rounded-xl border border-slate-200 bg-slate-50 px-4 py-3"
						aria-live="polite"
					>
						{#if fatherWorkedChoice !== 'yes' || !fatherHasInputs() || !dueDateProvided()}
							<p class="rounded-lg bg-amber-50 px-3 py-2 text-sm font-medium text-amber-700">
								Bitte wähle „Ja“ bei „gearbeitet & weiterhin beschäftigt“ und gib den
								{!dueDateProvided() ? ' errechneten Geburtstermin' : ' Beschäftigungsbeginn'} an.
							</p>
						{:else}
							<div class={badgeClass(fatherEligible())}>{badgeLabel(fatherEligible())}</div>
							<div class="mt-2 space-y-2 text-sm text-slate-700">
								{#if fatherEligible()}
									<p>Der Vater erfüllt die 182 Kalendertage.</p>
								{:else}
									<p>Derzeit reichen die Angaben nicht für 182 Kalendertage.</p>
								{/if}
							</div>
						{/if}
					</div>
				{/if}
			</section>
		</div>

		<!-- Shared Check button for both -->
		<div class="mt-6 flex items-center justify-end">
			<button
				type="button"
				onclick={handleCheckBoth}
				class="inline-flex items-center justify-center rounded-lg bg-indigo-600 px-4 py-2 text-sm font-semibold text-white shadow-sm transition hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-500"
			>
				Check (beide)
			</button>
		</div>

		<!-- Shared summary below both boxes -->
		{#if hasSubmittedAll}
			<section
				bind:this={summaryEl}
				class="mt-4 space-y-3 rounded-2xl border border-slate-200 bg-white px-5 py-5 shadow-sm"
				aria-labelledby="summary-heading"
			>
				<h2 id="summary-heading" class="text-lg font-semibold text-slate-900">Zusammenfassung</h2>

				<div class="grid gap-3 md:grid-cols-2">
					<div class="rounded-xl border border-slate-200 bg-slate-50 px-4 py-3">
						<p class="text-sm font-semibold text-slate-900">Mutter</p>
						<div class="mt-2">
							<div class={badgeClass(motherEligible())}>{badgeLabel(motherEligible())}</div>
							<ul class="mt-2 list-disc pl-5 text-sm text-slate-700">
								<li>Stichtag: {motherStichtagLabel()}</li>
								<li>Zeitraum: {motherBenefitsRange() ?? '—'}</li>
								<li>
									Gearbeitet & weiterhin beschäftigt: {motherWorkedAndContinues() ? 'Ja' : 'Nein'}
								</li>
								<li>Keine Leistungen: {motherNoBenefits ? 'Ja' : 'Nein'}</li>
							</ul>
						</div>
					</div>

					<div class="rounded-xl border border-slate-200 bg-slate-50 px-4 py-3">
						<p class="text-sm font-semibold text-slate-900">Vater</p>
						<div class="mt-2">
							<div class={badgeClass(fatherEligible())}>{badgeLabel(fatherEligible())}</div>
							<ul class="mt-2 list-disc pl-5 text-sm text-slate-700">
								<li>Stichtag: {fatherStichtagLabel()}</li>
								<li>Zeitraum: {fatherBenefitsRange() ?? '—'}</li>
								<li>
									Gearbeitet & weiterhin beschäftigt: {fatherWorkedAndContinues() ? 'Ja' : 'Nein'}
								</li>
								<li>Keine Leistungen: {fatherNoBenefits ? 'Ja' : 'Nein'}</li>
							</ul>
						</div>
					</div>
				</div>
			</section>
		{/if}
	{:else}
		<p class="mt-8 font-semibold">🚧 Tool ist noch in Entwicklung 🚧</p>
	{/if}
</section>
