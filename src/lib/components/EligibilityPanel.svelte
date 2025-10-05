<script lang="ts">
	import type { Person } from '$lib/types';
	import { createEventDispatcher } from 'svelte';

	let {
		dueDateStr = '', // yyyy-mm-dd
		motherJobStart = '', // yyyy-mm-dd
		fatherJobStart = '', // yyyy-mm-dd
		motherEarlyLeaveStr = '', // yyyy-mm-dd (optional)
		motherNoBenefits = $bindable(false),
		fatherNoBenefits = $bindable(false),
		specialBirth = $bindable(false) // Frühgeburt / Mehrlinge / Kaiserschnitt
	} = $props<{
		dueDateStr?: string;
		motherJobStart?: string;
		fatherJobStart?: string;
		motherEarlyLeaveStr?: string;
		motherNoBenefits?: boolean;
		fatherNoBenefits?: boolean;
		specialBirth?: boolean;
	}>();

	const dispatch = createEventDispatcher();

	function addDays(d: Date, n: number) {
		const x = new Date(d);
		x.setDate(x.getDate() + n);
		return x;
	}
	function daysBetween(a: Date, b: Date) {
		return Math.floor((a.getTime() - b.getTime()) / 86400000);
	}
	const et = () => (dueDateStr ? new Date(dueDateStr + 'T00:00:00') : null);
	const mutterschutzReg = () => (et() ? addDays(et()!, -56) : null); // 8 Wochen vor ET
	const mutterschutzEff = () =>
		motherEarlyLeaveStr ? new Date(motherEarlyLeaveStr + 'T00:00:00') : mutterschutzReg();

	// Mutterschutz nach Geburt (vereinfacht)
	const postBirthWeeks = () => (specialBirth ? 12 : 8);
	const postBirthEnd = () => (et() ? addDays(et()!, postBirthWeeks() * 7) : null);

	function isEligible(p: Person): boolean {
		if (!et()) return false;
		const stichtag = p === 'Mutter' ? mutterschutzEff() : et();
		const startStr = p === 'Mutter' ? motherJobStart : fatherJobStart;
		const noBenefits = p === 'Mutter' ? motherNoBenefits : fatherNoBenefits;
		if (!startStr || !stichtag || !noBenefits) return false;
		const start = new Date(startStr + 'T00:00:00');
		return daysBetween(stichtag, start) >= 182;
	}

	function eligText(): string {
		const m = isEligible('Mutter');
		const v = isEligible('Vater');
		if (m && v) return 'Beide sind für eaKBG anspruchsberechtigt.';
		if (m && !v)
			return 'Nur die Mutter ist anspruchsberechtigt. Vater: Sonderleistung I (41,14 €/Tag) möglich.';
		if (!m && v)
			return 'Nur der Vater ist anspruchsberechtigt. Mutter: Sonderleistung I (41,14 €/Tag) möglich.';
		return 'Keiner ist anspruchsberechtigt. Es bleibt das Pauschale Kinderbetreuungsgeld.';
	}
</script>

<div class="rounded-xl border border-slate-200 bg-white p-4">
	<h4 class="m-0 mb-2 font-bold text-slate-900">Karenz: Prüfung & Eingaben</h4>
	<div class="grid grid-cols-1 gap-3 md:grid-cols-2">
		<!-- 1. Geburtstermin -->
		<section class="rounded-xl border border-slate-200 bg-white p-3 md:col-span-2">
			<h5 class="m-0 mb-2 font-semibold">1) Errechneter Geburtstermin</h5>
			<div class="flex flex-wrap items-end gap-3">
				<label class="flex flex-col gap-1 text-sm">
					<span class="text-xs text-slate-600">(Errechneter) Geburtstermin</span>
					<input
						type="date"
						class="h-9 rounded-lg border-slate-200"
						bind:value={dueDateStr}
						onchange={() => dispatch('update', { dueDateStr })}
					/>
				</label>
				{#if dueDateStr}
                    <div class="hl w-full">
                        Mutterschutz-Beginn (vereinfacht): <strong>{mutterschutzReg()?.toLocaleDateString()}</strong>
                    </div>
                    <div class="hl w-full">
                        Mutterschutz nach Geburt: <strong>{postBirthWeeks()} Wochen</strong> (bis <strong>{postBirthEnd()?.toLocaleDateString()}</strong>)
                    </div>
                {/if}
                </div>
            </section>

		<!-- 2. Arbeitssituation -->
		<section class="rounded-xl border border-slate-200 bg-white p-3">
			<h5 class="m-0 mb-2 font-semibold">2) Arbeitssituation – Mutter</h5>
			<label class="flex flex-col gap-1 text-sm">
				<span class="text-xs text-slate-600">Beginn letzter durchgehender Job</span>
				<input
					type="date"
					class="h-9 rounded-lg border-slate-200"
					bind:value={motherJobStart}
					onchange={() => dispatch('update', { motherJobStart })}
				/>
			</label>
			<label class="check">
				<input
					type="checkbox"
					bind:checked={motherNoBenefits}
					onchange={() => dispatch('update', { motherNoBenefits })}
				/>
                <span>
                    In den 182 Tagen vor dem Mutterschutz‑Beginn ({mutterschutzEff()?.toLocaleDateString() ?? '—'}) habe ich kein AMS,
                    Weiterbildungsgeld, Notstandshilfe o.ä. bezogen — Zeitraum:
                    <strong>{(mutterschutzEff() ? addDays(mutterschutzEff()!, -182).toLocaleDateString() : '—')} –
                    {mutterschutzEff()?.toLocaleDateString() ?? '—'}</strong>
                </span>
			</label>
		</section>
		<section class="rounded-xl border border-slate-200 bg-white p-3">
			<h5 class="m-0 mb-2 font-semibold">2) Arbeitssituation – Vater</h5>
			<label class="flex flex-col gap-1 text-sm">
				<span class="text-xs text-slate-600">Beginn letzter durchgehender Job</span>
				<input
					type="date"
					class="h-9 rounded-lg border-slate-200"
					bind:value={fatherJobStart}
					onchange={() => dispatch('update', { fatherJobStart })}
				/>
			</label>
			<label class="check">
				<input
					type="checkbox"
					bind:checked={fatherNoBenefits}
					onchange={() => dispatch('update', { fatherNoBenefits })}
				/>
                <span>
                    In den 182 Tagen vor der Geburt ({et()?.toLocaleDateString() ?? '—'}) habe ich kein AMS,
                    Weiterbildungsgeld, Notstandshilfe o.ä. bezogen — Zeitraum:
                    <strong>{(et() ? addDays(et()!, -182).toLocaleDateString() : '—')} –
                    {et()?.toLocaleDateString() ?? '—'}</strong>
                </span>
			</label>
		</section>

		<!-- 3. Mutterschutz & Papamonat/Familienzeitbonus -->
		<section class="rounded-xl border border-slate-200 bg-white p-3">
			<h5 class="m-0 mb-2 font-semibold">3) Mutterschutz (Mutter)</h5>
			<label class="flex flex-col gap-1 text-sm">
				<span class="text-xs text-slate-600">Früherer Mutterschutz-Beginn (optional)</span>
				<input
					type="date"
					class="h-9 rounded-lg border-slate-200"
					bind:value={motherEarlyLeaveStr}
					onchange={() => dispatch('update', { motherEarlyLeaveStr })}
				/>
			</label>
			<label class="check mt-2">
				<input
					type="checkbox"
					bind:checked={specialBirth}
					onchange={() => dispatch('update', { specialBirth })}
				/>
				<span
					>Frühgeburt, Mehrlingsgeburt oder Kaiserschnitt (verlängert Mutterschutz nach Geburt auf
					mindestens 12 Wochen)</span
				>
			</label>
			<div class="mini-info mt-2">
				Für Anspruch auf eaKBG müssen 6 Monate (182 Kalendertage) vor dem Mutterschutz-Beginn
				durchgehend gearbeitet worden sein (standardmäßig 8 Wochen vor ET, oder früher, wenn
				ärztlich verordnet). In den letzten 128 Tagen vor diesem Stichtag ist kein Bezug von
				Arbeitslosengeld, Notstandshilfe oder Weiterbildungsgeld zulässig (ÖGK).
			</div>
		</section>
		<section class="rounded-xl border border-slate-200 bg-white p-3">
			<h5 class="m-0 mb-2 font-semibold">3) Papamonat / Familienzeitbonus (Vater)</h5>
			{#if dueDateStr && et()}
				{@const birth = et()!}
				{@const windowStart = birth}
				{@const windowEnd = addDays(birth, 91)}
				{@const startMax28 = addDays(birth, 91 - 28)}
				{@const startMax31 = addDays(birth, 91 - 31)}
				{@const eligStart = new Date(
					(fatherJobStart ? new Date(fatherJobStart + 'T00:00:00') : new Date()).getTime() +
						182 * 86400000
				)}
				{@const recStart = eligStart > windowStart ? eligStart : windowStart}
				{@const recEnd31 = addDays(recStart, 31 - 1)}
				{@const recEnd28 = addDays(recStart, 28 - 1)}
				<div class="mini-info">
					Voraussetzungen (vereinfacht): 182 Tage erwerbstätig vor Bezugsbeginn, keine Leistungen
					aus der Arbeitslosenversicherung im Beobachtungszeitraum. Dauer: 28–31 Tage, vollständiger
					Bezug innerhalb von 91 Tagen ab Geburt.
				</div>
				<div class="mt-2 text-sm text-slate-700">
					Möglicher Start im Zeitraum <strong>{windowStart.toLocaleDateString()}</strong> bis
					<strong>{startMax28.toLocaleDateString()}</strong>
					(28 Tage) bzw. bis <strong>{startMax31.toLocaleDateString()}</strong> (31 Tage).<br
					/>Empfohlener Start (frühestmöglicher bei aktueller Beschäftigungslage):
					<strong>{recStart.toLocaleDateString()}</strong>
					– <strong>{(recEnd31 <= windowEnd ? recEnd31 : recEnd28).toLocaleDateString()}</strong>
				</div>
				<div
					class={fatherNoBenefits &&
					daysBetween(et()!, new Date(fatherJobStart + 'T00:00:00')) >= 182
						? 'ok mt-2 text-emerald-700'
						: 'warn mt-2 text-red-700'}
				>
					{fatherNoBenefits && daysBetween(et()!, new Date(fatherJobStart + 'T00:00:00')) >= 182
						? '✔ Familienzeitbonus: Voraussetzungen (vereinfacht) erfüllt'
						: '✖ Familienzeitbonus: Voraussetzungen (vereinfacht) nicht erfüllt'}
				</div>
			{/if}
		</section>

		<!-- 4. Anspruchs-Info auf eaKBG -->
		<section class="rounded-xl border border-slate-200 bg-white p-3 md:col-span-2">
			<h5 class="m-0 mb-2 font-semibold">4) Anspruch (eaKBG)</h5>
			<div class="grid grid-cols-1 gap-3 md:grid-cols-2">
				<div class={isEligible('Mutter') ? 'ok text-emerald-700' : 'warn text-red-700'}>
					{isEligible('Mutter') ? '✔ Anspruch Mutter: ja' : '✖ Anspruch Mutter: nein'}
				</div>
				<div class={isEligible('Vater') ? 'ok text-emerald-700' : 'warn text-red-700'}>
					{isEligible('Vater') ? '✔ Anspruch Vater: ja' : '✖ Anspruch Vater: nein'}
				</div>
			</div>
			<p class="mt-2 text-slate-800"><strong>Ergebnis:</strong> {eligText()}</p>
			<div class="footnote">
				Unverbindliche Rechenhilfe, keine Rechtsberatung. Mehr Informationen: <a
					href="#"
					target="_blank"
					rel="noreferrer">Weitere Details (Dummy-Link)</a
				>
			</div>
		</section>
	</div>
</div>

<style>
	.card {
		border: 1px solid #e5e7eb;
		border-radius: 12px;
		background: #fff;
		padding: 12px;
	}
	.card.inner {
		padding: 10px;
	}
	.row {
		display: flex;
		gap: 12px;
		flex-wrap: wrap;
		align-items: flex-end;
	}
	.title {
		margin: 0 0 4px 0;
		font-weight: 700;
	}
	.sub {
		color: #475569;
		font-size: 13px;
		margin-bottom: 8px;
	}
	.field {
		display: flex;
		flex-direction: column;
		gap: 4px;
	}
	.label {
		font-size: 12px;
		color: #475569;
	}
	input[type='date'],
	input[type='text'],
	input[type='number'],
	select {
		height: 36px;
		border: 1px solid #e2e8f0;
		border-radius: 8px;
		padding: 6px 8px;
		background: #fff;
	}
	input:focus,
	select:focus {
		outline: 2px solid #93c5fd;
		outline-offset: 1px;
	}
	.hl {
		background: #f8fafc;
		padding: 4px 8px;
		border-radius: 8px;
		border: 1px solid #e2e8f0;
	}
	.info {
		margin-top: 8px;
		background: #fffbeb;
		border: 1px solid #fde68a;
		border-radius: 8px;
		padding: 8px 10px;
		color: #92400e;
		font-size: 13px;
		line-height: 1.35;
	}
	.mini-info {
		margin-top: 6px;
		background: #f8fafc;
		border: 1px solid #e2e8f0;
		border-radius: 8px;
		padding: 6px 8px;
		color: #334155;
		font-size: 12px;
		line-height: 1.35;
	}
	.check {
		display: flex;
		gap: 8px;
		align-items: flex-start;
		margin-top: 6px;
	}
	.check input {
		margin-top: 2px;
	}
	.footnote {
		margin-top: 8px;
		color: #475569;
		font-size: 12px;
	}
	.ok {
		color: #065f46;
	}
	.warn {
		color: #b91c1c;
	}
</style>
