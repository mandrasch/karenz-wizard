<script lang="ts">
	import { Gantt, Willow } from 'wx-svelte-gantt';
	import { browser } from '$app/environment';

	// ---- Props ----
	// Errechneter Geburtstermin (EGT) als String; Default 2026-01-01
	let { birthDateStr = '2026-01-01' } = $props<{ birthDateStr?: string }>();

	// ---- State ----
	// KBG-Dauer in Monaten (UI-gesteuert)
	let months = $state(12);

	// ---- Date-Helpers ----
	function daysInMonth(y: number, m0: number) {
		return new Date(y, m0 + 1, 0).getDate();
	}
	function addWholeMonthsClamped(d: Date, m: number) {
		const x = new Date(d),
			day = x.getDate();
		x.setDate(1);
		x.setMonth(x.getMonth() + m);
		x.setDate(Math.min(day, daysInMonth(x.getFullYear(), x.getMonth())));
		return x;
	}
	function addMonths(d: Date, m: number) {
		const whole = Math.trunc(m),
			frac = m - whole,
			base = addWholeMonthsClamped(d, whole);
		if (!frac) return base;
		const dim = daysInMonth(base.getFullYear(), base.getMonth());
		const out = new Date(base);
		out.setDate(out.getDate() + Math.round(frac * dim));
		return out;
	}
	function addWeeks(d: Date, w: number) {
		const x = new Date(d);
		x.setDate(x.getDate() + Math.round(w * 7));
		return x;
	}
	function parseLocalDate(str: string): Date | null {
		if (!str) return null;
		const m = /^(\d{4})-(\d{2})-(\d{2})$/.exec(str);
		if (m) return new Date(+m[1], +m[2] - 1, +m[3]);
		const t = Date.parse(str);
		return Number.isFinite(t) ? new Date(t) : null;
	}

	// ---- Derived core dates ----
	const egt = $derived(() => parseLocalDate(birthDateStr) ?? new Date(2026, 0, 1)); // Date
	const egtMinus8 = $derived(() => addWeeks(egt, -8));
	const egtPlus8 = $derived(() => addWeeks(egt, 8));

	// ---- Tasks (rein derived) ----
	type Task = {
		id: number;
		text: string;
		start: Date;
		end: Date;
		type: 'task';
		progress?: number;
		css?: string;
		color?: string;
	};

	const tasksDerived = $derived<Task[]>(() => {
		const m = Math.max(0, Math.min(24, +months || 0));
		const kbgEnd = addMonths(egt, m);

		const arr: Task[] = [
			{ id: 1, text: 'Mutterschutz (vor Geburt)', start: egtMinus8, end: egt, type: 'task' },
			{ id: 2, text: 'Mutterschutz (nach Geburt)', start: egt, end: egtPlus8, type: 'task' },
			{ id: 3, text: 'Papamonat', start: egt, end: egtPlus8, type: 'task' }
		];

		// KBG Mutter – ruhend (erste 8 Wochen)
		const pausedStart = egt;
		const pausedEnd = addWeeks(egt, 8);
		if (pausedStart < kbgEnd) {
			arr.push({
				id: 4,
				text: 'KBG Mutter (ruhend, 8 Wo.)',
				start: pausedStart,
				end: pausedEnd < kbgEnd ? pausedEnd : kbgEnd,
				type: 'task',
				css: 'task-paused',
				color: '#cbd5e1'
			});
		}

		// KBG Mutter – laufend (Rest)
		const liveStart = pausedEnd;
		if (liveStart < kbgEnd) {
			arr.push({
				id: 5,
				text: `KBG Mutter (${m.toFixed(2)} Mon.)`,
				start: liveStart,
				end: kbgEnd,
				type: 'task',
				progress: 0
			});
		}

		return arr;
	});

	const linksDerived = $derived<any[]>(() => []); // keine Verknüpfungen in diesem Demo

	// Optional: Remount-Key nur falls Library Re-Init braucht
	const ganttKey = $derived(() =>
		tasksDerived.map((t) => `${t.id}:${t.start.getTime?.()}:${t.end.getTime?.()}`).join('|')
	);

	const scales = [
		{ unit: 'month', step: 1, format: 'MMMM yyy' },
		{ unit: 'day', step: 1, format: 'd' }
	];
</script>

<div class="controls">
	<label>
		EGT
		<input type="date" bind:value={birthDateStr} style="margin-left:8px" />
	</label>
	<label style="margin-left:16px">
		KBG-Dauer (Monate)
		<input
			type="number"
			min="0"
			max="24"
			step="0.5"
			bind:value={months}
			on:input={(e) =>
				(months = Math.min(
					24,
					Math.max(0, (e.currentTarget as HTMLInputElement).valueAsNumber || 0)
				))}
			style="margin-left:8px;width:100px"
		/>
	</label>
</div>

<div class="gantt-wrap">
	{#if browser}
		{#key ganttKey}
			<Willow fonts={false}>
				<Gantt tasks={tasksDerived} links={linksDerived} {scales} columns={[]} readonly={true} />
			</Willow>
		{/key}
	{:else}
		<div class="placeholder">Gantt rendert nur im Client…</div>
	{/if}
</div>

<div class="debug">
	<div>EGT: {egt.toISOString().slice(0, 10)}</div>
	<div>Tasks: {JSON.stringify(tasksDerived)}</div>
</div>

<style>
	.controls {
		margin: 8px 0;
		font-size: 14px;
		color: #0f172a;
		display: flex;
		align-items: center;
		gap: 12px 16px;
		flex-wrap: wrap;
	}
	.gantt-wrap {
		border: 1px solid #e5e7eb;
		border-radius: 12px;
		background: #fff;
		overflow: hidden;
		width: 100%;
		height: 360px;
	}
	.placeholder {
		padding: 8px 10px;
		font-size: 12px;
		color: #64748b;
	}
	.debug {
		margin-top: 8px;
		font-size: 12px;
		color: #64748b;
		word-break: break-word;
	}

	/* Schraffur für KBG „ruhend“.
     Falls wx-svelte-gantt Task-Klassen anders injiziert, Selektor anpassen. */
	:global(.task-paused) {
		background-image: repeating-linear-gradient(
			45deg,
			rgba(148, 163, 184, 0.35) 0,
			rgba(148, 163, 184, 0.35) 6px,
			rgba(203, 213, 225, 0.35) 6px,
			rgba(203, 213, 225, 0.35) 12px
		) !important;
		border-color: #94a3b8 !important;
	}
</style>
