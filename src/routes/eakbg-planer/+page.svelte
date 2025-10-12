<script lang="ts">
	import NoteGrid from '$lib/components/NoteGrid.svelte';
	import TimelineSummary from '$lib/components/TimelineSummary.svelte';
	import '@fontsource/ibm-plex-sans-condensed/400.css';
	import '@fontsource/ibm-plex-sans-condensed/600.css';

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
		overlayColor?: string;
		isInactive?: boolean;
		isUnpaid?: boolean;
		forcePaidStartMarker?: boolean;
		hideStartMarker?: boolean;
		hideEndMarker?: boolean;
		isEaBase?: boolean;
		rowGroup?: string;
		lineClass?: string;
		labelClass?: string;
		color?: string;
		markerColor?: string;
		startMarkerColor?: string;
		endMarkerColor?: string;
		markerVariant?: 'default' | 'line';
		labelPosition?: 'above' | 'below';
		hideDurationLabel?: boolean;
		summaryKey?: string;
	};

	const BASE_TOTAL_WEEKS = 104; // 2 years expressed in weeks
	const BASELINE_WIDTH = 640;
	const margins = { top: 32, right: 48, bottom: 32, left: 96 };
	const rowHeight = 60;
	const TIMELINE_EXTRA_HEIGHT = 0;
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
	let fatherMonths = $state(10);
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

	const lastKarenzEnd = $derived(
		Math.max(
			motherWeeks,
			fatherMonths > 0 ? fatherEnd : motherWeeks,
			thirdMonths > 0 ? thirdEnd : motherWeeks
		)
	);
	const parentalPartTimeEnd = BASE_TOTAL_WEEKS;
	const parentalPartTimeDurationWeeks = $derived(Math.max(0, parentalPartTimeEnd - lastKarenzEnd));
	const hasParentalPartTime = $derived(parentalPartTimeDurationWeeks > 0.01);

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
	const fatherUnpaidWeeks = $derived(monthsToWeeks(fatherUnpaidMonths));
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
			? 'Karenz Mutter: ea KBG³ 💰 + unbezahlte Karenz⁷'
			: 'Karenz Mutter: ea KBG³ 💰'
	);

	const motherConsumesAllEa = $derived(coverageAfterMother <= 0);

	const fatherLabel = $derived(
		fatherUnpaidMonths > 0
			? fatherPaidMonths > 0 && !motherConsumesAllEa
				? 'Karenz Vater: ea KBG³ 💰 + unbezahlte Karenz⁷'
				: 'Karenz Vater: unbezahlte Karenz⁷'
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
				? 'Unbezahlte Karenz⁷ (weiterer Teil)'
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

	const eaLabel = 'Anspruch einkommensabhängiges Kinderbetreuungsgeld³ 💰';
	const eaDisplay = $derived(
		jointMonth
			? `max. t13 Monate ab Geburt (11 + min. 2 Vater) wg. gemeinsamer Monat`
			: `max. 14 Monate ab Geburt (12 +  min. 2 Vater)`
	);

	const baseIntervals = $derived<Interval[]>(
		(() => {
			const intervals: Interval[] = [
				{
					label: 'Mutterschutz vor Geburt¹',
					start: -MUTTERSCHUTZ_PRE_WEEKS,
					end: 0,
					displayDuration: `${formatWeeks(MUTTERSCHUTZ_PRE_WEEKS)}, Wochengeld ÖGK 💰`,
					isInactive: true,
					color: 'mutterschutz'
				},
				{
					label: 'Recht auf Karenz-Freistellung² (≠ Förderung)',
					start: 0,
					end: BASE_TOTAL_WEEKS,
					isInactive: true,
					displayDuration:
						'Bis 2. Lebensjahr Recht auf Freistellung, Arbeitgeber muss es erlauben. Heißt aber nicht Recht auf staatliche Förderung!',
					hideDurationLabel: false,
					rowGroup: 'baseline-rights',
					lineClass: 'baseline-rights',
					labelClass: 'label-baseline-rights',
					labelPosition: 'above',
					markerVariant: 'line'
				},
				{
					label: extendedMutterschutz
						? 'Mutterschutz nach der Geburt²'
						: 'Mutterschutz nach der Geburt²',
					start: 0,
					end: mutterschutzWeeks,
					displayDuration: `${formatWeeks(mutterschutzWeeks)}, Wochengeld ÖGK 💰`,
					isInactive: true,
					color: 'mutterschutz'
				},
				{
					label: eaLabel,
					start: 0,
					end: eaKbgWeeks,
					displayDuration: eaDisplay,
					isInactive: true,
					lineClass: 'baseline-rights',
					labelClass: 'label-baseline-rights',
					labelPosition: 'above',
					markerVariant: 'line'
				},
				{
					label: motherLabel,
					start: mutterschutzWeeks,
					end: motherWeeks,
					displayDuration: motherDisplay,
					overlayVariant: 'unpaid',
					overlayStart: motherUnpaidMonths > 0 ? motherUnpaidStart : undefined,
					overlayEnd: motherUnpaidMonths > 0 ? motherWeeks : undefined,
					overlayColor: motherPaidMonths > 0 && motherUnpaidMonths === 0 ? 'ea' : undefined,
					forcePaidStartMarker: true,
					isEaBase: true,
					rowGroup: 'mother',
					color: motherUnpaidMonths > 0 ? undefined : 'ea',
					startMarkerColor:
						motherPaidMonths > 0 ? 'ea' : motherUnpaidMonths > 0 ? 'unpaid' : undefined,
					endMarkerColor:
						motherUnpaidMonths > 0 ? 'unpaid' : motherPaidMonths > 0 ? 'ea' : undefined,
					summaryKey: 'mother-karenz'
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
					labelClass: 'label-working',
					rowGroup: 'mother'
				});
			}

			intervals.push({
				label: 'Papamonat⁶',
				start: papamonatStart,
				end: papamonatEnd,
				displayDuration: 'Ab Entlassung KH, FZB 💰',
				isInactive: true,
				overlayStart: papamonatStart,
				overlayVariant: 'papamonat',
				overlayEnd: papamonatEnd,
				rowGroup: 'father',
				color: 'mutterschutz'
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
					labelClass: 'label-working',
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
				overlayColor: fatherPaidMonths > 0 ? 'ea' : undefined,
				forcePaidStartMarker: fatherUnpaidMonths > 0,
				isEaBase: fatherUnpaidMonths === 0 && fatherPaidMonths > 0,
				rowGroup: 'father',
				color: fatherPaidMonths > 0 && fatherUnpaidMonths === 0 ? 'ea' : undefined,
				startMarkerColor:
					fatherPaidMonths > 0 ? 'ea' : fatherUnpaidMonths > 0 ? 'unpaid' : undefined,
				endMarkerColor: fatherUnpaidMonths > 0 ? 'unpaid' : fatherPaidMonths > 0 ? 'ea' : undefined,
				summaryKey: 'father-karenz'
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
					labelClass: 'label-working',
					rowGroup: 'father'
				});
			}

			return intervals;
		})()
	);

	const intervals = $derived<Interval[]>(
		(() => {
			const result: Interval[] = [...baseIntervals];

			if (thirdMonths > 0) {
				result.push({
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
					overlayColor: thirdPaidMonths > 0 ? 'ea' : undefined,
					isEaBase: thirdUnpaidMonths === 0 && thirdPaidMonths > 0,
					rowGroup: 'mother',
					color: thirdPaidMonths > 0 && thirdUnpaidMonths === 0 ? 'ea' : undefined,
					startMarkerColor:
						thirdPaidMonths > 0 ? 'ea' : thirdUnpaidMonths > 0 ? 'unpaid' : undefined,
					endMarkerColor: thirdUnpaidMonths > 0 ? 'unpaid' : thirdPaidMonths > 0 ? 'ea' : undefined,
					summaryKey: 'third-karenz'
				} satisfies Interval);
			}

			if (hasParentalPartTime) {
				result.push({
					label: 'Anspruch auf Eltern-Teilzeit (beide)⁸',
					start: lastKarenzEnd,
					end: parentalPartTimeEnd,
					rowGroup: 'c',
					hideStartMarker: true,
					hideEndMarker: true,
					hideDurationLabel: true,
					color: 'parental-part-time'
				});
			}

			return result;
		})()
	);

	type SegmentSummary = {
		id: string;
		title: string;
		days: number;
		startWeeks: number;
		endWeeks: number;
		labelPosition: 'above' | 'below';
		summaryKey: string;
		parent?: 'mother' | 'father' | 'third';
		benefitType?: 'ea-paid' | 'unpaid' | 'other';
	};

	const TIMELINE_SUMMARY_KEYS = new Set(['mother-karenz', 'father-karenz', 'third-karenz']);

	const weeksToDays = (weeks: number) => Math.max(0, Math.round(weeks * 7));

	let birthDateInput = $state('');

	const addDays = (date: Date, days: number) => {
		const result = new Date(date);
		result.setDate(result.getDate() + days);
		return result;
	};

	const formatDate = (date: Date) =>
		date.toLocaleDateString('de-AT', {
			day: '2-digit',
			month: '2-digit',
			year: 'numeric'
		});

	const parseBirthDate = (value: string): Date | null => {
		if (!value) {
			return null;
		}
		const parsed = new Date(value);
		return Number.isNaN(parsed.getTime()) ? null : parsed;
	};

	const formatSegmentRange = (segment: SegmentSummary) => {
		const baseDate = parseBirthDate(birthDateInput);
		if (!baseDate) {
			return '–';
		}
		const startOffset = Math.round(segment.startWeeks * 7);
		const endOffsetExclusive = Math.round(segment.endWeeks * 7);
		const endOffset = Math.max(startOffset, endOffsetExclusive - 1);
		const startDate = addDays(baseDate, startOffset);
		const endDate = addDays(baseDate, endOffset);
		return `${formatDate(startDate)} – ${formatDate(endDate)}`;
	};

	const segmentSummaries = $derived<SegmentSummary[]>(
		(() => {
			const summaries: SegmentSummary[] = [];
			const MIN_DURATION_WEEKS = 0.01;

			const pushSummary = (
				id: string,
				title: string,
				startWeeks: number,
				endWeeks: number,
				summaryKey: string,
				labelPosition: 'above' | 'below',
				meta: Partial<Pick<SegmentSummary, 'parent' | 'benefitType'>> = {}
			) => {
				const durationWeeks = Math.max(0, endWeeks - startWeeks);
				if (durationWeeks <= MIN_DURATION_WEEKS) {
					return;
				}
				summaries.push({
					id,
					title,
					days: weeksToDays(durationWeeks),
					startWeeks,
					endWeeks,
					labelPosition,
					summaryKey,
					...meta
				});
			};

			intervals.forEach((interval, index) => {
				const summaryKey = interval.summaryKey;
				if (!summaryKey || !TIMELINE_SUMMARY_KEYS.has(summaryKey)) {
					return;
				}

				const startWeeks = interval.start;
				const endWeeks = interval.lineEnd ?? interval.end;
				const label = interval.label?.trim();
				const labelPosition = interval.labelPosition ?? 'above';

				if (summaryKey === 'mother-karenz') {
					const paidEnd = Math.min(startWeeks + motherPaidWeeks, endWeeks);
					const hasPaid = motherPaidWeeks > MIN_DURATION_WEEKS;
					const hasUnpaid = motherUnpaidWeeks > MIN_DURATION_WEEKS;
					const unpaidStart = hasPaid ? paidEnd : startWeeks;

					if (hasPaid) {
						pushSummary(
							`${summaryKey}-${index}-paid`,
							'Karenz Mutter: ea KBG³ 💰',
							startWeeks,
							paidEnd,
							summaryKey,
							labelPosition,
							{ parent: 'mother', benefitType: 'ea-paid' }
						);
					}

					if (hasUnpaid) {
						pushSummary(
							`${summaryKey}-${index}-unpaid`,
							'Karenz Mutter: unbezahlte Karenz⁷',
							unpaidStart,
							endWeeks,
							summaryKey,
							labelPosition,
							{ parent: 'mother', benefitType: 'unpaid' }
						);
					}

					if (!hasPaid && !hasUnpaid && label) {
						pushSummary(
							`${summaryKey}-${index}`,
							label,
							startWeeks,
							endWeeks,
							summaryKey,
							labelPosition,
							{ parent: 'mother', benefitType: 'other' }
						);
					}
					return;
				}

				if (summaryKey === 'father-karenz') {
					const paidEnd = Math.min(startWeeks + paidFatherWeeks, endWeeks);
					const hasPaid = paidFatherWeeks > MIN_DURATION_WEEKS;
					const hasUnpaid = fatherUnpaidWeeks > MIN_DURATION_WEEKS;
					const unpaidStart = hasPaid ? paidEnd : startWeeks;

					if (hasPaid) {
						pushSummary(
							`${summaryKey}-${index}-paid`,
							'Karenz Vater: ea KBG³ 💰',
							startWeeks,
							paidEnd,
							summaryKey,
							labelPosition,
							{ parent: 'father', benefitType: 'ea-paid' }
						);
					}

					if (hasUnpaid) {
						pushSummary(
							`${summaryKey}-${index}-unpaid`,
							'Karenz Vater: unbezahlte Karenz⁷',
							unpaidStart,
							endWeeks,
							summaryKey,
							labelPosition,
							{ parent: 'father', benefitType: 'unpaid' }
						);
					}

					if (!hasPaid && !hasUnpaid && label) {
						pushSummary(
							`${summaryKey}-${index}`,
							label,
							startWeeks,
							endWeeks,
							summaryKey,
							labelPosition,
							{ parent: 'father', benefitType: 'other' }
						);
					}
					return;
				}

				if (summaryKey === 'third-karenz') {
					const hasPaidThird = thirdPaidMonths > MIN_DURATION_WEEKS;
					const hasUnpaidThird = thirdUnpaidMonths > MIN_DURATION_WEEKS;
					const thirdPaidEnd = Math.min(startWeeks + paidThirdWeeks, endWeeks);
					const thirdUnpaidStart = hasPaidThird ? thirdPaidEnd : startWeeks;

					if (hasPaidThird) {
						pushSummary(
							`${summaryKey}-${index}-paid`,
							label,
							startWeeks,
							thirdPaidEnd,
							summaryKey,
							labelPosition,
							{ parent: 'mother', benefitType: 'ea-paid' }
						);
					}

					if (hasUnpaidThird) {
						const unpaidLabel =
							label.includes('unbezahlt') || label.includes('Unbezahlte')
								? label
								: 'Unbezahlte Karenz⁷ (weiterer Teil)';
						pushSummary(
							`${summaryKey}-${index}-unpaid`,
							unpaidLabel,
							thirdUnpaidStart,
							endWeeks,
							summaryKey,
							labelPosition,
							{ parent: 'mother', benefitType: 'unpaid' }
						);
					}

					if (!hasPaidThird && !hasUnpaidThird && label) {
						pushSummary(
							`${summaryKey}-${index}`,
							label,
							startWeeks,
							endWeeks,
							summaryKey,
							labelPosition,
							{ parent: 'mother', benefitType: 'other' }
						);
					}
					return;
				}

				if (!label) {
					return;
				}

				pushSummary(
					`${summaryKey}-${index}`,
					label,
					startWeeks,
					endWeeks,
					summaryKey,
					labelPosition,
					{ benefitType: 'other' }
				);
			});

			return summaries;
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
	const baseSvgHeight = $derived(
		margins.top + margins.bottom + rowHeight * (maxRowIndex + 1) + TIMELINE_EXTRA_HEIGHT
	);
	const svgWidth = $derived(baseSvgWidth * zoomLevel);
	const svgHeight = $derived(baseSvgHeight * zoomLevel);
	const viewportHeight = $derived(Math.ceil(svgHeight));
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

<section class="content planner-page min-w-0">
	<div class="page-header mt-10 min-w-0">
		<h1 id="planner-title" class="planner-heading text-2xl font-semibold text-slate-900">
			ea KBG Planer
		</h1>
		<p class="subline">
			Prototyp für eine kleine Planungshilfe für das einkommensabhängige Kinderbetreuungsgeld und
			die Aufteilung der Karenz.
		</p>
		<div class="planner-quick-info" role="note">
			<p class="planner-note">
				⚠️ Alle Angaben ohne Gewähr, bitte alle Planungen bei der
				<a href="/ak-beratung" class="planner-link">Arbeiterkammer kostenfrei überprüfen lassen</a>!
			</p>
			<p class="planner-note">
				Unsicher, ob du oder dein/e Partner/in Anspruch hat auf ea KBG? Wenn nur eine Person
				Anspruch hat, kann das andere Elternteil Sonderleistung 1 beziehen. Achtung bei AMS-Zeiten
				o.ä. vor Geburt/Mutterschutz! <a href="/eakbg-anspruch" class="planner-link">Hier prüfen</a
				>.
			</p>
		</div>
	</div>

	<section aria-labelledby="planner-title" class="timeline-section min-w-0">
		<div class="planner-panel min-w-0">
			<div class="planner-controls flex min-w-0 flex-row flex-wrap">
				<div class="example-presets min-w-0">
					<span>Beispiele:</span>

					<button type="button" on:click={() => applyExample(10, 10)} class="example-link"
						>10 + 10 (Halbe Halbe)</button
					>
					<button type="button" on:click={() => applyExample(10, 2)} class="example-link"
						>10 + 2</button
					>
					<button type="button" on:click={() => applyExample(6, 6)} class="example-link"
						>6 + 6</button
					>
				</div>
				<div class="flex min-w-0 flex-row self-start">
					<div class="control-group min-w-0">
						<label for="mother-months">Karenz-Teil 1: Mutter</label>
						<div class="stepper min-w-0">
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
					<div class="control-group min-w-0">
						<label for="father-months">Karenz-Teil 2: Vater</label>
						<div class="stepper min-w-0">
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
					<div class="control-group min-w-0">
						<label for="third-months">(Karenz-Teil 3: Mutter)</label>
						<div class="stepper min-w-0">
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
							<button
								type="button"
								on:click={() => adjustThirdMonths(1)}
								aria-label="Monat erhoehen"
							>
								+
							</button>
						</div>
					</div>
				</div>
				<div class="flex min-w-0 flex-col gap-4 self-start">
					<label class="control-checkbox">
						<input type="checkbox" bind:checked={extendedMutterschutz} />
						<div class="control-checkbox__text">
							<span
								>Mutterschutz 12 Wochen (statt 8 Wochen) <br />(Früh-/Mehrlings-Geburt,
								Kaiserschnitt)</span
							>
						</div>
					</label>
					<label class="control-checkbox">
						<input type="checkbox" bind:checked={jointMonth} />
						<div class="control-checkbox__text">
							<span>Gemeinsamer Monat beim ersten Wechsel⁵</span>
							{#if jointMonth}
								<small>ea KBG wird um 1 Monat kürzer</small>
							{:else}
								<!-- quick hack to fix unecessary layout shift on height-->
								<small>&nbsp;</small>
							{/if}
						</div>
					</label>
				</div>
			</div>

			{#if fatherEaBlocked}
				<div class="warning-banner" role="alert">
					⚠️ Die Mutter nutzt den gesamten Anspruch auf einkommensabhängiges Kinderbetreuungsgeld.
					Der Vater kann daher keinen ea KBG-Bezug mehr geltend machen, weil er mindestens 2 Monate
					im Zeitraum der 14 Monate ab Geburt nehmen muss (12+2 Modell).
				</div>
			{/if}

			<div class="timeline-shell min-w-0">
				<div
					class="timeline-window max-w-full min-w-0"
					role="region"
					aria-labelledby="planner-title"
					style={`height: ${viewportHeight}px;`}
				>
					<div class="timeline-viewport min-w-0">
						<svg
							width={svgWidth}
							height={svgHeight}
							viewBox={svgViewBox}
							role="img"
							aria-labelledby="planner-title"
							style="min-width: 100%; max-width: none;"
						>
							<title>Zeitstrahl mit Basis von zwei Jahren und zusaetzlichen Phasen</title>

							<g class="baseline" aria-hidden="true">
								<circle
									class="marker marker-birth"
									cx={toX(0)}
									cy={rowY(BASELINE_ROW_INDEX)}
									r="6"
								/>
								<line
									class="timeline-track"
									x1={toX(0)}
									y1={rowY(BASELINE_ROW_INDEX)}
									x2={toX(timelineWeeks)}
									y2={rowY(BASELINE_ROW_INDEX)}
								/>
								{#each baselineTicks as tickWeeks}
									{@const isFinalTick = tickWeeks === timelineWeeks}
									<line
										class="baseline-month-tick"
										x1={toX(tickWeeks)}
										y1={rowY(BASELINE_ROW_INDEX) - (isFinalTick ? 16 : 10)}
										x2={toX(tickWeeks)}
										y2={rowY(BASELINE_ROW_INDEX) + (isFinalTick ? 16 : 10)}
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
								{@const colorClass = interval.color ? ` color-${interval.color}` : ''}
								{@const overlayColorClass = interval.overlayColor
									? ` color-${interval.overlayColor}`
									: colorClass}
								{@const markerVariant = interval.markerVariant ?? 'default'}
								{@const startMarkerColorKey =
									interval.startMarkerColor ?? interval.markerColor ?? interval.color}
								{@const endMarkerColorKey =
									interval.endMarkerColor ?? interval.markerColor ?? interval.color}
								{@const startMarkerColorClass = startMarkerColorKey
									? ` color-${startMarkerColorKey}`
									: ''}
								{@const endMarkerColorClass = endMarkerColorKey
									? ` color-${endMarkerColorKey}`
									: ''}
								{@const startMarkerLineClass =
									markerVariant === 'line'
										? ` marker-line${interval.lineClass ? ` ${interval.lineClass}` : ''}${startMarkerColorClass}`
										: ''}
								{@const endMarkerLineClass =
									markerVariant === 'line'
										? ` marker-line${interval.lineClass ? ` ${interval.lineClass}` : ''}${endMarkerColorClass}`
										: ''}
								{@const labelAnchor = interval.start < 0 ? 'start' : 'middle'}
								{@const labelX =
									interval.start < 0
										? toX(interval.start)
										: (toX(interval.start) + toX(lineEnd)) / 2}
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
									hasOverlay &&
									interval.overlayVariant === 'unpaid' &&
									interval.overlayEnd === lineEnd
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
											class={`interval-line ${activeLineClass}${customLineClass}${colorClass}`}
											x1={toX(pausedUntil)}
											y1={rowY(rowIndex)}
											x2={toX(lineEnd)}
											y2={rowY(rowIndex)}
										/>
									{:else}
										<line
											class={`interval-line ${activeLineClass}${customLineClass}${colorClass}`}
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
												class={`marker marker-overlay-start overlay-${overlayVariant}${overlayColorClass}`}
												cx={toX(overlayStart)}
												cy={rowY(rowIndex)}
												r="4"
											/>
										{/if}
										<line
											class={`interval-line overlay overlay-${overlayVariant}${overlayColorClass}`}
											x1={toX(overlayStart)}
											y1={rowY(rowIndex)}
											x2={toX(overlayEnd)}
											y2={rowY(rowIndex)}
										/>
										<circle
											class={`marker marker-overlay-end overlay-${overlayVariant}${overlayColorClass}`}
											cx={toX(overlayEnd)}
											cy={rowY(rowIndex)}
											r="4"
										/>
									{/if}

									{#if !interval.hideStartMarker}
										{#if markerVariant === 'line'}
											<line
												class={`marker${startMarkerLineClass}`}
												x1={toX(interval.start)}
												y1={rowY(rowIndex) - 10}
												x2={toX(interval.start)}
												y2={rowY(rowIndex) + 10}
											/>
										{:else}
											<circle
												class={`marker ${startMarkerClass}${startMarkerColorClass}`}
												cx={toX(interval.start)}
												cy={rowY(rowIndex)}
												r="5"
											/>
										{/if}
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
										{#if markerVariant === 'line'}
											<line
												class={`marker${endMarkerLineClass}`}
												x1={toX(lineEnd)}
												y1={rowY(rowIndex) - 10}
												x2={toX(lineEnd)}
												y2={rowY(rowIndex) + 10}
											/>
										{:else}
											<circle
												class={`marker ${endMarkerClass}${endMarkerColorClass}`}
												cx={toX(lineEnd)}
												cy={rowY(rowIndex)}
												r="5"
											/>
										{/if}
									{/if}
									<text
										class={`label interval-label${interval.labelClass ? ` ${interval.labelClass}` : ''}`}
										x={labelX}
										y={interval.labelPosition === 'below'
											? rowY(rowIndex) + 18
											: rowY(rowIndex) - 12}
										text-anchor={labelAnchor}
									>
										{interval.label}
									</text>
									{#if !interval.hideDurationLabel}
										<text
											class="label interval-duration"
											x={labelX}
											y={interval.labelPosition === 'below'
												? rowY(rowIndex) + 36
												: rowY(rowIndex) + 18}
											text-anchor={labelAnchor}
										>
											{interval.displayDuration ?? formatWeeks(interval.end - interval.start)}
										</text>
									{/if}
								</g>
							{/each}
						</svg>
					</div>
				</div>
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
			</div>
		</div>

		<NoteGrid />
		<TimelineSummary {segmentSummaries} bind:birthDateInput {formatSegmentRange} open={false} />
	</section>

	<!-- TODO: remove, not necessary anymore-->
	<section id="auswertung" class="prose">
		<div class="debug-panel" style="display:none">
			<h3>Debug · EA-KBG Berechnung</h3>
			<div class="debug-grid">
				<div><strong>EA KBG Monate:</strong> {eaKbgMonths.toFixed(2)}</div>
				<div><strong>EA KBG Wochen:</strong> {eaKbgWeeks.toFixed(1)}</div>
				<div><strong>Mutter bezahlt:</strong> {motherPaidMonths.toFixed(2)}</div>
				<div><strong>Vater bezahlt:</strong> {fatherPaidMonths.toFixed(2)}</div>
				<div>
					<strong>Vater Start (Monate nach Geburt):</strong>
					{(fatherStart / WEEKS_PER_MONTH).toFixed(2)}
				</div>
				<div><strong>Vater Fenster Monate:</strong> {fatherCoverageWindowMonths.toFixed(2)}</div>
				<div>
					<strong>Vater min. Fenster ok?:</strong>
					{fatherWindowAllowsMinimum ? 'ja' : 'nein'}
				</div>
				<div><strong>Vater EA-eligible?</strong> {fatherEaEligible ? 'ja' : 'nein'}</div>
				<div><strong>Vater elig. Monate:</strong> {fatherEligibleMonthsValue.toFixed(2)}</div>
				<div><strong>Dritter Teil bezahlt:</strong> {thirdPaidMonths.toFixed(2)}</div>
				<div>
					<strong>Dritter Start (Monate nach Geburt):</strong>
					{(thirdStart / WEEKS_PER_MONTH).toFixed(2)}
				</div>
				<div><strong>Dritter Fenster Monate:</strong> {thirdCoverageWindowMonths.toFixed(2)}</div>
				<div>
					<strong>Dritter min. Fenster ok?:</strong>
					{thirdWindowAllowsMinimum ? 'ja' : 'nein'}
				</div>
				<div><strong>Dritter EA-eligible?</strong> {thirdEaEligible ? 'ja' : 'nein'}</div>
				<div><strong>Dritter elig. Monate:</strong> {thirdEligibleMonthsValue.toFixed(2)}</div>
			</div>
		</div>
	</section>
</section>

<style lang="postcss">
	/* TODO: convert to tailwind inline styles */

	@reference "../../app.css";

	:global(:root) {
		--planner-font:
			'IBM Plex Sans Condensed', system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI',
			sans-serif;
		--planner-font-condensed: 'IBM Plex Sans Condensed', var(--planner-font);
		--timeline-label-font: var(--planner-font-condensed);
		--timeline-color-rights: #475467;
		--timeline-color-ea: #0f9eb8;
		--timeline-color-mutterschutz: #15803d;
		--timeline-color-active-line: #2563eb;
		--timeline-color-marker-active: #1d4ed8;
		--timeline-color-unpaid: #d97706;
		--timeline-color-overlay-unpaid: #f59e0b;
		--timeline-color-papamonat: #15803d;
		--timeline-color-inactive: #cbd5e1;
		--timeline-color-working: #94a3b8;
		--timeline-color-marker-neutral: #1f2937;
	}
	:global(main) {
		@apply max-w-none;
	}

	/* Avoid any stray horizontal scrolling */
	:global(html, body) {
		overflow-x: hidden;
	}

	/* Let flex/grid children shrink on small screens */
	.planner-page,
	.timeline-section,
	.planner-controls,
	.timeline-window,
	.timeline-viewport,
	.control-group,
	.stepper {
		min-width: 0;
	}

	/* TODO: add this to div element? general css or inline?*/
	/* Container */
	.planner-page {
		@apply gap-6;
		font-family: var(--planner-font);
	}

	.planner-heading {
		font-family: var(
			--planner-heading-font,
			ui-sans-serif,
			system-ui,
			-apple-system,
			BlinkMacSystemFont,
			'Segoe UI',
			sans-serif
		);
	}

	/* TODO: generalize this, not special for this page? */
	.page-header {
		@apply mb-4 grid gap-3;
	}

	.planner-panel {
		@apply grid gap-0 overflow-hidden rounded-3xl border border-slate-200 bg-white shadow-sm;
	}

	.subline {
		@apply text-sm leading-relaxed text-slate-800;
	}

	.planner-quick-info {
		@apply flex flex-col gap-1.5 rounded-2xl bg-slate-100/70 px-3 py-2 text-xs text-slate-700 sm:flex-row sm:flex-wrap sm:items-center sm:gap-2;
	}

	.planner-note {
		@apply m-0 leading-snug;
	}

	.planner-link {
		@apply font-semibold text-slate-900 underline decoration-dotted underline-offset-2 transition hover:text-slate-700;
	}

	.timeline-section {
		@apply grid gap-6;
	}

	.planner-controls {
		@apply w-full items-end gap-4 border-b border-slate-200 bg-white px-4 py-3;
	}

	.example-presets {
		@apply flex w-full items-center gap-2 text-xs text-slate-600;
	}

	.example-presets span {
		@apply font-semibold;
	}

	.example-link {
		@apply cursor-pointer border-0 bg-transparent p-0 font-semibold text-indigo-600 hover:underline focus-visible:underline;
	}

	.control-group {
		@apply grid gap-1.5;
	}

	.control-group label {
		@apply text-xs font-semibold tracking-wide text-slate-900 uppercase;
	}

	.control-note {
		@apply block max-w-[7rem] text-xs leading-tight font-medium text-amber-600;
	}

	.stepper {
		@apply inline-flex items-center gap-1.5 rounded-full border border-slate-300 bg-white px-2 py-1;
	}

	.stepper button {
		@apply grid h-11 w-11 place-items-center rounded-full border-0 bg-slate-200 text-base font-semibold text-slate-800 transition hover:bg-slate-300;
	}

	.stepper input {
		@apply w-14 border-0 bg-transparent text-center text-sm font-semibold tracking-wide text-slate-800 focus:outline-none;
	}

	.control-checkbox {
		@apply flex items-start gap-2 text-xs font-semibold text-slate-900;
	}

	.control-checkbox input {
		@apply mt-0.5 shrink-0;
	}

	.control-checkbox__text {
		@apply flex flex-col gap-1;
	}

	.control-checkbox__text span {
		@apply leading-tight;
	}

	.control-checkbox__text small {
		@apply text-xs font-medium text-amber-600;
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
		@apply w-full bg-white px-4 pt-4 pb-4;
	}

	.timeline-zoom-controls {
		@apply mt-2 flex items-center gap-2 text-xs font-semibold text-slate-600;
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

	/* Key fix: keep timeline to container width (no 100vw) */
	.timeline-window {
		width: 100%;
		@apply overflow-hidden rounded-2xl bg-white pb-3;
	}

	.timeline-viewport {
		@apply h-full w-full overflow-x-auto overflow-y-hidden;
		-webkit-overflow-scrolling: touch;
		min-height: inherit;
	}

	.timeline-window:focus-visible {
		@apply outline outline-2 outline-offset-4 outline-indigo-500;
	}

	.warning-banner {
		@apply mt-4 rounded-[10px] border border-amber-300 bg-amber-300/20 px-4 py-3 text-sm font-semibold text-amber-700;
	}

	.planner-panel > .warning-banner {
		@apply mx-4;
	}

	svg {
		@apply block rounded-xl;
	}

	.timeline-track {
		@apply stroke-slate-800 stroke-[4px];
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
		@apply stroke-slate-500 stroke-[1px];
		stroke-linecap: round;
	}

	.ea-marker-line {
		@apply stroke-slate-500 stroke-[2px] opacity-65;
		stroke-dasharray: 4 6;
	}

	.marker {
		fill: var(--timeline-color-marker-neutral);
	}

	.marker-start {
		fill: var(--timeline-color-marker-active);
	}

	.marker-ea {
		fill: var(--timeline-color-ea);
		stroke: #fff;
		stroke-width: 1.5px;
	}

	.marker-end {
		fill: var(--timeline-color-marker-active);
		opacity: 0.9;
	}

	.marker-resume {
		fill: var(--timeline-color-marker-active);
		stroke: #fff;
		stroke-width: 1.5px;
	}

	.marker-inactive {
		fill: var(--timeline-color-inactive);
		opacity: 0.75;
	}

	.marker-unpaid {
		fill: var(--timeline-color-unpaid);
	}

	.marker-overlay-end,
	.marker-overlay-start {
		fill: var(--timeline-color-marker-active);
		stroke: #fff;
		stroke-width: 1.5px;
	}

	.marker-overlay-end.overlay-paid,
	.marker-overlay-start.overlay-paid {
		fill: var(--timeline-color-marker-active);
	}

	.marker-overlay-end.overlay-unpaid,
	.marker-overlay-start.overlay-unpaid {
		fill: var(--timeline-color-overlay-unpaid);
	}

	.interval-line {
		stroke-width: 6px;
		stroke-linecap: round;
		stroke: var(--timeline-color-inactive);
	}

	.interval-line.active {
		stroke: var(--timeline-color-active-line);
	}

	.interval-line.ea {
		stroke: var(--timeline-color-ea);
	}

	.interval-line.paused {
		stroke: var(--timeline-color-inactive);
	}

	.interval-line.inactive {
		stroke: var(--timeline-color-inactive);
	}

	.interval-line.working {
		stroke-width: 4px;
		stroke: var(--timeline-color-working);
	}

	.interval-line.baseline-rights {
		stroke-width: 5px;
		stroke: var(--timeline-color-rights);
		stroke-linecap: square;
	}

	.interval-line.baseline-rights-ea {
		stroke: var(--timeline-color-ea);
	}

	.interval-line.color-parental-part-time {
		stroke: var(--timeline-color-active-line);
	}

	.interval-line.unpaid {
		stroke: var(--timeline-color-unpaid);
	}

	.interval-line.overlay {
		stroke-width: 8px;
		stroke-linecap: round;
	}

	.interval-line.overlay.overlay-paid {
		stroke: var(--timeline-color-active-line);
	}

	.interval-line.overlay.overlay-unpaid {
		stroke: var(--timeline-color-overlay-unpaid);
	}

	.interval-line.overlay.overlay-papamonat {
		stroke: var(--timeline-color-papamonat);
	}

	.interval-line.color-ea {
		stroke: var(--timeline-color-ea);
	}

	.interval-line.overlay.color-ea {
		stroke: var(--timeline-color-ea);
	}

	.interval-line.color-mutterschutz {
		stroke: var(--timeline-color-mutterschutz);
	}

	.interval-line.overlay.color-mutterschutz {
		stroke: var(--timeline-color-mutterschutz);
	}

	.marker.marker-line {
		stroke-width: 3px;
		stroke: var(--timeline-color-rights);
		fill: none;
		stroke-linecap: square;
	}

	.marker.marker-line.baseline-rights-ea {
		stroke: var(--timeline-color-ea);
	}

	.marker.marker-line.color-ea {
		stroke: var(--timeline-color-ea);
	}

	.marker.color-ea {
		fill: var(--timeline-color-ea);
		stroke: #fff;
		stroke-width: 1.5px;
	}

	.marker.marker-line.color-mutterschutz {
		stroke: var(--timeline-color-mutterschutz);
	}

	.marker.color-mutterschutz {
		fill: var(--timeline-color-mutterschutz);
		stroke: #fff;
		stroke-width: 1.5px;
	}

	.marker.marker-line.color-unpaid {
		stroke: var(--timeline-color-unpaid);
	}

	.marker.color-unpaid {
		fill: var(--timeline-color-unpaid);
		stroke: #fff;
		stroke-width: 1.5px;
	}

	.marker.marker-line.color-active-line {
		stroke: var(--timeline-color-active-line);
	}

	.marker.color-active-line {
		fill: var(--timeline-color-active-line);
		stroke: #fff;
		stroke-width: 1.5px;
	}

	.marker.marker-line.color-parental-part-time {
		stroke: var(--timeline-color-active-line);
	}

	.marker.color-parental-part-time {
		fill: var(--timeline-color-active-line);
		stroke: #fff;
		stroke-width: 1.5px;
	}

	.interval-label.label-working {
		@apply text-xs font-normal;
		fill: var(--timeline-color-working);
	}

	.label-baseline-rights {
		@apply text-xs font-medium;
		fill: var(--timeline-color-rights);
	}

	.label-baseline-rights-ea {
		fill: var(--timeline-color-ea);
	}

	.label {
		@apply text-sm font-normal;
		fill: #1e293b;
		font-family: var(--timeline-label-font);
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
		font-family: var(--timeline-label-font);
	}

	.timeline-summary {
		@apply mt-6 grid gap-3 rounded-xl border border-slate-200 bg-white p-4;
	}

	.timeline-summary__title {
		@apply flex items-center gap-2 text-sm font-semibold tracking-wide text-slate-700 uppercase;
	}

	.timeline-summary__badge {
		@apply inline-flex items-center rounded-full bg-amber-100 px-2.5 py-0.5 text-[11px] font-semibold tracking-wide text-amber-700 uppercase;
	}

	.timeline-summary__birthdate {
		@apply grid gap-1 text-sm;
	}

	.timeline-summary__birthdate label {
		@apply flex flex-col gap-1;
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

	.timeline-summary__table th {
		@apply border-b border-slate-200 bg-slate-50 px-3 py-2 text-left text-xs font-semibold tracking-wide text-slate-700 uppercase;
	}

	.timeline-summary__table td {
		@apply px-3 py-2 align-middle text-sm text-slate-800;
	}

	.timeline-summary__table th[scope='row'] {
		@apply text-sm font-semibold text-slate-900;
	}

	.timeline-summary__input {
		@apply w-full rounded-md border border-slate-300 bg-white px-2 py-1 text-sm text-slate-800 shadow-sm focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-500 disabled:cursor-not-allowed disabled:bg-slate-100 disabled:text-slate-500;
	}

	.timeline-summary__empty {
		@apply mt-4 text-sm font-medium text-slate-600;
	}
</style>
