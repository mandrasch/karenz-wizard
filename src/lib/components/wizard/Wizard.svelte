<script lang="ts">
  import { fly } from 'svelte/transition';
  import { cubicOut } from 'svelte/easing';
  import type {
    Wizard,
    WizardNode,
    Answer,
    ChoiceOption,
    HistoryEntry,
    ComputedKey
  } from './wizard-types';

  let { wizard }: { wizard: Wizard } = $props();

  // ── State ─────────────────────────────────────────────────────────────
  let currentId = $state(wizard.start);
  let history = $state<HistoryEntry[]>([]);
  let data = $state<Record<string, string>>({});
  let dateInput = $state('');

  // ── Derived ───────────────────────────────────────────────────────────
  const nodesById = $derived(
    Object.fromEntries(wizard.nodes.map((n) => [n.id, n])) as Record<string, WizardNode>
  );
  const currentNode = $derived(nodesById[currentId]);
  const stepNumber = $derived(history.length + 1);

  const computedValues = $derived.by(() => {
    const v: Record<ComputedKey, Date | undefined> = {
      mutterschutzStart: undefined,
      mutterschutzEnd: undefined
    };
    if (data.edd) {
      const edd = new Date(data.edd);
      v.mutterschutzStart = addDays(edd, -56);
      v.mutterschutzEnd = addDays(edd, 56);
    }
    return v;
  });

  const canGoBack = $derived(history.length > 0 && currentNode.kind !== 'result');
  const needsNextButton = $derived(
    currentNode.kind === 'info' || currentNode.kind === 'date'
  );
  const nextDisabled = $derived(currentNode.kind === 'date' && !dateInput);

  // Walk history for the printable summary — info nodes are skipped
  const summaryItems = $derived.by(() => {
    const labels: Record<Answer, string> = {
      yes: 'Ja',
      no: 'Nein',
      maybe: 'Vielleicht'
    };
    return history
      .map((entry) => {
        const node = nodesById[entry.nodeId];
        if (!node) return null;
        if (node.kind === 'question') {
          return { label: node.text, value: entry.answer ? labels[entry.answer] : '' };
        }
        if (node.kind === 'date') {
          return {
            label: node.text,
            value: entry.value ? formatDate(new Date(entry.value)) : ''
          };
        }
        if (node.kind === 'choice') {
          const opt = node.options.find((o) => o.value === entry.value);
          return { label: node.text, value: opt?.label ?? '' };
        }
        return null;
      })
      .filter((x): x is { label: string; value: string } => x !== null);
  });

  const summaryDates = $derived.by(() => {
    const items: Array<{ label: string; value: string }> = [];
    if (computedValues.mutterschutzStart) {
      items.push({
        label: 'Spätester Beginn Mutterschutz',
        value: formatDate(computedValues.mutterschutzStart)
      });
    }
    if (computedValues.mutterschutzEnd) {
      items.push({
        label: 'Voraussichtliches Ende Schutzfrist',
        value: formatDate(computedValues.mutterschutzEnd)
      });
    }
    return items;
  });

  // ── Effects ───────────────────────────────────────────────────────────
  $effect(() => {
    if (currentNode.kind === 'date') {
      dateInput = data[currentNode.storeAs] ?? '';
    }
  });

  // ── Helpers ───────────────────────────────────────────────────────────
  function addDays(d: Date, n: number): Date {
    const copy = new Date(d);
    copy.setDate(copy.getDate() + n);
    return copy;
  }

  function formatDate(d: Date | undefined | null): string {
    if (!d) return '—';
    return d.toLocaleDateString('de-AT', {
      day: '2-digit',
      month: 'long',
      year: 'numeric'
    });
  }

  // ── Actions ───────────────────────────────────────────────────────────
  function handleAnswer(a: Answer) {
    if (currentNode.kind !== 'question') return;
    history.push({ nodeId: currentId, answer: a });
    currentId = currentNode.next[a];
  }

  function handleChoice(opt: ChoiceOption) {
    if (currentNode.kind !== 'choice') return;
    history.push({ nodeId: currentId, value: opt.value });
    currentId = opt.next;
  }

  function handleNext() {
    if (currentNode.kind === 'info') {
      history.push({ nodeId: currentId });
      currentId = currentNode.next;
    } else if (currentNode.kind === 'date') {
      if (!dateInput) return;
      data[currentNode.storeAs] = dateInput;
      history.push({ nodeId: currentId, value: dateInput });
      currentId = currentNode.next;
    }
  }

  function goBack() {
    const prev = history.pop();
    if (prev) currentId = prev.nodeId;
  }

  function restart() {
    currentId = wizard.start;
    history = [];
    data = {};
  }

  function print() {
    window.print();
  }
</script>

<section class="wizard">
  <header class="masthead no-print">
    <span class="kicker">Mutterschutz → Karenz</span>
    <span class="step">Schritt {String(stepNumber).padStart(2, '0')}</span>
  </header>

  {#key currentId}
    <article class="card" in:fly={{ x: 20, duration: 280, easing: cubicOut }}>
      {#if currentNode.kind === 'question'}
        <h2>{currentNode.text}</h2>
        {#if currentNode.help}
          <p class="help">{currentNode.help}</p>
        {/if}
        <div class="answers">
          <button class="btn btn-yes" onclick={() => handleAnswer('yes')}>Ja</button>
          <button class="btn btn-maybe" onclick={() => handleAnswer('maybe')}>Vielleicht</button>
          <button class="btn btn-no" onclick={() => handleAnswer('no')}>Nein</button>
        </div>

      {:else if currentNode.kind === 'choice'}
        <h2>{currentNode.text}</h2>
        {#if currentNode.help}
          <p class="help">{currentNode.help}</p>
        {/if}
        <div class="answers">
          {#each currentNode.options as opt}
            <button class="btn btn-choice" onclick={() => handleChoice(opt)}>{opt.label}</button>
          {/each}
        </div>

      {:else if currentNode.kind === 'date'}
        <h2>{currentNode.text}</h2>
        {#if currentNode.help}
          <p class="help">{currentNode.help}</p>
        {/if}
        <label class="date-field">
          <span class="sr-only">Datum</span>
          <input type="date" bind:value={dateInput} />
        </label>

      {:else if currentNode.kind === 'info'}
        <h2>{currentNode.title}</h2>
        <p class="body">{currentNode.body}</p>

        {#if currentNode.computed && computedValues[currentNode.computed]}
          <aside class="computed">
            <div class="computed-label">
              {currentNode.computedLabel ?? 'Berechneter Wert'}
            </div>
            <div class="computed-value">
              {formatDate(computedValues[currentNode.computed])}
            </div>
          </aside>
        {/if}

        {#if currentNode.callout}
          <aside class="callout">
            <div class="callout-label">{currentNode.callout.label}</div>
            <div class="callout-body">{currentNode.callout.body}</div>
          </aside>
        {/if}

      {:else if currentNode.kind === 'result'}
        <h2>{currentNode.title}</h2>
        <p class="body">{currentNode.body}</p>

        {#if summaryDates.length > 0}
          <div class="summary">
            <h3>Wichtige Termine</h3>
            <dl>
              {#each summaryDates as item}
                <dt>{item.label}</dt>
                <dd>{item.value}</dd>
              {/each}
            </dl>
          </div>
        {/if}

        <div class="summary">
          <h3>Eure Angaben</h3>
          <dl>
            {#each summaryItems as item}
              <dt>{item.label}</dt>
              <dd>{item.value}</dd>
            {/each}
          </dl>
        </div>

        <div class="actions no-print">
          <button class="btn btn-primary" onclick={print}>Drucken / als PDF speichern</button>
          <button class="btn btn-ghost" onclick={restart}>Von vorn beginnen</button>
        </div>
      {/if}

      {#if currentNode.kind !== 'result' && currentNode.sources && currentNode.sources.length > 0}
        <footer class="sources no-print">
          <span class="sources-label">Quellen:</span>
          <ul>
            {#each currentNode.sources as s}
              <li><a href={s.url} target="_blank" rel="noopener noreferrer">{s.label} ↗</a></li>
            {/each}
          </ul>
        </footer>
      {/if}
    </article>

    {#if currentNode.kind !== 'result' && currentNode.video}
      <aside
        class="video-card no-print"
        in:fly={{ x: 20, duration: 280, delay: 80, easing: cubicOut }}
      >
        <span class="kicker">Mehr Infos</span>
        <h3>{currentNode.video.title}</h3>
        <div class="video-wrap">
          <iframe
            src="https://www.youtube-nocookie.com/embed/{currentNode.video.youtubeId}"
            title={currentNode.video.title}
            loading="lazy"
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
            allowfullscreen
          ></iframe>
        </div>
      </aside>
    {/if}
  {/key}

  {#if currentNode.kind !== 'result'}
    <nav class="nav no-print">
      {#if canGoBack}
        <button class="nav-link nav-back" onclick={goBack}>
          <span aria-hidden="true">←</span> Zurück
        </button>
      {:else}
        <span></span>
      {/if}
      {#if needsNextButton}
        <button class="nav-link nav-next" onclick={handleNext} disabled={nextDisabled}>
          Weiter <span aria-hidden="true">→</span>
        </button>
      {:else}
        <span></span>
      {/if}
    </nav>
  {/if}

  <aside class="elternkalender no-print">
    <div class="ek-text">
      <span class="kicker">Keine Frist verpassen</span>
      <p>Lasst euch vom AK Elternkalender rechtzeitig an alle wichtigen Termine erinnern.</p>
    </div>
    <a class="ek-cta" href="https://www.arbeiterkammer.at/" target="_blank" rel="noopener noreferrer">
      Zum AK Elternkalender <span aria-hidden="true">→</span>
    </a>
  </aside>
</section>

<style>
  @import url('https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,400;0,9..144,600;1,9..144,400&family=Figtree:wght@400;500;600&display=swap');

  :global(:root) {
    --cream: #f6f1e7;
    --cream-deep: #efe6d2;
    --ink: #1c2a24;
    --ink-soft: #4a5a51;
    --evergreen: #2f5444;
    --evergreen-deep: #1f3a2e;
    --peach: #f5d7b8;
    --peach-deep: #c67b5c;
    --line: #d9cfbb;
    --white: #fffdf8;
    --warn: #9b4a4a;
    --warn-bg: #f7ebe6;
  }

  /* Scoped to the wizard container — do NOT override global body
     (would break the rest of the site's Inter typography + white bg). */
  .wizard {
    max-width: 36rem;
    margin: 0 auto;
    padding: 1.25rem 1rem 3rem;
    font-family: 'Figtree', system-ui, sans-serif;
    color: var(--ink);
    background: var(--cream);
    border-radius: 1.25rem;
  }

  .masthead {
    display: flex;
    justify-content: space-between;
    align-items: baseline;
    margin-bottom: 1.25rem;
    padding: 0 0.25rem;
  }
  .kicker {
    font-family: 'Fraunces', serif;
    font-style: italic;
    font-size: 0.88rem;
    color: var(--ink-soft);
    letter-spacing: 0.02em;
  }
  .step {
    font-family: 'Fraunces', serif;
    font-size: 0.85rem;
    color: var(--ink-soft);
    letter-spacing: 0.08em;
    text-transform: uppercase;
  }

  .card {
    background: var(--white);
    border: 1px solid var(--line);
    border-radius: 1.25rem;
    padding: 1.75rem 1.5rem;
    box-shadow: 0 1px 0 rgba(31, 58, 46, 0.04), 0 12px 40px -20px rgba(31, 58, 46, 0.15);
  }

  h2 {
    font-family: 'Fraunces', serif;
    font-weight: 400;
    font-size: 1.6rem;
    line-height: 1.25;
    margin: 0 0 0.6rem 0;
    color: var(--ink);
    letter-spacing: -0.01em;
  }
  h2::first-letter { font-style: italic; }

  .help {
    color: var(--ink-soft);
    margin: 0 0 1.5rem 0;
    font-size: 0.97rem;
    line-height: 1.55;
  }
  .body {
    line-height: 1.65;
    margin: 0 0 1.25rem 0;
    font-size: 1rem;
  }

  .answers {
    display: grid;
    gap: 0.55rem;
    margin-top: 0.25rem;
  }

  .btn {
    font-family: inherit;
    font-size: 1.02rem;
    font-weight: 500;
    padding: 1rem 1.1rem;
    border: 1px solid var(--line);
    border-radius: 0.8rem;
    background: var(--white);
    color: var(--ink);
    cursor: pointer;
    text-align: left;
    min-height: 3.25rem;
    transition: background 0.18s, border-color 0.18s, transform 0.05s;
    display: flex;
    align-items: center;
  }
  .btn:hover { background: var(--cream-deep); border-color: var(--ink-soft); }
  .btn:active { transform: translateY(1px); }
  .btn:disabled { opacity: 0.45; cursor: not-allowed; }

  .btn-yes { border-left: 4px solid var(--evergreen); }
  .btn-yes:hover { background: #e8efe9; }
  .btn-maybe { border-left: 4px solid var(--peach-deep); }
  .btn-maybe:hover { background: #f7ecdf; }
  .btn-no { border-left: 4px solid var(--warn); }
  .btn-no:hover { background: var(--warn-bg); }

  .btn-choice {
    border-left: 4px solid var(--evergreen);
    justify-content: flex-start;
  }
  .btn-choice:hover { background: #e8efe9; }

  .btn-primary {
    background: var(--evergreen);
    color: var(--white);
    border-color: var(--evergreen);
    width: 100%;
    justify-content: center;
    margin-top: 0.5rem;
  }
  .btn-primary:hover {
    background: var(--evergreen-deep);
    border-color: var(--evergreen-deep);
  }
  .btn-ghost { background: transparent; justify-content: center; }

  .date-field input {
    font-family: inherit;
    width: 100%;
    padding: 0.95rem 1rem;
    font-size: 1.05rem;
    border: 1px solid var(--line);
    border-radius: 0.8rem;
    min-height: 3.25rem;
    background: var(--white);
    color: var(--ink);
  }
  .date-field input:focus {
    outline: 2px solid var(--evergreen);
    outline-offset: 1px;
    border-color: var(--evergreen);
  }

  .sr-only {
    position: absolute;
    width: 1px; height: 1px;
    padding: 0; margin: -1px;
    overflow: hidden; clip: rect(0,0,0,0);
    white-space: nowrap; border: 0;
  }

  .computed {
    background: var(--peach);
    border: 1px solid #e8c9a8;
    border-radius: 0.8rem;
    padding: 1rem 1.15rem;
    margin: 0 0 1rem 0;
  }
  .computed-label {
    font-family: 'Fraunces', serif;
    font-style: italic;
    font-size: 0.92rem;
    color: #7a4a2c;
    margin-bottom: 0.15rem;
  }
  .computed-value {
    font-family: 'Fraunces', serif;
    font-size: 1.45rem;
    font-weight: 600;
    color: var(--ink);
    letter-spacing: -0.01em;
  }

  .callout {
    background: var(--warn-bg);
    border-left: 3px solid var(--warn);
    border-radius: 0.5rem;
    padding: 0.85rem 1rem;
    margin: 0 0 0.5rem 0;
  }
  .callout-label {
    font-family: 'Fraunces', serif;
    font-style: italic;
    font-weight: 600;
    font-size: 0.95rem;
    color: var(--warn);
    margin-bottom: 0.25rem;
  }
  .callout-body {
    font-size: 0.93rem;
    line-height: 1.5;
    color: var(--ink);
  }

  .sources {
    margin-top: 1.5rem;
    padding-top: 1rem;
    border-top: 1px dashed var(--line);
    font-size: 0.85rem;
  }
  .sources-label {
    font-family: 'Fraunces', serif;
    font-style: italic;
    color: var(--ink-soft);
    margin-right: 0.4rem;
  }
  .sources ul { display: inline; list-style: none; padding: 0; margin: 0; }
  .sources li { display: inline; }
  .sources li:not(:last-child)::after {
    content: ' · ';
    color: var(--line);
  }
  .sources a { color: var(--evergreen); text-decoration: none; }
  .sources a:hover { text-decoration: underline; }

  /* ── Video card (always visible) ────────────────────────── */
  .video-card {
    margin-top: 1rem;
    background: var(--white);
    border: 1px solid var(--line);
    border-radius: 1.25rem;
    padding: 1.25rem 1.25rem 1rem;
    box-shadow: 0 1px 0 rgba(31, 58, 46, 0.04), 0 8px 30px -20px rgba(31, 58, 46, 0.15);
  }
  .video-card h3 {
    font-family: 'Fraunces', serif;
    font-weight: 400;
    font-size: 1.15rem;
    margin: 0.1rem 0 0.85rem 0;
    color: var(--ink);
  }
  .video-wrap {
    position: relative;
    padding-bottom: 56.25%;
    height: 0;
    overflow: hidden;
    background: #000;
    border-radius: 0.6rem;
  }
  .video-wrap iframe {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    border: 0;
  }

  /* ── Nav (Zurück / Weiter at same level) ─────────────────── */
  .nav {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 1.25rem;
    padding: 0 0.25rem;
    min-height: 2.75rem;
  }
  .nav-link {
    background: none;
    border: none;
    cursor: pointer;
    font-family: inherit;
    font-size: 1rem;
    padding: 0.6rem 0.25rem;
    display: inline-flex;
    align-items: center;
    gap: 0.4rem;
  }
  .nav-link:disabled { opacity: 0.35; cursor: not-allowed; }

  .nav-back { color: var(--ink-soft); }
  .nav-back:hover:not(:disabled) { color: var(--ink); }

  .nav-next {
    color: var(--evergreen);
    font-weight: 600;
    padding: 0.6rem 1rem;
    border-radius: 0.6rem;
    background: var(--white);
    border: 1px solid var(--evergreen);
  }
  .nav-next:hover:not(:disabled) {
    background: var(--evergreen);
    color: var(--white);
  }

  /* ── Summary & actions (result screen) ────────────────────── */
  .summary {
    margin-top: 1.5rem;
    border-top: 1px solid var(--line);
    padding-top: 1.25rem;
  }
  .summary:first-of-type { margin-top: 1rem; }
  .summary h3 {
    font-family: 'Fraunces', serif;
    font-weight: 400;
    font-style: italic;
    font-size: 1.15rem;
    margin: 0 0 0.85rem 0;
    color: var(--ink-soft);
  }
  dl { margin: 0; }
  dt {
    font-size: 0.88rem;
    color: var(--ink-soft);
    margin-top: 0.85rem;
    line-height: 1.4;
  }
  dd {
    margin: 0.2rem 0 0 0;
    font-weight: 500;
    font-size: 1.02rem;
  }
  .actions {
    margin-top: 1.75rem;
    display: grid;
    gap: 0.55rem;
  }

  /* ── Elternkalender footer (persistent) ──────────────────── */
  .elternkalender {
    margin-top: 1.75rem;
    background: var(--evergreen);
    color: var(--white);
    border-radius: 1.25rem;
    padding: 1.25rem 1.35rem;
    display: flex;
    align-items: center;
    gap: 1rem;
    flex-wrap: wrap;
    box-shadow: 0 1px 0 rgba(31, 58, 46, 0.04), 0 12px 40px -20px rgba(31, 58, 46, 0.25);
  }
  .ek-text { flex: 1 1 15rem; }
  .ek-text .kicker {
    color: var(--peach);
    display: block;
    font-size: 0.9rem;
    font-style: italic;
    margin-bottom: 0.2rem;
  }
  .ek-text p {
    margin: 0;
    font-size: 0.95rem;
    line-height: 1.45;
    color: #e6ded0;
  }
  .ek-cta {
    display: inline-flex;
    align-items: center;
    gap: 0.3rem;
    padding: 0.7rem 1.1rem;
    background: var(--peach);
    color: var(--ink);
    border-radius: 0.6rem;
    text-decoration: none;
    font-weight: 600;
    font-size: 0.95rem;
    white-space: nowrap;
    transition: background 0.18s, transform 0.05s;
  }
  .ek-cta:hover { background: #f1c898; }
  .ek-cta:active { transform: translateY(1px); }

  /* ── Print ──────────────────────────────────────────────── */
  @media print {
    :global(body) { background: white; }
    .no-print { display: none !important; }
    .card { box-shadow: none; border: none; padding: 0; }
    h2 { page-break-after: avoid; }
    dt { page-break-after: avoid; }
  }
</style>
