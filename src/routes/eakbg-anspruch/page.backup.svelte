<script lang="ts">
	import EligibilityPanel from '$lib/components/EligibilityPanel.svelte';
	import Timeline from '$lib/components/Timeline.svelte';
	import GanttMinimalDemo from '$lib/components/GanttMinimalDemo.svelte';
	import type { InputBlock } from '$lib/types';

	// State in der Page (einfach)
	let dueDateStr = $state<string>('2026-01-01');
	let motherJobStart = $state<string>('2024-01-01');
	let fatherJobStart = $state<string>('2024-01-01');
	// Optional: früherer Mutterschutz-Beginn (falls ärztlich früher)
	let motherEarlyLeaveStr = $state<string>('');
	// Bestätigung: in relevanten 182 Tagen kein AMS/Notstand/Weiterbildungsgeld bezogen
	let motherNoBenefits = $state(false);
	let fatherNoBenefits = $state(false);
	// Besonderer Geburtsverlauf: Frühgeburt / Mehrlinge / Kaiserschnitt
	let specialBirth = $state(false);

	// Blocks
	let b1 = $state<InputBlock>({ enabled: true, person: 'Mutter', months: 12 });
	let b2 = $state<InputBlock>({ enabled: true, person: 'Vater', months: 2 });
	let b3 = $state<InputBlock>({ enabled: false, person: 'Mutter', months: 4 });
	let sharedFirstSwitch = $state(0);

	// Optional: optische Warnung, wenn niemand anspruchsberechtigt (UI bleibt dennoch nutzbar)
	function addDays(d: Date, n: number) {
		const x = new Date(d);
		x.setDate(x.getDate() + n);
		return x;
	}
	function daysBetween(a: Date, b: Date) {
		return Math.floor((a.getTime() - b.getTime()) / 86400000);
	}
	const et = () => (dueDateStr ? new Date(dueDateStr + 'T00:00:00') : null);
	const mutterschutzStart = () => (et() ? addDays(et()!, -56) : null);
	function isEligibleMother() {
		if (!et() || !motherJobStart) return false;
		const stichtag = motherEarlyLeaveStr
			? new Date(motherEarlyLeaveStr + 'T00:00:00')
			: mutterschutzStart()!;
		return motherNoBenefits && daysBetween(stichtag, new Date(motherJobStart + 'T00:00:00')) >= 182;
	}
	function isEligibleFather() {
		if (!et() || !fatherJobStart) return false;
		return fatherNoBenefits && daysBetween(et()!, new Date(fatherJobStart + 'T00:00:00')) >= 182;
	}
	const noEligibility = $derived(() => !isEligibleMother() && !isEligibleFather());
</script>

<div class="wrap">
	<div class="warn-banner">
		+++ Alle Angaben ohne Gewähr – dieser Artikel wurde noch nicht von Expert:innen geprüft!<br />
		Bitte unbedingt bei AK kostenfrei zu Elternkarenz beraten lassen. +++
		<a
			href="https://wien.arbeiterkammer.at/ueberuns/kontakt/elternkarenz/Elternkarenz.html"
			target="_blank"
			rel="noreferrer">AK Wien: Elternkarenz-Beratung</a
		>
	</div>
	<h3 style="margin:0 0 10px 0;">Karenz Planer Österreich</h3>

	<EligibilityPanel
		{dueDateStr}
		{motherJobStart}
		{fatherJobStart}
		{motherEarlyLeaveStr}
		bind:specialBirth
		bind:motherNoBenefits
		bind:fatherNoBenefits
		on:update={(e) => {
			Object.assign(
				{
					dueDateStr,
					motherJobStart,
					fatherJobStart,
					motherEarlyLeaveStr,
					motherNoBenefits,
					fatherNoBenefits
				},
				e.detail
			);
		}}
	/>

<!-- TODO: add visualization-->
</div>

<style>
	.wrap {
		font-family:
			system-ui,
			-apple-system,
			Segoe UI,
			Roboto,
			Arial,
			sans-serif;
		padding: 16px;
		color: #0f172a;
		max-width: 1100px;
		margin: 0 auto;
	}
	.banner {
		margin-top: 10px;
		padding: 10px 12px;
		border-radius: 10px;
		border: 1px solid #fde68a;
		background: #fffbeb;
		color: #92400e;
	}
	.warn-banner {
		margin-bottom: 12px;
		padding: 10px 12px;
		border-radius: 10px;
		border: 1px solid #ef4444;
		background: #fef2f2;
		color: #991b1b;
		font-weight: 600;
		line-height: 1.3;
	}
	.warn-banner a {
		color: #991b1b;
		text-decoration: underline;
	}
</style>
