// e2e_test.ts
import puppeteer from "npm:puppeteer@latest";
import { assert } from "https://deno.land/std@0.220.0/testing/asserts.ts";

const APP_URL = "http://localhost:8000";

Deno.test("Home page loads and has title", async () => {
  // 1. Fresh サーバーをバックグラウンドで起動
  const cmd = new Deno.Command(Deno.execPath(), {
    args: ["task", "start"],
    stdout: "null",
    stderr: "piped",
  });
  const child = cmd.spawn(); // プロセス生成
  // サーバー起動完了まで少し待機（適宜調整）
  await new Promise((r) => setTimeout(r, 2000));

  // 2. Puppeteer でブラウザ起動
  const browser = await puppeteer.launch();
  const page = await browser.newPage();

  // 3. ページ遷移 & タイトル検証
  await page.goto(APP_URL, { waitUntil: "networkidle2" });
  const title = await page.title();
  assert(title.includes("stockanize"));

  // 4. 後片付け
  await browser.close();
  // サブプロセスを終了
  child.kill("SIGTERM");
  await child.status;
});
