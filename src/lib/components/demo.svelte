<script lang="ts">
  // Svelte 5 runes demo: single “Mutter” task starting 2025-01-01,
  // controlled by a months input. Shows a simple pseudo-Gantt and debug.

  // State
  let months = $state(12);

  // Helpers
  function addMonths(d: Date, m: number) {
    const whole = Math.floor(m);
    const frac = m - whole;
    const x = new Date(d);
    x.setMonth(x.getMonth() + whole);
    if (frac) x.setDate(x.getDate() + Math.round(frac * 30.4375));
    return x;
  }

  const fixedStart = new Date(2025, 0, 1); // 2025-01-01
  let tasks = $state<any[]>([]);

  // Build the single task from the input state
  $effect(() => {
    const s = fixedStart;
    const e = addMonths(s, +months || 0);
    tasks = [
      {
        id: 1,
        text: `Mutter (${(+months).toFixed(2)} M)`,
        start: s,
        end: e,
        duration: +months || 0,
        progress: 0,
        type: 'task'
      }
    ];
  });

  // Optional: force remount consumers when the time window changes
  const ganttKey = $derived(() =>
    tasks.map(t => `${t.id}:${t.start?.getTime?.()}:${t.end?.getTime?.()}`).join('|')
  );

  // Pseudo-Gantt rendering params
  const monthsTotal = 24;
  const pxPerMonth = 40; // visual scale
  const timelineStart = fixedStart;
  const timelineEnd = $derived(() => addMonths(timelineStart, monthsTotal));
  const widthPx = monthsTotal * pxPerMonth;

  // For axis ticks
  const monthsAxis = Array.from({ length: monthsTotal + 1 }, (_, i) => i);

  function leftPx(d: Date) {
    const ms = d.getTime() - timelineStart.getTime();
    const days = ms / 86400000;
    const monthsApprox = days / 30.4375;
    return Math.max(0, Math.min(widthPx, monthsApprox * pxPerMonth));
  }
  function widthFor(a: Date, b: Date) {
    return Math.max(0, leftPx(b) - leftPx(a));
  }
</script>

<div class="controls">
  <label>
    Mutter: Dauer in Monaten
    <input
      type="number"
      min="0"
      max="24"
      step="0.5"
      value={months}
      oninput={(e) => (months = Math.min(24, Math.max(0, (e.currentTarget as HTMLInputElement).valueAsNumber || 0)))}
    />
  </label>
  <span class="hint">Start: 2025-01-01</span>
  <span class="hint">Gesamtfenster: 24 Monate</span>
  <span class="hint">Skala: ~40px/Monat</span>
  
</div>

<!-- Keyed remount container (if a child needs re-init on window change) -->
{#key ganttKey}
  <div class="gantt-wrap" style:width={`${widthPx + 80}px`}>
    <!-- Axis -->
    <div class="axis">
      {#each monthsAxis as m}
        <div class="tick" style:left={`${m * pxPerMonth}px`}>
          {#if m % 6 === 0}
            <span>{m} M</span>
          {/if}
        </div>
      {/each}
    </div>

    <!-- Track -->
    <div class="track" style:width={`${widthPx}px`}>
      {#each tasks as t (t.id)}
        <div
          class="bar"
          style:left={`${leftPx(t.start)}px`}
          style:width={`${widthFor(t.start, t.end)}px`}
          title={`${t.text}`}
        >
          <div class="bar-content">{t.text}</div>
        </div>
      {/each}
    </div>
  </div>
{/key}

<div class="debug">
  <div>tasks: {JSON.stringify(tasks)}</div>
  {#each tasks as t}
    <div>
      id={t.id} text={t.text}
      start={t.start?.toISOString?.()} end={t.end?.toISOString?.()}
      duration={t.duration}
    </div>
  {/each}
  <div>fixedStart: {fixedStart.toISOString()}</div>
  <div>months: {months}</div>
  <div>window: {timelineStart.toISOString()} → {timelineEnd().toISOString()}</div>
  <div>pxPerMonth: {pxPerMonth}</div>
</div>

<style>
  .controls {
    margin: 8px 0;
    font-size: 14px;
    color: #0f172a;
    display: flex;
    align-items: center;
    gap: 12px;
    flex-wrap: wrap;
  }
  .controls input {
    margin-left: 8px;
    width: 100px;
  }
  .hint { font-size: 12px; color: #64748b; }

  .gantt-wrap {
    border: 1px solid #e5e7eb;
    border-radius: 12px;
    background: #fff;
    overflow-x: auto;
    overflow-y: hidden;
    height: 220px;
    padding: 8px;
    position: relative;
  }
  .axis {
    position: relative;
    height: 36px;
    border-bottom: 1px solid #e5e7eb;
  }
  .tick {
    position: absolute;
    top: 0;
    bottom: 0;
    width: 0;
    border-left: 1px solid #eef0f2;
  }
  .tick > span {
    position: absolute;
    top: 2px;
    transform: translateX(-50%);
    font-size: 12px;
    color: #6b7280;
    background: #fff;
    padding: 0 4px;
  }
  .track {
    position: relative;
    height: 140px;
    border-left: 1px solid #eef0f2;
    border-right: 1px solid #eef0f2;
    background-image: repeating-linear-gradient(
      to right,
      #f3f4f6 0,
      #f3f4f6 1px,
      transparent 1px,
      transparent 39px
    );
  }
  .bar {
    position: absolute;
    top: 18px;
    height: 32px;
    background: #7dd3fc;
    border: 1px solid #38bdf8;
    border-radius: 8px;
    box-shadow: 0 2px 6px rgba(0,0,0,0.06);
    overflow: hidden;
  }
  .bar-content {
    padding: 6px 8px;
    font-size: 12px;
    color: #0f172a;
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
  }

  .debug {
    margin-top: 10px;
    font-size: 12px;
    color: #64748b;
  }
</style>
