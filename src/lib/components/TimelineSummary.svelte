<script lang="ts">
	export type Segment = {
		id: string;
		title: string;
		days: number;
		summaryKey?: string;
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
		segmentSummaries.filter((segment) =>
			segment.summaryKey !== undefined && SUMMARY_WHITELIST.has(segment.summaryKey)
		)
	);
</script>

{#if visibleSegmentSummaries.length > 0}
	<details class="timeline-summary group" bind:open>
		<summary
			class="timeline-summary__summary"
			aria-label="Überblick zu den Abschnitten ein- und ausklappen"
		>
			<div class="flex items-center gap-3">
				<h3 class="timeline-summary__title m-0">Überblick zu den Abschnitten</h3>
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
			</div>

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
						{#each visibleSegmentSummaries as segment (segment.id)}
							<tr>
								<th scope="row">{segment.title}</th>
								<td>{segment.days}</td>
								<td>{formatSegmentRange(segment)}</td>
								<td>
									<input
										type="text"
										class="timeline-summary__input"
										aria-label={`Förderung für ${segment.title}`}
										disabled
									/>
								</td>
								<td>
									<input
										type="text"
										class="timeline-summary__input"
										aria-label={`Gesamt für ${segment.title}`}
										disabled
									/>
								</td>
							</tr>
						{/each}
					</tbody>
				</table>
			</div>
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
