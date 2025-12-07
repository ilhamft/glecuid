import { test, expect } from '@playwright/test';

test('has generated cuid2', async ({ page }) => {
  await page.goto('/');
  const element = page.locator('#app');
  const text = await element.innerText();
  expect(text).toHaveLength(24);
});
