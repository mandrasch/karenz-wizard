<script lang="ts">
	import { tick } from 'svelte';

	/* Schrift (IBM Plex Sans Condensed) – bereits installiert */
	import '@fontsource/ibm-plex-sans-condensed/400.css';
	import '@fontsource/ibm-plex-sans-condensed/500.css';
	import '@fontsource/ibm-plex-sans-condensed/600.css';
	import '@fontsource/ibm-plex-sans-condensed/700.css';

	type QuickPerson = 'mother' | 'father';
	let quickPerson: QuickPerson = $state('mother');

	let toolAvailable = true;

	// Basisdaten
	let dueDateStr = $state(''); // ET (errechneter Geburtstermin)
	let actualBirthStr = $state(''); // Tatsächlicher Geburtstermin (nur wenn Vater-Basis "actual")
	let fatherBirthBasis: 'et' | 'actual' = $state('et'); // Umschalter in der Vater-Box

	// Mutter: Beginn Beschäftigungsverbot/Mutterschutz (bekannt?)
	let motherBanKnownChoice: 'yes' | 'no' = $state('no');
	let motherBanStartStr = $state('');

	// Selbstauskunft
	let mHasDV = $state(false);
	let mNoALV = $state(false);
	let fHasDV = $state(false);
	let fNoALV = $state(false);

	// Helpers / Derived
	const addDays = (d: Date, days: number) => {
		const x = new Date(d);
		x.setDate(x.getDate() + days);
		return x;
	};
	const isValidDate = (d: Date | null): d is Date =>
		d instanceof Date && !Number.isNaN(d.getTime());
	const asDate = (s: string) => (s ? new Date(`${s}T00:00:00`) : null);
	const dateFmt = new Intl.DateTimeFormat('de-AT', {
		day: '2-digit',
		month: '2-digit',
		year: 'numeric'
	});

	const et = $derived(() => asDate(dueDateStr));
	const actualBirth = $derived(() => asDate(actualBirthStr));

	const motherBanKnown = $derived(() => motherBanKnownChoice === 'yes');
	const motherBanStart = $derived(() => asDate(motherBanStartStr));

	// Mutter-Stichtag: Beginn Beschäftigungsverbots/Mutterschutz (falls unbekannt: ET − 56 Tage (8 Wochen))
	const motherRefDate = $derived(() => {
		if (motherBanKnown() && isValidDate(motherBanStart())) return motherBanStart();
		const _et = et();
		return isValidDate(_et) ? addDays(_et, -56) : null;
	});

	// Vater-Stichtag: Geburt (je nach Umschalter tatsächlich oder ET)
	const fatherRefDate = $derived(() => {
		const _et = et();
		const _birth = actualBirth();
		if (fatherBirthBasis === 'actual' && isValidDate(_birth)) return _birth;
		return _et;
	});

	// Labels & 182 Tage-Fenster
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

	// Eligibility (Selbstauskunft: beide Checkboxen = Ja)
	const motherEligibleQuick = $derived(() => mHasDV && mNoALV);
	const fatherEligibleQuick = $derived(() => fHasDV && fNoALV);

	// UI
	const badgeClass = (ok: boolean) =>
		ok
			? 'inline-flex items-center gap-2 rounded-full border border-emerald-300 bg-emerald-50 px-3 py-1 text-xs font-semibold text-emerald-700'
			: 'inline-flex items-center gap-2 rounded-full border border-rose-300 bg-rose-50 px-3 py-1 text-xs font-semibold text-rose-700';

	function switchPerson(p: QuickPerson) {
		quickPerson = p;
		tick().then(() =>
			document.getElementById(p === 'mother' ? 'mother-title' : 'father-title')?.focus()
		);
	}
</script>

<!-- Wrapper mit eigener Font-Familie -->
<section class="eakbg content">
	<p class="mt-8 w-full text-center">
		⚠️ Vorschau! Dieses Tool ist noch in Arbeit, noch nicht durchgeprüft! ⚠️
	</p>

	<!-- Kompakter Header -->
	<header class="mt-8">
		<div class="flex flex-wrap items-start justify-between gap-3">
			<h1 class="text-2xl leading-tight font-semibold text-slate-900">eaKBG – Anspruch prüfen</h1>
			<span
				class="inline-flex items-center gap-1 rounded-full border border-slate-300 bg-slate-50 px-2.5 py-1 text-[11px] font-semibold text-slate-700"
			>
				Vorab-Check · unverbindlich
			</span>
		</div>

		<p class="mt-1 text-[13px] leading-snug text-slate-700">
			Für das <strong>einkommensabhängige Kinderbetreuungsgeld</strong> (eaKBG) musst du in den
			<strong>182 Kalendertagen vor einem bestimmten Stichtag</strong> erwerbstätig gewesen sein –
			und in dieser Zeit
			<strong>keine AMS-, Notstands- oder Weiterbildungsgeld-Leistungen</strong> erhalten haben. Bei
			der <strong>Mutter</strong> ist der Stichtag der Mutterschutzbeginn (meist
			<strong>56 Tage (8 Wochen)</strong>
			vor ET), beim <strong>Vater</strong> die <strong>Geburt</strong>. Bitte
			<strong>beide Elternteile prüfen</strong>
			– wenn nur einer die Voraussetzungen erfüllt, kann der andere ggf. die
			<a href="/faq#sonderleistung-1" class="text-indigo-700 underline hover:text-indigo-600"
				>Sonderleistung 1</a
			> erhalten.
		</p>

		<!-- Quellen kompakt -->
		<p class="mt-2 text-[11px] text-slate-500">
			Quellen:
			<a
				class="underline hover:text-slate-700"
				href="https://www.gesundheitskasse.at/cdscontent/?contentid=10007.880037"
				target="_blank"
				rel="noreferrer">ÖGK</a
			>
			·
			<a
				class="underline hover:text-slate-700"
				href="https://www.sozialversicherung.at/cdscontent/load?contentid=10008.638104&version=1632292834"
				target="_blank"
				rel="noreferrer">Sozialversicherung</a
			>
			·
			<a
				class="underline hover:text-slate-700"
				href="https://stmk.arbeiterkammer.at/service/broschuerenundratgeber/beruffamilie/20250108_Broschuere_Wenn_ein_Baby_kommt_2025.pdf"
				target="_blank"
				rel="noreferrer">AK</a
			>
			·
			<a
				class="underline hover:text-slate-700"
				href="https://www.oesterreich.gv.at/de/themen/familie_und_partnerschaft/finanzielle-unterstuetzungen/3/2/1/Seite.080614"
				target="_blank"
				rel="noreferrer">oesterreich.gv.at</a
			>
		</p>
	</header>

	{#if toolAvailable}
		<!-- Basisdaten -->
		<section class="mt-6 rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
			<h2 class="text-base font-semibold text-slate-900">Basisdaten</h2>
			<p class="mt-1 text-[13px] text-slate-600">
				Zuerst den <strong>errechneten Geburtstermin (ET)</strong> eintragen. Bei der
				<strong>Mutter</strong>
				ist der Stichtag der Mutterschutzbeginn; wenn nicht bekannt, wird
				<strong>ET − 56 Tage (8 Wochen)</strong>
				verwendet. Beim <strong>Vater</strong> ist der Stichtag die <strong>Geburt</strong> (tatsächlich
				oder – wenn nicht vorhanden – der ET).
			</p>

			<div class="mt-4 grid gap-4 md:grid-cols-2">
				<!-- ET -->
				<div>
					<label class="text-[13px] font-semibold text-slate-900" for="due">
						Errechneter Geburtstermin (ET) <span class="text-rose-600" aria-hidden="true">*</span>
					</label>
					<input
						id="due"
						type="date"
						bind:value={dueDateStr}
						required
						aria-required="true"
						class="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2 text-[13px] text-slate-900 focus:ring-2 focus:ring-indigo-500 focus:outline-none"
					/>
				</div>
			</div>
		</section>

		<!-- Platzhalter wenn ET fehlt -->
		{#if !isValidDate(et())}
			<div class="mt-5 rounded-2xl border border-slate-200 bg-slate-50 p-5 text-center shadow-sm">
				<p class="text-[13px] font-medium text-slate-700">
					Bitte zuerst den <strong>errechneten Geburtstermin (ET)</strong> eingeben, um die Prüfung zu
					starten.
				</p>
			</div>
		{/if}

		{#if isValidDate(et())}
			<!-- Hinweis: beide prüfen -->
			<section
				class="mt-4 rounded-2xl border border-indigo-200 bg-indigo-50 p-4 text-[13px] text-indigo-900"
			>
				<p class="font-medium">Bitte beide Elternteile prüfen.</p>
				<p class="mt-1">
					Wenn ein Elternteil den eaKBG-Anspruch erfüllt, kann der
					<a href="/faq#sonderleistung-1" class="underline"
						>andere Elternteil ggf. die Sonderleistung 1</a
					> beziehen (sofern die Voraussetzungen erfüllt sind).
				</p>
			</section>

			<!-- Tabs -->
			<div
				class="mt-5 inline-flex overflow-hidden rounded-lg border border-slate-300"
				role="tablist"
				aria-label="Elternteil wählen"
			>
				<button
					type="button"
					role="tab"
					aria-selected={quickPerson === 'mother'}
					class={'px-4 py-2 text-[13px] ' +
						(quickPerson === 'mother'
							? 'bg-indigo-600 text-white'
							: 'bg-white text-slate-800 hover:bg-slate-50')}
					onclick={() => switchPerson('mother')}
				>
					Mutter
				</button>
				<button
					type="button"
					role="tab"
					aria-selected={quickPerson === 'father'}
					class={'px-4 py-2 text-[13px] ' +
						(quickPerson === 'father'
							? 'bg-indigo-600 text-white'
							: 'bg-white text-slate-800 hover:bg-slate-50')}
					onclick={() => switchPerson('father')}
				>
					Vater
				</button>
			</div>

			<!-- Mutter -->
			<section
				class="mt-4 rounded-2xl border border-slate-200 bg-white p-5 shadow-sm"
				aria-labelledby="mother-title"
				hidden={quickPerson !== 'mother'}
			>
				<h2 id="mother-title" tabindex="-1" class="text-base font-semibold text-slate-900">
					Mutter – Stichtag: <span class="font-normal">{mStichtagLabel()}</span>
				</h2>
				<p class="mt-1 text-[12px] text-slate-600">
					Stichtag ist der <strong>Beginn des Beschäftigungsverbots/Mutterschutzes</strong> (falls
					bekannt), sonst <strong>ET − 56 Tage (8 Wochen)</strong>. Der Prüfzeitraum sind die
					<strong>182 Kalendertage vor dem Stichtag</strong>.
				</p>

				<div class="mt-3 grid gap-3">
					<fieldset class="rounded-lg border border-slate-200 bg-slate-50 p-3">
						<legend class="text-[12px] font-semibold text-slate-900"
							>Beginn Beschäftigungsverbots/Mutterschutz</legend
						>
						<div class="mt-1 flex flex-wrap gap-6">
							<label class="inline-flex items-center gap-2 text-[13px]">
								<input
									type="radio"
									name="m-ban-known"
									value="yes"
									bind:group={motherBanKnownChoice}
									class="h-4 w-4 border-slate-300 text-indigo-600 focus:ring-indigo-500"
								/>
								Ich kenne das Datum
							</label>
							<label class="inline-flex items-center gap-2 text-[13px]">
								<input
									type="radio"
									name="m-ban-known"
									value="no"
									bind:group={motherBanKnownChoice}
									class="h-4 w-4 border-slate-300 text-indigo-600 focus:ring-indigo-500"
								/>
								Ich kenne es nicht (Standard: ET − 56 Tage (8 Wochen))
							</label>
						</div>
						{#if motherBanKnown()}
							<div class="mt-2">
								<label class="text-[12px] font-medium text-slate-900" for="m-ban">Datum</label>
								<input
									id="m-ban"
									type="date"
									bind:value={motherBanStartStr}
									class="mt-1 w-full rounded-lg border border-slate-300 px-3 py-1.5 text-[13px] text-slate-900 focus:ring-2 focus:ring-indigo-500 focus:outline-none"
								/>
							</div>
						{:else}
							<p class="mt-2 text-[12px] text-slate-600">
								Es wird <strong>ET − 56 Tage (8 Wochen)</strong> verwendet.
							</p>
						{/if}
					</fieldset>

					<label class="flex items-center gap-2 text-[13px] text-slate-700">
						<input
							type="checkbox"
							bind:checked={mHasDV}
							class="h-4 w-4 rounded border-slate-300 text-indigo-600 focus:ring-indigo-500"
						/>
						Ich habe ein aufrechtes Arbeitsverhältnis (oder gleichgestellte Zeiten).
					</label>

					<label class="flex items-start gap-2 text-[13px] text-slate-700">
						<input
							type="checkbox"
							bind:checked={mNoALV}
							disabled={!mHasDV}
							class="mt-0.5 h-4 w-4 rounded border-slate-300 text-indigo-600 focus:ring-indigo-500 disabled:cursor-not-allowed disabled:opacity-60"
						/>
						<span>
							Keine AMS-/Notstands-/Weiterbildungsgeld-Leistungen im Zeitraum <strong
								>{mRangeLabel()}</strong
							>.<br />
							<span class="text-[11px] text-slate-500">
								Gilt nur, wenn das Dienstverhältnis (oder gleichgestellte Zeiten) im Zeitraum
								aufrecht war; kurze Unterbrechungen bis 14 Tage sind unschädlich. ({mStichtagLabel()}
								− 182 Tage)
							</span>
						</span>
					</label>
				</div>

				<div class="mt-4 rounded-xl border border-slate-200 bg-slate-50 p-4">
					<div class={badgeClass(motherEligibleQuick())}>
						{motherEligibleQuick()
							? 'Ja – voraussichtlich Anspruch'
							: 'Nein – voraussichtlich kein Anspruch'}
					</div>
					{#if !motherEligibleQuick()}
						<p class="mt-1 text-[12px]">
							Wenn der andere Elternteil eaKBG erfüllt, ist ggf. die
							<a class="text-indigo-700 underline" href="/faq#sonderleistung-1">Sonderleistung 1</a>
							möglich.
						</p>
					{/if}
				</div>
			</section>

			<!-- Vater -->
			<section
				class="mt-4 rounded-2xl border border-slate-200 bg-white p-5 shadow-sm"
				aria-labelledby="father-title"
				hidden={quickPerson !== 'father'}
			>
				<h2 id="father-title" tabindex="-1" class="text-base font-semibold text-slate-900">
					Vater – Stichtag: <span class="font-normal">{fStichtagLabel()}</span>
				</h2>
				<p class="mt-1 text-[12px] text-slate-600">
					<strong>Stichtag ist die Geburt</strong> (tatsächlich, wenn ausgewählt und bekannt, sonst
					ET).<br />
					Der Prüfzeitraum umfasst die <strong>182 Kalendertage vor dem Stichtag</strong> (<span
						class="whitespace-nowrap">{fStichtagLabel()}</span
					>).
				</p>

				<!-- Vater – Grundlage für den Stichtag -->
				<fieldset class="mt-3 rounded-lg border border-slate-200 bg-slate-50 p-3">
					<legend class="text-[12px] font-semibold text-slate-900"
						>Vater – Grundlage für den Stichtag</legend
					>
					<div class="mt-1 flex flex-wrap items-center gap-6">
						<label class="inline-flex items-center gap-2 text-[13px]">
							<input
								type="radio"
								name="father-basis"
								value="et"
								bind:group={fatherBirthBasis}
								class="h-4 w-4 border-slate-300 text-indigo-600 focus:ring-indigo-500"
							/>
							Errechneter Geburtstermin (ET)
						</label>
						<label class="inline-flex items-center gap-2 text-[13px]">
							<input
								type="radio"
								name="father-basis"
								value="actual"
								bind:group={fatherBirthBasis}
								class="h-4 w-4 border-slate-300 text-indigo-600 focus:ring-indigo-500"
							/>
							Tatsächlicher Geburtstermin
						</label>
					</div>

					{#if fatherBirthBasis === 'actual'}
						<div class="mt-3">
							<label class="text-[13px] font-semibold text-slate-900" for="birth">
								Tatsächlicher Geburtstermin <span class="text-rose-600" aria-hidden="true">*</span>
							</label>
							<input
								id="birth"
								type="date"
								bind:value={actualBirthStr}
								required
								aria-required="true"
								class="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2 text-[13px] text-slate-900 focus:ring-2 focus:ring-indigo-500 focus:outline-none"
							/>
							<p class="mt-1 text-[12px] text-slate-500">
								Dieses Datum gilt nur für den <strong>Vater</strong> als Stichtag. Bei der
								<strong>Mutter</strong>
								bleibt der Stichtag der Mutterschutzbeginn (ist dieser nicht bekannt, wird
								<strong>ET − 56 Tage (8 Wochen)</strong> verwendet).
							</p>
						</div>
					{/if}
				</fieldset>

				<div class="mt-3 grid gap-3">
					<label class="flex items-center gap-2 text-[13px] text-slate-700">
						<input
							type="checkbox"
							bind:checked={fHasDV}
							class="h-4 w-4 rounded border-slate-300 text-indigo-600 focus:ring-indigo-500"
						/>
						Ich habe ein aufrechtes Arbeitsverhältnis (oder gleichgestellte Zeiten).
					</label>

					<label class="flex items-start gap-2 text-[13px] text-slate-700">
						<input
							type="checkbox"
							bind:checked={fNoALV}
							disabled={!fHasDV}
							class="mt-0.5 h-4 w-4 rounded border-slate-300 text-indigo-600 focus:ring-indigo-500 disabled:cursor-not-allowed disabled:opacity-60"
						/>
						<span>
							Keine AMS-/Notstands-/Weiterbildungsgeld-Leistungen im Zeitraum <strong
								>{fRangeLabel()}</strong
							>.<br />
							<span class="text-[11px] text-slate-500">
								Gilt nur, wenn das Dienstverhältnis (oder gleichgestellte Zeiten) im Zeitraum
								aufrecht war; kurze Unterbrechungen bis 14 Tage sind unschädlich. ({fStichtagLabel()}
								− 182 Tage)
							</span>
						</span>
					</label>
				</div>

				<div class="mt-4 rounded-xl border border-slate-200 bg-slate-50 p-4">
					<div class={badgeClass(fatherEligibleQuick())}>
						{fatherEligibleQuick()
							? 'Ja – voraussichtlich Anspruch'
							: 'Nein – voraussichtlich kein Anspruch'}
					</div>
					{#if !fatherEligibleQuick()}
						<p class="mt-1 text-[12px]">
							Wenn der andere Elternteil eaKBG erfüllt, ist ggf.
							<a class="text-indigo-700 underline" href="/faq#sonderleistung-1">Sonderleistung 1</a>
							möglich.
						</p>
					{/if}
				</div>
			</section>

			<!-- WICHTIGE HINWEISE -->
			<section
				class="mt-6 rounded-2xl border border-amber-200 bg-amber-50 p-5 text-[13px] text-amber-900 shadow-sm"
			>
				<h2 class="text-[14px] font-semibold text-amber-900">Wichtige Hinweise</h2>
				<ul class="mt-2 list-disc space-y-1 pl-5">
					<li>
						<strong>Vorab-/Planungs-Check:</strong> Dieses Tool vereinfacht die Prüfung auf Basis
						deiner Angaben (aufrechtes Dienstverhältnis & keine Leistungen im 182-Tage-Zeitraum).
						Die <strong>endgültige Beurteilung</strong> erfolgt durch die zuständige Krankenkasse.
					</li>
					<li>
						<strong>Stichtage:</strong> Mutter: Mutterschutzbeginn (falls unbekannt:
						<strong>ET − 56 Tage (8 Wochen)</strong>). Vater: <strong>Geburt</strong> (je nach
						Auswahl tatsächlicher Termin oder ET). Der Prüfzeitraum umfasst jeweils die
						<strong>182 Kalendertage davor</strong>.
					</li>
					<li>
						<strong>Kurze Unterbrechungen bis 14 Tage:</strong> Unterbrechungen bis zu
						<strong>14 Kalendertagen</strong>
						im 182-Tage-Fenster sind unschädlich (z. B. Arbeitgeberwechsel). Details:
						<a
							class="underline"
							href="https://www.sozialversicherung.at/cdscontent/load?contentid=10008.638104&version=1632292834"
							target="_blank"
							rel="noreferrer">Sozialversicherung – Voraussetzungen</a
						>.
					</li>
					<li>
						<strong>Gleichgestellte Zeiten:</strong> Bestimmte Zeiten (z. B. Mutterschutz, Karenz
						bis max. 2. Geburtstag bei aufrechtem DV) können berücksichtigt werden. Siehe
						<a
							class="underline"
							href="https://www.gesundheitskasse.at/cdscontent/?contentid=10007.880037"
							target="_blank"
							rel="noreferrer">ÖGK-Informationen</a
						>.
					</li>
					<li>
						<strong>Geltungsbereich:</strong> Primär für
						<strong>unselbständig Beschäftigte</strong>. Für Selbständige/freie DN gelten teils
						andere Regeln – bitte offizielle Infos beachten.
					</li>
					<li>
						<strong>Sonderfälle:</strong> Z. B. weiteres Kind während Karenz → abweichende Regeln
						möglich. Beratung:
						<a
							class="underline"
							href="https://www.arbeiterkammer.at/kbg"
							target="_blank"
							rel="noreferrer">Arbeiterkammer</a
						>.
					</li>
					<li>
						<strong>Antrag & Fristen:</strong> Antrag ab Geburt; rückwirkend max.
						<strong>182 Tage</strong>. Quelle:
						<a
							class="underline"
							href="https://www.oesterreich.gv.at/de/themen/familie_und_partnerschaft/finanzielle-unterstuetzungen/3/2/1/Seite.080614"
							target="_blank"
							rel="noreferrer">oesterreich.gv.at</a
						>.
					</li>
					<li>
						<strong>Sonderleistung 1:</strong> Erfüllt <em>ein</em> Elternteil den eaKBG-Anspruch
						nicht, kann der andere Elternteil ggf. die
						<a class="underline" href="/faq#sonderleistung-1">Sonderleistung 1</a> beziehen (sofern die
						Voraussetzungen erfüllt sind).
					</li>
				</ul>
			</section>
		{/if}
	{:else}
		<p class="mt-8 font-semibold">🚧 Tool ist noch in Entwicklung 🚧</p>
	{/if}
</section>

<style>
	/* Nur im Tool-Bereich aktivieren, um andere Seiten nicht zu beeinflussen */
	.eakbg {
		font-family:
			'IBM Plex Sans Condensed',
			ui-sans-serif,
			system-ui,
			-apple-system,
			Segoe UI,
			Roboto,
			Helvetica,
			Arial,
			'Apple Color Emoji',
			'Segoe UI Emoji';
	}
	[hidden] {
		display: none;
	}
</style>
