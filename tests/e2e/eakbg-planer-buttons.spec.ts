import { test, expect, type Locator } from '@playwright/test';

// Smoke test: every visible, enabled button inside the EaKbgPlaner Svelte
// island can be clicked without producing an uncaught JS exception. Buttons
// outside the island (nav, footer, breadcrumbs) are intentionally excluded.

test('EaKbgPlaner: clicking every island button raises no JS errors', async ({ page }) => {
	const errors: string[] = [];
	page.on('pageerror', (e) => errors.push(`pageerror: ${e.message}`));

	await page.goto('/eakbg-planer/');

	const island = page.getByTestId('eakbg-planer');
	await expect(island).toBeVisible();

	// Snapshot the initial set of buttons. We intentionally do not re-query
	// after each click: clicking may add/remove buttons (e.g. opening a
	// dialog), and stale handles correctly skip via isVisible/isEnabled.
	const buttons = await island.getByRole('button').all();
	expect(buttons.length, 'expected at least one button inside the island').toBeGreaterThan(0);

	let clicked = 0;
	let skipped = 0;
	for (const btn of buttons) {
		if (!(await safeIsActionable(btn))) {
			skipped++;
			continue;
		}
		const label = (await btn.textContent())?.trim().slice(0, 60) ?? '<no text>';
		await btn.click({ timeout: 2000 }).catch((err) => {
			errors.push(`click failed for "${label}": ${err.message}`);
		});
		clicked++;
	}

	console.log(`island buttons: clicked=${clicked} skipped=${skipped}`);
	expect(errors, errors.join('\n') || 'no errors').toEqual([]);
});

async function safeIsActionable(btn: Locator): Promise<boolean> {
	try {
		return (await btn.isVisible()) && (await btn.isEnabled());
	} catch {
		return false;
	}
}
