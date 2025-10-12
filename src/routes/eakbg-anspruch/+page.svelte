<script lang="ts">
	import { tick } from 'svelte';

	/* ===== State ===== */
	let toolAvailable = true;

	// Basisdaten
	let useActualBirth = $state(false);
	let dueDateStr = $state('');
	let actualBirthStr = $state('');

	// Mutter: Beginn Beschäftigungsverbot/Mutterschutz
	// Radio-Choice -> Boolean abgeleitet (vermeidet String/Boolean-Mix in bind:group)
	let motherBanKnownChoice: 'yes' | 'no' = $state('no');
	let motherBanStartStr = $state('');

	// Personenspezifisch
	type YesNo = '' | 'yes' | 'no';
	let mWorkedAndContinues: YesNo = $state('');
	let mJobStartStr = $state('');
	let mNoALV = $state(false);
	let mAllow14 = $state(false);

	let fWorkedAndContinues: YesNo = $state('');
	let fJobStartStr = $state('');
	let fNoALV = $state(false);
	let fAllow14 = $state(false);

	// UI
	let showAdvanced = $state(false);
	let hasSubmittedAll = $state(false);
	let resultHeadingEl: HTMLHeadingElement | null = null;

	/* ===== Helpers / Derived ===== */
	const addDays = (d: Date, days: number) => {
		const x = new Date(d);
		x.setDate(x.getDate() + days);
		return x;
	};
	const daysBetween = (a: Date, b: Date) => Math.floor((a.getTime() - b.getTime()) / 86_400_000);
	const isValidDate = (d: Date | null): d is Date =>
		d instanceof Date && !Number.isNaN(d.getTime());
	const asDate = (s: string) => (s ? new Date(`${s}T00:00:00`) : null);
	const dateFmt = new Intl.DateTimeFormat('de-AT', {
		day: '2-digit',
		month: '2-digit',
		year: 'numeric'
	});

	// ET / tatsächliche Geburt
	const et = $derived(() => asDate(dueDateStr));
	const actualBirth = $derived(() => asDate(actualBirthStr));
	const effectiveBirth = $derived(() => (useActualBirth && actualBirth() ? actualBirth() : et()));

	// Mutter: Radio-Choice -> Boolean
	const motherBanKnown = $derived(() => motherBanKnownChoice === 'yes');

	// Mutter-Stichtag: bekannt -> Datum, sonst ET − 56 (8 Wochen)
	const motherBanStart = $derived(() => asDate(motherBanStartStr));
	const motherRefDate = $derived(() => {
		if (motherBanKnown() && isValidDate(motherBanStart())) return motherBanStart();
		const _et = et();
		return isValidDate(_et) ? addDays(_et, -56) : null;
	});

	// Vater-Stichtag: Geburt (ET oder tatsächlich)
	const fatherRefDate = $derived(() => effectiveBirth());

	// Jobstarts
	const mJobStart = $derived(() => asDate(mJobStartStr));
	const fJobStart = $derived(() => asDate(fJobStartStr));

	// Labels & 182-Tage-Zeiträume
	const rangeLabel = (ref: Date | null) => {
		if (!isValidDate(ref)) return '—';
		const start = addDays(ref, -182);
		const end = addDays(ref, -1);
		return `${dateFmt.format(start)} – ${dateFmt.format(end)}`;
	};
	const mRangeLabel = $derived(() => rangeLabel(motherRefDate()));
	const fRangeLabel = $derived(() => rangeLabel(fatherRefDate()));
	const mStichtagLabel = $derived(() =>
		isValidDate(motherRefDate()) ? dateFmt.format(motherRefDate()!) : '—'
	);
	const fStichtagLabel = $derived(() =>
		isValidDate(fatherRefDate()) ? dateFmt.format(fatherRefDate()!) : '—'
	);

	// Eligibility (mit optionaler 14-Tage-Toleranz)
	function eligibleDays(jobStart: Date | null, refDate: Date | null, allow14: boolean): number {
		if (!isValidDate(jobStart) || !isValidDate(refDate)) return -1;
		const span = daysBetween(refDate!, jobStart!);
		return allow14 ? span + 14 : span;
	}
	const motherEligible = $derived(
		() =>
			mWorkedAndContinues === 'yes' &&
			mNoALV &&
			eligibleDays(mJobStart(), motherRefDate(), mAllow14) >= 182
	);
	const fatherEligible = $derived(
		() =>
			fWorkedAndContinues === 'yes' &&
			fNoALV &&
			eligibleDays(fJobStart(), fatherRefDate(), fAllow14) >= 182
	);

	// UI: Badges
	const badgeClass = (ok: boolean) =>
		ok
			? 'inline-flex items-center gap-2 rounded-full border border-emerald-300 bg-emerald-50 px-3 py-1 text-xs font-semibold text-emerald-700'
			: 'inline-flex items-center gap-2 rounded-full border border-rose-300 bg-rose-50 px-3 py-1 text-xs font-semibold text-rose-700';
	const badgeText = (ok: boolean) =>
		ok ? 'Ja – vorauss. Anspruch' : 'Nein – vorauss. kein Anspruch';

	async function handleCheck() {
		hasSubmittedAll = true;
		await tick();
		resultHeadingEl?.setAttribute('tabindex', '-1');
		resultHeadingEl?.focus();
	}
</script>

<section class="content">
	<header class="mt-10">
		<h1 class="text-3xl font-semibold text-slate-900">eaKBG – Vorab-Check (Österreich)</h1>
		<p class="mt-2 max-w-prose text-sm text-slate-600">
			Dieses Tool prüft vereinfacht, ob die <strong>182 Kalendertage Erwerbstätigkeit</strong> für
			das
			<strong>einkommensabhängige Kinderbetreuungsgeld</strong> (eaKBG) voraussichtlich erfüllt
			sind. Es ist ein <strong>Näherungs-/Planungs-Check</strong> – maßgeblich sind die
			<strong>tatsächlichen Daten</strong>
			(Geburt bzw. Beginn des Beschäftigungsverbots / Mutterschutz) und die Entscheidung der zuständigen
			Krankenkasse.
			<br />
			<em>Hinweis:</em> Zusätzlich kann – sofern die Voraussetzungen erfüllt sind – die
			<a href="/faq#sonderleistung-1" class="text-indigo-700 underline hover:text-indigo-600"
				>Sonderleistung 1</a
			>
			bezogen werden; sie ist hier nicht Gegenstand des Checks.
		</p>

		<!-- Offizielle Quellen -->
		<div class="mt-3 flex flex-wrap gap-2 text-xs">
			<a
				class="text-indigo-700 underline hover:text-indigo-600"
				href="https://www.gesundheitskasse.at/cdscontent/?contentid=10007.880037"
				target="_blank"
				rel="noreferrer">ÖGK: Einkommensabhängiges KBG</a
			>
			<a
				class="text-indigo-700 underline hover:text-indigo-600"
				href="https://www.sozialversicherung.at/cdscontent/load?contentid=10008.638104&version=1632292834"
				target="_blank"
				rel="noreferrer">Sozialversicherung: Voraussetzungen (inkl. 14-Tage-Regel)</a
			>
			<a
				class="text-indigo-700 underline hover:text-indigo-600"
				href="https://stmk.arbeiterkammer.at/service/broschuerenundratgeber/beruffamilie/20250108_Broschuere_Wenn_ein_Baby_kommt_2025.pdf"
				target="_blank"
				rel="noreferrer">AK: „Wenn ein Baby kommt“</a
			>
			<a
				class="text-indigo-700 underline hover:text-indigo-600"
				href="https://www.oesterreich.gv.at/de/themen/familie_und_partnerschaft/finanzielle-unterstuetzungen/3/2/1/Seite.080614"
				target="_blank"
				rel="noreferrer">oesterreich.gv.at: Antrag & Rückwirkung</a
			>
		</div>
	</header>

	{#if toolAvailable}
		<!-- 1) Basisdaten -->
		<section class="mt-8 rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
			<h2 class="text-lg font-semibold text-slate-900">1) Basisdaten</h2>
			<p class="mt-1 text-sm text-slate-600">
				Für den Vorab-Check genügt der <strong>errechnete Geburtstermin (ET)</strong>. Falls die
				<strong>tatsächliche Geburt</strong> bereits feststeht, kannst du umschalten.
			</p>

			<div class="mt-4 grid gap-4 md:grid-cols-2">
				<label class="flex items-center gap-2 text-sm font-medium text-slate-900">
					<input
						type="checkbox"
						bind:checked={useActualBirth}
						class="h-4 w-4 rounded border-slate-300 text-indigo-600 focus:ring-indigo-500"
						aria-describedby="actual-birth-help"
					/>
					Ich gebe den tatsächlichen Geburtstermin an (statt ET)
				</label>
				<p id="actual-birth-help" class="text-xs text-slate-500 md:col-span-2">
					Vater: Stichtag = tatsächliche Geburt (wenn gesetzt), sonst ET. Mutter: Beginn
					Beschäftigungs­verbot/Mutterschutz (oder ET − 56).
				</p>

				<div>
					<label class="text-sm font-semibold text-slate-900" for="due"
						>Errechneter Geburtstermin (ET) <span class="text-rose-600" aria-hidden="true">*</span
						></label
					>
					<input
						id="due"
						type="date"
						bind:value={dueDateStr}
						required
						aria-required="true"
						class="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2 text-sm text-slate-900 focus:ring-2 focus:ring-indigo-500 focus:outline-none"
					/>
				</div>

				{#if useActualBirth}
					<div>
						<label class="text-sm font-semibold text-slate-900" for="birth"
							>Tatsächlicher Geburtstermin <span class="text-rose-600" aria-hidden="true">*</span
							></label
						>
						<input
							id="birth"
							type="date"
							bind:value={actualBirthStr}
							required
							aria-required="true"
							class="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2 text-sm text-slate-900 focus:ring-2 focus:ring-indigo-500 focus:outline-none"
						/>
					</div>
				{/if}

				<!-- Bekannt/Unbekannt Auswahl für Mutter -->
				<div class="grid gap-2 md:col-span-2">
					<fieldset class="rounded-xl border border-slate-200 bg-slate-50 p-3">
						<legend class="text-sm font-semibold text-slate-900"
							>Beginn Beschäftigungsverbot/Mutterschutz</legend
						>

						<div
							class="mt-1 flex flex-wrap gap-6 text-sm"
							role="radiogroup"
							aria-label="Beginn Beschäftigungsverbot bekannt?"
						>
							<label class="inline-flex items-center gap-2">
								<input
									type="radio"
									name="ban-known"
									value="yes"
									bind:group={motherBanKnownChoice}
									class="h-4 w-4 border-slate-300 text-indigo-600 focus:ring-indigo-500"
								/>
								Ich kenne das Datum
							</label>
							<label class="inline-flex items-center gap-2">
								<input
									type="radio"
									name="ban-known"
									value="no"
									bind:group={motherBanKnownChoice}
									class="h-4 w-4 border-slate-300 text-indigo-600 focus:ring-indigo-500"
								/>
								Ich kenne es nicht (Standard: ET − 56 Tage)
							</label>
						</div>

						{#if motherBanKnown()}
							<div class="mt-3">
								<label class="text-sm font-medium text-slate-900" for="ban"
									>Datum (tt.mm.jjjj)</label
								>
								<input
									id="ban"
									type="date"
									bind:value={motherBanStartStr}
									class="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2 text-sm text-slate-900 focus:ring-2 focus:ring-indigo-500 focus:outline-none"
								/>
								<p class="mt-1 text-xs text-slate-500">
									Stichtag (Mutter) = dieses Datum. Zeitraum (182): {mRangeLabel()}
								</p>
							</div>
						{:else}
							<div class="mt-3 text-sm text-slate-700">
								Es wird <strong>ET − 56 Tage (8 Wochen)</strong> als Stichtag verwendet.
								<div
									class="mt-1 inline-flex items-center rounded-full border border-slate-300 bg-white px-2 py-0.5 text-xs font-medium text-slate-800"
								>
									Stichtag (Mutter): {mStichtagLabel()}
								</div>
								<div class="mt-1 text-xs text-slate-500">Zeitraum (182): {mRangeLabel()}</div>
							</div>
						{/if}
					</fieldset>
				</div>
			</div>
		</section>

		<!-- 2) Personenkarten -->
		<div class="mt-6 grid gap-6 md:grid-cols-2">
			<!-- Mutter -->
			<section class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
				<header><h2 class="text-lg font-semibold text-slate-900">2a) Mutter</h2></header>

				<div class="mt-3 space-y-4">
					<fieldset>
						<legend class="text-sm font-medium text-slate-900">
							In den letzten 182 Tagen <strong>vor dem Stichtag ({mStichtagLabel()})</strong>
							gearbeitet und <strong>aktuelles Dienstverhältnis aufrecht</strong>?
							<span class="text-rose-600" aria-hidden="true">*</span>
						</legend>
						<div class="mt-2 flex gap-6">
							<label class="inline-flex items-center gap-2">
								<input
									type="radio"
									name="m-worked"
									bind:group={mWorkedAndContinues}
									value="yes"
									class="h-4 w-4 border-slate-300 text-indigo-600 focus:ring-indigo-500"
								/>
								<span class="text-sm">Ja</span>
							</label>
							<label class="inline-flex items-center gap-2">
								<input
									type="radio"
									name="m-worked"
									bind:group={mWorkedAndContinues}
									value="no"
									class="h-4 w-4 border-slate-300 text-indigo-600 focus:ring-indigo-500"
								/>
								<span class="text-sm">Nein</span>
							</label>
						</div>
					</fieldset>

					{#if mWorkedAndContinues === 'no'}
						<p class="rounded-lg bg-rose-50 px-3 py-2 text-sm text-rose-700">
							Vereinfacht: vermutlich <strong>kein Anspruch</strong>. Prüfe ggf. das
							<a
								href="https://www.oesterreich.gv.at/de/themen/familie_und_partnerschaft/finanzielle-unterstuetzungen/3/2/Seite.080613"
								class="underline"
								target="_blank"
								rel="noreferrer">Kinderbetreuungsgeld-Konto</a
							>.
						</p>
					{:else}
						<div
							class="grid gap-3"
							aria-disabled={mWorkedAndContinues !== 'yes'}
							class:opacity-50={mWorkedAndContinues !== 'yes'}
							class:pointer-events-none={mWorkedAndContinues !== 'yes'}
						>
							<label class="text-sm font-medium text-slate-900" for="m-start"
								>Beschäftigungsbeginn <span class="text-rose-600" aria-hidden="true">*</span></label
							>
							<input
								id="m-start"
								type="date"
								bind:value={mJobStartStr}
								required
								aria-required="true"
								class="w-full rounded-lg border border-slate-300 px-3 py-2 text-sm text-slate-900 focus:ring-2 focus:ring-indigo-500 focus:outline-none"
							/>

							<label class="mt-1 flex items-center gap-2 text-sm text-slate-700">
								<input
									type="checkbox"
									bind:checked={mNoALV}
									class="h-4 w-4 rounded border-slate-300 text-indigo-600 focus:ring-indigo-500"
								/>
								Keine Leistungen (AMS/Notstand/Weiterbildungsgeld) im Zeitraum {mRangeLabel()}
							</label>

							{#if showAdvanced}
								<label class="mt-1 flex items-center gap-2 text-sm text-slate-700">
									<input
										type="checkbox"
										bind:checked={mAllow14}
										class="h-4 w-4 rounded border-slate-300 text-indigo-600 focus:ring-indigo-500"
									/>
									Kurze Unterbrechungen bis 14 Tage berücksichtigen
								</label>
							{/if}

							<div class="mt-2 text-xs text-slate-600">
								<strong>Stichtag:</strong>
								{mStichtagLabel()} · <strong>Zeitraum (182):</strong>
								{mRangeLabel()}
							</div>
						</div>
					{/if}
				</div>
			</section>

			<!-- Vater -->
			<section class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
				<header><h2 class="text-lg font-semibold text-slate-900">2b) Vater</h2></header>

				<div class="mt-3 space-y-4">
					<fieldset>
						<legend class="text-sm font-medium text-slate-900">
							In den letzten 182 Tagen <strong>vor dem Stichtag ({fStichtagLabel()})</strong>
							gearbeitet und <strong>aktuelles Dienstverhältnis aufrecht</strong>?
							<span class="text-rose-600" aria-hidden="true">*</span>
						</legend>
						<div class="mt-2 flex gap-6">
							<label class="inline-flex items-center gap-2">
								<input
									type="radio"
									name="f-worked"
									bind:group={fWorkedAndContinues}
									value="yes"
									class="h-4 w-4 border-slate-300 text-indigo-600 focus:ring-indigo-500"
								/>
								<span class="text-sm">Ja</span>
							</label>
							<label class="inline-flex items-center gap-2">
								<input
									type="radio"
									name="f-worked"
									bind:group={fWorkedAndContinues}
									value="no"
									class="h-4 w-4 border-slate-300 text-indigo-600 focus:ring-indigo-500"
								/>
								<span class="text-sm">Nein</span>
							</label>
						</div>
					</fieldset>

					{#if fWorkedAndContinues === 'no'}
						<p class="rounded-lg bg-rose-50 px-3 py-2 text-sm text-rose-700">
							Vereinfacht: vermutlich <strong>kein Anspruch</strong>. Prüfe ggf. das
							<a
								href="https://www.oesterreich.gv.at/de/themen/familie_und_partnerschaft/finanzielle-unterstuetzungen/3/2/Seite.080613"
								class="underline"
								target="_blank"
								rel="noreferrer">Kinderbetreuungsgeld-Konto</a
							>.
						</p>
					{:else}
						<div
							class="grid gap-3"
							aria-disabled={fWorkedAndContinues !== 'yes'}
							class:opacity-50={fWorkedAndContinues !== 'yes'}
							class:pointer-events-none={fWorkedAndContinues !== 'yes'}
						>
							<label class="text-sm font-medium text-slate-900" for="f-start"
								>Beschäftigungsbeginn <span class="text-rose-600" aria-hidden="true">*</span></label
							>
							<input
								id="f-start"
								type="date"
								bind:value={fJobStartStr}
								required
								aria-required="true"
								class="w-full rounded-lg border border-slate-300 px-3 py-2 text-sm text-slate-900 focus:ring-2 focus:ring-indigo-500 focus:outline-none"
							/>

							<label class="mt-1 flex items-center gap-2 text-sm text-slate-700">
								<input
									type="checkbox"
									bind:checked={fNoALV}
									class="h-4 w-4 rounded border-slate-300 text-indigo-600 focus:ring-indigo-500"
								/>
								Keine Leistungen (AMS/Notstand/Weiterbildungsgeld) im Zeitraum {fRangeLabel()}
							</label>

							{#if showAdvanced}
								<label class="mt-1 flex items-center gap-2 text-sm text-slate-700">
									<input
										type="checkbox"
										bind:checked={fAllow14}
										class="h-4 w-4 rounded border-slate-300 text-indigo-600 focus:ring-indigo-500"
									/>
									Kurze Unterbrechungen bis 14 Tage berücksichtigen
								</label>
							{/if}

							<div class="mt-2 text-xs text-slate-600">
								<strong>Stichtag:</strong>
								{fStichtagLabel()} · <strong>Zeitraum (182):</strong>
								{fRangeLabel()}
							</div>
						</div>
					{/if}
				</div>
			</section>
		</div>

		<!-- 3) Spezialfälle -->
		<section class="mt-4 rounded-2xl border border-slate-200 bg-white p-4 shadow-sm">
			<button
				type="button"
				class="w-full text-left"
				onclick={() => (showAdvanced = !showAdvanced)}
				aria-expanded={showAdvanced}
				aria-controls="advanced-panel"
			>
				<div class="flex items-center justify-between">
					<h3 class="text-sm font-semibold text-slate-900">
						3) Spezialfälle einblenden (optional)
					</h3>
					<span class="text-xs text-slate-600">{showAdvanced ? 'verbergen' : 'anzeigen'}</span>
				</div>
			</button>
			<div
				id="advanced-panel"
				class="mt-3 grid gap-3 text-sm text-slate-700"
				hidden={!showAdvanced}
			>
				<p>
					• <strong>14-Tage-Toleranz</strong>: Unterbrechungen bis zu 14 Kalendertagen im
					182-Tage-Fenster sind unschädlich.
					<a
						class="text-indigo-700 underline"
						href="https://www.sozialversicherung.at/cdscontent/load?contentid=10008.638104&version=1632292834"
						target="_blank"
						rel="noreferrer">Quelle</a
					>
				</p>
				<p>
					• <strong>Gleichgestellte Zeiten</strong> (z. B. Mutterschutz, Karenz bis max. 2. Geburtstag
					bei aufrechtem DV) können als Erwerbstätigkeit gelten – Details siehe Quelle.
				</p>
				<p>
					• <strong>Antrag & Frist</strong>: Antrag frühestens ab Geburt; rückwirkend max. 182 Tage.
					<a
						class="text-indigo-700 underline"
						href="https://www.oesterreich.gv.at/de/themen/familie_und_partnerschaft/finanzielle-unterstuetzungen/3/2/1/Seite.080614"
						target="_blank"
						rel="noreferrer">oesterreich.gv.at</a
					>
				</p>
			</div>
		</section>

		<!-- Prüfen -->
		<div class="mt-6 flex items-center justify-end">
			<button
				type="button"
				onclick={handleCheck}
				class="inline-flex items-center justify-center rounded-lg bg-indigo-600 px-4 py-2 text-sm font-semibold text-white shadow-sm transition hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-500"
			>
				Anspruch prüfen (beide)
			</button>
		</div>

		<!-- Ergebnis -->
		{#if hasSubmittedAll}
			<section class="mt-4 rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
				<h2 bind:this={resultHeadingEl} class="text-lg font-semibold text-slate-900">
					Ergebnis (Vorab-Check)
				</h2>
				<p class="mt-1 text-sm text-slate-600">
					Endgültig ist die Beurteilung erst mit den <strong>tatsächlichen Daten</strong> und der
					Prüfung durch die <strong>zuständige Krankenkasse</strong>.
				</p>

				<div class="mt-4 grid gap-4 md:grid-cols-2">
					<div class="rounded-xl border border-slate-200 bg-slate-50 p-4">
						<p class="text-sm font-semibold text-slate-900">Mutter</p>
						<div class="mt-2">
							<div class={badgeClass(motherEligible())}>{badgeText(motherEligible())}</div>
							<ul class="mt-2 list-disc pl-5 text-sm text-slate-700">
								<li>Stichtag: {mStichtagLabel()}</li>
								<li>Zeitraum (182): {mRangeLabel()}</li>
								<li>
									Gearbeitet & Dienstverhältnis aufrecht: {mWorkedAndContinues === 'yes'
										? 'Ja'
										: 'Nein'}
								</li>
								<li>Kein AMS/Notstand/Weiterbildungsgeld: {mNoALV ? 'Ja' : 'Nein'}</li>
								{#if showAdvanced}<li>
										14-Tage-Toleranz berücksichtigt: {mAllow14 ? 'Ja' : 'Nein'}
									</li>{/if}
							</ul>
						</div>
					</div>

					<div class="rounded-xl border border-slate-200 bg-slate-50 p-4">
						<p class="text-sm font-semibold text-slate-900">Vater</p>
						<div class="mt-2">
							<div class={badgeClass(fatherEligible())}>{badgeText(fatherEligible())}</div>
							<ul class="mt-2 list-disc pl-5 text-sm text-slate-700">
								<li>Stichtag: {fStichtagLabel()}</li>
								<li>Zeitraum (182): {fRangeLabel()}</li>
								<li>
									Gearbeitet & Dienstverhältnis aufrecht: {fWorkedAndContinues === 'yes'
										? 'Ja'
										: 'Nein'}
								</li>
								<li>Kein AMS/Notstand/Weiterbildungsgeld: {fNoALV ? 'Ja' : 'Nein'}</li>
								{#if showAdvanced}<li>
										14-Tage-Toleranz berücksichtigt: {fAllow14 ? 'Ja' : 'Nein'}
									</li>{/if}
							</ul>
						</div>
					</div>
				</div>

				<div class="mt-4 rounded-xl border border-amber-200 bg-amber-50 p-4 text-sm text-amber-800">
					<p class="font-medium">Was jetzt?</p>
					<ul class="mt-2 list-disc pl-5">
						<li>
							Antrag bei der <a
								class="underline"
								href="https://www.gesundheitskasse.at/cdscontent/?contentid=10007.880037"
								target="_blank"
								rel="noreferrer">ÖGK</a
							> stellen (frühestens ab Geburt; rückwirkend max. 182 Tage).
						</li>
						<li>
							Allgemeine Voraussetzungen beachten: gemeinsamer Haushalt/Hauptwohnsitzmeldung,
							Familienbeihilfe, Mutter-Kind-Pass-Untersuchungen.
						</li>
						<li>
							Bei Unsicherheiten: Beratung der <a
								class="underline"
								href="https://www.arbeiterkammer.at/kbg"
								target="_blank"
								rel="noreferrer">Arbeiterkammer</a
							> nutzen.
						</li>
					</ul>
				</div>
			</section>
		{/if}
	{:else}
		<p class="mt-8 font-semibold">🚧 Tool ist noch in Entwicklung 🚧</p>
	{/if}
</section>

<style>
	/* Kleine Helfer */
	[hidden] {
		display: none;
	}
</style>
