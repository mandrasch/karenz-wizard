<script lang="ts">
	export type Segment = {
		id: string;
		title: string;
		days: number;
		summaryKey?: string;
		parent?: 'mother' | 'father' | 'third';
		benefitType?: 'ea-paid' | 'unpaid' | 'other';
		[key: string]: unknown;
	};

	let {
		segmentSummaries = [] as Segment[],
		birthDateInput = $bindable<string | undefined>(undefined),
		formatSegmentRange,
		open = $bindable(true)
	} = $props();

	const SUMMARY_WHITELIST = new Set(['mother-karenz', 'father-karenz', 'third-karenz']);

	const visibleSegmentSummaries = $derived(
		segmentSummaries.filter(
			(segment) => segment.summaryKey !== undefined && SUMMARY_WHITELIST.has(segment.summaryKey)
		)
	);

	const DEFAULT_DAILY_CAP = 66;

	const sanitizeEuroInput = (value: string): number => {
		if (!value) {
			return 0;
		}
		const trimmed = value.replace(/\s+/g, '');
		const needsThousandsCleanup = trimmed.includes(',') && trimmed.includes('.');
		const normalized = (needsThousandsCleanup ? trimmed.replace(/\./g, '') : trimmed).replace(',', '.');
		const parsed = Number(normalized);
		return Number.isFinite(parsed) ? parsed : 0;
	};

	let motherDailyWochengeldInput = $state('');
	let fatherDailyBaseInput = $state('');
	let dailyCapInput = $state(DEFAULT_DAILY_CAP.toFixed(2));

	const motherDailyBase = $derived(sanitizeEuroInput(motherDailyWochengeldInput));
	const fatherDailyBase = $derived(sanitizeEuroInput(fatherDailyBaseInput));
	const dailyCap = $derived(() => {
		const value = sanitizeEuroInput(dailyCapInput);
		return value > 0 ? value : DEFAULT_DAILY_CAP;
	});

	const motherEaDaily = $derived(
		motherDailyBase > 0 ? Math.min(dailyCap, motherDailyBase * 0.8) : 0
	);
	const fatherEaDaily = $derived(
		fatherDailyBase > 0 ? Math.min(dailyCap, fatherDailyBase * 0.8) : 0
	);

	const euroFormatter = new Intl.NumberFormat('de-AT', {
		style: 'currency',
		currency: 'EUR',
		minimumFractionDigits: 2,
		maximumFractionDigits: 2
	});

	const formatCurrency = (value: number) => euroFormatter.format(value);
	const formatDailyRate = (value: number) =>
		value > 0 ? `${formatCurrency(value)} / Tag` : '—';

	type ComputedSegment = Segment & {
		dailyRate: number;
		totalAmount: number;
	};

	const computedSegments = $derived<ComputedSegment[]>(
		visibleSegmentSummaries.map((segment) => {
			const benefitType = segment.benefitType ?? 'other';
			const parent = segment.parent ?? 'mother';
			let dailyRate = 0;
			if (benefitType === 'ea-paid') {
				if (parent === 'mother' || parent === 'third') {
					dailyRate = motherEaDaily;
				} else if (parent === 'father') {
					dailyRate = fatherEaDaily;
				}
			}
			const totalAmount = dailyRate * segment.days;
			return { ...segment, dailyRate, totalAmount } satisfies ComputedSegment;
		})
	);

	const totalEstimatedAmount = $derived(
		computedSegments.reduce((sum, segment) => sum + segment.totalAmount, 0)
	);
	const motherEstimatedAmount = $derived(
		computedSegments
			.filter((segment) => segment.parent === 'mother' || segment.parent === 'third')
			.reduce((sum, segment) => sum + segment.totalAmount, 0)
	);
	const fatherEstimatedAmount = $derived(
		computedSegments
			.filter((segment) => segment.parent === 'father')
			.reduce((sum, segment) => sum + segment.totalAmount, 0)
	);
</script>

{#if visibleSegmentSummaries.length > 0}
	<details class="timeline-summary group" bind:open>
		<summary
			class="timeline-summary__summary"
			aria-label="Überblick zu den Abschnitten ein- und ausklappen"
		>
			<div class="flex items-center gap-3">
				<h3 class="timeline-summary__title m-0">Wie viel ea KBG bekommen wir?</h3>
				<span class="timeline-summary__badge"> Noch in Arbeit, kann Fehler enthalten! </span>
			</div>

			<svg
				class="h-5 w-5 shrink-0 transition-transform duration-200 group-open:rotate-180"
				viewBox="0 0 24 24"
				fill="none"
				aria-hidden="true"
			>
				<path
					d="M6 9l6 6 6-6"
					stroke="currentColor"
					stroke-width="2"
					stroke-linecap="round"
					stroke-linejoin="round"
				/>
			</svg>
		</summary>

		<div class="timeline-summary__panel" aria-live="polite">
			<div class="timeline-summary__birthdate">
				<label class="flex items-center gap-2">
					<span>(Errechneter) Geburtstermin</span>
					<input
						type="date"
						class="timeline-summary__input"
						bind:value={birthDateInput}
						aria-label="(Errechneter) Geburtstermin"
					/>
				</label>
				<p class="mt-2">
					Bitte beachte, dass die obige Auswahl "Mutterschutz 12 Woche - ja / nein" sowie
					"Gemeinsamer Monat" die Berechnung hier beinflusst. Diese Rechnung hier ist nur eine ganz
					grobe Vorschau zur ersten Orientierung. Zudem erhaltet ihr Wochengeld, ggf.
					Familienzeitbonus (Papamonat), Familienbeihilfe. Außerdem gibt es den Partnerschaftsbonus,
					falls ihr die Karenz 50:50 bis 60:40 aufteilt.
				</p>
			</div>

			<section
				aria-labelledby="ea-kbg-parameter-heading"
				class="timeline-summary__calculator"
			>
				<div class="timeline-summary__calculator-head">
					<h4 id="ea-kbg-parameter-heading">Parameter für die Schätzung</h4>
					<p>
						ea KBG entspricht 80&#160;% des durchschnittlichen Tagesnettos, gedeckelt auf den
						offiziellen Tagsatz.
					</p>
				</div>
				<div class="timeline-summary__calculator-grid">
					<label class="timeline-summary__calculator-field">
						<span>Wochengeld Mutter (€/Tag)</span>
						<input
							type="text"
							inputmode="decimal"
							placeholder="z. B. 98,40"
							class="timeline-summary__input"
							bind:value={motherDailyWochengeldInput}
							aria-describedby="ea-kbg-parameter-hint"
						/>
					</label>
					<label class="timeline-summary__calculator-field">
						<span>Bemessungsgrundlage Vater (€/Tag)</span>
						<input
							type="text"
							inputmode="decimal"
							placeholder="z. B. 120"
							class="timeline-summary__input"
							bind:value={fatherDailyBaseInput}
							aria-describedby="ea-kbg-parameter-hint"
						/>
					</label>
					<label class="timeline-summary__calculator-field">
						<span>Max. Tagsatz laut Gesetz (€/Tag)</span>
						<input
							type="text"
							inputmode="decimal"
							placeholder="66,00"
							class="timeline-summary__input"
							bind:value={dailyCapInput}
							aria-describedby="ea-kbg-parameter-hint"
						/>
					</label>
				</div>
				<p id="ea-kbg-parameter-hint" class="timeline-summary__calculator-hint">
					Stand Tagsatz: {formatCurrency(dailyCap)} (Quelle: <a
						href="https://de.wikipedia.org/wiki/Kinderbetreuungsgeld"
						class="timeline-summary__link"
						target="_blank"
						rel="noopener"
					>
						Wikipedia – Kinderbetreuungsgeld</a
					>) – bitte jährlich beim BKA gegenprüfen.
				</p>
				<div class="timeline-summary__calculator-preview" aria-live="polite">
					<p>
						Aktueller Schätztagsatz Mutter: <strong>{formatDailyRate(motherEaDaily)}</strong>
					</p>
					<p>
						Aktueller Schätztagsatz Vater: <strong>{formatDailyRate(fatherEaDaily)}</strong>
					</p>
				</div>
			</section>

			<div class="timeline-summary__table-wrapper">
				<table class="timeline-summary__table">
					<caption class="sr-only"
						>Zusammenfassung der geplanten Abschnitte mit Länge, Zeitraum und Förderung</caption
					>
					<thead>
						<tr>
							<th scope="col">Abschnitt</th>
							<th scope="col">Tage</th>
							<th scope="col">Zeitraum</th>
							<th scope="col">Förderung</th>
							<th scope="col">Gesamt</th>
						</tr>
					</thead>
					<tbody>
						{#each computedSegments as segment (segment.id)}
							<tr>
								<th scope="row">{segment.title}</th>
								<td>{segment.days}</td>
								<td>{formatSegmentRange(segment)}</td>
								<td>{formatDailyRate(segment.dailyRate)}</td>
								<td>{formatCurrency(segment.totalAmount)}</td>
							</tr>
						{/each}
					</tbody>
					<tfoot>
						<tr>
							<th scope="row">Summe (ea KBG, geschätzt)</th>
							<td>—</td>
							<td colspan="2">
								<span role="text">Mutter {formatCurrency(motherEstimatedAmount)} · Vater {formatCurrency(fatherEstimatedAmount)}</span>
							</td>
							<td>{formatCurrency(totalEstimatedAmount)}</td>
						</tr>
					</tfoot>
				</table>
			</div>
			<p class="mt-4 text-center">
				Berechne die genauen Beträge: <a
					class="underline"
					href="https://services.bundeskanzleramt.gv.at/KBG-Rechner/index.html#willkommen"
					>KBG-Rechner auf bundeskanzleramt.gv.at</a
				>
			</p>
		</div>
	</details>
{:else}
	<p class="timeline-summary__empty">Keine Abschnitte für die Übersicht verfügbar.</p>
{/if}

<style lang="scss">
	/* Tell Tailwind to include global utilities */
	@reference "../../app.css";

	:global(details > summary::-webkit-details-marker) {
		display: none;
	}

	:global(details > summary) {
		list-style: none;
	}

	.timeline-summary {
		@apply rounded-xl border border-slate-200/70 bg-white shadow-sm;
	}

	.timeline-summary__summary {
		@apply flex w-full cursor-pointer items-center justify-between gap-3 rounded-xl px-4 py-3 text-slate-800/90 outline-none select-none focus-visible:ring-2 focus-visible:ring-indigo-600/60 focus-visible:ring-offset-2 focus-visible:ring-offset-white md:px-5 md:py-4;
	}
	.timeline-summary__panel {
		@apply px-4 pt-2 pb-4 md:px-5 md:pt-3 md:pb-5;
	}

	.timeline-summary__title {
		@apply text-base font-semibold text-slate-900 sm:text-lg;
	}

	.timeline-summary__badge {
		@apply inline-flex items-center rounded-full bg-amber-100 px-2.5 py-0.5 text-[11px] font-semibold tracking-wide text-amber-700 uppercase;
	}

	.timeline-summary__birthdate {
		@apply mb-3 grid gap-1 text-sm;
	}

	.timeline-summary__birthdate span {
		@apply text-xs font-semibold tracking-wide text-slate-600 uppercase;
	}

	.timeline-summary__calculator {
		@apply mb-4 space-y-4 rounded-lg border border-slate-200/80 bg-slate-50/80 p-4 text-sm;
	}

	.timeline-summary__calculator-head h4 {
		@apply text-sm font-semibold text-slate-900;
	}

	.timeline-summary__calculator-head p {
		@apply mt-1 text-xs text-slate-600;
	}

	.timeline-summary__calculator-grid {
		@apply grid gap-3 md:grid-cols-3;
	}

	.timeline-summary__calculator-field {
		@apply grid gap-1 text-xs font-semibold uppercase tracking-wide text-slate-700;
	}

	.timeline-summary__calculator-hint {
		@apply text-xs text-slate-600;
	}

	.timeline-summary__calculator-preview {
		@apply grid gap-1 text-xs text-slate-700 md:grid-cols-2;
	}

	.timeline-summary__calculator-preview p {
		@apply m-0;
	}

	.timeline-summary__link {
		@apply text-indigo-600 underline decoration-indigo-500/60 underline-offset-2 hover:text-indigo-500;
	}

	.timeline-summary__table-wrapper {
		@apply overflow-x-auto;
	}

	.timeline-summary__table {
		@apply min-w-full border-collapse;
	}

	.timeline-summary__table thead th {
		@apply border-b border-slate-200 bg-slate-50 px-3 py-2 text-left text-xs font-semibold tracking-wide text-slate-700 uppercase;
	}

	.timeline-summary__table tbody td {
		@apply px-3 py-2 align-middle text-sm text-slate-800;
	}

	.timeline-summary__table tbody th[scope='row'] {
		@apply px-3 py-2 text-sm font-semibold text-slate-900;
	}

	.timeline-summary__input {
		@apply w-full rounded-md border border-slate-300 bg-white px-2 py-1 text-sm text-slate-800 shadow-sm focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-500 disabled:cursor-not-allowed disabled:bg-slate-100 disabled:text-slate-500;
	}

	.timeline-summary__empty {
		@apply mt-4 text-sm font-medium text-slate-600;
	}
</style>
