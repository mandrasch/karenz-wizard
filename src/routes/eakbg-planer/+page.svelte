<script lang="ts">
	type Interval = {
		label: string;
		start: number;
		end: number;
		pausedUntil?: number;
		displayDuration?: string;
		lineEnd?: number;
		overlayStart?: number;
		overlayEnd?: number;
		overlayVariant?: 'paid' | 'unpaid' | 'papamonat';
		isInactive?: boolean;
		isUnpaid?: boolean;
		forcePaidStartMarker?: boolean;
		hideStartMarker?: boolean;
		hideEndMarker?: boolean;
		isEaBase?: boolean;
		rowGroup?: string;
		lineClass?: string;
		labelPosition?: 'above' | 'below';
		hideDurationLabel?: boolean;
	};

	const BASE_TOTAL_WEEKS = 104; // 2 years expressed in weeks
	const BASELINE_WIDTH = 640;
	const margins = { top: 32, right: 48, bottom: 32, left: 96 };
	const rowHeight = 60;
	const BASELINE_ROW_INDEX = 1;
	const MID_YEAR_WEEKS = BASE_TOTAL_WEEKS / 2;

	const WEEKS_PER_MONTH = 4.345; // approx. average weeks per month
	const DEFAULT_MUTTERSCHUTZ_WEEKS = 8;
	const MUTTERSCHUTZ_PRE_WEEKS = 8;
	const EXTENDED_MUTTERSCHUTZ_WEEKS = 12;
	const PAPAMONAT_OFFSET_DAYS = 3;
	const EA_KBG_MONTHS = 14;
	const MAX_TOTAL_MONTHS = 24;
	const MIN_MOTHER_MONTHS = 2;
	const MAX_MOTHER_MONTHS = 24;
	const MIN_FATHER_MONTHS = 2;
	const MAX_FATHER_MONTHS = 24;
	const MIN_THIRD_MONTHS = 0;
	const MAX_THIRD_MONTHS = 24;

	const monthsToWeeks = (months: number) => months * WEEKS_PER_MONTH;
	const clamp = (value: number, min: number, max: number) => Math.min(Math.max(value, min), max);
	const rowY = (rowIndex: number) => margins.top + rowIndex * rowHeight;

	let motherMonths = $state(10);
	let fatherMonths = $state(8);
	let thirdMonths = $state(0);
	let jointMonth = $state(false);
	let extendedMutterschutz = $state(false);
	let previousJointMonth = $state(jointMonth);
	let motherJointCompensation = $state(0);

	const motherMin = $derived(jointMonth ? Math.max(0, MIN_MOTHER_MONTHS - 1) : MIN_MOTHER_MONTHS);
	const motherMax = $derived(
		Math.max(motherMin, jointMonth ? MAX_MOTHER_MONTHS - 1 : MAX_MOTHER_MONTHS)
	);

	const adjustMotherMonths = (delta: number) => {
		motherMonths = clamp(motherMonths + delta, motherMin, motherMax);
	};

	const adjustFatherMonths = (delta: number) => {
		fatherMonths = clamp(fatherMonths + delta, MIN_FATHER_MONTHS, MAX_FATHER_MONTHS);
	};

	const adjustThirdMonths = (delta: number) => {
		thirdMonths = clamp(thirdMonths + delta, MIN_THIRD_MONTHS, MAX_THIRD_MONTHS);
	};

	const applyExample = (motherPreset: number, fatherPreset: number) => {
		motherMonths = clamp(motherPreset, motherMin, motherMax);
		fatherMonths = clamp(fatherPreset, MIN_FATHER_MONTHS, MAX_FATHER_MONTHS);
	};

	const formatWeeks = (value: number) => `${value.toFixed(0)} Wochen`;

	$effect(() => {
		motherMonths = clamp(motherMonths, motherMin, motherMax);
	});

	$effect(() => {
		if (jointMonth !== previousJointMonth) {
			if (jointMonth) {
				const adjusted = Math.max(motherMin, motherMonths - 1);
				motherJointCompensation = motherMonths - adjusted;
				motherMonths = adjusted;
			} else {
				motherMonths = clamp(motherMonths + motherJointCompensation, motherMin, motherMax);
				motherJointCompensation = 0;
			}
			previousJointMonth = jointMonth;
		}
	});

	$effect(() => {
		fatherMonths = clamp(fatherMonths, MIN_FATHER_MONTHS, MAX_FATHER_MONTHS);
	});

	$effect(() => {
		thirdMonths = clamp(thirdMonths, MIN_THIRD_MONTHS, MAX_THIRD_MONTHS);
	});

	$effect(() => {
		const mutterschutzWeeksActive = extendedMutterschutz
			? EXTENDED_MUTTERSCHUTZ_WEEKS
			: DEFAULT_MUTTERSCHUTZ_WEEKS;
		const mutterschutzMonthsCurrent = mutterschutzWeeksActive / WEEKS_PER_MONTH;
		const totalMonthsCap = Math.max(0, MAX_TOTAL_MONTHS - mutterschutzMonthsCurrent);

		const maxMotherAllowed = Math.max(motherMin, totalMonthsCap - MIN_FATHER_MONTHS);
		if (motherMonths > maxMotherAllowed) {
			motherMonths = Math.min(maxMotherAllowed, motherMax);
		}

		const maxFatherAllowed = Math.max(MIN_FATHER_MONTHS, totalMonthsCap - motherMonths);
		const fatherUpperBound = Math.max(
			MIN_FATHER_MONTHS,
			Math.min(MAX_FATHER_MONTHS, maxFatherAllowed)
		);
		fatherMonths = clamp(fatherMonths, MIN_FATHER_MONTHS, fatherUpperBound);

		const totalWithoutThird = motherMonths + fatherMonths;
		const allowedThird = Math.max(0, totalMonthsCap - totalWithoutThird);
		thirdMonths = clamp(thirdMonths, 0, allowedThird);
	});

	const mutterschutzWeeks = $derived(
		extendedMutterschutz ? EXTENDED_MUTTERSCHUTZ_WEEKS : DEFAULT_MUTTERSCHUTZ_WEEKS
	);
	const motherTotalMonths = $derived(motherMonths + (jointMonth ? 1 : 0));
	const motherWeeks = $derived(mutterschutzWeeks + monthsToWeeks(motherTotalMonths));
	const fatherWeeks = $derived(monthsToWeeks(fatherMonths));
	const fatherStart = $derived(
		Math.max(
			mutterschutzWeeks,
			jointMonth ? mutterschutzWeeks + monthsToWeeks(motherMonths) : motherWeeks
		)
	);
	const fatherEnd = $derived(fatherStart + fatherWeeks);

	const thirdWeeks = $derived(monthsToWeeks(thirdMonths));
	const thirdStart = $derived(fatherEnd);
	const thirdEnd = $derived(thirdStart + thirdWeeks);

	const motherWorkStart = $derived(motherWeeks);
	const motherWorkEnd = $derived(
		Math.max(motherWorkStart, thirdMonths > 0 ? thirdStart : BASE_TOTAL_WEEKS)
	);
	const motherWorkGapWeeks = $derived(Math.max(0, motherWorkEnd - motherWorkStart));
	const hasMotherWorkGap = $derived(motherWorkGapWeeks > 0.01);

	const papamonatStart = PAPAMONAT_OFFSET_DAYS / 7;
	const papamonatOverlayEnd = $derived(papamonatStart + monthsToWeeks(1));
	const papamonatEnd = $derived(Math.min(papamonatOverlayEnd, mutterschutzWeeks));
	const fatherWorkStart = $derived(papamonatEnd);
	const fatherWorkEnd = $derived(Math.max(fatherWorkStart, fatherStart));
	const fatherWorkGapWeeks = $derived(Math.max(0, fatherWorkEnd - fatherWorkStart));
	const hasFatherWorkGap = $derived(fatherWorkGapWeeks > 0.01);
	const fatherPostWorkStart = $derived(fatherEnd);
	const fatherPostWorkEnd = $derived(Math.max(fatherPostWorkStart, BASE_TOTAL_WEEKS));
	const hasFatherPostWork = $derived(fatherPostWorkEnd - fatherPostWorkStart > 0.01);

	const eaKbgMonths = $derived(jointMonth ? EA_KBG_MONTHS - 1 : EA_KBG_MONTHS);
	const eaKbgWeeks = $derived(monthsToWeeks(eaKbgMonths));

	let motherCoverageDemandValue = $state(0);
	let motherPaidMonths = $state(0);
	let fatherPaidMonths = $state(0);
	let thirdPaidMonths = $state(0);
	let coverageAfterMother = $state(0);
	let fatherCoverageWindowMonths = $state(0);
	let fatherWindowAllowsMinimum = $state(true);
	let fatherEaEligible = $state(true);
	let fatherEligibleMonthsValue = $state(0);
	let fatherEaBlocked = $state(false);
	let thirdCoverageWindowMonths = $state(0);
	let thirdWindowAllowsMinimum = $state(true);
	let thirdEaEligible = $state(true);
	let thirdEligibleMonthsValue = $state(0);

	$effect(() => {
		const overlapAdjustment = jointMonth ? 1 : 0;
		const mutterschutzWeeksCurrent = extendedMutterschutz
			? EXTENDED_MUTTERSCHUTZ_WEEKS
			: DEFAULT_MUTTERSCHUTZ_WEEKS;
		const mutterschutzMonths = mutterschutzWeeksCurrent / WEEKS_PER_MONTH;

		const motherCoverageDemand = Math.max(0, motherMonths - overlapAdjustment);
		motherCoverageDemandValue = motherCoverageDemand;

		let remainingCoverage = Math.max(0, eaKbgMonths - mutterschutzMonths);
		const minimumReservedForFather = Math.min(MIN_FATHER_MONTHS, fatherMonths);
		const maxMotherPaidCoverage = Math.max(0, remainingCoverage - minimumReservedForFather);
		const motherCoverageWindowMonths = Math.max(
			0,
			(eaKbgWeeks - mutterschutzWeeks) / WEEKS_PER_MONTH
		);

		motherPaidMonths = Math.min(
			motherMonths,
			maxMotherPaidCoverage,
			12,
			motherCoverageWindowMonths
		);

		remainingCoverage = Math.max(0, remainingCoverage - motherPaidMonths);
		coverageAfterMother = remainingCoverage;

		if (remainingCoverage <= 0) {
			fatherPaidMonths = 0;
			thirdPaidMonths = 0;
		} else {
			fatherCoverageWindowMonths = Math.max(0, (eaKbgWeeks - fatherStart) / WEEKS_PER_MONTH);
			fatherWindowAllowsMinimum =
				fatherStart + MIN_FATHER_MONTHS * WEEKS_PER_MONTH <= eaKbgWeeks + 1e-9;
			fatherEaEligible = fatherWindowAllowsMinimum;

			if (!fatherWindowAllowsMinimum) {
				fatherPaidMonths = 0;
				fatherEligibleMonthsValue = 0;
			} else {
				fatherEligibleMonthsValue = Math.min(fatherMonths, fatherCoverageWindowMonths);
				fatherPaidMonths = Math.min(fatherEligibleMonthsValue, remainingCoverage);
			}

			fatherEaBlocked = fatherMonths > 0 && !fatherWindowAllowsMinimum;
			remainingCoverage = Math.max(0, remainingCoverage - fatherPaidMonths);

			thirdCoverageWindowMonths = Math.max(0, (eaKbgWeeks - thirdStart) / WEEKS_PER_MONTH);
			thirdWindowAllowsMinimum =
				thirdStart + MIN_THIRD_MONTHS * WEEKS_PER_MONTH <= eaKbgWeeks + 1e-9;
			thirdEaEligible = thirdWindowAllowsMinimum;

			if (!thirdWindowAllowsMinimum) {
				thirdPaidMonths = 0;
				thirdEligibleMonthsValue = 0;
			} else {
				thirdEligibleMonthsValue = Math.min(thirdMonths, thirdCoverageWindowMonths);
				thirdPaidMonths = Math.min(thirdEligibleMonthsValue, remainingCoverage);
			}
		}
	});

	const motherUnpaidMonths = $derived(Math.max(0, motherMonths - motherPaidMonths));
	const fatherUnpaidMonths = $derived(Math.max(0, fatherMonths - fatherPaidMonths));
	const thirdUnpaidMonths = $derived(Math.max(0, thirdMonths - thirdPaidMonths));

	const motherPaidWeeks = $derived(monthsToWeeks(motherPaidMonths));
	const motherUnpaidWeeks = $derived(monthsToWeeks(motherUnpaidMonths));
	const motherUnpaidStart = $derived(mutterschutzWeeks + motherPaidWeeks);

	const paidFatherWeeks = $derived(monthsToWeeks(fatherPaidMonths));
	const fatherPaidEnd = $derived(fatherStart + paidFatherWeeks);

	const paidThirdWeeks = $derived(monthsToWeeks(thirdPaidMonths));
	const thirdPaidEnd = $derived(thirdStart + paidThirdWeeks);

	const totalParentalMonths = $derived(
		motherMonths + fatherMonths + thirdMonths - (jointMonth ? 1 : 0)
	);
	const exceedsEaKbg = $derived(totalParentalMonths > eaKbgMonths);

	const motherDisplay = $derived(
		motherUnpaidMonths > 0
			? `${motherMonths.toFixed(0)} Monate; ${motherPaidMonths.toFixed(0)} bezahlt, ${motherUnpaidMonths.toFixed(0)} unbezahlte)`
			: `${motherMonths.toFixed(0)} Monate`
	);

	const motherLabel = $derived(
		motherUnpaidMonths > 0
			? 'Karenz Mutter: ea KBG 💰 + unbezahlte Karenz'
			: 'Karenz Mutter: ea KBG 💰'
	);

	const motherConsumesAllEa = $derived(coverageAfterMother <= 0);

	const fatherLabel = $derived(
		fatherUnpaidMonths > 0
			? fatherPaidMonths > 0 && !motherConsumesAllEa
				? 'Karenz Vater: ea KBG 💰 + unbezahlte Karenz'
				: 'Karenz Vater: unbezahlte Karenz'
			: 'Karenz Vater'
	);

	const fatherDisplay = $derived(
		fatherUnpaidMonths > 0
			? `${fatherMonths.toFixed(0)} Monate (${fatherPaidMonths.toFixed(0)} bezahlt, ${fatherUnpaidMonths.toFixed(0)} unbezahlte)`
			: `${fatherMonths.toFixed(0)} Monate`
	);

	const thirdLabel = $derived(
		thirdMonths > 0
			? thirdUnpaidMonths > 0
				? 'Unbezahlte Karenz (weiterer Teil)'
				: 'Karenz weiterer Teil'
			: ''
	);
	const thirdDisplay = $derived(
		thirdMonths > 0
			? thirdUnpaidMonths > 0
				? `${thirdMonths.toFixed(0)} Monate (${thirdPaidMonths.toFixed(0)} bezahlt, ${thirdUnpaidMonths.toFixed(0)} unbezahlte)`
				: `${thirdMonths.toFixed(0)} Monate`
			: ''
	);

	const eaLabel = 'Anspruch einkommensabh. Kinderbetreuungsgeld';
	const eaDisplay = $derived(
		jointMonth
			? `max. t13 Monate ab Geburt (11 + min. 2 Vater) wg. gemeinsamer Monat - ab Ende Mutterschutz`
			: `max. 14 Monate ab Geburt (12 +  min. 2 Vater) - ab Ende Mutterschutz`
	);

	const baseIntervals = $derived<Interval[]>(
		(() => {
			const intervals: Interval[] = [
				{
					label: 'Mutterschutz vor Geburt',
					start: -MUTTERSCHUTZ_PRE_WEEKS,
					end: 0,
					displayDuration: `${formatWeeks(MUTTERSCHUTZ_PRE_WEEKS)}, Wochengeld ÖGK 💰`,
					isInactive: true
				},
				{
					label: extendedMutterschutz ? 'Mutterschutz n. G.' : 'Mutterschutz n. G.',
					start: 0,
					end: mutterschutzWeeks,
					displayDuration: `${formatWeeks(mutterschutzWeeks)}, Wochengeld ÖGK 💰`,
					isInactive: true
				},
				{
					label: eaLabel,
					start: 0,
					end: eaKbgWeeks,
					displayDuration: eaDisplay,
					isInactive: true
				},
				{
					label: motherLabel,
					start: mutterschutzWeeks,
					end: motherWeeks,
					displayDuration: motherDisplay,
					overlayVariant: 'unpaid',
					overlayStart: motherUnpaidMonths > 0 ? motherUnpaidStart : undefined,
					overlayEnd: motherUnpaidMonths > 0 ? motherWeeks : undefined,
					forcePaidStartMarker: true,
					isEaBase: true,
					rowGroup: 'mother'
				}
			];

			if (hasMotherWorkGap) {
				intervals.push({
					label: 'Mutter arbeitet',
					start: motherWorkStart,
					end: motherWorkEnd,
					isInactive: true,
					hideStartMarker: true,
					hideEndMarker: true,
					hideDurationLabel: true,
					labelPosition: 'below',
					lineClass: 'working',
					rowGroup: 'mother'
				});
			}

			intervals.push({
				label: 'Papamonat',
				start: papamonatStart,
				end: papamonatEnd,
				displayDuration: 'ggf. Famililienzeitbonus 💰',
				isInactive: true,
				overlayStart: papamonatStart,
				overlayVariant: 'papamonat',
				overlayEnd: papamonatEnd,
				rowGroup: 'father'
			});

			if (hasFatherWorkGap) {
				intervals.push({
					label: 'Vater arbeitet',
					start: fatherWorkStart,
					end: fatherWorkEnd,
					isInactive: true,
					hideStartMarker: true,
					hideEndMarker: true,
					hideDurationLabel: true,
					labelPosition: 'below',
					lineClass: 'working',
					rowGroup: 'father'
				});
			}

			intervals.push({
				label: fatherLabel,
				start: fatherStart,
				end: fatherEnd,
				displayDuration: fatherDisplay,
				isUnpaid: fatherUnpaidMonths > 0,
				overlayVariant: fatherPaidMonths > 0 ? 'paid' : 'unpaid',
				overlayStart: fatherUnpaidMonths > 0 && fatherPaidMonths > 0 ? fatherStart : undefined,
				overlayEnd:
					fatherUnpaidMonths > 0 && fatherPaidMonths > 0
						? Math.min(fatherPaidEnd, fatherEnd)
						: undefined,
				forcePaidStartMarker: fatherUnpaidMonths > 0,
				isEaBase: fatherUnpaidMonths === 0 && fatherPaidMonths > 0,
				rowGroup: 'father'
			});

			if (hasFatherPostWork) {
				intervals.push({
					label: 'Vater arbeitet',
					start: fatherPostWorkStart,
					end: fatherPostWorkEnd,
					isInactive: true,
					hideStartMarker: true,
					hideEndMarker: true,
					hideDurationLabel: true,
					labelPosition: 'below',
					lineClass: 'working',
					rowGroup: 'father'
				});
			}

			return intervals;
		})()
	);

	const intervals = $derived<Interval[]>(
		(() => {
			if (thirdMonths > 0) {
				return [
					...baseIntervals,
					{
						label: thirdLabel,
						start: thirdStart,
						end: thirdEnd,
						displayDuration: thirdDisplay,
						isUnpaid: thirdUnpaidMonths > 0,
						overlayVariant: thirdPaidMonths > 0 ? 'paid' : 'unpaid',
						overlayStart: thirdUnpaidMonths > 0 && thirdPaidMonths > 0 ? thirdStart : undefined,
						overlayEnd:
							thirdUnpaidMonths > 0 && thirdPaidMonths > 0
								? Math.min(thirdPaidEnd, thirdEnd)
								: undefined,
						isEaBase: thirdUnpaidMonths === 0 && thirdPaidMonths > 0,
						rowGroup: 'mother'
					} satisfies Interval
				];
			}

			return baseIntervals;
		})()
	);

	const intervalRowIndices = $derived<number[]>(
		(() => {
			const assignments = new Map<string, number>();
			let nextRowIndex = BASELINE_ROW_INDEX + 1;
			return intervals.map((interval, index) => {
				if (interval.start < 0) {
					return index;
				}
				const key = interval.rowGroup ?? `${index}-${interval.label}`;
				if (assignments.has(key)) {
					return assignments.get(key)!;
				}
				const rowIndex = nextRowIndex++;
				assignments.set(key, rowIndex);
				return rowIndex;
			});
		})()
	);

	const eaRowIndex = $derived(intervals.findIndex((interval) => interval.label === eaLabel));
	const maxIntervalRowIndex = $derived(
		intervalRowIndices.length > 0 ? Math.max(...intervalRowIndices) : 0
	);
	const effectiveEaRowIndex = $derived(
		eaRowIndex >= 0 ? intervalRowIndices[eaRowIndex] : BASELINE_ROW_INDEX
	);
	const maxRowIndex = $derived(Math.max(maxIntervalRowIndex, BASELINE_ROW_INDEX));
	const eaMarkerStartY = $derived(rowY(effectiveEaRowIndex) - rowHeight / 2);
	const eaMarkerEndY = $derived(rowY(maxRowIndex) + rowHeight / 2);

	const timelineWeeks = $derived(
		Math.max(BASE_TOTAL_WEEKS, ...intervals.map((interval) => interval.lineEnd ?? interval.end))
	);
	const scale = $derived(BASELINE_WIDTH / timelineWeeks);
	const MIN_ZOOM = 0.75;
	const MAX_ZOOM = 1.75;
	const ZOOM_STEP = 0.25;
	let zoomLevel = $state(1);
	const baseSvgWidth = BASELINE_WIDTH + margins.left + margins.right;
	const baseSvgHeight = $derived(margins.top + margins.bottom + rowHeight * (maxRowIndex + 1));
	const viewportHeight = $derived(Math.ceil(baseSvgHeight));
	const svgWidth = $derived(baseSvgWidth * zoomLevel);
	const svgHeight = $derived(baseSvgHeight * zoomLevel);
	const svgViewBox = $derived(`0 0 ${baseSvgWidth} ${baseSvgHeight}`);
	const canZoomOut = $derived(zoomLevel > MIN_ZOOM + 1e-3);
	const canZoomIn = $derived(zoomLevel < MAX_ZOOM - 1e-3);
	const zoomPercent = $derived(Math.round(zoomLevel * 100));

	const zoomIn = () => {
		zoomLevel = Math.min(MAX_ZOOM, Number((zoomLevel + ZOOM_STEP).toFixed(2)));
	};

	const zoomOut = () => {
		zoomLevel = Math.max(MIN_ZOOM, Number((zoomLevel - ZOOM_STEP).toFixed(2)));
	};

	const resetZoom = () => {
		zoomLevel = 1;
	};

	const baselineTicks = $derived(
		(() => {
			const ticks: number[] = [];
			for (let tick = WEEKS_PER_MONTH; tick < timelineWeeks; tick += WEEKS_PER_MONTH) {
				ticks.push(tick);
			}
			return ticks;
		})()
	);

	const toX = (weeks: number) => margins.left + weeks * scale;
</script>

<div class="layout">
	<div class="page-header mt-10">
		<h2 class="text-2xl font-semibold text-slate-900">
			Planer für einkommensabhängiges Kinderbetreuungsgeld (ea KBG)
		</h2>
		<p class="subline">
			Eine kleine Planungshilfe fuer das einkommensabhängige Kinderbetreuungsgeld und die Aufteilung
			der Karenz.
		</p>
		<aside class="infobox">
			Prüfen, ob du oder dein/e Partner/in Anspruch hat auf ea KBG? Wenn nur eine Person Anspruch
			hat, kann das andere Elternteil Sonderleistung 1 beziehen. Achtung bei AMS-Zeiten vor
			Geburt/Mutterschutz! <a href="/eakbg-anspruch" class="link underline">Hier Prüfen</a>. ⚠️ Alle
			Angaben ohne Gewähr, bitte alle Planungen bei der
			<a href="/ak-beratung" class="underline">Arbeiterkammer kostenfrei überprüfen lassen</a>!
		</aside>
	</div>

	<section aria-labelledby="planner-title" class="timeline-section">
		<div class="planner-controls flex flex-row flex-wrap">
			<div class="example-presets">
				<span>Beispiele:</span>
				<button type="button" on:click={() => applyExample(10, 2)} class="example-link"
					>10 + 2</button
				>
				<button type="button" on:click={() => applyExample(10, 10)} class="example-link"
					>10 + 10 (Halbe Halbe)</button
				>
				<button type="button" on:click={() => applyExample(6, 6)} class="example-link">6 + 6</button
				>
			</div>
			<div class="flex flex-row self-start">
				<div class="control-group">
					<label for="mother-months">Karenz-Teil 1: Mutter</label>
					<div class="stepper">
						<button
							type="button"
							on:click={() => adjustMotherMonths(-1)}
							aria-label="Monat verringern"
						>
							-
						</button>
						<input
							id="mother-months"
							type="number"
							min={MIN_MOTHER_MONTHS}
							max={MAX_MOTHER_MONTHS}
							bind:value={motherMonths}
						/>
						<button
							type="button"
							on:click={() => adjustMotherMonths(1)}
							aria-label="Monat erhoehen"
						>
							+
						</button>
					</div>
				</div>
				<div class="control-group">
					<label for="father-months">Karenz-Teil 2: Vater</label>
					<div class="stepper">
						<button
							type="button"
							on:click={() => adjustFatherMonths(-1)}
							aria-label="Monat verringern"
						>
							-
						</button>
						<input
							id="father-months"
							type="number"
							min={MIN_FATHER_MONTHS}
							max={MAX_FATHER_MONTHS}
							bind:value={fatherMonths}
						/>
						<button
							type="button"
							on:click={() => adjustFatherMonths(1)}
							aria-label="Monat erhoehen"
						>
							+
						</button>
					</div>
				</div>
				<div class="control-group">
					<label for="third-months">(Karenz-Teil 3: Mutter)</label>
					<div class="stepper">
						<button
							type="button"
							on:click={() => adjustThirdMonths(-1)}
							aria-label="Monat verringern"
						>
							-
						</button>
						<input
							id="third-months"
							type="number"
							min={MIN_THIRD_MONTHS}
							max={MAX_THIRD_MONTHS}
							bind:value={thirdMonths}
						/>
						<button type="button" on:click={() => adjustThirdMonths(1)} aria-label="Monat erhoehen">
							+
						</button>
					</div>
				</div>
			</div>
			<div class="flex flex-col gap-5 self-start">
				<label class="control-checkbox">
					<input type="checkbox" bind:checked={extendedMutterschutz} />
					<span
						>Mutterschutz 12 Wochen (statt 8 Wochen) <br />(Früh-/Mehrlings-Geburt, Kaiserschnitt)</span
					>
				</label>
				<label class="control-checkbox">
					<input type="checkbox" bind:checked={jointMonth} />
					<span>Gemeinsamer Monat beim ersten Wechsel</span>
					{#if jointMonth}
						<small>ea KBG wird um 1 Monat kuerzer</small>
					{/if}
				</label>
			</div>
		</div>

		{#if fatherEaBlocked}
			<div class="warning-banner" role="alert">
				⚠️ Die Mutter nutzt den gesamten Anspruch auf einkommensabhängiges Kinderbetreuungsgeld. Der
				Vater kann daher keinen ea KBG-Bezug mehr geltend machen, weil er mindestens 2 Monate im
				Zeitraum der 14 Monate ab Geburt nehmen muss (12+2 Modell).
			</div>
		{/if}

		<div class="timeline-shell">
			<div class="timeline-zoom-controls" role="group" aria-label="Zoom-Steuerung">
				<button
					type="button"
					class="zoom-button"
					on:click={zoomOut}
					disabled={!canZoomOut}
					aria-label="Ansicht verkleinern"
				>
					-
				</button>
				<button
					type="button"
					class="zoom-button"
					on:click={zoomIn}
					disabled={!canZoomIn}
					aria-label="Ansicht vergrößern"
				>
					+
				</button>
				<button type="button" class="zoom-reset" on:click={resetZoom} disabled={zoomLevel === 1}>
					Reset
				</button>
				<span class="zoom-status" aria-live="polite">{zoomPercent}%</span>
			</div>
			<div
				class="timeline-window max-w-full"
				role="region"
				aria-labelledby="planner-title"
				style={`max-height: ${viewportHeight}px; min-height: ${viewportHeight}px;`}
			>
				<svg
					width={svgWidth}
					height={svgHeight}
					viewBox={svgViewBox}
					role="img"
					aria-labelledby="planner-title"
				>
					<title>Zeitstrahl mit Basis von zwei Jahren und zusaetzlichen Phasen</title>

					<g class="baseline" aria-hidden="true">
						<circle class="marker marker-birth" cx={toX(0)} cy={rowY(BASELINE_ROW_INDEX)} r="6" />
						<line
							class="timeline-track"
							x1={toX(0)}
							y1={rowY(BASELINE_ROW_INDEX)}
							x2={toX(timelineWeeks)}
							y2={rowY(BASELINE_ROW_INDEX)}
						/>
						{#each baselineTicks as tickWeeks}
							<line
								class="baseline-month-tick"
								x1={toX(tickWeeks)}
								y1={rowY(BASELINE_ROW_INDEX) - 10}
								x2={toX(tickWeeks)}
								y2={rowY(BASELINE_ROW_INDEX) + 10}
							/>
						{/each}
						<circle
							class="marker marker-midyear"
							cx={toX(MID_YEAR_WEEKS)}
							cy={rowY(BASELINE_ROW_INDEX)}
							r="5"
						/>
						<circle
							class="marker marker-baseline-end"
							cx={toX(timelineWeeks)}
							cy={rowY(BASELINE_ROW_INDEX)}
							r="6"
						/>
						<text
							class="label label-dot-end"
							x={toX(timelineWeeks)}
							y={rowY(BASELINE_ROW_INDEX) - 22}
							text-anchor="middle"
						>
							2. Lebensjahr
						</text>
						<text
							class="label label-dot-mid"
							x={toX(MID_YEAR_WEEKS)}
							y={rowY(BASELINE_ROW_INDEX) - 22}
							text-anchor="middle"
						>
							1. Lebensjahr
						</text>
						<text
							class="label label-end"
							x={(toX(0) + toX(timelineWeeks)) / 2}
							y={rowY(BASELINE_ROW_INDEX) + 26}
							text-anchor="middle"
						>
							Bis zum 2. Lebensjahr Recht auf Karenz (Freistellung), Arbeitgeber muss es erlauben
						</text>
						<text
							class="label label-start"
							x={toX(0)}
							y={rowY(BASELINE_ROW_INDEX) - 18}
							text-anchor="middle"
						>
							Geburt
						</text>
					</g>

					<line
						class="ea-marker-line"
						x1={toX(0)}
						y1={rowY(BASELINE_ROW_INDEX)}
						x2={toX(0)}
						y2={eaMarkerEndY}
					/>

					<line
						class="ea-marker-line"
						x1={toX(eaKbgWeeks)}
						y1={eaMarkerStartY}
						x2={toX(eaKbgWeeks)}
						y2={eaMarkerEndY}
					/>

					{#each intervals as interval, index (interval.label + '-' + interval.start + '-' + interval.end)}
						{@const rowIndex = intervalRowIndices[index] ?? index}
						{@const hasPausedSegment =
							interval.pausedUntil !== undefined && interval.pausedUntil > interval.start}
						{@const lineEnd = interval.lineEnd ?? interval.end}
						{@const hasOverlay =
							interval.overlayEnd !== undefined &&
							interval.overlayStart !== undefined &&
							interval.overlayEnd > interval.overlayStart}
						{@const overlayVariant = interval.overlayVariant ?? 'paid'}
						{@const overlayStartsAtLineStart =
							hasOverlay && interval.overlayStart === interval.start}
						{@const forcePaidStart = interval.forcePaidStartMarker === true}
						{@const activeLineClass = interval.isInactive
							? 'inactive'
							: interval.isEaBase
								? 'ea'
								: interval.isUnpaid
									? 'unpaid'
									: 'active'}
						{@const customLineClass = interval.lineClass ? ` ${interval.lineClass}` : ''}
						{@const startMarkerClass = overlayStartsAtLineStart
							? `marker-overlay-start overlay-${overlayVariant}`
							: forcePaidStart
								? 'marker-overlay-start overlay-paid'
								: interval.isInactive
									? 'marker-inactive'
									: interval.isUnpaid
										? 'marker-unpaid'
										: interval.isEaBase
											? 'marker-ea'
											: 'marker-start'}
						{@const endMarkerClass =
							hasOverlay && interval.overlayVariant === 'unpaid' && interval.overlayEnd === lineEnd
								? 'marker-unpaid'
								: interval.isInactive
									? 'marker-inactive'
									: interval.isUnpaid
										? 'marker-unpaid'
										: interval.isEaBase
											? 'marker-ea'
											: 'marker-end'}
						<g
							class="interval"
							aria-label={`${interval.label}: ${interval.displayDuration ?? formatWeeks(interval.end - interval.start)}`}
						>
							{#if hasPausedSegment}
								{@const pausedUntil = interval.pausedUntil ?? interval.start}
								<line
									class="interval-line paused"
									x1={toX(interval.start)}
									y1={rowY(rowIndex)}
									x2={toX(pausedUntil)}
									y2={rowY(rowIndex)}
								/>
								<line
									class={`interval-line ${activeLineClass}${customLineClass}`}
									x1={toX(pausedUntil)}
									y1={rowY(rowIndex)}
									x2={toX(lineEnd)}
									y2={rowY(rowIndex)}
								/>
							{:else}
								<line
									class={`interval-line ${activeLineClass}${customLineClass}`}
									x1={toX(interval.start)}
									y1={rowY(rowIndex)}
									x2={toX(lineEnd)}
									y2={rowY(rowIndex)}
								/>
							{/if}

							{#if hasOverlay}
								{@const overlayStart = interval.overlayStart ?? interval.start}
								{@const overlayEnd = Math.min(interval.overlayEnd ?? lineEnd, lineEnd)}
								{@const renderOverlayStart = overlayStart > interval.start}
								{#if renderOverlayStart}
									<circle
										class={`marker marker-overlay-start overlay-${overlayVariant}`}
										cx={toX(overlayStart)}
										cy={rowY(rowIndex)}
										r="4"
									/>
								{/if}
								<line
									class={`interval-line overlay overlay-${overlayVariant}`}
									x1={toX(overlayStart)}
									y1={rowY(rowIndex)}
									x2={toX(overlayEnd)}
									y2={rowY(rowIndex)}
								/>
								<circle
									class={`marker marker-overlay-end overlay-${overlayVariant}`}
									cx={toX(overlayEnd)}
									cy={rowY(rowIndex)}
									r="4"
								/>
							{/if}

							{#if !interval.hideStartMarker}
								<circle
									class={`marker ${startMarkerClass}`}
									cx={toX(interval.start)}
									cy={rowY(rowIndex)}
									r="5"
								/>
							{/if}

							{#if hasPausedSegment}
								{@const pausedUntil = interval.pausedUntil ?? interval.start}
								<circle
									class="marker marker-resume"
									cx={toX(pausedUntil)}
									cy={rowY(rowIndex)}
									r="4"
								/>
							{/if}

							{#if !interval.hideEndMarker}
								<circle
									class={`marker ${endMarkerClass}`}
									cx={toX(lineEnd)}
									cy={rowY(rowIndex)}
									r="5"
								/>
							{/if}
							<text
								class="label interval-label"
								x={(toX(interval.start) + toX(lineEnd)) / 2}
								y={interval.labelPosition === 'below' ? rowY(rowIndex) + 18 : rowY(rowIndex) - 12}
								text-anchor="middle"
							>
								{interval.label}
							</text>
							{#if !interval.hideDurationLabel}
								<text
									class="label interval-duration"
									x={(toX(interval.start) + toX(lineEnd)) / 2}
									y={interval.labelPosition === 'below' ? rowY(rowIndex) + 36 : rowY(rowIndex) + 18}
									text-anchor="middle"
								>
									{interval.displayDuration ?? formatWeeks(interval.end - interval.start)}
								</text>
							{/if}
						</g>
					{/each}
				</svg>
			</div>
		</div>

		<aside class="note-box">
			<div class="prose">
				<h3>🚧 Warum? / Erklärungen - in Arbeit 🚧</h3>
				<p>Hinweis: Auch der Vater kann den ersten Karenzteil uebernehmen.</p>
				<p class="footnote" id="fn-1">
					[1] Papamonat: ab Entlassung aus dem Krankenhaus bis zum Ende des Mutterschutzes nutzbar,
					der Arbeitgeber muss es erlauben.
				</p>
				<p class="footnote" id="fn-2">
					[2] Fuer die Tage im Krankenhaus wird in der Regel Urlaub oder Sonderurlaub benoetigt.
					Pruefe ggf. den Familienzeitbonus: <a href="#">Dummy Link</a>.
				</p>
				<p class="footnote" id="fn-3">
					[3] Unbezahlte Karenz: Mitversicherung? Wie organisiert man unbezahlte Karenz? <a href="#"
						>Dummy Link</a
					>
				</p>
				<p class="footnote" id="fn-4">
					[4] Wer hat Anspruch auf das einkommensabhaengige Kinderbetreuungsgeld? <a href="#"
						>Dummy Link</a
					>
				</p>
				<p class="footnote">
					* Meldefristen beachten! Siehe fuer Papamonat: <a href="#">Dummy Link</a> und fuer Karenz:
					<a href="#">Dummy-Link</a>
				</p>

				<h3 id="eakbg">ea KBG</h3>
				<p>
					Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor
					invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et
					accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata
					sanctus est Lorem ipsum dolor sit amet.
				</p>
				<h3 id="sonderleistung-1">Sonderleistung 1</h3>
				<p>
					Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor
					invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et
					accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata
					sanctus est Lorem ipsum dolor sit amet.
				</p>
				<h3 id="mutterschutz">Mutterschutz</h3>
				<p>
					Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor
					invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et
					accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata
					sanctus est Lorem ipsum dolor sit amet.
				</p>
				<h3 id="papamonat-fzb">Papamonat (und Familienzeitbonus)</h3>
				<p>
					Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor
					invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et
					accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata
					sanctus est Lorem ipsum dolor sit amet.
				</p>
				<h3 id="unbezahlte-karenz">Unbezahlte Karenz</h3>
				<p>
					Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor
					invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et
					accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata
					sanctus est Lorem ipsum dolor sit amet.
				</p>
				<h3 id="elternteilzeit">Elternteilzeit</h3>
				<p>
					Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor
					invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et
					accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata
					sanctus est Lorem ipsum dolor sit amet.
				</p>
			</div>
		</aside>
	</section>

	<section id="auswertung" class="prose">
		<p class="font-semibold">
			TODO: Wie viel Tage pro Karenzteil x Wochengeld: ____ = wie viel Geld? (grobe Rechnung)
		</p>

		<div class="debug-panel">
			<h3>Debug · EA-KBG Berechnung</h3>
			<div class="debug-grid">
				<div>
					<strong>EA KBG Monate:</strong>
					{eaKbgMonths.toFixed(2)}
				</div>
				<div>
					<strong>EA KBG Wochen:</strong>
					{eaKbgWeeks.toFixed(1)}
				</div>
				<div>
					<strong>Mutter bezahlt:</strong>
					{motherPaidMonths.toFixed(2)}
				</div>
				<div>
					<strong>Vater bezahlt:</strong>
					{fatherPaidMonths.toFixed(2)}
				</div>
				<div>
					<strong>Vater Start (Monate nach Geburt):</strong>
					{(fatherStart / WEEKS_PER_MONTH).toFixed(2)}
				</div>
				<div>
					<strong>Vater Fenster Monate:</strong>
					{fatherCoverageWindowMonths.toFixed(2)}
				</div>
				<div>
					<strong>Vater min. Fenster ok?:</strong>
					{fatherWindowAllowsMinimum ? 'ja' : 'nein'}
				</div>
				<div>
					<strong>Vater EA-eligible?</strong>
					{fatherEaEligible ? 'ja' : 'nein'}
				</div>
				<div>
					<strong>Vater elig. Monate:</strong>
					{fatherEligibleMonthsValue.toFixed(2)}
				</div>
				<div>
					<strong>Dritter Teil bezahlt:</strong>
					{thirdPaidMonths.toFixed(2)}
				</div>
				<div>
					<strong>Dritter Start (Monate nach Geburt):</strong>
					{(thirdStart / WEEKS_PER_MONTH).toFixed(2)}
				</div>
				<div>
					<strong>Dritter Fenster Monate:</strong>
					{thirdCoverageWindowMonths.toFixed(2)}
				</div>
				<div>
					<strong>Dritter min. Fenster ok?:</strong>
					{thirdWindowAllowsMinimum ? 'ja' : 'nein'}
				</div>
				<div>
					<strong>Dritter EA-eligible?</strong>
					{thirdEaEligible ? 'ja' : 'nein'}
				</div>
				<div>
					<strong>Dritter elig. Monate:</strong>
					{thirdEligibleMonthsValue.toFixed(2)}
				</div>
			</div>
		</div>
	</section>
</div>

<style lang="postcss">
	/* TODO: convert to tailwind inline styles */

	@reference "../../app.css";
	:global(main) {
		@apply max-w-none;
	}

	/* TODO: move to general layout file or use tailwind classes */
	.layout {
		@apply mx-auto flex w-full max-w-[1200px] flex-col gap-8 px-6 pb-12;
	}

	.page-header {
		@apply grid gap-4;
	}

	.subline {
		@apply text-base leading-relaxed text-slate-800;
	}

	.infobox {
		@apply rounded-xl border-l-4 border-indigo-500 bg-indigo-500/10 px-4 py-3 text-sm font-medium text-slate-900;
	}

	.timeline-section {
		@apply grid gap-6;
	}

	.planner-controls {
		@apply w-full items-end gap-5 rounded-xl border border-slate-200 bg-slate-50 px-5 py-4;
	}

	.example-presets {
		@apply flex w-full items-center gap-3 text-sm text-slate-600;
	}

	.example-presets span {
		@apply font-semibold;
	}

	.example-link {
		@apply cursor-pointer border-0 bg-transparent p-0 font-semibold text-indigo-600 hover:underline focus-visible:underline;
	}

	.control-group {
		@apply grid gap-2;
	}

	.control-group label {
		@apply text-sm font-semibold text-slate-900;
	}

	.control-note {
		@apply block max-w-[7rem] text-xs leading-tight font-medium text-amber-600;
	}

	.stepper {
		@apply inline-flex items-center gap-2 rounded-full border border-slate-300 bg-white px-2 py-1;
	}

	.stepper button {
		@apply grid h-8 w-8 place-items-center rounded-full border-0 bg-slate-200 text-lg font-medium text-slate-800 transition hover:bg-slate-300;
	}

	.stepper input {
		@apply w-16 border-0 bg-transparent text-center text-base font-semibold text-slate-800 focus:outline-none;
	}

	.control-checkbox {
		@apply grid grid-cols-[auto,1fr] items-center gap-x-3 gap-y-2 text-sm font-semibold text-slate-900;
	}

	.control-checkbox small {
		@apply col-start-2 text-xs font-medium text-amber-600;
	}

	.note-box {
		@apply grid gap-2 rounded-xl border border-slate-200 bg-slate-100 px-5 py-4 text-sm text-slate-900;
	}

	.note-box .footnote {
		@apply m-0 text-xs leading-5 text-slate-600;
	}

	.note-box a {
		@apply text-indigo-600 underline;
	}

	.footnote-link {
		@apply font-semibold text-indigo-600 no-underline hover:underline;
	}

	.timeline-shell {
		@apply w-full;
	}

	.timeline-zoom-controls {
		@apply mb-2 flex items-center gap-2 text-xs font-semibold text-slate-600;
	}

	.zoom-button {
		@apply inline-flex h-8 w-8 items-center justify-center rounded-md border border-slate-300 bg-white text-base font-semibold text-slate-700 shadow-sm transition hover:bg-slate-100 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-500 disabled:cursor-not-allowed disabled:opacity-50;
	}

	.zoom-reset {
		@apply inline-flex h-8 items-center justify-center rounded-md border border-slate-300 bg-white px-3 text-xs font-semibold text-slate-700 shadow-sm transition hover:bg-slate-100 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-500 disabled:cursor-not-allowed disabled:opacity-50;
	}

	.zoom-status {
		@apply text-xs font-semibold text-slate-700;
	}

	.timeline-window {
		width: min(100%, 100vw);
		@apply overflow-auto rounded-xl border border-slate-200 bg-white pb-4;
		-webkit-overflow-scrolling: touch;
	}

	.timeline-window:focus-visible {
		@apply outline outline-2 outline-offset-4 outline-indigo-500;
	}

	.warning-banner {
		@apply mt-4 rounded-[10px] border border-amber-300 bg-amber-300/20 px-4 py-3 text-sm font-semibold text-amber-700;
	}

	svg {
		@apply block min-w-full rounded-xl;
		background: linear-gradient(90deg, rgba(15, 23, 42, 0.04) 0 16px, transparent 16px);
	}

	.timeline-track {
		@apply stroke-slate-800 stroke-[6px];
		stroke-linecap: round;
	}

	.debug-panel {
		@apply mt-6 rounded-xl border border-dashed border-slate-300 bg-slate-50 px-5 py-4 text-sm text-slate-900;
	}

	.debug-panel h3 {
		@apply mb-3 text-base font-semibold;
	}

	.debug-grid {
		@apply grid gap-x-4 gap-y-2;
		grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
	}

	.baseline-month-tick {
		@apply stroke-slate-300 stroke-[1.5px];
		stroke-linecap: round;
	}

	.ea-marker-line {
		@apply stroke-slate-500 stroke-[2px] opacity-65;
		stroke-dasharray: 4 6;
	}

	.marker {
		@apply fill-slate-800;
	}

	.marker-start {
		@apply fill-amber-500;
	}

	.marker-ea {
		@apply fill-emerald-600 stroke-white stroke-[1.5px];
	}

	.marker-end {
		@apply fill-amber-500 opacity-80;
	}

	.marker-resume {
		@apply fill-amber-500 stroke-white stroke-[1.5px];
	}

	.marker-inactive {
		@apply fill-slate-400 opacity-70;
	}

	.marker-unpaid {
		@apply fill-red-500;
	}

	.marker-overlay-end,
	.marker-overlay-start {
		@apply fill-amber-500 stroke-white stroke-[1.5px];
	}

	.marker-overlay-end.overlay-paid,
	.marker-overlay-start.overlay-paid {
		@apply fill-emerald-600;
	}

	.marker-overlay-end.overlay-unpaid,
	.marker-overlay-start.overlay-unpaid {
		@apply fill-red-500;
	}

	.interval-line {
		@apply stroke-[10px];
		stroke-linecap: round;
	}

	.interval-line.active {
		@apply stroke-amber-500;
	}

	.interval-line.ea {
		@apply stroke-emerald-600;
	}

	.interval-line.paused {
		@apply stroke-slate-300;
	}

	.interval-line.inactive {
		@apply stroke-slate-400;
	}

	.interval-line.working {
		@apply stroke-[4px];
	}

	.interval-line.unpaid {
		@apply stroke-red-500;
	}

	.interval-line.overlay {
		@apply stroke-[10px];
		stroke-linecap: round;
	}

	.interval-line.overlay.overlay-paid {
		@apply stroke-emerald-600;
	}

	.interval-line.overlay.overlay-unpaid {
		@apply stroke-red-500;
	}

	.interval-line.overlay.overlay-papamonat {
		@apply stroke-amber-500;
	}

	.label {
		@apply fill-slate-900 text-sm font-normal;
	}

	.label-start {
		@apply font-bold;
	}

	.label-end {
		@apply text-xs;
	}

	.label-dot-end,
	.label-dot-mid {
		@apply text-xs font-semibold;
	}

	.interval-label {
		@apply font-semibold;
	}

	.interval-duration {
		@apply fill-slate-600 text-xs;
	}
</style>
