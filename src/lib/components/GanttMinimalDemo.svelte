<script lang="ts">
  import { Gantt, Willow } from 'wx-svelte-gantt';
  import { browser } from '$app/environment';

  const tasks = [
    {
      id: 20,
      text: 'New Task',
      start: new Date(2024, 5, 11),
      end: new Date(2024, 6, 12),
      duration: 1,
      progress: 2,
      type: 'task',
      lazy: false
    },
    {
      id: 47,
      text: '[1] Master project',
      start: new Date(2024, 5, 12),
      end: new Date(2024, 7, 12),
      duration: 8,
      progress: 0,
      parent: 0,
      type: 'summary'
    },
    {
      id: 22,
      text: 'Task',
      start: new Date(2024, 7, 11),
      end: new Date(2024, 8, 12),
      duration: 8,
      progress: 0,
      parent: 47,
      type: 'task'
    },
    {
      id: 21,
      text: 'New Task 2',
      start: new Date(2024, 7, 10),
      end: new Date(2024, 8, 12),
      duration: 3,
      progress: 0,
      type: 'task',
      lazy: false
    }
  ];

  const links = [{ id: 1, source: 20, target: 21, type: 'e2e' }];

  const scales = [
    { unit: 'month', step: 1, format: 'MMMM yyy' },
    { unit: 'day', step: 1, format: 'd' }
  ];
</script>

<div class="demo">
  {#if browser}
    <Willow fonts={false}>
      <Gantt {tasks} {links} {scales} columns={[]} readonly={true} />
    </Willow>
  {:else}
    <div class="placeholder">Gantt renders on client only…</div>
  {/if}
  
</div>

<style>
  .demo {
    border: 1px solid #e5e7eb;
    border-radius: 12px;
    background: #fff;
    height: 360px;
    overflow: hidden;
  }
  .placeholder {
    padding: 8px 10px;
    font-size: 12px;
    color: #64748b;
  }
</style>
